Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52595 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab0HZLGZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Aug 2010 07:06:25 -0400
Subject: Re: [RFC] iwlwifi: rewrite iwl-scan.c to avoid race conditions
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100820133226.GB4725@redhat.com>
References: <20100820133226.GB4725@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Aug 2010 13:06:04 +0200
Message-ID: <1282820764.3812.22.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

Sorry for the long delay here.

> In this patch I'm trying to avoid hardware scanning race conditions
> that may lead to not call ieee80211_scan_completed() (what in
> consequences gives "WARNING: at net/wireless/core.c:614
> wdev_cleanup_work+0xb7/0xf0"), or call iee80211_scan_completed() more
> then once (what gives " WARNING: at net/mac80211/scan.c:312
> ieee80211_scan_completed+0x5f/0x1f1").
> 
> First problem (warning in wdev_cleanup_work) make any further scan
> request from cfg80211 are ignored by mac80211 with EBUSY error,
> hence Networkmanager can not perform successful scan and not allow
> to establish new connection. So after suspend/resume (but maybe
> not only then) user is not able to connect to wireless network again.
> 
> We can not relay on that the commands (start and abort scan) are
> successful. Even if they are successfully send to the hardware, we can
> not get back notification from firmware (i.e. firmware hung or it was
> reseted), or we can get notification when we actually perform abort
> scan in driver code or after that.
> 
> To assure we call ieee80211_scan_completed() only once when scan
> was started we use SCAN_SCANNING bit. Code path, which first clear
> STATUS_SCANNING bit will call ieee80211_scan_completed().
> We do this in many cases, in scan complete notification, scan
> abort and timeout, firmware reset, etc. each time we check SCANNING bit.
> 
> Note: there are still some race conditions. I commented them in code,
> I'm still working on that problems.

Good description, thanks.

> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
> index bb2aeeb..98509c5 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
> @@ -295,7 +295,7 @@ extern const struct iwl_channel_info *iwl3945_get_channel_info(
>  extern int iwl3945_rs_next_rate(struct iwl_priv *priv, int rate);
>  
>  /* scanning */
> -void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif);
> +int iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif);
>  
>  /* Requires full declaration of iwl_priv before including */
>  #include "iwl-io.h"
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> index eedd71f..29a5e8f 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> @@ -1147,7 +1147,7 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
>  	return added;
>  }
>  
> -void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
> +int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
>  {
>  	struct iwl_host_cmd cmd = {
>  		.id = REPLY_SCAN_CMD,
> @@ -1155,7 +1155,6 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
>  		.flags = CMD_SIZE_HUGE,
>  	};
>  	struct iwl_scan_cmd *scan;
> -	struct ieee80211_conf *conf = NULL;
>  	u32 rate_flags = 0;
>  	u16 cmd_len;
>  	u16 rx_chain = 0;
> @@ -1167,48 +1166,7 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
>  	int  chan_mod;
>  	u8 active_chains;
>  	u8 scan_tx_antennas = priv->hw_params.valid_tx_ant;
> -
> -	conf = ieee80211_get_hw_conf(priv->hw);
> -
> -	cancel_delayed_work(&priv->scan_check);
> -
> -	if (!iwl_is_ready(priv)) {
> -		IWL_WARN(priv, "request scan called when driver not ready.\n");
> -		goto done;
> -	}
> -
> -	/* Make sure the scan wasn't canceled before this queued work
> -	 * was given the chance to run... */
> -	if (!test_bit(STATUS_SCANNING, &priv->status))
> -		goto done;
> -
> -	/* This should never be called or scheduled if there is currently
> -	 * a scan active in the hardware. */
> -	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
> -		IWL_DEBUG_INFO(priv, "Multiple concurrent scan requests in parallel. "
> -			       "Ignoring second request.\n");
> -		goto done;
> -	}
> -
> -	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
> -		IWL_DEBUG_SCAN(priv, "Aborting scan due to device shutdown\n");
> -		goto done;
> -	}
> -
> -	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
> -		IWL_DEBUG_HC(priv, "Scan request while abort pending.  Queuing.\n");
> -		goto done;
> -	}
> -
> -	if (iwl_is_rfkill(priv)) {
> -		IWL_DEBUG_HC(priv, "Aborting scan due to RF Kill activation\n");
> -		goto done;
> -	}
> -
> -	if (!test_bit(STATUS_READY, &priv->status)) {
> -		IWL_DEBUG_HC(priv, "Scan request while uninitialized.  Queuing.\n");
> -		goto done;
> -	}
> +	int ret = -ENOMEM;

Goodie :)
 
>  int iwlagn_manage_ibss_station(struct iwl_priv *priv,
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index 26bc048..7602765 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -3075,13 +3075,27 @@ static void iwl_bg_restart(struct work_struct *data)
>  		return;
>  
>  	if (test_and_clear_bit(STATUS_FW_ERROR, &priv->status)) {
> +		bool scan_pending = false;
> +
>  		mutex_lock(&priv->mutex);
>  		priv->vif = NULL;
>  		priv->is_open = 0;
> +		if (test_bit(STATUS_SCANNING, &priv->status) &&
> +		    !priv->is_internal_short_scan) {
> +			scan_pending = true;
> +			clear_bit(STATUS_SCAN_HW, &priv->status);
> +			clear_bit(STATUS_SCAN_ABORTING, &priv->status);
> +		}
>  		mutex_unlock(&priv->mutex);
> +
> +		if (scan_pending)
> +			ieee80211_scan_completed(priv->hw, true);

Since we've had locking problems in such situations a lot, I'm just
going to allow mac80211 to call scan_completed() from any context.
That'll get rid of all the problems with the mutx here, so that you can
move this code into a helper function (based on your description, I
suspect I'll see it again in the patch)


> -static void iwl_bg_scan_check(struct work_struct *data)
> +/* NOTE: priv->mutex is required before calling this function */

make that "lockdep_assert_held(&priv->mutex);" (at least in addition)

> +static int iwl_do_scan_abort(struct iwl_priv *priv)

> +	int ret = 0;

> +	if (test_bit(STATUS_SCANNING, &priv->status)) {
> +		if (test_and_set_bit(STATUS_SCAN_ABORTING, &priv->status))
> +			IWL_DEBUG_SCAN(priv, "Scan abort in progress.\n");
> +		else {
> +			ret = iwl_send_scan_abort(priv);
> +			if (ret) {
> +				clear_bit(STATUS_SCANNING, &priv->status);
> +				clear_bit(STATUS_SCAN_HW, &priv->status);
> +				clear_bit(STATUS_SCAN_ABORTING, &priv->status);
> +
> +				/* If we did internal scan and mac80211 does
> +				 * not schedule scan by itself we do not
> +				 * have to complete it */
> +				if (priv->is_internal_short_scan &&
> +				    priv->scan_request == NULL)
> +					ret = 0;

Is that && really correct? It's just an extra check, right? I mean,
scan_request is always NULL for internal short scans...

Also, if I make the change I just talked about earlier, could this
function call ieee80211_scan_completed() itself?

>  /**
> - * iwl_fill_probe_req - fill in all required fields and IE for probe request
> + * iwl_scan_cancel - Cancel any currently executing HW scan
>   */
> +void iwl_scan_cancel(struct iwl_priv *priv)
> +{
> +	IWL_DEBUG_SCAN(priv, "Queuing scan abort.\n");
> +	schedule_work(&priv->abort_scan);

This probably needs an explanation of why it uses schedule_work?


> + * NOTE: priv->mutex must be held before calling this function

lockdep_assert etc.

> +int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
>  {
> -	int len = 0;
> -	u8 *pos = NULL;
> +	int ret;
> +	unsigned long now = jiffies;
>  
> -	/* Make sure there is enough space for the probe request,
> -	 * two mandatory IEs and the data */
> -	left -= 24;
> -	if (left < 0)
> -		return 0;
> +	ret = iwl_do_scan_abort(priv);
> +	mutex_unlock(&priv->mutex);

I'd prefer if we never dropped the mutex in a function that requires
being called with it held. That can break locking really badly in the
caller without anybody noticing.

> +	if (ret) {
> +		ieee80211_scan_completed(priv->hw, true);
> +		goto out;
> +	}

I guess it's just because of this though, so that should go away.
 
> -	len += 24;
> +	while (time_before(jiffies, now + msecs_to_jiffies(ms))) {
> +		if (!test_bit(STATUS_SCANNING, &priv->status))
> +			break;
> +		msleep(20);
> +	}

Or because of this?
 
> -	/* ...next IE... */
> -	pos = &frame->u.probe_req.variable[0];
> +	/* XXX: race condtion: we can sucessufly cancel scan, but
> +	 *	a new scan request could arrive, so we can still
> +	 *	have scanning pending */ 

Can a new request really arrive? mac80211 needs to be processing the
completed first? Or is this maybe for internal short scans?


> +	/* When scanning is marked as pending, we will send abort command,
> +	 * but do not care if it will be successful or not. Just cancel
> +	 * bits and do cleanups here, we can not relay that we get
> +	 * abort notification from hardware. */

"rely on getting abort notification from hardware"

> +	/* We report scan completion to mac8011 only if external scan was
> +	 * actually performed and nobody else report the completion */
> +	if (test_and_clear_bit(STATUS_SCANNING, &priv->status) && !internal) {
> +		completed = true;
> +		IWL_DEBUG_INFO(priv, "SCAN completed.\n");
> +	}
> +
> +out_unlock:
>  	mutex_unlock(&priv->mutex);


Hmm, an only tangentially related question: do we really need to do all
these atomic bit operations? We hold the mutex everywhere anyway, no?

> --- a/drivers/net/wireless/iwlwifi/iwl-sta.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
> @@ -989,11 +989,11 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
>  	unsigned long flags;
>  	int i;
>  
> -	if (iwl_scan_cancel(priv)) {
> -		/* cancel scan failed, just live w/ bad key and rely
> -		   briefly on SW decryption */
> +	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
> +		/* just live w/ bad key and rely briefly on SW decryption */
>  		return;
>  	}
> +	/* XXX: race condition: nothing prevent to start HW scanning now */

TBH, I don't even understand why we need to cancel the scan here. We're
just updating a key ... and we don't really do that while scanning
anyway since it's triggered only by receiving frames successfully...

I'll send out the mac80211 patch in a bit.

johannes

