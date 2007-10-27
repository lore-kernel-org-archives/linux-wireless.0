Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:42894 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbXJ0XbP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 19:31:15 -0400
Date: Sun, 28 Oct 2007 02:31:13 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: [PATCH 6/7] ath5k: Add PCI IDs for newer chips
Message-ID: <20071027233113.GF5973@localhost.domain.invalid> (sfid-20071028_003124_959809_8EA7FD02)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 *Add PCI IDs for 5416/5418.

 *Print a message during attach that 
  these chips are not yet supported.

for base.c
Changes-licensed-under: 3-clause-BSD

for ath5k.h
Changes-licensed-under: ISC

Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index fa9f3ae..ef76f1c 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -50,9 +50,9 @@
 #define PCI_DEVICE_ID_ATHEROS_AR5212_FPGA 	0xf013 /* AR5212 (emulation board) */
 #define PCI_DEVICE_ID_ATHEROS_AR5211_LEGACY 	0xff12 /* AR5211 (emulation board) */
 #define PCI_DEVICE_ID_ATHEROS_AR5211_FPGA11B 	0xf11b /* AR5211 (emulation board) */
-#define PCI_DEVICE_ID_ATHEROS_AR5212_REV2 	0x0052 /* AR5312 WMAC (AP31) */
-#define PCI_DEVICE_ID_ATHEROS_AR5212_REV7 	0x0057 /* AR5312 WMAC (AP30-040) */
-#define PCI_DEVICE_ID_ATHEROS_AR5212_REV8 	0x0058 /* AR5312 WMAC (AP43-030) */
+#define PCI_DEVICE_ID_ATHEROS_AR5312_REV2 	0x0052 /* AR5312 WMAC (AP31) */
+#define PCI_DEVICE_ID_ATHEROS_AR5312_REV7 	0x0057 /* AR5312 WMAC (AP30-040) */
+#define PCI_DEVICE_ID_ATHEROS_AR5312_REV8 	0x0058 /* AR5312 WMAC (AP43-030) */
 #define PCI_DEVICE_ID_ATHEROS_AR5212_0014 	0x0014 /* AR5212 compatible */
 #define PCI_DEVICE_ID_ATHEROS_AR5212_0015 	0x0015 /* AR5212 compatible */
 #define PCI_DEVICE_ID_ATHEROS_AR5212_0016 	0x0016 /* AR5212 compatible */
@@ -62,6 +62,8 @@
 #define PCI_DEVICE_ID_ATHEROS_AR2413 		0x001a /* AR2413 (Griffin-lite) */
 #define PCI_DEVICE_ID_ATHEROS_AR5413 		0x001b /* AR5413 (Eagle) */
 #define PCI_DEVICE_ID_ATHEROS_AR5424 		0x001c /* AR5424 (Condor PCI-E) */
+#define PCI_DEVICE_ID_ATHEROS_AR5416 		0x0023 /* AR5416 */
+#define PCI_DEVICE_ID_ATHEROS_AR5418 		0x0024 /* AR5418 */
 
 /****************************\
   GENERIC DRIVER DEFINITIONS
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 821ed44..e6a3155 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -182,7 +182,7 @@ MODULE_VERSION("0.1.1 (EXPERIMENTAL)");
 static struct pci_device_id ath5k_pci_id_table[] __devinitdata = {
 	{ PCI_VDEVICE(ATHEROS, 0x0207), .driver_data = AR5K_AR5210 }, /* 5210 early */
 	{ PCI_VDEVICE(ATHEROS, 0x0007), .driver_data = AR5K_AR5210 }, /* 5210 */
-	{ PCI_VDEVICE(ATHEROS, 0x0011), .driver_data = AR5K_AR5211 }, /* 5311 */
+	{ PCI_VDEVICE(ATHEROS, 0x0011), .driver_data = AR5K_AR5211 }, /* 5311 - this is on AHB bus !*/
 	{ PCI_VDEVICE(ATHEROS, 0x0012), .driver_data = AR5K_AR5211 }, /* 5211 */
 	{ PCI_VDEVICE(ATHEROS, 0x0013), .driver_data = AR5K_AR5212 }, /* 5212 */
 	{ PCI_VDEVICE(3COM_2,  0x0013), .driver_data = AR5K_AR5212 }, /* 3com 5212 */
@@ -197,6 +197,8 @@ static struct pci_device_id ath5k_pci_id_table[] __devinitdata = {
 	{ PCI_VDEVICE(ATHEROS, 0x001a), .driver_data = AR5K_AR5212 }, /* 2413 Griffin-lite */
 	{ PCI_VDEVICE(ATHEROS, 0x001b), .driver_data = AR5K_AR5212 }, /* 5413 Eagle */
 	{ PCI_VDEVICE(ATHEROS, 0x001c), .driver_data = AR5K_AR5212 }, /* 5424 Condor (PCI-E)*/
+	{ PCI_VDEVICE(ATHEROS, 0x0023), .driver_data = AR5K_AR5212 }, /* 5416 */
+	{ PCI_VDEVICE(ATHEROS, 0x0024), .driver_data = AR5K_AR5212 }, /* 5418 */
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, ath5k_pci_id_table);
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 1c10203..c95ae4b 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -278,6 +278,13 @@ struct ath5k_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc,
 		ah->ah_radio_2ghz_revision = ath5k_hw_radio_revision(ah,
 				CHANNEL_2GHZ);
 
+	/* Return on unsuported chips (unsupported eeprom etc) */
+	if(srev >= AR5K_SREV_VER_AR5416){
+		printk(KERN_ERR "ath5k: Device not yet supported.\n");
+		ret = -ENODEV;
+		goto err_free;
+	}
+
 	/* Identify single chip solutions */
 	if((srev <= AR5K_SREV_VER_AR5414) &&
 	(srev >= AR5K_SREV_VER_AR2424)) {



