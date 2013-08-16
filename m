Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:39980 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab3HPIXt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 04:23:49 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/2] rt2x00: rt2800pci: fix AUX_CTRL register setup for RT3090/3390/3593/5592
Date: Fri, 16 Aug 2013 10:23:30 +0200
Message-Id: <1376641410-20798-2-git-send-email-juhosg@openwrt.org> (sfid-20130816_102356_721347_EDBCF5B6)
In-Reply-To: <1376641410-20798-1-git-send-email-juhosg@openwrt.org>
References: <1376641410-20798-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 2011_1007_RT5390_RT5392_Linux_STA_V2.5.0.3_DPO
driver enables PCIe wakeup for these chips as well.
Do the same in rt2x00.

References:
  rt28xx_init in common/rtmp_init_intf.c
  RTMPInitPCIeLinkCtrlValue in os/linux/rt_rbus_pci_drv.c

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index e470fdb..182205b 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -537,9 +537,13 @@ static int rt2800pci_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00mmio_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
 
 	if (rt2x00_is_pcie(rt2x00dev) &&
-	    (rt2x00_rt(rt2x00dev, RT3572) ||
+	    (rt2x00_rt(rt2x00dev, RT3090) ||
+	     rt2x00_rt(rt2x00dev, RT3390) ||
+	     rt2x00_rt(rt2x00dev, RT3572) ||
+	     rt2x00_rt(rt2x00dev, RT3593) ||
 	     rt2x00_rt(rt2x00dev, RT5390) ||
-	     rt2x00_rt(rt2x00dev, RT5392))) {
+	     rt2x00_rt(rt2x00dev, RT5392) ||
+	     rt2x00_rt(rt2x00dev, RT5592))) {
 		rt2x00mmio_register_read(rt2x00dev, AUX_CTRL, &reg);
 		rt2x00_set_field32(&reg, AUX_CTRL_FORCE_PCIE_CLK, 1);
 		rt2x00_set_field32(&reg, AUX_CTRL_WAKE_PCIE_EN, 1);
-- 
1.7.10
