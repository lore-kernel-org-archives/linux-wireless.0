Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lgeamrelo11.lge.com ([156.147.23.51]:35318 "EHLO
        lgeamrelo11.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727877AbeHVLOQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Aug 2018 07:14:16 -0400
Date: Wed, 22 Aug 2018 16:50:10 +0900
From: Byungchul Park <byungchul.park@lge.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        kernel-team@lge.com
Subject: Re: [PATCH 1/2] workqueue: skip lockdep wq dependency in
 cancel_work_sync()
Message-ID: <20180822075010.GA29722@X58A-UD3R> (sfid-20180822_095035_235357_A512F036)
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534921643.25523.56.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 22, 2018 at 09:07:23AM +0200, Johannes Berg wrote:
> On Wed, 2018-08-22 at 14:47 +0900, Byungchul Park wrote:
> > On Wed, Aug 22, 2018 at 06:02:23AM +0200, Johannes Berg wrote:
> > > On Wed, 2018-08-22 at 11:45 +0900, Byungchul Park wrote:
> > > 
> > > > That should've been adjusted as well when Ingo reverted Cross-release.
> > > 
> > > I can't really say.
> > 
> > What do you mean?
> 
> I haven't followed any of this, so I just don't know.
> 
> > > > It would be much easier to add each pair, acquire/release, before
> > > > wait_for_completion() in both flush_workqueue() and flush_work() than
> > > > reverting the whole commit.
> > > 
> > > The commit doesn't do much more than this though.
> > 
> > That also has named of lockdep_map for wq/work in a better way.
> 
> What do you mean?

Ah.. Not important thing. I just mentioned I changed lock names a bit
when initializing lockdep_map instances which was suggested by Ingo. But
no problem even if you revert the whole thing. I just informed it. ;)

> > > > What's lacking is only lockdep annotations for wait_for_completion().
> > > 
> > > No, I disagree. Like I said before, we need the lockdep annotations on
> > 
> > You seem to be confused. I was talking about wait_for_completion() in
> > both flush_workqueue() and flush_work(). Without
> > the wait_for_completion()s, nothing matters wrt what you are concerning.
> 
> Yes and no.
> 
> You're basically saying if we don't get to do a wait_for_completion(),
> then we don't need any lockdep annotation. I'm saying this isn't true.

Strictly no. But I'm just talking about the case in wq flush code.

> Consider the following case:
> 
> work_function()
> {
> 	mutex_lock(&mutex);
> 	mutex_unlock(&mutex);
> }
> 
> other_function()
> {
> 	queue_work(&my_wq, &work);
> 
> 	if (common_case) {
> 		schedule_and_wait_for_something_that_takes_a_long_time()
> 	}
> 
> 	mutex_lock(&mutex);
> 	flush_workqueue(&my_wq);
> 	mutex_unlock(&mutex);
> }
> 
> 
> Clearly this code is broken, right?
> 
> However, you'll almost never get lockdep to indicate that, because of
> the "if (common_case)".

Sorry I don't catch you. Why is that problem with the example? Please
a deadlock example.

> My argument basically is that the lockdep annotations in the workqueue
> code should be entirely independent of the actual need to call
> wait_for_completion().

No. Lockdep annotations always do with either wait_for_something or self
event loop within a single context e.g. fs -> memory reclaim -> fs -> ..

> Therefore, the commit should be reverted regardless of any cross-release

No. That is necessary only when the wait_for_completion() cannot be
tracked in checking dependencies automatically by cross-release.

It might be the key to understand you, could you explain it more why you
think lockdep annotations are independent of the actual need to call
wait_for_completion()(or wait_for_something_else) hopefully with a
deadlock example?

> work (that I neither know and thus don't understand right now), since it
> makes workqueue code rely on lockdep for the completion, whereas we

Using wait_for_completion(), right?

> really want to have annotations here even when we didn't actually need
> to wait_for_completion().

Please an example of deadlock even w/o wait_for_completion().

> 
> johannes

Byungchul
