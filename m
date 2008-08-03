Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.182]:24106 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbYHCHo2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 03:44:28 -0400
Received: by ik-out-1112.google.com with SMTP id c28so1999228ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2008 00:44:26 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 5/8] rfkill: add WARN_ON and BUG_ON paranoia
Date: Sun, 3 Aug 2008 10:07:48 +0200
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <1217700664-20792-6-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1217700664-20792-6-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808031007.48877.IvDoorn@gmail.com> (sfid-20080803_094430_628457_3EA44FC7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 02 August 2008, Henrique de Moraes Holschuh wrote:
> BUG_ON and WARN_ON the heck out of buggy drivers calling into the rfkill
> subsystem.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/rfkill/rfkill.c |   33 +++++++++++++++++++++++++--------
>  1 files changed, 25 insertions(+), 8 deletions(-)
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index ea872e5..d5f95cb 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -76,6 +76,7 @@ static BLOCKING_NOTIFIER_HEAD(rfkill_notifier_list);
>   */
>  int register_rfkill_notifier(struct notifier_block *nb)
>  {
> +	BUG_ON(!nb);

Probably better:

	if (unlikely(!nb) {
		BUG()
		return -EINVAL;
	}

>  	return blocking_notifier_chain_register(&rfkill_notifier_list, nb);
>  }
>  EXPORT_SYMBOL_GPL(register_rfkill_notifier);
> @@ -91,6 +92,7 @@ EXPORT_SYMBOL_GPL(register_rfkill_notifier);
>   */
>  int unregister_rfkill_notifier(struct notifier_block *nb)
>  {
> +	BUG_ON(!nb);

	if (unlikely(!nb) {
		BUG()
		return -EINVAL;
	}

>  	return blocking_notifier_chain_unregister(&rfkill_notifier_list, nb);
>  }
>  EXPORT_SYMBOL_GPL(unregister_rfkill_notifier);
> @@ -202,6 +204,7 @@ static int rfkill_toggle_radio(struct rfkill *rfkill,
>  		 * RFKILL_STATE_HARD_BLOCKED */
>  		break;
>  	default:
> +		WARN_ON(1);
>  		return -EINVAL;
>  	}
>  
> @@ -236,8 +239,10 @@ static void __rfkill_switch_all(const enum rfkill_type type,
>  {
>  	struct rfkill *rfkill;
>  
> -	if (unlikely(state >= RFKILL_STATE_MAX))
> +	if (unlikely(state >= RFKILL_STATE_MAX || type >= RFKILL_TYPE_MAX)) {
> +		WARN_ON(1);
>  		return;
> +	}
>  
>  	rfkill_global_states[type].current_state = state;
>  	list_for_each_entry(rfkill, &rfkill_list, node) {
> @@ -334,8 +339,11 @@ int rfkill_force_state(struct rfkill *rfkill, enum rfkill_state state)
>  {
>  	enum rfkill_state oldstate;
>  
> -	if (unlikely(state >= RFKILL_STATE_MAX))
> +	BUG_ON(!rfkill);

	if (unlikely(!rfkill) {
		BUG()
		return -EINVAL;
	}

> +	if (unlikely(state >= RFKILL_STATE_MAX)) {
> +		WARN_ON(1);
>  		return -EINVAL;
> +	}
>  
>  	mutex_lock(&rfkill->mutex);
>  
> @@ -662,6 +670,11 @@ struct rfkill * __must_check rfkill_allocate(struct device *parent,
>  	struct rfkill *rfkill;
>  	struct device *dev;
>  
> +	if (type >= RFKILL_TYPE_MAX) {
> +		WARN_ON(1);
> +		return NULL;
> +	}
> +
>  	rfkill = kzalloc(sizeof(struct rfkill), GFP_KERNEL);
>  	if (!rfkill)
>  		return NULL;
> @@ -734,12 +747,13 @@ int __must_check rfkill_register(struct rfkill *rfkill)
>  	struct device *dev = &rfkill->dev;
>  	int error;
>  
> -	if (!rfkill->toggle_radio)
> -		return -EINVAL;
> -	if (rfkill->type >= RFKILL_TYPE_MAX)
> -		return -EINVAL;
> -	if (rfkill->state >= RFKILL_STATE_MAX)
> +	if (unlikely(!rfkill ||
> +		     !rfkill->toggle_radio ||
> +		     rfkill->type >= RFKILL_TYPE_MAX ||
> +		     rfkill->state >= RFKILL_STATE_MAX)) {
> +		WARN_ON(1);
>  		return -EINVAL;
> +	}
>  
>  	snprintf(dev->bus_id, sizeof(dev->bus_id),
>  		 "rfkill%ld", (long)atomic_inc_return(&rfkill_no) - 1);
> @@ -773,6 +787,7 @@ EXPORT_SYMBOL(rfkill_register);
>   */
>  void rfkill_unregister(struct rfkill *rfkill)
>  {
> +	BUG_ON(!rfkill);

	if (unlikely(!rfkill) {
		BUG()
		return -EINVAL;
	}

>  	device_del(&rfkill->dev);
>  	rfkill_remove_switch(rfkill);
>  	rfkill_led_trigger_unregister(rfkill);
> @@ -811,8 +826,10 @@ int rfkill_set_default(enum rfkill_type type, enum rfkill_state state)
>  
>  	if (type >= RFKILL_TYPE_MAX ||
>  	    (state != RFKILL_STATE_SOFT_BLOCKED &&
> -	     state != RFKILL_STATE_UNBLOCKED))
> +	     state != RFKILL_STATE_UNBLOCKED)) {
> +		WARN_ON(1);
>  		return -EINVAL;
> +	}
>  
>  	mutex_lock(&rfkill_mutex);
>  


