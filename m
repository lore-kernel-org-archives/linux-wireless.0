Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EBE382381
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 06:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787726520; cv=none; b=NLqOfDRtsTBfgl6CPm2tTRNAuzuHXZcGaDdM3PaWzk7Dqrp+uRvgouHmAey9Q18g8xXsARU0Njzm7JZr0t0jg4prQMq8nYoHsGDvh8L7csQLKMqnOCfyqgHWaBjQ8BN3D6KEFdGIrcbR0zH286AH/QhJ1GBkRpy89NxLdsNLHa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787726520; c=relaxed/simple;
	bh=nkKizCwm9E3GZiY6Ii5DMIxnthMhLqU5aXZl/1tK7Q8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a1W9pdi2w6byRCUyD/Wp5b5EApEYJwX8INC0X9K0/FPDoptMIi2q23Wnc+hBuG8OOc7NYBwOld9ykTiAPtjctTIvhh10/K57joKTgs1k9CdeZQZAxmxQAM/fmJX8WIsOjRXJfo6IXNSVthzv/d1OcdfyT82SGc+t3Pgm5AdBeb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=egeeKLmH; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="egeeKLmH"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67Q6fuiA7353421, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787726516; bh=kGVak0d9QOEhGWxgW4IL6pzubcUVWXISkZaal1x3xkE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=egeeKLmH6zLNEhdprsr5vVVC/s7NAuP7X8aw5zXeO3Tdb7FGrXESKrhpyF5Pa4wZE
	 ZtKiF7Z5GUvnTxcPnEYDxxVUv5F2fLZ+4hbJUejOz1aJSLYilaw79slhccFYo5wDI+
	 01Au2JwffaZT9JNhihX0s9IVVtONmbvrYZ5BZKvkWiGuuOCMcfN5twtWCJm9bFfMcj
	 GP9QW8Wz+BUXPQiIk6O6Z93R3vcsKOenEjc7QpC8uEn1wpgWWJm8j/ezJq0QSf2qo8
	 AvobhHzcC1lm2HGAHU6YWpGPhlOTJ8UyfgpLwOxpHza+52J6I2yambarqzjI7rDyuH
	 hcwBVtZmKqaGA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67Q6fuiA7353421
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 14:41:56 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 26 Aug 2026 14:41:57 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 26 Aug 2026 14:41:56 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 26 Aug 2026 14:41:56 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 08/14] wifi: rtw89: 8922d: send RFE type to firmware
Date: Wed, 26 Aug 2026 14:40:55 +0800
Message-ID: <20260826064101.58892-9-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260826064101.58892-1-pkshih@realtek.com>
References: <20260826064101.58892-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

To configure BT in firmware according to RFE type, send it via H2C command.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/fw.c       | 40 +++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/fw.h       |  7 ++++
 drivers/net/wireless/realtek/rtw89/rtw8922d.c |  2 +
 3 files changed, 49 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 0099c5c03e7a..18f4781d4e90 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -3535,6 +3535,46 @@ int rtw89_fw_h2c_lps_ml_cmn_info_v1(struct rtw89_dev *rtwdev,
 	return ret;
 }
 
+int rtw89_fw_h2c_phy_rfe_type(struct rtw89_dev *rtwdev)
+{
+	const struct rtw89_chip_info *chip = rtwdev->chip;
+	struct rtw89_efuse *efuse = &rtwdev->efuse;
+	struct rtw89_h2c_phy_rfe_type *h2c;
+	u32 len = sizeof(*h2c);
+	struct sk_buff *skb;
+	int ret;
+
+	if (chip->chip_id != RTL8922D)
+		return 0;
+
+	skb = rtw89_fw_h2c_alloc_skb_with_hdr(rtwdev, len);
+	if (!skb) {
+		rtw89_err(rtwdev, "failed to alloc skb for h2c phy_rfe_type\n");
+		return -ENOMEM;
+	}
+	skb_put(skb, len);
+	h2c = (struct rtw89_h2c_phy_rfe_type *)skb->data;
+
+	h2c->rfe_type = efuse->rfe_type;
+
+	rtw89_h2c_pkt_set_hdr(rtwdev, skb, FWCMD_TYPE_H2C,
+			      H2C_CAT_OUTSRC, H2C_CL_OUTSRC_DM,
+			      H2C_FUNC_FW_RFE_TYPE, 0, 0, len);
+
+	ret = rtw89_h2c_tx(rtwdev, skb, false);
+	if (ret) {
+		rtw89_err(rtwdev, "failed to send h2c\n");
+		goto fail;
+	}
+
+	return 0;
+fail:
+	dev_kfree_skb_any(skb);
+
+	return ret;
+}
+EXPORT_SYMBOL(rtw89_fw_h2c_phy_rfe_type);
+
 #define H2C_P2P_ACT_LEN 20
 int rtw89_fw_h2c_p2p_act(struct rtw89_dev *rtwdev,
 			 struct rtw89_vif_link *rtwvif_link,
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index 375ca0a243a6..f7d017d3ced0 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -2101,6 +2101,11 @@ struct rtw89_h2c_lps_ml_cmn_info_v1 {
 	struct rtw89_bb_link_info_rx_gain rx_gain[RTW89_BB_PS_LINK_BUF_MAX];
 } __packed;
 
+struct rtw89_h2c_phy_rfe_type {
+	u8 rfe_type;
+	u8 rsvd[3];
+} __packed;
+
 struct rtw89_h2c_trig_cpu_except {
 	__le32 w0;
 } __packed;
@@ -4886,6 +4891,7 @@ enum rtw89_mrc_h2c_func {
 #define H2C_FUNC_FW_MCC_DIG		0x6
 #define H2C_FUNC_FW_LPS_CH_INFO		0xb
 #define H2C_FUNC_FW_LPS_ML_CMN_INFO	0xe
+#define H2C_FUNC_FW_RFE_TYPE		0x1b
 
 #define H2C_CL_OUTSRC_RF_REG_A		0x8
 #define H2C_CL_OUTSRC_RF_REG_B		0x9
@@ -5568,6 +5574,7 @@ int rtw89_fw_h2c_lps_ml_cmn_info_v1(struct rtw89_dev *rtwdev,
 				    struct rtw89_vif *rtwvif);
 int rtw89_fw_h2c_fwips(struct rtw89_dev *rtwdev, struct rtw89_vif_link *rtwvif_link,
 		       bool enable);
+int rtw89_fw_h2c_phy_rfe_type(struct rtw89_dev *rtwdev);
 struct sk_buff *rtw89_fw_h2c_alloc_skb_with_hdr(struct rtw89_dev *rtwdev, u32 len);
 struct sk_buff *rtw89_fw_h2c_alloc_skb_no_hdr(struct rtw89_dev *rtwdev, u32 len);
 int rtw89_fw_msg_reg(struct rtw89_dev *rtwdev,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index 5f910163163f..4d003b303ae7 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -2504,6 +2504,8 @@ static void rtw8922d_bb_sethw(struct rtw89_dev *rtwdev)
 	enum rtw89_phy_idx phy_idx;
 	u32 reg;
 
+	rtw89_fw_h2c_phy_rfe_type(rtwdev);
+
 	reg = rtw89_mac_reg_by_idx(rtwdev, R_BE_PWR_BOOST, RTW89_PHY_0);
 	rtw89_write32_clr(rtwdev, reg, B_BE_PWR_CTRL_SEL);
 	reg = rtw89_mac_reg_by_idx(rtwdev, R_BE_PWR_BOOST, RTW89_PHY_1);
-- 
2.25.1

