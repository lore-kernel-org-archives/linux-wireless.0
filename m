Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41370 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094Ab0ICOi4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Sep 2010 10:38:56 -0400
Subject: Re: [PATCH 04/13] iwlwifi: cancel scan when down the device
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1283515056-11523-5-git-send-email-sgruszka@redhat.com>
References: <1283515056-11523-1-git-send-email-sgruszka@redhat.com>
	 <1283515056-11523-5-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain
Date: Fri, 03 Sep 2010 07:38:17 -0700
Message-Id: <1283524697.5211.15.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gruszka,

On Fri, 2010-09-03 at 04:57 -0700, Stanislaw Gruszka wrote:
> Always cancel scan when stooping device and scan is currently pending,
> we should newer have scan running after down device.
> 
> To assure we start scan cancel from restart work we have to schedule
> abort_scan to different workqueue than priv->workqueue.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn.c      |   14 +++-----------
>  drivers/net/wireless/iwlwifi/iwl-scan.c     |    2 +-
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |   16 ++++------------
>  3 files changed, 8 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index ad0e67f..0de2401 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -2875,8 +2875,9 @@ static void __iwl_down(struct iwl_priv *priv)
>  
>  	IWL_DEBUG_INFO(priv, DRV_NAME " is going down\n");
>  
> -	if (!exit_pending)
> -		set_bit(STATUS_EXIT_PENDING, &priv->status);
> +	iwl_scan_cancel_timeout(priv, 200);
> +
> +	exit_pending = test_and_set_bit(STATUS_EXIT_PENDING, &priv->status);
>  
>  	/* Stop TX queues watchdog. We need to have STATUS_EXIT_PENDING bit set
>  	 * to prevent rearm timer */
> @@ -3486,15 +3487,6 @@ static void iwl_mac_stop(struct ieee80211_hw *hw)
>  
>  	priv->is_open = 0;
>  
> -	if (iwl_is_ready_rf(priv) || test_bit(STATUS_SCAN_HW, &priv->status)) {
> -		/* stop mac, cancel any scan request and clear
> -		 * RXON_FILTER_ASSOC_MSK BIT
> -		 */
> -		mutex_lock(&priv->mutex);
> -		iwl_scan_cancel_timeout(priv, 100);
> -		mutex_unlock(&priv->mutex);
> -	}
> -
>  	iwl_down(priv);

I see you remove the "mutex" here, not needed?

Wey


