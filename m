Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2821 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160Ab3IYKLU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 06:11:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>, stable@vger.kernel.org,
	"Tod Jackson" <tod.jackson@gmail.com>,
	"Joe Perches" <joe@perches.com>,
	"Rafal Milecki" <zajec5@gmail.com>,
	"Hauke Mehrtens" <hauke@hauke-m.de>
Subject: [PATCH for-3.12 2/3] bcma: make bcma_core_pci_{up,down}()
 callable from atomic context
Date: Wed, 25 Sep 2013 12:11:02 +0200
Message-ID: <1380103864-10447-3-git-send-email-arend@broadcom.com> (sfid-20130925_121128_285517_B54CEF37)
In-Reply-To: <1380103864-10447-1-git-send-email-arend@broadcom.com>
References: <1380103864-10447-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the bcma_core_pci_power_save() call from
the bcma_core_pci_{up,down}() functions as it tries to schedule
thus requiring to call them from non-atomic context. The function
bcma_core_pci_power_save() is now exported so the calling module
can explicitly use it in non-atomic context. This fixes the
'scheduling while atomic' issue reported by Tod Jackson and
Joe Perches.

[   13.210710] BUG: scheduling while atomic: dhcpcd/1800/0x00000202
[   13.210718] Modules linked in: brcmsmac nouveau coretemp kvm_intel kvm cordic brcmutil bcma dell_wmi atl1c ttm mxm_wmi wmi
[   13.210756] CPU: 2 PID: 1800 Comm: dhcpcd Not tainted 3.11.0-wl #1
[   13.210762] Hardware name: Alienware M11x R2/M11x R2, BIOS A04 11/23/2010
[   13.210767]  ffff880177c92c40 ffff880170fd1948 ffffffff8169af5b 0000000000000007
[   13.210777]  ffff880170fd1ab0 ffff880170fd1958 ffffffff81697ee2 ffff880170fd19d8
[   13.210785]  ffffffff816a19f5 00000000000f4240 000000000000d080 ffff880170fd1fd8
[   13.210794] Call Trace:
[   13.210813]  [<ffffffff8169af5b>] dump_stack+0x4f/0x84
[   13.210826]  [<ffffffff81697ee2>] __schedule_bug+0x43/0x51
[   13.210837]  [<ffffffff816a19f5>] __schedule+0x6e5/0x810
[   13.210845]  [<ffffffff816a1c34>] schedule+0x24/0x70
[   13.210855]  [<ffffffff816a04fc>] schedule_hrtimeout_range_clock+0x10c/0x150
[   13.210867]  [<ffffffff810684e0>] ? update_rmtp+0x60/0x60
[   13.210877]  [<ffffffff8106915f>] ? hrtimer_start_range_ns+0xf/0x20
[   13.210887]  [<ffffffff816a054e>] schedule_hrtimeout_range+0xe/0x10
[   13.210897]  [<ffffffff8104f6fb>] usleep_range+0x3b/0x40
[   13.210910]  [<ffffffffa00371af>] bcma_pcie_mdio_set_phy.isra.3+0x4f/0x80 [bcma]
[   13.210921]  [<ffffffffa003729f>] bcma_pcie_mdio_write.isra.4+0xbf/0xd0 [bcma]
[   13.210932]  [<ffffffffa0037498>] bcma_pcie_mdio_writeread.isra.6.constprop.13+0x18/0x30 [bcma]
[   13.210942]  [<ffffffffa00374ee>] bcma_core_pci_power_save+0x3e/0x80 [bcma]
[   13.210953]  [<ffffffffa003765d>] bcma_core_pci_up+0x2d/0x60 [bcma]
[   13.210975]  [<ffffffffa03dc17c>] brcms_c_up+0xfc/0x430 [brcmsmac]
[   13.210989]  [<ffffffffa03d1a7d>] brcms_up+0x1d/0x20 [brcmsmac]
[   13.211003]  [<ffffffffa03d2498>] brcms_ops_start+0x298/0x340 [brcmsmac]
[   13.211020]  [<ffffffff81600a12>] ? cfg80211_netdev_notifier_call+0xd2/0x5f0
[   13.211030]  [<ffffffff815fa53d>] ? packet_notifier+0xad/0x1d0
[   13.211064]  [<ffffffff81656e75>] ieee80211_do_open+0x325/0xf80
[   13.211076]  [<ffffffff8106ac09>] ? __raw_notifier_call_chain+0x9/0x10
[   13.211086]  [<ffffffff81657b41>] ieee80211_open+0x71/0x80
[   13.211101]  [<ffffffff81526267>] __dev_open+0x87/0xe0
[   13.211109]  [<ffffffff8152650c>] __dev_change_flags+0x9c/0x180
[   13.211117]  [<ffffffff815266a3>] dev_change_flags+0x23/0x70
[   13.211127]  [<ffffffff8158cd68>] devinet_ioctl+0x5b8/0x6a0
[   13.211136]  [<ffffffff8158d5c5>] inet_ioctl+0x75/0x90
[   13.211147]  [<ffffffff8150b38b>] sock_do_ioctl+0x2b/0x70
[   13.211155]  [<ffffffff8150b681>] sock_ioctl+0x71/0x2a0
[   13.211169]  [<ffffffff8114ed47>] do_vfs_ioctl+0x87/0x520
[   13.211180]  [<ffffffff8113f159>] ? ____fput+0x9/0x10
[   13.211198]  [<ffffffff8106228c>] ? task_work_run+0x9c/0xd0
[   13.211202]  [<ffffffff8114f271>] SyS_ioctl+0x91/0xb0
[   13.211208]  [<ffffffff816aa252>] system_call_fastpath+0x16/0x1b
[   13.211217] NOHZ: local_softirq_pending 202

The issue was introduced in v3.11 kernel by following commit:

commit aa51e598d04c6acf5477934cd6383f5a17ce9029
Author: Hauke Mehrtens <hauke@hauke-m.de>
Date:   Sat Aug 24 00:32:31 2013 +0200

    brcmsmac: use bcma PCIe up and down functions

    replace the calls to bcma_core_pci_extend_L1timer() by calls to the
    newly introduced bcma_core_pci_ip() and bcma_core_pci_down()

    Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
    Cc: Arend van Spriel <arend@broadcom.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

This fix has been discussed with Hauke Mehrtens [1] selection
option 3) and is intended for v3.12.

Ref:
[1] http://mid.gmane.org/5239B12D.3040206@hauke-m.de

Cc: <stable@vger.kernel.org> # 3.11.x
Cc: Tod Jackson <tod.jackson@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Rafal Milecki <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/bcma/driver_pci.c            |   49 ++++++++++++++++++----------------
 include/linux/bcma/bcma_driver_pci.h |    1 +
 2 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index c9fd694..50329d1 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -210,25 +210,6 @@ static void bcma_core_pci_config_fixup(struct bcma_drv_pci *pc)
 	}
 }
 
-static void bcma_core_pci_power_save(struct bcma_drv_pci *pc, bool up)
-{
-	u16 data;
-
-	if (pc->core->id.rev >= 15 && pc->core->id.rev <= 20) {
-		data = up ? 0x74 : 0x7C;
-		bcma_pcie_mdio_writeread(pc, BCMA_CORE_PCI_MDIO_BLK1,
-					 BCMA_CORE_PCI_MDIO_BLK1_MGMT1, 0x7F64);
-		bcma_pcie_mdio_writeread(pc, BCMA_CORE_PCI_MDIO_BLK1,
-					 BCMA_CORE_PCI_MDIO_BLK1_MGMT3, data);
-	} else if (pc->core->id.rev >= 21 && pc->core->id.rev <= 22) {
-		data = up ? 0x75 : 0x7D;
-		bcma_pcie_mdio_writeread(pc, BCMA_CORE_PCI_MDIO_BLK1,
-					 BCMA_CORE_PCI_MDIO_BLK1_MGMT1, 0x7E65);
-		bcma_pcie_mdio_writeread(pc, BCMA_CORE_PCI_MDIO_BLK1,
-					 BCMA_CORE_PCI_MDIO_BLK1_MGMT3, data);
-	}
-}
-
 /**************************************************
  * Init.
  **************************************************/
@@ -255,6 +236,32 @@ void bcma_core_pci_init(struct bcma_drv_pci *pc)
 		bcma_core_pci_clientmode_init(pc);
 }
 
+void bcma_core_pci_power_save(struct bcma_bus *bus, bool up)
+{
+	struct bcma_drv_pci *pc;
+	u16 data;
+
+	if (bus->hosttype != BCMA_HOSTTYPE_PCI)
+		return;
+
+	pc = &bus->drv_pci[0];
+
+	if (pc->core->id.rev >= 15 && pc->core->id.rev <= 20) {
+		data = up ? 0x74 : 0x7C;
+		bcma_pcie_mdio_writeread(pc, BCMA_CORE_PCI_MDIO_BLK1,
+					 BCMA_CORE_PCI_MDIO_BLK1_MGMT1, 0x7F64);
+		bcma_pcie_mdio_writeread(pc, BCMA_CORE_PCI_MDIO_BLK1,
+					 BCMA_CORE_PCI_MDIO_BLK1_MGMT3, data);
+	} else if (pc->core->id.rev >= 21 && pc->core->id.rev <= 22) {
+		data = up ? 0x75 : 0x7D;
+		bcma_pcie_mdio_writeread(pc, BCMA_CORE_PCI_MDIO_BLK1,
+					 BCMA_CORE_PCI_MDIO_BLK1_MGMT1, 0x7E65);
+		bcma_pcie_mdio_writeread(pc, BCMA_CORE_PCI_MDIO_BLK1,
+					 BCMA_CORE_PCI_MDIO_BLK1_MGMT3, data);
+	}
+}
+EXPORT_SYMBOL_GPL(bcma_core_pci_power_save);
+
 int bcma_core_pci_irq_ctl(struct bcma_drv_pci *pc, struct bcma_device *core,
 			  bool enable)
 {
@@ -310,8 +317,6 @@ void bcma_core_pci_up(struct bcma_bus *bus)
 
 	pc = &bus->drv_pci[0];
 
-	bcma_core_pci_power_save(pc, true);
-
 	bcma_core_pci_extend_L1timer(pc, true);
 }
 EXPORT_SYMBOL_GPL(bcma_core_pci_up);
@@ -326,7 +331,5 @@ void bcma_core_pci_down(struct bcma_bus *bus)
 	pc = &bus->drv_pci[0];
 
 	bcma_core_pci_extend_L1timer(pc, false);
-
-	bcma_core_pci_power_save(pc, false);
 }
 EXPORT_SYMBOL_GPL(bcma_core_pci_down);
diff --git a/include/linux/bcma/bcma_driver_pci.h b/include/linux/bcma/bcma_driver_pci.h
index d66033f..0333e60 100644
--- a/include/linux/bcma/bcma_driver_pci.h
+++ b/include/linux/bcma/bcma_driver_pci.h
@@ -242,6 +242,7 @@ extern int bcma_core_pci_irq_ctl(struct bcma_drv_pci *pc,
 				 struct bcma_device *core, bool enable);
 extern void bcma_core_pci_up(struct bcma_bus *bus);
 extern void bcma_core_pci_down(struct bcma_bus *bus);
+extern void bcma_core_pci_power_save(struct bcma_bus *bus, bool up);
 
 extern int bcma_core_pci_pcibios_map_irq(const struct pci_dev *dev);
 extern int bcma_core_pci_plat_dev_init(struct pci_dev *dev);
-- 
1.7.10.4


