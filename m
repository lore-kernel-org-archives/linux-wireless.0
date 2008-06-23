Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:41787 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758896AbYFWUza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 16:55:30 -0400
Received: by ug-out-1314.google.com with SMTP id h2so603577ugf.16
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2008 13:55:27 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 1/2] rfkill: rename the rfkill_state states and add block-locked state
Date: Mon, 23 Jun 2008 22:55:24 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
	Dan Williams <dcbw@redhat.com>,
	Thomas Renninger <trenn@suse.de>,
	Fabien Crespel <fabien@crespel.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1214254004-32652-1-git-send-email-hmh@hmh.eng.br> <1214254004-32652-2-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1214254004-32652-2-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200806232255.24813.IvDoorn@gmail.com> (sfid-20080623_225545_677204_9487CD1D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 23 June 2008, Henrique de Moraes Holschuh wrote:
> The current naming of rfkill_state causes a lot of confusion: not only the
> "kill" in rfkill suggests negative logic, but also the fact that rfkill cannot
> turn anything on (it can just force something off or stop forcing something
> off) is often forgotten.
> 
> Rename RFKILL_STATE_OFF to RFKILL_STATE_SOFT_BLOCKED (transmitter is blocked
> and will not operate; state can be changed by a toggle_radio request), and
> RFKILL_STATE_ON to RFKILL_STATE_UNBLOCKED (transmitter is not blocked, and may
> operate).
> 
> Also, add a new third state, RFKILL_STATE_HARD_BLOCKED (transmitter is blocked
> and will not operate; state cannot be changed through a toggle_radio request),
> which is used by drivers to indicate a wireless transmiter was blocked by a
> hardware rfkill line that accepts no overrides.
> 
> Keep the old names as #defines, but document them as deprecated.  This way,
> drivers can be converted to the new names *and* verified to actually use rfkill
> correctly one by one.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  Documentation/rfkill.txt  |   56 ++++++++++++++++++++++++++++-----
>  include/linux/rfkill.h    |   32 +++++++++++++++++--
>  net/rfkill/rfkill-input.c |   29 +++++++++--------
>  net/rfkill/rfkill.c       |   75 ++++++++++++++++++++++++++++++++++++--------
>  4 files changed, 152 insertions(+), 40 deletions(-)
> 
> diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
> index cf230c1..5316cea 100644
> --- a/Documentation/rfkill.txt
> +++ b/Documentation/rfkill.txt
> @@ -60,9 +60,20 @@ The second option provides an rfkill input handler. This handler will listen to
>  all rfkill key events and will toggle the radio accordingly.  With this option
>  enabled userspace could either do nothing or simply perform monitoring tasks.
>  
> -When a rfkill switch is in the RFKILL_STATE_ON, the wireless transmitter (radio
> -TX circuit for example) is *enabled*.  When the rfkill switch is in the
> -RFKILL_STATE_OFF, the wireless transmitter is to be *blocked* from operating.
> +When a rfkill switch is in the RFKILL_STATE_UNBLOCKED, the wireless transmitter
> +(radio TX circuit for example) is *enabled*.  When the rfkill switch is in the
> +RFKILL_STATE_SOFT_BLOCKED or RFKILL_STATE_HARD_BLOCKED, the wireless
> +transmitter is to be *blocked* from operating.
> +
> +RFKILL_STATE_SOFT_BLOCKED indicates that a call to toggle_radio() can change
> +that state.  RFKILL_STATE_HARD_BLOCKED indicates that a call to toggle_radio()
> +will not be able to change the state and will return with a suitable error if
> +attempts are made to set the state to RFKILL_STATE_UNBLOCKED.
> +
> +RFKILL_STATE_HARD_BLOCKED is used by drivers to signal that the device is
> +locked in the BLOCKED state by a hardwire rfkill line (typically an input pin
> +that, when active, forces the transmitter to be disabled) which the driver
> +CANNOT override.
>  
>  Full rfkill functionality requires two different subsystems to cooperate: the
>  input layer and the rfkill class.  The input layer issues *commands* to the
> @@ -122,10 +133,10 @@ Userspace input handlers (uevents) or kernel input handlers (rfkill-input):
>  	  action).
>  	* rfkill-input implements EPO by handling EV_SW SW_RFKILL_ALL 0
>  	  (power off all transmitters) in a special way: it ignores any
> -	  overrides and local state cache and forces all transmitters to
> -	  the OFF state (including those which are already supposed to be
> -	  OFF).  Note that the opposite event (power on all transmitters)
> -	  is handled normally.
> +	  overrides and local state cache and forces all transmitters to the
> +	  RFKILL_STATE_SOFT_BLOCKED state (including those which are already
> +	  supposed to be BLOCKED).  Note that the opposite event (power on all
> +	  transmitters) is handled normally.
>  
>  Userspace uevent handler or kernel platform-specific drivers hooked to the
>  rfkill notifier chain:
> @@ -284,6 +295,19 @@ You should:
>  	  YOU CAN ACCESS state DIRECTLY)
>  	- rfkill_register()
>  
> +The only way to set a device to the RFKILL_STATE_HARD_BLOCKED state is through
> +a suitable return of get_state() or through rfkill_force_state().
> +
> +When a device is in the RFKILL_STATE_HARD_BLOCKED state, the only way to switch
> +it to a different state is through a suitable return of get_state() or through
> +rfkill_force_state().
> +
> +If toggle_radio() is called to set a device to state RFKILL_STATE_SOFT_BLOCKED
> +when that device is already at the RFKILL_STATE_HARD_BLOCKED state, it should
> +not return an error.  Instead, it should try to double-block the transmitter,
> +so that its state will change from RFKILL_STATE_HARD_BLOCKED to
> +RFKILL_STATE_SOFT_BLOCKED should the hardware blocking cease.
> +
>  Please refer to the source for more documentation.
>  
>  ===============================================================================
> @@ -322,13 +346,27 @@ change by writing to the "state" attribute in order for anything to happen.
>  
>  Take particular care to implement EV_SW SW_RFKILL_ALL properly.  When that
>  switch is set to OFF, *every* rfkill device *MUST* be immediately put into the
> -OFF state, no questions asked.
> +RFKILL_STATE_SOFT_BLOCKED state, no questions asked.
>  
>  The following sysfs entries will be created:
>  
>  	name: Name assigned by driver to this key (interface or driver name).
>  	type: Name of the key type ("wlan", "bluetooth", etc).
> -	state: Current state of the key. 1: On, 0: Off.
> +	state: Current state of the transmitter
> +		0: RFKILL_STATE_SOFT_BLOCKED
> +			transmitter is forced off, but you can override it
> +			by a write to the state attribute, or through input
> +			events (if rfkill-input is loaded).
> +		1: RFKILL_STATE_UNBLOCKED
> +			transmiter is NOT forced off, and may operate if
> +			all other conditions for such operation are met
> +			(such as interface is up and configured, etc).
> +		2: RFKILL_STATE_HARD_BLOCKED
> +			transmitter is forced off by something outside of
> +			the driver's control.
> +
> +			You cannot set a device to this state through
> +			writes to the state attribute.
>  	claim: 1: Userspace handles events, 0: Kernel handles events
>  
>  Both the "state" and "claim" entries are also writable. For the "state" entry
> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> index 98667be..c5f6e54 100644
> --- a/include/linux/rfkill.h
> +++ b/include/linux/rfkill.h
> @@ -46,16 +46,25 @@ enum rfkill_type {
>  };
>  
>  enum rfkill_state {
> -	RFKILL_STATE_OFF	= 0,	/* Radio output blocked */
> -	RFKILL_STATE_ON		= 1,	/* Radio output active */
> +	RFKILL_STATE_SOFT_BLOCKED = 0,	/* Radio output blocked */
> +	RFKILL_STATE_UNBLOCKED    = 1,	/* Radio output allowed */
> +	RFKILL_STATE_HARD_BLOCKED = 2,	/* Output blocked, non-overrideable */
>  };
>  
> +/*
> + * These are DEPRECATED, drivers using them should be verified to
> + * comply with the rfkill usage guidelines in Documentation/rfkill.txt
> + * and then converted to use the new names for rfkill_state
> + */
> +#define RFKILL_STATE_OFF RFKILL_STATE_SOFT_BLOCKED
> +#define RFKILL_STATE_ON  RFKILL_STATE_UNBLOCKED
> +
>  /**
>   * struct rfkill - rfkill control structure.
>   * @name: Name of the switch.
>   * @type: Radio type which the button controls, the value stored
>   *	here should be a value from enum rfkill_type.
> - * @state: State of the switch, "ON" means radio can operate.
> + * @state: State of the switch, "UNBLOCKED" means radio can operate.
>   * @user_claim_unsupported: Whether the hardware supports exclusive
>   *	RF-kill control by userspace. Set this before registering.
>   * @user_claim: Set when the switch is controlled exlusively by userspace.
> @@ -63,8 +72,12 @@ enum rfkill_state {
>   * @data: Pointer to the RF button drivers private data which will be
>   *	passed along when toggling radio state.
>   * @toggle_radio(): Mandatory handler to control state of the radio.
> + *	only RFKILL_STATE_SOFT_BLOCKED and RFKILL_STATE_UNBLOCKED are
> + *	valid parameters.
>   * @get_state(): handler to read current radio state from hardware,
>   *      may be called from atomic context, should return 0 on success.
> + *      Either this handler OR judicious use of rfkill_force_state() is
> + *      MANDATORY for any driver capable of RFKILL_STATE_HARD_BLOCKED.
>   * @led_trigger: A LED trigger for this button's LED.
>   * @dev: Device structure integrating the switch into device tree.
>   * @node: Used to place switch into list of all switches known to the
> @@ -103,6 +116,19 @@ void rfkill_unregister(struct rfkill *rfkill);
>  int rfkill_force_state(struct rfkill *rfkill, enum rfkill_state state);
>  
>  /**
> + * rfkill_state_complement - return complementar state
> + * @state: state to return the complement of
> + *
> + * Returns RFKILL_STATE_SOFT_BLOCKED if @state is RFKILL_STATE_UNBLOCKED,
> + * returns RFKILL_STATE_UNBLOCKED otherwise.
> + */
> +static inline enum rfkill_state rfkill_state_complement(enum rfkill_state state)
> +{
> +	return (state == RFKILL_STATE_UNBLOCKED) ?
> +		RFKILL_STATE_SOFT_BLOCKED : RFKILL_STATE_UNBLOCKED;
> +}
> +
> +/**
>   * rfkill_get_led_name - Get the LED trigger name for the button's LED.
>   * This function might return a NULL pointer if registering of the
>   * LED trigger failed.
> diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
> index 5d4c8b2..8aa8227 100644
> --- a/net/rfkill/rfkill-input.c
> +++ b/net/rfkill/rfkill-input.c
> @@ -84,7 +84,8 @@ static void rfkill_schedule_toggle(struct rfkill_task *task)
>  	spin_lock_irqsave(&task->lock, flags);
>  
>  	if (time_after(jiffies, task->last + msecs_to_jiffies(200))) {
> -		task->desired_state = !task->desired_state;
> +		task->desired_state =
> +				rfkill_state_complement(task->desired_state);
>  		task->last = jiffies;
>  		schedule_work(&task->work);
>  	}
> @@ -92,14 +93,14 @@ static void rfkill_schedule_toggle(struct rfkill_task *task)
>  	spin_unlock_irqrestore(&task->lock, flags);
>  }
>  
> -#define DEFINE_RFKILL_TASK(n, t)			\
> -	struct rfkill_task n = {			\
> -		.work = __WORK_INITIALIZER(n.work,	\
> -				rfkill_task_handler),	\
> -		.type = t,				\
> -		.mutex = __MUTEX_INITIALIZER(n.mutex),	\
> -		.lock = __SPIN_LOCK_UNLOCKED(n.lock),	\
> -		.desired_state = RFKILL_STATE_ON,	\
> +#define DEFINE_RFKILL_TASK(n, t)				\
> +	struct rfkill_task n = {				\
> +		.work = __WORK_INITIALIZER(n.work,		\
> +				rfkill_task_handler),		\
> +		.type = t,					\
> +		.mutex = __MUTEX_INITIALIZER(n.mutex),		\
> +		.lock = __SPIN_LOCK_UNLOCKED(n.lock),		\
> +		.desired_state = RFKILL_STATE_UNBLOCKED,	\
>  	}
>  
>  static DEFINE_RFKILL_TASK(rfkill_wlan, RFKILL_TYPE_WLAN);
> @@ -135,15 +136,15 @@ static void rfkill_event(struct input_handle *handle, unsigned int type,
>  			/* handle EPO (emergency power off) through shortcut */
>  			if (data) {
>  				rfkill_schedule_set(&rfkill_wwan,
> -						    RFKILL_STATE_ON);
> +						    RFKILL_STATE_UNBLOCKED);
>  				rfkill_schedule_set(&rfkill_wimax,
> -						    RFKILL_STATE_ON);
> +						    RFKILL_STATE_UNBLOCKED);
>  				rfkill_schedule_set(&rfkill_uwb,
> -						    RFKILL_STATE_ON);
> +						    RFKILL_STATE_UNBLOCKED);
>  				rfkill_schedule_set(&rfkill_bt,
> -						    RFKILL_STATE_ON);
> +						    RFKILL_STATE_UNBLOCKED);
>  				rfkill_schedule_set(&rfkill_wlan,
> -						    RFKILL_STATE_ON);
> +						    RFKILL_STATE_UNBLOCKED);
>  			} else
>  				rfkill_schedule_epo();
>  			break;
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index 7d07175..ce0e231 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -39,7 +39,7 @@ MODULE_LICENSE("GPL");
>  static LIST_HEAD(rfkill_list);	/* list of registered rf switches */
>  static DEFINE_MUTEX(rfkill_mutex);
>  
> -static unsigned int rfkill_default_state = RFKILL_STATE_ON;
> +static unsigned int rfkill_default_state = RFKILL_STATE_UNBLOCKED;
>  module_param_named(default_state, rfkill_default_state, uint, 0444);
>  MODULE_PARM_DESC(default_state,
>  		 "Default initial state for all radio types, 0 = radio off");
> @@ -98,7 +98,7 @@ static void rfkill_led_trigger(struct rfkill *rfkill,
>  
>  	if (!led->name)
>  		return;
> -	if (state == RFKILL_STATE_OFF)
> +	if (state != RFKILL_STATE_UNBLOCKED)
>  		led_trigger_event(led, LED_OFF);
>  	else
>  		led_trigger_event(led, LED_FULL);
> @@ -128,6 +128,28 @@ static void update_rfkill_state(struct rfkill *rfkill)
>  	}
>  }
>  
> +/**
> + * rfkill_toggle_radio - wrapper for toggle_radio hook
> + * calls toggle_radio taking into account a lot of "small"
> + * details.
> + * @rfkill: the rfkill struct to use
> + * @force: calls toggle_radio even if cache says it is not needed,
> + *	and also makes sure notifications of the state will be
> + *	sent even if it didn't change
> + * @state: the new state to call toggle_radio() with
> + *
> + * This wrappen protects and enforces the API for toggle_radio
> + * calls.  Note that @force cannot override a (possibly cached)
> + * state of RFKILL_STATE_HARD_BLOCKED.  Any device making use of
> + * RFKILL_STATE_HARD_BLOCKED implements either get_state() or
> + * rfkill_force_state(), so the cache either is bypassed or valid.
> + *
> + * Note that we do call toggle_radio for RFKILL_STATE_SOFT_BLOCKED
> + * even if the radio is in RFKILL_STATE_HARD_BLOCKED state, so as to
> + * give the driver a hint that it should double-BLOCK the transmitter.
> + *
> + * Caller must have aquired rfkill_mutex.
> + */
>  static int rfkill_toggle_radio(struct rfkill *rfkill,
>  				enum rfkill_state state,
>  				int force)
> @@ -141,9 +163,28 @@ static int rfkill_toggle_radio(struct rfkill *rfkill,
>  	    !rfkill->get_state(rfkill->data, &newstate))
>  		rfkill->state = newstate;
>  
> +	switch (state) {
> +	case RFKILL_STATE_HARD_BLOCKED:
> +		/* typically happens when refreshing hardware state,
> +		 * such as on resume */
> +		state = RFKILL_STATE_SOFT_BLOCKED;
> +		break;
> +	case RFKILL_STATE_UNBLOCKED:
> +		/* force can't override this, only rfkill_force_state() can */
> +		if (rfkill->state == RFKILL_STATE_HARD_BLOCKED)
> +			return -EPERM;
> +		break;
> +	case RFKILL_STATE_SOFT_BLOCKED:
> +		/* nothing to do, we want to give drivers the hint to double
> +		 * BLOCK even a transmitter that is already in state
> +		 * RFKILL_STATE_HARD_BLOCKED */
> +		break;
> +	}
> +
>  	if (force || state != rfkill->state) {
>  		retval = rfkill->toggle_radio(rfkill->data, state);
> -		if (!retval)
> +		/* never allow a HARD->SOFT downgrade! */
> +		if (!retval && rfkill->state != RFKILL_STATE_HARD_BLOCKED)
>  			rfkill->state = state;
>  	}
>  
> @@ -184,7 +225,7 @@ EXPORT_SYMBOL(rfkill_switch_all);
>  /**
>   * rfkill_epo - emergency power off all transmitters
>   *
> - * This kicks all rfkill devices to RFKILL_STATE_OFF, ignoring
> + * This kicks all rfkill devices to RFKILL_STATE_SOFT_BLOCKED, ignoring
>   * everything in its path but rfkill_mutex.
>   */
>  void rfkill_epo(void)
> @@ -193,7 +234,7 @@ void rfkill_epo(void)
>  
>  	mutex_lock(&rfkill_mutex);
>  	list_for_each_entry(rfkill, &rfkill_list, node) {
> -		rfkill_toggle_radio(rfkill, RFKILL_STATE_OFF, 1);
> +		rfkill_toggle_radio(rfkill, RFKILL_STATE_SOFT_BLOCKED, 1);
>  	}
>  	mutex_unlock(&rfkill_mutex);
>  }
> @@ -215,8 +256,9 @@ int rfkill_force_state(struct rfkill *rfkill, enum rfkill_state state)
>  {
>  	enum rfkill_state oldstate;
>  
> -	if (state != RFKILL_STATE_OFF &&
> -	    state != RFKILL_STATE_ON)
> +	if (state != RFKILL_STATE_SOFT_BLOCKED &&
> +	    state != RFKILL_STATE_UNBLOCKED &&
> +	    state != RFKILL_STATE_HARD_BLOCKED)
>  		return -EINVAL;
>  
>  	mutex_lock(&rfkill->mutex);
> @@ -290,11 +332,14 @@ static ssize_t rfkill_state_store(struct device *dev,
>  	if (!capable(CAP_NET_ADMIN))
>  		return -EPERM;
>  
> +	/* RFKILL_STATE_HARD_BLOCKED is illegal here... */
> +	if (state != RFKILL_STATE_UNBLOCKED &&
> +	    state != RFKILL_STATE_SOFT_BLOCKED)
> +		return -EINVAL;
> +
>  	if (mutex_lock_interruptible(&rfkill->mutex))
>  		return -ERESTARTSYS;
> -	error = rfkill_toggle_radio(rfkill,
> -			state ? RFKILL_STATE_ON : RFKILL_STATE_OFF,
> -			0);
> +	error = rfkill_toggle_radio(rfkill, state, 0);
>  	mutex_unlock(&rfkill->mutex);
>  
>  	return error ? error : count;
> @@ -373,7 +418,8 @@ static int rfkill_suspend(struct device *dev, pm_message_t state)
>  			update_rfkill_state(rfkill);
>  
>  			mutex_lock(&rfkill->mutex);
> -			rfkill->toggle_radio(rfkill->data, RFKILL_STATE_OFF);
> +			rfkill->toggle_radio(rfkill->data,
> +						RFKILL_STATE_SOFT_BLOCKED);
>  			mutex_unlock(&rfkill->mutex);
>  		}
>  
> @@ -470,7 +516,7 @@ static void rfkill_remove_switch(struct rfkill *rfkill)
>  {
>  	mutex_lock(&rfkill_mutex);
>  	list_del_init(&rfkill->node);
> -	rfkill_toggle_radio(rfkill, RFKILL_STATE_OFF, 1);
> +	rfkill_toggle_radio(rfkill, RFKILL_STATE_SOFT_BLOCKED, 1);
>  	mutex_unlock(&rfkill_mutex);
>  }
>  
> @@ -610,8 +656,9 @@ static int __init rfkill_init(void)
>  	int error;
>  	int i;
>  
> -	if (rfkill_default_state != RFKILL_STATE_OFF &&
> -	    rfkill_default_state != RFKILL_STATE_ON)
> +	/* RFKILL_STATE_HARD_BLOCKED is illegal here... */
> +	if (rfkill_default_state != RFKILL_STATE_SOFT_BLOCKED &&
> +	    rfkill_default_state != RFKILL_STATE_UNBLOCKED)
>  		return -EINVAL;
>  
>  	for (i = 0; i < ARRAY_SIZE(rfkill_states); i++)


