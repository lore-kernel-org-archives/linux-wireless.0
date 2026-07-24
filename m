Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265712FFDFC
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 13:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784901411; cv=none; b=Q1WumReSHjAswBvxNWUVUsyMtJuzvldDY0nfP9lBtXJusa/+3HZKLgKL78FKGSadZjRNFLvZTguCFJdFBq1FAL/oJpCiyFDvzASbMQ9r/50n5+EJG7XVTDe8kCvvrbKOWlHCc/kGBtGX0YhSYDlRF3V+jNzjiMaG2Dv8qh2K5i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784901411; c=relaxed/simple;
	bh=jPX/EHpiozktxBekUlhB3yoOjmZ2f4JNpUp65GU8fHs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AOdy7wj3gIugfPhTZfn+p2zgPQOOpwP5Tbwdc4BHFoCYKJCRpswqyo2RyOq8pz9AuzJV+Jyhc0sCPOdR5hqhsmKQcP/SUEIt31OcJtcLSMM2ZeGVoNO5gyisHlB/BYBT+X8MxtSgsPPvJWJNcVCuGtf3K12Tpx0thBTM1s3ByNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=XszcDYlo; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="XszcDYlo"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66ODukhhF1179662, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784901406; bh=1mF6k9Z8c8oj8cMUjxTGlYx/CAWxK321V+k4s30Vw4s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=XszcDYlo1P4Mf2VAe5rm196IrVBKoRVLAgwGME99OOH9wWrvJeOei8OfKrBeJxz61
	 w8/3/xGDlCy8DaXUAZ21USeY5Roj6D8PvnP4cmTEsRqT022XIECc6IL5fy4P7QE4nw
	 mJkaUcIlLO6xTcwrQIQL6m5hFYzbKFDvC2alfsjwzfnkIHCtWAhfbmolgFZeJe1DH5
	 27+gCR1JsspNaxW76xXVuBNZDRJIuxo4e18hotrXJUZg2nkRMh6FedXte23ebNxMUy
	 9yKJYOUckBQvbp4VJEDzLcOWRtXZSvhsoEWGQLhVdOXE7k09su/Jj9Be7bfwSBtV6c
	 n07ic6BTf+dug==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66ODukhhF1179662
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 21:56:46 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 21:56:46 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 21:56:46 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 21:56:46 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 01/14] wifi: rtw89: coex: Add chip initial info version 11 for RTL8922A/D
Date: Fri, 24 Jul 2026 21:56:27 +0800
Message-ID: <20260724135640.3195044-2-pkshih@realtek.com>
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

The version 11 init info add current RF path control information.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c     |  2 +
 drivers/net/wireless/realtek/rtw89/coex.h     | 19 ++++
 drivers/net/wireless/realtek/rtw89/core.h     | 47 ++++++++++
 drivers/net/wireless/realtek/rtw89/fw.c       | 75 ++++++++++++++++
 drivers/net/wireless/realtek/rtw89/fw.h       |  6 ++
 drivers/net/wireless/realtek/rtw89/rtw8922a.c | 88 ++++++++++++++++---
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 40 ++++++---
 7 files changed, 251 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 6a1888d8c476..f94866e1f43a 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -3199,6 +3199,8 @@ static void _fw_set_drv_info(struct rtw89_dev *rtwdev, u8 index)
 			rtw89_fw_h2c_cxdrv_init_v7(rtwdev, index);
 		else if (ver->fcxinit == 10)
 			rtw89_fw_h2c_cxdrv_init_v10(rtwdev, index);
+		else if (ver->fcxinit == 11)
+			rtw89_fw_h2c_cxdrv_init_v11(rtwdev, index);
 		else
 			rtw89_fw_h2c_cxdrv_init(rtwdev, index);
 		break;
diff --git a/drivers/net/wireless/realtek/rtw89/coex.h b/drivers/net/wireless/realtek/rtw89/coex.h
index 3238c44429a9..41a68ab21d80 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.h
+++ b/drivers/net/wireless/realtek/rtw89/coex.h
@@ -127,6 +127,11 @@ enum btc_fddt_en {
 	  ((__rssi == BTC_RSSI_ST_LOW || \
 	    __rssi == BTC_RSSI_ST_HIGH) ? 1 : 0); })
 
+/* Antenna TX/RX path position masks and helpers */
+#define BTC_ANT_TX_MASK 0xf0
+#define BTC_ANT_RX_MASK 0x0f
+#define BTC_ANT_SHIFT 4
+
 enum btc_ant {
 	BTC_ANT_SHARED = 0,
 	BTC_ANT_DEDICATED,
@@ -473,4 +478,18 @@ void btc_dw2b(u8 *buf, size_t idx, u32 val)
 	buf[idx + 3] = u32_get_bits(val, MASKBYTE3);
 }
 
+static inline
+u8 _btc_get_rf_path_from_ant_num(struct rtw89_btc *btc, u8 antnum)
+{
+	switch (antnum) {
+	default:
+	case 1:
+		return btc->mdinfo.ant.single_pos;
+	case 2:
+		return RF_PATH_AB;
+	case 3:
+		return RF_PATH_ABC;
+	}
+}
+
 #endif
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 7573f1965c98..7147e186b4a5 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -1537,6 +1537,21 @@ struct rtw89_btc_ant_info_v10 {
 	u8 ant_xmap[2][4];
 } __packed;
 
+struct rtw89_btc_ant_info_v11 {
+	u8 type;
+	u8 num;
+	u8 isolation;
+	u8 single_pos;
+
+	u8 stream_cnt;
+	u8 path_pos;   /* WL path position: Tx[7:4], Rx[3:0] */
+	u8 btg_pos;
+	u8 btg1_pos;
+	u8 func[5];
+	u8 ant_xmap[2][4];
+	u8 rsvd0[3];
+} __packed;
+
 struct rtw89_btc_ant_info {
 	u8 type;  /* shared, dedicated(non-shared) */
 	u8 num;   /* antenna count  */
@@ -1546,6 +1561,7 @@ struct rtw89_btc_ant_info {
 	u8 stream_cnt; /* spatial_stream count: Tx[7:4], Rx[3:0] */
 	u8 btg_pos;    /* BT0 btg-circuit at 0:WL-S0/1:WL-S1 */
 	u8 btg1_pos;   /* BT1 btg-circuit at 0:WL-S0/1:WL-S1 */
+	u8 path_pos;   /* WL path position: Tx[7:4], Rx[3:0] */
 	u8 func[5]; /* function at 1~5 Ant refer to enum btc_bt_func_type */
 	u8 ant_xmap[2][4];
 
@@ -2387,10 +2403,25 @@ struct rtw89_btc_module_v10 {
 	struct rtw89_btc_ant_info_v10 ant;
 } __packed;
 
+struct rtw89_btc_module_v11 {
+	u8 rfe_type;
+	u8 wa_type;
+	u8 kt_ver;
+	u8 kt_ver_adie;
+
+	u8 bt0_pos;
+	u8 bt0_sw_type;
+	u8 bt1_pos;
+	u8 bt1_sw_type;
+
+	struct rtw89_btc_ant_info_v11 ant;
+} __packed;
+
 union rtw89_btc_module_info {
 	struct rtw89_btc_module_v0 md_v0;
 	struct rtw89_btc_module_v7 md_v7;
 	struct rtw89_btc_module_v10 md_v10;
+	struct rtw89_btc_module_v11 md_v11;
 };
 
 struct rtw89_btc_module {
@@ -2473,11 +2504,26 @@ struct rtw89_btc_init_info_v10 {
 	struct rtw89_btc_module_v10 module;
 } __packed;
 
+struct rtw89_btc_init_info_v11 {
+	u8 endian_type; /* 0: little-endian, 1:big-endian */
+	u8 init_mode; /* refer to enum BTC_MODE_xxx  */
+	u8 wl_init_ok;
+	u8 bt0_function;
+
+	u8 bt1_function;
+	u8 bt2_function;
+	u8 pta_mode;
+	u8 pta_direction;
+
+	struct rtw89_btc_module_v11 module;
+};
+
 union rtw89_btc_init_info_u {
 	struct rtw89_btc_init_info_v0 init_v0;
 	struct rtw89_btc_init_info_v7 init_v7;
 	struct rtw89_btc_init_info_v10 init_v10;
 	struct rtw89_btc_init_info_v107 init_v107;
+	struct rtw89_btc_init_info_v11 init_v11;
 };
 
 struct rtw89_btc_init_info {
@@ -2547,6 +2593,7 @@ enum rtw89_btc_bt_func_type {
 #define RTW89_BTC_BT_DEF_BR_TX_PWR 4
 #define RTW89_BTC_BT_DEF_LE_TX_PWR 4
 #define RTW89_BTC_DEFAULT_ANISO 10
+#define RTW89_BTC_BT_DEF_LE_TX_PWR_1 10
 
 struct rtw89_btc_bt_scan_info_v1 {
 	__le16 win;
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 3b8c144e0e98..a3a04697e2e6 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -5973,6 +5973,81 @@ int rtw89_fw_h2c_cxdrv_init_v10(struct rtw89_dev *rtwdev, u8 type)
 	return ret;
 }
 
+int rtw89_fw_h2c_cxdrv_init_v11(struct rtw89_dev *rtwdev, u8 type)
+{
+	struct rtw89_btc *btc = &rtwdev->btc;
+	struct rtw89_btc_dm *dm = &btc->dm;
+	struct rtw89_btc_init_info *init = &dm->init_info;
+	struct rtw89_h2c_cxinit_v11 *h2c;
+	u32 len = sizeof(*h2c);
+	struct sk_buff *skb;
+	int ret;
+
+	skb = rtw89_fw_h2c_alloc_skb_with_hdr(rtwdev, len);
+	if (!skb) {
+		rtw89_err(rtwdev, "failed to alloc skb for h2c cxdrv_init_v11\n");
+		return -ENOMEM;
+	}
+	skb_put(skb, len);
+	h2c = (struct rtw89_h2c_cxinit_v11 *)skb->data;
+
+	h2c->hdr.type = type;
+	h2c->hdr.ver = 11;
+	h2c->hdr.len = len - H2C_LEN_CXDRVHDR_V7;
+
+	h2c->init.endian_type = init->endian_type;
+	h2c->init.init_mode = init->init_mode;
+	h2c->init.wl_init_ok = init->wl_init_ok;
+	h2c->init.bt0_function = init->bt0_function;
+
+	h2c->init.bt1_function = init->bt1_function;
+	h2c->init.bt2_function = init->bt2_function;
+	h2c->init.pta_mode = init->pta_mode;
+	h2c->init.pta_direction = init->pta_direction;
+
+	h2c->init.module.rfe_type = init->module.rfe_type;
+	h2c->init.module.wa_type = init->module.wa_type;
+	h2c->init.module.kt_ver = init->module.kt_ver;
+	h2c->init.module.kt_ver_adie = init->module.kt_ver_adie;
+
+	h2c->init.module.bt0_pos = init->module.bt0_pos;
+	h2c->init.module.bt0_sw_type = init->module.bt0_sw_type;
+	h2c->init.module.bt1_pos = init->module.bt1_pos;
+	h2c->init.module.bt1_sw_type = init->module.bt1_sw_type;
+
+	h2c->init.module.ant.type = init->module.ant.type;
+	h2c->init.module.ant.num = init->module.ant.num;
+	h2c->init.module.ant.isolation = init->module.ant.isolation;
+	h2c->init.module.ant.single_pos = init->module.ant.single_pos;
+
+	h2c->init.module.ant.stream_cnt = init->module.ant.stream_cnt;
+	h2c->init.module.ant.path_pos = init->module.ant.path_pos;
+	h2c->init.module.ant.btg_pos = init->module.ant.btg_pos;
+	h2c->init.module.ant.btg1_pos = init->module.ant.btg1_pos;
+	memcpy(h2c->init.module.ant.func, init->module.ant.func,
+	       sizeof(init->module.ant.func));
+
+	memcpy(h2c->init.module.ant.ant_xmap, init->module.ant.ant_xmap,
+	       sizeof(init->module.ant.ant_xmap));
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
 #define PORT_DATA_OFFSET 4
 #define H2C_LEN_CXDRVINFO_ROLE_DBCC_LEN 12
 #define H2C_LEN_CXDRVINFO_ROLE_SIZE(max_role_num) \
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index e86014ca249a..c0a00b721060 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -2603,6 +2603,11 @@ struct rtw89_h2c_cxinit_v10 {
 	struct rtw89_btc_init_info_v10 init;
 } __packed;
 
+struct rtw89_h2c_cxinit_v11 {
+	struct rtw89_h2c_cxhdr_v7 hdr;
+	struct rtw89_btc_init_info_v11 init;
+} __packed;
+
 #define RTW89_H2C_CXROLE_V101_ROLE_STAT_CONNTECTED BIT(0)
 #define RTW89_H2C_CXROLE_V101_ROLE_STAT_PID GENMASK(3, 1)
 #define RTW89_H2C_CXROLE_V101_ROLE_STAT_PHY BIT(4)
@@ -5456,6 +5461,7 @@ int rtw89_fw_h2c_cxdrv_role_v2(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_role_v7(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_role_v8(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_role_v10(struct rtw89_dev *rtwdev, u8 type);
+int rtw89_fw_h2c_cxdrv_init_v11(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_osi_info(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_osi_info_v6(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_ctrl(struct rtw89_dev *rtwdev, u8 type);
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922a.c b/drivers/net/wireless/realtek/rtw89/rtw8922a.c
index 2586fd2df8ab..2d225e009b28 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922a.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922a.c
@@ -2721,25 +2721,33 @@ static u32 rtw8922a_chan_to_rf18_val(struct rtw89_dev *rtwdev,
 
 static void rtw8922a_btc_set_rfe(struct rtw89_dev *rtwdev)
 {
-	struct rtw89_btc_module *md = &rtwdev->btc.mdinfo;
+	struct rtw89_btc *btc = &rtwdev->btc;
+	struct rtw89_btc_module *md = &btc->mdinfo;
+	u8 i, j;
+	u8 tx_path_pos, rx_path_pos;
 
 	md->rfe_type = rtwdev->efuse.rfe_type;
 	md->kt_ver = rtwdev->hal.cv;
-	md->bt_solo = 0;
-	md->bt0_sw_type = BTC_SWITCH_INTERNAL;
+	md->kt_ver_adie = rtwdev->hal.acv;
 	md->wa_type = 0;
 
-	md->ant.type = BTC_ANT_SHARED;
 	md->ant.num = 2;
-	md->ant.isolation = 10;
-	md->ant.diversity = 0;
-	md->ant.single_pos = RF_PATH_A;
-	md->ant.btg_pos = RF_PATH_B;
+	md->ant.single_pos = BTC_RF_S0;
 
 	if (md->kt_ver <= 1)
 		md->wa_type |= BTC_WA_HFP_ZB;
 
-	rtwdev->btc.cx.bt_ext.func_type = BTC_3CX_NONE;
+	btc->cx.bt0.ant_iso_to_wl = md->ant.isolation;
+	btc->cx.bt1.ant_iso_to_wl =  md->ant.isolation;
+
+	md->ant.stream_cnt = 2;
+	md->ant.btg_pos = RF_PATH_B;
+	md->ant.single_pos = RF_PATH_A;
+
+	btc->cx.bt0.band_56G_support = 0;
+	btc->cx.bt1.band_56G_support = 0;
+	btc->cx.bt0.func_type = BTC_BTF_BT;
+	btc->cx.bt1.func_type = BTC_BTF_NONE;
 
 	if (md->rfe_type == 0) {
 		rtwdev->btc.dm.error.map.rfe_type0 = true;
@@ -2747,17 +2755,69 @@ static void rtw8922a_btc_set_rfe(struct rtw89_dev *rtwdev)
 	}
 
 	md->ant.num = (md->rfe_type % 2) ?  2 : 3;
-
 	if (md->kt_ver == 0)
 		md->ant.num = 2;
 
-	if (md->ant.num == 3) {
-		md->ant.type = BTC_ANT_DEDICATED;
-		md->bt0_pos = BTC_BT_ALONE;
-	} else {
+	memset(btc->dm.ant_xmap, 0, sizeof(btc->dm.ant_xmap));
+
+	switch (md->ant.num) {
+	case 1:
 		md->ant.type = BTC_ANT_SHARED;
 		md->bt0_pos = BTC_BT_BTG;
+		md->bt0_sw_type = BTC_SWITCH_V1_INTERNAL;
+		md->ant.btg_pos = BTC_RF_S0;
+		btc->dm.ant_xmap[BTC_RF_S0][BTC_BT_1ST] = 1;
+		md->ant.func[0] = BTC_EFMAP_BT0;
+		break;
+	case 2: /* 2-Ant */
+	default:
+		md->ant.type = BTC_ANT_SHARED;
+		md->bt0_pos = BTC_BT_BTG;
+		md->bt0_sw_type = BTC_SWITCH_V1_INTERNAL;
+		btc->dm.wl_trx_nss_en = 1;
+		btc->dm.ant_xmap[BTC_RF_S1][BTC_BT_1ST] = 1;
+		md->ant.func[1] = BTC_EFMAP_BT0;
+		break;
+	case 3: /* 3-Ant, 3 different BT-configuration */
+		/* WL-S0 + WL-S1 + BT0-S0 */
+		md->ant.type = BTC_ANT_DEDICATED;
+		md->bt0_pos = BTC_BT_ALONE;
+		md->bt0_sw_type = BTC_SWITCH_V1_NONE;
+		md->ant.func[2] = BTC_EFMAP_BT0;
+	}
+
+	tx_path_pos = _btc_get_rf_path_from_ant_num(btc, rtwdev->hal.tx_nss);
+	rx_path_pos = _btc_get_rf_path_from_ant_num(btc, rtwdev->hal.rx_nss);
+	/* Combine TX[7:4] and RX[3:0] into path_pos byte */
+	md->ant.path_pos = ((tx_path_pos << BTC_ANT_SHIFT) & BTC_ANT_TX_MASK) |
+			   (rx_path_pos & BTC_ANT_RX_MASK);
+
+	switch (btc->cx.bt_ext.chip_id) {
+	default:
+	case BTC_ESOC_NONE:
+		memset(&btc->cx.bt_ext, 0, sizeof(struct rtw89_btc_extsoc_info));
+		btc->cx.bt_ext.max_tx_pwr = RTW89_BTC_BT_DEF_LE_TX_PWR_1;
+		btc->cx.bt_ext.ant_iso_to_wl = RTW89_BTC_DEFAULT_ANISO;
+		break;
+	case BTC_ESOC_8771:
+		btc->cx.bt_ext.func_type = BTC_BTF_THREAD;
+		btc->cx.bt_ext.hw_coex = BTC_EXTSOC_INTF_PTA;
+		btc->cx.bt_ext.rf_band_map = 0x1; /* 2.4G only */
+		btc->cx.bt_ext.link_weight[BTC_BT_B2G] = 10;
+		btc->cx.bt_ext.profile_map[BTC_BT_B2G] |= BTC_BT_THREAD;
+		/* use GPIO 12~15 for Ext-4-wire-PTA */
+		btc->cx.bt_ext.hpta_cfg = BIT(12) | BIT(13) | BIT(14) | BIT(15);
+		md->ant.func[2] = BTC_EFMAP_ZB;
+		break;
 	}
+
+	btc->dm.ant_xmap[BTC_RF_S0][BTC_BT_EXT] = 0;
+	btc->dm.ant_xmap[BTC_RF_S1][BTC_BT_EXT] = 0;
+
+	for (i = BTC_RF_S0; i <= BTC_RF_S1; i++)
+		for (j = BTC_BT_1ST; j <= BTC_BT_EXT; j++)
+			md->ant.ant_xmap[i][j] = btc->dm.ant_xmap[i][j];
+
 	rtwdev->btc.btg_pos = md->ant.btg_pos;
 	rtwdev->btc.ant_type = md->ant.type;
 }
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index 12c96425a6ff..142e693c87bf 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -3174,7 +3174,9 @@ static void rtw8922d_btc_set_rfe(struct rtw89_dev *rtwdev)
 	struct rtw89_btc_dm *dm = &btc->dm;
 	struct rtw89_btc_cx *cx = &btc->cx;
 	u8 efuse_bt_func, efuse_ant_info, bt_sw_gpio_pos;
-	u8 is_combo, is_bt_share;
+	u8 is_combo, is_bt_share, is_spdt;
+	u8 tx_path_pos, rx_path_pos;
+	u8 i, j;
 
 	rtw89_debug(rtwdev, RTW89_DBG_BTC, "[BTC], %s !!\n", __func__);
 
@@ -3192,7 +3194,8 @@ static void rtw8922d_btc_set_rfe(struct rtw89_dev *rtwdev)
 	cx->bt0.ant_iso_to_wl = md->ant.isolation;
 	cx->bt1.ant_iso_to_wl = md->ant.isolation;
 
-	md->ant.stream_cnt = 2;
+	md->ant.stream_cnt = (rtwdev->hal.tx_nss << BTC_ANT_SHIFT) +
+				rtwdev->hal.rx_nss;
 	md->ant.btg_pos = BTC_RF_S1; /* BTG0 at WL-S1 */
 	md->ant.btg1_pos = BTC_RF_S0; /* BTG1 at WL-S0 if Dual-BTGA */
 
@@ -3203,19 +3206,20 @@ static void rtw8922d_btc_set_rfe(struct rtw89_dev *rtwdev)
 
 	efuse_bt_func = rtwdev->efuse.bt_setting_2;
 
-	switch ((efuse_bt_func & 0xe0) >> 5) { /* 0xcd[7:5] */
+	is_spdt = !!(efuse_bt_func & BIT(5));
+
+	switch ((efuse_bt_func & 0xc0) >> 6) { /* 0xcd[7:6] */
 	default:
 	case 0:
-	case 1:
 		bt_sw_gpio_pos = 5;
 		break;
-	case 2:
+	case 1:
 		bt_sw_gpio_pos = 11;
 		break;
-	case 3:
+	case 2:
 		bt_sw_gpio_pos = 15;
 		break;
-	case 4:
+	case 3:
 		bt_sw_gpio_pos = 20;
 		break;
 	}
@@ -3233,9 +3237,8 @@ static void rtw8922d_btc_set_rfe(struct rtw89_dev *rtwdev)
 	case 1: /* 1-Ant WL-S0 only & BT0 only */
 		md->ant.type = BTC_ANT_SHARED;
 		md->bt0_pos = BTC_BT_BTG;
-		md->bt0_sw_type = BTC_SWITCH_INTERNAL;
+		md->bt0_sw_type = BTC_SWITCH_V1_INTERNAL;
 		md->ant.btg_pos = BTC_RF_S0; /* BTG0 at WL-S0 */
-		md->ant.stream_cnt = 1;
 		md->ant.func[0] = BTC_EFMAP_BT0;
 		dm->ant_xmap[BTC_RF_S0][BTC_BT_1ST] = 1; /* BT0 shared with S0*/
 		dm->ant_xmap[BTC_RF_S1][BTC_BT_1ST] = 0; /* WL 1T1R no RF-S1 */
@@ -3265,13 +3268,13 @@ static void rtw8922d_btc_set_rfe(struct rtw89_dev *rtwdev)
 
 		if (md->ant.func[0] == BTC_EFMAP_BT1) { /* if 2nd BT exist */
 			dm->ant_xmap[BTC_RF_S0][BTC_BT_2ND] = 1;
-			if (md->rfe_type == 12) { /* WL-S0 & BT1 by SPDT */
+			if (is_spdt) { /* WL-S0 & BT1 by SPDT */
 				md->bt1_pos = BTC_BT_ALONE;
 				/* Todo: set SPDT GPIO-ctrl */
 				md->bt1_sw_type = bt_sw_gpio_pos;
 			} else { /* WL-S0 & BT1-S1 by BTGA */
 				md->bt1_pos = BTC_BT_BTG;
-				md->bt1_sw_type = BTC_SWITCH_INTERNAL;
+				md->bt1_sw_type = BTC_SWITCH_V1_INTERNAL;
 			}
 		}
 
@@ -3284,7 +3287,7 @@ static void rtw8922d_btc_set_rfe(struct rtw89_dev *rtwdev)
 			md->ant.func[2] = efuse_bt_func & (~BTC_EFMAP_BT0);
 			md->ant.type = BTC_ANT_SHARED;
 			md->bt0_pos = BTC_BT_BTG;
-			md->bt0_sw_type = BTC_SWITCH_INTERNAL;
+			md->bt0_sw_type = BTC_SWITCH_V1_INTERNAL;
 			dm->ant_xmap[BTC_RF_S1][BTC_BT_1ST] = 1;
 			dm->wl_trx_nss_en = 1; /* 1ss MIMO-PS capability */
 		} else {
@@ -3324,6 +3327,12 @@ static void rtw8922d_btc_set_rfe(struct rtw89_dev *rtwdev)
 		break;
 	}
 
+	tx_path_pos = _btc_get_rf_path_from_ant_num(btc, rtwdev->hal.tx_nss);
+	rx_path_pos = _btc_get_rf_path_from_ant_num(btc, rtwdev->hal.rx_nss);
+	/* Combine TX[7:4] and RX[3:0] into path_pos byte */
+	md->ant.path_pos = ((tx_path_pos << BTC_ANT_SHIFT) & BTC_ANT_TX_MASK) |
+			   (rx_path_pos & BTC_ANT_RX_MASK);
+
 	/*
 	 * if only BT0 at BTGA: 2-Ant, 3-Ant(BT1 used dedicated-ant)
 	 * can setup dm->wl_trx_nss_en = 1, WL MIMO-PS to 1T1R
@@ -3373,6 +3382,13 @@ static void rtw8922d_btc_set_rfe(struct rtw89_dev *rtwdev)
 
 	dm->ant_xmap[BTC_RF_S0][BTC_BT_EXT] = 0;
 	dm->ant_xmap[BTC_RF_S1][BTC_BT_EXT] = 0;
+
+	for (i = BTC_RF_S0; i <= BTC_RF_S1; i++)
+		for (j = BTC_BT_1ST; j <= BTC_BT_EXT; j++)
+			md->ant.ant_xmap[i][j] = dm->ant_xmap[i][j];
+
+	rtwdev->btc.btg_pos = md->ant.btg_pos;
+	rtwdev->btc.ant_type = md->ant.type;
 }
 
 static void rtw8922d_btc_init_cfg(struct rtw89_dev *rtwdev)
-- 
2.25.1

