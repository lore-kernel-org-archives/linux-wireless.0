Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:30915 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab2APEHQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jan 2012 23:07:16 -0500
Subject: Re: [PATCH] wireless: iwlwifi: iwl-scan.c: Fix build warning
From: wwguy <wey-yi.w.guy@intel.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Fabio Estevam <fabio.estevam@freescale.com>
In-Reply-To: <1326682032-3060-1-git-send-email-festevam@gmail.com>
References: <1326682032-3060-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 Jan 2012 19:59:55 -0800
Message-ID: <1326686395.2892.8.camel@wwguy-ubuntu> (sfid-20120116_050720_860357_608F656B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-01-16 at 00:47 -0200, Fabio Estevam wrote:
> Fix the following build warning:
> 
> drivers/net/wireless/iwlwifi/iwl-scan.c: In function ‘iwlagn_request_scan’:
> drivers/net/wireless/iwlwifi/iwl-scan.c:572: warning: ‘cmd_len’ may be used uninitialized in this function
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-scan.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
> index 084aa2c..a645472 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-scan.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
> @@ -569,7 +569,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
>  	struct iwl_scan_cmd *scan;
>  	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
>  	u32 rate_flags = 0;
> -	u16 cmd_len;
> +	u16 cmd_len = 0;
>  	u16 rx_chain = 0;
>  	enum ieee80211_band band;
>  	u8 n_probes = 0;


