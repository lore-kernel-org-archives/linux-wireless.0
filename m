Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:43561 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756530Ab0ICOxn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Sep 2010 10:53:43 -0400
Subject: Re: [PATCH 08/13] iwlwifi: avoid dropping muttex in
 iwl_scan_cancel_timeout
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1283515056-11523-9-git-send-email-sgruszka@redhat.com>
References: <1283515056-11523-1-git-send-email-sgruszka@redhat.com>
	 <1283515056-11523-9-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain
Date: Fri, 03 Sep 2010 07:53:05 -0700
Message-Id: <1283525585.5211.16.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gruszka,

On Fri, 2010-09-03 at 04:57 -0700, Stanislaw Gruszka wrote:
> Don't drop mutex when waiting for scan complete. Use STATUS_HW_SCAN bit
> to check if scanning is currency pending, because STATUS_SCANNING will
> be cleared only with priv->mutex taken.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-scan.c |   17 ++++++++---------
>  1 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
> index 6ab7bb3..7e4faaf 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-scan.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
> @@ -138,22 +138,21 @@ EXPORT_SYMBOL(iwl_scan_cancel);
>   */
>  int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
>  {
> -	unsigned long now = jiffies;
> +	unsigned long timeout = jiffies + msecs_to_jiffies(ms);
>  
>  	lockdep_assert_held(&priv->mutex);
>  
> -	iwl_do_scan_abort(priv);
> +	IWL_DEBUG_SCAN(priv, "Scan cancel timeout\n");
>  
> -	if (ms) {
> -		mutex_unlock(&priv->mutex);
> -		while (!time_after(jiffies, now + msecs_to_jiffies(ms)) &&
> -				test_bit(STATUS_SCANNING, &priv->status))
> -			msleep(20);
> -		mutex_lock(&priv->mutex);
> +	iwl_do_scan_abort(priv);
>  
> +	while (time_before_eq(jiffies, timeout)) {
> +		if (!test_bit(STATUS_SCAN_HW, &priv->status))
> +			break;
> +		msleep(20);
>  	}
>  
> -	return test_bit(STATUS_SCANNING, &priv->status);
> +	return test_bit(STATUS_SCAN_HW, &priv->status);
>  }
>  EXPORT_SYMBOL(iwl_scan_cancel_timeout);
>  
Should patch 7 and 8 merge into single patch?

Wey

