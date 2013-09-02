Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:50889 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab3IBFsE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Sep 2013 01:48:04 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/6] ath9k: Enable antenna diversity for WB335
Date: Mon,  2 Sep 2013 11:14:05 +0530
Message-Id: <1378100645-29868-6-git-send-email-sujith@msujith.org> (sfid-20130902_074810_942154_F5271C63)
In-Reply-To: <1378100645-29868-1-git-send-email-sujith@msujith.org>
References: <1378100645-29868-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/pci.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index d089a7c..b43a2ec 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -269,7 +269,11 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 
 	{ PCI_VDEVICE(ATHEROS, 0x0034) }, /* PCI-E  AR9462 */
 	{ PCI_VDEVICE(ATHEROS, 0x0037) }, /* PCI-E  AR1111/AR9485 */
-	{ PCI_VDEVICE(ATHEROS, 0x0036) }, /* PCI-E  AR9565 */
+
+	/* PCI-E AR9565 (WB335) */
+	{ PCI_VDEVICE(ATHEROS, 0x0036),
+	  .driver_data = ATH9K_PCI_BT_ANT_DIV },
+
 	{ 0 }
 };
 
-- 
1.8.4

