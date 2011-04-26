Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58118 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab1DZUfu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 16:35:50 -0400
Received: by wwa36 with SMTP id 36so1154709wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 13:35:49 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/2] wl12xx: discard corrupted packets in RX
Date: Tue, 26 Apr 2011 23:35:40 +0300
Message-Id: <1303850140-11230-2-git-send-email-arik@wizery.com> (sfid-20110426_223622_802240_DF69311D)
In-Reply-To: <1303850140-11230-1-git-send-email-arik@wizery.com>
References: <1303850140-11230-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When packets arrive with a RX descriptor indicating corruption, discard
them.

In general white-list the RX descriptor status to prevent rouge data
from being sent up.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/rx.c |   33 ++++++++++++++++++++++++++-------
 1 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index faf5a1d..7009103 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -76,12 +76,15 @@ static void wl1271_rx_status(struct wl1271 *wl,
 						      status->band);
 
 	if (desc->flags & WL1271_RX_DESC_ENCRYPT_MASK) {
-		status->flag |= RX_FLAG_IV_STRIPPED | RX_FLAG_MMIC_STRIPPED;
+		u8 desc_err_code = desc->status & WL1271_RX_DESC_STATUS_MASK;
 
-		if (likely(!(desc->status & WL1271_RX_DESC_DECRYPT_FAIL)))
-			status->flag |= RX_FLAG_DECRYPTED;
-		if (unlikely(desc->status & WL1271_RX_DESC_MIC_FAIL))
+		status->flag |= RX_FLAG_IV_STRIPPED | RX_FLAG_MMIC_STRIPPED |
+				RX_FLAG_DECRYPTED;
+
+		if (unlikely(desc_err_code == WL1271_RX_DESC_MIC_FAIL)) {
 			status->flag |= RX_FLAG_MMIC_ERROR;
+			wl1271_warning("Michael MIC error");
+		}
 	}
 }
 
@@ -100,6 +103,25 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length)
 	if (unlikely(wl->state == WL1271_STATE_PLT))
 		return -EINVAL;
 
+	/* the data read starts with the descriptor */
+	desc = (struct wl1271_rx_descriptor *) data;
+
+	switch (desc->status & WL1271_RX_DESC_STATUS_MASK) {
+	/* discard corrupted packets */
+	case WL1271_RX_DESC_DRIVER_RX_Q_FAIL:
+	case WL1271_RX_DESC_DECRYPT_FAIL:
+		wl1271_warning("corrupted packet in RX with status: 0x%x",
+			       desc->status & WL1271_RX_DESC_STATUS_MASK);
+		return -EINVAL;
+	case WL1271_RX_DESC_SUCCESS:
+	case WL1271_RX_DESC_MIC_FAIL:
+		break;
+	default:
+		wl1271_error("invalid RX descriptor status: 0x%x",
+			     desc->status & WL1271_RX_DESC_STATUS_MASK);
+		return -EINVAL;
+	}
+
 	skb = __dev_alloc_skb(length, GFP_KERNEL);
 	if (!skb) {
 		wl1271_error("Couldn't allocate RX frame");
@@ -109,9 +131,6 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length)
 	buf = skb_put(skb, length);
 	memcpy(buf, data, length);
 
-	/* the data read starts with the descriptor */
-	desc = (struct wl1271_rx_descriptor *) buf;
-
 	/* now we pull the descriptor out of the buffer */
 	skb_pull(skb, sizeof(*desc));
 
-- 
1.7.1

