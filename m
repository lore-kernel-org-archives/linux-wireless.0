Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:34710 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbaBJLr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 06:47:59 -0500
Received: by mail-we0-f174.google.com with SMTP id x55so4104087wes.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 03:47:57 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/18] wlcore: send EAPOL frames with voice priority
Date: Mon, 10 Feb 2014 13:47:26 +0200
Message-Id: <1392032854-28126-11-git-send-email-eliad@wizery.com> (sfid-20140210_130007_173736_0101C290)
In-Reply-To: <1392032854-28126-1-git-send-email-eliad@wizery.com>
References: <1392032854-28126-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igal Chernobelsky <igalc@ti.com>

Send EAPOL frames with voice priority by setting (the new)
TX_HW_ATTR_EAPOL_FRAME bit in tx attribute.

Sending EAPOL with voice priority fixes re-key
timeout issues during heavy traffic.

Signed-off-by: Igal Chernobelsky <igalc@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/tx.c | 4 ++++
 drivers/net/wireless/ti/wlcore/tx.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 9f7921d..38b31a0 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -362,6 +362,10 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	    ieee80211_has_protected(frame_control))
 		tx_attr |= TX_HW_ATTR_HOST_ENCRYPT;
 
+	/* send EAPOL frames as voice */
+	if (control->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO)
+		tx_attr |= TX_HW_ATTR_EAPOL_FRAME;
+
 	desc->tx_attr = cpu_to_le16(tx_attr);
 
 	wlcore_hw_set_tx_desc_csum(wl, desc, skb);
diff --git a/drivers/net/wireless/ti/wlcore/tx.h b/drivers/net/wireless/ti/wlcore/tx.h
index 35489c3..79cb3ff 100644
--- a/drivers/net/wireless/ti/wlcore/tx.h
+++ b/drivers/net/wireless/ti/wlcore/tx.h
@@ -37,6 +37,7 @@
 #define TX_HW_ATTR_TX_CMPLT_REQ          BIT(12)
 #define TX_HW_ATTR_TX_DUMMY_REQ          BIT(13)
 #define TX_HW_ATTR_HOST_ENCRYPT          BIT(14)
+#define TX_HW_ATTR_EAPOL_FRAME           BIT(15)
 
 #define TX_HW_ATTR_OFST_SAVE_RETRIES     0
 #define TX_HW_ATTR_OFST_HEADER_PAD       1
-- 
1.8.5.2.229.g4448466.dirty

