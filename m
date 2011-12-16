Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55777 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760426Ab1LPVp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 16:45:28 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: zajec5@gmail.com, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: mark some vars __maybe_unused in b43_nphy_pmu_spur_avoid
Date: Fri, 16 Dec 2011 16:33:34 -0500
Message-Id: <1324071214-5432-1-git-send-email-linville@tuxdriver.com> (sfid-20111216_224532_496709_72C81FBC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoids this warning when CONFIG_B43_BCMA is not set:

  CC [M]  drivers/net/wireless/b43/phy_n.o
drivers/net/wireless/b43/phy_n.c: In function ‘b43_nphy_pmu_spur_avoid’:
drivers/net/wireless/b43/phy_n.c:4052:6: warning: unused variable ‘pmu_ctl’
drivers/net/wireless/b43/phy_n.c:4051:22: warning: unused variable ‘cc’

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/b43/phy_n.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index c8fa2cd..f2435e7 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -4048,8 +4048,8 @@ int b43_phy_initn(struct b43_wldev *dev)
 /* http://bcm-v4.sipsolutions.net/802.11/PmuSpurAvoid */
 static void b43_nphy_pmu_spur_avoid(struct b43_wldev *dev, bool avoid)
 {
-	struct bcma_drv_cc *cc;
-	u32 pmu_ctl;
+	struct bcma_drv_cc __maybe_unused *cc;
+	u32 __maybe_unused pmu_ctl;
 
 	switch (dev->dev->bus_type) {
 #ifdef CONFIG_B43_BCMA
-- 
1.7.4.4

