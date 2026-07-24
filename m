Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA2C2E06D2
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 13:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784901441; cv=none; b=ZSmKlH0yajc3l/i4BTjzXEFFZP33TJOYAqFXpqbjmrCzHZmaKEeH5lvOBHT/OgwfOssGytRsCrqDcIHrYKIYyTkxcUX7QUkM2/yzP0nlkc8U7rvjvbHQIOxGkiXD1CINd6HXi9muvr00TfcdQmDrSwhV+oTDVJelJhyWNsXTRiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784901441; c=relaxed/simple;
	bh=SL1ByGvfyFwjHn62tuJc54KubxwU5oOWoDHPLk7NGcg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RUZUZH1l6KOMoNhwNIsxIG24mtRrsZVLVrK0KmBqM/hTiPHSUXeTE/SkjSz0lt/H0eVxxvdNS/TjZuQVtL3m/VOOCnIrQfIFDF5nroOihU+fZ8TkIC0XZmo2xUuORAZJiz35WxHf1VkwtojOgYgDtMl1TJG7RLElWs/WIt293iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=L2iX/Net; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="L2iX/Net"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66ODvHTT11179745, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784901437; bh=yrYVrrQNOHpAAqU/O01W4f581yuH8LG/XeUSxfUGZAg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=L2iX/NetpwOs43hT/taxeIb92DiYUu/gH63irYEozJe0PxosloX++nSOmkRBIi3yg
	 cV7Wlf8S3YfXGprR0DIus6ftElRwh47WJ6GVQuxfFnz+WnT7aSunIJJLOmWNjlAZBl
	 kaLD22SqM0e7ageQ29+Z0nWeYT2ibYleZ6U8rPZyn/73E/kN+kCnnzgWCxEb+TleD8
	 l1IoYm3PL0KE5SX+DEw81wNObSsJqwMxtsGHO5XcxqkmLjaaFCvybrjrxnsGufiUBX
	 K6bwDgfVxWzzeafBrD3TALaqXVAwFwPUYTAgzic+rDwi9VmRLYuZMr5u+UDqc0Ka2C
	 l+Rm1iWGf521g==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66ODvHTT11179745
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 21:57:17 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 21:57:17 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 21:57:17 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 07/14] wifi: rtw89: coex: complete GPIO debug configuration handler
Date: Fri, 24 Jul 2026 21:56:33 +0800
Message-ID: <20260724135640.3195044-8-pkshih@realtek.com>
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

Complete the implementation of _fw_set_gpio() function to support all
GPIO control configuration types for coexistence. Included debug signal,
antenna switch, external I2C mailbox, external PTA related GPIO
configuration. This function is called during initialization and when
BT re-enables.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 234 +++++++++++++++++++++-
 drivers/net/wireless/realtek/rtw89/coex.h |  35 ----
 drivers/net/wireless/realtek/rtw89/core.h | 162 ++++++++++++++-
 drivers/net/wireless/realtek/rtw89/fw.h   |  10 +
 4 files changed, 392 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index ae458917ecf7..96ec5fa20422 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -3206,6 +3206,212 @@ static void _fw_set_policy(struct rtw89_dev *rtwdev, u16 policy_type,
 		rtw89_set_coex_ctrl_lps(rtwdev, btc->btc_ctrl_lps);
 }
 
+static u8 _get_gpiosig_for_ver(struct rtw89_dev *rtwdev, u8 sig_v8)
+{
+	const struct rtw89_btc_ver *ver = rtwdev->btc.ver;
+
+	/* v8: gpio_ver >= 8, directly use v8 signal ID */
+	if (ver->fcxgpiodbg >= 8)
+		return sig_v8;
+
+	/* v7: gpio_ver < 8, convert v8 signal ID to v7 signal ID */
+	if (sig_v8 <= BTC_DBG_GNT_WL) {
+		return sig_v8;
+	} else if (sig_v8 <= BTC_DBG_GNT_WL1) {
+		rtw89_debug(rtwdev, RTW89_DBG_BTC,
+			    "[BTC], %s(): sig %d not supported in v7\n",
+			    __func__, sig_v8);
+		return BTC_DBG_NUM;
+	} else if (sig_v8 >= BTC_DBG_NUM) {
+		rtw89_debug(rtwdev, RTW89_DBG_BTC,
+			    "[BTC], %s(): sig %d not available\n",
+			    __func__, sig_v8);
+		return BTC_DBG_NUM;
+	} else {
+		return sig_v8 - 2;
+	}
+}
+
+static u32 _convert_gpio_enmap_to_ver(struct rtw89_dev *rtwdev, u32 en_map_v8)
+{
+	const struct rtw89_btc_ver *ver = rtwdev->btc.ver;
+	u32 en_map_v7 = 0;
+	u32 bit;
+
+	/* v8: gpio_ver >= 8, directly use v8 en_map */
+	if (ver->fcxgpiodbg >= 8)
+		return en_map_v8;
+
+	/* v7: gpio_ver < 8, convert v8 en_map bitmap to v7 en_map bitmap */
+	/* bit 0-1: GNT_BT, GNT_WL - same position in both versions */
+	en_map_v7 |= en_map_v8 & GENMASK(1, 0);
+
+	/* bit 2-3: GNT_BT1, GNT_WL1 - not supported in v7, skip these bits */
+
+	/* bit 4-31: shift right by 2 positions (become bit 2-29 in v7) */
+	for (bit = BTC_DBG_BCN_EARLY; bit < BTC_DBG_NUM; bit++) {
+		if (en_map_v8 & BIT(bit))
+			en_map_v7 |= BIT(bit - 2);
+	}
+
+	return en_map_v7;
+}
+
+static u32 _convert_gpio_enmap_from_ver(struct rtw89_dev *rtwdev, u32 en_map)
+{
+	const struct rtw89_btc_ver *ver = rtwdev->btc.ver;
+	u32 en_map_v8 = 0;
+	u32 bit;
+
+	if (ver->fcxgpiodbg >= 8)
+		return en_map;
+
+	/* bit 0-1: GNT_BT, GNT_WL - same position in both versions */
+	en_map_v8 |= en_map & GENMASK(1, 0);
+
+	/* bit 2-29: shift left by 2 positions (become bit 4-31 in v8) */
+	for (bit = BTC_DBG_GNT_BT1; bit < BTC_DBG_NUM - 2; bit++) {
+		if (en_map & BIT(bit))
+			en_map_v8 |= BIT(bit + 2);
+	}
+
+	return en_map_v8;
+}
+
+static void _fw_set_gpio(struct rtw89_dev *rtwdev, u8 type, u32 val)
+{
+	struct rtw89_btc *btc = &rtwdev->btc;
+	struct rtw89_fbtc_h2c_set_gpio *gpio = &btc->gpio;
+	const struct rtw89_btc_ver *ver = btc->ver;
+	struct rtw89_fbtc_h2c_set_gpio_2b l2_h2c;
+	struct rtw89_fbtc_h2c_set_gpio_4b l4_h2c;
+	u8 gpio_ver = ver->fcxgpiodbg;
+	u8 buf[sizeof(l4_h2c)];
+	u8 len;
+
+	if (gpio_ver < 8 && type > CXDGPIO_MUX_MAP)
+		return;
+
+	if (type >= CXDGPIO_MAX)
+		return;
+
+	switch (type) {
+	case CXDGPIO_EN_MAP: /* GPIO debug signal en-map 0~31 */
+		val = _convert_gpio_enmap_to_ver(rtwdev, val);
+		gpio->en_map.data.type = CXDGPIO_EN_MAP;
+		gpio->en_map.data.fver = gpio_ver;
+		gpio->en_map.data.dlen = CXDGPIO_SET_L4;
+		gpio->en_map.data.en_map = val;
+		l4_h2c = gpio->en_map.fmt;
+		put_unaligned_le32(val, (u32 *)l4_h2c.data);
+		memcpy(buf, &l4_h2c, sizeof(l4_h2c));
+		len = sizeof(l4_h2c);
+		break;
+	case CXDGPIO_MUX_MAP: /* GPIO dbg: Signal to GPIO Mux */
+		gpio->mux.data.type = CXDGPIO_MUX_MAP;
+		gpio->mux.data.fver = gpio_ver;
+		gpio->mux.data.dlen = CXDGPIO_SET_L2;
+		gpio->mux.data.sig = _get_gpiosig_for_ver(rtwdev,
+							  FIELD_GET(GENMASK(7, 0), val));
+		if (gpio->mux.data.sig == 0xff)
+			return;
+		gpio->mux.data.gpio = FIELD_GET(GENMASK(15, 8), val);
+		l2_h2c = gpio->mux.fmt;
+		memcpy(buf, &l2_h2c, sizeof(l2_h2c));
+		len = sizeof(l2_h2c);
+		break;
+	case CXDGPIO_EXT_HPTA: /* GPIO config for Ext HW-PTA */
+		gpio->ext_pta.data.type = CXDGPIO_EXT_HPTA;
+		gpio->ext_pta.data.fver = gpio_ver;
+		gpio->ext_pta.data.dlen = CXDGPIO_SET_L2;
+		gpio->ext_pta.data.map_low = FIELD_GET(GENMASK(7, 0), val);
+		gpio->ext_pta.data.map_high = FIELD_GET(GENMASK(15, 8), val);
+		l2_h2c = gpio->ext_pta.fmt;
+		memcpy(buf, &l2_h2c, sizeof(l2_h2c));
+		len = sizeof(l2_h2c);
+		break;
+	case CXDGPIO_EXT_HMBX: /* GPIO config for Ext HW-mailbox */
+		gpio->ext_mb.data.type = CXDGPIO_EXT_HMBX;
+		gpio->ext_mb.data.fver = gpio_ver;
+		gpio->ext_mb.data.dlen = CXDGPIO_SET_L2;
+		gpio->ext_mb.data.map_low = FIELD_GET(GENMASK(7, 0), val);
+		gpio->ext_mb.data.map_high = FIELD_GET(GENMASK(15, 8), val);
+		l2_h2c = gpio->ext_mb.fmt;
+		memcpy(buf, &l2_h2c, sizeof(l2_h2c));
+		len = sizeof(l2_h2c);
+		break;
+	case CXDGPIO_EXT_SWOUT: /* GPIO config for Ext SW output (wlan_act) */
+		gpio->ext_swout.data.type = CXDGPIO_EXT_SWOUT;
+		gpio->ext_swout.data.fver = gpio_ver;
+		gpio->ext_swout.data.dlen = CXDGPIO_SET_L2;
+		gpio->ext_swout.data.map_low = FIELD_GET(GENMASK(7, 0), val);
+		gpio->ext_swout.data.map_high = FIELD_GET(GENMASK(15, 8), val);
+		l2_h2c = gpio->ext_swout.fmt;
+		memcpy(buf, &l2_h2c, sizeof(l2_h2c));
+		len = sizeof(l2_h2c);
+		break;
+	case CXDGPIO_EXT_SWIN: /* GPIO config for Ext SW input control */
+		gpio->ext_swin.data.type = CXDGPIO_EXT_SWIN;
+		gpio->ext_swin.data.fver = gpio_ver;
+		gpio->ext_swin.data.dlen = CXDGPIO_SET_L4;
+		gpio->ext_swin.data.in_map_low = FIELD_GET(GENMASK(7, 0), val);
+		gpio->ext_swin.data.in_map_high = FIELD_GET(GENMASK(15, 8), val);
+		gpio->ext_swin.data.int_map_low = FIELD_GET(GENMASK(23, 16), val);
+		gpio->ext_swin.data.int_map_high = FIELD_GET(GENMASK(31, 24), val);
+		l4_h2c = gpio->ext_swin.fmt;
+		put_unaligned_le32(val, (u32 *)l4_h2c.data);
+		memcpy(buf, &l4_h2c, sizeof(l4_h2c));
+		len = sizeof(l4_h2c);
+		break;
+	default:
+		return;
+	}
+
+	_send_fw_cmd(rtwdev, BTFC_SET, SET_GPIO_DBG, buf, len);
+}
+
+static void _set_ext_interface(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_btc *btc = &rtwdev->btc;
+	struct rtw89_btc_cx *cx = &btc->cx;
+	u8 bt1_sw_type = BTC_SWITCH_INTERNAL;
+	u32 val;
+
+	if (btc->ver->fcxgpiodbg < 7)
+		return;
+
+	/* if BT1+WL-S0, route DBG_GNT_BT1 to control SPDT */
+	if ((rtwdev->chip->para_ver & BTC_FEAT_DUAL_BT) &&
+	    btc->ver->fcxinit >= 10) {
+		if (btc->ver->fcxinit >= 10)
+			bt1_sw_type = btc->mdinfo.bt1_sw_type;
+		else
+			return;
+
+		if (bt1_sw_type > BTC_SWITCH_INTERNAL) {
+			_fw_set_gpio(rtwdev, CXDGPIO_EN_MAP,
+				     BIT(BTC_DBG_GNT_BT1));
+
+			val = (bt1_sw_type << 8) + BTC_DBG_GNT_BT1;
+			_fw_set_gpio(rtwdev, CXDGPIO_MUX_MAP, val);
+		}
+	}
+
+	/* set GPIO as Ext-PTA interface wire */
+	if (cx->bt_ext.hw_coex & BTC_EXTSOC_INTF_PTA)
+		_fw_set_gpio(rtwdev, CXDGPIO_EXT_HPTA, cx->bt_ext.hpta_cfg);
+
+	/* set GPIO as Ext-mailbox interface wire */
+	if (cx->bt_ext.hw_coex & BTC_EXTSOC_INTF_MBX)
+		_fw_set_gpio(rtwdev, CXDGPIO_EXT_HMBX, cx->bt_ext.hmbx_cfg);
+
+	/* set GPIO as Ext-SWIO interface wire */
+	if (cx->bt_ext.hw_coex & BTC_EXTSOC_INTF_SWIO) {
+		_fw_set_gpio(rtwdev, CXDGPIO_EXT_SWOUT, cx->bt_ext.swout_cfg);
+		_fw_set_gpio(rtwdev, CXDGPIO_EXT_SWIN, cx->bt_ext.swin_cfg);
+	}
+}
+
 static void _fw_set_drv_info(struct rtw89_dev *rtwdev, u8 index)
 {
 	struct rtw89_btc *btc = &rtwdev->btc;
@@ -8251,6 +8457,7 @@ static void _set_init_info(struct rtw89_dev *rtwdev)
 	_fw_set_drv_info(rtwdev, CXDRVINFO_CTRL);
 	rtw89_btc_fw_set_slots(rtwdev);
 	btc_fw_set_monreg(rtwdev);
+	_set_ext_interface(rtwdev);
 	_set_wl_tx_power(rtwdev, RTW89_BTC_WL_DEF_TX_PWR, RTW89_PHY_0);
 }
 
@@ -9779,6 +9986,8 @@ static const char *id_to_gdbg(u32 id)
 	switch (id) {
 	CASE_BTC_GDBG_STR(GNT_BT);
 	CASE_BTC_GDBG_STR(GNT_WL);
+	CASE_BTC_GDBG_STR(GNT_BT1);
+	CASE_BTC_GDBG_STR(GNT_WL1);
 	CASE_BTC_GDBG_STR(BCN_EARLY);
 	CASE_BTC_GDBG_STR(WL_NULL0);
 	CASE_BTC_GDBG_STR(WL_NULL1);
@@ -9807,8 +10016,6 @@ static const char *id_to_gdbg(u32 id)
 	CASE_BTC_GDBG_STR(SLOT_B1FDD);
 	CASE_BTC_GDBG_STR(BT_CHANGE);
 	CASE_BTC_GDBG_STR(WL_CCA);
-	CASE_BTC_GDBG_STR(BT_LEAUDIO);
-	CASE_BTC_GDBG_STR(USER_DEF);
 	default:
 		return "unknown";
 	}
@@ -11487,8 +11694,8 @@ static int _show_gpio_dbg(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 	struct rtw89_btc_rpt_cmn_info *pcinfo = NULL;
 	union rtw89_btc_fbtc_gpio_dbg *gdbg = NULL;
 	char *p = buf, *end = buf + bufsz;
-	u8 *gpio_map, i;
-	u32 en_map;
+	u32 en_map_raw, en_map;
+	u8 *gpio_map, i, sig;
 
 	pcinfo = &pfwinfo->rpt_fbtc_gpio_dbg.cinfo;
 	gdbg = &rtwdev->btc.fwinfo.rpt_fbtc_gpio_dbg.finfo;
@@ -11499,27 +11706,32 @@ static int _show_gpio_dbg(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		goto out;
 	}
 
-	if (ver->fcxgpiodbg == 7) {
-		en_map = le32_to_cpu(gdbg->v7.en_map);
+	if (ver->fcxgpiodbg == 7 || ver->fcxgpiodbg == 8) {
+		en_map_raw = le32_to_cpu(gdbg->v7.en_map);
 		gpio_map = gdbg->v7.gpio_map;
 	} else {
-		en_map = le32_to_cpu(gdbg->v1.en_map);
+		en_map_raw = le32_to_cpu(gdbg->v1.en_map);
 		gpio_map = gdbg->v1.gpio_map;
 	}
 
+	en_map = _convert_gpio_enmap_from_ver(rtwdev, en_map_raw);
 	if (!en_map)
 		goto out;
 
-	p += scnprintf(p, end - p, " %-15s : enable_map:0x%08x",
+	p += scnprintf(p, end - p, "\n\r %-15s : enable_map:0x%08x",
 		       "[gpio_dbg]", en_map);
 
-	for (i = 0; i < BTC_DBG_MAX1; i++) {
+	for (i = 0; i < BTC_DBG_NUM; i++) {
 		if (!(en_map & BIT(i)))
 			continue;
+
+		sig = ver->fcxgpiodbg >= 8 ? i : _get_gpiosig_for_ver(rtwdev, i);
+		if (sig >= BTC_DBG_NUM)
+			continue;
+
 		p += scnprintf(p, end - p, ", %s->GPIO%d", id_to_gdbg(i),
-			       gpio_map[i]);
+			       gpio_map[sig]);
 	}
-	p += scnprintf(p, end - p, "\n");
 
 out:
 	return p - buf;
diff --git a/drivers/net/wireless/realtek/rtw89/coex.h b/drivers/net/wireless/realtek/rtw89/coex.h
index 355784941edd..3e9e1510c44f 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.h
+++ b/drivers/net/wireless/realtek/rtw89/coex.h
@@ -315,41 +315,6 @@ enum btc_mlo_rf_combin {
 	BTC_MLO_RF_2_PLUS_2 = 3,
 };
 
-enum btc_wl_gpio_debug {
-	BTC_DBG_GNT_BT = 0,
-	BTC_DBG_GNT_WL = 1,
-	BTC_DBG_BCN_EARLY = 2,
-	BTC_DBG_WL_NULL0 = 3,
-	BTC_DBG_WL_NULL1 = 4,
-	BTC_DBG_WL_RXISR = 5,
-	BTC_DBG_TDMA_ENTRY = 6,
-	BTC_DBG_A2DP_EMPTY = 7,
-	BTC_DBG_BT_RETRY = 8,
-	BTC_DBG_BT_RELINK = 9,
-	BTC_DBG_SLOT_WL = 10,
-	BTC_DBG_SLOT_BT = 11,
-	BTC_DBG_WL_ERR = 12,
-	BTC_DBG_WL_OK = 13,
-	BTC_DBG_SLOT_B2W = 14,
-	BTC_DBG_SLOT_W1 = 15,
-	BTC_DBG_SLOT_W2 = 16,
-	BTC_DBG_SLOT_W2B = 17,
-	BTC_DBG_SLOT_B1 = 18,
-	BTC_DBG_SLOT_B2 = 19,
-	BTC_DBG_SLOT_B3 = 20,
-	BTC_DBG_SLOT_B4 = 21,
-	BTC_DBG_SLOT_LK = 22,
-	BTC_DBG_SLOT_E2G = 23,
-	BTC_DBG_SLOT_E5G = 24,
-	BTC_DBG_SLOT_EBT = 25,
-	BTC_DBG_SLOT_WLK = 26,
-	BTC_DBG_SLOT_B1FDD = 27,
-	BTC_DBG_BT_CHANGE = 28,
-	BTC_DBG_WL_CCA = 29,
-	BTC_DBG_BT_LEAUDIO = 30,
-	BTC_DBG_USER_DEF = 31,
-};
-
 void rtw89_btc_init(struct rtw89_dev *rtwdev);
 void rtw89_btc_ntfy_poweron(struct rtw89_dev *rtwdev);
 void rtw89_btc_ntfy_poweroff(struct rtw89_dev *rtwdev);
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 0ec63f9510bd..ba3a9b0d4aa2 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -3074,14 +3074,55 @@ enum rtw89_btc_afh_map_type { /*AFH MAP TYPE */
 	RPT_BT_AFH_SEQ_LE = 0x20
 };
 
-#define BTC_DBG_MAX1  32
+enum btc_wl_gpio_debug {
+	BTC_DBG_GNT_BT = 0,
+	BTC_DBG_GNT_WL = 1,
+	BTC_DBG_GNT_BT1 = 2,
+	BTC_DBG_GNT_WL1 = 3,
+	/* The following signals should 0-1 tiggle by each function-call */
+	BTC_DBG_BCN_EARLY = 4,
+	BTC_DBG_WL_NULL0 = 5,
+	BTC_DBG_WL_NULL1 = 6,
+	BTC_DBG_WL_RXISR = 7,
+	BTC_DBG_TDMA_ENTRY = 8,
+	BTC_DBG_A2DP_EMPTY = 9,
+	BTC_DBG_BT_RETRY = 10,
+	/* The following signals should 0-1 tiggle by state L/H */
+	BTC_DBG_BT_RELINK = 11,
+	BTC_DBG_SLOT_WL = 12,
+	BTC_DBG_SLOT_BT = 13,
+	/* The following signals should 0-1 tiggle by external*/
+	BTC_DBG_WL_ERR = 14,
+	BTC_DBG_WL_OK = 15,
+	/* The following signals appear only 1-active at same time*/
+	BTC_DBG_SLOT_B2W = 16,
+	BTC_DBG_SLOT_W1 = 17,
+	BTC_DBG_SLOT_W2 = 18,
+	BTC_DBG_SLOT_W2B = 19,
+	BTC_DBG_SLOT_B1 = 20,
+	BTC_DBG_SLOT_B2 = 21,
+	BTC_DBG_SLOT_B3 = 22,
+	BTC_DBG_SLOT_B4 = 23,
+	BTC_DBG_SLOT_LK = 24,
+	BTC_DBG_SLOT_E2G = 25,
+	BTC_DBG_SLOT_E5G = 26,
+	BTC_DBG_SLOT_EBT = 27,
+	BTC_DBG_SLOT_WLK = 28,
+	BTC_DBG_SLOT_B1FDD = 29,
+	BTC_DBG_BT_CHANGE = 30,
+	/* The following signals should 0-1 tiggle by external*/
+	BTC_DBG_WL_CCA = 31,
+
+	BTC_DBG_NUM,
+};
+
 struct rtw89_btc_fbtc_gpio_dbg_v1 {
 	u8 fver; /* btc_ver::fcxgpiodbg */
 	u8 rsvd;
 	__le16 rsvd2;
 	__le32 en_map; /* which debug signal (see btc_wl_gpio_debug) is enable */
 	__le32 pre_state; /* the debug signal is 1 or 0  */
-	u8 gpio_map[BTC_DBG_MAX1]; /*the debug signals to GPIO-Position */
+	u8 gpio_map[BTC_DBG_NUM]; /*the debug signals to GPIO-Position */
 } __packed;
 
 struct rtw89_btc_fbtc_gpio_dbg_v7 {
@@ -3090,7 +3131,7 @@ struct rtw89_btc_fbtc_gpio_dbg_v7 {
 	u8 rsvd1;
 	u8 rsvd2;
 
-	u8 gpio_map[BTC_DBG_MAX1];
+	u8 gpio_map[BTC_DBG_NUM];
 
 	__le32 en_map;
 	__le32 pre_state;
@@ -3101,6 +3142,120 @@ union rtw89_btc_fbtc_gpio_dbg {
 	struct rtw89_btc_fbtc_gpio_dbg_v7 v7;
 };
 
+/*
+ * SET_GPIO_CTRL payload (max len = 7 bytes)
+ *
+ * type = CXDGPIO_EN_MAP
+ *   data.val[31:0] = debug signal enable map
+ *
+ * type = CXDGPIO_MUX_MAP
+ *   data.mux.sig  = debug signal id
+ *   data.mux.gpio = GPIO id
+ *
+ * type = CXDGPIO_EXT_HPTA / CXDGPIO_EXT_HMBX / CXDGPIO_EXT_SWOUT
+ *   data.map.map_low  = GPIO 7~0 map
+ *   data.map.map_high = GPIO 15~8 map
+ *
+ * type = CXDGPIO_EXT_SWIN
+ *   data.swin.in_map_low  = GPIO 7~0 input-en-map
+ *   data.swin.in_map_high = GPIO 15~8 input-en-map
+ *   data.swin.int_map_low = GPIO 7~0 interrupt source map
+ *   data.swin.int_map_high = GPIO 15~8 interrupt source map
+ */
+#define CXDGPIO_SET_L4 4
+#define CXDGPIO_SET_L2 2
+struct rtw89_fbtc_h2c_set_gpio_en_map {
+	u8 type; /* gpio_type */
+	u8 fver; /* FCX_VER_GPIODBG */
+	u8 dlen;
+	u32 en_map;
+};
+
+struct rtw89_fbtc_h2c_set_gpio_mux {
+	u8 type; /* gpio_type */
+	u8 fver; /* FCX_VER_GPIODBG */
+	u8 dlen;
+	u8 sig;
+	u8 gpio;
+};
+
+struct rtw89_fbtc_h2c_set_gpio_ext_pta {
+	u8 type; /* gpio_type */
+	u8 fver; /* FCX_VER_GPIODBG */
+	u8 dlen;
+	u8 map_low;
+	u8 map_high;
+};
+
+struct rtw89_fbtc_h2c_set_gpio_ext_mb {
+	u8 type; /* gpio_type */
+	u8 fver; /* FCX_VER_GPIODBG */
+	u8 dlen;
+	u8 map_low;
+	u8 map_high;
+};
+
+struct rtw89_fbtc_h2c_set_gpio_ext_swout {
+	u8 type; /* gpio_type */
+	u8 fver; /* FCX_VER_GPIODBG */
+	u8 dlen;
+	u8 map_low;
+	u8 map_high;
+};
+
+struct rtw89_fbtc_h2c_set_gpio_ext_swin {
+	u8 type; /* gpio_type */
+	u8 fver; /* FCX_VER_GPIODBG */
+	u8 dlen;
+	u8 in_map_low;
+	u8 in_map_high;
+	u8 int_map_low;
+	u8 int_map_high;
+};
+
+struct rtw89_fbtc_h2c_set_gpio_2b {
+	u8 type; /* gpio_type */
+	u8 fver; /* FCX_VER_GPIODBG */
+	u8 dlen;
+	u8 data[CXDGPIO_SET_L2];
+} __packed;
+
+struct rtw89_fbtc_h2c_set_gpio_4b {
+	u8 type; /* gpio_type */
+	u8 fver; /* FCX_VER_GPIODBG */
+	u8 dlen;
+	u8 data[CXDGPIO_SET_L4];
+} __packed;
+
+union rtw89_fbtc_h2c_set_gpio_en_map_u {
+	struct rtw89_fbtc_h2c_set_gpio_4b fmt;
+	struct rtw89_fbtc_h2c_set_gpio_en_map data;
+};
+
+union rtw89_fbtc_h2c_set_gpio_mux_u {
+	struct rtw89_fbtc_h2c_set_gpio_2b fmt;
+	struct rtw89_fbtc_h2c_set_gpio_mux data;
+};
+
+union rtw89_fbtc_h2c_set_gpio_ext_pta_u {
+	struct rtw89_fbtc_h2c_set_gpio_2b fmt;
+	struct rtw89_fbtc_h2c_set_gpio_ext_pta data;
+};
+
+union rtw89_fbtc_h2c_set_gpio_ext_swin_u {
+	struct rtw89_fbtc_h2c_set_gpio_4b fmt;
+	struct rtw89_fbtc_h2c_set_gpio_ext_swin data;
+};
+
+struct rtw89_fbtc_h2c_set_gpio {
+	union rtw89_fbtc_h2c_set_gpio_en_map_u en_map;
+	union rtw89_fbtc_h2c_set_gpio_mux_u mux;
+	union rtw89_fbtc_h2c_set_gpio_ext_pta_u ext_pta;
+	union rtw89_fbtc_h2c_set_gpio_ext_pta_u ext_mb;
+	union rtw89_fbtc_h2c_set_gpio_ext_pta_u ext_swout;
+	union rtw89_fbtc_h2c_set_gpio_ext_swin_u ext_swin;
+};
+
 struct rtw89_btc_fbtc_mreg_val_v1 {
 	u8 fver; /* btc_ver::fcxmreg */
 	u8 reg_num;
@@ -4178,6 +4333,7 @@ struct rtw89_btc {
 	struct rtw89_btc_module mdinfo;
 	struct rtw89_btc_btf_fwinfo fwinfo;
 	struct rtw89_btc_dbg dbg;
+	struct rtw89_fbtc_h2c_set_gpio gpio;
 
 	struct wiphy_work eapol_notify_work;
 	struct wiphy_work arp_notify_work;
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index 538df0fb42cc..6147960521ee 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -2391,6 +2391,16 @@ enum rtw89_btc_cxdrvinfo {
 	CXDRVINFO_MAX,
 };
 
+enum rtw89_fbtc_gpio_type {
+	CXDGPIO_EN_MAP = 0x0,
+	CXDGPIO_MUX_MAP = 0x1,
+	CXDGPIO_EXT_HPTA = 0x2,
+	CXDGPIO_EXT_HMBX = 0x3,
+	CXDGPIO_EXT_SWOUT = 0x4,
+	CXDGPIO_EXT_SWIN = 0x5,
+	CXDGPIO_MAX,
+};
+
 enum rtw89_scan_mode {
 	RTW89_SCAN_IMMEDIATE,
 	RTW89_SCAN_DELAY,
-- 
2.25.1

