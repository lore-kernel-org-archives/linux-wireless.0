Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.180]:25680 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbYHCHl5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 03:41:57 -0400
Received: by ik-out-1112.google.com with SMTP id c28so1998200ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2008 00:41:56 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 2/8] rfkill: add default global states (v2)
Date: Sun, 3 Aug 2008 10:05:16 +0200
Cc: linux-wireless@vger.kernel.org
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <1217700664-20792-3-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1217700664-20792-3-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808031005.16559.IvDoorn@gmail.com> (sfid-20080803_094200_418109_0178BB40)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 02 August 2008, Henrique de Moraes Holschuh wrote:
> Add a second set of global states, "rfkill_default_states", to track the
> state that will be used when the first rfkill class of a given type is
> registered, and also to save "undo" information when rfkill_epo is called.
> 
> Add a new exported function, rfkill_set_default(), which can be used by
> platform drivers to restore radio state saved by the platform across
> reboots or shutdown.
> 
> Also, fix rfkill_epo to properly update rfkill_states, but still preserve a
> copy of the state so that we can undo the effect of rfkill_epo later if we
> want to.  Add rfkill_restore_states() to restore rfkill_states from the
> copy.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  include/linux/rfkill.h    |    1 +
>  net/rfkill/rfkill-input.h |    1 +
>  net/rfkill/rfkill.c       |  127 ++++++++++++++++++++++++++++++++++++++++----
>  3 files changed, 117 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> index 741d1a6..aa3c7d5 100644
> --- a/include/linux/rfkill.h
> +++ b/include/linux/rfkill.h
> @@ -116,6 +116,7 @@ int rfkill_register(struct rfkill *rfkill);
>  void rfkill_unregister(struct rfkill *rfkill);
>  
>  int rfkill_force_state(struct rfkill *rfkill, enum rfkill_state state);
> +int rfkill_set_default(enum rfkill_type type, enum rfkill_state state);
>  
>  /**
>   * rfkill_state_complement - return complementar state
> diff --git a/net/rfkill/rfkill-input.h b/net/rfkill/rfkill-input.h
> index f63d050..bbfa646 100644
> --- a/net/rfkill/rfkill-input.h
> +++ b/net/rfkill/rfkill-input.h
> @@ -13,5 +13,6 @@
>  
>  void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state);
>  void rfkill_epo(void);
> +void rfkill_restore_states(void);
>  
>  #endif /* __RFKILL_INPUT_H */
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index 297bfd5..c1901fb 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -44,7 +44,13 @@ module_param_named(default_state, rfkill_default_state, uint, 0444);
>  MODULE_PARM_DESC(default_state,
>  		 "Default initial state for all radio types, 0 = radio off");
>  
> -static enum rfkill_state rfkill_states[RFKILL_TYPE_MAX];
> +struct rfkill_gsw_state {
> +	enum rfkill_state current_state;
> +	enum rfkill_state default_state;
> +};
> +
> +static struct rfkill_gsw_state rfkill_global_states[RFKILL_TYPE_MAX];
> +static unsigned long rfkill_states_lockdflt[BITS_TO_LONGS(RFKILL_TYPE_MAX)];
>  
>  static BLOCKING_NOTIFIER_HEAD(rfkill_notifier_list);
>  
> @@ -213,22 +219,22 @@ static int rfkill_toggle_radio(struct rfkill *rfkill,
>  }
>  
>  /**
> - * rfkill_switch_all - Toggle state of all switches of given type
> + * __rfkill_switch_all - Toggle state of all switches of given type
>   * @type: type of interfaces to be affected
>   * @state: the new state
>   *
>   * This function toggles the state of all switches of given type,
>   * unless a specific switch is claimed by userspace (in which case,
>   * that switch is left alone) or suspended.
> + *
> + * Caller must have acquired rfkill_mutex.
>   */
> -void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
> +static void __rfkill_switch_all(const enum rfkill_type type,
> +				const enum rfkill_state state)
>  {
>  	struct rfkill *rfkill;
>  
> -	mutex_lock(&rfkill_mutex);
> -
> -	rfkill_states[type] = state;
> -
> +	rfkill_global_states[type].current_state = state;
>  	list_for_each_entry(rfkill, &rfkill_list, node) {
>  		if ((!rfkill->user_claim) && (rfkill->type == type)) {
>  			mutex_lock(&rfkill->mutex);
> @@ -236,7 +242,20 @@ void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
>  			mutex_unlock(&rfkill->mutex);
>  		}
>  	}
> +}
>  
> +/**
> + * rfkill_switch_all - Toggle state of all switches of given type
> + * @type: type of interfaces to be affected
> + * @state: the new state
> + *
> + * Acquires rfkill_mutex and calls __rfkill_switch_all(@type, @state).
> + * Please refer to __rfkill_switch_all() for details.
> + */
> +void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
> +{
> +	mutex_lock(&rfkill_mutex);
> +	__rfkill_switch_all(type, state);
>  	mutex_unlock(&rfkill_mutex);
>  }
>  EXPORT_SYMBOL(rfkill_switch_all);
> @@ -246,10 +265,14 @@ EXPORT_SYMBOL(rfkill_switch_all);
>   *
>   * This kicks all non-suspended rfkill devices to RFKILL_STATE_SOFT_BLOCKED,
>   * ignoring everything in its path but rfkill_mutex and rfkill->mutex.
> + *
> + * The global state before the EPO is saved and can be restored later
> + * using rfkill_restore_states().
>   */
>  void rfkill_epo(void)
>  {
>  	struct rfkill *rfkill;
> +	int i;
>  
>  	mutex_lock(&rfkill_mutex);
>  	list_for_each_entry(rfkill, &rfkill_list, node) {
> @@ -257,11 +280,35 @@ void rfkill_epo(void)
>  		rfkill_toggle_radio(rfkill, RFKILL_STATE_SOFT_BLOCKED, 1);
>  		mutex_unlock(&rfkill->mutex);
>  	}
> +	for (i = 0; i < RFKILL_TYPE_MAX; i++) {
> +		rfkill_global_states[i].default_state =
> +				rfkill_global_states[i].current_state;
> +		rfkill_global_states[i].current_state =
> +				RFKILL_STATE_SOFT_BLOCKED;
> +	}
>  	mutex_unlock(&rfkill_mutex);
>  }
>  EXPORT_SYMBOL_GPL(rfkill_epo);
>  
>  /**
> + * rfkill_restore_states - restore global states
> + *
> + * Restore (and sync switches to) the global state from the
> + * states in rfkill_default_states.  This can undo the effects of
> + * a call to rfkill_epo().
> + */
> +void rfkill_restore_states(void)
> +{
> +	int i;
> +
> +	mutex_lock(&rfkill_mutex);
> +	for (i = 0; i < RFKILL_TYPE_MAX; i++)
> +		__rfkill_switch_all(i, rfkill_global_states[i].default_state);
> +	mutex_unlock(&rfkill_mutex);
> +}
> +EXPORT_SYMBOL_GPL(rfkill_restore_states);
> +
> +/**
>   * rfkill_force_state - Force the internal rfkill radio state
>   * @rfkill: pointer to the rfkill class to modify.
>   * @state: the current radio state the class should be forced to.
> @@ -414,8 +461,8 @@ static ssize_t rfkill_claim_store(struct device *dev,
>  		if (!claim) {
>  			mutex_lock(&rfkill->mutex);
>  			rfkill_toggle_radio(rfkill,
> -					    rfkill_states[rfkill->type],
> -					    0);
> +					rfkill_global_states[rfkill->type].current_state,
> +					0);
>  			mutex_unlock(&rfkill->mutex);
>  		}
>  		rfkill->user_claim = !!claim;
> @@ -562,7 +609,16 @@ static int rfkill_add_switch(struct rfkill *rfkill)
>  	if (error < 0)
>  		goto unlock_out;
>  
> -	rfkill_toggle_radio(rfkill, rfkill_states[rfkill->type], 0);
> +	if (!error) {
> +		/* lock default after first use */
> +		set_bit(rfkill->type, rfkill_states_lockdflt);
> +		rfkill_global_states[rfkill->type].current_state =
> +			rfkill_global_states[rfkill->type].default_state;
> +	}
> +
> +	rfkill_toggle_radio(rfkill,
> +			    rfkill_global_states[rfkill->type].current_state,
> +			    0);
>  
>  	list_add_tail(&rfkill->node, &rfkill_list);
>  
> @@ -718,6 +774,53 @@ void rfkill_unregister(struct rfkill *rfkill)
>  }
>  EXPORT_SYMBOL(rfkill_unregister);
>  
> +/**
> + * rfkill_set_default - set initial value for a switch type
> + * @type - the type of switch to set the default state of
> + * @state - the new default state for that group of switches
> + *
> + * Sets the initial state rfkill should use for a given type.
> + * The following initial states are allowed: RFKILL_STATE_SOFT_BLOCKED
> + * and RFKILL_STATE_UNBLOCKED.
> + *
> + * This function is meant to be used by platform drivers for platforms
> + * that can save switch state across power down/reboot.
> + *
> + * The default state for each switch type can be changed exactly once.
> + * After a switch of that type is registered, the default state cannot
> + * be changed anymore.  This guards against multiple drivers it the
> + * same platform trying to set the initial switch default state, which
> + * is not allowed.
> + *
> + * Returns -EPERM if the state has already been set once or is in use,
> + * so drivers likely want to either ignore or at most printk(KERN_NOTICE)
> + * if this function returns -EPERM.
> + *
> + * Returns 0 if the new default state was set, or an error if it
> + * could not be set.
> + */
> +int rfkill_set_default(enum rfkill_type type, enum rfkill_state state)
> +{
> +	int error;
> +
> +	if (type >= RFKILL_TYPE_MAX ||
> +	    (state != RFKILL_STATE_SOFT_BLOCKED &&
> +	     state != RFKILL_STATE_UNBLOCKED))
> +		return -EINVAL;
> +
> +	mutex_lock(&rfkill_mutex);
> +
> +	if (!test_and_set_bit(type, rfkill_states_lockdflt)) {
> +		rfkill_global_states[type].default_state = state;
> +		error = 0;
> +	} else
> +		error = -EPERM;
> +
> +	mutex_unlock(&rfkill_mutex);
> +	return error;
> +}
> +EXPORT_SYMBOL_GPL(rfkill_set_default);
> +
>  /*
>   * Rfkill module initialization/deinitialization.
>   */
> @@ -731,8 +834,8 @@ static int __init rfkill_init(void)
>  	    rfkill_default_state != RFKILL_STATE_UNBLOCKED)
>  		return -EINVAL;
>  
> -	for (i = 0; i < ARRAY_SIZE(rfkill_states); i++)
> -		rfkill_states[i] = rfkill_default_state;
> +	for (i = 0; i < RFKILL_TYPE_MAX; i++)
> +		rfkill_global_states[i].default_state = rfkill_default_state;
>  
>  	error = class_register(&rfkill_class);
>  	if (error) {


