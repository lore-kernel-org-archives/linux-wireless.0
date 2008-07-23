Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:5106 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbYGWS1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 14:27:32 -0400
Received: by nf-out-0910.google.com with SMTP id d3so932985nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 11:27:32 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] rfkill: rename rfkill_mutex to rfkill_global_mutex
Date: Wed, 23 Jul 2008 20:44:46 +0200
Cc: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br> <1216775046-9506-6-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1216775046-9506-6-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807232044.47129.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 July 2008, Henrique de Moraes Holschuh wrote:
> rfkill_mutex and rfkill->mutex are too easy to confuse with each other.
> 
> Rename rfkill_mutex to rfkill_global_mutex, so that they are easier to tell
> apart with just one glance.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Michael Buesch <mb@bu3sch.de>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  net/rfkill/rfkill.c |   40 ++++++++++++++++++++--------------------
>  1 files changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index 2265bc5..d6e16e1 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -37,7 +37,7 @@ MODULE_DESCRIPTION("RF switch support");
>  MODULE_LICENSE("GPL");
>  
>  static LIST_HEAD(rfkill_list);	/* list of registered rf switches */
> -static DEFINE_MUTEX(rfkill_mutex);
> +static DEFINE_MUTEX(rfkill_global_mutex);
>  
>  static unsigned int rfkill_default_state = RFKILL_STATE_UNBLOCKED;
>  module_param_named(default_state, rfkill_default_state, uint, 0444);
> @@ -209,7 +209,7 @@ static int rfkill_toggle_radio(struct rfkill *rfkill,
>   * unless a specific switch is claimed by userspace (in which case,
>   * that switch is left alone).
>   *
> - * Caller must have acquired rfkill_mutex.
> + * Caller must have acquired rfkill_global_mutex.
>   */
>  static void __rfkill_switch_all(const enum rfkill_type type,
>  				const enum rfkill_state state)
> @@ -231,7 +231,7 @@ static void __rfkill_switch_all(const enum rfkill_type type,
>   * @type: type of interfaces to be affected
>   * @state: the new state
>   *
> - * Acquires rfkill_mutex and calls __rfkill_switch_all(@type, @state).
> + * Acquires rfkill_global_mutex and calls __rfkill_switch_all(@type, @state).
>   * Please refer to __rfkill_switch_all() for details.
>   *
>   * Does nothing if rfkill_set_state_lock() was used to lock state
> @@ -239,10 +239,10 @@ static void __rfkill_switch_all(const enum rfkill_type type,
>   */
>  void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
>  {
> -	mutex_lock(&rfkill_mutex);
> +	mutex_lock(&rfkill_global_mutex);
>  	if (!rfkill_state_lock)
>  		__rfkill_switch_all(type, state);
> -	mutex_unlock(&rfkill_mutex);
> +	mutex_unlock(&rfkill_global_mutex);
>  }
>  EXPORT_SYMBOL(rfkill_switch_all);
>  
> @@ -250,7 +250,7 @@ EXPORT_SYMBOL(rfkill_switch_all);
>   * rfkill_epo - emergency power off all transmitters
>   *
>   * This kicks all rfkill devices to RFKILL_STATE_SOFT_BLOCKED, ignoring
> - * everything in its path but rfkill_mutex and rfkill->mutex.
> + * everything in its path but rfkill_global_mutex and rfkill->mutex.
>   *
>   * The global state before the EPO is saved and can be restored later
>   * using rfkill_restore_states().
> @@ -260,7 +260,7 @@ void rfkill_epo(void)
>  	struct rfkill *rfkill;
>  	int i;
>  
> -	mutex_lock(&rfkill_mutex);
> +	mutex_lock(&rfkill_global_mutex);
>  
>  	rfkill_state_lock = 1;
>  	list_for_each_entry(rfkill, &rfkill_list, node) {
> @@ -272,7 +272,7 @@ void rfkill_epo(void)
>  		rfkill_default_states[i] = rfkill_states[i];
>  		rfkill_states[i] = RFKILL_STATE_SOFT_BLOCKED;
>  	}
> -	mutex_unlock(&rfkill_mutex);
> +	mutex_unlock(&rfkill_global_mutex);
>  }
>  EXPORT_SYMBOL_GPL(rfkill_epo);
>  
> @@ -287,12 +287,12 @@ void rfkill_restore_states(void)
>  {
>  	int i;
>  
> -	mutex_lock(&rfkill_mutex);
> +	mutex_lock(&rfkill_global_mutex);
>  
>  	rfkill_state_lock = 0;
>  	for (i = 0; i < RFKILL_TYPE_MAX; i++)
>  		__rfkill_switch_all(i, rfkill_default_states[i]);
> -	mutex_unlock(&rfkill_mutex);
> +	mutex_unlock(&rfkill_global_mutex);
>  }
>  EXPORT_SYMBOL_GPL(rfkill_restore_states);
>  
> @@ -306,9 +306,9 @@ EXPORT_SYMBOL_GPL(rfkill_restore_states);
>   */
>  void rfkill_set_state_lock(int lock)
>  {
> -	mutex_lock(&rfkill_mutex);
> +	mutex_lock(&rfkill_global_mutex);
>  	rfkill_state_lock = !!lock;
> -	mutex_unlock(&rfkill_mutex);
> +	mutex_unlock(&rfkill_global_mutex);
>  }
>  EXPORT_SYMBOL_GPL(rfkill_set_state_lock);
>  
> @@ -454,7 +454,7 @@ static ssize_t rfkill_claim_store(struct device *dev,
>  	 * Take the global lock to make sure the kernel is not in
>  	 * the middle of rfkill_switch_all
>  	 */
> -	error = mutex_lock_interruptible(&rfkill_mutex);
> +	error = mutex_lock_interruptible(&rfkill_global_mutex);
>  	if (error)
>  		return error;
>  
> @@ -469,7 +469,7 @@ static ssize_t rfkill_claim_store(struct device *dev,
>  		rfkill->user_claim = claim;
>  	}
>  
> -	mutex_unlock(&rfkill_mutex);
> +	mutex_unlock(&rfkill_global_mutex);
>  
>  	return error ? error : count;
>  }
> @@ -601,7 +601,7 @@ static int rfkill_add_switch(struct rfkill *rfkill)
>  {
>  	int error;
>  
> -	mutex_lock(&rfkill_mutex);
> +	mutex_lock(&rfkill_global_mutex);
>  
>  	error = rfkill_check_duplicity(rfkill);
>  	if (error < 0)
> @@ -620,16 +620,16 @@ static int rfkill_add_switch(struct rfkill *rfkill)
>  
>  	error = 0;
>  unlock_out:
> -	mutex_unlock(&rfkill_mutex);
> +	mutex_unlock(&rfkill_global_mutex);
>  
>  	return error;
>  }
>  
>  static void rfkill_remove_switch(struct rfkill *rfkill)
>  {
> -	mutex_lock(&rfkill_mutex);
> +	mutex_lock(&rfkill_global_mutex);
>  	list_del_init(&rfkill->node);
> -	mutex_unlock(&rfkill_mutex);
> +	mutex_unlock(&rfkill_global_mutex);
>  
>  	mutex_lock(&rfkill->mutex);
>  	rfkill_toggle_radio(rfkill, RFKILL_STATE_SOFT_BLOCKED, 1);
> @@ -797,7 +797,7 @@ int rfkill_set_default(enum rfkill_type type, enum rfkill_state state)
>  	     state != RFKILL_STATE_UNBLOCKED))
>  		return -EINVAL;
>  
> -	mutex_lock(&rfkill_mutex);
> +	mutex_lock(&rfkill_global_mutex);
>  
>  	if (!test_and_set_bit(type, &rfkill_states_lockdflt)) {
>  		rfkill_default_states[type] = state;
> @@ -805,7 +805,7 @@ int rfkill_set_default(enum rfkill_type type, enum rfkill_state state)
>  	} else
>  		error = -EPERM;
>  
> -	mutex_unlock(&rfkill_mutex);
> +	mutex_unlock(&rfkill_global_mutex);
>  	return error;
>  }
>  EXPORT_SYMBOL_GPL(rfkill_set_default);


