Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56363 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042AbaKYOow (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 09:44:52 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 5/5] mwifiex: add Tx status support for ACTION frames
Date: Tue, 25 Nov 2014 06:43:06 -0800
Message-ID: <1416926586-19286-6-git-send-email-akarwar@marvell.com> (sfid-20141125_154456_895946_63DF0AFA)
In-Reply-To: <1416926586-19286-1-git-send-email-akarwar@marvell.com>
References: <1416926586-19286-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ACK status (0/1) for ACTION frames is informed to cfg80211. We
will extend existing logic used for EAPOL frames. The cfg80211
API is different here. Also, we need to explicitly free cloned
skb.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 13 ++++++++++---
 drivers/net/wireless/mwifiex/decl.h     |  2 ++
 drivers/net/wireless/mwifiex/main.c     | 10 +++++++---
 drivers/net/wireless/mwifiex/main.h     |  4 ++++
 drivers/net/wireless/mwifiex/sta_tx.c   |  3 ++-
 drivers/net/wireless/mwifiex/txrx.c     | 17 ++++++++++++++---
 drivers/net/wireless/mwifiex/uap_txrx.c |  3 ++-
 7 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 68d5874..f881044 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -194,10 +194,17 @@ mwifiex_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	tx_info->pkt_len = pkt_len;
 
 	mwifiex_form_mgmt_frame(skb, buf, len);
-	mwifiex_queue_tx_pkt(priv, skb);
-
 	*cookie = prandom_u32() | 1;
-	cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, true, GFP_ATOMIC);
+
+	if (ieee80211_is_action(mgmt->frame_control))
+		skb = mwifiex_clone_skb_for_tx_status(priv,
+						      skb,
+				MWIFIEX_BUF_FLAG_ACTION_TX_STATUS, cookie);
+	else
+		cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, true,
+					GFP_ATOMIC);
+
+	mwifiex_queue_tx_pkt(priv, skb);
 
 	wiphy_dbg(wiphy, "info: management frame transmitted\n");
 	return 0;
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 9daa88a..2269acf 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -77,6 +77,7 @@
 #define MWIFIEX_BUF_FLAG_BRIDGED_PKT	   BIT(1)
 #define MWIFIEX_BUF_FLAG_TDLS_PKT	   BIT(2)
 #define MWIFIEX_BUF_FLAG_EAPOL_TX_STATUS   BIT(3)
+#define MWIFIEX_BUF_FLAG_ACTION_TX_STATUS  BIT(4)
 
 #define MWIFIEX_BRIDGED_PKTS_THR_HIGH      1024
 #define MWIFIEX_BRIDGED_PKTS_THR_LOW        128
@@ -161,6 +162,7 @@ struct mwifiex_txinfo {
 	u8 bss_type;
 	u32 pkt_len;
 	u8 ack_frame_id;
+	u64 cookie;
 };
 
 enum mwifiex_wmm_ac_e {
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index cf31d36..d4d2223 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -608,9 +608,9 @@ int mwifiex_queue_tx_pkt(struct mwifiex_private *priv, struct sk_buff *skb)
 	return 0;
 }
 
-static struct sk_buff *
+struct sk_buff *
 mwifiex_clone_skb_for_tx_status(struct mwifiex_private *priv,
-				struct sk_buff *skb, u8 flag)
+				struct sk_buff *skb, u8 flag, u64 *cookie)
 {
 	struct sk_buff *orig_skb = skb;
 	struct mwifiex_txinfo *tx_info, *orig_tx_info;
@@ -632,6 +632,10 @@ mwifiex_clone_skb_for_tx_status(struct mwifiex_private *priv,
 			orig_tx_info = MWIFIEX_SKB_TXCB(orig_skb);
 			orig_tx_info->ack_frame_id = id;
 			orig_tx_info->flags |= flag;
+
+			if (flag == MWIFIEX_BUF_FLAG_ACTION_TX_STATUS && cookie)
+				orig_tx_info->cookie = *cookie;
+
 		} else if (skb_shared(skb)) {
 			kfree_skb(orig_skb);
 		} else {
@@ -703,7 +707,7 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		     priv->adapter->fw_api_ver == MWIFIEX_FW_V15))
 		skb = mwifiex_clone_skb_for_tx_status(priv,
 						      skb,
-					MWIFIEX_BUF_FLAG_EAPOL_TX_STATUS);
+					MWIFIEX_BUF_FLAG_EAPOL_TX_STATUS, NULL);
 
 	/* Record the current time the packet was queued; used to
 	 * determine the amount of time the packet was queued in
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index e19fc2f..bdba37b 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1342,6 +1342,10 @@ void mwifiex_clean_auto_tdls(struct mwifiex_private *priv);
 void mwifiex_parse_tx_status_event(struct mwifiex_private *priv,
 				   void *event_body);
 
+struct sk_buff *
+mwifiex_clone_skb_for_tx_status(struct mwifiex_private *priv,
+				struct sk_buff *skb, u8 flag, u64 *cookie);
+
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
 void mwifiex_debugfs_remove(void);
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index c69ecbc..b896d73 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -77,7 +77,8 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 	local_tx_pd->pkt_delay_2ms =
 				mwifiex_wmm_compute_drv_pkt_delay(priv, skb);
 
-	if (tx_info->flags & MWIFIEX_BUF_FLAG_EAPOL_TX_STATUS) {
+	if (tx_info->flags & MWIFIEX_BUF_FLAG_EAPOL_TX_STATUS ||
+	    tx_info->flags & MWIFIEX_BUF_FLAG_ACTION_TX_STATUS) {
 		local_tx_pd->tx_token_id = tx_info->ack_frame_id;
 		local_tx_pd->flags |= MWIFIEX_TXPD_FLAGS_REQ_TX_STATUS;
 	}
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 782bfd6..6ae1333 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -209,6 +209,7 @@ void mwifiex_parse_tx_status_event(struct mwifiex_private *priv,
 	struct tx_status_event *tx_status = (void *)priv->adapter->event_body;
 	struct sk_buff *ack_skb;
 	unsigned long flags;
+	struct mwifiex_txinfo *tx_info;
 
 	if (!tx_status->tx_token_id)
 		return;
@@ -219,7 +220,17 @@ void mwifiex_parse_tx_status_event(struct mwifiex_private *priv,
 		idr_remove(&priv->ack_status_frames, tx_status->tx_token_id);
 	spin_unlock_irqrestore(&priv->ack_status_lock, flags);
 
-	/* consumes ack_skb */
-	if (ack_skb)
-		skb_complete_wifi_ack(ack_skb, !tx_status->status);
+	if (ack_skb) {
+		tx_info = MWIFIEX_SKB_TXCB(ack_skb);
+
+		if (tx_info->flags & MWIFIEX_BUF_FLAG_EAPOL_TX_STATUS) {
+			/* consumes ack_skb */
+			skb_complete_wifi_ack(ack_skb, !tx_status->status);
+		} else {
+			cfg80211_mgmt_tx_status(priv->wdev, tx_info->cookie,
+						ack_skb->data, ack_skb->len,
+						!tx_status->status, GFP_ATOMIC);
+			dev_kfree_skb_any(ack_skb);
+		}
+	}
 }
diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index 4580942..e7d326f 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -374,7 +374,8 @@ void *mwifiex_process_uap_txpd(struct mwifiex_private *priv,
 
 	txpd->pkt_delay_2ms = mwifiex_wmm_compute_drv_pkt_delay(priv, skb);
 
-	if (tx_info->flags & MWIFIEX_BUF_FLAG_EAPOL_TX_STATUS) {
+	if (tx_info->flags & MWIFIEX_BUF_FLAG_EAPOL_TX_STATUS ||
+	    tx_info->flags & MWIFIEX_BUF_FLAG_ACTION_TX_STATUS) {
 		txpd->tx_token_id = tx_info->ack_frame_id;
 		txpd->flags |= MWIFIEX_TXPD_FLAGS_REQ_TX_STATUS;
 	}
-- 
1.8.1.4

