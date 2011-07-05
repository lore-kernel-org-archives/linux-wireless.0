Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:63264 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab1GEOrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 10:47:06 -0400
Received: by fxd18 with SMTP id 18so6268252fxd.11
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jul 2011 07:47:05 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3.0] ssb: fix init regression of hostmode PCI core
Date: Tue,  5 Jul 2011 17:25:32 +0200
Message-Id: <1309879532-8704-1-git-send-email-zajec5@gmail.com> (sfid-20110705_164738_900758_CB0A5DA9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Our workarounds seem to be clientmode PCI specific. Using SPROM
workaround on SoC resulted in Oops:

Data bus error, epc == 8017ed58, ra == 80225838
 Oops[#1]:
 Cpu 0
 $ 0   : 00000000 10008000 b8000000 00000001
 $ 4   : 80293b5c 00000caa ffffffff 00000000
 $ 8   : 0000000a 00000003 00000001 696d6d20
 $12   : ffffffff 00000000 00000000 ffffffff
 $16   : 802d0140 b8004800 802c0000 00000000
 $20   : 00000000 802c0000 00000000 802d04d4
 $24   : 00000018 80151a00
 $28   : 81816000 81817df8 8029bda0 80225838
 Hi    : 00000000
 Lo    : 00000000
 epc   : 8017ed58 ssb_ssb_read16+0x48/0x60
   Not tainted
 ra    : 80225838 ssb_pcicore_init+0x54/0x3b4

Reported-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Hauke: could you give it a try?

John: this regression was introduced in 3.0
---
 drivers/ssb/driver_pcicore.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
index 21b9465..11d85bf 100644
--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -516,8 +516,17 @@ static void ssb_pcicore_pcie_setup_workarounds(struct ssb_pcicore *pc)
 
 static void __devinit ssb_pcicore_init_clientmode(struct ssb_pcicore *pc)
 {
+	ssb_pcicore_fix_sprom_core_index(pc);
+
 	/* Disable PCI interrupts. */
 	ssb_write32(pc->dev, SSB_INTVEC, 0);
+
+	/* Additional PCIe always once-executed workarounds */
+	if (pc->dev->id.coreid == SSB_DEV_PCIE) {
+		ssb_pcicore_serdes_workaround(pc);
+		/* TODO: ASPM */
+		/* TODO: Clock Request Update */
+	}
 }
 
 void __devinit ssb_pcicore_init(struct ssb_pcicore *pc)
@@ -529,8 +538,6 @@ void __devinit ssb_pcicore_init(struct ssb_pcicore *pc)
 	if (!ssb_device_is_enabled(dev))
 		ssb_device_enable(dev, 0);
 
-	ssb_pcicore_fix_sprom_core_index(pc);
-
 #ifdef CONFIG_SSB_PCICORE_HOSTMODE
 	pc->hostmode = pcicore_is_in_hostmode(pc);
 	if (pc->hostmode)
@@ -538,13 +545,6 @@ void __devinit ssb_pcicore_init(struct ssb_pcicore *pc)
 #endif /* CONFIG_SSB_PCICORE_HOSTMODE */
 	if (!pc->hostmode)
 		ssb_pcicore_init_clientmode(pc);
-
-	/* Additional PCIe always once-executed workarounds */
-	if (dev->id.coreid == SSB_DEV_PCIE) {
-		ssb_pcicore_serdes_workaround(pc);
-		/* TODO: ASPM */
-		/* TODO: Clock Request Update */
-	}
 }
 
 static u32 ssb_pcie_read(struct ssb_pcicore *pc, u32 address)
-- 
1.7.3.4

