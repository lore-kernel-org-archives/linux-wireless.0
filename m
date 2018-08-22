Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:50318 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727797AbeHVL0P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Aug 2018 07:26:15 -0400
Message-ID: <1534924940.25523.70.camel@sipsolutions.net> (sfid-20180822_100239_036766_26EE5398)
Subject: Re: [PATCH 1/2] workqueue: skip lockdep wq dependency in
 cancel_work_sync()
From: Johannes Berg <johannes@sipsolutions.net>
To: Byungchul Park <byungchul.park@lge.com>
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        kernel-team@lge.com
Date: Wed, 22 Aug 2018 10:02:20 +0200
In-Reply-To: <20180822075010.GA29722@X58A-UD3R>
References: <20180821160814.GP3978217@devbig004.ftw2.facebook.com>
         <1534871894.25523.34.camel@sipsolutions.net>
         <20180821172711.GR3978217@devbig004.ftw2.facebook.com>
         <1534872621.25523.39.camel@sipsolutions.net>
         <20180821175550.GS3978217@devbig004.ftw2.facebook.com>
         <1534879241.25523.44.camel@sipsolutions.net>
         <20180822024535.GA2414@X58A-UD3R>
         <1534910543.25523.50.camel@sipsolutions.net>
         <20180822054731.GB2414@X58A-UD3R>
         <1534921643.25523.56.camel@sipsolutions.net>
         <20180822075010.GA29722@X58A-UD3R>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-08-22 at 16:50 +0900, Byungchul Park wrote:

> > You're basically saying if we don't get to do a wait_for_completion(),
> > then we don't need any lockdep annotation. I'm saying this isn't true.
> 
> Strictly no. But I'm just talking about the case in wq flush code.

Sure, I meant it's not true in the wq flush code, not talking about
anything else.

> > Consider the following case:
> > 
> > work_function()
> > {
> > 	mutex_lock(&mutex);
> > 	mutex_unlock(&mutex);
> > }
> > 
> > other_function()
> > {
> > 	queue_work(&my_wq, &work);
> > 
> > 	if (common_case) {
> > 		schedule_and_wait_for_something_that_takes_a_long_time()
> > 	}
> > 
> > 	mutex_lock(&mutex);
> > 	flush_workqueue(&my_wq);
> > 	mutex_unlock(&mutex);
> > }
> > 
> > 
> > Clearly this code is broken, right?
> > 
> > However, you'll almost never get lockdep to indicate that, because of
> > the "if (common_case)".
> 
> Sorry I don't catch you. Why is that problem with the example? Please
> a deadlock example.

sure, I thought that was easy:

thread 1			thread 2 (wq thread)

common_case = false;
queue_work(&my_wq, &work);
mutex_lock(&mutex);

flush_workqueue(&my_wq);
				work_function()
				-> mutex_lock(&mutex);
				-> schedule(), wait for mutex
wait_for_completion()

-> deadlock - we can't make any forward progress here.


> > My argument basically is that the lockdep annotations in the workqueue
> > code should be entirely independent of the actual need to call
> > wait_for_completion().
> 
> No. Lockdep annotations always do with either wait_for_something or self
> event loop within a single context e.g. fs -> memory reclaim -> fs -> ..

Yes, but I'm saying that we should catch *potential* deadlocks *before*
they happen.

See the example above. Clearly, you're actually deadlocking, and
obviously (assuming all the wait_for_completion() things work right)
lockdep will show why we just deadlocked.

BUT.

This is useless. We want/need lockdep to show *potential* deadlocks,
even when they didn't happen. Consider the other case in the above
scenario:

thread 1			thread 2 (wq thread)

common_case = true;
queue_work(&my_wq, &work);

schedule_and_wait_...();	work_function()
				-> mutex_lock(&mutex);
				-> mutex_unlock()
				done


mutex_lock(&mutex);
flush_workqueue(&my_wq);
-> nothing to do, will NOT
   call wait_for_completion();

-> no deadlock

Here we don't have a deadlock, but without the revert we will also not
get a lockdep report. We should though, because we're doing something
that's quite clearly dangerous - we simply don't know if the work
function will complete before we get to flush_workqueue(). Maybe the
work function has an uncommon case itself that takes forever, etc.

> > Therefore, the commit should be reverted regardless of any cross-release
> 
> No. That is necessary only when the wait_for_completion() cannot be
> tracked in checking dependencies automatically by cross-release.

No. See above. We want the annotation regardless of invoking
wait_for_completion().

> It might be the key to understand you, could you explain it more why you
> think lockdep annotations are independent of the actual need to call
> wait_for_completion()(or wait_for_something_else) hopefully with a
> deadlock example?

See above.

You're getting too hung up about a deadlock example. We don't want to
have lockdep only catch *actual* deadlocks. The code I wrote clearly has
a potential deadlock (sequence given above), but in most cases the code
above will *not* deadlock. This is the interesting part we want lockdep
to catch.

> > work (that I neither know and thus don't understand right now), since it
> > makes workqueue code rely on lockdep for the completion, whereas we
> 
> Using wait_for_completion(), right?

Yes.

> > really want to have annotations here even when we didn't actually need
> > to wait_for_completion().
> 
> Please an example of deadlock even w/o wait_for_completion().

No, here's where you get confused. Clearly, there is no lockdep if we
don't do wait_for_completion(). But if you have the code above, lockdep
should still warn about the potential deadlock that happens when you
*do* get to wait_for_completion(). Lockdep shouldn't be restricted to
warning about a deadlock that *actually* happened.

johannes
