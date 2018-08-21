Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:35516 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbeHUUjV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 16:39:21 -0400
Message-ID: <1534871894.25523.34.camel@sipsolutions.net> (sfid-20180821_191901_973187_C5DA740F)
Subject: Re: [PATCH 1/2] workqueue: skip lockdep wq dependency in
 cancel_work_sync()
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Tue, 21 Aug 2018 19:18:14 +0200
In-Reply-To: <20180821160814.GP3978217@devbig004.ftw2.facebook.com> (sfid-20180821_180819_283179_8D636508)
References: <20180821120317.4115-1-johannes@sipsolutions.net>
         <20180821120317.4115-2-johannes@sipsolutions.net>
         <20180821160814.GP3978217@devbig004.ftw2.facebook.com>
         (sfid-20180821_180819_283179_8D636508)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-21 at 09:08 -0700, Tejun Heo wrote:
> 
> > -static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr)
> > +static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
> > +			     bool from_cancel)
> >  {
> >  	struct worker *worker = NULL;
> >  	struct worker_pool *pool;
> > @@ -2885,7 +2886,8 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr)
> >  	 * workqueues the deadlock happens when the rescuer stalls, blocking
> >  	 * forward progress.
> >  	 */
> > -	if (pwq->wq->saved_max_active == 1 || pwq->wq->rescuer) {
> > +	if (!from_cancel &&
> > +	    (pwq->wq->saved_max_active == 1 || pwq->wq->rescuer)) {
> >  		lock_map_acquire(&pwq->wq->lockdep_map);
> >  		lock_map_release(&pwq->wq->lockdep_map);
> >  	}
> 
> But this can lead to a deadlock.  I'd much rather err on the side of
> discouraging complex lock dancing around ordered workqueues, no?

What can lead to a deadlock?

Writing out the example again, with the unlock now:

   work1_function() { mutex_lock(&mutex); mutex_unlock(&mutex); }
   work2_function() { /* nothing */ }
 
   other_function() {
     queue_work(ordered_wq, &work1);
     queue_work(ordered_wq, &work2);
     mutex_lock(&mutex);
     cancel_work_sync(&work2);
     mutex_unlock(&mutex);
   }

This shouldn't be able to lead to a deadlock like I had explained:

> In cancel_work_sync(), we can only have one of two cases, even
> with an ordered workqueue:
>  * the work isn't running, just cancelled before it started
>  * the work is running, but then nothing else can be on the
>    workqueue before it

johannes
