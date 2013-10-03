Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:38301 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab3JCLt3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 07:49:29 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	arend@broadcom.com, brcm80211-dev-list@broadcom.com,
	jogo@openwrt.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] bcma: add PCI id 0x4313
Date: Thu,  3 Oct 2013 13:49:10 +0200
Message-Id: <1380800951-28643-2-git-send-email-hauke@hauke-m.de> (sfid-20131003_134931_894824_90B28721)
In-Reply-To: <1380800951-28643-1-git-send-email-hauke@hauke-m.de>
References: <1380800951-28643-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This PCI id is used by some BCM4313 cards without a sprom. I have seen
such a card on a router connected to some BCM63XX SoC via PCIe. There
are cards out there with the same PCI id and a BCM4311, which is a pre
ieee80211n chip only supporting ieee80211a, these are still not
supported by b43 and not detected by ssb.

This devices was found by someone in this ticket:
https://dev.openwrt.org/ticket/13551

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/host_pci.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index a1caf9c..6fb98b5 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -272,6 +272,7 @@ static SIMPLE_DEV_PM_OPS(bcma_pm_ops, bcma_host_pci_suspend,
 
 static DEFINE_PCI_DEVICE_TABLE(bcma_pci_bridge_tbl) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x0576) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4313) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 43224) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4331) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4353) },
-- 
1.7.10.4

