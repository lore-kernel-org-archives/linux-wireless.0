Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38138 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750958AbaEVFCu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 01:02:50 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/5] mwifiex: set TDLS flags for AMSDU packets
Date: Wed, 21 May 2014 22:02:30 -0700
Message-ID: <1400734951-6851-4-git-send-email-bzhao@marvell.com> (sfid-20140522_070253_340809_626E1869)
In-Reply-To: <1400734951-6851-1-git-send-email-bzhao@marvell.com>
References: <1400734951-6851-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch fixes an issue where AMSDU packets for TDLS link
would flow over infra link. This happened because we were
missing setting TDLS flag in TxPD on AMSDU packets.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 860dfe7..5b32106 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -100,6 +100,7 @@ mwifiex_11n_form_amsdu_txpd(struct mwifiex_private *priv,
 			    struct sk_buff *skb)
 {
 	struct txpd *local_tx_pd;
+	struct mwifiex_txinfo *tx_info = MWIFIEX_SKB_TXCB(skb);
 
 	skb_push(skb, sizeof(*local_tx_pd));
 
@@ -118,6 +119,9 @@ mwifiex_11n_form_amsdu_txpd(struct mwifiex_private *priv,
 	local_tx_pd->tx_pkt_length = cpu_to_le16(skb->len -
 						 sizeof(*local_tx_pd));
 
+	if (tx_info->flags & MWIFIEX_BUF_FLAG_TDLS_PKT)
+		local_tx_pd->flags |= MWIFIEX_TXPD_FLAGS_TDLS_PACKET;
+
 	if (local_tx_pd->tx_control == 0)
 		/* TxCtrl set by user or default */
 		local_tx_pd->tx_control = cpu_to_le32(priv->pkt_tx_ctrl);
@@ -183,6 +187,9 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 
 	tx_info_aggr->bss_type = tx_info_src->bss_type;
 	tx_info_aggr->bss_num = tx_info_src->bss_num;
+
+	if (tx_info_src->flags & MWIFIEX_BUF_FLAG_TDLS_PKT)
+		tx_info_aggr->flags |= MWIFIEX_BUF_FLAG_TDLS_PKT;
 	skb_aggr->priority = skb_src->priority;
 
 	do_gettimeofday(&tv);
-- 
1.8.2.3

