Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:8778 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab0IMOI0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 10:08:26 -0400
Subject: Re: [PATCH 09/14] iwlwifi: assure we complete scan in scan_abort
 and scan_check works
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1284382005-3246-10-git-send-email-sgruszka@redhat.com>
References: <1284382005-3246-1-git-send-email-sgruszka@redhat.com>
	 <1284382005-3246-10-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain
Date: Mon, 13 Sep 2010 07:07:24 -0700
Message-Id: <1284386844.23922.19.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-13 at 05:46 -0700, Stanislaw Gruszka wrote:
> Assure we complete scan in mac80211 when we abort scanning (scan_abort
> work) or scan timeout occurs (scan_check work). Currently
> iwl_scan_cancel_timeout() procedure force scan finish in mac80211
> at the end of timeout loop, so we can use it in proper work functions.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-scan.c |   14 ++------------
>  1 files changed, 2 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
> index ce605e0..da037b2 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-scan.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
> @@ -490,18 +490,8 @@ static void iwl_bg_scan_check(struct work_struct *data)
>  	struct iwl_priv *priv =
>  	    container_of(data, struct iwl_priv, scan_check.work);
>  
> -	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
> -		return;
> -
>  	mutex_lock(&priv->mutex);
> -	if (test_bit(STATUS_SCANNING, &priv->status) &&
> -	    !test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
> -		IWL_DEBUG_SCAN(priv, "Scan completion watchdog (%dms)\n",
> -			       jiffies_to_msecs(IWL_SCAN_CHECK_WATCHDOG));
> -
> -		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
> -			iwl_send_scan_abort(priv);
> -	}
> +	iwl_scan_cancel_timeout(priv, 200);
>  	mutex_unlock(&priv->mutex);
>  }
>  
> @@ -560,7 +550,7 @@ static void iwl_bg_abort_scan(struct work_struct *work)
>  	cancel_delayed_work(&priv->scan_check);
>  
>  	mutex_lock(&priv->mutex);
> -	iwl_do_scan_abort(priv);
> +	iwl_scan_cancel_timeout(priv, 200);
>  	mutex_unlock(&priv->mutex);
>  }
>  

