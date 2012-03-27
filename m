Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:37844 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718Ab2C0OvP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 10:51:15 -0400
From: Jakub Kicinski <kubakici@wp.pl>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH 1/4] rt2x00: broaden PCIE L1-state wakeup configuration
Date: Tue, 27 Mar 2012 16:51:04 +0200
Message-Id: <1332859867-27921-2-git-send-email-kubakici@wp.pl> (sfid-20120327_165121_427987_5A29C6F6)
In-Reply-To: <1332859867-27921-1-git-send-email-kubakici@wp.pl>
References: <1332859867-27921-1-git-send-email-kubakici@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Broaden wakeup configuration to all PCIE from rt3xxx on.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
2011_0406_RT5390_RT5392_Linux_STA_V2.5.0.3_DPO
rtmp_init_inf.c:171

Legacy driver applies this configuration to the following devices:
3071 3090 3572 3592 3562 3062 3390 3593 5390 5370 5392 5372 5360 5362
if they are working on PCIE bus. AFAIK these are all post 2xxx PCIE
devices.
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    4 +---
 drivers/net/wireless/rt2x00/rt2800pci.c |    5 +----
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 6c0a12e..4722030 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -401,9 +401,7 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
 		return -EBUSY;
 
 	if (rt2x00_is_pci(rt2x00dev)) {
-		if (rt2x00_rt(rt2x00dev, RT3572) ||
-		    rt2x00_rt(rt2x00dev, RT5390) ||
-		    rt2x00_rt(rt2x00dev, RT5392)) {
+		if (rt2x00_is_pcie(rt2x00dev) && rt2x00dev->chip.rt > 0x3000) {
 			rt2800_register_read(rt2x00dev, AUX_CTRL, &reg);
 			rt2x00_set_field32(&reg, AUX_CTRL_FORCE_PCIE_CLK, 1);
 			rt2x00_set_field32(&reg, AUX_CTRL_WAKE_PCIE_EN, 1);
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 0397bbf..5a2f68f 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -478,10 +478,7 @@ static int rt2800pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00pci_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e1f);
 	rt2x00pci_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
 
-	if (rt2x00_is_pcie(rt2x00dev) &&
-	    (rt2x00_rt(rt2x00dev, RT3572) ||
-	     rt2x00_rt(rt2x00dev, RT5390) ||
-	     rt2x00_rt(rt2x00dev, RT5392))) {
+	if (rt2x00_is_pcie(rt2x00dev) && rt2x00dev->chip.rt > 0x3000) {
 		rt2x00pci_register_read(rt2x00dev, AUX_CTRL, &reg);
 		rt2x00_set_field32(&reg, AUX_CTRL_FORCE_PCIE_CLK, 1);
 		rt2x00_set_field32(&reg, AUX_CTRL_WAKE_PCIE_EN, 1);
-- 
1.7.7.6

