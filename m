Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43584 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252AbZKMX54 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 18:57:56 -0500
Received: by bwz27 with SMTP id 27so4039905bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2009 15:58:00 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ar9170: do not discard valuable DUPOFDM frames
Date: Sat, 14 Nov 2009 00:57:58 +0100
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200911140057.58302.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables the driver to process all incoming
dupofdm-modulated frames when operating in HT40 mode.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 7e59b82..bd2a276 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -850,6 +850,7 @@ static int ar9170_rx_mac_status(struct ar9170 *ar,
 		}
 		break;
 
+	case AR9170_RX_STATUS_MODULATION_DUPOFDM:
 	case AR9170_RX_STATUS_MODULATION_OFDM:
 		switch (head->plcp[0] & 0xf) {
 		case 0xb:
@@ -897,8 +898,7 @@ static int ar9170_rx_mac_status(struct ar9170 *ar,
 		status->flag |= RX_FLAG_HT;
 		break;
 
-	case AR9170_RX_STATUS_MODULATION_DUPOFDM:
-		/* XXX */
+	default:
 		if (ar9170_nag_limiter(ar))
 			printk(KERN_ERR "%s: invalid modulation\n",
 			       wiphy_name(ar->hw->wiphy));
