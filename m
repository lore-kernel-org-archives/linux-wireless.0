Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:32071 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab3LBXAe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 18:00:34 -0500
From: Jingoo Han <jg1.han@samsung.com>
To: 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>,
	"'John W. Linville'" <linville@tuxdriver.com>,
	=?iso-8859-2?Q?'Rafa=B3_Mi=B3ecki'?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 02/39] bcma: pci: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:00:27 +0900
Message-id: <001701ceefb2$4ad65260$e082f720$%han@samsung.com> (sfid-20131203_000307_390972_C7DAAF37)
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
is not preferred.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/bcma/host_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 6fb98b5..6fe0909 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -270,7 +270,7 @@ static SIMPLE_DEV_PM_OPS(bcma_pm_ops, bcma_host_pci_suspend,
 
 #endif /* CONFIG_PM_SLEEP */
 
-static DEFINE_PCI_DEVICE_TABLE(bcma_pci_bridge_tbl) = {
+static const struct pci_device_id bcma_pci_bridge_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x0576) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4313) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 43224) },
-- 
1.7.10.4


