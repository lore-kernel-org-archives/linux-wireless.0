Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700543BD659
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 07:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788937295; cv=none; b=FTmhmVahJy4+eV0q5xBiYofnvb0/WlFiqFVR3cO2soFphdfyznN6dqi7zqZrWa+3UnivieT3ft/hIazqvgX8GP2jF5PG8MaybyVrXfSG2YeHYfhHcoJD+lC65I4cvnlmYRhM8KHm5XyH7rHH7377PmiccIF4KlzqGCNdMVvatoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788937295; c=relaxed/simple;
	bh=H65Gi6JQQOnUmRQ/OfG+oplWn/CSP8HUS/+YKFw7u2I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YX6Qx2fYduZVqN0ywNeJhs31Dty9qjhWK8Fijyqi5hmOT8r1ecqakqLrVHKZxVCqnFev7WssttZV4iBypCj93x2Hn4Y6wUkuqjWaUZ3+RiDVQg9j9n4yVDfk8mdpm2oe9zBV7EViRst1OFZhMGrvPlEqF083WPVtO2cH9S6vcHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ihu6r4P4; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ihu6r4P4"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68971QBz8356897, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788937288; bh=Npr5XSgg1fdq5LIeOd6eIdU2j8ErsRKf3utuKtLe0eI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=ihu6r4P4jo6f6z4fLWz/VmGVJNAxQs/JwiAQ398qJ4MNtmQjJ/VEfft3z3DqPesIV
	 v/u6oWsDKRyMvWKAgv9hnU9gUHCyqVJtzbQmeyJFOdmPVdNKItzsQisV68sxhTrFPZ
	 ZT8smeb9YvaCYX9EzRSHipkp8F9XrUTWZ3b0gXznHy47UeJ5CqRF5Zd5tgb2zJzmDh
	 uJ1kd6kQmRYKjEcpAUJ0gXG39d9hYn5t5+zmXzmtBBspdqMZirMZRg83FJ8OrOUVt8
	 AHT+G5uZJo72vLfnSuWYpNqrayB40fkzUbqbYe19FlPh9rc9/cChFbUh8qHIy1Pm6E
	 DqwLo/RxNHHYA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68971QBz8356897
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 15:01:27 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:01:27 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:01:26 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 9 Sep 2026 15:01:26 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <echuang@realtek.com>,
	<phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 09/15] wifi: rtw89: 8922d: add extra data to PS H2C
Date: Wed, 9 Sep 2026 14:59:58 +0800
Message-ID: <20260909070004.35353-10-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260909070004.35353-1-pkshih@realtek.com>
References: <20260909070004.35353-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Eric Huang <echuang@realtek.com>

Append 2GHz regulatory mode and per-link BSS color to LPS
multi-link H2C to assist firmware backup and restore the
settings.

Signed-off-by: Eric Huang <echuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.h |  1 +
 drivers/net/wireless/realtek/rtw89/fw.c   | 44 +++++++++++++++++++++--
 drivers/net/wireless/realtek/rtw89/fw.h   | 17 +++++++++
 3 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index d725124b39bf..e88942c469e4 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -6023,6 +6023,7 @@ enum rtw89_fw_feature {
 	RTW89_FW_FEATURE_SER_L1_BY_EVENT,
 	RTW89_FW_FEATURE_SIM_SER_L0L1_BY_HALT_H2C,
 	RTW89_FW_FEATURE_LPS_ML_INFO_V1,
+	RTW89_FW_FEATURE_LPS_ML_INFO_V1_EXTRA,
 	RTW89_FW_FEATURE_SER_POST_RECOVER_DMAC,
 	RTW89_FW_FEATURE_TX_HISTORY_V1,
 
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index dcbdf4b5e4b2..300686ed0f6e 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -983,6 +983,7 @@ static const struct __fw_feat_cfg fw_feat_tbl[] = {
 	__CFG_FW_FEAT(RTL8922D, lt, 0, 35, 109, 1, SCAN_OFFLOAD_BE_V1),
 	__CFG_FW_FEAT(RTL8922D, lt, 0, 35, 113, 0, RFK_TXIQK_V0),
 	__CFG_FW_FEAT(RTL8922D, lt, 0, 35, 113, 2, SCAN_OFFLOAD_BE_V2),
+	__CFG_FW_FEAT(RTL8922D, ge, 0, 35, 119, 0, LPS_ML_INFO_V1_EXTRA),
 };
 
 static void rtw89_fw_iterate_feature_cfg(struct rtw89_fw_info *fw,
@@ -3486,26 +3487,59 @@ void rtw89_bb_lps_cmn_info_rx_gain_fill(struct rtw89_dev *rtwdev,
 	}
 }
 
+static void
+rtw89_fw_h2c_lps_ml_cmn_info_v1_extra_fill(struct rtw89_dev *rtwdev,
+					   struct rtw89_vif *rtwvif,
+					   struct rtw89_h2c_lps_ml_cmn_info_v1_extra *h2c)
+{
+	u8 regd = rtw89_regd_get(rtwdev, RTW89_BAND_2G);
+	struct ieee80211_bss_conf *bss_conf;
+	struct rtw89_vif_link *rtwvif_link;
+	unsigned int link_id;
+
+	static_assert(sizeof(*h2c) % 4 == 0);
+
+	h2c->regu_mode_on_24g = regd == RTW89_FCC ? RTW89_BB_REGULATION_FCC :
+						    RTW89_BB_REGULATION_CE;
+
+	rtw89_vif_for_each_link(rtwvif, rtwvif_link, link_id) {
+		u8 phy_idx = rtwvif_link->phy_idx;
+
+		rcu_read_lock();
+		bss_conf = rtw89_vif_rcu_dereference_link(rtwvif_link, true);
+		h2c->bss_color[phy_idx] = bss_conf->he_bss_color.color;
+		rcu_read_unlock();
+	}
+}
+
 int rtw89_fw_h2c_lps_ml_cmn_info_v1(struct rtw89_dev *rtwdev,
 				    struct rtw89_vif *rtwvif)
 {
 	static const u8 bcn_bw_ofst[] = {0, 0, 0, 3, 6, 9, 0, 12};
+	struct rtw89_h2c_lps_ml_cmn_info_v1_extra *h2c_extra;
 	const struct rtw89_chip_info *chip = rtwdev->chip;
 	struct rtw89_efuse *efuse = &rtwdev->efuse;
 	struct rtw89_h2c_lps_ml_cmn_info_v1 *h2c;
 	struct rtw89_vif_link *rtwvif_link;
 	const struct rtw89_chan *chan;
 	struct rtw89_bb_ctx *bb;
-	u32 len = sizeof(*h2c);
 	unsigned int link_id;
 	struct sk_buff *skb;
 	u8 beacon_bw_ofst;
+	bool has_extra;
 	u32 done;
+	u32 len;
 	int ret;
 
 	if (chip->chip_gen != RTW89_CHIP_BE)
 		return 0;
 
+	has_extra = RTW89_CHK_FW_FEATURE(LPS_ML_INFO_V1_EXTRA, &rtwdev->fw);
+	if (has_extra)
+		len = sizeof(*h2c_extra);
+	else
+		len = sizeof(*h2c);
+
 	skb = rtw89_fw_h2c_alloc_skb_with_hdr(rtwdev, len);
 	if (!skb) {
 		rtw89_err(rtwdev, "failed to alloc skb for h2c lps_ml_cmn_info_v1\n");
@@ -3514,7 +3548,13 @@ int rtw89_fw_h2c_lps_ml_cmn_info_v1(struct rtw89_dev *rtwdev,
 	skb_put(skb, len);
 	h2c = (struct rtw89_h2c_lps_ml_cmn_info_v1 *)skb->data;
 
-	h2c->fmt_id = 0x20;
+	if (has_extra) {
+		h2c_extra = container_of(h2c, typeof(*h2c_extra), v1);
+		h2c->fmt_id = RTW89_H2C_LPS_ML_CMN_INFO_FMT_ID_V1_EXTRA;
+		rtw89_fw_h2c_lps_ml_cmn_info_v1_extra_fill(rtwdev, rtwvif, h2c_extra);
+	} else {
+		h2c->fmt_id = RTW89_H2C_LPS_ML_CMN_INFO_FMT_ID_V1;
+	}
 
 	h2c->mlo_dbcc_mode = cpu_to_le32(rtwdev->mlo_dbcc_mode);
 	h2c->rfe_type = efuse->rfe_type;
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index 6cb1f6dfb650..d1bd82788376 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -2091,6 +2091,16 @@ struct rtw89_bb_link_info_rx_gain {
 	u8 wb_g_elna[RTW89_BB_PS_LINK_RX_GAIN_TAB_MAX][BB_GT2_G_ELNA_NUM];
 } __packed;
 
+enum rtw89_bb_regulation_mode {
+	RTW89_BB_REGULATION_FCC = 0,
+	RTW89_BB_REGULATION_CE = 1,
+};
+
+enum rtw89_h2c_lps_ml_cmn_info_fmt_id {
+	RTW89_H2C_LPS_ML_CMN_INFO_FMT_ID_V1 = 0x20,
+	RTW89_H2C_LPS_ML_CMN_INFO_FMT_ID_V1_EXTRA = 0x21,
+};
+
 struct rtw89_h2c_lps_ml_cmn_info_v1 {
 	u8 fmt_id;
 	u8 rfe_type;
@@ -2106,6 +2116,13 @@ struct rtw89_h2c_lps_ml_cmn_info_v1 {
 	struct rtw89_bb_link_info_rx_gain rx_gain[RTW89_BB_PS_LINK_BUF_MAX];
 } __packed;
 
+struct rtw89_h2c_lps_ml_cmn_info_v1_extra {
+	struct rtw89_h2c_lps_ml_cmn_info_v1 v1;
+	u8 regu_mode_on_24g;
+	u8 bss_color[RTW89_BB_PS_LINK_BUF_MAX];
+	u8 rsvd[2];
+} __packed;
+
 struct rtw89_h2c_phy_rfe_type {
 	u8 rfe_type;
 	u8 rsvd[3];
-- 
2.25.1

