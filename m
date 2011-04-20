Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28631 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab1DTO1f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 10:27:35 -0400
Subject: Re: [PATCH] iwlwifi: fix possible data overwrite in hcmd callback
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1303308178-5297-1-git-send-email-sgruszka@redhat.com>
References: <1303308178-5297-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 07:05:48 -0700
Message-ID: <1303308348.14995.149.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Wed, 2011-04-20 at 07:02 -0700, Stanislaw Gruszka wrote:
> My commit 3598e1774c94e55c71b585340e7dc4538f310e3f
> "iwlwifi: fix enqueue hcmd race conditions" move hcmd callback after
> command queue reclaim, to avoid call it with hcmd_lock. But since
> queue read index was updated, cmd data can be overwritten. Fix problem
> by calling callback before taking hcmd_lock and queue reclaim.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-tx.c |   15 ++++-----------
>  1 files changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
> index 3732380..efff189 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-tx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
> @@ -607,9 +607,6 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
>  	struct iwl_cmd_meta *meta;
>  	struct iwl_tx_queue *txq = &priv->txq[priv->cmd_queue];
>  	unsigned long flags;
> -	void (*callback) (struct iwl_priv *priv, struct iwl_device_cmd *cmd,
> -			  struct iwl_rx_packet *pkt);
> -
>  
>  	/* If a Tx command is being handled and it isn't in the actual
>  	 * command queue then there a command routing bug has been introduced
> @@ -623,8 +620,6 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
>  		return;
>  	}
>  
> -	spin_lock_irqsave(&priv->hcmd_lock, flags);
> -
>  	cmd_index = get_cmd_index(&txq->q, index, huge);
>  	cmd = txq->cmd[cmd_index];
>  	meta = &txq->meta[cmd_index];
> @@ -634,13 +629,14 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
>  			 dma_unmap_len(meta, len),
>  			 PCI_DMA_BIDIRECTIONAL);
>  
> -	callback = NULL;
>  	/* Input error checking is done when commands are added to queue. */
>  	if (meta->flags & CMD_WANT_SKB) {
>  		meta->source->reply_page = (unsigned long)rxb_addr(rxb);
>  		rxb->page = NULL;
> -	} else
> -		callback = meta->callback;
> +	} else if (meta->callback)
> +		meta->callback(priv, cmd, pkt);
> +
> +	spin_lock_irqsave(&priv->hcmd_lock, flags);
>  
>  	iwl_hcmd_queue_reclaim(priv, txq_id, index, cmd_index);
>  
> @@ -655,7 +651,4 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
>  	meta->flags = 0;
>  
>  	spin_unlock_irqrestore(&priv->hcmd_lock, flags);
> -
> -	if (callback)
> -		callback(priv, cmd, pkt);
>  }

Could you elaborate a bit more, why you do not need to protect getting
the cmd index.

Wey

