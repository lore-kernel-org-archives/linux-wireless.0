Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:8122 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab0IJP5m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 11:57:42 -0400
Subject: Re: [PATCH 14/14] iwlwifi: apply settings when finishing scan
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1284128807-11436-15-git-send-email-sgruszka@redhat.com>
References: <1284128807-11436-1-git-send-email-sgruszka@redhat.com>
	 <1284128807-11436-15-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain
Date: Fri, 10 Sep 2010 08:56:55 -0700
Message-Id: <1284134215.6054.29.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-09-10 at 07:26 -0700, Stanislaw Gruszka wrote:
> Even is someone else complete scanning in mac80211, apply rxon and
> tx power settings if gets scan complete notification from hardware.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-scan.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
> index 65b7cb4..599573f 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-scan.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
> @@ -573,7 +573,7 @@ static void iwl_bg_scan_completed(struct work_struct *work)
>  
>  	if (!test_and_clear_bit(STATUS_SCANNING, &priv->status)) {
>  		IWL_DEBUG_SCAN(priv, "Scan already completed.\n");
> -		goto out;
> +		goto out_settings;
>  	}
>  
>  	if (priv->is_internal_short_scan && !aborted) {
> @@ -599,6 +599,7 @@ static void iwl_bg_scan_completed(struct work_struct *work)
>  out_complete:
>  	iwl_complete_scan(priv, aborted);
>  
> +out_settings:
>  	/* Can we still talk to firmware ? */
>  	if (!iwl_is_ready_rf(priv))
>  		goto out;

