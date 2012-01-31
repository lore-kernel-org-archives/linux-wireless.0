Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48217 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab2AaPvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 10:51:19 -0500
Received: by mail-ww0-f44.google.com with SMTP id dt10so118881wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 07:51:19 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] wl12xx: add TX_HW_ATTR_HOST_ENCRYPT flag
Date: Tue, 31 Jan 2012 17:54:42 +0200
Message-Id: <1328025283-22888-3-git-send-email-eliad@wizery.com> (sfid-20120131_165124_530917_88177AA3)
In-Reply-To: <1328025283-22888-1-git-send-email-eliad@wizery.com>
References: <1328025283-22888-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In WEP shared authentication, we encrypt the auth frame
in the host, and we want the fw to pass it as-is.
Use the TX_HW_ATTR_HOST_ENCRYPT flag in order to indicate
it to the fw.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
depends on the "wl12xx: update fw api" patchset

 drivers/net/wireless/wl12xx/tx.c |   17 +++++++++++++----
 drivers/net/wireless/wl12xx/tx.h |    1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index ee313e7..1f5cc2a 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -255,16 +255,20 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	int aligned_len, ac, rate_idx;
 	s64 hosttime;
 	u16 tx_attr = 0;
+	__le16 frame_control;
+	struct ieee80211_hdr *hdr;
+	u8 *frame_start;
 	bool is_dummy;
 
 	desc = (struct wl1271_tx_hw_descr *) skb->data;
+	frame_start = (u8 *)(desc + 1);
+	hdr = (struct ieee80211_hdr *)(frame_start + extra);
+	frame_control = hdr->frame_control;
 
 	/* relocate space for security header */
 	if (extra) {
-		void *framestart = skb->data + sizeof(*desc);
-		u16 fc = *(u16 *)(framestart + extra);
-		int hdrlen = ieee80211_hdrlen(cpu_to_le16(fc));
-		memmove(framestart, framestart + extra, hdrlen);
+		int hdrlen = ieee80211_hdrlen(frame_control);
+		memmove(frame_start, hdr, hdrlen);
 	}
 
 	/* configure packet life time */
@@ -353,6 +357,11 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			     desc->wl127x_mem.total_mem_blocks);
 	}
 
+	/* for WEP shared auth - no fw encryption is needed */
+	if (ieee80211_is_auth(frame_control) &&
+	    ieee80211_has_protected(frame_control))
+		tx_attr |= TX_HW_ATTR_HOST_ENCRYPT;
+
 	desc->tx_attr = cpu_to_le16(tx_attr);
 }
 
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index 2dbb24e..7ceb3ce 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -39,6 +39,7 @@
 #define TX_HW_ATTR_LAST_WORD_PAD         (BIT(10) | BIT(11))
 #define TX_HW_ATTR_TX_CMPLT_REQ          BIT(12)
 #define TX_HW_ATTR_TX_DUMMY_REQ          BIT(13)
+#define TX_HW_ATTR_HOST_ENCRYPT          BIT(14)
 
 #define TX_HW_ATTR_OFST_SAVE_RETRIES     0
 #define TX_HW_ATTR_OFST_HEADER_PAD       1
-- 
1.7.6.401.g6a319

