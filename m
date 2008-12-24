Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38946 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbYLXO0c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 09:26:32 -0500
Subject: [PATCH] b43: detect N PHY revision/radio
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Content-Type: text/plain
Date: Wed, 24 Dec 2008 15:26:40 +0100
Message-Id: <1230128800.4566.3.camel@johannes> (sfid-20081224_152652_395984_5C636D77)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Does nothing unless you enable the hidden N PHY config.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/b43/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-12-24 15:00:50.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-12-24 15:25:03.000000000 +0100
@@ -3758,7 +3758,7 @@ static int b43_phy_versioning(struct b43
 		break;
 #ifdef CONFIG_B43_NPHY
 	case B43_PHYTYPE_N:
-		if (phy_rev > 1)
+		if (phy_rev > 4)
 			unsupported = 1;
 		break;
 #endif
@@ -3811,7 +3811,7 @@ static int b43_phy_versioning(struct b43
 			unsupported = 1;
 		break;
 	case B43_PHYTYPE_N:
-		if (radio_ver != 0x2055)
+		if (radio_ver != 0x2055 && radio_ver != 0x2056)
 			unsupported = 1;
 		break;
 	default:


