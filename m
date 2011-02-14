Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42180 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab1BNOxo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 09:53:44 -0500
Subject: Re: [PATCH] iwlwifi: zero fill txq->txb on queue reset
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1297693999-15342-1-git-send-email-sgruszka@redhat.com>
References: <1297693999-15342-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 15:53:39 +0100
Message-ID: <1297695219.3953.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-14 at 15:33 +0100, Stanislaw Gruszka wrote:
> We allocate txq->txb area with kzalloc, but when reseting queue
> during __iwl_down / __iwl_up we we leave old values, let's zero
> initialize in such case as well.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-tx.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
> index a8935cd..0c8555c 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-tx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
> @@ -418,6 +418,8 @@ void iwl_tx_queue_reset(struct iwl_priv *priv, struct iwl_tx_queue *txq,
>  
>  	if (txq_id == priv->cmd_queue)
>  		actual_slots++;
> +	else
> +		memset(txq->txb, 0, sizeof(txq->txb[0]) * TFD_QUEUE_SIZE_MAX);

I don't mind -- but I think the changelog should say that this isn't
necessary since the device will never use any of those entries?

johannes

