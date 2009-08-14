Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:53533 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbZHNMyq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 08:54:46 -0400
Received: by bwz22 with SMTP id 22so1123698bwz.18
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 05:54:46 -0700 (PDT)
Message-ID: <4A855E96.3090202@gmail.com>
Date: Fri, 14 Aug 2009 14:54:46 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>
CC: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: Make LP-PHY testable
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-Enable rate memory init for LP-PHY (same as G and N-PHY).
-Mark rev.2 LP-PHYs with the B2063 radio as supported.
-Allow using the 5GHz band on LP-PHYs.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/b43/main.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 3ca3e93..5559b22 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2674,6 +2674,7 @@ static void b43_rate_memory_init(struct b43_wldev *dev)
 	case B43_PHYTYPE_A:
 	case B43_PHYTYPE_G:
 	case B43_PHYTYPE_N:
+	case B43_PHYTYPE_LP:
 		b43_rate_memory_write(dev, B43_OFDM_RATE_6MB, 1);
 		b43_rate_memory_write(dev, B43_OFDM_RATE_12MB, 1);
 		b43_rate_memory_write(dev, B43_OFDM_RATE_18MB, 1);
@@ -3888,7 +3889,7 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 #endif
 #ifdef CONFIG_B43_PHY_LP
 	case B43_PHYTYPE_LP:
-		if (phy_rev > 1)
+		if (phy_rev > 2)
 			unsupported = 1;
 		break;
 #endif
@@ -3945,7 +3946,7 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 			unsupported = 1;
 		break;
 	case B43_PHYTYPE_LP:
-		if (radio_ver != 0x2062)
+		if (radio_ver != 0x2062 && radio_ver != 0x2063)
 			unsupported = 1;
 		break;
 	default:
@@ -4588,9 +4589,10 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 		case B43_PHYTYPE_A:
 			have_5ghz_phy = 1;
 			break;
+		case B43_PHYTYPE_LP: //FIXME not always!
+			have_5ghz_phy = 1;
 		case B43_PHYTYPE_G:
 		case B43_PHYTYPE_N:
-		case B43_PHYTYPE_LP:
 			have_2ghz_phy = 1;
 			break;
 		default:
@@ -4605,7 +4607,8 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 	}
 	if (1 /* disable A-PHY */) {
 		/* FIXME: For now we disable the A-PHY on multi-PHY devices. */
-		if (dev->phy.type != B43_PHYTYPE_N) {
+		if (dev->phy.type != B43_PHYTYPE_N &&
+		    dev->phy.type != B43_PHYTYPE_LP) {
 			have_2ghz_phy = 1;
 			have_5ghz_phy = 0;
 		}
-- 
1.6.2.4



