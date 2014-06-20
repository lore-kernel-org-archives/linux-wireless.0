Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61942 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbaFTPWR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2014 11:22:17 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so999392wib.11
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jun 2014 08:22:14 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: remove leftover code from old devices support
Date: Fri, 20 Jun 2014 17:22:00 +0200
Message-Id: <1403277721-25302-1-git-send-email-zajec5@gmail.com> (sfid-20140620_172220_613726_256CD6F8)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Old devices (A-PHY or B-PHY) are supposed to be supported by b43legacy.
We keep phy_a.c as it's needed for G-PHY which shares some design.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c       | 9 ---------
 drivers/net/wireless/b43/phy_a.h      | 4 ----
 drivers/net/wireless/b43/phy_common.c | 3 ---
 3 files changed, 16 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 4b662d0..4164afa 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4306,15 +4306,6 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 	phy_type = (tmp & B43_PHYVER_TYPE) >> B43_PHYVER_TYPE_SHIFT;
 	phy_rev = (tmp & B43_PHYVER_VERSION);
 	switch (phy_type) {
-	case B43_PHYTYPE_A:
-		if (phy_rev >= 4)
-			unsupported = 1;
-		break;
-	case B43_PHYTYPE_B:
-		if (phy_rev != 2 && phy_rev != 4 && phy_rev != 6
-		    && phy_rev != 7)
-			unsupported = 1;
-		break;
 	case B43_PHYTYPE_G:
 		if (phy_rev > 9)
 			unsupported = 1;
diff --git a/drivers/net/wireless/b43/phy_a.h b/drivers/net/wireless/b43/phy_a.h
index 5cfaab7..f7d0d92 100644
--- a/drivers/net/wireless/b43/phy_a.h
+++ b/drivers/net/wireless/b43/phy_a.h
@@ -123,8 +123,4 @@ struct b43_phy_a {
  */
 void b43_phy_inita(struct b43_wldev *dev);
 
-
-struct b43_phy_operations;
-extern const struct b43_phy_operations b43_phyops_a;
-
 #endif /* LINUX_B43_PHY_A_H_ */
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 2d05b59..ce486ee 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -45,9 +45,6 @@ int b43_phy_allocate(struct b43_wldev *dev)
 	phy->ops = NULL;
 
 	switch (phy->type) {
-	case B43_PHYTYPE_A:
-		phy->ops = &b43_phyops_a;
-		break;
 	case B43_PHYTYPE_G:
 		phy->ops = &b43_phyops_g;
 		break;
-- 
1.8.4.5

