Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45218 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab1DMFuK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 01:50:10 -0400
Received: by iwn34 with SMTP id 34so275635iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 22:50:10 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19877.14881.765433.837554@gargle.gargle.HOWL>
Date: Wed, 13 Apr 2011 11:22:33 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 01/40] ath9k_htc: Remove AR7010 v1.0 support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

All the AR7010 devices supoprted by ath9k_htc are based
on version v1.1, so remove support for v1.0.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 2d10239..dc05820 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -17,11 +17,9 @@
 #include "htc.h"
 
 /* identify firmware images */
-#define FIRMWARE_AR7010		"ar7010.fw"
 #define FIRMWARE_AR7010_1_1	"ar7010_1_1.fw"
 #define FIRMWARE_AR9271		"ar9271.fw"
 
-MODULE_FIRMWARE(FIRMWARE_AR7010);
 MODULE_FIRMWARE(FIRMWARE_AR7010_1_1);
 MODULE_FIRMWARE(FIRMWARE_AR9271);
 
@@ -1026,10 +1024,7 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 	/* Find out which firmware to load */
 
 	if (IS_AR7010_DEVICE(id->driver_info))
-		if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x0202)
-			hif_dev->fw_name = FIRMWARE_AR7010_1_1;
-		else
-			hif_dev->fw_name = FIRMWARE_AR7010;
+		hif_dev->fw_name = FIRMWARE_AR7010_1_1;
 	else
 		hif_dev->fw_name = FIRMWARE_AR9271;
 
-- 
1.7.4.4

