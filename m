Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:64737 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbaBHAbE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:31:04 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 23/30] mwifiex: tdls related handling for data packets addressed to TDLS peer
Date: Fri, 7 Feb 2014 16:30:36 -0800
Message-ID: <1391819442-21239-4-git-send-email-bzhao@marvell.com> (sfid-20140208_020009_342600_0F56434D)
In-Reply-To: <1391819442-21239-1-git-send-email-bzhao@marvell.com>
References: <1391819442-21239-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

1. If data packet is addressed to TDLS peer for which link is
established, mark these packets with TDLS flag so that FW can
send them on direct link instead of sending via AP.
2. If data packet is addressed to TDLS peer and TDLS setup is
underway, move these packets to TDLS queue.
3. If this packet is TDLS setup packet, do not block it.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.h |  1 +
 drivers/net/wireless/mwifiex/tdls.c | 11 ++++++++++
 drivers/net/wireless/mwifiex/wmm.c  | 42 +++++++++++++++++++++++++++++++------
 3 files changed, 48 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 138929e..19c60b2 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1213,6 +1213,7 @@ int mwifiex_send_tdls_action_frame(struct mwifiex_private *priv,
 void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 				       u8 *buf, int len);
 int mwifiex_tdls_oper(struct mwifiex_private *priv, u8 *peer, u8 action);
+int mwifiex_get_tdls_link_status(struct mwifiex_private *priv, u8 *mac);
 
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index 3198739..7ef3593 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -782,3 +782,14 @@ int mwifiex_tdls_oper(struct mwifiex_private *priv, u8 *peer, u8 action)
 	}
 	return 0;
 }
+
+int mwifiex_get_tdls_link_status(struct mwifiex_private *priv, u8 *mac)
+{
+	struct mwifiex_sta_node *sta_ptr;
+
+	sta_ptr = mwifiex_get_sta_entry(priv, mac);
+	if (sta_ptr)
+		return sta_ptr->tdls_status;
+
+	return TDLS_NOT_SETUP;
+}
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index e9f7628..63496ed 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -631,6 +631,21 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
 	struct mwifiex_ra_list_tbl *ra_list;
 	u8 ra[ETH_ALEN], tid_down;
 	unsigned long flags;
+	struct list_head list_head;
+	int tdls_status = TDLS_NOT_SETUP;
+	struct ethhdr *eth_hdr = (struct ethhdr *)skb->data;
+	struct mwifiex_txinfo *tx_info = MWIFIEX_SKB_TXCB(skb);
+
+	memcpy(ra, eth_hdr->h_dest, ETH_ALEN);
+
+	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA &&
+	    ISSUPP_TDLS_ENABLED(adapter->fw_cap_info)) {
+		if (ntohs(eth_hdr->h_proto) == ETH_P_TDLS)
+			dev_dbg(adapter->dev,
+				"TDLS setup packet for %pM. Don't block\n", ra);
+		else
+			tdls_status = mwifiex_get_tdls_link_status(priv, ra);
+	}
 
 	if (!priv->media_connected && !mwifiex_is_skb_mgmt_frame(skb)) {
 		dev_dbg(adapter->dev, "data: drop packet in disconnect\n");
@@ -649,12 +664,27 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
 	   have only 1 raptr for a tid in case of infra */
 	if (!mwifiex_queuing_ra_based(priv) &&
 	    !mwifiex_is_skb_mgmt_frame(skb)) {
-		if (!list_empty(&priv->wmm.tid_tbl_ptr[tid_down].ra_list))
-			ra_list = list_first_entry(
-				&priv->wmm.tid_tbl_ptr[tid_down].ra_list,
-				struct mwifiex_ra_list_tbl, list);
-		else
-			ra_list = NULL;
+		switch (tdls_status) {
+		case TDLS_SETUP_COMPLETE:
+			ra_list = mwifiex_wmm_get_queue_raptr(priv, tid_down,
+							      ra);
+			tx_info->flags |= MWIFIEX_BUF_FLAG_TDLS_PKT;
+			break;
+		case TDLS_SETUP_INPROGRESS:
+			skb_queue_tail(&priv->tdls_txq, skb);
+			spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
+					       flags);
+			return;
+		default:
+			list_head = priv->wmm.tid_tbl_ptr[tid_down].ra_list;
+			if (!list_empty(&list_head))
+				ra_list = list_first_entry(
+					&list_head, struct mwifiex_ra_list_tbl,
+					list);
+			else
+				ra_list = NULL;
+			break;
+		}
 	} else {
 		memcpy(ra, skb->data, ETH_ALEN);
 		if (ra[0] & 0x01 || mwifiex_is_skb_mgmt_frame(skb))
-- 
1.8.2.3

