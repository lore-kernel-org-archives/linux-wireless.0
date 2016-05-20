Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36061 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbcETOlb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2016 10:41:31 -0400
Received: by mail-wm0-f51.google.com with SMTP id n129so275052311wmn.1
        for <linux-wireless@vger.kernel.org>; Fri, 20 May 2016 07:41:30 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@open-mesh.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Sven Eckelmann <sven.eckelmann@open-mesh.com>
Subject: [PATCH 2/2] ath10k: Add board data download from target
Date: Fri, 20 May 2016 16:41:12 +0200
Message-Id: <1463755272-12912-2-git-send-email-sven.eckelmann@open-mesh.com> (sfid-20160520_164134_468432_CB58F330)
In-Reply-To: <1568876.Six5hABE57@bentobox>
References: <1568876.Six5hABE57@bentobox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The QCA9887 stores its calibration data (board.bin) inside the EEPROM of
the target. This has to be downloaded manually to allow the device to
initialize correctly.

Signed-off-by: Sven Eckelmann <sven.eckelmann@open-mesh.com>
---
 drivers/net/wireless/ath/ath10k/core.c |  41 +++++++++-
 drivers/net/wireless/ath/ath10k/core.h |   3 +
 drivers/net/wireless/ath/ath10k/hif.h  |  14 ++++
 drivers/net/wireless/ath/ath10k/hw.h   |  22 ++++++
 drivers/net/wireless/ath/ath10k/pci.c  | 139 +++++++++++++++++++++++++++++++++
 5 files changed, 218 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 0f4a4f6..a70759a 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/firmware.h>
 #include <linux/of.h>
+#include <asm/byteorder.h>
 
 #include "core.h"
 #include "mac.h"
@@ -550,6 +551,34 @@ out:
 	return ret;
 }
 
+static int ath10k_download_cal_eeprom(struct ath10k *ar)
+{
+	size_t data_len;
+	void *data = NULL;
+	int ret;
+
+	ret = ath10k_hif_fetch_target_board_data(ar, &data, &data_len);
+	if (ret) {
+		ath10k_warn(ar, "failed to read calibration data from EEPROM: %d\n",
+			    ret);
+		goto out_free;
+	}
+
+	ret = ath10k_download_board_data(ar, data, data_len);
+	if (ret) {
+		ath10k_warn(ar, "failed to download calibration data from EEPROM: %d\n",
+			    ret);
+		goto out_free;
+	}
+
+	ret = 0;
+
+out_free:
+	kfree(data);
+
+	return ret;
+}
+
 static int ath10k_core_get_board_id_from_otp(struct ath10k *ar)
 {
 	u32 result, address;
@@ -1312,7 +1341,17 @@ static int ath10k_download_cal_data(struct ath10k *ar)
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT,
-		   "boot did not find DT entry, try OTP next: %d\n",
+		   "boot did not find DT entry, try target EEPROM next: %d\n",
+		   ret);
+
+	ret = ath10k_download_cal_eeprom(ar);
+	if (ret == 0) {
+		ar->cal_mode = ATH10K_CAL_MODE_EEPROM;
+		goto done;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT,
+		   "boot did not find target EEPROM entry, try OTP next: %d\n",
 		   ret);
 
 	ret = ath10k_download_and_run_otp(ar);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 1852e0e..86d7642 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -571,6 +571,7 @@ enum ath10k_cal_mode {
 	ATH10K_CAL_MODE_DT,
 	ATH10K_PRE_CAL_MODE_FILE,
 	ATH10K_PRE_CAL_MODE_DT,
+	ATH10K_CAL_MODE_EEPROM,
 };
 
 enum ath10k_crypt_mode {
@@ -593,6 +594,8 @@ static inline const char *ath10k_cal_mode_str(enum ath10k_cal_mode mode)
 		return "pre-cal-file";
 	case ATH10K_PRE_CAL_MODE_DT:
 		return "pre-cal-dt";
+	case ATH10K_CAL_MODE_EEPROM:
+		return "eeprom";
 	}
 
 	return "unknown";
diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index 89e7076..c18b8c8 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -87,6 +87,10 @@ struct ath10k_hif_ops {
 
 	int (*suspend)(struct ath10k *ar);
 	int (*resume)(struct ath10k *ar);
+
+	/* fetch board data from target eeprom */
+	int (*fetch_target_board_data)(struct ath10k *ar, void **data,
+				       size_t *data_len);
 };
 
 static inline int ath10k_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
@@ -202,4 +206,14 @@ static inline void ath10k_hif_write32(struct ath10k *ar,
 	ar->hif.ops->write32(ar, address, data);
 }
 
+static inline int ath10k_hif_fetch_target_board_data(struct ath10k *ar,
+						     void **data,
+						     size_t *data_len)
+{
+	if (!ar->hif.ops->fetch_target_board_data)
+		return -EOPNOTSUPP;
+
+	return ar->hif.ops->fetch_target_board_data(ar, data, data_len);
+}
+
 #endif /* _HIF_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 9108831..53ca40e 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -557,7 +557,10 @@ enum ath10k_hw_4addr_pad {
 #define WLAN_SYSTEM_SLEEP_DISABLE_MASK		0x00000001
 
 #define WLAN_GPIO_PIN0_ADDRESS			0x00000028
+#define WLAN_GPIO_PIN0_CONFIG_LSB		11
 #define WLAN_GPIO_PIN0_CONFIG_MASK		0x00007800
+#define WLAN_GPIO_PIN0_PAD_PULL_LSB		5
+#define WLAN_GPIO_PIN0_PAD_PULL_MASK		0x00000060
 #define WLAN_GPIO_PIN1_ADDRESS			0x0000002c
 #define WLAN_GPIO_PIN1_CONFIG_MASK		0x00007800
 #define WLAN_GPIO_PIN10_ADDRESS			0x00000050
@@ -570,6 +573,8 @@ enum ath10k_hw_4addr_pad {
 #define CLOCK_GPIO_BT_CLK_OUT_EN_MASK		0
 
 #define SI_CONFIG_OFFSET			0x00000000
+#define SI_CONFIG_ERR_INT_LSB			19
+#define SI_CONFIG_ERR_INT_MASK			0x00080000
 #define SI_CONFIG_BIDIR_OD_DATA_LSB		18
 #define SI_CONFIG_BIDIR_OD_DATA_MASK		0x00040000
 #define SI_CONFIG_I2C_LSB			16
@@ -583,7 +588,9 @@ enum ath10k_hw_4addr_pad {
 #define SI_CONFIG_DIVIDER_LSB			0
 #define SI_CONFIG_DIVIDER_MASK			0x0000000f
 #define SI_CS_OFFSET				0x00000004
+#define SI_CS_DONE_ERR_LSB			10
 #define SI_CS_DONE_ERR_MASK			0x00000400
+#define SI_CS_DONE_INT_LSB			9
 #define SI_CS_DONE_INT_MASK			0x00000200
 #define SI_CS_START_LSB				8
 #define SI_CS_START_MASK			0x00000100
@@ -634,7 +641,10 @@ enum ath10k_hw_4addr_pad {
 #define GPIO_BASE_ADDRESS			WLAN_GPIO_BASE_ADDRESS
 #define GPIO_PIN0_OFFSET			WLAN_GPIO_PIN0_ADDRESS
 #define GPIO_PIN1_OFFSET			WLAN_GPIO_PIN1_ADDRESS
+#define GPIO_PIN0_CONFIG_LSB			WLAN_GPIO_PIN0_CONFIG_LSB
 #define GPIO_PIN0_CONFIG_MASK			WLAN_GPIO_PIN0_CONFIG_MASK
+#define GPIO_PIN0_PAD_PULL_LSB			WLAN_GPIO_PIN0_PAD_PULL_LSB
+#define GPIO_PIN0_PAD_PULL_MASK			WLAN_GPIO_PIN0_PAD_PULL_MASK
 #define GPIO_PIN1_CONFIG_MASK			WLAN_GPIO_PIN1_CONFIG_MASK
 #define SI_BASE_ADDRESS				WLAN_SI_BASE_ADDRESS
 #define SCRATCH_BASE_ADDRESS			SOC_CORE_BASE_ADDRESS
@@ -689,6 +699,18 @@ enum ath10k_hw_4addr_pad {
 #define WINDOW_READ_ADDR_ADDRESS		MISSING
 #define WINDOW_WRITE_ADDR_ADDRESS		MISSING
 
+#define QCA9887_1_0_I2C_SDA_GPIO_PIN		5
+#define QCA9887_1_0_I2C_SDA_PIN_CONFIG		3
+#define QCA9887_1_0_SI_CLK_GPIO_PIN		17
+#define QCA9887_1_0_SI_CLK_PIN_CONFIG		3
+#define QCA9887_1_0_GPIO_ENABLE_W1TS_LOW_ADDRESS 0x00000010
+
+#define QCA9887_EEPROM_SELECT_READ		0xa10000a0
+#define QCA9887_EEPROM_ADDR_HI_MASK		0x0000ff00
+#define QCA9887_EEPROM_ADDR_HI_LSB		8
+#define QCA9887_EEPROM_ADDR_LO_MASK		0x00ff0000
+#define QCA9887_EEPROM_ADDR_LO_LSB		16
+
 #define RTC_STATE_V_GET(x) (((x) & RTC_STATE_V_MASK) >> RTC_STATE_V_LSB)
 
 #endif /* _HW_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index b799f46..c156705 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2566,6 +2566,144 @@ static int ath10k_pci_hif_resume(struct ath10k *ar)
 }
 #endif
 
+static bool ath10k_pci_validate_cal(void *data, size_t size)
+{
+	__le16 *cal_words = data;
+	u16 checksum = 0;
+	size_t i;
+
+	if (size % 2 != 0)
+		return false;
+
+	for (i = 0; i < size / 2; i++)
+		checksum ^= le16_to_cpu(cal_words[i]);
+
+	return checksum == 0xffff;
+}
+
+static void ath10k_pci_enable_eeprom(struct ath10k *ar)
+{
+	/* Enable SI clock */
+	ath10k_pci_soc_write32(ar, CLOCK_CONTROL_OFFSET, 0x0);
+
+	/* Configure GPIOs for I2C operation */
+	ath10k_pci_write32(ar,
+			   GPIO_BASE_ADDRESS + GPIO_PIN0_OFFSET +
+			   4 * QCA9887_1_0_I2C_SDA_GPIO_PIN,
+			   SM(QCA9887_1_0_I2C_SDA_PIN_CONFIG,
+			      GPIO_PIN0_CONFIG) |
+			   SM(1, GPIO_PIN0_PAD_PULL));
+
+	ath10k_pci_write32(ar,
+			   GPIO_BASE_ADDRESS + GPIO_PIN0_OFFSET +
+			   4 * QCA9887_1_0_SI_CLK_GPIO_PIN,
+			   SM(QCA9887_1_0_SI_CLK_PIN_CONFIG, GPIO_PIN0_CONFIG) |
+			   SM(1, GPIO_PIN0_PAD_PULL));
+
+	ath10k_pci_write32(ar,
+			   GPIO_BASE_ADDRESS +
+			   QCA9887_1_0_GPIO_ENABLE_W1TS_LOW_ADDRESS,
+			   1u << QCA9887_1_0_SI_CLK_GPIO_PIN);
+
+	/* In Swift ASIC - EEPROM clock will be (110MHz/512) = 214KHz */
+	ath10k_pci_write32(ar,
+			   SI_BASE_ADDRESS + SI_CONFIG_OFFSET,
+			   SM(1, SI_CONFIG_ERR_INT) |
+			   SM(1, SI_CONFIG_BIDIR_OD_DATA) |
+			   SM(1, SI_CONFIG_I2C) |
+			   SM(1, SI_CONFIG_POS_SAMPLE) |
+			   SM(1, SI_CONFIG_INACTIVE_DATA) |
+			   SM(1, SI_CONFIG_INACTIVE_CLK) |
+			   SM(8, SI_CONFIG_DIVIDER));
+}
+
+static int ath10k_pci_read_eeprom(struct ath10k *ar, u16 addr, u8 *out)
+{
+	u32 reg;
+	int wait_limit;
+
+	/* set device select byte and for the read operation */
+	reg = QCA9887_EEPROM_SELECT_READ |
+	      SM(addr, QCA9887_EEPROM_ADDR_LO) |
+	      SM(addr >> 8, QCA9887_EEPROM_ADDR_HI);
+	ath10k_pci_write32(ar, SI_BASE_ADDRESS + SI_TX_DATA0_OFFSET, reg);
+
+	/* write transmit data, transfer length, and START bit */
+	ath10k_pci_write32(ar, SI_BASE_ADDRESS + SI_CS_OFFSET,
+			   SM(1, SI_CS_START) | SM(1, SI_CS_RX_CNT) |
+			   SM(4, SI_CS_TX_CNT));
+
+	/* wait max 1 sec */
+	wait_limit = 100000;
+
+	/* wait for SI_CS_DONE_INT */
+	do {
+		reg = ath10k_pci_read32(ar, SI_BASE_ADDRESS + SI_CS_OFFSET);
+		if (MS(reg, SI_CS_DONE_INT))
+			break;
+
+		wait_limit--;
+		udelay(10);
+	} while (wait_limit > 0);
+
+	if (!MS(reg, SI_CS_DONE_INT)) {
+		ath10k_err(ar, "timeout while reading device EEPROM at %04x\n",
+			   addr);
+		return -ETIMEDOUT;
+	}
+
+	/* clear SI_CS_DONE_INT */
+	ath10k_pci_write32(ar, SI_BASE_ADDRESS + SI_CS_OFFSET, reg);
+
+	if (MS(reg, SI_CS_DONE_ERR)) {
+		ath10k_err(ar, "failed to read device EEPROM at %04x\n", addr);
+		return -EIO;
+	}
+
+	/* extract receive data */
+	reg = ath10k_pci_read32(ar, SI_BASE_ADDRESS + SI_RX_DATA0_OFFSET);
+	*out = reg;
+
+	return 0;
+}
+
+static int ath10k_pci_fetch_target_board_data(struct ath10k *ar, void **data,
+					      size_t *data_len)
+{
+	u8 *caldata = NULL;
+	size_t calsize, i;
+	int ret;
+
+	if (!QCA_REV_9887(ar))
+		return -EOPNOTSUPP;
+
+	calsize = ar->hw_params.cal_data_len;
+	caldata = kmalloc(calsize, GFP_KERNEL);
+	if (!caldata)
+		return -ENOMEM;
+
+	ath10k_pci_enable_eeprom(ar);
+
+	for (i = 0; i < calsize; i++) {
+		ret = ath10k_pci_read_eeprom(ar, i, &caldata[i]);
+		if (ret)
+			goto err_free;
+	}
+
+	if (!ath10k_pci_validate_cal(caldata, calsize))
+		goto err_free;
+
+	*data = caldata;
+	*data_len = calsize;
+
+	return 0;
+
+err_free:
+	kfree(data);
+
+	return -EINVAL;
+}
+
 static const struct ath10k_hif_ops ath10k_pci_hif_ops = {
 	.tx_sg			= ath10k_pci_hif_tx_sg,
 	.diag_read		= ath10k_pci_hif_diag_read,
@@ -2585,6 +2723,7 @@ static const struct ath10k_hif_ops ath10k_pci_hif_ops = {
 	.suspend		= ath10k_pci_hif_suspend,
 	.resume			= ath10k_pci_hif_resume,
 #endif
+	.fetch_target_board_data = ath10k_pci_fetch_target_board_data,
 };
 
 /*
-- 
2.8.1

