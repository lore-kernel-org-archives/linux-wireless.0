Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8B7C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 04:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A940B2084C
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 04:13:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m4YkolYA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfDCEN3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 00:13:29 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43586 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfDCEN2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 00:13:28 -0400
Received: by mail-pf1-f196.google.com with SMTP id c8so7457067pfd.10
        for <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2019 21:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HPhE8A2guRdrxQFjV6raU3Kc+HLmPYaxIauGThNxw7c=;
        b=m4YkolYAAst7CDKhJVBCPYUTu8KrdjgcPQwJxBRPuKce9y71ax/c47Klq63QkBbbUW
         HebqtWXezOKMhLO/qTBHJCjHaKm6MlWGh5ZP+FCvfgWxoUs3/jRCl63hqBV0tAzEKetT
         eOGAa4MRQqb2Ebaz/qpSe8MWVu0+1g/y7Ph32kywisQ7fNPFN2op0V5ul+LujTyyiY7M
         YBgEOHFygWpayxFm/qaREAFN5ErVTxv09xlcJDDVjwuwHvarTLdRDe49rdBB5dHEhppr
         Nh2Ni9dtTLhar1HfRwJT5QYv0v9SdkQzSWxAPQHkEATgc1L4SFkc4S545GJiZ3RV5nZi
         /KiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HPhE8A2guRdrxQFjV6raU3Kc+HLmPYaxIauGThNxw7c=;
        b=rQbxYSlVR2P/XN8xump+pwTd4SkKsph03vi890gnrCEl/Mi4cyydRZwxGvyidbkg8y
         t1fw2gXGkNixo4q5jjBhI/Sq8e3A8lQifPeafOPhCdJjzBsTsXL4vHVnebUCpz/RJJ/a
         tLjw6IZvbffdAbER8u9W5CIcSNyvq+pl6J6/khp/RmJKS0VTtunJWL8XC7K0LyuOL79c
         c6D5s7EcHy9Gvf67YLxMOrkfaceU1LnjYAu44BK8/wZKqjdZaf9nit3mT+Z8CQsx+svd
         sEOxI6IMaBXC+Y9vCHT7/2szEbyemkXihlCu0EU22lkfRLhrZp6W0Wgyu/3maSSbCjfQ
         OZEw==
X-Gm-Message-State: APjAAAWXzkanM0VjAuCjLojfwyjugGLCsflY/W+AOy9d6FZjA3MKNDpF
        Ams69pjjUsj4Fis0VLgrYfo=
X-Google-Smtp-Source: APXvYqzhye1msCPsL/G3XsUUftR6e7ZvdkGsKS79akf/rA7T3/dZ4/n3r5Sx1Umgy2u2H2ETIrkKeg==
X-Received: by 2002:aa7:8609:: with SMTP id p9mr72670423pfn.166.1554264807441;
        Tue, 02 Apr 2019 21:13:27 -0700 (PDT)
Received: from siva.domain.name ([123.201.77.78])
        by smtp.gmail.com with ESMTPSA id r3sm42290239pgb.82.2019.04.02.21.13.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 21:13:26 -0700 (PDT)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        krishna.pedda@redpinesignals.com,
        Ganapathiraju Kondraju <ganapathi.kondraju@redpinesignals.com>,
        Siva Rebbagondla <siva8118@gmail.com>
Subject: [PATCH 2/8] rsi: move common part of firmware load to separate function
Date:   Wed,  3 Apr 2019 09:43:03 +0530
Message-Id: <20190403041309.12829-3-siva8118@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190403041309.12829-1-siva8118@gmail.com>
References: <20190403041309.12829-1-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Till software bootloader ready state, communication with device is common
for 9113 and 9116. Hence moved that part of firmware loading to separate
function rsi_prepare_fw_load(). Also LMAC_VER_OFFSET is different for 9113
and 9116, so renamed existing macro to LMAC_VER_OFFSET_9113

Signed-off-by: Siva Rebbagondla <siva8118@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 54 +++++++++++++++++---------
 drivers/net/wireless/rsi/rsi_hal.h     |  2 +-
 2 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 1dbaab2a96b7..b85ffb5595bc 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -829,21 +829,18 @@ static int auto_fw_upgrade(struct rsi_hw *adapter, u8 *flash_content,
 	return 0;
 }
 
-static int rsi_load_firmware(struct rsi_hw *adapter)
+static int rsi_hal_prepare_fwload(struct rsi_hw *adapter)
 {
-	struct rsi_common *common = adapter->priv;
 	struct rsi_host_intf_ops *hif_ops = adapter->host_intf_ops;
-	const struct firmware *fw_entry = NULL;
-	u32 regout_val = 0, content_size;
-	u16 tmp_regout_val = 0;
-	struct ta_metadata *metadata_p;
+	u32 regout_val = 0;
 	int status;
 
 	bl_start_cmd_timer(adapter, BL_CMD_TIMEOUT);
 
 	while (!adapter->blcmd_timer_expired) {
 		status = hif_ops->master_reg_read(adapter, SWBL_REGOUT,
-					      &regout_val, 2);
+						  &regout_val,
+						  RSI_COMMON_REG_SIZE);
 		if (status < 0) {
 			rsi_dbg(ERR_ZONE,
 				"%s: REGOUT read failed\n", __func__);
@@ -865,13 +862,26 @@ static int rsi_load_firmware(struct rsi_hw *adapter)
 		(regout_val & 0xff));
 
 	status = hif_ops->master_reg_write(adapter, SWBL_REGOUT,
-					(REGOUT_INVALID | REGOUT_INVALID << 8),
-					2);
-	if (status < 0) {
+					   (REGOUT_INVALID |
+					    REGOUT_INVALID << 8),
+					   RSI_COMMON_REG_SIZE);
+	if (status < 0)
 		rsi_dbg(ERR_ZONE, "%s: REGOUT writing failed..\n", __func__);
-		return status;
-	}
-	mdelay(1);
+	else
+		rsi_dbg(INFO_ZONE,
+			"===> Device is ready to load firmware <===\n");
+
+	return status;
+}
+
+static int rsi_load_9113_firmware(struct rsi_hw *adapter)
+{
+	struct rsi_common *common = adapter->priv;
+	const struct firmware *fw_entry = NULL;
+	u32 content_size;
+	u16 tmp_regout_val = 0;
+	struct ta_metadata *metadata_p;
+	int status;
 
 	status = bl_cmd(adapter, CONFIG_AUTO_READ_MODE, CMD_PASS,
 			"AUTO_READ_CMD");
@@ -902,13 +912,15 @@ static int rsi_load_firmware(struct rsi_hw *adapter)
 
 	/* Get the firmware version */
 	common->lmac_ver.ver.info.fw_ver[0] =
-		fw_entry->data[LMAC_VER_OFFSET] & 0xFF;
+		fw_entry->data[LMAC_VER_OFFSET_9113] & 0xFF;
 	common->lmac_ver.ver.info.fw_ver[1] =
-		fw_entry->data[LMAC_VER_OFFSET + 1] & 0xFF;
-	common->lmac_ver.major = fw_entry->data[LMAC_VER_OFFSET + 2] & 0xFF;
+		fw_entry->data[LMAC_VER_OFFSET_9113 + 1] & 0xFF;
+	common->lmac_ver.major =
+		fw_entry->data[LMAC_VER_OFFSET_9113 + 2] & 0xFF;
 	common->lmac_ver.release_num =
-		fw_entry->data[LMAC_VER_OFFSET + 3] & 0xFF;
-	common->lmac_ver.minor = fw_entry->data[LMAC_VER_OFFSET + 4] & 0xFF;
+		fw_entry->data[LMAC_VER_OFFSET_9113 + 3] & 0xFF;
+	common->lmac_ver.minor =
+		fw_entry->data[LMAC_VER_OFFSET_9113 + 4] & 0xFF;
 	common->lmac_ver.patch_num = 0;
 	rsi_print_version(common);
 
@@ -980,10 +992,14 @@ static int rsi_load_firmware(struct rsi_hw *adapter)
 int rsi_hal_device_init(struct rsi_hw *adapter)
 {
 	struct rsi_common *common = adapter->priv;
+	int status;
 
 	switch (adapter->device_model) {
 	case RSI_DEV_9113:
-		if (rsi_load_firmware(adapter)) {
+		status = rsi_hal_prepare_fwload(adapter);
+		if (status < 0)
+			return status;
+		if (rsi_load_9113_firmware(adapter)) {
 			rsi_dbg(ERR_ZONE,
 				"%s: Failed to load TA instructions\n",
 				__func__);
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
index 327638cdd30b..f6dc55625516 100644
--- a/drivers/net/wireless/rsi/rsi_hal.h
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -113,7 +113,7 @@
 #define BBP_INFO_40MHZ 0x6
 
 #define FW_FLASH_OFFSET			0x820
-#define LMAC_VER_OFFSET			(FW_FLASH_OFFSET + 0x200)
+#define LMAC_VER_OFFSET_9113		(FW_FLASH_OFFSET + 0x200)
 #define MAX_DWORD_ALIGN_BYTES		64
 #define RSI_COMMON_REG_SIZE		2
 
-- 
2.17.1

