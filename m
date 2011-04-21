Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:65058 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab1DUHjR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 03:39:17 -0400
Date: Thu, 21 Apr 2011 09:42:09 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Nishant Sarmukadam <nishants@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Pradeep Nemavat <pnemavat@marvell.com>
Subject: Re: [PATCH V2 2/4] mwl8k: Add timestamp information for tx packets
Message-ID: <20110421074209.GX1897@wantstofly.org>
References: <1303231582-17333-1-git-send-email-nishants@marvell.com>
 <1303231582-17333-2-git-send-email-nishants@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303231582-17333-2-git-send-email-nishants@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 19, 2011 at 10:16:20PM +0530, Nishant Sarmukadam wrote:

> From: Pradeep Nemavat <pnemavat@marvell.com>
> 
> Timestamp tx packets using a HW micro-second timer.
> This timestamp will be compared to the current timestamp
> in the hardware and if the difference is greater than 500ms,
> the packet will be dropped.
> 
> Signed-off-by: Pradeep Nemavat <pnemavat@marvell.com>
> Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
> ---
>  drivers/net/wireless/mwl8k.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
> index 7968301..aca0139 100644
> --- a/drivers/net/wireless/mwl8k.c
> +++ b/drivers/net/wireless/mwl8k.c
> @@ -1792,6 +1792,14 @@ static inline void mwl8k_tx_count_packet(struct ieee80211_sta *sta, u8 tid)
>  		tx_stats->pkts++;
>  }
>  
> +/* HW micro second timer register
> + * located at offset 0xA600. This
> + * will be used to timestamp tx
> + * packets.
> + */
> +
> +#define	MWL8K_HW_TIMER_REGISTER	(priv->regs + 0xA600)

1. Ugly implicit 'priv' argument here. :-(

   Please just do something like:

 #define  MWL8K_A2H_INT_RX_READY                  (1 << 1)
 #define  MWL8K_A2H_INT_TX_DONE                   (1 << 0)
+
+/* Misc registers */
+#define MWL8K_HW_TIMER_REGISTER		0x0000a600

 #define MWL8K_A2H_EVENTS        (MWL8K_A2H_INT_DUMMY | \
                                  MWL8K_A2H_INT_CHNL_SWITCHED | \

   and then just use it as ioread32(priv->regs + MWL8K_HW_TIMER_REGISTER).


2. Does this register exist on 8687/superfly3, or is it SJ only?
