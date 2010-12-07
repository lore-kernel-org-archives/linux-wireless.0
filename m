Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:64032 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab0LGVFF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 16:05:05 -0500
Received: by ewy10 with SMTP id 10so411161ewy.4
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 13:05:03 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/4] b43: fix split of N-PHY devices into supported and not (based on PHY rev)
Date: Tue,  7 Dec 2010 21:55:59 +0100
Message-Id: <1291755360-21570-4-git-send-email-zajec5@gmail.com>
In-Reply-To: <1291755360-21570-1-git-send-email-zajec5@gmail.com>
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c  |    2 +-
 drivers/net/wireless/b43/phy_n.c |    1 -
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 670fd7b..4d97aac 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4054,7 +4054,7 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 		break;
 #ifdef CONFIG_B43_NPHY
 	case B43_PHYTYPE_N:
-		if (phy_rev > 4)
+		if (phy_rev > 2)
 			unsupported = 1;
 		break;
 #endif
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 3517341..61875c8 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3515,7 +3515,6 @@ int b43_phy_initn(struct b43_wldev *dev)
 	if (phy->rev >= 3)
 		b43_nphy_spur_workaround(dev);
 
-	b43err(dev->wl, "IEEE 802.11n devices are not supported, yet.\n");
 	return 0;
 }
 
-- 
1.6.3.3

