Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:35268 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755416AbdDMUKh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 16:10:37 -0400
Received: by mail-pf0-f180.google.com with SMTP id i5so32949842pfc.2
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 13:10:37 -0700 (PDT)
Date: Thu, 13 Apr 2017 13:10:33 -0700
From: Brian Norris <briannorris@chromium.org>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH v5 4/4] mwifiex: pcie: extract wifi part from combo firmware
 during function level reset
Message-ID: <20170413201032.GA91869@google.com> (sfid-20170413_221042_555509_5FAFE408)
References: <1492066102-31251-1-git-send-email-huxinming820@gmail.com>
 <1492066102-31251-4-git-send-email-huxinming820@gmail.com>
 <20170413184629.GB66124@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170413184629.GB66124@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

A separate wifi-only firmware was download during pcie function level
reset. It is in fact the tail part of wifi/bt combo firmware. Per
Brian's and Dmitry's suggestion, this patch extract the wifi part from
combo firmware.

After that, the mrvl/pcie8997_wlan_v4.bin image in linux-firmware repo
is redundant (though I guess we keep it around to support older
kernels).

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
On Thu, Apr 13, 2017 at 11:46:30AM -0700, Brian Norris wrote:
> I might just rewrite this and send it myself, if I get the time.

Done.

v2: extract wifi part from combo firmware(Dmitry and Brian)
    add more description(Kalle)
v3: same as v2
v4: add sequence comments, code enhance(Brian)
v5: (Brian) fix overflow errors
    (Brian) add missing newline chars
    (Brian) consolidate header-skipping logic

Note: I only resubmitted the 4th patch, as the others look fine
---
 drivers/net/wireless/marvell/mwifiex/fw.h   |  18 +++++
 drivers/net/wireless/marvell/mwifiex/pcie.c | 114 ++++++++++++++++++++++++++--
 drivers/net/wireless/marvell/mwifiex/pcie.h |   3 +-
 3 files changed, 127 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 0b683742e30c..6cf9ab9133ea 100644
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
index 061223149bed..63102efb388e 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -1956,6 +1956,94 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 	return ret;
 }
 
+/* Combo firmware image is a combination of
+ * (1) combo crc heaer, start with CMD5
+ * (2) bluetooth image, start with CMD7, end with CMD6, data wrapped in CMD1.
+ * (3) wifi image.
+ *
+ * This function bypass the header and bluetooth part, return
+ * the offset of tail wifi-only part.
+ */
+
+static int mwifiex_extract_wifi_fw(struct mwifiex_adapter *adapter,
+				   const void *firmware, u32 firmware_len) {
+	const struct mwifiex_fw_data *fwdata;
+	u32 offset = 0, data_len, dnld_cmd;
+	int ret = 0;
+	bool cmd7_before = false;
+
+	while (1) {
+		/* Check for integer and buffer overflow */
+		if (offset + sizeof(fwdata->header) < sizeof(fwdata->header) ||
+		    offset + sizeof(fwdata->header) >= firmware_len) {
+			mwifiex_dbg(adapter, ERROR,
+				    "extract wifi-only fw failure!\n");
+			ret = -1;
+			goto done;
+		}
+
+		fwdata = firmware + offset;
+		dnld_cmd = le32_to_cpu(fwdata->header.dnld_cmd);
+		data_len = le32_to_cpu(fwdata->header.data_length);
+
+		/* Skip past header */
+		offset += sizeof(fwdata->header);
+
+		switch (dnld_cmd) {
+		case MWIFIEX_FW_DNLD_CMD_1:
+			if (!cmd7_before) {
+				mwifiex_dbg(adapter, ERROR,
+					    "no cmd7 before cmd1!\n");
+				ret = -1;
+				goto done;
+			}
+			if (offset + data_len < data_len) {
+				mwifiex_dbg(adapter, ERROR, "bad FW parse\n");
+				ret = -1;
+				goto done;
+			}
+			offset += data_len;
+			break;
+		case MWIFIEX_FW_DNLD_CMD_5:
+			/* Check for integer overflow */
+			if (offset + data_len < data_len) {
+				mwifiex_dbg(adapter, ERROR, "bad FW parse\n");
+				ret = -1;
+				goto done;
+			}
+			offset += data_len;
+			break;
+		case MWIFIEX_FW_DNLD_CMD_6:
+			/* Check for integer overflow */
+			if (offset + data_len < data_len) {
+				mwifiex_dbg(adapter, ERROR, "bad FW parse\n");
+				ret = -1;
+				goto done;
+			}
+			offset += data_len;
+			if (offset >= firmware_len) {
+				mwifiex_dbg(adapter, ERROR,
+					    "extract wifi-only fw failure!\n");
+				ret = -1;
+			} else {
+				ret = offset;
+			}
+			goto done;
+		case MWIFIEX_FW_DNLD_CMD_7:
+			cmd7_before = true;
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
@@ -1971,7 +2059,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 	u32 firmware_len = fw->fw_len;
 	u32 offset = 0;
 	struct sk_buff *skb;
-	u32 txlen, tx_blocks = 0, tries, len;
+	u32 txlen, tx_blocks = 0, tries, len, val;
 	u32 block_retry_cnt = 0;
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
@@ -1998,6 +2086,24 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
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
@@ -3070,12 +3176,6 @@ static void mwifiex_pcie_up_dev(struct mwifiex_adapter *adapter)
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
index 7e2450ce79d3..f7ce9b6db6b4 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -35,7 +35,6 @@
 #define PCIE8897_B0_FW_NAME "mrvl/pcie8897_uapsta.bin"
 #define PCIEUART8997_FW_NAME_V4 "mrvl/pcieuart8997_combo_v4.bin"
 #define PCIEUSB8997_FW_NAME_V4 "mrvl/pcieusb8997_combo_v4.bin"
-#define PCIE8997_DEFAULT_WIFIFW_NAME "mrvl/pcie8997_wlan_v4.bin"
 
 #define PCIE_VENDOR_ID_MARVELL              (0x11ab)
 #define PCIE_VENDOR_ID_V2_MARVELL           (0x1b4b)
@@ -120,6 +119,8 @@
 #define MWIFIEX_SLEEP_COOKIE_SIZE			4
 #define MWIFIEX_MAX_DELAY_COUNT				100
 
+#define MWIFIEX_PCIE_FLR_HAPPENS 0xFEDCBABA
+
 struct mwifiex_pcie_card_reg {
 	u16 cmd_addr_lo;
 	u16 cmd_addr_hi;
-- 
2.12.2.762
