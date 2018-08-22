Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lgeamrelo13.lge.com ([156.147.23.53]:60126 "EHLO
        lgeamrelo11.lge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727992AbeHVMkP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Aug 2018 08:40:15 -0400
Date: Wed, 22 Aug 2018 18:15:47 +0900
From: Byungchul Park <byungchul.park@lge.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        kernel-team@lge.com
Subject: Re: [PATCH 1/2] workqueue: skip lockdep wq dependency in
 cancel_work_sync()
Message-ID: <20180822091547.GB29722@X58A-UD3R> (sfid-20180822_111626_169492_97FDB9F3)
References: <20180821172711.GR3978217@devbig004.ftw2.facebook.com>
 <1534872621.25523.39.camel@sipsolutions.net>
 <20180821175550.GS3978217@devbig004.ftw2.facebook.com>
 <1534879241.25523.44.camel@sipsolutions.net>
 <20180822024535.GA2414@X58A-UD3R>
 <1534910543.25523.50.camel@sipsolutions.net>
 <20180822054731.GB2414@X58A-UD3R>
 <1534921643.25523.56.camel@sipsolutions.net>
 <20180822075010.GA29722@X58A-UD3R>
 <1534924940.25523.70.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534924940.25523.70.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 22, 2018 at 10:02:20AM +0200, Johannes Berg wrote:
> > Sorry I don't catch you. Why is that problem with the example? Please
> > a deadlock example.
> 
> sure, I thought that was easy:
> 
> thread 1			thread 2 (wq thread)
> 
> common_case = false;
> queue_work(&my_wq, &work);
> mutex_lock(&mutex);
> 
> flush_workqueue(&my_wq);
> 				work_function()
> 				-> mutex_lock(&mutex);
> 				-> schedule(), wait for mutex
> wait_for_completion()
> 
> -> deadlock - we can't make any forward progress here.

I see. Now, I understand what you are talking about.

   if (common_case)
	schedule_and_wait_for_something_that_takes_a_long_time()

should be:

   if (common_case)
	schedule_and_wait_long_time_so_that_the_work_to_finish()

> > > My argument basically is that the lockdep annotations in the workqueue
> > > code should be entirely independent of the actual need to call
> > > wait_for_completion().
> > 
> > No. Lockdep annotations always do with either wait_for_something or self
> > event loop within a single context e.g. fs -> memory reclaim -> fs -> ..
> 
> Yes, but I'm saying that we should catch *potential* deadlocks *before*
> they happen.

Absolutely true about what lockdep does.

> See the example above. Clearly, you're actually deadlocking, and
> obviously (assuming all the wait_for_completion() things work right)
> lockdep will show why we just deadlocked.
> 
> BUT.
> 
> This is useless. We want/need lockdep to show *potential* deadlocks,
> even when they didn't happen. Consider the other case in the above
> scenario:
> 
> thread 1			thread 2 (wq thread)
> 
> common_case = true;
> queue_work(&my_wq, &work);
> 
> schedule_and_wait_...();	work_function()
> 				-> mutex_lock(&mutex);
> 				-> mutex_unlock()
> 				done
> 
> 
> mutex_lock(&mutex);
> flush_workqueue(&my_wq);
> -> nothing to do, will NOT
>    call wait_for_completion();
> 
> -> no deadlock

Sure. It's not a deadlock because wait_for_completion() is not involved
in this path - where wait_for_completion() is necessary to deadlock.

Ok. I didn't know what you are talking about but now I got it.

You are talking about who knows whether common_case is true or not,
so we must aggresively consider the case the wait_for_completion()
so far hasn't been called but may be called in the future.

I think it's a problem of how aggressively we need to check dependencies.
If we choose the aggressive option, then we could get reported
aggressively but could not avoid aggresive false positives either.
I don't want to strongly argue that because it's a problem of policy.

Just, I would consider only waits that actually happened anyway. Of
course, we gotta consider the waits definitely even if any actual
deadlock doesn't happen since detecting potantial problem is more
important than doing on actual ones as you said.

So no big objection to check dependencies aggressively.

> Here we don't have a deadlock, but without the revert we will also not

You misunderstand me. The commit should be reverted or acquire/release
pairs should be added in both flush functions.

> get a lockdep report. We should though, because we're doing something
> that's quite clearly dangerous - we simply don't know if the work
> function will complete before we get to flush_workqueue(). Maybe the
> work function has an uncommon case itself that takes forever, etc.
> 
> > > Therefore, the commit should be reverted regardless of any cross-release
> > 
> > No. That is necessary only when the wait_for_completion() cannot be
> > tracked in checking dependencies automatically by cross-release.
> 
> No. See above. We want the annotation regardless of invoking
> wait_for_completion().

Anyway the annotation should be placed in the path where
wait_for_completion() might be called. But whether doing it
regardless of invoking wait_for_completion() or not is a problem of
policy so I don't care. No big objection whichever you do.

> > It might be the key to understand you, could you explain it more why you
> > think lockdep annotations are independent of the actual need to call
> > wait_for_completion()(or wait_for_something_else) hopefully with a
> > deadlock example?
> 
> See above.
> 
> You're getting too hung up about a deadlock example. We don't want to

No no. Your example was helpful to understand what you are talking about.
I asked you for a potential deadlock example.

> have lockdep only catch *actual* deadlocks. The code I wrote clearly has
> a potential deadlock (sequence given above), but in most cases the code
> above will *not* deadlock. This is the interesting part we want lockdep
> to catch.

Absolutly true. You can find my opinion about that in
Documentation/locking/crossrelease.txt which has been removed because
crossrelease is strong at detecting *potential* deadlock problems.

> > > work (that I neither know and thus don't understand right now), since it
> > > makes workqueue code rely on lockdep for the completion, whereas we
> > 
> > Using wait_for_completion(), right?
> 
> Yes.
> 
> > > really want to have annotations here even when we didn't actually need
> > > to wait_for_completion().
> > 
> > Please an example of deadlock even w/o wait_for_completion().
> 
> No, here's where you get confused. Clearly, there is no lockdep if we
> don't do wait_for_completion(). But if you have the code above, lockdep
> should still warn about the potential deadlock that happens when you
> *do* get to wait_for_completion(). Lockdep shouldn't be restricted to
> warning about a deadlock that *actually* happened.

I didn't know if you were talking about this in the previous talk.

Byungchul
