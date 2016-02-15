Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35737 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbcBOUSS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2016 15:18:18 -0500
Received: by mail-wm0-f51.google.com with SMTP id c200so129832840wme.0
        for <linux-wireless@vger.kernel.org>; Mon, 15 Feb 2016 12:18:17 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@googlemail.com>, kvalo@adurom.com
Subject: [PATCH] carl9170: import 1.9.9 firmware headers
Date: Mon, 15 Feb 2016 21:16:06 +0100
Message-Id: <1455567366-10851-1-git-send-email-chunkeey@googlemail.com> (sfid-20160215_211822_581454_3923010E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Import new headers from my firmware branch:
<https://github.com/chunkeey/carl9170fw>

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/fwcmd.h   |  8 ++++
 drivers/net/wireless/ath/carl9170/fwdesc.h  |  6 +++
 drivers/net/wireless/ath/carl9170/hw.h      | 73 +++++++++++++++++++++++++++--
 drivers/net/wireless/ath/carl9170/version.h |  6 +--
 4 files changed, 87 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/fwcmd.h b/drivers/net/wireless/ath/carl9170/fwcmd.h
index 9111d4f..ea1d80f 100644
--- a/drivers/net/wireless/ath/carl9170/fwcmd.h
+++ b/drivers/net/wireless/ath/carl9170/fwcmd.h
@@ -56,6 +56,7 @@ enum carl9170_cmd_oids {
 	CARL9170_CMD_RX_FILTER		= 0x07,
 	CARL9170_CMD_WOL		= 0x08,
 	CARL9170_CMD_TALLY		= 0x09,
+	CARL9170_CMD_WREGB		= 0x0a,
 
 	/* CAM */
 	CARL9170_CMD_EKEY		= 0x10,
@@ -123,6 +124,12 @@ struct carl9170_write_reg {
 	} regs[0] __packed;
 } __packed;
 
+struct carl9170_write_reg_byte {
+	__le32	addr;
+	__le32  count;
+	u8	val[0];
+} __packed;
+
 #define	CARL9170FW_PHY_HT_ENABLE		0x4
 #define	CARL9170FW_PHY_HT_DYN2040		0x8
 #define	CARL9170FW_PHY_HT_EXT_CHAN_OFF		0x3
@@ -226,6 +233,7 @@ struct carl9170_cmd {
 		struct carl9170_u32_list	echo;
 		struct carl9170_reg_list	rreg;
 		struct carl9170_write_reg	wreg;
+		struct carl9170_write_reg_byte	wregb;
 		struct carl9170_rf_init		rf_init;
 		struct carl9170_psm		psm;
 		struct carl9170_wol_cmd		wol;
diff --git a/drivers/net/wireless/ath/carl9170/fwdesc.h b/drivers/net/wireless/ath/carl9170/fwdesc.h
index 66848d4..0533f79c 100644
--- a/drivers/net/wireless/ath/carl9170/fwdesc.h
+++ b/drivers/net/wireless/ath/carl9170/fwdesc.h
@@ -81,6 +81,12 @@ enum carl9170fw_feature_list {
 	/* Firmware will pass BA when BARs are queued */
 	CARL9170FW_RX_BA_FILTER,
 
+	/* Firmware has support to write a byte at a time */
+	CARL9170FW_HAS_WREGB_CMD,
+
+	/* Pattern generator */
+	CARL9170FW_PATTERN_GENERATOR,
+
 	/* KEEP LAST */
 	__CARL9170FW_FEATURE_NUM
 };
diff --git a/drivers/net/wireless/ath/carl9170/hw.h b/drivers/net/wireless/ath/carl9170/hw.h
index 0db874a..08e0ae9 100644
--- a/drivers/net/wireless/ath/carl9170/hw.h
+++ b/drivers/net/wireless/ath/carl9170/hw.h
@@ -453,9 +453,74 @@
 #define	AR9170_MC_REG_BASE			0x1d1000
 
 #define	AR9170_MC_REG_FLASH_WAIT_STATE		(AR9170_MC_REG_BASE + 0x000)
-#define	AR9170_MC_REG_SEEPROM_WP0		(AR9170_MC_REG_BASE + 0x400)
-#define	AR9170_MC_REG_SEEPROM_WP1		(AR9170_MC_REG_BASE + 0x404)
-#define	AR9170_MC_REG_SEEPROM_WP2		(AR9170_MC_REG_BASE + 0x408)
+
+#define AR9170_SPI_REG_BASE			(AR9170_MC_REG_BASE + 0x200)
+#define AR9170_SPI_REG_CONTROL0			(AR9170_SPI_REG_BASE + 0x000)
+#define		AR9170_SPI_CONTROL0_BUSY		BIT(0)
+#define		AR9170_SPI_CONTROL0_CMD_GO		BIT(1)
+#define		AR9170_SPI_CONTROL0_PAGE_WR		BIT(2)
+#define		AR9170_SPI_CONTROL0_SEQ_RD		BIT(3)
+#define		AR9170_SPI_CONTROL0_CMD_ABORT		BIT(4)
+#define		AR9170_SPI_CONTROL0_CMD_LEN_S		8
+#define		AR9170_SPI_CONTROL0_CMD_LEN		0x00000f00
+#define		AR9170_SPI_CONTROL0_RD_LEN_S		12
+#define		AR9170_SPI_CONTROL0_RD_LEN		0x00007000
+
+#define	AR9170_SPI_REG_CONTROL1			(AR9170_SPI_REG_BASE + 0x004)
+#define		AR9170_SPI_CONTROL1_SCK_RATE		BIT(0)
+#define		AR9170_SPI_CONTROL1_DRIVE_SDO		BIT(1)
+#define		AR9170_SPI_CONTROL1_MODE_SEL_S		2
+#define		AR9170_SPI_CONTROL1_MODE_SEL		0x000000c0
+#define		AR9170_SPI_CONTROL1_WRITE_PROTECT	BIT(4)
+
+#define AR9170_SPI_REG_COMMAND_PORT0		(AR9170_SPI_REG_BASE + 0x008)
+#define		AR9170_SPI_COMMAND_PORT0_CMD0_S		0
+#define		AR9170_SPI_COMMAND_PORT0_CMD0		0x000000ff
+#define		AR9170_SPI_COMMAND_PORT0_CMD1_S		8
+#define		AR9170_SPI_COMMAND_PORT0_CMD1		0x0000ff00
+#define		AR9170_SPI_COMMAND_PORT0_CMD2_S		16
+#define		AR9170_SPI_COMMAND_PORT0_CMD2		0x00ff0000
+#define		AR9170_SPI_COMMAND_PORT0_CMD3_S		24
+#define		AR9170_SPI_COMMAND_PORT0_CMD3		0xff000000
+
+#define AR9170_SPI_REG_COMMAND_PORT1		(AR9170_SPI_REG_BASE + 0x00C)
+#define		AR9170_SPI_COMMAND_PORT1_CMD4_S		0
+#define		AR9170_SPI_COMMAND_PORT1_CMD4		0x000000ff
+#define		AR9170_SPI_COMMAND_PORT1_CMD5_S		8
+#define		AR9170_SPI_COMMAND_PORT1_CMD5		0x0000ff00
+#define		AR9170_SPI_COMMAND_PORT1_CMD6_S		16
+#define		AR9170_SPI_COMMAND_PORT1_CMD6		0x00ff0000
+#define		AR9170_SPI_COMMAND_PORT1_CMD7_S		24
+#define		AR9170_SPI_COMMAND_PORT1_CMD7		0xff000000
+
+#define AR9170_SPI_REG_DATA_PORT		(AR9170_SPI_REG_BASE + 0x010)
+#define AR9170_SPI_REG_PAGE_WRITE_LEN		(AR9170_SPI_REG_BASE + 0x014)
+
+#define AR9170_EEPROM_REG_BASE			(AR9170_MC_REG_BASE + 0x400)
+#define	AR9170_EEPROM_REG_WP_MAGIC1		(AR9170_EEPROM_REG_BASE + 0x000)
+#define		AR9170_EEPROM_WP_MAGIC1			0x12345678
+
+#define	AR9170_EEPROM_REG_WP_MAGIC2		(AR9170_EEPROM_REG_BASE + 0x004)
+#define		AR9170_EEPROM_WP_MAGIC2			0x55aa00ff
+
+#define	AR9170_EEPROM_REG_WP_MAGIC3		(AR9170_EEPROM_REG_BASE + 0x008)
+#define		AR9170_EEPROM_WP_MAGIC3			0x13579ace
+
+#define	AR9170_EEPROM_REG_CLOCK_DIV		(AR9170_EEPROM_REG_BASE + 0x00C)
+#define		AR9170_EEPROM_CLOCK_DIV_FAC_S		0
+#define		AR9170_EEPROM_CLOCK_DIV_FAC		0x000001ff
+#define		AR9170_EEPROM_CLOCK_DIV_FAC_39KHZ	0xff
+#define		AR9170_EEPROM_CLOCK_DIV_FAC_78KHZ	0x7f
+#define		AR9170_EEPROM_CLOCK_DIV_FAC_312KHZ	0x1f
+#define		AR9170_EEPROM_CLOCK_DIV_FAC_10MHZ	0x0
+#define	AR9170_EEPROM_CLOCK_DIV_SOFT_RST		BIT(9)
+
+#define AR9170_EEPROM_REG_MODE			(AR9170_EEPROM_REG_BASE + 0x010)
+#define	AR9170_EEPROM_MODE_EEPROM_SIZE_16K_PLUS		BIT(31)
+
+#define AR9170_EEPROM_REG_WRITE_PROTECT		(AR9170_EEPROM_REG_BASE + 0x014)
+#define		AR9170_EEPROM_WRITE_PROTECT_WP_STATUS	BIT(0)
+#define		AR9170_EEPROM_WRITE_PROTECT_WP_SET	BIT(8)
 
 /* Interrupt Controller */
 #define	AR9170_MAX_INT_SRC			9
@@ -589,11 +654,13 @@
 #define	AR9170_USB_REG_EP10_MAP			(AR9170_USB_REG_BASE + 0x039)
 
 #define	AR9170_USB_REG_EP_IN_MAX_SIZE_HIGH	(AR9170_USB_REG_BASE + 0x03f)
+#define		AR9170_USB_EP_IN_STALL			0x8
 #define		AR9170_USB_EP_IN_TOGGLE			0x10
 
 #define	AR9170_USB_REG_EP_IN_MAX_SIZE_LOW	(AR9170_USB_REG_BASE + 0x03e)
 
 #define	AR9170_USB_REG_EP_OUT_MAX_SIZE_HIGH	(AR9170_USB_REG_BASE + 0x05f)
+#define		AR9170_USB_EP_OUT_STALL			0x8
 #define		AR9170_USB_EP_OUT_TOGGLE		0x10
 
 #define	AR9170_USB_REG_EP_OUT_MAX_SIZE_LOW	(AR9170_USB_REG_BASE + 0x05e)
diff --git a/drivers/net/wireless/ath/carl9170/version.h b/drivers/net/wireless/ath/carl9170/version.h
index 2282847..a0410fe 100644
--- a/drivers/net/wireless/ath/carl9170/version.h
+++ b/drivers/net/wireless/ath/carl9170/version.h
@@ -1,7 +1,7 @@
 #ifndef __CARL9170_SHARED_VERSION_H
 #define __CARL9170_SHARED_VERSION_H
-#define CARL9170FW_VERSION_YEAR 12
-#define CARL9170FW_VERSION_MONTH 12
+#define CARL9170FW_VERSION_YEAR 16
+#define CARL9170FW_VERSION_MONTH 2
 #define CARL9170FW_VERSION_DAY 15
-#define CARL9170FW_VERSION_GIT "1.9.7"
+#define CARL9170FW_VERSION_GIT "1.9.9"
 #endif /* __CARL9170_SHARED_VERSION_H */
-- 
2.7.0

