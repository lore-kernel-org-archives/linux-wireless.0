Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.179]:54078 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436AbYHZP4R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2008 11:56:17 -0400
Received: by ik-out-1112.google.com with SMTP id c28so1787674ika.5
        for <linux-wireless@vger.kernel.org>; Tue, 26 Aug 2008 08:56:16 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 3/5] rfkill: add WARN and BUG_ON paranoia (v2)
Date: Tue, 26 Aug 2008 17:56:06 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <1219762681-26911-1-git-send-email-hmh@hmh.eng.br> <1219762681-26911-4-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1219762681-26911-4-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808261756.06759.IvDoorn@gmail.com> (sfid-20080826_175622_001711_679EFC07)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 26 August 2008, Henrique de Moraes Holschuh wrote:
> BUG_ON() and WARN() the heck out of buggy drivers calling into the rfkill
> subsystem.
> 
> Also switch from WARN_ON(1) to the new descriptive WARN().

The below usage of WARN() were correct when used as WARN_ON(),
(I only complained about the litteral WARN_ON(1) usage.
But apparently the WARN arguments are now the same as WARN_ON(),
so I have no objections against this patch.
 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  net/rfkill/rfkill.c |   50 +++++++++++++++++++++++++++++++++++++-------------
>  1 files changed, 37 insertions(+), 13 deletions(-)
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index b630f35..910699c 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -76,6 +76,7 @@ static BLOCKING_NOTIFIER_HEAD(rfkill_notifier_list);
>   */
>  int register_rfkill_notifier(struct notifier_block *nb)
>  {
> +	BUG_ON(!nb);
>  	return blocking_notifier_chain_register(&rfkill_notifier_list, nb);
>  }
>  EXPORT_SYMBOL_GPL(register_rfkill_notifier);
> @@ -91,6 +92,7 @@ EXPORT_SYMBOL_GPL(register_rfkill_notifier);
>   */
>  int unregister_rfkill_notifier(struct notifier_block *nb)
>  {
> +	BUG_ON(!nb);
>  	return blocking_notifier_chain_unregister(&rfkill_notifier_list, nb);
>  }
>  EXPORT_SYMBOL_GPL(unregister_rfkill_notifier);
> @@ -202,6 +204,9 @@ static int rfkill_toggle_radio(struct rfkill *rfkill,
>  		 * RFKILL_STATE_HARD_BLOCKED */
>  		break;
>  	default:
> +		WARN(1, KERN_WARNING
> +			"rfkill: illegal state %d passed as parameter "
> +			"to rfkill_toggle_radio\n", state);
>  		return -EINVAL;
>  	}
>  
> @@ -236,7 +241,11 @@ static void __rfkill_switch_all(const enum rfkill_type type,
>  {
>  	struct rfkill *rfkill;
>  
> -	if (unlikely(state >= RFKILL_STATE_MAX))
> +	if (WARN((state >= RFKILL_STATE_MAX || type >= RFKILL_TYPE_MAX),
> +			KERN_WARNING
> +			"rfkill: illegal state %d or type %d "
> +			"passed as parameter to __rfkill_switch_all\n",
> +			state, type))
>  		return;
>  
>  	rfkill_global_states[type].current_state = state;
> @@ -334,7 +343,11 @@ int rfkill_force_state(struct rfkill *rfkill, enum rfkill_state state)
>  {
>  	enum rfkill_state oldstate;
>  
> -	if (unlikely(state >= RFKILL_STATE_MAX))
> +	BUG_ON(!rfkill);
> +	if (WARN((state >= RFKILL_STATE_MAX),
> +			KERN_WARNING
> +			"rfkill: illegal state %d passed as parameter "
> +			"to rfkill_force_state\n", state))
>  		return -EINVAL;
>  
>  	mutex_lock(&rfkill->mutex);
> @@ -593,10 +606,10 @@ static int rfkill_check_duplicity(const struct rfkill *rfkill)
>  	memset(seen, 0, sizeof(seen));
>  
>  	list_for_each_entry(p, &rfkill_list, node) {
> -		if (p == rfkill) {
> -			WARN_ON(1);
> +		if (WARN((p == rfkill), KERN_WARNING
> +				"rfkill: illegal attempt to register "
> +				"an already registered rfkill struct\n"))
>  			return -EEXIST;
> -		}
>  		set_bit(p->type, seen);
>  	}
>  
> @@ -664,6 +677,12 @@ struct rfkill * __must_check rfkill_allocate(struct device *parent,
>  	struct rfkill *rfkill;
>  	struct device *dev;
>  
> +	if (WARN((type >= RFKILL_TYPE_MAX),
> +			KERN_WARNING
> +			"rfkill: illegal type %d passed as parameter "
> +			"to rfkill_allocate\n", type))
> +		return NULL;
> +
>  	rfkill = kzalloc(sizeof(struct rfkill), GFP_KERNEL);
>  	if (!rfkill)
>  		return NULL;
> @@ -736,11 +755,12 @@ int __must_check rfkill_register(struct rfkill *rfkill)
>  	struct device *dev = &rfkill->dev;
>  	int error;
>  
> -	if (!rfkill->toggle_radio)
> -		return -EINVAL;
> -	if (rfkill->type >= RFKILL_TYPE_MAX)
> -		return -EINVAL;
> -	if (rfkill->state >= RFKILL_STATE_MAX)
> +	if (WARN((!rfkill || !rfkill->toggle_radio ||
> +			rfkill->type >= RFKILL_TYPE_MAX ||
> +			rfkill->state >= RFKILL_STATE_MAX),
> +			KERN_WARNING
> +			"rfkill: attempt to register a "
> +			"badly initialized rfkill struct\n"))
>  		return -EINVAL;
>  
>  	snprintf(dev->bus_id, sizeof(dev->bus_id),
> @@ -775,6 +795,7 @@ EXPORT_SYMBOL(rfkill_register);
>   */
>  void rfkill_unregister(struct rfkill *rfkill)
>  {
> +	BUG_ON(!rfkill);
>  	device_del(&rfkill->dev);
>  	rfkill_remove_switch(rfkill);
>  	rfkill_led_trigger_unregister(rfkill);
> @@ -811,9 +832,12 @@ int rfkill_set_default(enum rfkill_type type, enum rfkill_state state)
>  {
>  	int error;
>  
> -	if (type >= RFKILL_TYPE_MAX ||
> -	    (state != RFKILL_STATE_SOFT_BLOCKED &&
> -	     state != RFKILL_STATE_UNBLOCKED))
> +	if (WARN((type >= RFKILL_TYPE_MAX ||
> +			(state != RFKILL_STATE_SOFT_BLOCKED &&
> +			 state != RFKILL_STATE_UNBLOCKED)),
> +			KERN_WARNING
> +			"rfkill: illegal state %d or type %d passed as "
> +			"parameter to rfkill_set_default\n", state, type))
>  		return -EINVAL;
>  
>  	mutex_lock(&rfkill_mutex);


