Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:64374 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbYLVDz2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 22:55:28 -0500
Received: by rv-out-0506.google.com with SMTP id k40so1734812rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 21 Dec 2008 19:55:27 -0800 (PST)
Subject: Re: [PATCH 01/10] iwl3945: rearrange 3945 tfd
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>
In-Reply-To: <1229916683-9772-2-git-send-email-yi.zhu@intel.com>
References: <1229916683-9772-1-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-2-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain
Date: Sun, 21 Dec 2008 19:55:20 -0800
Message-Id: <1229918120.22856.4.camel@brick> (sfid-20081222_045531_684151_CEEC8EDE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few small things I noticed:

On Mon, 2008-12-22 at 11:31 +0800, Zhu Yi wrote:
> From: Winkler, Tomas <tomas.winkler@intel.com>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-fh.h b/drivers/net/wireless/iwlwifi/iwl-3945-fh.h
> index bbcd0ce..53ed249 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945-fh.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945-fh.h
> @@ -172,7 +172,17 @@
>  
>  #define FH39_RSSR_CHNL0_RX_STATUS_CHNL_IDLE			(0x01000000)
>  
> -#define TFD_QUEUE_SIZE_MAX      (256)
> +struct iwl3945_tfd_tb {
> +	__le32 addr;
> +	__le32 len;
> +} __attribute__ ((packed));
> +
> +struct iwl3945_tfd {
> +	__le32 control_flags;
> +	struct iwl3945_tfd_tb tbs[4];
> +	u8 __pad[28];
> +} __attribute__ ((packed));
> +

Packed doesn't really buy anything with these two structs, if you still
want it, you can also use plain __packed (see compiler-gcc.h)

>  static inline u8 iwl3945_hw_get_rate(__le16 rate_n_flags)
>  {
>  	return le16_to_cpu(rate_n_flags) & 0xFF;
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
> index 131bae7..24cdc5c 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
> @@ -38,6 +38,7 @@
>  #include <asm/unaligned.h>
>  #include <net/mac80211.h>
>  
> +#include "iwl-fh.h"
>  #include "iwl-3945-fh.h"
>  #include "iwl-commands.h"
>  #include "iwl-3945.h"
> @@ -307,7 +308,7 @@ static void iwl3945_tx_queue_reclaim(struct iwl_priv *priv,
>  {
>  	struct iwl3945_tx_queue *txq = &priv->txq39[txq_id];
>  	struct iwl_queue *q = &txq->q;
> -	struct iwl3945_tx_info *tx_info;
> +	struct iwl_tx_info *tx_info;
>  
>  	BUG_ON(txq_id == IWL_CMD_QUEUE_NUM);
>  
> @@ -728,7 +729,7 @@ int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
>  {
>  	int count;
>  	u32 pad;
> -	struct iwl3945_tfd_frame *tfd = (struct iwl3945_tfd_frame *)ptr;
> +	struct iwl3945_tfd *tfd = (struct iwl3945_tfd *)ptr;

void pointer, no cast needed (although maybe that should get cleaned up.

Cheers,

Harvey

