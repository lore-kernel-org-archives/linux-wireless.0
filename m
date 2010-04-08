Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46720 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193Ab0DHT1k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:40 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 013/102] ath9k_hw: Add the PCI IDs for AR9300 and fill up the pci_id_tables
Date: Thu,  8 Apr 2010 15:26:09 -0400
Message-Id: <1270754858-26266-14-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Senthil Balasubramanian <senthilkumar@atheros.com>

Also, clean up and reorganize the AR9287 macro to have better
ordering. We won't add the PCI ID to the supported device list
until we have some functional code for it.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    5 +++--
 drivers/net/wireless/ath/ath9k/hw.h |    6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d3b7a98..6d4c6e6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -992,9 +992,10 @@ int ath9k_hw_init(struct ath_hw *ah)
 	case AR9280_DEVID_PCI:
 	case AR9280_DEVID_PCIE:
 	case AR9285_DEVID_PCIE:
-	case AR5416_DEVID_AR9287_PCI:
-	case AR5416_DEVID_AR9287_PCIE:
+	case AR9287_DEVID_PCI:
+	case AR9287_DEVID_PCIE:
 	case AR2427_DEVID_PCIE:
+	case AR9300_DEVID_PCIE:
 		break;
 	default:
 		if (common->bus_ops->ath_bus_type == ATH_USB)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index a0ab32a..705dcad 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -41,6 +41,9 @@
 #define AR9280_DEVID_PCIE	0x002a
 #define AR9285_DEVID_PCIE	0x002b
 #define AR2427_DEVID_PCIE	0x002c
+#define AR9287_DEVID_PCI	0x002d
+#define AR9287_DEVID_PCIE	0x002e
+#define AR9300_DEVID_PCIE	0x0030
 
 #define AR5416_AR9100_DEVID	0x000b
 
@@ -48,9 +51,6 @@
 #define AR_SUBVENDOR_ID_NEW_A	0x7065
 #define AR5416_MAGIC		0x19641014
 
-#define AR5416_DEVID_AR9287_PCI  0x002D
-#define AR5416_DEVID_AR9287_PCIE 0x002E
-
 #define AR9280_COEX2WIRE_SUBSYSID	0x309b
 #define AT9285_COEX3WIRE_SA_SUBSYSID	0x30aa
 #define AT9285_COEX3WIRE_DA_SUBSYSID	0x30ab
-- 
1.6.3.3

