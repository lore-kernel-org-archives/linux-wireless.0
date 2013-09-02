Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:45613 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460Ab3IBIdE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Sep 2013 04:33:04 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 6/8] ath9k: Enable antenna diversity for WB335
Date: Mon,  2 Sep 2013 13:59:04 +0530
Message-Id: <1378110546-22305-6-git-send-email-sujith@msujith.org> (sfid-20130902_103311_036256_664A7CF6)
In-Reply-To: <1378110546-22305-1-git-send-email-sujith@msujith.org>
References: <21028.19411.335796.192256@gargle.gargle.HOWL>
 <1378110546-22305-1-git-send-email-sujith@msujith.org>
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

