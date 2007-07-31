Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48225 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106AbXGaSd7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:33:59 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121186ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:33:59 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/24] rt2x00: Don't toggle tuner bit for non-RF2523 chips
Date: Tue, 31 Jul 2007 20:37:02 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.02606.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 875a52bc8ca873ac0ef6aa473101ffe59528d24c Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Fri, 27 Jul 2007 17:39:55 +0200
Subject: [PATCH 03/24] rt2x00: Don't toggle tuner bit for non-RF2523 chips

The TUNER bit for RF1 shouldn't be set when it isn't
written to the device anyway...

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2500pci.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index 0535c1d..5996876 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -455,13 +455,12 @@ static void rt2500pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	 * Switch off tuning bits.
 	 * For RT2523 devices we do not need to update the R1 register.
 	 */
-	rt2x00_set_field32(&reg.rf1, RF1_TUNER, 0);
-	rt2x00_set_field32(&reg.rf3, RF3_TUNER, 0);
-
-
-	if (!rt2x00_rf(&rt2x00dev->chip, RF2523))
+	if (!rt2x00_rf(&rt2x00dev->chip, RF2523)) {
+		rt2x00_set_field32(&reg.rf1, RF1_TUNER, 0);
 		rt2500pci_rf_write(rt2x00dev, reg.rf1);
+	}
 
+	rt2x00_set_field32(&reg.rf3, RF3_TUNER, 0);
 	rt2500pci_rf_write(rt2x00dev, reg.rf3);
 
 	/*
-- 
1.5.2.4

