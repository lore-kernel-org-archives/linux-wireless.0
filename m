Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4528CC4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 04:13:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2F382084C
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 04:13:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vP6GfB7H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfDCENh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 00:13:37 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46996 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbfDCENg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 00:13:36 -0400
Received: by mail-pf1-f194.google.com with SMTP id 9so7449372pfj.13
        for <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2019 21:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oY8/HVKZlQpTBMN8dcCvzadzHg0JCjUfvh/DXbf1Hq4=;
        b=vP6GfB7HZ77N62WOLx3DqTtAXByjKP3b76FMEQ+b1JvloXl19gJ7myC9oIQamIyVT/
         //IuxD2tS7b1sYtWH3onvlN+fP30DYdTYAuN9RSNM9vuCN8JAt+F8FpUv4EzaI4HWCRi
         +9SyGbvnhO9Rmghxn/vi6SNNjGHC3xlqLJyi4+f4IROPDDsn+UwlpMgfhOoHlyJYnZNN
         bkpIdVfiaQlIlgVFGRGLkrFlc9qd42p7McTcN1OUzsDD4QJ7Y/8IPqXnrXqe+byK487m
         59JjfDzI94BWM4TEwlL8IQooQihB2cFXD+xy0L9ywCZTzl7yLUoNxTLs/Hq/Q/82Hpff
         o1zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oY8/HVKZlQpTBMN8dcCvzadzHg0JCjUfvh/DXbf1Hq4=;
        b=L0G+qBU/t5b9+SINwX5U6L9JyHQw0acjBIAId9+mruvRPa/3mr40/xX2atJ99HQwK8
         MAFrQOaWzwizHoc59npCKKsqlvAc8LJRKL+VAWKLHGaIpPoYwEFD2YRIuKcjDN4wlHs1
         e7Eej7ZTjizyJpLuj6EfZsYP+CMUZwLXktQRX5TZsWc+Xmn3pHW8pu/X7garr2gzW6G5
         aS14YEbeRJSRAHkotDoynGwtuv9dgbgYzGdoEMoE+jwIlL+21MMhy7at+milgOh/OCYB
         HFpEMRe88kWPNIqT3xrc4JpRNm5C2VD5W39P4P+24Sskjjyxi6Ag+Q6t6dqyDAULKKHj
         ntMA==
X-Gm-Message-State: APjAAAWOf5fSsfNpeqIJ7gGumb0nxTy4198SVMyqcxnCkVqSNj2j/qEN
        IUycAnPMCqS17ZoH0H0jFYgeWTxA8QEhUmu2
X-Google-Smtp-Source: APXvYqwACwX1i+oR61esaKnZ+Q4e+9dfTcTSOCAXGmfKz0aGnvOqPgess6/9V1Gn1613mQPYUiaEwQ==
X-Received: by 2002:a63:c34a:: with SMTP id e10mr69756512pgd.194.1554264815203;
        Tue, 02 Apr 2019 21:13:35 -0700 (PDT)
Received: from siva.domain.name ([123.201.77.78])
        by smtp.gmail.com with ESMTPSA id r3sm42290239pgb.82.2019.04.02.21.13.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 21:13:34 -0700 (PDT)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        krishna.pedda@redpinesignals.com,
        Ganapathiraju Kondraju <ganapathi.kondraju@redpinesignals.com>,
        Siva Rebbagondla <siva8118@gmail.com>
Subject: [PATCH 5/8] rsi: new bootup parameters for 9116
Date:   Wed,  3 Apr 2019 09:43:06 +0530
Message-Id: <20190403041309.12829-6-siva8118@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190403041309.12829-1-siva8118@gmail.com>
References: <20190403041309.12829-1-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Bootup parameters are different for 9116 device. Check added for device
model where-ever bootup parameters are being send.

Signed-off-by: Siva Rebbagondla <siva8118@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c    | 112 ++++++++++++++++++++-
 drivers/net/wireless/rsi/rsi_boot_params.h |  63 ++++++++++++
 drivers/net/wireless/rsi/rsi_mgmt.h        |   9 ++
 3 files changed, 181 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 9eb60a5501a2..d4d833c3e782 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -209,6 +209,59 @@ static struct bootup_params boot_params_40 = {
 	.beacon_resedue_alg_en = 0,
 };
 
+static struct bootup_params_9116 boot_params_9116_20 = {
+	.magic_number = cpu_to_le16(LOADED_TOKEN),
+	.valid = cpu_to_le32(VALID_20),
+	.device_clk_info_9116 = {{
+		.pll_config_9116_g = {
+			.pll_ctrl_set_reg = cpu_to_le16(0xd518),
+			.pll_ctrl_clr_reg = cpu_to_le16(0x2ae7),
+			.pll_modem_conig_reg = cpu_to_le16(0x2000),
+			.soc_clk_config_reg = cpu_to_le16(0x0c18),
+			.adc_dac_strm1_config_reg = cpu_to_le16(0x1100),
+			.adc_dac_strm2_config_reg = cpu_to_le16(0x6600),
+		},
+		.switch_clk_9116_g = {
+			.switch_clk_info =
+				cpu_to_le32((RSI_SWITCH_TASS_CLK |
+					    RSI_SWITCH_WLAN_BBP_LMAC_CLK_REG |
+					    RSI_SWITCH_BBP_LMAC_CLK_REG)),
+			.tass_clock_reg = cpu_to_le32(0x083C0503),
+			.wlan_bbp_lmac_clk_reg_val = cpu_to_le32(0x01042001),
+			.zbbt_bbp_lmac_clk_reg_val = cpu_to_le32(0x02010001),
+			.bbp_lmac_clk_en_val = cpu_to_le32(0x0000003b),
+		}
+	},
+	},
+};
+
+static struct bootup_params_9116 boot_params_9116_40 = {
+	.magic_number = cpu_to_le16(LOADED_TOKEN),
+	.valid = cpu_to_le32(VALID_40),
+	.device_clk_info_9116 = {{
+		.pll_config_9116_g = {
+			.pll_ctrl_set_reg = cpu_to_le16(0xd518),
+			.pll_ctrl_clr_reg = cpu_to_le16(0x2ae7),
+			.pll_modem_conig_reg = cpu_to_le16(0x3000),
+			.soc_clk_config_reg = cpu_to_le16(0x0c18),
+			.adc_dac_strm1_config_reg = cpu_to_le16(0x0000),
+			.adc_dac_strm2_config_reg = cpu_to_le16(0x6600),
+		},
+		.switch_clk_9116_g = {
+			.switch_clk_info =
+				cpu_to_le32((RSI_SWITCH_TASS_CLK |
+					    RSI_SWITCH_WLAN_BBP_LMAC_CLK_REG |
+					    RSI_SWITCH_BBP_LMAC_CLK_REG |
+					    RSI_MODEM_CLK_160MHZ)),
+			.tass_clock_reg = cpu_to_le32(0x083C0503),
+			.wlan_bbp_lmac_clk_reg_val = cpu_to_le32(0x01042002),
+			.zbbt_bbp_lmac_clk_reg_val = cpu_to_le32(0x04010002),
+			.bbp_lmac_clk_en_val = cpu_to_le32(0x0000003b),
+		}
+	},
+	},
+};
+
 static u16 mcs[] = {13, 26, 39, 52, 78, 104, 117, 130};
 
 /**
@@ -893,6 +946,50 @@ static int rsi_load_bootup_params(struct rsi_common *common)
 	return rsi_send_internal_mgmt_frame(common, skb);
 }
 
+static int rsi_load_9116_bootup_params(struct rsi_common *common)
+{
+	struct sk_buff *skb;
+	struct rsi_boot_params_9116 *boot_params;
+
+	rsi_dbg(MGMT_TX_ZONE, "%s: Sending boot params frame\n", __func__);
+
+	skb = dev_alloc_skb(sizeof(struct rsi_boot_params_9116));
+	if (!skb)
+		return -ENOMEM;
+	memset(skb->data, 0, sizeof(struct rsi_boot_params));
+	boot_params = (struct rsi_boot_params_9116 *)skb->data;
+
+	if (common->channel_width == BW_40MHZ) {
+		memcpy(&boot_params->bootup_params,
+		       &boot_params_9116_40,
+		       sizeof(struct bootup_params_9116));
+		rsi_dbg(MGMT_TX_ZONE, "%s: Packet 40MHZ <=== %d\n", __func__,
+			UMAC_CLK_40BW);
+		boot_params->umac_clk = cpu_to_le16(UMAC_CLK_40BW);
+	} else {
+		memcpy(&boot_params->bootup_params,
+		       &boot_params_9116_20,
+		       sizeof(struct bootup_params_9116));
+		if (boot_params_20.valid != cpu_to_le32(VALID_20)) {
+			boot_params->umac_clk = cpu_to_le16(UMAC_CLK_20BW);
+			rsi_dbg(MGMT_TX_ZONE,
+				"%s: Packet 20MHZ <=== %d\n", __func__,
+				UMAC_CLK_20BW);
+		} else {
+			boot_params->umac_clk = cpu_to_le16(UMAC_CLK_40MHZ);
+			rsi_dbg(MGMT_TX_ZONE,
+				"%s: Packet 20MHZ <=== %d\n", __func__,
+				UMAC_CLK_40MHZ);
+		}
+	}
+	rsi_set_len_qno(&boot_params->desc_dword0.len_qno,
+			sizeof(struct bootup_params_9116), RSI_WIFI_MGMT_Q);
+	boot_params->desc_dword0.frame_type = BOOTUP_PARAMS_REQUEST;
+	skb_put(skb, sizeof(struct rsi_boot_params_9116));
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
 /**
  * rsi_send_reset_mac() - This function prepares reset MAC request and sends an
  *			  internal management frame to indicate it to firmware.
@@ -971,7 +1068,10 @@ int rsi_band_check(struct rsi_common *common,
 	}
 
 	if (common->channel_width != prev_bw) {
-		status = rsi_load_bootup_params(common);
+		if (adapter->device_model == RSI_DEV_9116)
+			status = rsi_load_9116_bootup_params(common);
+		else
+			status = rsi_load_bootup_params(common);
 		if (status)
 			return status;
 
@@ -1936,6 +2036,8 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 
 int rsi_handle_card_ready(struct rsi_common *common, u8 *msg)
 {
+	int status;
+
 	switch (common->fsm_state) {
 	case FSM_CARD_NOT_READY:
 		rsi_dbg(INIT_ZONE, "Card ready indication from Common HAL\n");
@@ -1963,9 +2065,13 @@ int rsi_handle_card_ready(struct rsi_common *common, u8 *msg)
 		rsi_dbg(INFO_ZONE, "USB buffer status register = %x\n",
 			common->priv->usb_buffer_status_reg);
 
-		if (rsi_load_bootup_params(common)) {
+		if (common->priv->device_model == RSI_DEV_9116)
+			status = rsi_load_9116_bootup_params(common);
+		else
+			status = rsi_load_bootup_params(common);
+		if (status < 0) {
 			common->fsm_state = FSM_CARD_NOT_READY;
-			return -EINVAL;
+			return status;
 		}
 		common->fsm_state = FSM_BOOT_PARAMS_SENT;
 		break;
diff --git a/drivers/net/wireless/rsi/rsi_boot_params.h b/drivers/net/wireless/rsi/rsi_boot_params.h
index ad903b22440e..c1cf19d1e376 100644
--- a/drivers/net/wireless/rsi/rsi_boot_params.h
+++ b/drivers/net/wireless/rsi/rsi_boot_params.h
@@ -80,6 +80,15 @@ struct pll_config {
 	struct afepll_info afepll_info_g;
 } __packed;
 
+struct pll_config_9116 {
+	__le16 pll_ctrl_set_reg;
+	__le16 pll_ctrl_clr_reg;
+	__le16 pll_modem_conig_reg;
+	__le16 soc_clk_config_reg;
+	__le16 adc_dac_strm1_config_reg;
+	__le16 adc_dac_strm2_config_reg;
+} __packed;
+
 /* structure to store configs related to UMAC clk programming */
 struct switch_clk {
 	__le16 switch_clk_info;
@@ -93,11 +102,32 @@ struct switch_clk {
 	__le16 qspi_uart_clock_reg_config;
 } __packed;
 
+#define RSI_SWITCH_TASS_CLK			BIT(0)
+#define RSI_SWITCH_QSPI_CLK			BIT(1)
+#define RSI_SWITCH_SLP_CLK_2_32			BIT(2)
+#define RSI_SWITCH_WLAN_BBP_LMAC_CLK_REG	BIT(3)
+#define RSI_SWITCH_ZBBT_BBP_LMAC_CLK_REG	BIT(4)
+#define RSI_SWITCH_BBP_LMAC_CLK_REG		BIT(5)
+#define RSI_MODEM_CLK_160MHZ			BIT(6)
+
+struct switch_clk_9116 {
+	__le32 switch_clk_info;
+	__le32 tass_clock_reg;
+	__le32 wlan_bbp_lmac_clk_reg_val;
+	__le32 zbbt_bbp_lmac_clk_reg_val;
+	__le32 bbp_lmac_clk_en_val;
+} __packed;
+
 struct device_clk_info {
 	struct pll_config pll_config_g;
 	struct switch_clk switch_clk_g;
 } __packed;
 
+struct device_clk_info_9116 {
+	struct pll_config_9116 pll_config_9116_g;
+	struct switch_clk_9116 switch_clk_9116_g;
+} __packed;
+
 struct bootup_params {
 	__le16 magic_number;
 	__le16 crystal_good_time;
@@ -127,4 +157,37 @@ struct bootup_params {
 	__le32 max_threshold_to_avoid_sleep;
 	u8 beacon_resedue_alg_en;
 } __packed;
+
+struct bootup_params_9116 {
+	__le16 magic_number;
+#define LOADED_TOKEN  0x5AA5   /* Bootup params are installed by host
+				* or OTP/FLASH (Bootloader)
+				*/
+#define ROM_TOKEN     0x55AA   /* Bootup params are taken from ROM
+				* itself in MCU mode.
+				*/
+	__le16 crystal_good_time;
+	__le32 valid;
+	__le32 reserved_for_valids;
+	__le16 bootup_mode_info;
+#define BT_COEXIST		BIT(0)
+#define BOOTUP_MODE		(BIT(2) | BIT(1))
+#define CUR_DEV_MODE_9116	(bootup_params_9116.bootup_mode_info >> 1)
+	__le16 digital_loop_back_params;
+	__le16 rtls_timestamp_en;
+	__le16 host_spi_intr_cfg;
+	struct device_clk_info_9116 device_clk_info_9116[1];
+	__le32 buckboost_wakeup_cnt;
+	__le16 pmu_wakeup_wait;
+	u8 shutdown_wait_time;
+	u8 pmu_slp_clkout_sel;
+	__le32 wdt_prog_value;
+	__le32 wdt_soc_rst_delay;
+	__le32 dcdc_operation_mode;
+	__le32 soc_reset_wait_cnt;
+	__le32 waiting_time_at_fresh_sleep;
+	__le32 max_threshold_to_avoid_sleep;
+	u8 beacon_resedue_alg_en;
+} __packed;
+
 #endif
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index ea83faa15c7e..6b9248df6784 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -351,6 +351,15 @@ struct rsi_boot_params {
 	struct bootup_params bootup_params;
 } __packed;
 
+struct rsi_boot_params_9116 {
+	struct rsi_cmd_desc_dword0 desc_dword0;
+	struct rsi_cmd_desc_dword1 desc_dword1;
+	struct rsi_cmd_desc_dword2 desc_dword2;
+	__le16 reserved;
+	__le16 umac_clk;
+	struct bootup_params_9116 bootup_params;
+} __packed;
+
 struct rsi_peer_notify {
 	struct rsi_cmd_desc desc;
 	u8 mac_addr[6];
-- 
2.17.1

