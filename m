Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:44356 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab1CFO2U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 09:28:20 -0500
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id p26ESKsV026281
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 6 Mar 2011 08:28:20 -0600
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH 09/15] wl12xx: 1281/1283 support - Add dummy packet support
Date: Sun,  6 Mar 2011 16:32:14 +0200
Message-Id: <1299421940-26292-10-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
References: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support sending dummy packet to wl128x FW as results of
dummy packet event. That is part of dynamic TX mem blocks mechanism.

Only send dummy packet when not in AP mode (Thanks to
Ido Yariv" <ido@wizery.com> and Arik Nemtsov" <arik@wizery.com> for this one)

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/boot.c  |    7 +--
 drivers/net/wireless/wl12xx/event.c |    6 +++
 drivers/net/wireless/wl12xx/event.h |    5 ++-
 drivers/net/wireless/wl12xx/io.h    |    1 +
 drivers/net/wireless/wl12xx/main.c  |   40 ++++++++++++++++++++
 drivers/net/wireless/wl12xx/tx.c    |   70 +++++++++++++++++++++++++---------
 drivers/net/wireless/wl12xx/tx.h    |    4 ++
 7 files changed, 109 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 2f40909..d92c90a 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -476,10 +476,9 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 		DISCONNECT_EVENT_COMPLETE_ID |
 		RSSI_SNR_TRIGGER_0_EVENT_ID |
 		PSPOLL_DELIVERY_FAILURE_EVENT_ID |
-		SOFT_GEMINI_SENSE_EVENT_ID;
-
-	if (wl->bss_type == BSS_TYPE_AP_BSS)
-		wl->event_mask |= STA_REMOVE_COMPLETE_EVENT_ID;
+		SOFT_GEMINI_SENSE_EVENT_ID |
+		/* The same value as STA_REMOVE_COMPLETE_EVENT_ID */
+		DUMMY_PACKET_EVENT_ID;
 
 	ret = wl1271_event_unmask(wl);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index 1b170c5..413d901 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -228,6 +228,12 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 			wl1271_event_rssi_trigger(wl, mbox);
 	}
 
+	if ((vector & DUMMY_PACKET_EVENT_ID) && !is_ap) {
+		wl1271_debug(DEBUG_EVENT, "DUMMY_PACKET_ID_EVENT_ID");
+		if (wl->vif)
+			wl1271_tx_dummy_packet(wl);
+	}
+
 	if (wl->vif && beacon_loss)
 		ieee80211_connection_loss(wl->vif);
 
diff --git a/drivers/net/wireless/wl12xx/event.h b/drivers/net/wireless/wl12xx/event.h
index 0e80886..b6cf06e 100644
--- a/drivers/net/wireless/wl12xx/event.h
+++ b/drivers/net/wireless/wl12xx/event.h
@@ -59,7 +59,10 @@ enum {
 	BSS_LOSE_EVENT_ID			 = BIT(18),
 	REGAINED_BSS_EVENT_ID			 = BIT(19),
 	ROAMING_TRIGGER_MAX_TX_RETRY_EVENT_ID	 = BIT(20),
-	STA_REMOVE_COMPLETE_EVENT_ID		 = BIT(21), /* AP */
+	/* STA: dummy paket for dynamic mem blocks */
+	DUMMY_PACKET_EVENT_ID                    = BIT(21),
+	/* AP: STA remove complete */
+	STA_REMOVE_COMPLETE_EVENT_ID             = BIT(21),
 	SOFT_GEMINI_SENSE_EVENT_ID		 = BIT(22),
 	SOFT_GEMINI_PREDICTION_EVENT_ID		 = BIT(23),
 	SOFT_GEMINI_AVALANCHE_EVENT_ID		 = BIT(24),
diff --git a/drivers/net/wireless/wl12xx/io.h b/drivers/net/wireless/wl12xx/io.h
index 9ae2f4a..4ea1a77 100644
--- a/drivers/net/wireless/wl12xx/io.h
+++ b/drivers/net/wireless/wl12xx/io.h
@@ -170,5 +170,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void);
 int wl1271_free_hw(struct wl1271 *wl);
 irqreturn_t wl1271_irq(int irq, void *data);
 void wl1271_set_block_size(struct wl1271 *wl);
+int wl1271_tx_dummy_packet(struct wl1271 *wl);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 94f99ae..32d963d 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1185,6 +1185,46 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 }
 
+int wl1271_tx_dummy_packet(struct wl1271 *wl)
+{
+	struct sk_buff *skb = NULL;
+	struct ieee80211_hdr_3addr *hdr;
+	int ret = 0;
+
+	/* 1400 = Regular mpdu size without aggregation */
+	skb = dev_alloc_skb(
+		sizeof(struct wl1271_tx_hw_descr) + sizeof(*hdr) + 1400);
+	if (!skb) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	skb_reserve(skb, sizeof(struct wl1271_tx_hw_descr));
+
+	hdr = (struct ieee80211_hdr_3addr *) skb_put(skb, sizeof(*hdr));
+	memset(hdr, 0, sizeof(*hdr));
+	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |
+					 IEEE80211_FCTL_TODS);
+
+	memcpy(hdr->addr1, wl->bssid, ETH_ALEN);
+	memcpy(hdr->addr2, wl->mac_addr, ETH_ALEN);
+	memcpy(hdr->addr3, wl->bssid, ETH_ALEN);
+
+	skb_put(skb, 1400);
+
+	skb->pkt_type = TX_PKT_TYPE_DUMMY_REQ;
+	/* CONF_TX_AC_VO */
+	skb->queue_mapping = 0;
+
+	wl1271_op_tx(wl->hw, skb);
+
+out:
+	if (ret)
+		wl1271_warning("failed to allocate buffer for dummy packet");
+
+	return ret;
+}
+
 static struct notifier_block wl1271_dev_notifier = {
 	.notifier_call = wl1271_dev_notify,
 };
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index a7cec1c..441c7de 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -216,8 +216,21 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	else
 		desc->life_time = cpu_to_le16(TX_HW_AP_MODE_PKT_LIFETIME_TU);
 
-	/* configure the tx attributes */
-	tx_attr = wl->session_counter << TX_HW_ATTR_OFST_SESSION_COUNTER;
+	if (skb->pkt_type == TX_PKT_TYPE_DUMMY_REQ) {
+		/*
+		 * FW expects the dummy packet to have an invalid session id -
+		 * any session id that is different than the one set in the join
+		 */
+		tx_attr = ((~wl->session_counter) <<
+			   TX_HW_ATTR_OFST_SESSION_COUNTER) &
+			   TX_HW_ATTR_SESSION_COUNTER;
+
+		tx_attr |= TX_HW_ATTR_TX_DUMMY_REQ;
+	} else {
+		/* configure the tx attributes */
+		tx_attr =
+			wl->session_counter << TX_HW_ATTR_OFST_SESSION_COUNTER;
+	}
 
 	/* queue (we use same identifiers for tid's and ac's */
 	ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
@@ -590,6 +603,12 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 	skb = wl->tx_frames[id];
 	info = IEEE80211_SKB_CB(skb);
 
+	if (skb->pkt_type == TX_PKT_TYPE_DUMMY_REQ) {
+		dev_kfree_skb(skb);
+		wl1271_free_tx_id(wl, id);
+		return;
+	}
+
 	/* update the TX status info */
 	if (result->status == TX_SUCCESS) {
 		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
@@ -719,10 +738,15 @@ void wl1271_tx_reset(struct wl1271 *wl)
 			while ((skb = skb_dequeue(&wl->tx_queue[i]))) {
 				wl1271_debug(DEBUG_TX, "freeing skb 0x%p",
 					     skb);
-				info = IEEE80211_SKB_CB(skb);
-				info->status.rates[0].idx = -1;
-				info->status.rates[0].count = 0;
-				ieee80211_tx_status(wl->hw, skb);
+
+				if (skb->pkt_type == TX_PKT_TYPE_DUMMY_REQ) {
+					dev_kfree_skb(skb);
+				} else {
+					info = IEEE80211_SKB_CB(skb);
+					info->status.rates[0].idx = -1;
+					info->status.rates[0].count = 0;
+					ieee80211_tx_status(wl->hw, skb);
+				}
 			}
 		}
 	}
@@ -743,21 +767,29 @@ void wl1271_tx_reset(struct wl1271 *wl)
 		wl1271_free_tx_id(wl, i);
 		wl1271_debug(DEBUG_TX, "freeing skb 0x%p", skb);
 
-		/* Remove private headers before passing the skb to mac80211 */
-		info = IEEE80211_SKB_CB(skb);
-		skb_pull(skb, sizeof(struct wl1271_tx_hw_descr));
-		if (info->control.hw_key &&
-		    info->control.hw_key->cipher == WLAN_CIPHER_SUITE_TKIP) {
-			int hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-			memmove(skb->data + WL1271_TKIP_IV_SPACE, skb->data,
-				hdrlen);
-			skb_pull(skb, WL1271_TKIP_IV_SPACE);
-		}
+		if (skb->pkt_type == TX_PKT_TYPE_DUMMY_REQ) {
+			dev_kfree_skb(skb);
+		} else {
+			/*
+			 * Remove private headers before passing the skb to
+			 * mac80211
+			 */
+			info = IEEE80211_SKB_CB(skb);
+			skb_pull(skb, sizeof(struct wl1271_tx_hw_descr));
+			if (info->control.hw_key &&
+			    info->control.hw_key->cipher ==
+			    WLAN_CIPHER_SUITE_TKIP) {
+				int hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+				memmove(skb->data + WL1271_TKIP_IV_SPACE,
+					skb->data, hdrlen);
+				skb_pull(skb, WL1271_TKIP_IV_SPACE);
+			}
 
-		info->status.rates[0].idx = -1;
-		info->status.rates[0].count = 0;
+			info->status.rates[0].idx = -1;
+			info->status.rates[0].count = 0;
 
-		ieee80211_tx_status(wl->hw, skb);
+			ieee80211_tx_status(wl->hw, skb);
+		}
 	}
 }
 
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index 3072f95..0dbd8f5 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -41,6 +41,7 @@
 					  BIT(8) | BIT(9))
 #define TX_HW_ATTR_LAST_WORD_PAD         (BIT(10) | BIT(11))
 #define TX_HW_ATTR_TX_CMPLT_REQ          BIT(12)
+#define TX_HW_ATTR_TX_DUMMY_REQ          BIT(13)
 
 #define TX_HW_ATTR_OFST_SAVE_RETRIES     0
 #define TX_HW_ATTR_OFST_HEADER_PAD       1
@@ -48,6 +49,9 @@
 #define TX_HW_ATTR_OFST_RATE_POLICY      5
 #define TX_HW_ATTR_OFST_LAST_WORD_PAD    10
 #define TX_HW_ATTR_OFST_TX_CMPLT_REQ     12
+#define TX_HW_ATTR_OFST_TX_DUMMY_REQ     13
+
+#define TX_PKT_TYPE_DUMMY_REQ            5
 
 #define TX_HW_RESULT_QUEUE_LEN           16
 #define TX_HW_RESULT_QUEUE_LEN_MASK      0xf
-- 
1.7.0.4

