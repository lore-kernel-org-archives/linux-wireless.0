Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:35479 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424Ab0G1OfS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 10:35:18 -0400
Subject: Re: [RFC] iwlwifi: fix scan abort
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100728154509.77e8e85b@dhcp-lab-109.englab.brq.redhat.com>
References: <20100728154509.77e8e85b@dhcp-lab-109.englab.brq.redhat.com>
Content-Type: text/plain
Date: Wed, 28 Jul 2010 07:34:42 -0700
Message-Id: <1280327682.26765.6.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gruszka,

On Wed, 2010-07-28 at 06:45 -0700, Stanislaw Gruszka wrote:
> We can not call cancel_delayed_work_sync(&priv->scan_check) with 
> priv->mutex locked because workqueue function iwl_bg_scan_check()
> take that lock internally.
> 
> We do not need to synchronize when canceling priv->scan_check work. 
> We can avoid races (sending double abort command or send no
> command at all) using STATUS_SCAN_ABORT bit. Moreover
> current iwl_bg_scan_check() code seems to be broken, as
> we should not send abort commands when currently aborting.
> 
> I did not test patch yet, just want to know if it is theoretically
> correct. Except obvious circular priv->mutex locking fix, maybe it
> can help with warning in ieee80211_scan_completed, which is still
> reported by the users from time to time.
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
> index 2a7c399..b0c6b04 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-scan.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
> @@ -429,11 +429,10 @@ void iwl_bg_scan_check(struct work_struct *data)
>  		return;
>  
>  	mutex_lock(&priv->mutex);
> -	if (test_bit(STATUS_SCANNING, &priv->status) ||
> -	    test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
> -		IWL_DEBUG_SCAN(priv, "Scan completion watchdog resetting "
> -			"adapter (%dms)\n",
> -			jiffies_to_msecs(IWL_SCAN_CHECK_WATCHDOG));
> +	if (test_bit(STATUS_SCANNING, &priv->status) &&
> +	    !test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
> +		IWL_DEBUG_SCAN(priv, "Scan completion watchdog (%dms)\n",
> +			       jiffies_to_msecs(IWL_SCAN_CHECK_WATCHDOG));

make sense here, the code is broken, we should not abort scan if already
doing it.

>  
>  		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
>  			iwl_send_scan_abort(priv);
> @@ -498,12 +497,11 @@ void iwl_bg_abort_scan(struct work_struct *work)
>  	    !test_bit(STATUS_GEO_CONFIGURED, &priv->status))
>  		return;
>  
> -	mutex_lock(&priv->mutex);
> -
> -	cancel_delayed_work_sync(&priv->scan_check);
> -	set_bit(STATUS_SCAN_ABORTING, &priv->status);
> -	iwl_send_scan_abort(priv);
> +	cancel_delayed_work(&priv->scan_check);
>  
> +	mutex_lock(&priv->mutex);
> +	if (test_bit(STATUS_SCAN_ABORTING, &priv->status))
> +		iwl_send_scan_abort(priv);
>  	mutex_unlock(&priv->mutex);
>  }

Looks right to me, thanks a lot to catch this one.

Wey



