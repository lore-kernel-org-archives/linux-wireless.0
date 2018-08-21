Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:43478 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbeHUT3C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 15:29:02 -0400
Date: Tue, 21 Aug 2018 09:08:14 -0700
From: Tejun Heo <tj@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 1/2] workqueue: skip lockdep wq dependency in
 cancel_work_sync()
Message-ID: <20180821160814.GP3978217@devbig004.ftw2.facebook.com> (sfid-20180821_180834_163170_91E8D8CB)
References: <20180821120317.4115-1-johannes@sipsolutions.net>
 <20180821120317.4115-2-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180821120317.4115-2-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 21, 2018 at 02:03:16PM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In cancel_work_sync(), we can only have one of two cases, even
> with an ordered workqueue:
>  * the work isn't running, just cancelled before it started
>  * the work is running, but then nothing else can be on the
>    workqueue before it
> 
> Thus, we need to skip the lockdep workqueue dependency handling,
> otherwise we get false positive reports from lockdep saying that
> we have a potential deadlock when the workqueue also has other
> work items with locking, e.g.
> 
>   work1_function() { mutex_lock(&mutex); ... }
>   work2_function() { /* nothing */ }
> 
>   other_function() {
>     queue_work(ordered_wq, &work1);
>     queue_work(ordered_wq, &work2);
>     mutex_lock(&mutex);
>     cancel_work_sync(&work2);
>   }
> 
> As described above, this isn't a problem, but lockdep will
> currently flag it as if cancel_work_sync() was flush_work(),
> which *is* a problem.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  kernel/workqueue.c | 37 ++++++++++++++++++++++---------------
>  1 file changed, 22 insertions(+), 15 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 78b192071ef7..a6c2b823f348 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2843,7 +2843,8 @@ void drain_workqueue(struct workqueue_struct *wq)
>  }
>  EXPORT_SYMBOL_GPL(drain_workqueue);
>  
> -static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr)
> +static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
> +			     bool from_cancel)
>  {
>  	struct worker *worker = NULL;
>  	struct worker_pool *pool;
> @@ -2885,7 +2886,8 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr)
>  	 * workqueues the deadlock happens when the rescuer stalls, blocking
>  	 * forward progress.
>  	 */
> -	if (pwq->wq->saved_max_active == 1 || pwq->wq->rescuer) {
> +	if (!from_cancel &&
> +	    (pwq->wq->saved_max_active == 1 || pwq->wq->rescuer)) {
>  		lock_map_acquire(&pwq->wq->lockdep_map);
>  		lock_map_release(&pwq->wq->lockdep_map);
>  	}

But this can lead to a deadlock.  I'd much rather err on the side of
discouraging complex lock dancing around ordered workqueues, no?

Thanks.

-- 
tejun
