Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1257D3749E2
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 13:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784901416; cv=none; b=cuYzHTlr7SkhKbgdMsF+B8o/B3JCJUfOhWiyo6+JCqMU5GUdf+tCzJocxWC4HVRsYH1hrpbR4Asld1qKRqgsFY6mo1+jWuMeA4BgXx40mb69XPU5Ep8SX+CQcovckPV6ZQnEPU/72ycZSyXkXD9iyYdVMcI0qLmKPdJ8NAk+4hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784901416; c=relaxed/simple;
	bh=qv87pR0AZEWiaYDbxNy92sqy3aco6WeNbltuqXO3icM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XmCDwDbW+4xcdy+Nycy1x3kzIeOrbpV4vzByMP5EM6Vm/06xNmlP6A5QJrIpUjSb135uLg2yf1QNS3i39T5mgPt+ezIyXxKWKstik46LRrSurjux61W21hDZH3jGnO+ZDHvJi+MxOFWpM/54spzLKGIrUWD8CfJF9kje3CTPdws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Afksqz1D; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Afksqz1D"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66ODupcjF1179676, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784901411; bh=EYhMQwu2fWq/M4U0yqr2JbsvG9wNsaJNTI04bfKLJ5M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=Afksqz1D2mLG73+547K4gR+GqW/UiKkYjLW7mOqRubjmjVK3AlD1uUEC2TMOxOeA/
	 /PRDsup97SDzV3DKjotWBzxQJu75HjE2CTz12XHxvAL4VyQxScfJspvYV7hB9xVhjz
	 xwxOFzETnC5bCmthfCLP134EKRl9j0TqRQ+NwJSjewZ0Ei6GkviSH63m9lhFSKQhKz
	 dBPytSF5OsusO1M4H/mDbRMt1NZ7PJ3o1JbFjvx8w+/ggEPfwpcnijtj4liBFF1Q5r
	 3xwVF4vIbMpZFWlaxDipAhPHauH1XhKL/Tz2MQEJ2FjXYJWzTlDB8G2x4ip6RFRL0G
	 FFtCOQw3s9yTw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66ODupcjF1179676
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 21:56:51 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 21:56:51 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 21:56:51 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 21:56:51 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 02/14] wifi: rtw89: coex: Add Wi-Fi MLO info version 2 H2C command
Date: Fri, 24 Jul 2026 21:56:28 +0800
Message-ID: <20260724135640.3195044-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260724135640.3195044-1-pkshih@realtek.com>
References: <20260724135640.3195044-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

The info included MLO status, hardware status, firmware will set
corresponding register control to do coexistence (PTA slot priority,
RF switch etc.)

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c |  3 ++
 drivers/net/wireless/realtek/rtw89/core.h | 19 ++++++++
 drivers/net/wireless/realtek/rtw89/fw.c   | 58 +++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/fw.h   |  6 +++
 4 files changed, 86 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index f94866e1f43a..0c5599a23b4a 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -3274,6 +3274,9 @@ static void _fw_set_drv_info(struct rtw89_dev *rtwdev, u8 index)
 		else
 			return;
 
+		if (ver->fcxmlo == 2)
+			rtw89_fw_h2c_cxdrv_mlo_v2(rtwdev, index);
+
 		break;
 	case CXDRVINFO_OSI:
 		if (!ver->fcxosi || ver->drvinfo_ver == 103)
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 7147e186b4a5..0ec63f9510bd 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -1783,6 +1783,25 @@ struct rtw89_btc_wl_dbcc_info {
 	u8 role[RTW89_PHY_NUM]; /* role in each phy */
 };
 
+struct rtw89_btc_wl_mlo_info_v2 {
+	u8 wmode[RTW89_PHY_NUM];
+	u8 ch_type[RTW89_PHY_NUM];
+	u8 hwb_rf_band[RTW89_PHY_NUM];
+	u8 path_rf_band[RTW89_PHY_NUM];
+
+	u8 wtype;
+	u8 mrcx_mode;
+	u8 mrcx_act_hwb_map;
+	u8 mrcx_bt_slot_rsp;
+
+	u8 rf_combination;
+	u8 mlo_en;
+	u8 mlo_adie;
+	u8 dual_hw_band_en;
+
+	__le32 link_status;
+} __packed;
+
 struct rtw89_btc_wl_mlo_info {
 	u8 wmode[RTW89_PHY_NUM]; /* enum phl_mr_wmode */
 	u8 ch_type[RTW89_PHY_NUM]; /* enum phl_mr_ch_type */
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index a3a04697e2e6..5ab80bda3ae5 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -6616,6 +6616,64 @@ int rtw89_fw_h2c_cxdrv_role_v10(struct rtw89_dev *rtwdev, u8 type)
 	return ret;
 }
 
+int rtw89_fw_h2c_cxdrv_mlo_v2(struct rtw89_dev *rtwdev, u8 type)
+{
+	struct rtw89_btc_wl_mlo_info *mlo = &rtwdev->btc.cx.wl.mlo_info;
+	struct rtw89_h2c_cxmlo_v2 *h2c;
+	u32 len = sizeof(*h2c);
+	struct sk_buff *skb;
+	int ret;
+
+	skb = rtw89_fw_h2c_alloc_skb_with_hdr(rtwdev, len);
+	if (!skb) {
+		rtw89_err(rtwdev, "failed to alloc skb for h2c cxdrv_mlo_v2\n");
+		return -ENOMEM;
+	}
+	skb_put(skb, len);
+	h2c = (struct rtw89_h2c_cxmlo_v2 *)skb->data;
+
+	h2c->hdr.type = type;
+	h2c->hdr.ver = 2;
+	h2c->hdr.len = len - H2C_LEN_CXDRVHDR_V7;
+
+	memcpy(h2c->mlo.wmode, mlo->wmode,
+	       sizeof(h2c->mlo.wmode));
+	memcpy(h2c->mlo.ch_type, mlo->ch_type,
+	       sizeof(h2c->mlo.ch_type));
+	memcpy(h2c->mlo.hwb_rf_band, mlo->hwb_rf_band,
+	       sizeof(h2c->mlo.hwb_rf_band));
+	memcpy(h2c->mlo.path_rf_band, mlo->path_rf_band,
+	       sizeof(h2c->mlo.path_rf_band));
+
+	h2c->mlo.wtype = mlo->wtype;
+	h2c->mlo.mrcx_mode = mlo->mrcx_mode;
+	h2c->mlo.mrcx_act_hwb_map = mlo->mrcx_act_hwb_map;
+	h2c->mlo.mrcx_bt_slot_rsp = mlo->mrcx_bt_slot_rsp;
+
+	h2c->mlo.rf_combination = mlo->rf_combination;
+	h2c->mlo.mlo_en = mlo->mlo_en;
+	h2c->mlo.mlo_adie = mlo->mlo_adie;
+	h2c->mlo.dual_hw_band_en = mlo->dual_hw_band_en;
+	h2c->mlo.link_status = cpu_to_le32(mlo->link_status);
+
+	rtw89_h2c_pkt_set_hdr(rtwdev, skb, FWCMD_TYPE_H2C,
+			      H2C_CAT_OUTSRC, BTFC_SET,
+			      SET_DRV_INFO, 0, 0,
+			      len);
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
+
 int rtw89_fw_h2c_cxdrv_osi_info(struct rtw89_dev *rtwdev, u8 type)
 {
 	struct rtw89_btc *btc = &rtwdev->btc;
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index c0a00b721060..538df0fb42cc 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -2453,6 +2453,11 @@ struct rtw89_h2c_cxrole_v10 {
 	struct rtw89_btc_wl_role_info_v10 r;
 } __packed;
 
+struct rtw89_h2c_cxmlo_v2 {
+	struct rtw89_h2c_cxhdr_v7 hdr;
+	struct rtw89_btc_wl_mlo_info_v2 mlo;
+} __packed;
+
 struct rtw89_h2c_cxosi {
 	struct rtw89_h2c_cxhdr_v7 hdr;
 	struct rtw89_btc_fbtc_outsrc_set_info_v1 osi;
@@ -5462,6 +5467,7 @@ int rtw89_fw_h2c_cxdrv_role_v7(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_role_v8(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_role_v10(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_init_v11(struct rtw89_dev *rtwdev, u8 type);
+int rtw89_fw_h2c_cxdrv_mlo_v2(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_osi_info(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_osi_info_v6(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_ctrl(struct rtw89_dev *rtwdev, u8 type);
-- 
2.25.1

