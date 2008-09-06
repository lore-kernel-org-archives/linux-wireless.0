Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:47522 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYIFAw6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2008 20:52:58 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] p54: add more rx filters
Date: Sat, 6 Sep 2008 02:56:12 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809060256.12896.chunkeey@web.de> (sfid-20080906_025303_812159_ED8650CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new filters settings to make the card more useful in monitor mode.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-09-05 21:02:22.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-09-06 01:57:59.000000000 +0200
@@ -433,6 +433,13 @@ static int p54_rx_data(struct ieee80211_
 	size_t header_len = sizeof(*hdr);
 	u32 tsf32;
 
+	if (!(hdr->magic & cpu_to_le16(0x0001))) {
+		if (priv->filter_flags & FIF_FCSFAIL)
+			rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
+		else
+			return 0;
+	}
+
 	rx_status.signal = hdr->rssi;
 	/* XX correct? */
 	rx_status.qual = (100 * hdr->rssi) / 127;
@@ -1127,13 +1134,26 @@ static void p54_configure_filter(struct 
 {
 	struct p54_common *priv = dev->priv;
 
-	*total_flags &= FIF_BCN_PRBRESP_PROMISC;
+	*total_flags &= FIF_BCN_PRBRESP_PROMISC |
+			FIF_PROMISC_IN_BSS |
+			FIF_FCSFAIL;
+
+	priv->filter_flags = *total_flags;
 
 	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
 		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
-			p54_set_filter(dev, 0, NULL);
+			p54_set_filter(dev, priv->filter_type, NULL);
+		else
+			p54_set_filter(dev, priv->filter_type, priv->bssid);
+	}
+
+	if (changed_flags & FIF_PROMISC_IN_BSS) {
+		if (*total_flags & FIF_PROMISC_IN_BSS)
+			p54_set_filter(dev, priv->filter_type |
+				cpu_to_le16(0x8), NULL);
 		else
-			p54_set_filter(dev, 0, priv->bssid);
+			p54_set_filter(dev, priv->filter_type &
+				~cpu_to_le16(0x8), priv->bssid);
 	}
 }
 
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-09-04 14:43:07.000000000 +0200
+++ b/drivers/net/wireless/p54/p54.h	2008-09-04 14:56:25.000000000 +0200
@@ -80,6 +80,7 @@ struct p54_common {
 	struct pda_channel_output_limit *output_limit;
 	unsigned int output_limit_len;
 	struct pda_pa_curve_data *curve_data;
+	unsigned int filter_flags;
 	u16 rxhw;
 	u8 version;
 	u8 rx_antenna;

