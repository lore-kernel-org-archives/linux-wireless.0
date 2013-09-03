Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53500 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab3ICOe1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 10:34:27 -0400
Received: by mail-wi0-f178.google.com with SMTP id hn9so2011269wib.11
        for <linux-wireless@vger.kernel.org>; Tue, 03 Sep 2013 07:34:26 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/12] wlcore: send EAPOL frames with voice priority
Date: Tue,  3 Sep 2013 17:34:02 +0300
Message-Id: <1378218848-7853-6-git-send-email-eliad@wizery.com> (sfid-20130903_163441_963909_65A247D4)
In-Reply-To: <1378218848-7853-1-git-send-email-eliad@wizery.com>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igal Chernobelsky <igalc@ti.com>

Send EAPOL frames with voice priority by setting TX_HW_ATTR_EAPOL_FRAME
new bit in tx attribute. Sending EAPOL with voice priority fixes
re-key timeout during heavy traffic issue.

Signed-off-by: Igal Chernobelsky <igalc@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/tx.c | 4 ++++
 drivers/net/wireless/ti/wlcore/tx.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 03249da..3c02023 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -357,6 +357,10 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
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
1.8.3.rc1.35.g9b79519

