Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f52.google.com ([74.125.83.52]:59285 "EHLO
	mail-gw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933341Ab1INVvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 17:51:03 -0400
Received: by gwb1 with SMTP id 1so677621gwb.11
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 14:51:01 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, stable <stable@kernel.org>
Subject: [PATCH 1/2] rt2800pci: Fix compiler error on PowerPC
Date: Wed, 14 Sep 2011 16:50:22 -0500
Message-Id: <1316037024-17340-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110914_235113_012185_A0E08558)
In-Reply-To: <1316037024-17340-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1316037024-17340-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using gcc 4.4.5 on a Powerbook G4 with a PPC cpu, a complicated
if statement results in incorrect flow, whereas the equivalent switch
statement works correctly.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: stable <stable@kernel.org>
---

 drivers/net/wireless/rt2x00/rt2800lib.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index ef67f67..23568af 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3870,19 +3870,23 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		return -ENODEV;
 	}
 
-	if (!rt2x00_rf(rt2x00dev, RF2820) &&
-	    !rt2x00_rf(rt2x00dev, RF2850) &&
-	    !rt2x00_rf(rt2x00dev, RF2720) &&
-	    !rt2x00_rf(rt2x00dev, RF2750) &&
-	    !rt2x00_rf(rt2x00dev, RF3020) &&
-	    !rt2x00_rf(rt2x00dev, RF2020) &&
-	    !rt2x00_rf(rt2x00dev, RF3021) &&
-	    !rt2x00_rf(rt2x00dev, RF3022) &&
-	    !rt2x00_rf(rt2x00dev, RF3052) &&
-	    !rt2x00_rf(rt2x00dev, RF3320) &&
-	    !rt2x00_rf(rt2x00dev, RF5370) &&
-	    !rt2x00_rf(rt2x00dev, RF5390)) {
-		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
+	switch (rt2x00dev->chip.rf) {
+	case RF2820:
+	case RF2850:
+	case RF2720:
+	case RF2750:
+	case RF3020:
+	case RF2020:
+	case RF3021:
+	case RF3022:
+	case RF3052:
+	case RF3320:
+	case RF5370:
+	case RF5390:
+		break;
+	default:
+		ERROR(rt2x00dev, "Invalid RF chipset 0x%x detected.\n",
+		      rt2x00dev->chip.rf);
 		return -ENODEV;
 	}
 
-- 
1.7.6.1

