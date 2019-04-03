Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D554C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 04:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 025D220882
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 04:13:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tZKiVRb8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfDCENj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 00:13:39 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40041 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbfDCENi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 00:13:38 -0400
Received: by mail-pl1-f195.google.com with SMTP id b3so4369600plr.7
        for <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2019 21:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7R46dzH1EaCBosHA5RnOCXrM5xi+AbbXTz2RXAagiSc=;
        b=tZKiVRb8nTnoNn/dd9nOL+qvBO784WyGN27SZwOLdgAMSmPe/SBBe9LOMYjvU4LubQ
         +mA0ET+7fo9mMW9ngwA37p+Hi/CT9Eenxh/qlVfDxYJwYuzy5BRIUuTrdxTdA9IlomJG
         3UaoyqZoy7eEBDg5Zzyrzh5JS+ePb5FF5I635MbF5pHCDQz6V8Ddkf7ZjHsAQFpBIh1I
         EPGox87cjkV/auvlb8BhtyjjdNhtpiJcZ30CKvPnFUVe/5yPuO0BfaoeXkLfuGTV0RgC
         hlZwe6OYNPRGhoqMKZhh6V0iWncttX2FmMvo4Zyn/FlQsuAOnhLARZbE4nO1/5/OIHWv
         rw4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7R46dzH1EaCBosHA5RnOCXrM5xi+AbbXTz2RXAagiSc=;
        b=tSkjtTWVIgj+HqFWWTUkvCqJLsCGCEgaZXxZhRBiLXlxgvehjF4XWSqJRztOXJJxIh
         zF94L9LWUrZMSy7PJpT+HhVr06dB86ZVmgCTdM9pm8n9K5ntmroPobHIqtog2NRFI1PH
         GMFZT2LYuzYEMiNAoFxKnvK4QJKaaM7bCZzhMmBznwrh8B9ZMlr49tq52Zo3Pt/UXUI/
         cfce0BuIELlLvgzA4+0LZR7NdL3L9h/s60zzTtz+LY+koUYCdpQMnPsHaORHXM1kNJgC
         MfrqThI4hIN+lyDiZ/QV4DNgHZJlDnZpH2tv6PnDzc0MG+uwASLeG7e4gEOnxMITHQSr
         vgBw==
X-Gm-Message-State: APjAAAUWSugSeXQvwuGH0osLq01y9WcMPBY59KwXqVZ9fur/nh5lLtxm
        9bey7lc+/ku8MIzh2YcRjW8=
X-Google-Smtp-Source: APXvYqxzL6dpu9hgzxgp+uJzH4RaSXXcOE8v6nS48Lt+iVgaDxfD5vfFr8hnc1wk+tdOpEpmAJ6Cng==
X-Received: by 2002:a17:902:2a2a:: with SMTP id i39mr33398489plb.211.1554264817712;
        Tue, 02 Apr 2019 21:13:37 -0700 (PDT)
Received: from siva.domain.name ([123.201.77.78])
        by smtp.gmail.com with ESMTPSA id r3sm42290239pgb.82.2019.04.02.21.13.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 21:13:37 -0700 (PDT)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        krishna.pedda@redpinesignals.com,
        Ganapathiraju Kondraju <ganapathi.kondraju@redpinesignals.com>,
        Siva Rebbagondla <siva8118@gmail.com>
Subject: [PATCH 6/8] rsi: send new tx command frame wlan9116 features
Date:   Wed,  3 Apr 2019 09:43:07 +0530
Message-Id: <20190403041309.12829-7-siva8118@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190403041309.12829-1-siva8118@gmail.com>
References: <20190403041309.12829-1-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

For 9116 device, we have introduced w9116 features frame, which shall be
send when radio capabilities confirm is received.

Signed-off-by: Siva Rebbagondla <siva8118@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 55 +++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_main.h     | 12 ++++++
 drivers/net/wireless/rsi/rsi_mgmt.h     | 17 ++++++++
 3 files changed, 84 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index d4d833c3e782..f328532fef88 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -288,6 +288,14 @@ static void rsi_set_default_parameters(struct rsi_common *common)
 	common->obm_ant_sel_val = 2;
 	common->beacon_interval = RSI_BEACON_INTERVAL;
 	common->dtim_cnt = RSI_DTIM_COUNT;
+	common->w9116_features.pll_mode = 0x0;
+	common->w9116_features.rf_type = 1;
+	common->w9116_features.wireless_mode = 0;
+	common->w9116_features.enable_ppe = 0;
+	common->w9116_features.afe_type = 1;
+	common->w9116_features.dpd = 0;
+	common->w9116_features.sifs_tx_enable = 0;
+	common->w9116_features.ps_options = 0;
 }
 
 void init_bgscan_params(struct rsi_common *common)
@@ -1646,6 +1654,47 @@ int rsi_send_ps_request(struct rsi_hw *adapter, bool enable,
 	return rsi_send_internal_mgmt_frame(common, skb);
 }
 
+static int rsi_send_w9116_features(struct rsi_common *common)
+{
+	struct rsi_wlan_9116_features *w9116_features;
+	u16 frame_len = sizeof(struct rsi_wlan_9116_features);
+	struct sk_buff *skb;
+
+	rsi_dbg(MGMT_TX_ZONE,
+		"%s: Sending wlan 9116 features\n", __func__);
+
+	skb = dev_alloc_skb(frame_len);
+	if (!skb)
+		return -ENOMEM;
+	memset(skb->data, 0, frame_len);
+
+	w9116_features = (struct rsi_wlan_9116_features *)skb->data;
+
+	w9116_features->pll_mode = common->w9116_features.pll_mode;
+	w9116_features->rf_type = common->w9116_features.rf_type;
+	w9116_features->wireless_mode = common->w9116_features.wireless_mode;
+	w9116_features->enable_ppe = common->w9116_features.enable_ppe;
+	w9116_features->afe_type = common->w9116_features.afe_type;
+	if (common->w9116_features.dpd)
+		w9116_features->feature_enable |= cpu_to_le32(RSI_DPD);
+	if (common->w9116_features.sifs_tx_enable)
+		w9116_features->feature_enable |=
+			cpu_to_le32(RSI_SIFS_TX_ENABLE);
+	if (common->w9116_features.ps_options & RSI_DUTY_CYCLING)
+		w9116_features->feature_enable |= cpu_to_le32(RSI_DUTY_CYCLING);
+	if (common->w9116_features.ps_options & RSI_END_OF_FRAME)
+		w9116_features->feature_enable |= cpu_to_le32(RSI_END_OF_FRAME);
+	w9116_features->feature_enable |=
+		cpu_to_le32((common->w9116_features.ps_options & ~0x3) << 2);
+
+	rsi_set_len_qno(&w9116_features->desc.desc_dword0.len_qno,
+			frame_len - FRAME_DESC_SZ, RSI_WIFI_MGMT_Q);
+	w9116_features->desc.desc_dword0.frame_type = FEATURES_ENABLE;
+	skb_put(skb, frame_len);
+
+	return rsi_send_internal_mgmt_frame(common, skb);
+}
+
 /**
  * rsi_set_antenna() - This function send antenna configuration request
  *		       to device
@@ -1964,6 +2013,12 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 	case RADIO_CAPABILITIES:
 		if (common->fsm_state == FSM_RADIO_CAPS_SENT) {
 			common->rf_reset = 1;
+			if (adapter->device_model == RSI_DEV_9116 &&
+			    rsi_send_w9116_features(common)) {
+				rsi_dbg(ERR_ZONE,
+					"Failed to send 9116 features\n");
+				goto out;
+			}
 			if (rsi_program_bb_rf(common)) {
 				goto out;
 			} else {
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index e35c6e5151c3..73a19e43106b 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -219,6 +219,17 @@ enum rsi_dfs_regions {
 	RSI_REGION_WORLD
 };
 
+struct rsi_9116_features {
+	u8 pll_mode;
+	u8 rf_type;
+	u8 wireless_mode;
+	u8 afe_type;
+	u8 enable_ppe;
+	u8 dpd;
+	u32 sifs_tx_enable;
+	u32 ps_options;
+};
+
 struct rsi_common {
 	struct rsi_hw *priv;
 	struct vif_priv vif_info[RSI_MAX_VIFS];
@@ -314,6 +325,7 @@ struct rsi_common {
 
 	struct cfg80211_scan_request *hwscan;
 	struct rsi_bgscan_params bgscan;
+	struct rsi_9116_features w9116_features;
 	u8 bgscan_en;
 	u8 mac_ops_resumed;
 };
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 6b9248df6784..2ce2dcf57441 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -294,6 +294,7 @@ enum cmd_frame_type {
 	COMMON_DEV_CONFIG = 0x28,
 	RADIO_PARAMS_UPDATE = 0x29,
 	WOWLAN_CONFIG_PARAMS = 0x2B,
+	FEATURES_ENABLE = 0x33,
 	WOWLAN_WAKEUP_REASON = 0xc5
 };
 
@@ -663,6 +664,22 @@ struct rsi_bgscan_probe {
 	__le16 probe_req_length;
 } __packed;
 
+#define RSI_DUTY_CYCLING	BIT(0)
+#define RSI_END_OF_FRAME	BIT(1)
+#define RSI_SIFS_TX_ENABLE	BIT(2)
+#define RSI_DPD			BIT(3)
+struct rsi_wlan_9116_features {
+	struct rsi_cmd_desc desc;
+	u8 pll_mode;
+	u8 rf_type;
+	u8 wireless_mode;
+	u8 enable_ppe;
+	u8 afe_type;
+	u8 reserved1;
+	__le16 reserved2;
+	__le32 feature_enable;
+};
+
 static inline u32 rsi_get_queueno(u8 *addr, u16 offset)
 {
 	return (le16_to_cpu(*(__le16 *)&addr[offset]) & 0x7000) >> 12;
-- 
2.17.1

