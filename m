Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17942 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363AbbBCI7Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 03:59:24 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: "quozl@laptop.org" <quozl@laptop.org>,
	Avinash Patil <patila@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 3 Feb 2015 00:59:14 -0800
Subject: RE: [RFC PATCH] mwifiex: handle command response in aggregation
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951B165DBD08@SC-VEXCH1.marvell.com> (sfid-20150203_095930_269682_6EE9FE57)
References: <20150123071619.GA31644@us.netrek.org>
In-Reply-To: <20150123071619.GA31644@us.netrek.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

>From: quozl@laptop.org [mailto:quozl@laptop.org]
>Sent: 23 January 2015 12:46
>To: Amitkumar Karwar; Avinash Patil
>Cc: linux-wireless@vger.kernel.org
>Subject: [RFC PATCH] mwifiex: handle command response in aggregation
>
>Firmware does occasionally pass a command response to the host on the
>data port.  Ensure it is processed.
>
>http://dev.laptop.org/ticket/12749
>---
>Seen on device firmwares:
>
>	14.66.9.p96
>	14.66.35.p52
>
>Others not tested.
>
> drivers/net/wireless/mwifiex/sdio.c | 5 ++---
> 1 file changed, 2 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/net/wireless/mwifiex/sdio.c
>b/drivers/net/wireless/mwifiex/sdio.c
>index 933dae1..8fe6147 100644
>--- a/drivers/net/wireless/mwifiex/sdio.c
>+++ b/drivers/net/wireless/mwifiex/sdio.c
>@@ -1240,8 +1240,7 @@ static int
>mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
> 			/* copy pkt to deaggr buf */
> 			skb_deaggr = card->mpa_rx.skb_arr[pind];
>
>-			if ((pkt_type == MWIFIEX_TYPE_DATA) && (pkt_len <=
>-					 card->mpa_rx.len_arr[pind])) {
>+			if (pkt_len <= card->mpa_rx.len_arr[pind]) {
>
> 				memcpy(skb_deaggr->data, curr_ptr, pkt_len);
>
>@@ -1251,7 +1250,7 @@ static int
>mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
> 				mwifiex_decode_rx_packet(adapter, skb_deaggr,
> 							 pkt_type);
> 			} else {
>-				dev_err(adapter->dev, "wrong aggr pkt:"
>+				dev_err(adapter->dev, "bad aggr pkt:"
> 					" type=%d len=%d max_len=%d\n",
> 					pkt_type, pkt_len,
> 					card->mpa_rx.len_arr[pind]);
>--
>1.9.1
>
>

We checked with our firmware engineer. There is no possibility of receiving command response on data port. Probably this is a corrupted data received on SDIO. If possible, could you print this data and share log?

Regards,
Amit
