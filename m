Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eggs.gnu.org ([208.118.235.92]:44583 "EHLO eggs.gnu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbbF3Auf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2015 20:50:35 -0400
Received: from Debian-exim by eggs.gnu.org with spam-scanned (Exim 4.71)
	(envelope-from <nikolas@gnu.org>)
	id 1Z9jks-0007yc-0B
	for linux-wireless@vger.kernel.org; Mon, 29 Jun 2015 20:50:34 -0400
From: Nik Nyby <nikolas@gnu.org>
To: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Cc: Nik Nyby <nikolas@gnu.org>
Subject: [PATCH] b43: Fix typo in function name
Date: Mon, 29 Jun 2015 20:45:47 -0400
Message-Id: <1435625147-23535-1-git-send-email-nikolas@gnu.org> (sfid-20150630_025039_836868_4A1DD046)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a typo in the "b43_lo_g_maintenance_work" function
name.

Signed-off-by: Nik Nyby <nikolas@gnu.org>
---
 drivers/net/wireless/b43/lo.c    | 4 ++--
 drivers/net/wireless/b43/lo.h    | 2 +-
 drivers/net/wireless/b43/phy_g.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/lo.c b/drivers/net/wireless/b43/lo.c
index 916123a..a335f94 100644
--- a/drivers/net/wireless/b43/lo.c
+++ b/drivers/net/wireless/b43/lo.c
@@ -929,8 +929,8 @@ void b43_lo_g_adjust_to(struct b43_wldev *dev,
 	b43_lo_write(dev, &cal->ctl);
 }
 
-/* Periodic LO maintanance work */
-void b43_lo_g_maintanance_work(struct b43_wldev *dev)
+/* Periodic LO maintenance work */
+void b43_lo_g_maintenance_work(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_g *gphy = phy->g;
diff --git a/drivers/net/wireless/b43/lo.h b/drivers/net/wireless/b43/lo.h
index 3b27e20..7b4df38 100644
--- a/drivers/net/wireless/b43/lo.h
+++ b/drivers/net/wireless/b43/lo.h
@@ -80,7 +80,7 @@ void b43_lo_g_adjust_to(struct b43_wldev *dev,
 
 void b43_gphy_dc_lt_init(struct b43_wldev *dev, bool update_all);
 
-void b43_lo_g_maintanance_work(struct b43_wldev *dev);
+void b43_lo_g_maintenance_work(struct b43_wldev *dev);
 void b43_lo_g_cleanup(struct b43_wldev *dev);
 void b43_lo_g_init(struct b43_wldev *dev);
 
diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
index 727ce6e..462310e 100644
--- a/drivers/net/wireless/b43/phy_g.c
+++ b/drivers/net/wireless/b43/phy_g.c
@@ -3004,7 +3004,7 @@ static void b43_gphy_op_pwork_15sec(struct b43_wldev *dev)
 		   phy->rev == 1) {
 		//TODO: implement rev1 workaround
 	}
-	b43_lo_g_maintanance_work(dev);
+	b43_lo_g_maintenance_work(dev);
 	b43_mac_enable(dev);
 }
 
-- 
2.1.4

