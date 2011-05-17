Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:1152 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225Ab1EQOtr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 10:49:47 -0400
Subject: Re: [PATCH] iwlwifi: remove unused parameter from
 iwl_hcmd_queue_reclaim
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <9506853D-331A-4900-BAA3-61C3CB280AAD@cs.washington.edu>
References: <9506853D-331A-4900-BAA3-61C3CB280AAD@cs.washington.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 07:24:03 -0700
Message-ID: <1305642243.14995.280.camel@wwguy-huron> (sfid-20110517_164955_718439_D0471A80)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-16 at 21:46 -0700, Daniel Halperin wrote:
> cmd_index is never used.
> 
> Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
> ---
>  drivers/net/wireless/iwlwifi/iwl-tx.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
> index 54a935f..686e176 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-tx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
> @@ -746,8 +746,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
>   * need to be reclaimed. As result, some free space forms.  If there is
>   * enough free space (> low mark), wake the stack that feeds us.
>   */
> -static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id,
> -				   int idx, int cmd_idx)
> +static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id, int idx)
>  {
>  	struct iwl_tx_queue *txq = &priv->txq[txq_id];
>  	struct iwl_queue *q = &txq->q;
> @@ -819,7 +818,7 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
>  
>  	spin_lock_irqsave(&priv->hcmd_lock, flags);
>  
> -	iwl_hcmd_queue_reclaim(priv, txq_id, index, cmd_index);
> +	iwl_hcmd_queue_reclaim(priv, txq_id, index);
>  
>  	if (!(meta->flags & CMD_ASYNC)) {
>  		clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
Thanks
Wey

