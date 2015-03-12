Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:65469 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753230AbbCLI2G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 04:28:06 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t2C8NUS9002707
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 01:27:45 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1t20qjehk4-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 01:27:45 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: fix a bug in Rx multiport aggregation logic
Date: Thu, 12 Mar 2015 00:38:38 -0700
Message-ID: <1426145920-5288-1-git-send-email-akarwar@marvell.com> (sfid-20150312_092815_655378_0C8B47E9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Cathy Luo <cluo@marvell.com>

It's been observed Rx aggregated packets are always followed
by a single Rx packet. This patch improves our logic to add
that extra packet in next aggregation.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 57d85ab..9ef010b 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1133,6 +1133,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 	s32 f_do_rx_aggr = 0;
 	s32 f_do_rx_cur = 0;
 	s32 f_aggr_cur = 0;
+	s32 f_post_aggr_cur = 0;
 	struct sk_buff *skb_deaggr;
 	u32 pind;
 	u32 pkt_len, pkt_type, mport;
@@ -1169,7 +1170,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 			} else {
 				/* No room in Aggr buf, do rx aggr now */
 				f_do_rx_aggr = 1;
-				f_do_rx_cur = 1;
+				f_post_aggr_cur = 1;
 			}
 		} else {
 			/* Rx aggr not in progress */
@@ -1280,9 +1281,13 @@ rx_curr_single:
 
 		mwifiex_decode_rx_packet(adapter, skb, pkt_type);
 	}
+	if (f_post_aggr_cur) {
+		dev_dbg(adapter->dev, "info: current packet aggregation\n");
+		/* Curr pkt can be aggregated */
+		mp_rx_aggr_setup(card, skb, port);
+	}
 
 	return 0;
-
 error:
 	if (MP_RX_AGGR_IN_PROGRESS(card)) {
 		/* Multiport-aggregation transfer failed - cleanup */
-- 
1.8.1.4

