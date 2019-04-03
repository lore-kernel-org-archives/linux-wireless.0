Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A41CC4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 04:13:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E89F2084C
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 04:13:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UiOE4ntq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfDCENb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 00:13:31 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45915 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfDCENb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 00:13:31 -0400
Received: by mail-pg1-f194.google.com with SMTP id y3so7606875pgk.12
        for <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2019 21:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wj2eiXwMKwZ5r8ecH1XVq4sJSVontJheErRiC4AACEk=;
        b=UiOE4ntqQy825lb3bIpWwBqgK16SA0QTaj3riwUb6MUyU3C85X4NNZ42KBCON/nWKv
         89eEtK/pRDDbFIoTxZlfs6DzZNdYz3Y+pEB0NDlO4EuYCdU99mMEJuWWWVyl8OCDs3c2
         XODSd3oDd3qw4KQSgetRf5y3DQgBv4AzFr2qtYuHk2tW+LTljH5pm3od0P5bOfdrvdQ8
         lLLC1Vh8p3CkYiNdZ86WPb+tRnDYlOP5u9H7S8La4+ojzFRw6heRSnUZdEjzBlCyvMc6
         wkbe7/zFIiIX7oLFXF4Hafdf9rJjg1Re8qGC2ImMNA8yqA7fzrK+/FIh8hRnvfCOvFOt
         NNPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wj2eiXwMKwZ5r8ecH1XVq4sJSVontJheErRiC4AACEk=;
        b=c2vGgJGlqB0pd6q7EOjQnCufbIvF5RDevzt99nNSA03IFJOlfc/G17NYUD73PsmJiH
         5Bjp8ELI87TO/qFWUdB+tOlU+0am9JGx3WxkHMbA11nLxwXsgbw3GZSll6+2IxOR4N38
         C4jIG4goC1+MuBsESFCzYqF40S01uJDYUJ3lacfcX0ZqKTOfUcc0lUalyl101kZ6x+p/
         hTXUr388l2Pik+QWZpmyQRLAfyKJDTMuwBysHkzKc/ir8/xCERyCGxIh0ml4vxxkTRPa
         pYovc/o++XB/Bsp5TOpJUqydgXKaNd+I+d2jVrRJxnqiQLbLVFajGhsdBl9y0nadqmEU
         b6mw==
X-Gm-Message-State: APjAAAWDn75CWGJMSWZjR+NgA+xiTXIqG71MJM1k6Kl/IlwwgMHZfNPb
        JTTqP1NLEXltRbV41stcTbC41yxqgwfgQzkv
X-Google-Smtp-Source: APXvYqzdlnCG8Q44N18Lorv3/eC3ez423Ma8JLHd6Nnbmu4kiyMOJWI2shCu7Cb2rLpd7dpWEllWWA==
X-Received: by 2002:a62:b418:: with SMTP id h24mr63733714pfn.145.1554264810020;
        Tue, 02 Apr 2019 21:13:30 -0700 (PDT)
Received: from siva.domain.name ([123.201.77.78])
        by smtp.gmail.com with ESMTPSA id r3sm42290239pgb.82.2019.04.02.21.13.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 21:13:29 -0700 (PDT)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        krishna.pedda@redpinesignals.com,
        Ganapathiraju Kondraju <ganapathi.kondraju@redpinesignals.com>,
        Siva Rebbagondla <siva8118@gmail.com>
Subject: [PATCH 3/8] rsi: add firmware loading for 9116 device
Date:   Wed,  3 Apr 2019 09:43:04 +0530
Message-Id: <20190403041309.12829-4-siva8118@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190403041309.12829-1-siva8118@gmail.com>
References: <20190403041309.12829-1-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

New firmware files and firmware loading method are added for 9116.

Signed-off-by: Siva Rebbagondla <siva8118@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c  | 145 ++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_sdio.c |  65 +++++++++++
 drivers/net/wireless/rsi/rsi_hal.h      |  27 +++++
 drivers/net/wireless/rsi/rsi_main.h     |   1 +
 drivers/net/wireless/rsi/rsi_sdio.h     |   2 +-
 5 files changed, 239 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index b85ffb5595bc..f84250bdb8cf 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -31,6 +31,13 @@ static struct ta_metadata metadata_flash_content[] = {
 
 };
 
+static struct ta_metadata metadata[] = {{"pmemdata_dummy", 0x00000000},
+	{"rsi/rs9116_wlan.rps", 0x00000000},
+	{"rsi/rs9116_wlan_bt_classic.rps", 0x00000000},
+	{"rsi/pmemdata_dummy", 0x00000000},
+	{"rsi/rs9116_wlan_bt_classic.rps", 0x00000000}
+};
+
 int rsi_send_pkt_to_bus(struct rsi_common *common, struct sk_buff *skb)
 {
 	struct rsi_hw *adapter = common->priv;
@@ -989,6 +996,133 @@ static int rsi_load_9113_firmware(struct rsi_hw *adapter)
 	return status;
 }
 
+static int rsi_load_9116_firmware(struct rsi_hw *adapter)
+{
+	struct rsi_common *common = adapter->priv;
+	struct rsi_host_intf_ops *hif_ops = adapter->host_intf_ops;
+	const struct firmware *fw_entry;
+	struct ta_metadata *metadata_p;
+	u8 *ta_firmware, *fw_p;
+	struct bootload_ds bootload_ds;
+	u32 instructions_sz, base_address;
+	u16 block_size = adapter->block_size;
+	u32 dest, len;
+	int status, cnt;
+
+	rsi_dbg(INIT_ZONE, "***** Load 9116 TA Instructions *****\n");
+
+	if (adapter->rsi_host_intf == RSI_HOST_INTF_USB) {
+		status = bl_cmd(adapter, POLLING_MODE, CMD_PASS,
+				"POLLING_MODE");
+		if (status < 0)
+			return status;
+	}
+
+	status = hif_ops->master_reg_write(adapter, MEM_ACCESS_CTRL_FROM_HOST,
+					   RAM_384K_ACCESS_FROM_TA,
+					   RSI_9116_REG_SIZE);
+	if (status < 0) {
+		rsi_dbg(ERR_ZONE, "%s: Unable to access full RAM memory\n",
+			__func__);
+		return status;
+	}
+
+	metadata_p = &metadata[adapter->priv->coex_mode];
+	rsi_dbg(INIT_ZONE, "%s: loading file %s\n", __func__, metadata_p->name);
+	status = request_firmware(&fw_entry, metadata_p->name, adapter->device);
+	if (status < 0) {
+		rsi_dbg(ERR_ZONE, "%s: Failed to open file %s\n",
+			__func__, metadata_p->name);
+		return status;
+	}
+
+	ta_firmware = kmemdup(fw_entry->data, fw_entry->size, GFP_KERNEL);
+	if (!ta_firmware)
+		goto fail_release_fw;
+	fw_p = ta_firmware;
+	instructions_sz = fw_entry->size;
+	rsi_dbg(INFO_ZONE, "FW Length = %d bytes\n", instructions_sz);
+
+	common->lmac_ver.major = ta_firmware[LMAC_VER_OFFSET_9116];
+	common->lmac_ver.minor = ta_firmware[LMAC_VER_OFFSET_9116 + 1];
+	common->lmac_ver.release_num = ta_firmware[LMAC_VER_OFFSET_9116 + 2];
+	common->lmac_ver.patch_num = ta_firmware[LMAC_VER_OFFSET_9116 + 3];
+	common->lmac_ver.ver.info.fw_ver[0] =
+		ta_firmware[LMAC_VER_OFFSET_9116 + 4];
+
+	if (instructions_sz % FW_ALIGN_SIZE)
+		instructions_sz +=
+			(FW_ALIGN_SIZE - (instructions_sz % FW_ALIGN_SIZE));
+	rsi_dbg(INFO_ZONE, "instructions_sz : %d\n", instructions_sz);
+
+	if (*(u16 *)fw_p == RSI_9116_FW_MAGIC_WORD) {
+		memcpy(&bootload_ds, fw_p, sizeof(struct bootload_ds));
+		fw_p += le16_to_cpu(bootload_ds.offset);
+		rsi_dbg(INFO_ZONE, "FW start = %x\n", *(u32 *)fw_p);
+
+		cnt = 0;
+		do {
+			rsi_dbg(ERR_ZONE, "%s: Loading chunk %d\n",
+				__func__, cnt);
+
+			dest = le32_to_cpu(bootload_ds.bl_entry[cnt].dst_addr);
+			len = le32_to_cpu(bootload_ds.bl_entry[cnt].control) &
+			      RSI_BL_CTRL_LEN_MASK;
+			rsi_dbg(INFO_ZONE, "length %d destination %x\n",
+				len, dest);
+
+			status = hif_ops->load_data_master_write(adapter, dest,
+								 len,
+								 block_size,
+								 fw_p);
+			if (status < 0) {
+				rsi_dbg(ERR_ZONE,
+					"Failed to load chunk %d\n", cnt);
+				break;
+			}
+			fw_p += len;
+			if (le32_to_cpu(bootload_ds.bl_entry[cnt].control) &
+			    RSI_BL_CTRL_LAST_ENTRY)
+				break;
+			cnt++;
+		} while (1);
+	} else {
+		base_address = metadata_p->address;
+		status = hif_ops->load_data_master_write(adapter,
+							 base_address,
+							 instructions_sz,
+							 block_size,
+							 ta_firmware);
+	}
+	if (status) {
+		rsi_dbg(ERR_ZONE,
+			"%s: Unable to load %s blk\n",
+			__func__, metadata_p->name);
+		goto fail_free_fw;
+	}
+
+	rsi_dbg(INIT_ZONE, "%s: Successfully loaded %s instructions\n",
+		__func__, metadata_p->name);
+
+	if (adapter->rsi_host_intf == RSI_HOST_INTF_SDIO) {
+		if (hif_ops->ta_reset(adapter))
+			rsi_dbg(ERR_ZONE, "Unable to put ta in reset\n");
+	} else {
+		if (bl_cmd(adapter, JUMP_TO_ZERO_PC,
+			   CMD_PASS, "JUMP_TO_ZERO") < 0)
+			rsi_dbg(INFO_ZONE, "Jump to zero command failed\n");
+		else
+			rsi_dbg(INFO_ZONE, "Jump to zero command successful\n");
+	}
+
+fail_free_fw:
+	kfree(ta_firmware);
+fail_release_fw:
+	release_firmware(fw_entry);
+
+	return status;
+}
+
 int rsi_hal_device_init(struct rsi_hw *adapter)
 {
 	struct rsi_common *common = adapter->priv;
@@ -1006,6 +1140,17 @@ int rsi_hal_device_init(struct rsi_hw *adapter)
 			return -EINVAL;
 		}
 		break;
+	case RSI_DEV_9116:
+		status = rsi_hal_prepare_fwload(adapter);
+		if (status < 0)
+			return status;
+		if (rsi_load_9116_firmware(adapter)) {
+			rsi_dbg(ERR_ZONE,
+				"%s: Failed to load firmware to 9116 device\n",
+				__func__);
+			return -EINVAL;
+		}
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 2f4bc25d93ca..e9a2af0a1a80 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -923,6 +923,70 @@ static int rsi_sdio_reinit_device(struct rsi_hw *adapter)
 	return 0;
 }
 
+static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
+{
+	int status;
+	u32 addr;
+	u8 *data;
+
+	status = rsi_sdio_master_access_msword(adapter, TA_BASE_ADDR);
+	if (status < 0) {
+		rsi_dbg(ERR_ZONE,
+			"Unable to set ms word to common reg\n");
+		return status;
+	}
+
+	rsi_dbg(INIT_ZONE, "%s: Bring TA out of reset\n", __func__);
+	put_unaligned_le32(TA_HOLD_THREAD_VALUE, data);
+	addr = TA_HOLD_THREAD_REG | RSI_SD_REQUEST_MASTER;
+	status = rsi_sdio_write_register_multiple(adapter, addr,
+						  (u8 *)&data,
+						  RSI_9116_REG_SIZE);
+	if (status < 0) {
+		rsi_dbg(ERR_ZONE, "Unable to hold TA threads\n");
+		return status;
+	}
+
+	put_unaligned_le32(TA_SOFT_RST_CLR, data);
+	addr = TA_SOFT_RESET_REG | RSI_SD_REQUEST_MASTER;
+	status = rsi_sdio_write_register_multiple(adapter, addr,
+						  (u8 *)&data,
+						  RSI_9116_REG_SIZE);
+	if (status < 0) {
+		rsi_dbg(ERR_ZONE, "Unable to get TA out of reset\n");
+		return status;
+	}
+
+	put_unaligned_le32(TA_PC_ZERO, data);
+	addr = TA_TH0_PC_REG | RSI_SD_REQUEST_MASTER;
+	status = rsi_sdio_write_register_multiple(adapter, addr,
+						  (u8 *)&data,
+						  RSI_9116_REG_SIZE);
+	if (status < 0) {
+		rsi_dbg(ERR_ZONE, "Unable to Reset TA PC value\n");
+		return -EINVAL;
+	}
+
+	put_unaligned_le32(TA_RELEASE_THREAD_VALUE, data);
+	addr = TA_RELEASE_THREAD_REG | RSI_SD_REQUEST_MASTER;
+	status = rsi_sdio_write_register_multiple(adapter, addr,
+						  (u8 *)&data,
+						  RSI_9116_REG_SIZE);
+	if (status < 0) {
+		rsi_dbg(ERR_ZONE, "Unable to release TA threads\n");
+		return status;
+	}
+
+	status = rsi_sdio_master_access_msword(adapter, MISC_CFG_BASE_ADDR);
+	if (status < 0) {
+		rsi_dbg(ERR_ZONE, "Unable to set ms word to common reg\n");
+		return status;
+	}
+	rsi_dbg(INIT_ZONE, "***** TA Reset done *****\n");
+
+	return 0;
+}
+
 static struct rsi_host_intf_ops sdio_host_intf_ops = {
 	.write_pkt		= rsi_sdio_host_intf_write_pkt,
 	.read_pkt		= rsi_sdio_host_intf_read_pkt,
@@ -933,6 +997,7 @@ static struct rsi_host_intf_ops sdio_host_intf_ops = {
 	.master_reg_write	= rsi_sdio_master_reg_write,
 	.load_data_master_write	= rsi_sdio_load_data_master_write,
 	.reinit_device          = rsi_sdio_reinit_device,
+	.ta_reset		= rsi_sdio_ta_reset,
 };
 
 /**
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
index f6dc55625516..c07b1a006d3f 100644
--- a/drivers/net/wireless/rsi/rsi_hal.h
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -114,8 +114,17 @@
 
 #define FW_FLASH_OFFSET			0x820
 #define LMAC_VER_OFFSET_9113		(FW_FLASH_OFFSET + 0x200)
+#define LMAC_VER_OFFSET_9116		0x22C2
 #define MAX_DWORD_ALIGN_BYTES		64
 #define RSI_COMMON_REG_SIZE		2
+#define RSI_9116_REG_SIZE		4
+#define FW_ALIGN_SIZE			4
+#define RSI_9116_FW_MAGIC_WORD		0x5aa5
+
+#define MEM_ACCESS_CTRL_FROM_HOST	0x41300000
+#define RAM_384K_ACCESS_FROM_TA		(BIT(2) | BIT(3) | BIT(4) | BIT(5) | \
+					 BIT(20) | BIT(21) | BIT(22) | \
+					 BIT(23) | BIT(24) | BIT(25))
 
 struct bl_header {
 	__le32 flags;
@@ -130,6 +139,24 @@ struct ta_metadata {
 	unsigned int address;
 };
 
+#define RSI_BL_CTRL_LEN_MASK			0xFFFFFF
+#define RSI_BL_CTRL_SPI_32BIT_MODE		BIT(27)
+#define RSI_BL_CTRL_REL_TA_SOFTRESET		BIT(28)
+#define RSI_BL_CTRL_START_FROM_ROM_PC		BIT(29)
+#define RSI_BL_CTRL_SPI_8BIT_MODE		BIT(30)
+#define RSI_BL_CTRL_LAST_ENTRY			BIT(31)
+struct bootload_entry {
+	__le32 control;
+	__le32 dst_addr;
+} __packed;
+
+struct bootload_ds {
+	__le16 fixed_pattern;
+	__le16 offset;
+	__le32 reserved;
+	struct bootload_entry bl_entry[7];
+} __packed;
+
 struct rsi_mgmt_desc {
 	__le16 len_qno;
 	u8 frame_type;
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 077cc97dbe6f..e35c6e5151c3 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -385,6 +385,7 @@ struct rsi_host_intf_ops {
 				      u32 instructions_size, u16 block_size,
 				      u8 *fw);
 	int (*reinit_device)(struct rsi_hw *adapter);
+	int (*ta_reset)(struct rsi_hw *adapter);
 };
 
 enum rsi_host_intf rsi_get_host_intf(void *priv);
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index 838e929f7235..c5cfb6238f73 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -92,7 +92,7 @@ enum sdio_interrupt_type {
 #define TA_SOFT_RST_SET              BIT(0)
 #define TA_PC_ZERO                   0
 #define TA_HOLD_THREAD_VALUE         0xF
-#define TA_RELEASE_THREAD_VALUE      cpu_to_le32(0xF)
+#define TA_RELEASE_THREAD_VALUE      0xF
 #define TA_BASE_ADDR                 0x2200
 #define MISC_CFG_BASE_ADDR           0x4105
 
-- 
2.17.1

