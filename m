Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:48279 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbZBOQiB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 11:38:01 -0500
Received: by ewy14 with SMTP id 14so1606260ewy.13
        for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 08:37:59 -0800 (PST)
Message-ID: <499844E7.1040307@gmail.com> (sfid-20090215_173808_175234_6D34828A)
Date: Sun, 15 Feb 2009 17:37:59 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: stefano.brivio@polimi.it
CC: linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] B43: misplaced parentheses?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think below is what was intended? otherwise we could as well have written:

 	b43_radio_write16(dev, txctl_reg,
 			  (b43_radio_read16(dev, txctl_reg) & ~txctl_value)
			  || (rfatt->with_padmix) ? txctl_value : 0);

			  ^^--- Note: boolean or

please review.
-------------------------->8------------------8<---------------------------
Fix misplaced parentheses

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/wireless/b43/lo.c b/drivers/net/wireless/b43/lo.c
index 6a18a14..88ed75f 100644
--- a/drivers/net/wireless/b43/lo.c
+++ b/drivers/net/wireless/b43/lo.c
@@ -783,7 +783,7 @@ struct b43_lo_calib * b43_calibrate_lo_setting(struct b43_wldev *dev,
 			  | rfatt->att);
 	b43_radio_write16(dev, txctl_reg,
 			  (b43_radio_read16(dev, txctl_reg) & ~txctl_value)
-			  | (rfatt->with_padmix) ? txctl_value : 0);
+			  | (rfatt->with_padmix ? txctl_value : 0));
 
 	max_rx_gain = rfatt->att * 2;
 	max_rx_gain += bbatt->att / 2;
