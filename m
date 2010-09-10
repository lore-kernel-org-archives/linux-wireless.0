Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:42342 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540Ab0IJPuG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 11:50:06 -0400
Subject: Re: [PATCH 01/14] iwlwifi: remove unused conf variables
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Berg, Johannes" <johannes.berg@intel.com>
In-Reply-To: <1284128807-11436-2-git-send-email-sgruszka@redhat.com>
References: <1284128807-11436-1-git-send-email-sgruszka@redhat.com>
	 <1284128807-11436-2-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain
Date: Fri, 10 Sep 2010 08:49:18 -0700
Message-Id: <1284133758.6054.6.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-09-10 at 07:26 -0700, Stanislaw Gruszka wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There are a number of conf variables that are
> unused, remove them.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    3 ---
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 ------
>  2 files changed, 0 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> index a8f2adf..51a8d7e 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> @@ -1162,7 +1162,6 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
>  		.flags = CMD_SIZE_HUGE,
>  	};
>  	struct iwl_scan_cmd *scan;
> -	struct ieee80211_conf *conf = NULL;
>  	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
>  	u32 rate_flags = 0;
>  	u16 cmd_len;
> @@ -1179,8 +1178,6 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
>  	if (vif)
>  		ctx = iwl_rxon_ctx_from_vif(vif);
>  
> -	conf = ieee80211_get_hw_conf(priv->hw);
> -
>  	cancel_delayed_work(&priv->scan_check);
>  
>  	if (!iwl_is_ready(priv)) {
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index 68e624a..5b742eb 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -2569,12 +2569,9 @@ static void __iwl3945_down(struct iwl_priv *priv)
>  {
>  	unsigned long flags;
>  	int exit_pending = test_bit(STATUS_EXIT_PENDING, &priv->status);
> -	struct ieee80211_conf *conf = NULL;
>  
>  	IWL_DEBUG_INFO(priv, DRV_NAME " is going down\n");
>  
> -	conf = ieee80211_get_hw_conf(priv->hw);
> -
>  	if (!exit_pending)
>  		set_bit(STATUS_EXIT_PENDING, &priv->status);
>  
> @@ -2828,13 +2825,10 @@ void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
>  		.flags = CMD_SIZE_HUGE,
>  	};
>  	struct iwl3945_scan_cmd *scan;
> -	struct ieee80211_conf *conf = NULL;
>  	u8 n_probes = 0;
>  	enum ieee80211_band band;
>  	bool is_active = false;
>  
> -	conf = ieee80211_get_hw_conf(priv->hw);
> -
>  	cancel_delayed_work(&priv->scan_check);
>  
>  	if (!iwl_is_ready(priv)) {

