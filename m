Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39567 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042AbaKYOos (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 09:44:48 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 4/5] mwifiex: add Tx status support for EAPOL packets
Date: Tue, 25 Nov 2014 06:43:05 -0800
Message-ID: <1416926586-19286-5-git-send-email-akarwar@marvell.com> (sfid-20141125_154454_855983_D5CA6609)
In-Reply-To: <1416926586-19286-1-git-send-email-akarwar@marvell.com>
References: <1416926586-19286-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware notifies the driver through event if EAPOL data packet
has been acked or not. We will inform this status to userspace
listening on a socket.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |  3 ++
 drivers/net/wireless/mwifiex/decl.h      |  2 ++
 drivers/net/wireless/mwifiex/fw.h        | 17 +++++++++--
 drivers/net/wireless/mwifiex/init.c      |  3 ++
 drivers/net/wireless/mwifiex/main.c      | 48 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/main.h      |  7 +++++
 drivers/net/wireless/mwifiex/sta_event.c |  5 ++++
 drivers/net/wireless/mwifiex/sta_tx.c    |  5 ++++
 drivers/net/wireless/mwifiex/txrx.c      | 20 +++++++++++++
 drivers/net/wireless/mwifiex/uap_event.c |  4 +++
 drivers/net/wireless/mwifiex/uap_txrx.c  |  7 ++++-
 drivers/net/wireless/mwifiex/wmm.c       | 10 +++++++
 12 files changed, 127 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 17f0ee0..68d5874 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2988,6 +2988,9 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 			   NL80211_FEATURE_INACTIVITY_TIMER |
 			   NL80211_FEATURE_NEED_OBSS_SCAN;
 
+	if (adapter->fw_api_ver == MWIFIEX_FW_V15)
+		wiphy->features |= NL80211_FEATURE_SK_TX_STATUS;
+
 	/* Reserve space for mwifiex specific private data for BSS */
 	wiphy->bss_priv_size = sizeof(struct mwifiex_bss_priv);
 
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index fc0b1ed..9daa88a 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -76,6 +76,7 @@
 #define MWIFIEX_BUF_FLAG_REQUEUED_PKT      BIT(0)
 #define MWIFIEX_BUF_FLAG_BRIDGED_PKT	   BIT(1)
 #define MWIFIEX_BUF_FLAG_TDLS_PKT	   BIT(2)
+#define MWIFIEX_BUF_FLAG_EAPOL_TX_STATUS   BIT(3)
 
 #define MWIFIEX_BRIDGED_PKTS_THR_HIGH      1024
 #define MWIFIEX_BRIDGED_PKTS_THR_LOW        128
@@ -159,6 +160,7 @@ struct mwifiex_txinfo {
 	u8 bss_num;
 	u8 bss_type;
 	u32 pkt_len;
+	u8 ack_frame_id;
 };
 
 enum mwifiex_wmm_ac_e {
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index e095f37..fb5936e 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -494,6 +494,7 @@ enum P2P_MODES {
 #define EVENT_TDLS_GENERIC_EVENT        0x00000052
 #define EVENT_EXT_SCAN_REPORT           0x00000058
 #define EVENT_REMAIN_ON_CHAN_EXPIRED    0x0000005f
+#define EVENT_TX_STATUS_REPORT		0x00000074
 
 #define EVENT_ID_MASK                   0xffff
 #define BSS_NUM_MASK                    0xf
@@ -542,6 +543,7 @@ struct mwifiex_ie_types_data {
 #define MWIFIEX_TxPD_POWER_MGMT_LAST_PACKET 0x08
 #define MWIFIEX_TXPD_FLAGS_TDLS_PACKET      0x10
 #define MWIFIEX_RXPD_FLAGS_TDLS_PACKET      0x01
+#define MWIFIEX_TXPD_FLAGS_REQ_TX_STATUS    0x20
 
 struct txpd {
 	u8 bss_type;
@@ -553,7 +555,9 @@ struct txpd {
 	u8 priority;
 	u8 flags;
 	u8 pkt_delay_2ms;
-	u8 reserved1;
+	u8 reserved1[2];
+	u8 tx_token_id;
+	u8 reserved[2];
 } __packed;
 
 struct rxpd {
@@ -598,8 +602,9 @@ struct uap_txpd {
 	u8 priority;
 	u8 flags;
 	u8 pkt_delay_2ms;
-	u8 reserved1;
-	__le32 reserved2;
+	u8 reserved1[2];
+	u8 tx_token_id;
+	u8 reserved[2];
 };
 
 struct uap_rxpd {
@@ -1224,6 +1229,12 @@ struct mwifiex_event_scan_result {
 	u8 num_of_set;
 } __packed;
 
+struct tx_status_event {
+	u8 packet_type;
+	u8 tx_token_id;
+	u8 status;
+} __packed;
+
 #define MWIFIEX_USER_SCAN_CHAN_MAX             50
 
 #define MWIFIEX_MAX_SSID_LIST_LENGTH         10
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index cc15ab8..520ad4a 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -473,6 +473,9 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 
 		spin_lock_init(&priv->tx_ba_stream_tbl_lock);
 		spin_lock_init(&priv->rx_reorder_tbl_lock);
+
+		spin_lock_init(&priv->ack_status_lock);
+		idr_init(&priv->ack_status_frames);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index cf07279..cf31d36 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -608,6 +608,44 @@ int mwifiex_queue_tx_pkt(struct mwifiex_private *priv, struct sk_buff *skb)
 	return 0;
 }
 
+static struct sk_buff *
+mwifiex_clone_skb_for_tx_status(struct mwifiex_private *priv,
+				struct sk_buff *skb, u8 flag)
+{
+	struct sk_buff *orig_skb = skb;
+	struct mwifiex_txinfo *tx_info, *orig_tx_info;
+
+	skb = skb_clone(skb, GFP_ATOMIC);
+	if (skb) {
+		unsigned long flags;
+		int id;
+
+		spin_lock_irqsave(&priv->ack_status_lock, flags);
+		id = idr_alloc(&priv->ack_status_frames, orig_skb,
+			       1, 0xff, GFP_ATOMIC);
+		spin_unlock_irqrestore(&priv->ack_status_lock, flags);
+
+		if (id >= 0) {
+			tx_info = MWIFIEX_SKB_TXCB(skb);
+			tx_info->ack_frame_id = id;
+			tx_info->flags |= flag;
+			orig_tx_info = MWIFIEX_SKB_TXCB(orig_skb);
+			orig_tx_info->ack_frame_id = id;
+			orig_tx_info->flags |= flag;
+		} else if (skb_shared(skb)) {
+			kfree_skb(orig_skb);
+		} else {
+			kfree_skb(skb);
+			skb = orig_skb;
+		}
+	} else {
+		/* couldn't clone -- lose tx status ... */
+		skb = orig_skb;
+	}
+
+	return skb;
+}
+
 /*
  * CFG802.11 network device handler for data transmission.
  */
@@ -617,6 +655,7 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	struct sk_buff *new_skb;
 	struct mwifiex_txinfo *tx_info;
+	bool multicast;
 
 	dev_dbg(priv->adapter->dev, "data: %lu BSS(%d-%d): Data <= kernel\n",
 		jiffies, priv->bss_type, priv->bss_num);
@@ -657,6 +696,15 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	tx_info->bss_type = priv->bss_type;
 	tx_info->pkt_len = skb->len;
 
+	multicast = is_multicast_ether_addr(skb->data);
+
+	if (unlikely(!multicast && skb->sk &&
+		     skb_shinfo(skb)->tx_flags & SKBTX_WIFI_STATUS &&
+		     priv->adapter->fw_api_ver == MWIFIEX_FW_V15))
+		skb = mwifiex_clone_skb_for_tx_status(priv,
+						      skb,
+					MWIFIEX_BUF_FLAG_EAPOL_TX_STATUS);
+
 	/* Record the current time the packet was queued; used to
 	 * determine the amount of time the packet was queued in
 	 * the driver before it was sent to the firmware.
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 5a690d5..e19fc2f 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -34,6 +34,7 @@
 #include <linux/firmware.h>
 #include <linux/ctype.h>
 #include <linux/of.h>
+#include <linux/idr.h>
 
 #include "decl.h"
 #include "ioctl.h"
@@ -578,6 +579,9 @@ struct mwifiex_private {
 	u8 check_tdls_tx;
 	struct timer_list auto_tdls_timer;
 	bool auto_tdls_timer_active;
+	struct idr ack_status_frames;
+	/* spin lock for ack status */
+	spinlock_t ack_status_lock;
 };
 
 enum mwifiex_ba_status {
@@ -1335,6 +1339,9 @@ void mwifiex_add_auto_tdls_peer(struct mwifiex_private *priv, const u8 *mac);
 void mwifiex_setup_auto_tdls_timer(struct mwifiex_private *priv);
 void mwifiex_clean_auto_tdls(struct mwifiex_private *priv);
 
+void mwifiex_parse_tx_status_event(struct mwifiex_private *priv,
+				   void *event_body);
+
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
 void mwifiex_debugfs_remove(void);
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 204ecc8..b8c171d 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -504,6 +504,11 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		ret = mwifiex_parse_tdls_event(priv, adapter->event_skb);
 		break;
 
+	case EVENT_TX_STATUS_REPORT:
+		dev_dbg(adapter->dev, "event: TX_STATUS Report\n");
+		mwifiex_parse_tx_status_event(priv, adapter->event_body);
+		break;
+
 	default:
 		dev_dbg(adapter->dev, "event: unknown event id: %#x\n",
 			eventcause);
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index dab7b33..c69ecbc 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -77,6 +77,11 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 	local_tx_pd->pkt_delay_2ms =
 				mwifiex_wmm_compute_drv_pkt_delay(priv, skb);
 
+	if (tx_info->flags & MWIFIEX_BUF_FLAG_EAPOL_TX_STATUS) {
+		local_tx_pd->tx_token_id = tx_info->ack_frame_id;
+		local_tx_pd->flags |= MWIFIEX_TXPD_FLAGS_REQ_TX_STATUS;
+	}
+
 	if (local_tx_pd->priority <
 	    ARRAY_SIZE(priv->wmm.user_pri_pkt_tx_ctrl))
 		/*
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index a5983fc..782bfd6 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -203,3 +203,23 @@ done:
 }
 EXPORT_SYMBOL_GPL(mwifiex_write_data_complete);
 
+void mwifiex_parse_tx_status_event(struct mwifiex_private *priv,
+				   void *event_body)
+{
+	struct tx_status_event *tx_status = (void *)priv->adapter->event_body;
+	struct sk_buff *ack_skb;
+	unsigned long flags;
+
+	if (!tx_status->tx_token_id)
+		return;
+
+	spin_lock_irqsave(&priv->ack_status_lock, flags);
+	ack_skb = idr_find(&priv->ack_status_frames, tx_status->tx_token_id);
+	if (ack_skb)
+		idr_remove(&priv->ack_status_frames, tx_status->tx_token_id);
+	spin_unlock_irqrestore(&priv->ack_status_lock, flags);
+
+	/* consumes ack_skb */
+	if (ack_skb)
+		skb_complete_wifi_ack(ack_skb, !tx_status->status);
+}
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index 7c2b9766..38390cb 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -172,6 +172,10 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 			return mwifiex_handle_event_ext_scan_report(priv,
 						adapter->event_skb->data);
 		break;
+	case EVENT_TX_STATUS_REPORT:
+		dev_dbg(adapter->dev, "event: TX_STATUS Report\n");
+		mwifiex_parse_tx_status_event(priv, adapter->event_body);
+		break;
 	default:
 		dev_dbg(adapter->dev, "event: unknown event id: %#x\n",
 			eventcause);
diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index ec7309d..4580942 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -370,10 +370,15 @@ void *mwifiex_process_uap_txpd(struct mwifiex_private *priv,
 	txpd->bss_num = priv->bss_num;
 	txpd->bss_type = priv->bss_type;
 	txpd->tx_pkt_length = cpu_to_le16((u16)(skb->len - len));
-
 	txpd->priority = (u8)skb->priority;
+
 	txpd->pkt_delay_2ms = mwifiex_wmm_compute_drv_pkt_delay(priv, skb);
 
+	if (tx_info->flags & MWIFIEX_BUF_FLAG_EAPOL_TX_STATUS) {
+		txpd->tx_token_id = tx_info->ack_frame_id;
+		txpd->flags |= MWIFIEX_TXPD_FLAGS_REQ_TX_STATUS;
+	}
+
 	if (txpd->priority < ARRAY_SIZE(priv->wmm.user_pri_pkt_tx_ctrl))
 		/*
 		 * Set the priority specific tx_control field, setting of 0 will
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 94c98a8..dc1f2ad 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -523,6 +523,13 @@ static void mwifiex_wmm_delete_all_ralist(struct mwifiex_private *priv)
 	}
 }
 
+static int mwifiex_free_ack_frame(int id, void *p, void *data)
+{
+	pr_warn("Have pending ack frames!\n");
+	kfree_skb(p);
+	return 0;
+}
+
 /*
  * This function cleans up the Tx and Rx queues.
  *
@@ -558,6 +565,9 @@ mwifiex_clean_txrx(struct mwifiex_private *priv)
 
 	skb_queue_walk_safe(&priv->tdls_txq, skb, tmp)
 		mwifiex_write_data_complete(priv->adapter, skb, 0, -1);
+
+	idr_for_each(&priv->ack_status_frames, mwifiex_free_ack_frame, NULL);
+	idr_destroy(&priv->ack_status_frames);
 }
 
 /*
-- 
1.8.1.4

