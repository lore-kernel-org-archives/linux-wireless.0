Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48867 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754813AbaLWIOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 03:14:40 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id sBN8E0Cc007874
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2014 00:14:39 -0800
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0a-0016f401.pphosted.com with ESMTP id 1rcjut132c-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2014 00:14:39 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<huxm@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 1/8] mwifiex: report tdls peers in debugfs
Date: Tue, 23 Dec 2014 19:14:05 +0530
Message-ID: <1419342252-2702-2-git-send-email-patila@marvell.com> (sfid-20141223_091450_044160_4A6AE5C8)
In-Reply-To: <1419342252-2702-1-git-send-email-patila@marvell.com>
References: <1419342252-2702-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch add provision to show TDLS peer table in debugfs file.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/debugfs.c |  9 +++++++++
 drivers/net/wireless/mwifiex/decl.h    |  1 +
 drivers/net/wireless/mwifiex/ioctl.h   |  9 ++++++++-
 drivers/net/wireless/mwifiex/main.h    |  2 ++
 drivers/net/wireless/mwifiex/tdls.c    | 30 ++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/util.c    |  2 ++
 6 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 2713f7ac..b506032 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -493,6 +493,15 @@ mwifiex_debug_read(struct file *file, char __user *ubuf,
 		}
 	}
 
+	if (info.tdls_peer_num) {
+		p += sprintf(p, "TDLS peer table:\n");
+		for (i = 0; i < info.tdls_peer_num; i++) {
+			p += sprintf(p, "peer = %pM",
+				     info.tdls_list[i].peer_addr);
+			p += sprintf(p, "\n");
+		}
+	}
+
 	ret = simple_read_from_buffer(ubuf, count, ppos, (char *) page,
 				      (unsigned long) p - page);
 
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 7fe3f1b..817c496 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -44,6 +44,7 @@
 
 #define MWIFIEX_MAX_TX_BASTREAM_SUPPORTED	2
 #define MWIFIEX_MAX_RX_BASTREAM_SUPPORTED	16
+#define MWIFIEX_MAX_TDLS_PEER_SUPPORTED 8
 
 #define MWIFIEX_STA_AMPDU_DEF_TXWINSIZE        64
 #define MWIFIEX_STA_AMPDU_DEF_RXWINSIZE        64
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 0847f3e..dcf4bdb 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -180,7 +180,11 @@ struct mwifiex_ds_tx_ba_stream_tbl {
 	u8 amsdu;
 };
 
-#define DBG_CMD_NUM	5
+#define DBG_CMD_NUM    5
+
+struct tdls_peer_info {
+	u8 peer_addr[ETH_ALEN];
+};
 
 struct mwifiex_debug_info {
 	u32 int_counter;
@@ -193,6 +197,9 @@ struct mwifiex_debug_info {
 	u32 rx_tbl_num;
 	struct mwifiex_ds_rx_reorder_tbl rx_tbl
 		[MWIFIEX_MAX_RX_BASTREAM_SUPPORTED];
+	u32 tdls_peer_num;
+	struct tdls_peer_info tdls_list
+		[MWIFIEX_MAX_TDLS_PEER_SUPPORTED];
 	u16 ps_mode;
 	u32 ps_state;
 	u8 is_deep_sleep;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index e66993c..b3e23f6 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1324,6 +1324,8 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 				       u8 *buf, int len);
 int mwifiex_tdls_oper(struct mwifiex_private *priv, const u8 *peer, u8 action);
 int mwifiex_get_tdls_link_status(struct mwifiex_private *priv, const u8 *mac);
+int mwifiex_get_tdls_list(struct mwifiex_private *priv,
+			  struct tdls_peer_info *buf);
 void mwifiex_disable_all_tdls_links(struct mwifiex_private *priv);
 bool mwifiex_is_bss_in_11ac_mode(struct mwifiex_private *priv);
 u8 mwifiex_get_center_freq_index(struct mwifiex_private *priv, u8 band,
diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index 22884b4..efa81d8 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -1123,6 +1123,36 @@ int mwifiex_get_tdls_link_status(struct mwifiex_private *priv, const u8 *mac)
 	return TDLS_NOT_SETUP;
 }
 
+int mwifiex_get_tdls_list(struct mwifiex_private *priv,
+			  struct tdls_peer_info *buf)
+{
+	struct mwifiex_sta_node *sta_ptr;
+	struct tdls_peer_info *peer = buf;
+	int count = 0;
+	unsigned long flags;
+
+	if (!ISSUPP_TDLS_ENABLED(priv->adapter->fw_cap_info))
+		return 0;
+
+	/* make sure we are in station mode and connected */
+	if (!(priv->bss_type == MWIFIEX_BSS_TYPE_STA && priv->media_connected))
+		return 0;
+
+	spin_lock_irqsave(&priv->sta_list_spinlock, flags);
+	list_for_each_entry(sta_ptr, &priv->sta_list, list) {
+		if (sta_ptr->tdls_status == TDLS_SETUP_COMPLETE) {
+			ether_addr_copy(peer->peer_addr, sta_ptr->mac_addr);
+			peer++;
+			count++;
+			if (count >= MWIFIEX_MAX_TDLS_PEER_SUPPORTED)
+				break;
+		}
+	}
+	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
+
+	return count;
+}
+
 void mwifiex_disable_all_tdls_links(struct mwifiex_private *priv)
 {
 	struct mwifiex_sta_node *sta_ptr;
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index b1768fb..3bd9179 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -97,6 +97,8 @@ int mwifiex_get_debug_info(struct mwifiex_private *priv,
 							      info->rx_tbl);
 		info->tx_tbl_num = mwifiex_get_tx_ba_stream_tbl(priv,
 								info->tx_tbl);
+		info->tdls_peer_num = mwifiex_get_tdls_list(priv,
+							    info->tdls_list);
 		info->ps_mode = adapter->ps_mode;
 		info->ps_state = adapter->ps_state;
 		info->is_deep_sleep = adapter->is_deep_sleep;
-- 
1.8.1.4

