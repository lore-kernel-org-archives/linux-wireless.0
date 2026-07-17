Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842253CF67F
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784271532; cv=none; b=E9B9y9T2biSurbHjB3bi8+5n48JSLvkorD0diPoW7LeVan9C38nSTRXQZdbFLVe4ifqIG0gLQnGtjampx0UvZIKtDiL/SxPqQ3Jc7i8E8TA9LEje/oLwdlHi5Z+37E2A33hKBegBK5g6MucgNMQIHOi6wieyMs8icUQb2ne0x44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784271532; c=relaxed/simple;
	bh=W9hXyMSnfm+jm07q1RHeIwJw3amq5+vWEApvnDdcBSg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PrZmuc08TcYJ6qBvAMnKtf2M9b5xVNDr/bOPR7geRsyH7oecUYec5r8yKbtQfuUIxuWnwdUmR4tQt+Wr56lMoMQAGOOZdFppXmaM+2EVhHfeILX3wTMYaJXCY85WuXWPuUJ6Dvo/d17Rh11CBCHQuJgeaDpU6DTbFj65hiYynpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Vyb7evgB; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Vyb7evgB"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H6wlsbF4176321, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784271527; bh=4ZyscKjv0uwd2jUx+dyIqLFgD3Hq6mGa4AfmqxcrjJc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=Vyb7evgBV5QcgDb9O/NbzYH0T1eEJHi6dgsVneQoL1gvojqS5tFSABzlLSYFWpbOK
	 sOzQ1bzkJOYsSj3Y5dErwWZ3bsr+teltYkO5UyYuiZRDC2oVg/Tv+9ddpSdfSvh1BB
	 E0ltBtehxvt2tmOlJ0QAlaCIOPkh17+LeIZLVQRyCriR8Ovhc1VHwxPf0b3QBxcz2r
	 fi2D05idZ3Fd6ualmU7S+VG8oZg6aY5VLMuqmtHdzTCTBzC2XuoN48E2VHDclcIHfs
	 cjBbbB97s8MAfO9DgKLWgfBaWqf+9NzdAH6avaEPxq+za5mMI8yHBk+MYNO6wqchib
	 V/ucNlcCek/uQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H6wlsbF4176321
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:58:47 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:58:48 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:58:48 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 14:58:48 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 01/13] wifi: rtw89: coex: Add version 107 TX/RX info for firmware feature
Date: Fri, 17 Jul 2026 14:57:27 +0800
Message-ID: <20260717065739.64124-2-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260717065739.64124-1-pkshih@realtek.com>
References: <20260717065739.64124-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

The previous version 7 format is for Dual-Bluetooth using. This patch
is for single Bluetooth solution using. Driver will summary Wi-Fi now
status for firmware to train RF parameters & TDMA mechanism.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c |  27 ++++--
 drivers/net/wireless/realtek/rtw89/fw.c   | 112 ++++++++++++++++------
 drivers/net/wireless/realtek/rtw89/fw.h   |  24 +++++
 3 files changed, 126 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index b044b25aeade..3addcdfd89eb 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -3081,10 +3081,15 @@ static void _fw_set_drv_info(struct rtw89_dev *rtwdev, u8 index)
 		if (ver->drvinfo_ver > 1)
 			index = 3;
 
+		if (ver->fcxtrx == 0)
+			return;
+
 		if (ver->fcxtrx == 7)
 			rtw89_fw_h2c_cxdrv_trx_v7(rtwdev, index);
 		else if (ver->fcxtrx == 9)
 			rtw89_fw_h2c_cxdrv_trx_v9(rtwdev, index);
+		else if (ver->fcxtrx == 107)
+			rtw89_fw_h2c_cxdrv_trx_v107(rtwdev, index);
 		break;
 	case CXDRVINFO_RFK:
 		if (ver->drvinfo_ver != 0)
@@ -3096,7 +3101,7 @@ static void _fw_set_drv_info(struct rtw89_dev *rtwdev, u8 index)
 		if (ver->drvinfo_ver == 3)
 			index = 4;
 
-		if (ver->fcxtrx == 7)
+		if (ver->fcxtrx == 7 || ver->fcxtrx == 107)
 			rtw89_fw_h2c_cxtxpwr_v7(rtwdev, index);
 		else if (ver->fcxtrx == 9)
 			rtw89_fw_h2c_cxtxpwr_v9(rtwdev, index);
@@ -3358,7 +3363,8 @@ static void _set_wl_tx_power(struct rtw89_dev *rtwdev, u32 level, u8 phy_map)
 		    dm->rf_trx_para.wl_tx_power[RTW89_PHY_0],
 		    dm->rf_trx_para.wl_tx_power[RTW89_PHY_1]);
 
-	if (ver->fcxtrx == 7 && chip->chip_id == RTL8922A) {
+	if ((ver->fcxtrx == 7 && chip->chip_id == RTL8922A) ||
+	    ver->fcxtrx == 107) {
 		_fw_set_drv_info(rtwdev, CXDRVINFO_TXPWR);
 	} else if (ver->fcxtrx == 9) {
 		_fw_set_drv_info(rtwdev, CXDRVINFO_TXPWR);
@@ -3632,12 +3638,17 @@ static void _set_rf_trx_para(struct rtw89_dev *rtwdev)
 	u8 bid = BTC_BT_1ST, lv;
 	u32 wl_stb_chg;
 
-	if (ver->fcxtrx == 9 && chip->rf_para_ulink_v9) {
-		ul_para_num = chip->rf_para_ulink_num_v9;
-		dl_para_num = chip->rf_para_dlink_num_v9;
-		_set_rf_trx_para_v9(rtwdev);
-		return;
-	} else if (ver->fcxtrx == 0 && chip->rf_para_ulink_v0) {
+	if (ver->fcxtrx == 9) {
+		/* Early v9 need to assign UL/DL RF para at driver */
+		if (chip->rf_para_ulink_v9) {
+			ul_para_num = chip->rf_para_ulink_num_v9;
+			dl_para_num = chip->rf_para_dlink_num_v9;
+		} else {
+			_set_rf_trx_para_v9(rtwdev);
+			return;
+		}
+	} else if ((ver->fcxtrx == 0 || ver->fcxtrx == 7 || ver->fcxtrx == 107) &&
+		   chip->rf_para_ulink_v0) {
 		ul_para_num = chip->rf_para_ulink_num_v0;
 		dl_para_num = chip->rf_para_dlink_num_v0;
 	} else {
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 0db77120298f..33303c097f47 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -6677,16 +6677,12 @@ int rtw89_fw_h2c_cxdrv_ctrl_v9(struct rtw89_dev *rtwdev, u8 type)
 	return ret;
 }
 
-int rtw89_fw_h2c_cxdrv_trx_v7(struct rtw89_dev *rtwdev, u8 type)
+static void rtw89_btc_load_trx_para(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_btc *btc = &rtwdev->btc;
 	struct rtw89_btc_rf_trx_para_v9 rf_para = btc->dm.rf_trx_para;
 	struct rtw89_btc_trx_info *trx = &btc->dm.trx_info;
 	struct rtw89_btc_wl_info *wl = &btc->cx.wl;
-	struct rtw89_h2c_cxtrx_v7 *h2c;
-	u32 len = sizeof(*h2c);
-	struct sk_buff *skb;
-	int ret;
 	u8 i;
 
 	for (i = 0; i < RTW89_PHY_NUM; i++) {
@@ -6694,19 +6690,38 @@ int rtw89_fw_h2c_cxdrv_trx_v7(struct rtw89_dev *rtwdev, u8 type)
 						   RTW89_BTC_WL_DEF_TX_PWR);
 		trx->wl_rx_gain[i] = u32_get_bits(rf_para.wl_rx_gain[i],
 						  RTW89_BTC_WL_DEF_TX_PWR);
+		if (btc->ver->fcxtrx == 107)
+			break;
 	}
+
 	for (i = 0; i < BTC_ALL_BT; i++) {
 		trx->bt_tx_power[i] = u32_get_bits(rf_para.bt_tx_power[i],
 						   RTW89_BTC_WL_DEF_TX_PWR);
 		trx->bt_rx_gain[i] = u32_get_bits(rf_para.bt_rx_gain[i],
 						  RTW89_BTC_WL_DEF_TX_PWR);
+		if (btc->ver->fcxtrx == 107)
+			break;
+
 		trx->zb_tx_power[i] = u32_get_bits(rf_para.zb_tx_power[i],
 						   RTW89_BTC_WL_DEF_TX_PWR);
 		trx->zb_rx_gain[i] = u32_get_bits(rf_para.zb_rx_gain[i],
 						  RTW89_BTC_WL_DEF_TX_PWR);
 	}
+
 	trx->cn = wl->cn_report;
 	trx->nhm = wl->nhm.pwr;
+}
+
+int rtw89_fw_h2c_cxdrv_trx_v7(struct rtw89_dev *rtwdev, u8 type)
+{
+	struct rtw89_btc *btc = &rtwdev->btc;
+	struct rtw89_btc_trx_info *trx = &btc->dm.trx_info;
+	struct rtw89_h2c_cxtrx_v7 *h2c;
+	u32 len = sizeof(*h2c);
+	struct sk_buff *skb;
+	int ret;
+
+	rtw89_btc_load_trx_para(rtwdev);
 
 	skb = rtw89_fw_h2c_alloc_skb_with_hdr(rtwdev, len);
 	if (!skb) {
@@ -6717,7 +6732,7 @@ int rtw89_fw_h2c_cxdrv_trx_v7(struct rtw89_dev *rtwdev, u8 type)
 	h2c = (struct rtw89_h2c_cxtrx_v7 *)skb->data;
 
 	h2c->hdr.type = type;
-	h2c->hdr.ver = btc->ver->fcxtrx;
+	h2c->hdr.ver = 7;
 	h2c->hdr.len = sizeof(*h2c) - H2C_LEN_CXDRVHDR_V7;
 
 	h2c->v7_u8.tx_lvl = trx->tx_lvl;
@@ -6760,33 +6775,14 @@ int rtw89_fw_h2c_cxdrv_trx_v7(struct rtw89_dev *rtwdev, u8 type)
 int rtw89_fw_h2c_cxdrv_trx_v9(struct rtw89_dev *rtwdev, u8 type)
 {
 	struct rtw89_btc *btc = &rtwdev->btc;
-	struct rtw89_btc_rf_trx_para_v9 rf_para = btc->dm.rf_trx_para;
 	struct rtw89_btc_trx_info *trx = &btc->dm.trx_info;
-	struct rtw89_btc_wl_info *wl = &btc->cx.wl;
 	struct rtw89_h2c_cxtrx_v9 *h2c;
 	u32 len = sizeof(*h2c);
 	struct sk_buff *skb;
 	int ret;
 	u8 i;
 
-	for (i = 0; i < RTW89_PHY_NUM; i++) {
-		trx->wl_tx_power[i] = u32_get_bits(rf_para.wl_tx_power[i],
-						   RTW89_BTC_WL_DEF_TX_PWR);
-		trx->wl_rx_gain[i] = u32_get_bits(rf_para.wl_rx_gain[i],
-						  RTW89_BTC_WL_DEF_TX_PWR);
-	}
-	for (i = 0; i < BTC_ALL_BT; i++) {
-		trx->bt_tx_power[i] = u32_get_bits(rf_para.bt_tx_power[i],
-						   RTW89_BTC_WL_DEF_TX_PWR);
-		trx->bt_rx_gain[i] = u32_get_bits(rf_para.bt_rx_gain[i],
-						  RTW89_BTC_WL_DEF_TX_PWR);
-		trx->zb_tx_power[i] = u32_get_bits(rf_para.zb_tx_power[i],
-						   RTW89_BTC_WL_DEF_TX_PWR);
-		trx->zb_rx_gain[i] = u32_get_bits(rf_para.zb_rx_gain[i],
-						  RTW89_BTC_WL_DEF_TX_PWR);
-	}
-	trx->cn = wl->cn_report;
-	trx->nhm = wl->nhm.pwr;
+	rtw89_btc_load_trx_para(rtwdev);
 
 	skb = rtw89_fw_h2c_alloc_skb_with_hdr(rtwdev, len);
 	if (!skb) {
@@ -6797,7 +6793,7 @@ int rtw89_fw_h2c_cxdrv_trx_v9(struct rtw89_dev *rtwdev, u8 type)
 	h2c = (struct rtw89_h2c_cxtrx_v9 *)skb->data;
 
 	h2c->hdr.type = type;
-	h2c->hdr.ver = btc->ver->fcxtrx;
+	h2c->hdr.ver = 9;
 	h2c->hdr.len = sizeof(*h2c) - H2C_LEN_CXDRVHDR_V7;
 
 	h2c->v9_u8.tx_lvl = trx->tx_lvl;
@@ -6843,6 +6839,64 @@ int rtw89_fw_h2c_cxdrv_trx_v9(struct rtw89_dev *rtwdev, u8 type)
 	return ret;
 }
 
+int rtw89_fw_h2c_cxdrv_trx_v107(struct rtw89_dev *rtwdev, u8 type)
+{
+	struct rtw89_btc *btc = &rtwdev->btc;
+	struct rtw89_btc_trx_info *trx = &btc->dm.trx_info;
+	struct rtw89_h2c_cxtrx_v107 *h2c;
+	u32 len = sizeof(*h2c);
+	struct sk_buff *skb;
+	int ret;
+
+	rtw89_btc_load_trx_para(rtwdev);
+
+	skb = rtw89_fw_h2c_alloc_skb_with_hdr(rtwdev, len);
+	if (!skb) {
+		rtw89_err(rtwdev, "failed to alloc skb for h2c cxtrx_v107\n");
+		return -ENOMEM;
+	}
+	skb_put(skb, len);
+	h2c = (struct rtw89_h2c_cxtrx_v107 *)skb->data;
+
+	h2c->hdr.type = type;
+	h2c->hdr.ver = 7;
+	h2c->hdr.len = sizeof(*h2c) - H2C_LEN_CXDRVHDR_V7;
+
+	h2c->v107_u8.tx_lvl = trx->tx_lvl;
+	h2c->v107_u8.rx_lvl = trx->rx_lvl;
+	h2c->v107_u8.wl_rssi = trx->wl_rssi;
+	h2c->v107_u8.bt_rssi = trx->bt_rssi;
+	h2c->v107_u8.wl_tx_power = trx->bt_tx_power[RTW89_PHY_0];
+	h2c->v107_u8.wl_rx_gain = trx->wl_rx_gain[RTW89_PHY_0];
+	h2c->v107_u8.bt_tx_power = trx->bt_tx_power[BTC_BT_1ST];
+	h2c->v107_u8.bt_rx_gain = trx->bt_rx_gain[BTC_BT_1ST];
+	h2c->v107_u8.cn = trx->cn;
+	h2c->v107_u8.nhm = trx->nhm;
+	h2c->v107_u8.bt_profile = trx->bt_profile;
+	h2c->v107_u8.rsvd2 = trx->rsvd2;
+	h2c->v7_le.tx_rate = cpu_to_le16(trx->tx_rate);
+	h2c->v7_le.rx_rate = cpu_to_le16(trx->rx_rate);
+	h2c->v7_le.tx_tp = cpu_to_le32(trx->tx_tp);
+	h2c->v7_le.rx_tp = cpu_to_le32(trx->rx_tp);
+	h2c->v7_le.rx_err_ratio = cpu_to_le32(trx->rx_err_ratio);
+
+	rtw89_h2c_pkt_set_hdr(rtwdev, skb, FWCMD_TYPE_H2C,
+			      H2C_CAT_OUTSRC, BTFC_SET,
+			      SET_DRV_INFO, 0, 0, len);
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
 #define H2C_LEN_CXDRVINFO_RFK (4 + H2C_LEN_CXDRVHDR)
 int rtw89_fw_h2c_cxdrv_rfk(struct rtw89_dev *rtwdev, u8 type)
 {
@@ -6907,7 +6961,7 @@ int rtw89_fw_h2c_cxtxpwr_v7(struct rtw89_dev *rtwdev, u8 type)
 	h2c = (struct rtw89_h2c_cxtxpwr_v7 *)skb->data;
 
 	h2c->hdr.type = type;
-	h2c->hdr.ver = btc->ver->fcxtrx;
+	h2c->hdr.ver = 7;
 	h2c->hdr.len = sizeof(*h2c) - H2C_LEN_CXDRVHDR_V7;
 	h2c->pwr = rp.wl_tx_power[RTW89_PHY_0] & 0xff;
 
@@ -6947,7 +7001,7 @@ int rtw89_fw_h2c_cxtxpwr_v9(struct rtw89_dev *rtwdev, u8 type)
 	h2c = (struct rtw89_h2c_cxtxpwr_v9 *)skb->data;
 
 	h2c->hdr.type = type;
-	h2c->hdr.ver = btc->ver->fcxtrx;
+	h2c->hdr.ver = 9;
 	h2c->hdr.len = sizeof(*h2c) - H2C_LEN_CXDRVHDR_V7;
 	if (dm->wl_tx_pwr_phy_map == BIT(RTW89_PHY_1))
 		h2c->pwr = rp.wl_tx_power[RTW89_PHY_1] & 0xff;
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index a1aab8293c14..a36bb9f024ba 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -2517,6 +2517,23 @@ struct rtw89_btc_trx_info_v7_u8 {
 	u8 rsvd2;
 } __packed;
 
+struct rtw89_btc_trx_info_v107_u8 {
+	u8 tx_lvl;
+	u8 rx_lvl;
+	u8 wl_rssi;
+	u8 bt_rssi;
+
+	s8 wl_tx_power;
+	s8 wl_rx_gain;
+	s8 bt_tx_power;
+	s8 bt_rx_gain;
+
+	u8 cn;
+	s8 nhm;
+	u8 bt_profile;
+	u8 rsvd2;
+} __packed;
+
 struct rtw89_btc_trx_info_le {
 	__le16 tx_rate;
 	__le16 rx_rate;
@@ -2538,6 +2555,12 @@ struct rtw89_h2c_cxtrx_v7 {
 	struct rtw89_btc_trx_info_le v7_le;
 } __packed;
 
+struct rtw89_h2c_cxtrx_v107 {
+	struct rtw89_h2c_cxhdr_v7 hdr;
+	struct rtw89_btc_trx_info_v107_u8 v107_u8;
+	struct rtw89_btc_trx_info_le v7_le;
+} __packed;
+
 struct rtw89_h2c_cxtxpwr_v7 {
 	struct rtw89_h2c_cxhdr_v7 hdr;
 	u8 pwr;
@@ -5395,6 +5418,7 @@ int rtw89_fw_h2c_cxdrv_ctrl_v7(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_ctrl_v9(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_trx_v7(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_trx_v9(struct rtw89_dev *rtwdev, u8 type);
+int rtw89_fw_h2c_cxdrv_trx_v107(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_rfk(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxtxpwr_v7(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxtxpwr_v9(struct rtw89_dev *rtwdev, u8 type);
-- 
2.25.1

