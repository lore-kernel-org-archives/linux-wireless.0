Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:53664 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728315AbeHVNHA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Aug 2018 09:07:00 -0400
Message-ID: <1534930963.25523.87.camel@sipsolutions.net> (sfid-20180822_114303_382512_2C9D3984)
Subject: Re: [PATCH 1/2] workqueue: skip lockdep wq dependency in
 cancel_work_sync()
From: Johannes Berg <johannes@sipsolutions.net>
To: Byungchul Park <byungchul.park@lge.com>
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        kernel-team@lge.com
Date: Wed, 22 Aug 2018 11:42:43 +0200
In-Reply-To: <20180822091547.GB29722@X58A-UD3R>
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
         <20180822091547.GB29722@X58A-UD3R>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-08-22 at 18:15 +0900, Byungchul Park wrote:
> 
> > thread 1			thread 2 (wq thread)
> > 
> > common_case = false;
> > queue_work(&my_wq, &work);
> > mutex_lock(&mutex);
> > 
> > flush_workqueue(&my_wq);
> > 				work_function()
> > 				-> mutex_lock(&mutex);
> > 				-> schedule(), wait for mutex
> > wait_for_completion()
> > 
> > -> deadlock - we can't make any forward progress here.
> 
> I see. Now, I understand what you are talking about.
> 
>    if (common_case)
> 	schedule_and_wait_for_something_that_takes_a_long_time()
> 
> should be:
> 
>    if (common_case)
> 	schedule_and_wait_long_time_so_that_the_work_to_finish()

Fair point.

> Ok. I didn't know what you are talking about but now I got it.

great.

> You are talking about who knows whether common_case is true or not,
> so we must aggresively consider the case the wait_for_completion()
> so far hasn't been called but may be called in the future.

Yes.

> I think it's a problem of how aggressively we need to check dependencies.
> If we choose the aggressive option, then we could get reported
> aggressively but could not avoid aggresive false positives either.
> I don't want to strongly argue that because it's a problem of policy.

I don't think you could consider a report from "aggressive reporting" to
 be a false positive. It's clearly possible that this happens, and once
you go to a workqueue you basically don't really know your sequencing
and timing any more.

> Just, I would consider only waits that actually happened anyway. Of
> course, we gotta consider the waits definitely even if any actual
> deadlock doesn't happen since detecting potantial problem is more
> important than doing on actual ones as you said.
> 
> So no big objection to check dependencies aggressively.
> 
> > Here we don't have a deadlock, but without the revert we will also not
> 
> You misunderstand me. The commit should be reverted or acquire/release
> pairs should be added in both flush functions.

Ok, I thought you were arguing we shouldn't revert it :)

I don't know whether to revert or just add the pairs in the flush
functions, because I can't say I understand what the third part of the
patch does.

> Anyway the annotation should be placed in the path where
> wait_for_completion() might be called.

Yes, it should be called regardless of whether we actually wait or not,
i.e. before most of the checking in the functions.

My issue #3 that I outlined is related - we'd like to have lockdep
understand that if this work was on the WQ it might deadlock, but we
don't have a way to get the WQ unless the work is scheduled - and in the
case that it is scheduled we might already hitting the deadlock
(depending on the order of execution though I guess).

> Absolutly true. You can find my opinion about that in
> Documentation/locking/crossrelease.txt which has been removed because
> crossrelease is strong at detecting *potential* deadlock problems.

Ok, you know what, I'm going to read this now ... hang on........

I see. You were trying to solve the problem of completions/context
transfers in lockdep.

Given the revert of crossrelease though, we can't actually revert your
patch anyway, and looking at it again I see what you mean by the "name"
now ...

So yeah, we should only re-add the two acquire/release pairs. I guess
I'll make a patch for that, replacing my patch 2.

I'm intrigued by the crossrelease - but that's a separate topic.

johannes
