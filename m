Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:43334 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756756Ab1CROUf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 10:20:35 -0400
Received: by wyj26 with SMTP id 26so3515137wyj.10
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 07:20:24 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: shahar_levi@ti.com, ruthyz@ti.com
Subject: [PATCH v2 11/14] wl12xx: 1281/1283 support - Add dummy packet support
Date: Fri, 18 Mar 2011 16:19:26 +0200
Message-Id: <1300457969-19601-12-git-send-email-coelho@ti.com>
In-Reply-To: <1300457969-19601-1-git-send-email-coelho@ti.com>
References: <1300457969-19601-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shahar Levi <shahar_levi@ti.com>

Support sending dummy packet to wl128x FW as results of
dummy packet event. That is part of dynamic TX mem blocks mechanism.

Only send dummy packet when not in AP mode.

[Even though the DUMMY_PACKET_EVENT_ID and the
STA_REMOVE_COMPLETE_EVENT_ID events are defined to the same value, we
need to treat them separately in the code.  Keep the check and enable
STA_REMOVE_COMPLETE_EVENT_ID for AP mode and DUMMY_PACKET_EVENT_ID for
STA.  Moved one warning to a cleaner place.  Use WL1271_TID_MGMT for
dummy packets -- Luca]

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
Reviewed-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/boot.c  |    2 +
 drivers/net/wireless/wl12xx/event.c |    6 +++
 drivers/net/wireless/wl12xx/event.h |    5 ++-
 drivers/net/wireless/wl12xx/io.h    |    1 +
 drivers/net/wireless/wl12xx/main.c  |   42 +++++++++++++++++++
 drivers/net/wireless/wl12xx/tx.c    |   75 +++++++++++++++++++++++++---------
 drivers/net/wireless/wl12xx/tx.h    |    6 +++
 7 files changed, 116 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 9d742c1..34bf2fe 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -482,6 +482,8 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 
 	if (wl->bss_type == BSS_TYPE_AP_BSS)
 		wl->event_mask |= STA_REMOVE_COMPLETE_EVENT_ID;
+	else
+		wl->event_mask |= DUMMY_PACKET_EVENT_ID;
 
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
index 84454f6..e6199eb 100644
--- a/drivers/net/wireless/wl12xx/io.h
+++ b/drivers/net/wireless/wl12xx/io.h
@@ -170,5 +170,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void);
 int wl1271_free_hw(struct wl1271 *wl);
 irqreturn_t wl1271_irq(int irq, void *data);
 bool wl1271_set_block_size(struct wl1271 *wl);
+int wl1271_tx_dummy_packet(struct wl1271 *wl);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 3c381ce..54ac675 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1174,6 +1174,48 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 }
 
+#define TX_DUMMY_PACKET_SIZE 1400
+int wl1271_tx_dummy_packet(struct wl1271 *wl)
+{
+	struct sk_buff *skb = NULL;
+	struct ieee80211_hdr_3addr *hdr;
+	int ret = 0;
+
+	skb = dev_alloc_skb(
+		sizeof(struct wl1271_tx_hw_descr) + sizeof(*hdr) +
+		TX_DUMMY_PACKET_SIZE);
+	if (!skb) {
+		wl1271_warning("failed to allocate buffer for dummy packet");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	skb_reserve(skb, sizeof(struct wl1271_tx_hw_descr));
+
+	hdr = (struct ieee80211_hdr_3addr *) skb_put(skb, sizeof(*hdr));
+	memset(hdr, 0, sizeof(*hdr));
+	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |
+					 IEEE80211_FCTL_TODS  |
+					 IEEE80211_STYPE_NULLFUNC);
+
+	memcpy(hdr->addr1, wl->bssid, ETH_ALEN);
+	memcpy(hdr->addr2, wl->mac_addr, ETH_ALEN);
+	memcpy(hdr->addr3, wl->bssid, ETH_ALEN);
+
+	skb_put(skb, TX_DUMMY_PACKET_SIZE);
+
+	memset(skb->data, 0, TX_DUMMY_PACKET_SIZE);
+
+	skb->pkt_type = TX_PKT_TYPE_DUMMY_REQ;
+	/* CONF_TX_AC_VO */
+	skb->queue_mapping = 0;
+
+	wl1271_op_tx(wl->hw, skb);
+
+out:
+	return ret;
+}
+
 static struct notifier_block wl1271_dev_notifier = {
 	.notifier_call = wl1271_dev_notify,
 };
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index afc8505..75222a6 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -215,13 +215,29 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	else
 		desc->life_time = cpu_to_le16(TX_HW_AP_MODE_PKT_LIFETIME_TU);
 
-	/* configure the tx attributes */
-	tx_attr = wl->session_counter << TX_HW_ATTR_OFST_SESSION_COUNTER;
-
 	/* queue (we use same identifiers for tid's and ac's */
 	ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 	desc->tid = ac;
 
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
+
+		/* Dummy packets require the TID to be management */
+		desc->tid = WL1271_TID_MGMT;
+	} else {
+		/* configure the tx attributes */
+		tx_attr =
+			wl->session_counter << TX_HW_ATTR_OFST_SESSION_COUNTER;
+	}
+
 	if (wl->bss_type != BSS_TYPE_AP_BSS) {
 		desc->aid = hlid;
 
@@ -587,6 +603,12 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
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
@@ -716,10 +738,15 @@ void wl1271_tx_reset(struct wl1271 *wl)
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
@@ -740,21 +767,29 @@ void wl1271_tx_reset(struct wl1271 *wl)
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
index e313177..6f45e91 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -41,6 +41,9 @@
 					  BIT(8) | BIT(9))
 #define TX_HW_ATTR_LAST_WORD_PAD         (BIT(10) | BIT(11))
 #define TX_HW_ATTR_TX_CMPLT_REQ          BIT(12)
+#define TX_HW_ATTR_TX_DUMMY_REQ          BIT(13)
+
+#define TX_PKT_TYPE_DUMMY_REQ            5
 
 #define TX_HW_ATTR_OFST_SAVE_RETRIES     0
 #define TX_HW_ATTR_OFST_HEADER_PAD       1
@@ -55,6 +58,9 @@
 #define WL1271_TX_ALIGN_TO 4
 #define WL1271_TKIP_IV_SPACE 4
 
+/* Used for management frames and dummy packets */
+#define WL1271_TID_MGMT 7
+
 struct wl127x_tx_mem {
 	/*
 	 * Number of extra memory blocks to allocate for this packet
-- 
1.7.1

