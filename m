Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:15957 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbYJKNyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 09:54:00 -0400
Received: by ey-out-2122.google.com with SMTP id 6so372545eyi.37
        for <linux-wireless@vger.kernel.org>; Sat, 11 Oct 2008 06:53:58 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 3/5] rfkill: add master_switch_mode and EPO lock to rfkill and rfkill-input
Date: Sat, 11 Oct 2008 15:53:49 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
References: <1223586933-17753-1-git-send-email-hmh@hmh.eng.br> <20081009212049.GA16430@khazad-dum.debian.net> <20081010004933.GA23514@khazad-dum.debian.net>
In-Reply-To: <20081010004933.GA23514@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200810111553.49466.IvDoorn@gmail.com> (sfid-20081011_155415_776663_3E2F6BCF)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 10 October 2008, Henrique de Moraes Holschuh wrote:
> Add of software-based sanity to rfkill and rfkill-input so that it can
> reproduce what hardware-based EPO switches do, blocking all transmitters
> and locking down any further attempts to unblock them until the switch is
> deactivated.
> 
> rfkill-input is responsible for issuing the EPO control requests, like
> before.
> 
> While an rfkill EPO is active, all transmitters are locked to one of the
> BLOCKED states and all attempts to change that through the rfkill API
> (userspace and kernel) will be either ignored or return -EPERM errors.
> 
> The lock will be released upon receipt of EV_SW SW_RFKILL_ALL ON by
> rfkill-input, or should modular rfkill-input be unloaded.
> 
> This makes rfkill and rfkill-input extend the operation of an existing
> wireless master kill switch to all wireless devices in the system, even
> those that are not under hardware or firmware control.
> 
> Since the above is the expected operational behavior for the master rfkill
> switch, the EPO lock functionality is not optional.
> 
> Also, extend rfkill-input to allow for three different behaviors when it
> receives an EV_SW SW_RFKILL_ALL ON input event.  The user can set which
> behavior he wants through the master_switch_mode parameter:
> 
> master_switch_mode = 0: EV_SW SW_RFKILL_ALL ON just unlocks rfkill
> controller state changes (so that the rfkill userspace and kernel APIs can
> now be used to change rfkill controller states again), but doesn't change
> any of their states (so they will all remain blocked).  This is the safest
> mode of operation, as it requires explicit operator action to re-enable a
> transmitter.
> 
> master_switch_mode = 1: EV_SW SW_RFKILL_ALL ON causes rfkill-input to
> attempt to restore the system to the state before the last EV_SW
> SW_RFKILL_ALL OFF event, or to the default global states if no EV_SW
> SW_RFKILL_ALL OFF ever happened.   This is the recommended mode of
> operation for laptops.
> 
> master_switch_mode = 2: tries to unblock all rfkill controllers (i.e.
> enable all transmitters) when an EV_SW SW_RFKILL_ALL ON event is received.
> This is the default mode of operation, as it mimics the previous behavior
> of rfkill-input.
> 
> In order to implement these features in a clean way, the entire event
> handling of rfkill-input was refactored into a single worker function.
> 
> Protection against input event DoS (repeatedly firing rfkill events for
> rfkill-input to process) was removed during the code refactoring.  It will
> be added back in a future patch.
> 
> Note that with these changes, rfkill-input doesn't need to explicitly
> handle any radio types for which KEY_<radio type> or SW_<radio type> events
> do not exist yet.
> 
> Code to handle EV_SW SW_{WLAN,WWAN,BLUETOOTH,WIMAX,...} was added as it
> might be needed in the future (and its implementation is not that obvious),
> but is currently #ifdef'd out to avoid wasting resources.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Dmitry Torokhov <dtor@mail.ru>

Although I think RFKILL_NEED_SWSET could be removed entirely if it isn't used anyway,
we might do that later.

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  Here, typos fixed...
> 
>  Documentation/rfkill.txt  |   20 ++-
>  net/rfkill/rfkill-input.c |  301 ++++++++++++++++++++++++++++++++++-----------
>  net/rfkill/rfkill-input.h |    2 +
>  net/rfkill/rfkill.c       |   46 +++++++-
>  4 files changed, 287 insertions(+), 82 deletions(-)
> 
> diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
> index b65f079..4d3ee31 100644
> --- a/Documentation/rfkill.txt
> +++ b/Documentation/rfkill.txt
> @@ -191,12 +191,20 @@ Userspace input handlers (uevents) or kernel input handlers (rfkill-input):
>  	  to tell the devices registered with the rfkill class to change
>  	  their state (i.e. translates the input layer event into real
>  	  action).
> +
>  	* rfkill-input implements EPO by handling EV_SW SW_RFKILL_ALL 0
>  	  (power off all transmitters) in a special way: it ignores any
>  	  overrides and local state cache and forces all transmitters to the
>  	  RFKILL_STATE_SOFT_BLOCKED state (including those which are already
> -	  supposed to be BLOCKED).  Note that the opposite event (power on all
> -	  transmitters) is handled normally.
> +	  supposed to be BLOCKED).
> +	* rfkill EPO will remain active until rfkill-input receives an
> +	  EV_SW SW_RFKILL_ALL 1 event.  While the EPO is active, transmitters
> +	  are locked in the blocked state (rfkill will refuse to unblock them).
> +	* rfkill-input implements different policies that the user can
> +	  select for handling EV_SW SW_RFKILL_ALL 1.  It will unlock rfkill,
> +	  and either do nothing (leave transmitters blocked, but now unlocked),
> +	  restore the transmitters to their state before the EPO, or unblock
> +	  them all.
>  
>  Userspace uevent handler or kernel platform-specific drivers hooked to the
>  rfkill notifier chain:
> @@ -331,11 +339,9 @@ class to get a sysfs interface :-)
>  correct event for your switch/button.  These events are emergency power-off
>  events when they are trying to turn the transmitters off.  An example of an
>  input device which SHOULD generate *_RFKILL_ALL events is the wireless-kill
> -switch in a laptop which is NOT a hotkey, but a real switch that kills radios
> -in hardware, even if the O.S. has gone to lunch.  An example of an input device
> -which SHOULD NOT generate *_RFKILL_ALL events by default, is any sort of hot
> -key that does nothing by itself, as well as any hot key that is type-specific
> -(e.g. the one for WLAN).
> +switch in a laptop which is NOT a hotkey, but a real sliding/rocker switch.
> +An example of an input device which SHOULD NOT generate *_RFKILL_ALL events by
> +default, is any sort of hot key that is type-specific (e.g. the one for WLAN).
>  
>  
>  3.1 Guidelines for wireless device drivers
> diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
> index e5b6955..4ea4e68 100644
> --- a/net/rfkill/rfkill-input.c
> +++ b/net/rfkill/rfkill-input.c
> @@ -23,138 +23,291 @@ MODULE_AUTHOR("Dmitry Torokhov <dtor@mail.ru>");
>  MODULE_DESCRIPTION("Input layer to RF switch connector");
>  MODULE_LICENSE("GPL");
>  
> +enum rfkill_input_master_mode {
> +	RFKILL_INPUT_MASTER_DONOTHING = 0,
> +	RFKILL_INPUT_MASTER_RESTORE = 1,
> +	RFKILL_INPUT_MASTER_UNBLOCKALL = 2,
> +	RFKILL_INPUT_MASTER_MAX,	/* marker */
> +};
> +
> +static enum rfkill_input_master_mode rfkill_master_switch_mode =
> +					RFKILL_INPUT_MASTER_UNBLOCKALL;
> +module_param_named(master_switch_mode, rfkill_master_switch_mode, uint, 0);
> +MODULE_PARM_DESC(master_switch_mode,
> +	"SW_RFKILL_ALL ON should: 0=do nothing; 1=restore; 2=unblock all");
> +
> +enum rfkill_global_sched_op {
> +	RFKILL_GLOBAL_OP_EPO = 0,
> +	RFKILL_GLOBAL_OP_RESTORE,
> +	RFKILL_GLOBAL_OP_UNLOCK,
> +	RFKILL_GLOBAL_OP_UNBLOCK,
> +};
> +
> +/*
> + * Currently, the code marked with RFKILL_NEED_SWSET is inactive.
> + * If handling of EV_SW SW_WLAN/WWAN/BLUETOOTH/etc is needed in the
> + * future, when such events are added, that code will be necessary.
> + */
> +
>  struct rfkill_task {
>  	struct work_struct work;
> -	enum rfkill_type type;
> -	struct mutex mutex; /* ensures that task is serialized */
> -	spinlock_t lock; /* for accessing last and desired state */
> -	unsigned long last; /* last schedule */
> -	enum rfkill_state desired_state; /* on/off */
> +
> +	/* ensures that task is serialized */
> +	struct mutex mutex;
> +
> +	/* protects everything below */
> +	spinlock_t lock;
> +
> +	/* pending regular switch operations (1=pending) */
> +	unsigned long sw_pending[BITS_TO_LONGS(RFKILL_TYPE_MAX)];
> +
> +#ifdef RFKILL_NEED_SWSET
> +	/* set operation pending (1=pending) */
> +	unsigned long sw_setpending[BITS_TO_LONGS(RFKILL_TYPE_MAX)];
> +
> +	/* desired state for pending set operation (1=unblock) */
> +	unsigned long sw_newstate[BITS_TO_LONGS(RFKILL_TYPE_MAX)];
> +#endif
> +
> +	/* should the state be complemented (1=yes) */
> +	unsigned long sw_togglestate[BITS_TO_LONGS(RFKILL_TYPE_MAX)];
> +
> +	bool global_op_pending;
> +	enum rfkill_global_sched_op op;
>  };
>  
> -static void rfkill_task_handler(struct work_struct *work)
> +static void __rfkill_handle_global_op(enum rfkill_global_sched_op op)
>  {
> -	struct rfkill_task *task = container_of(work, struct rfkill_task, work);
> +	unsigned int i;
> +
> +	switch (op) {
> +	case RFKILL_GLOBAL_OP_EPO:
> +		rfkill_epo();
> +		break;
> +	case RFKILL_GLOBAL_OP_RESTORE:
> +		rfkill_restore_states();
> +		break;
> +	case RFKILL_GLOBAL_OP_UNLOCK:
> +		rfkill_remove_epo_lock();
> +		break;
> +	case RFKILL_GLOBAL_OP_UNBLOCK:
> +		rfkill_remove_epo_lock();
> +		for (i = 0; i < RFKILL_TYPE_MAX; i++)
> +			rfkill_switch_all(i, RFKILL_STATE_UNBLOCKED);
> +		break;
> +	default:
> +		/* memory corruption or bug, fail safely */
> +		rfkill_epo();
> +		WARN(1, "Unknown requested operation %d! "
> +			"rfkill Emergency Power Off activated\n",
> +			op);
> +	}
> +}
>  
> -	mutex_lock(&task->mutex);
> +#ifdef RFKILL_NEED_SWSET
> +static void __rfkill_handle_normal_op(const enum rfkill_type type,
> +			const bool sp, const bool s, const bool c)
> +{
> +	enum rfkill_state state;
>  
> -	rfkill_switch_all(task->type, task->desired_state);
> +	if (sp)
> +		state = (s) ? RFKILL_STATE_UNBLOCKED :
> +			      RFKILL_STATE_SOFT_BLOCKED;
> +	else
> +		state = rfkill_get_global_state(type);
>  
> -	mutex_unlock(&task->mutex);
> +	if (c)
> +		state = rfkill_state_complement(state);
> +
> +	rfkill_switch_all(type, state);
>  }
> +#else
> +static void __rfkill_handle_normal_op(const enum rfkill_type type,
> +			const bool c)
> +{
> +	enum rfkill_state state;
> +
> +	state = rfkill_get_global_state(type);
> +	if (c)
> +		state = rfkill_state_complement(state);
> +
> +	rfkill_switch_all(type, state);
> +}
> +#endif
>  
> -static void rfkill_task_epo_handler(struct work_struct *work)
> +static void rfkill_task_handler(struct work_struct *work)
>  {
> -	rfkill_epo();
> +	struct rfkill_task *task =
> +			container_of(work, struct rfkill_task, work);
> +	bool doit = true;
> +
> +	mutex_lock(&task->mutex);
> +
> +	spin_lock_irq(&task->lock);
> +	while (doit) {
> +		if (task->global_op_pending) {
> +			enum rfkill_global_sched_op op = task->op;
> +			task->global_op_pending = false;
> +			memset(task->sw_pending, 0, sizeof(task->sw_pending));
> +			spin_unlock_irq(&task->lock);
> +
> +			__rfkill_handle_global_op(op);
> +
> +			/* make sure we do at least one pass with
> +			 * !task->global_op_pending */
> +			spin_lock_irq(&task->lock);
> +			continue;
> +		} else if (!rfkill_is_epo_lock_active()) {
> +			unsigned int i = 0;
> +
> +			while (!task->global_op_pending &&
> +						i < RFKILL_TYPE_MAX) {
> +				if (test_and_clear_bit(i, task->sw_pending)) {
> +					bool c;
> +#ifdef RFKILL_NEED_SWSET
> +					bool sp, s;
> +					sp = test_and_clear_bit(i,
> +							task->sw_setpending);
> +					s = test_bit(i, task->sw_newstate);
> +#endif
> +					c = test_and_clear_bit(i,
> +							task->sw_togglestate);
> +					spin_unlock_irq(&task->lock);
> +
> +#ifdef RFKILL_NEED_SWSET
> +					__rfkill_handle_normal_op(i, sp, s, c);
> +#else
> +					__rfkill_handle_normal_op(i, c);
> +#endif
> +
> +					spin_lock_irq(&task->lock);
> +				}
> +				i++;
> +			}
> +		}
> +		doit = task->global_op_pending;
> +	}
> +	spin_unlock_irq(&task->lock);
> +
> +	mutex_unlock(&task->mutex);
>  }
>  
> -static DECLARE_WORK(epo_work, rfkill_task_epo_handler);
> +static struct rfkill_task rfkill_task = {
> +	.work = __WORK_INITIALIZER(rfkill_task.work,
> +				rfkill_task_handler),
> +	.mutex = __MUTEX_INITIALIZER(rfkill_task.mutex),
> +	.lock = __SPIN_LOCK_UNLOCKED(rfkill_task.lock),
> +};
>  
> -static void rfkill_schedule_epo(void)
> +static void rfkill_schedule_global_op(enum rfkill_global_sched_op op)
>  {
> -	schedule_work(&epo_work);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&rfkill_task.lock, flags);
> +	rfkill_task.op = op;
> +	rfkill_task.global_op_pending = true;
> +	schedule_work(&rfkill_task.work);
> +	spin_unlock_irqrestore(&rfkill_task.lock, flags);
>  }
>  
> -static void rfkill_schedule_set(struct rfkill_task *task,
> +#ifdef RFKILL_NEED_SWSET
> +/* Use this if you need to add EV_SW SW_WLAN/WWAN/BLUETOOTH/etc handling */
> +
> +static void rfkill_schedule_set(enum rfkill_type type,
>  				enum rfkill_state desired_state)
>  {
>  	unsigned long flags;
>  
> -	if (unlikely(work_pending(&epo_work)))
> +	if (rfkill_is_epo_lock_active())
>  		return;
>  
> -	spin_lock_irqsave(&task->lock, flags);
> -
> -	if (time_after(jiffies, task->last + msecs_to_jiffies(200))) {
> -		task->desired_state = desired_state;
> -		task->last = jiffies;
> -		schedule_work(&task->work);
> +	spin_lock_irqsave(&rfkill_task.lock, flags);
> +	if (!rfkill_task.global_op_pending) {
> +		set_bit(type, rfkill_task.sw_pending);
> +		set_bit(type, rfkill_task.sw_setpending);
> +		clear_bit(type, rfkill_task.sw_togglestate);
> +		if (desired_state)
> +			set_bit(type,  rfkill_task.sw_newstate);
> +		else
> +			clear_bit(type, rfkill_task.sw_newstate);
> +		schedule_work(&rfkill_task.work);
>  	}
> -
> -	spin_unlock_irqrestore(&task->lock, flags);
> +	spin_unlock_irqrestore(&rfkill_task.lock, flags);
>  }
> +#endif
>  
> -static void rfkill_schedule_toggle(struct rfkill_task *task)
> +static void rfkill_schedule_toggle(enum rfkill_type type)
>  {
>  	unsigned long flags;
>  
> -	if (unlikely(work_pending(&epo_work)))
> +	if (rfkill_is_epo_lock_active())
>  		return;
>  
> -	spin_lock_irqsave(&task->lock, flags);
> -
> -	if (time_after(jiffies, task->last + msecs_to_jiffies(200))) {
> -		task->desired_state =
> -				rfkill_state_complement(task->desired_state);
> -		task->last = jiffies;
> -		schedule_work(&task->work);
> +	spin_lock_irqsave(&rfkill_task.lock, flags);
> +	if (!rfkill_task.global_op_pending) {
> +		set_bit(type, rfkill_task.sw_pending);
> +		change_bit(type, rfkill_task.sw_togglestate);
> +		schedule_work(&rfkill_task.work);
>  	}
> -
> -	spin_unlock_irqrestore(&task->lock, flags);
> +	spin_unlock_irqrestore(&rfkill_task.lock, flags);
>  }
>  
> -#define DEFINE_RFKILL_TASK(n, t)				\
> -	struct rfkill_task n = {				\
> -		.work = __WORK_INITIALIZER(n.work,		\
> -				rfkill_task_handler),		\
> -		.type = t,					\
> -		.mutex = __MUTEX_INITIALIZER(n.mutex),		\
> -		.lock = __SPIN_LOCK_UNLOCKED(n.lock),		\
> -		.desired_state = RFKILL_STATE_UNBLOCKED,	\
> -	}
> -
> -static DEFINE_RFKILL_TASK(rfkill_wlan, RFKILL_TYPE_WLAN);
> -static DEFINE_RFKILL_TASK(rfkill_bt, RFKILL_TYPE_BLUETOOTH);
> -static DEFINE_RFKILL_TASK(rfkill_uwb, RFKILL_TYPE_UWB);
> -static DEFINE_RFKILL_TASK(rfkill_wimax, RFKILL_TYPE_WIMAX);
> -static DEFINE_RFKILL_TASK(rfkill_wwan, RFKILL_TYPE_WWAN);
> -
>  static void rfkill_schedule_evsw_rfkillall(int state)
>  {
> -	/* EVERY radio type. state != 0 means radios ON */
> -	/* handle EPO (emergency power off) through shortcut */
>  	if (state) {
> -		rfkill_schedule_set(&rfkill_wwan,
> -				    RFKILL_STATE_UNBLOCKED);
> -		rfkill_schedule_set(&rfkill_wimax,
> -				    RFKILL_STATE_UNBLOCKED);
> -		rfkill_schedule_set(&rfkill_uwb,
> -				    RFKILL_STATE_UNBLOCKED);
> -		rfkill_schedule_set(&rfkill_bt,
> -				    RFKILL_STATE_UNBLOCKED);
> -		rfkill_schedule_set(&rfkill_wlan,
> -				    RFKILL_STATE_UNBLOCKED);
> +		switch (rfkill_master_switch_mode) {
> +		case RFKILL_INPUT_MASTER_UNBLOCKALL:
> +			rfkill_schedule_global_op(RFKILL_GLOBAL_OP_UNBLOCK);
> +			break;
> +		case RFKILL_INPUT_MASTER_RESTORE:
> +			rfkill_schedule_global_op(RFKILL_GLOBAL_OP_RESTORE);
> +			break;
> +		case RFKILL_INPUT_MASTER_DONOTHING:
> +			rfkill_schedule_global_op(RFKILL_GLOBAL_OP_UNLOCK);
> +			break;
> +		default:
> +			/* memory corruption or driver bug! fail safely */
> +			rfkill_schedule_global_op(RFKILL_GLOBAL_OP_EPO);
> +			WARN(1, "Unknown rfkill_master_switch_mode (%d), "
> +				"driver bug or memory corruption detected!\n",
> +				rfkill_master_switch_mode);
> +			break;
> +		}
>  	} else
> -		rfkill_schedule_epo();
> +		rfkill_schedule_global_op(RFKILL_GLOBAL_OP_EPO);
>  }
>  
>  static void rfkill_event(struct input_handle *handle, unsigned int type,
>  			unsigned int code, int data)
>  {
>  	if (type == EV_KEY && data == 1) {
> +		enum rfkill_type t;
> +
>  		switch (code) {
>  		case KEY_WLAN:
> -			rfkill_schedule_toggle(&rfkill_wlan);
> +			t = RFKILL_TYPE_WLAN;
>  			break;
>  		case KEY_BLUETOOTH:
> -			rfkill_schedule_toggle(&rfkill_bt);
> +			t = RFKILL_TYPE_BLUETOOTH;
>  			break;
>  		case KEY_UWB:
> -			rfkill_schedule_toggle(&rfkill_uwb);
> +			t = RFKILL_TYPE_UWB;
>  			break;
>  		case KEY_WIMAX:
> -			rfkill_schedule_toggle(&rfkill_wimax);
> +			t = RFKILL_TYPE_WIMAX;
>  			break;
>  		default:
> -			break;
> +			return;
>  		}
> +		rfkill_schedule_toggle(t);
> +		return;
>  	} else if (type == EV_SW) {
>  		switch (code) {
>  		case SW_RFKILL_ALL:
>  			rfkill_schedule_evsw_rfkillall(data);
> -			break;
> +			return;
>  		default:
> -			break;
> +			return;
>  		}
>  	}
>  }
> @@ -255,6 +408,9 @@ static struct input_handler rfkill_handler = {
>  
>  static int __init rfkill_handler_init(void)
>  {
> +	if (rfkill_master_switch_mode >= RFKILL_INPUT_MASTER_MAX)
> +		return -EINVAL;
> +
>  	return input_register_handler(&rfkill_handler);
>  }
>  
> @@ -262,6 +418,7 @@ static void __exit rfkill_handler_exit(void)
>  {
>  	input_unregister_handler(&rfkill_handler);
>  	flush_scheduled_work();
> +	rfkill_remove_epo_lock();
>  }
>  
>  module_init(rfkill_handler_init);
> diff --git a/net/rfkill/rfkill-input.h b/net/rfkill/rfkill-input.h
> index d1e03e8..fe8df6b 100644
> --- a/net/rfkill/rfkill-input.h
> +++ b/net/rfkill/rfkill-input.h
> @@ -14,6 +14,8 @@
>  void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state);
>  void rfkill_epo(void);
>  void rfkill_restore_states(void);
> +void rfkill_remove_epo_lock(void);
> +bool rfkill_is_epo_lock_active(void);
>  enum rfkill_state rfkill_get_global_state(const enum rfkill_type type);
>  
>  #endif /* __RFKILL_INPUT_H */
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index fdf87d2..e348eab 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -51,6 +51,7 @@ struct rfkill_gsw_state {
>  
>  static struct rfkill_gsw_state rfkill_global_states[RFKILL_TYPE_MAX];
>  static unsigned long rfkill_states_lockdflt[BITS_TO_LONGS(RFKILL_TYPE_MAX)];
> +static bool rfkill_epo_lock_active;
>  
>  static BLOCKING_NOTIFIER_HEAD(rfkill_notifier_list);
>  
> @@ -264,11 +265,14 @@ static void __rfkill_switch_all(const enum rfkill_type type,
>   *
>   * Acquires rfkill_global_mutex and calls __rfkill_switch_all(@type, @state).
>   * Please refer to __rfkill_switch_all() for details.
> + *
> + * Does nothing if the EPO lock is active.
>   */
>  void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
>  {
>  	mutex_lock(&rfkill_global_mutex);
> -	__rfkill_switch_all(type, state);
> +	if (!rfkill_epo_lock_active)
> +		__rfkill_switch_all(type, state);
>  	mutex_unlock(&rfkill_global_mutex);
>  }
>  EXPORT_SYMBOL(rfkill_switch_all);
> @@ -289,6 +293,7 @@ void rfkill_epo(void)
>  
>  	mutex_lock(&rfkill_global_mutex);
>  
> +	rfkill_epo_lock_active = true;
>  	list_for_each_entry(rfkill, &rfkill_list, node) {
>  		mutex_lock(&rfkill->mutex);
>  		rfkill_toggle_radio(rfkill, RFKILL_STATE_SOFT_BLOCKED, 1);
> @@ -317,6 +322,7 @@ void rfkill_restore_states(void)
>  
>  	mutex_lock(&rfkill_global_mutex);
>  
> +	rfkill_epo_lock_active = false;
>  	for (i = 0; i < RFKILL_TYPE_MAX; i++)
>  		__rfkill_switch_all(i, rfkill_global_states[i].default_state);
>  	mutex_unlock(&rfkill_global_mutex);
> @@ -324,6 +330,35 @@ void rfkill_restore_states(void)
>  EXPORT_SYMBOL_GPL(rfkill_restore_states);
>  
>  /**
> + * rfkill_remove_epo_lock - unlock state changes
> + *
> + * Used by rfkill-input manually unlock state changes, when
> + * the EPO switch is deactivated.
> + */
> +void rfkill_remove_epo_lock(void)
> +{
> +	mutex_lock(&rfkill_global_mutex);
> +	rfkill_epo_lock_active = false;
> +	mutex_unlock(&rfkill_global_mutex);
> +}
> +EXPORT_SYMBOL_GPL(rfkill_remove_epo_lock);
> +
> +/**
> + * rfkill_is_epo_lock_active - returns true EPO is active
> + *
> + * Returns 0 (false) if there is NOT an active EPO contidion,
> + * and 1 (true) if there is an active EPO contition, which
> + * locks all radios in one of the BLOCKED states.
> + *
> + * Can be called in atomic context.
> + */
> +bool rfkill_is_epo_lock_active(void)
> +{
> +	return rfkill_epo_lock_active;
> +}
> +EXPORT_SYMBOL_GPL(rfkill_is_epo_lock_active);
> +
> +/**
>   * rfkill_get_global_state - returns global state for a type
>   * @type: the type to get the global state of
>   *
> @@ -447,7 +482,12 @@ static ssize_t rfkill_state_store(struct device *dev,
>  	error = mutex_lock_killable(&rfkill->mutex);
>  	if (error)
>  		return error;
> -	error = rfkill_toggle_radio(rfkill, state, 0);
> +
> +	if (!rfkill_epo_lock_active)
> +		error = rfkill_toggle_radio(rfkill, state, 0);
> +	else
> +		error = -EPERM;
> +
>  	mutex_unlock(&rfkill->mutex);
>  
>  	return error ? error : count;
> @@ -491,7 +531,7 @@ static ssize_t rfkill_claim_store(struct device *dev,
>  		return error;
>  
>  	if (rfkill->user_claim != claim) {
> -		if (!claim) {
> +		if (!claim && !rfkill_epo_lock_active) {
>  			mutex_lock(&rfkill->mutex);
>  			rfkill_toggle_radio(rfkill,
>  					rfkill_global_states[rfkill->type].current_state,
> -- 
> 1.5.6.5
> 


