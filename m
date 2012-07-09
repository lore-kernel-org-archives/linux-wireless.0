Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab2GIMmX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 08:42:23 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	"Woody Hung" <Woody.Hung@mediatek.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/2] rt2x00pci: small 3290 changes cleanup
Date: Mon,  9 Jul 2012 14:41:47 +0200
Message-Id: <1341837708-22689-1-git-send-email-sgruszka@redhat.com> (sfid-20120709_144226_330856_3D1F7535)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix indention and remove unnecessary brackets and compares.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index dd43612..bf0e71e 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -986,7 +986,7 @@ static int rt2800_enable_wlan_rt3290(struct rt2x00_dev *rt2x00dev)
 	int i, count;
 
 	rt2800_register_read(rt2x00dev, WLAN_FUN_CTRL, &reg);
-	if ((rt2x00_get_field32(reg, WLAN_EN) == 1))
+	if (rt2x00_get_field32(reg, WLAN_EN))
 		return 0;
 
 	rt2x00_set_field32(&reg, WLAN_GPIO_OUT_OE_BIT_ALL, 0xff);
@@ -1004,9 +1004,9 @@ static int rt2800_enable_wlan_rt3290(struct rt2x00_dev *rt2x00dev)
 		 */
 		for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 			rt2800_register_read(rt2x00dev, CMB_CTRL, &reg);
-			if ((rt2x00_get_field32(reg, PLL_LD) == 1) &&
-				(rt2x00_get_field32(reg, XTAL_RDY) == 1))
-					break;
+			if (rt2x00_get_field32(reg, PLL_LD) &&
+			    rt2x00_get_field32(reg, XTAL_RDY))
+				break;
 			udelay(REGISTER_BUSY_DELAY);
 		}
 
@@ -1022,9 +1022,8 @@ static int rt2800_enable_wlan_rt3290(struct rt2x00_dev *rt2x00dev)
 			rt2800_register_write(rt2x00dev, 0x58, 0x618);
 			udelay(REGISTER_BUSY_DELAY);
 			count++;
-		} else {
+		} else
 			count = 0;
-		}
 
 		rt2800_register_read(rt2x00dev, WLAN_FUN_CTRL, &reg);
 		rt2x00_set_field32(&reg, PCIE_APP0_CLK_REQ, 0);
-- 
1.7.1

