Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:45169 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbbAWHQq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 02:16:46 -0500
Date: Fri, 23 Jan 2015 18:16:19 +1100
From: James Cameron <quozl@laptop.org>
To: Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC PATCH] mwifiex: handle command response in aggregation
Message-ID: <20150123071619.GA31644@us.netrek.org> (sfid-20150123_081649_486682_DE6C7913)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware does occasionally pass a command response to the host on the
data port.  Ensure it is processed.

http://dev.laptop.org/ticket/12749
---
Seen on device firmwares:

	14.66.9.p96
	14.66.35.p52

Others not tested.

 drivers/net/wireless/mwifiex/sdio.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 933dae1..8fe6147 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1240,8 +1240,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 			/* copy pkt to deaggr buf */
 			skb_deaggr = card->mpa_rx.skb_arr[pind];
 
-			if ((pkt_type == MWIFIEX_TYPE_DATA) && (pkt_len <=
-					 card->mpa_rx.len_arr[pind])) {
+			if (pkt_len <= card->mpa_rx.len_arr[pind]) {
 
 				memcpy(skb_deaggr->data, curr_ptr, pkt_len);
 
@@ -1251,7 +1250,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 				mwifiex_decode_rx_packet(adapter, skb_deaggr,
 							 pkt_type);
 			} else {
-				dev_err(adapter->dev, "wrong aggr pkt:"
+				dev_err(adapter->dev, "bad aggr pkt:"
 					" type=%d len=%d max_len=%d\n",
 					pkt_type, pkt_len,
 					card->mpa_rx.len_arr[pind]);
-- 
1.9.1


-- 
James Cameron
http://quozl.linux.org.au/
