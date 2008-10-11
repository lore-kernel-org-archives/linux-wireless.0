Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:51518 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbYJKNyE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 09:54:04 -0400
Received: by fk-out-0910.google.com with SMTP id 18so849130fkq.5
        for <linux-wireless@vger.kernel.org>; Sat, 11 Oct 2008 06:54:02 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 5/5] rfkill: rate-limit rfkill-input workqueue usage (v3)
Date: Sat, 11 Oct 2008 15:53:52 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
References: <1223586933-17753-1-git-send-email-hmh@hmh.eng.br> <1223586933-17753-6-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1223586933-17753-6-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810111553.52856.IvDoorn@gmail.com> (sfid-20081011_155416_887056_B5204944)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 09 October 2008, Henrique de Moraes Holschuh wrote:
> Limit the number of "expensive" rfkill workqueue operations per second, in
> order to not hog system resources too much when faced with a rogue source
> of rfkill input events.
> 
> The old rfkill-input code (before it was refactored) had such a limit in
> place.  It used to drop new events that were past the rate limit.  This
> behaviour was not implemented as an anti-DoS measure, but rather as an
> attempt to work around deficiencies in input device drivers which would
> issue multiple KEY_FOO events too soon for a given key FOO (i.e. ones that
> do not implement mechanical debouncing properly).
> 
> However, we can't really expect such issues to be worked around by every
> input handler out there, and also by every userspace client of input
> devices.  It is the input device driver's responsability to do debouncing
> instead of spamming the input layer with bogus events.
> 
> The new limiter code is focused only on anti-DoS behaviour, and tries to
> not lose events (instead, it coalesces them when possible).
> 
> The transmitters are updated once every 200ms, maximum.  Care is taken not
> to delay a request to _enter_ rfkill transmitter Emergency Power Off (EPO)
> mode.
> 
> If mistriggered (e.g. by a jiffies counter wrap), the code delays processing
> *once* by 200ms.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Dmitry Torokhov <dtor@mail.ru>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  net/rfkill/rfkill-input.c |   49 +++++++++++++++++++++++++++++++++++++-------
>  1 files changed, 41 insertions(+), 8 deletions(-)
> 
> diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
> index 4ea4e68..6ddf3ce 100644
> --- a/net/rfkill/rfkill-input.c
> +++ b/net/rfkill/rfkill-input.c
> @@ -30,6 +30,9 @@ enum rfkill_input_master_mode {
>  	RFKILL_INPUT_MASTER_MAX,	/* marker */
>  };
>  
> +/* Delay (in ms) between consecutive switch ops */
> +#define RFKILL_OPS_DELAY 200
> +
>  static enum rfkill_input_master_mode rfkill_master_switch_mode =
>  					RFKILL_INPUT_MASTER_UNBLOCKALL;
>  module_param_named(master_switch_mode, rfkill_master_switch_mode, uint, 0);
> @@ -50,7 +53,7 @@ enum rfkill_global_sched_op {
>   */
>  
>  struct rfkill_task {
> -	struct work_struct work;
> +	struct delayed_work dwork;
>  
>  	/* ensures that task is serialized */
>  	struct mutex mutex;
> @@ -74,6 +77,9 @@ struct rfkill_task {
>  
>  	bool global_op_pending;
>  	enum rfkill_global_sched_op op;
> +
> +	/* last time it was scheduled */
> +	unsigned long last_scheduled;
>  };
>  
>  static void __rfkill_handle_global_op(enum rfkill_global_sched_op op)
> @@ -137,8 +143,8 @@ static void __rfkill_handle_normal_op(const enum rfkill_type type,
>  
>  static void rfkill_task_handler(struct work_struct *work)
>  {
> -	struct rfkill_task *task =
> -			container_of(work, struct rfkill_task, work);
> +	struct rfkill_task *task = container_of(work,
> +					struct rfkill_task, dwork.work);
>  	bool doit = true;
>  
>  	mutex_lock(&task->mutex);
> @@ -193,12 +199,27 @@ static void rfkill_task_handler(struct work_struct *work)
>  }
>  
>  static struct rfkill_task rfkill_task = {
> -	.work = __WORK_INITIALIZER(rfkill_task.work,
> +	.dwork = __DELAYED_WORK_INITIALIZER(rfkill_task.dwork,
>  				rfkill_task_handler),
>  	.mutex = __MUTEX_INITIALIZER(rfkill_task.mutex),
>  	.lock = __SPIN_LOCK_UNLOCKED(rfkill_task.lock),
>  };
>  
> +static unsigned long rfkill_ratelimit(const unsigned long last)
> +{
> +	const unsigned long delay = msecs_to_jiffies(RFKILL_OPS_DELAY);
> +	return (time_after(jiffies, last + delay)) ? 0 : delay;
> +}
> +
> +static void rfkill_schedule_ratelimited(void)
> +{
> +	if (!delayed_work_pending(&rfkill_task.dwork)) {
> +		schedule_delayed_work(&rfkill_task.dwork,
> +				rfkill_ratelimit(rfkill_task.last_scheduled));
> +		rfkill_task.last_scheduled = jiffies;
> +	}
> +}
> +
>  static void rfkill_schedule_global_op(enum rfkill_global_sched_op op)
>  {
>  	unsigned long flags;
> @@ -206,7 +227,13 @@ static void rfkill_schedule_global_op(enum rfkill_global_sched_op op)
>  	spin_lock_irqsave(&rfkill_task.lock, flags);
>  	rfkill_task.op = op;
>  	rfkill_task.global_op_pending = true;
> -	schedule_work(&rfkill_task.work);
> +	if (op == RFKILL_GLOBAL_OP_EPO && !rfkill_is_epo_lock_active()) {
> +		/* bypass the limiter for EPO */
> +		cancel_delayed_work(&rfkill_task.dwork);
> +		schedule_delayed_work(&rfkill_task.dwork, 0);
> +		rfkill_task.last_scheduled = jiffies;
> +	} else
> +		rfkill_schedule_ratelimited();
>  	spin_unlock_irqrestore(&rfkill_task.lock, flags);
>  }
>  
> @@ -230,7 +257,7 @@ static void rfkill_schedule_set(enum rfkill_type type,
>  			set_bit(type,  rfkill_task.sw_newstate);
>  		else
>  			clear_bit(type, rfkill_task.sw_newstate);
> -		schedule_work(&rfkill_task.work);
> +		rfkill_schedule_ratelimited();
>  	}
>  	spin_unlock_irqrestore(&rfkill_task.lock, flags);
>  }
> @@ -247,7 +274,7 @@ static void rfkill_schedule_toggle(enum rfkill_type type)
>  	if (!rfkill_task.global_op_pending) {
>  		set_bit(type, rfkill_task.sw_pending);
>  		change_bit(type, rfkill_task.sw_togglestate);
> -		schedule_work(&rfkill_task.work);
> +		rfkill_schedule_ratelimited();
>  	}
>  	spin_unlock_irqrestore(&rfkill_task.lock, flags);
>  }
> @@ -411,13 +438,19 @@ static int __init rfkill_handler_init(void)
>  	if (rfkill_master_switch_mode >= RFKILL_INPUT_MASTER_MAX)
>  		return -EINVAL;
>  
> +	/*
> +	 * The penalty to not doing this is a possible RFKILL_OPS_DELAY delay
> +	 * at the first use.  Acceptable, but if we can avoid it, why not?
> +	 */
> +	rfkill_task.last_scheduled =
> +			jiffies - msecs_to_jiffies(RFKILL_OPS_DELAY) - 1;
>  	return input_register_handler(&rfkill_handler);
>  }
>  
>  static void __exit rfkill_handler_exit(void)
>  {
>  	input_unregister_handler(&rfkill_handler);
> -	flush_scheduled_work();
> +	cancel_delayed_work_sync(&rfkill_task.dwork);
>  	rfkill_remove_epo_lock();
>  }
>  


