Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31333 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950Ab1D1PFl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 11:05:41 -0400
Subject: Re: [PATCH 2.6.38 1/4] iwlwifi: do not set tx power when channel
 is changing
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "stable@kernel.org" <stable@kernel.org>,
	"kernel@lists.fedoraproject.org" <kernel@lists.fedoraproject.org>,
	Kyle McMartin <kmcmartin@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1303992495-7337-2-git-send-email-sgruszka@redhat.com>
References: <1303992495-7337-1-git-send-email-sgruszka@redhat.com>
	 <1303992495-7337-2-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 07:42:32 -0700
Message-ID: <1304001752.14995.206.camel@wwguy-huron> (sfid-20110428_170544_693346_B62FE6E9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-04-28 at 05:08 -0700, Stanislaw Gruszka wrote:
> commit f844a709a7d8f8be61a571afc31dfaca9e779621 upstream.
> 
> Mac80211 can request for tx power and channel change in one ->config
> call. If that happens, *_send_tx_power functions will try to setup tx
> power for old channel, what can be not correct because we already change
> the band. I.e  error  "Failed to get channel info for channel 140 [0]",
> can be printed frequently when operating in software scanning mode.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    5 ++---
>  drivers/net/wireless/iwlwifi/iwl-core.c     |   13 ++++++++++---
>  4 files changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
> index 39b6f16..4e7b58b 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
> @@ -1823,7 +1823,7 @@ int iwl3945_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
>  
>  	/* If we issue a new RXON command which required a tune then we must
>  	 * send a new TXPOWER command or we won't be able to Tx any frames */
> -	rc = priv->cfg->ops->lib->send_tx_power(priv);
> +	rc = iwl_set_tx_power(priv, priv->tx_power_next, true);
>  	if (rc) {
>  		IWL_ERR(priv, "Error setting Tx power (%d).\n", rc);
>  		return rc;
> diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
> index 91a9f52..992caa0 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-4965.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
> @@ -1571,7 +1571,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *c
>  
>  	/* If we issue a new RXON command which required a tune then we must
>  	 * send a new TXPOWER command or we won't be able to Tx any frames */
> -	ret = iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
> +	ret = iwl_set_tx_power(priv, priv->tx_power_next, true);
>  	if (ret) {
>  		IWL_ERR(priv, "Error sending TX power (%d)\n", ret);
>  		return ret;
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
> index 6d140bd..ee802fe 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
> @@ -288,10 +288,9 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
>  	 * If we issue a new RXON command which required a tune then we must
>  	 * send a new TXPOWER command or we won't be able to Tx any frames.
>  	 *
> -	 * FIXME: which RXON requires a tune? Can we optimise this out in
> -	 *        some cases?
> +	 * It's expected we set power here if channel is changing.
>  	 */
> -	ret = iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
> +	ret = iwl_set_tx_power(priv, priv->tx_power_next, true);
>  	if (ret) {
>  		IWL_ERR(priv, "Error sending TX power (%d)\n", ret);
>  		return ret;
> diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
> index efbde1f..91cac6f 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-core.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-core.c
> @@ -1161,6 +1161,8 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
>  {
>  	int ret;
>  	s8 prev_tx_power;
> +	bool defer;
> +	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
>  
>  	lockdep_assert_held(&priv->mutex);
>  
> @@ -1188,10 +1190,15 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
>  	if (!iwl_is_ready_rf(priv))
>  		return -EIO;
>  
> -	/* scan complete use tx_power_next, need to be updated */
> +	/* scan complete and commit_rxon use tx_power_next value,
> +	 * it always need to be updated for newest request */
>  	priv->tx_power_next = tx_power;
> -	if (test_bit(STATUS_SCANNING, &priv->status) && !force) {
> -		IWL_DEBUG_INFO(priv, "Deferring tx power set while scanning\n");
> +
> +	/* do not set tx power when scanning or channel changing */
> +	defer = test_bit(STATUS_SCANNING, &priv->status) ||
> +		memcmp(&ctx->active, &ctx->staging, sizeof(ctx->staging));
> +	if (defer && !force) {
> +		IWL_DEBUG_INFO(priv, "Deferring tx power set\n");
>  		return 0;
>  	}
>  


