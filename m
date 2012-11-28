Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36268 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab2K1JnI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:43:08 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so4384742wer.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 01:43:07 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 06/20] wlcore: improve handling for Rx errors
Date: Wed, 28 Nov 2012 11:42:35 +0200
Message-Id: <1354095769-8724-7-git-send-email-arik@wizery.com> (sfid-20121128_104402_476615_D63EC8C8)
In-Reply-To: <1354095769-8724-1-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Treat Rx error code as a bitmask. This allows sending MIC failures
when other error bit are on.

Align Rx descriptor status mask to the FW definition.

Ease debugging in case FW reports failure to decrypt on packets.

Discard corrupted packets early in Rx path to avoid reporting other
abnormalities with corrupted packets that also have other failure bytes on.
Namely - we don't want to get a MIC failure on a corrupted packet.
This is mandated by the WiFi specification - see
section 11.4.2.4.1 in 802.11-2012.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/rx.c |   29 ++++++++++++++---------------
 drivers/net/wireless/ti/wlcore/rx.h |    3 +--
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index 4665b96..6791a1a 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -92,9 +92,10 @@ static void wl1271_rx_status(struct wl1271 *wl,
 		status->flag |= RX_FLAG_IV_STRIPPED | RX_FLAG_MMIC_STRIPPED |
 				RX_FLAG_DECRYPTED;
 
-		if (unlikely(desc_err_code == WL1271_RX_DESC_MIC_FAIL)) {
+		if (unlikely(desc_err_code & WL1271_RX_DESC_MIC_FAIL)) {
 			status->flag |= RX_FLAG_MMIC_ERROR;
-			wl1271_warning("Michael MIC error");
+			wl1271_warning("Michael MIC error. Desc: 0x%x",
+				       desc_err_code);
 		}
 	}
 
@@ -112,7 +113,7 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 	u8 *buf;
 	u8 beacon = 0;
 	u8 is_data = 0;
-	u8 reserved = 0;
+	u8 reserved = 0, offset_to_data = 0;
 	u16 seq_num;
 	u32 pkt_data_len;
 
@@ -132,6 +133,8 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 
 	if (rx_align == WLCORE_RX_BUF_UNALIGNED)
 		reserved = RX_BUF_ALIGN;
+	else if (rx_align == WLCORE_RX_BUF_PADDED)
+		offset_to_data = RX_BUF_ALIGN;
 
 	/* the data read starts with the descriptor */
 	desc = (struct wl1271_rx_descriptor *) data;
@@ -143,19 +146,15 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 		return 0;
 	}
 
-	switch (desc->status & WL1271_RX_DESC_STATUS_MASK) {
 	/* discard corrupted packets */
-	case WL1271_RX_DESC_DRIVER_RX_Q_FAIL:
-	case WL1271_RX_DESC_DECRYPT_FAIL:
-		wl1271_warning("corrupted packet in RX with status: 0x%x",
-			       desc->status & WL1271_RX_DESC_STATUS_MASK);
-		return -EINVAL;
-	case WL1271_RX_DESC_SUCCESS:
-	case WL1271_RX_DESC_MIC_FAIL:
-		break;
-	default:
-		wl1271_error("invalid RX descriptor status: 0x%x",
-			     desc->status & WL1271_RX_DESC_STATUS_MASK);
+	if (desc->status & WL1271_RX_DESC_DECRYPT_FAIL) {
+		hdr = (void *)(data + sizeof(*desc) + offset_to_data);
+		wl1271_warning("corrupted packet in RX: status: 0x%x len: %d",
+			       desc->status & WL1271_RX_DESC_STATUS_MASK,
+			       pkt_data_len);
+		wl1271_dump((DEBUG_RX|DEBUG_CMD), "PKT: ", data + sizeof(*desc),
+			    min(pkt_data_len,
+				ieee80211_hdrlen(hdr->frame_control)));
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/wireless/ti/wlcore/rx.h b/drivers/net/wireless/ti/wlcore/rx.h
index 71eba18..3363f60 100644
--- a/drivers/net/wireless/ti/wlcore/rx.h
+++ b/drivers/net/wireless/ti/wlcore/rx.h
@@ -84,12 +84,11 @@
  * Bits 3-5 - process_id tag (AP mode FW)
  * Bits 6-7 - reserved
  */
-#define WL1271_RX_DESC_STATUS_MASK      0x03
+#define WL1271_RX_DESC_STATUS_MASK      0x07
 
 #define WL1271_RX_DESC_SUCCESS          0x00
 #define WL1271_RX_DESC_DECRYPT_FAIL     0x01
 #define WL1271_RX_DESC_MIC_FAIL         0x02
-#define WL1271_RX_DESC_DRIVER_RX_Q_FAIL 0x03
 
 #define RX_MEM_BLOCK_MASK            0xFF
 #define RX_BUF_SIZE_MASK             0xFFF00
-- 
1.7.9.5

