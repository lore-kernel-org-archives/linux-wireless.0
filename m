Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23325 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab0DAEiH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 00:38:07 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 31 Mar 2010 21:38:07 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19380.10220.955466.246781@gargle.gargle.HOWL>
Date: Thu, 1 Apr 2010 10:28:20 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] ath: Add a bus type field
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be used to store the bus types ( AHB/PCI/USB ).

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath.h                |   13 ++++++++++---
 drivers/net/wireless/ath/ath9k/ahb.c          |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    1 +
 drivers/net/wireless/ath/ath9k/pci.c          |    1 +
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 71fc960..1fbf6b1 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -48,6 +48,12 @@ enum ath_device_state {
 	ATH_HW_INITIALIZED,
 };
 
+enum ath_bus_type {
+	ATH_PCI,
+	ATH_AHB,
+	ATH_USB,
+};
+
 struct reg_dmn_pair_mapping {
 	u16 regDmnEnum;
 	u16 reg_5ghz_ctl;
@@ -73,9 +79,10 @@ struct ath_ops {
 struct ath_common;
 
 struct ath_bus_ops {
-	void		(*read_cachesize)(struct ath_common *common, int *csz);
-	bool		(*eeprom_read)(struct ath_common *common, u32 off, u16 *data);
-	void		(*bt_coex_prep)(struct ath_common *common);
+	enum ath_bus_type ath_bus_type;
+	void (*read_cachesize)(struct ath_common *common, int *csz);
+	bool (*eeprom_read)(struct ath_common *common, u32 off, u16 *data);
+	void (*bt_coex_prep)(struct ath_common *common);
 };
 
 struct ath_common {
diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index ca4994f..85fdd26 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -47,6 +47,7 @@ static bool ath_ahb_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 }
 
 static struct ath_bus_ops ath_ahb_bus_ops  = {
+	.ath_bus_type = ATH_AHB,
 	.read_cachesize = ath_ahb_read_cachesize,
 	.eeprom_read = ath_ahb_eeprom_read,
 };
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 90cfd90..e268d45 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -287,6 +287,7 @@ static bool ath_usb_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 }
 
 static const struct ath_bus_ops ath9k_usb_bus_ops = {
+	.ath_bus_type = ATH_USB,
 	.read_cachesize = ath_usb_read_cachesize,
 	.eeprom_read = ath_usb_eeprom_read,
 };
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 9441c67..1ec836c 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -88,6 +88,7 @@ static void ath_pci_bt_coex_prep(struct ath_common *common)
 }
 
 static const struct ath_bus_ops ath_pci_bus_ops = {
+	.ath_bus_type = ATH_PCI,
 	.read_cachesize = ath_pci_read_cachesize,
 	.eeprom_read = ath_pci_eeprom_read,
 	.bt_coex_prep = ath_pci_bt_coex_prep,
-- 
1.7.0.3

