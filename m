Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:39002 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751746Ab3HZT1K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 15:27:10 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Tobias Waldekranz <tobias@waldekranz.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 26 Aug 2013 12:27:06 -0700
Subject: RE: [PATCH] mwifiex: add missing endian conversions
Message-ID: <477F20668A386D41ADCC57781B1F70430EAF1FEDA3@SC-VEXCH1.marvell.com> (sfid-20130826_212713_762805_351CBBD8)
References: <20130826071806.GA3035@gmail.com>
In-Reply-To: <20130826071806.GA3035@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tobias,

> Fixes multiple locations where a little endian host is assumed during
> ser/des of messages sent to/received from the chip.

Thanks for your patch.
It doesn't apply to wireless or wireless-next trees.

Which git tree are you using?

> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  drivers/net/wireless/mwifiex/11n_aggr.c    | 2 +-
>  drivers/net/wireless/mwifiex/main.h        | 2 +-
>  drivers/net/wireless/mwifiex/sdio.c        | 6 +++---
>  drivers/net/wireless/mwifiex/sta_cmdresp.c | 2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
> index a78e065..b53c73c 100644
> --- a/drivers/net/wireless/mwifiex/11n_aggr.c
> +++ b/drivers/net/wireless/mwifiex/11n_aggr.c
> @@ -69,7 +69,7 @@ mwifiex_11n_form_amsdu_pkt(struct sk_buff *skb_aggr,
>  	memcpy(&tx_header->eth803_hdr, skb_src->data, dt_offset);
> 
>  	/* Copy SNAP header */
> -	snap.snap_type = *(u16 *) ((u8 *)skb_src->data + dt_offset);
> +	snap.snap_type = le16_to_cpu(*(__le16 *) ((u8 *)skb_src->data + dt_offset));

This line exceeds 80 characters. Please break it to two lines.

Thanks,
Bing


