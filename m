Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36108 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab1HNKR1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:17:27 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so4060970wwf.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:17:27 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 12/40] wl12xx: update rx/tx
Date: Sun, 14 Aug 2011 13:17:11 +0300
Message-Id: <1313317059-16567-13-git-send-email-eliad@wizery.com> (sfid-20110814_124257_150798_62B3AB5B)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the rx/tx descriptors according to the new fw api
(fw >= 6/7.3.0.0.75)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/rx.h     |    7 ++-----
 drivers/net/wireless/wl12xx/tx.c     |   15 +++++++++++----
 drivers/net/wireless/wl12xx/tx.h     |   14 ++++----------
 drivers/net/wireless/wl12xx/wl12xx.h |    2 +-
 4 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/rx.h b/drivers/net/wireless/wl12xx/rx.h
index 00c1c1d..86ba6b1 100644
--- a/drivers/net/wireless/wl12xx/rx.h
+++ b/drivers/net/wireless/wl12xx/rx.h
@@ -83,13 +83,13 @@
  * RX Descriptor status
  *
  * Bits 0-2 - error code
  * Bits 3-5 - process_id tag (AP mode FW)
  * Bits 6-7 - reserved
  */
-#define WL1271_RX_DESC_STATUS_MASK      0x07
+#define WL1271_RX_DESC_STATUS_MASK      0x03
 
 #define WL1271_RX_DESC_SUCCESS          0x00
 #define WL1271_RX_DESC_DECRYPT_FAIL     0x01
 #define WL1271_RX_DESC_MIC_FAIL         0x02
 #define WL1271_RX_DESC_DRIVER_RX_Q_FAIL 0x03
 
@@ -118,16 +118,13 @@ struct wl1271_rx_descriptor {
 	u8  rate;
 	u8  channel;
 	s8  rssi;
 	u8  snr;
 	__le32 timestamp;
 	u8  packet_class;
-	union {
-		u8  process_id; /* STA FW */
-		u8  hlid; /* AP FW */
-	} __packed;
+	u8  hlid;
 	u8  pad_len;
 	u8  reserved;
 } __packed;
 
 void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status);
 u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index f497336..23ce7aa 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -273,24 +273,23 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	} else {
 		/* configure the tx attributes */
 		tx_attr =
 			wl->session_counter << TX_HW_ATTR_OFST_SESSION_COUNTER;
 	}
 
-	if (wl->bss_type != BSS_TYPE_AP_BSS) {
-		desc->aid = hlid;
+	desc->hlid = hlid;
 
+	if (wl->bss_type != BSS_TYPE_AP_BSS) {
 		/* if the packets are destined for AP (have a STA entry)
 		   send them with AP rate policies, otherwise use default
 		   basic rates */
 		if (control->control.sta)
 			rate_idx = ACX_TX_AP_FULL_RATE;
 		else
 			rate_idx = ACX_TX_BASIC_RATE;
 	} else {
-		desc->hlid = hlid;
 		switch (hlid) {
 		case WL1271_AP_GLOBAL_HLID:
 			rate_idx = ACX_TX_AP_MODE_MGMT_RATE;
 			break;
 		case WL1271_AP_BROADCAST_HLID:
 			rate_idx = ACX_TX_AP_MODE_BCST_RATE;
@@ -372,13 +371,21 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 		}
 	}
 
 	if (wl->bss_type == BSS_TYPE_AP_BSS)
 		hlid = wl1271_tx_get_hlid(skb);
 	else
-		hlid = TX_HW_DEFAULT_AID;
+		if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
+			hlid = wl->sta_hlid;
+		else
+			hlid = wl->dev_hlid;
+
+	if (hlid == WL12XX_INVALID_LINK_ID) {
+		wl1271_error("invalid hlid. dropping skb 0x%p", skb);
+		return -EINVAL;
+	}
 
 	ret = wl1271_tx_allocate(wl, skb, extra, buf_offset, hlid);
 	if (ret < 0)
 		return ret;
 
 	wl1271_tx_fill_hdr(wl, skb, extra, info, hlid);
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index 5d719b5..b712d7b 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -26,15 +26,12 @@
 #define __TX_H__
 
 #define TX_HW_BLOCK_SIZE                 252
 
 #define TX_HW_MGMT_PKT_LIFETIME_TU       2000
 #define TX_HW_AP_MODE_PKT_LIFETIME_TU    8000
-/* The chipset reference driver states, that the "aid" value 1
- * is for infra-BSS, but is still always used */
-#define TX_HW_DEFAULT_AID                1
 
 #define TX_HW_ATTR_SAVE_RETRIES          BIT(0)
 #define TX_HW_ATTR_HEADER_PAD            BIT(1)
 #define TX_HW_ATTR_SESSION_COUNTER       (BIT(2) | BIT(3) | BIT(4))
 #define TX_HW_ATTR_RATE_POLICY           (BIT(5) | BIT(6) | BIT(7) | \
 					  BIT(8) | BIT(9))
@@ -113,30 +110,27 @@ struct wl1271_tx_hw_descr {
 	/* Bitwise fields - see TX_ATTR... definitions above. */
 	__le16 tx_attr;
 	/* Packet identifier used also in the Tx-Result. */
 	u8 id;
 	/* The packet TID value (as User-Priority) */
 	u8 tid;
-	union {
-		/* STA - Identifier of the remote STA in IBSS, 1 in infra-BSS */
-		u8 aid;
-		/* AP - host link ID (HLID) */
-		u8 hlid;
-	} __packed;
+	/* host link ID (HLID) */
+	u8 hlid;
 	u8 reserved;
 } __packed;
 
 enum wl1271_tx_hw_res_status {
 	TX_SUCCESS          = 0,
 	TX_HW_ERROR         = 1,
 	TX_DISABLED         = 2,
 	TX_RETRY_EXCEEDED   = 3,
 	TX_TIMEOUT          = 4,
 	TX_KEY_NOT_FOUND    = 5,
 	TX_PEER_NOT_FOUND   = 6,
-	TX_SESSION_MISMATCH = 7
+	TX_SESSION_MISMATCH = 7,
+	TX_LINK_NOT_VALID   = 8,
 };
 
 struct wl1271_tx_hw_res_descr {
 	/* Packet Identifier - same value used in the Tx descriptor.*/
 	u8 id;
 	/* The status of the transmission, indicating success or one of
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index ab46664..93e689d 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -156,13 +156,13 @@ extern u32 wl12xx_debug_level;
  */
 #define WL1271_PS_STA_MAX_BLOCKS  (2 * 9)
 
 #define WL1271_AP_BSS_INDEX        0
 #define WL1271_AP_DEF_BEACON_EXP   20
 
-#define ACX_TX_DESCRIPTORS         32
+#define ACX_TX_DESCRIPTORS         16
 
 #define WL1271_AGGR_BUFFER_SIZE (4 * PAGE_SIZE)
 
 enum wl1271_state {
 	WL1271_STATE_OFF,
 	WL1271_STATE_ON,
-- 
1.7.6.401.g6a319

