Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31469 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab2HBG3D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 02:29:03 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Felix Bitterli <felixb@qca.qualcomm.com>
Subject: [PATCH] ath9k: Add PID/VID support for AR1111
Date: Thu, 2 Aug 2012 11:58:50 +0530
Message-ID: <1343888930-353-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120802_082923_877790_1E194E70)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

AR1111 is same as AR9485. The h/w
difference between them is quite insignificant,
Felix suggests only very few baseband features
may not be available in AR1111. The h/w code for
AR9485 is already present, so AR1111 should
work fine with the addition of its PID/VID.

Cc: stable@vger.kernel.org [2.6.39+]
Cc: Felix Bitterli <felixb@qca.qualcomm.com>
Reported-by: Tim and Alison Bentley <Home@trarbentley.net>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    1 +
 drivers/net/wireless/ath/ath9k/hw.h  |    1 +
 drivers/net/wireless/ath/ath9k/pci.c |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index cfa91ab..60b6a9d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -730,6 +730,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 	case AR9300_DEVID_QCA955X:
 	case AR9300_DEVID_AR9580:
 	case AR9300_DEVID_AR9462:
+	case AR9485_DEVID_AR1111:
 		break;
 	default:
 		if (common->bus_ops->ath_bus_type == ATH_USB)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index dd0c146..ce7332c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -49,6 +49,7 @@
 #define AR9300_DEVID_AR9462	0x0034
 #define AR9300_DEVID_AR9330	0x0035
 #define AR9300_DEVID_QCA955X	0x0038
+#define AR9485_DEVID_AR1111	0x0037
 
 #define AR5416_AR9100_DEVID	0x000b
 
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 87b89d5..d455de9 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -37,6 +37,7 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 	{ PCI_VDEVICE(ATHEROS, 0x0032) }, /* PCI-E  AR9485 */
 	{ PCI_VDEVICE(ATHEROS, 0x0033) }, /* PCI-E  AR9580 */
 	{ PCI_VDEVICE(ATHEROS, 0x0034) }, /* PCI-E  AR9462 */
+	{ PCI_VDEVICE(ATHEROS, 0x0037) }, /* PCI-E  AR1111/AR9485 */
 	{ 0 }
 };
 
-- 
1.7.0.4

