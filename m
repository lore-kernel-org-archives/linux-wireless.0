Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:17999 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbZKQQuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:50:08 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 16/16] wl1251: add NVS in EEPROM support
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Nov 2009 18:50:09 +0200
Message-ID: <20091117165008.2236.5592.stgit@tikku>
In-Reply-To: <20091117164614.2236.8543.stgit@tikku>
References: <20091117164614.2236.8543.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David-John Willis <John.Willis@Distant-earth.com>

wl1251 supports also that NVS is stored in a separate EEPROM, add support
for that.

kvalo: use platform data instead Kconfig and use kernel style

Signed-off-by: David-John Willis <John.Willis@Distant-earth.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251.h      |    1 +
 drivers/net/wireless/wl12xx/wl1251_boot.c |   20 +++++++++++++-------
 drivers/net/wireless/wl12xx/wl1251_reg.h  |    6 ++++++
 drivers/net/wireless/wl12xx/wl1251_spi.c  |    2 ++
 include/linux/spi/wl12xx.h                |    1 +
 5 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251.h b/drivers/net/wireless/wl12xx/wl1251.h
index a839466..054533f 100644
--- a/drivers/net/wireless/wl12xx/wl1251.h
+++ b/drivers/net/wireless/wl12xx/wl1251.h
@@ -269,6 +269,7 @@ struct wl1251 {
 
 	void (*set_power)(bool enable);
 	int irq;
+	bool use_eeprom;
 
 	enum wl1251_state state;
 	struct mutex mutex;
diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.c b/drivers/net/wireless/wl12xx/wl1251_boot.c
index 5094f24..2e733e7 100644
--- a/drivers/net/wireless/wl12xx/wl1251_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1251_boot.c
@@ -494,13 +494,19 @@ int wl1251_boot(struct wl1251 *wl)
 		goto out;
 
 	/* 2. start processing NVS file */
-	ret = wl1251_boot_upload_nvs(wl);
-	if (ret < 0)
-		goto out;
-
-	/* write firmware's last address (ie. it's length) to
-	 * ACX_EEPROMLESS_IND_REG */
-	wl1251_reg_write32(wl, ACX_EEPROMLESS_IND_REG, wl->fw_len);
+	if (wl->use_eeprom) {
+		wl1251_reg_write32(wl, ACX_REG_EE_START, START_EEPROM_MGR);
+		msleep(4000);
+		wl1251_reg_write32(wl, ACX_EEPROMLESS_IND_REG, USE_EEPROM);
+	} else {
+		ret = wl1251_boot_upload_nvs(wl);
+		if (ret < 0)
+			goto out;
+
+		/* write firmware's last address (ie. it's length) to
+		 * ACX_EEPROMLESS_IND_REG */
+		wl1251_reg_write32(wl, ACX_EEPROMLESS_IND_REG, wl->fw_len);
+	}
 
 	/* 6. read the EEPROM parameters */
 	tmp = wl1251_reg_read32(wl, SCR_PAD2);
diff --git a/drivers/net/wireless/wl12xx/wl1251_reg.h b/drivers/net/wireless/wl12xx/wl1251_reg.h
index 06e1bd9..0ca3b43 100644
--- a/drivers/net/wireless/wl12xx/wl1251_reg.h
+++ b/drivers/net/wireless/wl12xx/wl1251_reg.h
@@ -370,6 +370,7 @@ enum wl12xx_acx_int_reg {
  EEPROM location specified in the EE_ADDR register.
  The Wlan hardware hardware clears this bit automatically.
 *===============================================*/
+#define EE_CTL                              (REGISTERS_BASE + 0x2000)
 #define ACX_EE_CTL_REG                      EE_CTL
 #define EE_WRITE                            0x00000001ul
 #define EE_READ                             0x00000002ul
@@ -380,6 +381,7 @@ enum wl12xx_acx_int_reg {
   This register specifies the address
   within the EEPROM from/to which to read/write data.
   ===============================================*/
+#define EE_ADDR                             (REGISTERS_BASE + 0x2008)
 #define ACX_EE_ADDR_REG                     EE_ADDR
 
 /*===============================================
@@ -389,8 +391,12 @@ enum wl12xx_acx_int_reg {
   data from the EEPROM or the write data
   to be written to the EEPROM.
   ===============================================*/
+#define EE_DATA                             (REGISTERS_BASE + 0x2004)
 #define ACX_EE_DATA_REG                     EE_DATA
 
+#define EEPROM_ACCESS_TO                    10000   /* timeout counter */
+#define START_EEPROM_MGR                    0x00000001
+
 /*===============================================
   EEPROM Base Address  - 32bit RW
   ------------------------------------------
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.c b/drivers/net/wireless/wl12xx/wl1251_spi.c
index 2cf8a21..9cc8c32 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
@@ -270,6 +270,8 @@ static int __devinit wl1251_spi_probe(struct spi_device *spi)
 		return -ENODEV;
 	}
 
+	wl->use_eeprom = pdata->use_eeprom;
+
 	ret = request_irq(wl->irq, wl1251_irq, 0, DRIVER_NAME, wl);
 	if (ret < 0) {
 		wl1251_error("request_irq() failed: %d", ret);
diff --git a/include/linux/spi/wl12xx.h b/include/linux/spi/wl12xx.h
index 11430ca..aed64ed 100644
--- a/include/linux/spi/wl12xx.h
+++ b/include/linux/spi/wl12xx.h
@@ -26,6 +26,7 @@
 
 struct wl12xx_platform_data {
 	void (*set_power)(bool enable);
+	bool use_eeprom;
 };
 
 #endif

