Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na6sys009bog029.obsmtp.com ([74.125.150.103]:41640 "EHLO
	na6sys009bog029.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753007Ab2HDBUB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 21:20:01 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 13/16] mwifiex: cleanup TX/RX BA tables for uAP
Date: Fri,  3 Aug 2012 18:06:11 -0700
Message-Id: <1344042374-6892-14-git-send-email-bzhao@marvell.com> (sfid-20120804_032005_995394_38C47349)
In-Reply-To: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
References: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Cleanup TX/RX BA tables when AP receives deauthentication from
associated station. During BSS_IDLE event, all wmm queues, BA
streams created for AP interface are deleted.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           |   26 ++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/11n.h           |    1 +
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   25 +++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/11n_rxreorder.h |    1 +
 drivers/net/wireless/mwifiex/uap_event.c     |    5 +++++
 5 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index e535c93..d273273 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -726,3 +726,29 @@ int mwifiex_get_tx_ba_stream_tbl(struct mwifiex_private *priv,
 
 	return count;
 }
+
+/*
+ * This function retrieves the entry for specific tx BA stream table by RA and
+ * deletes it.
+ */
+void mwifiex_del_tx_ba_stream_tbl_by_ra(struct mwifiex_private *priv, u8 *ra)
+{
+	struct mwifiex_tx_ba_stream_tbl *tbl, *tmp;
+	unsigned long flags;
+
+	if (!ra)
+		return;
+
+	spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
+	list_for_each_entry_safe(tbl, tmp, &priv->tx_ba_stream_tbl_ptr, list) {
+		if (!memcmp(tbl->ra, ra, ETH_ALEN)) {
+			spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock,
+					       flags);
+			mwifiex_11n_delete_tx_ba_stream_tbl_entry(priv, tbl);
+			spin_lock_irqsave(&priv->tx_ba_stream_tbl_lock, flags);
+		}
+	}
+	spin_unlock_irqrestore(&priv->tx_ba_stream_tbl_lock, flags);
+
+	return;
+}
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 6d2edb4..67c087c 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -69,6 +69,7 @@ int mwifiex_cmd_recfg_tx_buf(struct mwifiex_private *priv,
 int mwifiex_cmd_amsdu_aggr_ctrl(struct host_cmd_ds_command *cmd,
 				int cmd_action,
 				struct mwifiex_ds_11n_amsdu_aggr_ctrl *aa_ctrl);
+void mwifiex_del_tx_ba_stream_tbl_by_ra(struct mwifiex_private *priv, u8 *ra);
 
 /*
  * This function checks whether AMPDU is allowed or not for a particular TID.
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index e43d27d..24e2582 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -176,6 +176,31 @@ mwifiex_11n_get_rx_reorder_tbl(struct mwifiex_private *priv, int tid, u8 *ta)
 	return NULL;
 }
 
+/* This function retrieves the pointer to an entry in Rx reordering
+ * table which matches the given TA and deletes it.
+ */
+void mwifiex_11n_del_rx_reorder_tbl_by_ta(struct mwifiex_private *priv, u8 *ta)
+{
+	struct mwifiex_rx_reorder_tbl *tbl, *tmp;
+	unsigned long flags;
+
+	if (!ta)
+		return;
+
+	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
+	list_for_each_entry_safe(tbl, tmp, &priv->rx_reorder_tbl_ptr, list) {
+		if (!memcmp(tbl->ta, ta, ETH_ALEN)) {
+			spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock,
+					       flags);
+			mwifiex_del_rx_reorder_entry(priv, tbl);
+			spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
+		}
+	}
+	spin_unlock_irqrestore(&priv->rx_reorder_tbl_lock, flags);
+
+	return;
+}
+
 /*
  * This function finds the last sequence number used in the packets
  * buffered in Rx reordering table.
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.h b/drivers/net/wireless/mwifiex/11n_rxreorder.h
index 13ecb61..7284859 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.h
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.h
@@ -72,5 +72,6 @@ struct mwifiex_rx_reorder_tbl *mwifiex_11n_get_rxreorder_tbl(struct
 							   u8 *ta);
 struct mwifiex_rx_reorder_tbl *
 mwifiex_11n_get_rx_reorder_tbl(struct mwifiex_private *priv, int tid, u8 *ta);
+void mwifiex_11n_del_rx_reorder_tbl_by_ta(struct mwifiex_private *priv, u8 *ta);
 
 #endif /* _MWIFIEX_11N_RXREORDER_H_ */
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index a10bd95..14d4f04 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -226,10 +226,15 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 			     MWIFIEX_UAP_EVENT_EXTRA_HEADER;
 		cfg80211_del_sta(priv->netdev, deauth_mac, GFP_KERNEL);
 
+		if (priv->ap_11n_enabled) {
+			mwifiex_11n_del_rx_reorder_tbl_by_ta(priv, deauth_mac);
+			mwifiex_del_tx_ba_stream_tbl_by_ra(priv, deauth_mac);
+		}
 		mwifiex_del_sta_entry(priv, deauth_mac);
 		break;
 	case EVENT_UAP_BSS_IDLE:
 		priv->media_connected = false;
+		mwifiex_clean_txrx(priv);
 		mwifiex_del_all_sta_list(priv);
 		break;
 	case EVENT_UAP_BSS_ACTIVE:
-- 
1.7.0.2

