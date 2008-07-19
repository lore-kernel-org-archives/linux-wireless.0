Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:8503 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714AbYGSMcq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 08:32:46 -0400
Received: by nf-out-0910.google.com with SMTP id d3so242258nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2008 05:32:44 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 4/4] rfkill: mutex fixes
Date: Sat, 19 Jul 2008 14:47:25 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1216150327-10904-1-git-send-email-hmh@hmh.eng.br> <1216150327-10904-5-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1216150327-10904-5-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807191447.25603.IvDoorn@gmail.com> (sfid-20080719_143310_373967_1C799BED)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 15 July 2008, Henrique de Moraes Holschuh wrote:
> There are two mutexes in rfkill:
> 
> rfkill->mutex, which protects some of the fields of a rfkill struct, and is
> also used for callback serialization.
> 
> rfkill_mutex, which protects the global state, the list of registered
> rfkill structs and rfkill->claim.
> 
> Make sure to use the correct mutex, and to not miss locking rfkill->mutex
> even when we already took rfkill_mutex.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> ---
>  net/rfkill/rfkill.c |   29 +++++++++++++++++++----------
>  1 files changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index fc3a4fd..ac205ec 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -150,7 +150,7 @@ static void update_rfkill_state(struct rfkill *rfkill)
>   * even if the radio is in RFKILL_STATE_HARD_BLOCKED state, so as to
>   * give the driver a hint that it should double-BLOCK the transmitter.
>   *
> - * Caller must have aquired rfkill_mutex.
> + * Caller must have acquired rfkill->mutex.

Should rfkill_toggle_radio() not grab the rfkill->mutex itself?
At the moment every caller to rfkill_toggle_radio() does:

			mutex_lock(&rfkill->mutex);
 			rfkill_toggle_radio(rfkill, state, 0);
			mutex_unlock(&rfkill->mutex);

without anything in between, so perhaps the safest way would be moving
the locking requirement into the function.

>   */
>  static int rfkill_toggle_radio(struct rfkill *rfkill,
>  				enum rfkill_state state,
> @@ -216,8 +216,11 @@ void rfkill_switch_all(enum rfkill_type type, enum rfkill_state state)
>  	rfkill_states[type] = state;
>  
>  	list_for_each_entry(rfkill, &rfkill_list, node) {
> -		if ((!rfkill->user_claim) && (rfkill->type == type))
> +		if ((!rfkill->user_claim) && (rfkill->type == type)) {
> +			mutex_lock(&rfkill->mutex);
>  			rfkill_toggle_radio(rfkill, state, 0);
> +			mutex_unlock(&rfkill->mutex);
> +		}
>  	}
>  
>  	mutex_unlock(&rfkill_mutex);
> @@ -228,7 +231,7 @@ EXPORT_SYMBOL(rfkill_switch_all);
>   * rfkill_epo - emergency power off all transmitters
>   *
>   * This kicks all rfkill devices to RFKILL_STATE_SOFT_BLOCKED, ignoring
> - * everything in its path but rfkill_mutex.
> + * everything in its path but rfkill_mutex and rfkill->mutex.
>   */
>  void rfkill_epo(void)
>  {
> @@ -236,7 +239,9 @@ void rfkill_epo(void)
>  
>  	mutex_lock(&rfkill_mutex);
>  	list_for_each_entry(rfkill, &rfkill_list, node) {
> +		mutex_lock(&rfkill->mutex);
>  		rfkill_toggle_radio(rfkill, RFKILL_STATE_SOFT_BLOCKED, 1);
> +		mutex_unlock(&rfkill->mutex);
>  	}
>  	mutex_unlock(&rfkill_mutex);
>  }
> @@ -372,6 +377,9 @@ static ssize_t rfkill_claim_store(struct device *dev,
>  	if (!capable(CAP_NET_ADMIN))
>  		return -EPERM;
>  
> +	if (rfkill->user_claim_unsupported)
> +		return -EOPNOTSUPP;
> +
>  	/*
>  	 * Take the global lock to make sure the kernel is not in
>  	 * the middle of rfkill_switch_all
> @@ -380,19 +388,17 @@ static ssize_t rfkill_claim_store(struct device *dev,
>  	if (error)
>  		return error;
>  
> -	if (rfkill->user_claim_unsupported) {
> -		error = -EOPNOTSUPP;
> -		goto out_unlock;
> -	}
>  	if (rfkill->user_claim != claim) {
> -		if (!claim)
> +		if (!claim) {
> +			mutex_lock(&rfkill->mutex);
>  			rfkill_toggle_radio(rfkill,
>  					    rfkill_states[rfkill->type],
>  					    0);
> +			mutex_unlock(&rfkill->mutex);
> +		}
>  		rfkill->user_claim = claim;
>  	}
>  
> -out_unlock:
>  	mutex_unlock(&rfkill_mutex);
>  
>  	return error ? error : count;
> @@ -521,8 +527,11 @@ static void rfkill_remove_switch(struct rfkill *rfkill)
>  {
>  	mutex_lock(&rfkill_mutex);
>  	list_del_init(&rfkill->node);
> -	rfkill_toggle_radio(rfkill, RFKILL_STATE_SOFT_BLOCKED, 1);
>  	mutex_unlock(&rfkill_mutex);
> +
> +	mutex_lock(&rfkill->mutex);
> +	rfkill_toggle_radio(rfkill, RFKILL_STATE_SOFT_BLOCKED, 1);
> +	mutex_unlock(&rfkill->mutex);

Not sure about this one, something tells me it should be something like:

	mutex_lock(&rfkill_mutex);
	list_del_init(&rfkill->node);

	mutex_lock(&rfkill->mutex);
	rfkill_toggle_radio(rfkill, RFKILL_STATE_SOFT_BLOCKED, 1);
	mutex_unlock(&rfkill->mutex);

	mutex_unlock(&rfkill_mutex);

Ivo
