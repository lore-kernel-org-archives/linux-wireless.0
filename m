Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33755 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754895AbdDGKwF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 06:52:05 -0400
Received: by mail-pg0-f66.google.com with SMTP id 79so14789018pgf.0
        for <linux-wireless@vger.kernel.org>; Fri, 07 Apr 2017 03:52:05 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH v2 4/4] mwifiex: pcie: extract wifi part from combo firmware during function level reset
Date: Fri,  7 Apr 2017 10:51:25 +0000
Message-Id: <1491562285-29818-4-git-send-email-huxinming820@gmail.com> (sfid-20170407_125409_565530_4D83DF60)
In-Reply-To: <1491562285-29818-1-git-send-email-huxinming820@gmail.com>
References: <1491562285-29818-1-git-send-email-huxinming820@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

A seperate wifi-only firmware was download during pcie function level reset.
It is in fact the tail part of wifi/bt combo firmware. Per Brian's and
Dmitry's suggestion, this patch extract the wifi part from combo firmware.

After that, we can discard the redudant image in linux-firmware repo.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
v2: extract wifi part from combo firmware(Dimtry and Brain)
    add more description(Kalle)
---
 drivers/net/wireless/marvell/mwifiex/fw.h   | 18 +++++++
 drivers/net/wireless/marvell/mwifiex/pcie.c | 83 ++++++++++++++++++++++++++---
 drivers/net/wireless/marvell/mwifiex/pcie.h |  2 +
 3 files changed, 96 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 0b68374..6cf9ab9 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -43,6 +43,24 @@ struct tx_packet_hdr {
 	struct rfc_1042_hdr rfc1042_hdr;
 } __packed;
 
+struct mwifiex_fw_header {
+	__le32 dnld_cmd;
+	__le32 base_addr;
+	__le32 data_length;
+	__le32 crc;
+} __packed;
+
+struct mwifiex_fw_data {
+	struct mwifiex_fw_header header;
+	__le32 seq_num;
+	u8 data[1];
+} __packed;
+
+#define MWIFIEX_FW_DNLD_CMD_1 0x1
+#define MWIFIEX_FW_DNLD_CMD_5 0x5
+#define MWIFIEX_FW_DNLD_CMD_6 0x6
+#define MWIFIEX_FW_DNLD_CMD_7 0x7
+
 #define B_SUPPORTED_RATES               5
 #define G_SUPPORTED_RATES               9
 #define BG_SUPPORTED_RATES              13
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index a07cb0a..ebf00d9 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -1956,6 +1956,63 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 	return ret;
 }
 
+/* Extract wifi part from wifi-bt combo firmware image.
+ */
+
+static int mwifiex_extract_wifi_fw(struct mwifiex_adapter *adapter,
+				   u8 *firmware, u32 firmware_len) {
+	struct mwifiex_fw_data fwdata;
+	u32 offset = 0, data_len, dnld_cmd;
+	int ret = 0;
+	bool cmd7_before = false;
+
+	while (1) {
+		if (offset + sizeof(fwdata.header) >= firmware_len) {
+			mwifiex_dbg(adapter, ERROR,
+				    "extract wifi-only firmware failure!");
+			ret = -1;
+			goto done;
+		}
+
+		memcpy(&fwdata.header, firmware + offset,
+		       sizeof(fwdata.header));
+		dnld_cmd = le32_to_cpu(fwdata.header.dnld_cmd);
+		data_len = le32_to_cpu(fwdata.header.data_length);
+
+		switch (dnld_cmd) {
+		case MWIFIEX_FW_DNLD_CMD_1:
+			if (!cmd7_before) {
+				mwifiex_dbg(adapter, ERROR,
+					    "no cmd7 before cmd1!");
+				ret = -1;
+				goto done;
+			}
+			offset += data_len + sizeof(fwdata.header);
+			break;
+		case MWIFIEX_FW_DNLD_CMD_5:
+			offset += data_len + sizeof(fwdata.header);
+			break;
+		case MWIFIEX_FW_DNLD_CMD_6:
+			offset += data_len + sizeof(fwdata.header);
+			ret = offset;
+			goto done;
+		case MWIFIEX_FW_DNLD_CMD_7:
+			if (!cmd7_before)
+				cmd7_before = true;
+			offset += sizeof(fwdata.header);
+			break;
+		default:
+			mwifiex_dbg(adapter, ERROR, "unknown dnld_cmd %d\n",
+				    dnld_cmd);
+			ret = -1;
+			goto done;
+		}
+	}
+
+done:
+	return ret;
+}
+
 /*
  * This function downloads the firmware to the card.
  *
@@ -1971,7 +2028,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 	u32 firmware_len = fw->fw_len;
 	u32 offset = 0;
 	struct sk_buff *skb;
-	u32 txlen, tx_blocks = 0, tries, len;
+	u32 txlen, tx_blocks = 0, tries, len, val;
 	u32 block_retry_cnt = 0;
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
@@ -1998,6 +2055,24 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 		goto done;
 	}
 
+	ret = mwifiex_read_reg(adapter, PCIE_SCRATCH_13_REG, &val);
+	if (ret) {
+		mwifiex_dbg(adapter, FATAL, "Failed to read scratch register 13\n");
+		goto done;
+	}
+
+	/* PCIE FLR case: extract wifi part from combo firmware*/
+	if (val == MWIFIEX_PCIE_FLR_HAPPENS) {
+		ret = mwifiex_extract_wifi_fw(adapter, firmware, firmware_len);
+		if (ret < 0) {
+			mwifiex_dbg(adapter, ERROR, "Failed to extract wifi fw\n");
+			goto done;
+		}
+		offset = ret;
+		mwifiex_dbg(adapter, MSG,
+			    "info: dnld wifi firmware from %d bytes\n", offset);
+	}
+
 	/* Perform firmware data transfer */
 	do {
 		u32 ireg_intr = 0;
@@ -3060,12 +3135,6 @@ static void mwifiex_pcie_up_dev(struct mwifiex_adapter *adapter)
 	struct pci_dev *pdev = card->dev;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
-	/* Bluetooth is not on pcie interface. Download Wifi only firmware
-	 * during pcie FLR, so that bluetooth part of firmware which is
-	 * already running doesn't get affected.
-	 */
-	strcpy(adapter->fw_name, PCIE8997_DEFAULT_WIFIFW_NAME);
-
 	/* tx_buf_size might be changed to 3584 by firmware during
 	 * data transfer, we should reset it to default size.
 	 */
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index 6ac7dcb..5bbadf7 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -120,6 +120,8 @@
 #define MWIFIEX_SLEEP_COOKIE_SIZE			4
 #define MWIFIEX_MAX_DELAY_COUNT				100
 
+#define MWIFIEX_PCIE_FLR_HAPPENS 0xFEDCBABA
+
 struct mwifiex_pcie_card_reg {
 	u16 cmd_addr_lo;
 	u16 cmd_addr_hi;
-- 
1.8.1.4
