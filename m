Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:44259 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbZBOREV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 12:04:21 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: Fix LO calibration txctl reg value
Date: Sun, 15 Feb 2009 18:02:39 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200902151802.39970.mb@bu3sch.de> (sfid-20090215_180425_121007_6C623C4C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roel Kluin <roel.kluin@gmail.com>

This patch expands the parenthesis in the txctl reg write
of the LO calibration to enforce precedence rules.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please apply this bugfix.

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

-- 
Greetings, Michael.
