Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4293CC31F
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784271590; cv=none; b=q/ScY0r1vugb/jAPdY/+EE4LMeTcH+OKTxqfGh31iLDeyJWxZBxPpCVU59JjNIEXXhtopYfj+37+Oz/c/VZdO1jf3cESjwEkiloC84rX93+LjkDaQcVQPlLmSywp9yxZsCBWMSEif9yvjgRGZiYN8qGsCkr0ysyylQvR8XIE0/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784271590; c=relaxed/simple;
	bh=y8cKffZ4Da18xeuc9HYEGNi59d8by/K3lZ/sQxFZzls=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nyt6WFgczrdgX3aP2v5Mz+axyypZ4/nXtch5iTRhXOp+ZicaJCP9U/QM8JtlGH9NyknNnLlawvTwxgmisw/XG4a+ZI9pzL8JM5b05BBBg9edTPyr3vVeSMZhjhyeCKj4dfIfqrwvQbpkGkJtL3YsY7X0iO+X2vk9C5BwUMghjS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=CPG0pzHn; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="CPG0pzHn"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H6xjNxB4177031, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784271585; bh=9XspMO7CTkcJ5b9h3N9AUQOOxlxQn2OI2inLCUPt+GA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=CPG0pzHn3EH7/1/N3VTpjAZbYxVyNM/U75VU0jKyrtYeTtyBTbMkrEWTk4r1qDx6f
	 0fk8IiXPRLCk6Tys3yNdbz95GbrmJMLkkc6i2/AZ+b3he068BR8rO7dC4CqJ/BKlz6
	 dk8dq3pjEC6RzBimcMkb+0U/zxPOkeB8zZiUzs5fbUbOuLrl2vWgH1oQfZkg2mL0fK
	 0JDs2oghuO4vzGPNngJsgdOCyonuj0zaLF5owEdr8mGkzME/+XQVONkqCIHS41QMz0
	 AEE7WTe5RgfWDndCA2C/MxmaRrsQv5gePVeqwn4Bs7bMjm99nU1DCe8t6gy02yASy9
	 q/zuJgvAzyLdQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H6xjNxB4177031
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:59:45 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:59:46 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 14:59:46 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 12/13] wifi: rtw89: coex: Add wifi role info version 101
Date: Fri, 17 Jul 2026 14:57:38 +0800
Message-ID: <20260717065739.64124-13-pkshih@realtek.com>
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

The structure active_role which describes the using Wi-Fi role format is
different with the exist v1. Add branch to cover the difference.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 13 ++--
 drivers/net/wireless/realtek/rtw89/fw.c   | 82 +++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/fw.h   | 35 ++++++++++
 3 files changed, 125 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 54c11af46f8d..b95e34cb1567 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -3198,6 +3198,8 @@ static void _fw_set_drv_info(struct rtw89_dev *rtwdev, u8 index)
 			rtw89_fw_h2c_cxdrv_role(rtwdev, index);
 		else if (ver->fwlrole == 1)
 			rtw89_fw_h2c_cxdrv_role_v1(rtwdev, index);
+		else if (ver->fwlrole == 101)
+			rtw89_fw_h2c_cxdrv_role_v101(rtwdev, index);
 		else if (ver->fwlrole == 2)
 			rtw89_fw_h2c_cxdrv_role_v2(rtwdev, index);
 		else if (ver->fwlrole == 7)
@@ -6873,6 +6875,7 @@ static void _update_wl_link_mode(struct rtw89_dev *rtwdev, u8 hw_band, u8 type)
 	struct rtw89_btc_wl_mlo_info *mlo_info = &wl->mlo_info;
 	struct rtw89_btc_wl_role_info *r = &wl->role_info;
 	u8 p2p_exist = wl->role_info.p2p_exist;
+	u8 rver = ver->fwlrole;
 
 	if (hw_band == RTW89_PHY_1)
 		p2p_exist = wl->role_info.p2p_exist_hb1;
@@ -6893,7 +6896,7 @@ static void _update_wl_link_mode(struct rtw89_dev *rtwdev, u8 hw_band, u8 type)
 			r->link_mode = BTC_WLINK_STA;
 		}
 
-		if (ver->fwlrole >= 10)
+		if (rver >= 10 && rver < 100)
 			break;
 
 		if (mlo_info->hwb_rf_band[hw_band] != RTW89_BAND_2G) {
@@ -6921,7 +6924,7 @@ static void _update_wl_link_mode(struct rtw89_dev *rtwdev, u8 hw_band, u8 type)
 			r->link_mode = BTC_WLINK_SCC;
 		}
 
-		if (ver->fwlrole >= 10)
+		if (rver >= 10 && rver < 100)
 			break;
 
 		if (mlo_info->hwb_rf_band[hw_band] != RTW89_BAND_2G) {
@@ -6941,7 +6944,7 @@ static void _update_wl_link_mode(struct rtw89_dev *rtwdev, u8 hw_band, u8 type)
 		else
 			r->link_mode = BTC_WLINK_STA;
 
-		if (ver->fwlrole >= 10)
+		if (rver >= 10 && rver < 100)
 			break;
 
 		if (mlo_info->hwb_rf_band[hw_band] != RTW89_BAND_2G)
@@ -6959,7 +6962,7 @@ static void _update_wl_link_mode(struct rtw89_dev *rtwdev, u8 hw_band, u8 type)
 		 */
 		r->link_mode = BTC_WLINK_DB_MCC;
 
-		if (ver->fwlrole >= 10)
+		if (rver >= 10 && rver < 100)
 			break;
 
 		r->link_mode_v0 = BTC_WLINK_V0_25G_MCC;
@@ -6968,7 +6971,7 @@ static void _update_wl_link_mode(struct rtw89_dev *rtwdev, u8 hw_band, u8 type)
 		/* MLMR only support STA now (2024) */
 		r->link_mode = BTC_WLINK_STA;
 
-		if (ver->fwlrole >= 10)
+		if (rver >= 10 && rver < 100)
 			break;
 
 		if (mlo_info->hwb_rf_band[hw_band] != RTW89_BAND_2G) {
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 34bc52519ea2..a9308f9486ae 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -6148,6 +6148,88 @@ int rtw89_fw_h2c_cxdrv_role_v1(struct rtw89_dev *rtwdev, u8 type)
 	return ret;
 }
 
+int rtw89_fw_h2c_cxdrv_role_v101(struct rtw89_dev *rtwdev, u8 type)
+{
+	struct rtw89_btc *btc = &rtwdev->btc;
+	struct rtw89_btc_wl_info *wl = &btc->cx.wl;
+	struct rtw89_btc_wl_role_info *role_info = &wl->role_info;
+	struct rtw89_btc_wl_rlink *active;
+	struct rtw89_h2c_cxrole_v101 *h2c;
+	u32 len = sizeof(*h2c);
+	struct sk_buff *skb;
+	int ret;
+	u8 i;
+
+	skb = rtw89_fw_h2c_alloc_skb_with_hdr(rtwdev, len);
+	if (!skb) {
+		rtw89_err(rtwdev, "failed to alloc skb for h2c cxdrv_role_v101\n");
+		return -ENOMEM;
+	}
+	skb_put(skb, len);
+	h2c = (struct rtw89_h2c_cxrole_v101 *)skb->data;
+
+	h2c->hdr.type = type;
+	h2c->hdr.len = len - H2C_LEN_CXDRVHDR;
+
+	h2c->connect_cnt = role_info->connect_cnt;
+	h2c->link_mode = role_info->link_mode;
+	h2c->role_map = cpu_to_le16(role_info->role_map);
+
+	for (i = 0; i < RTW89_PORT_NUM; i++) {
+		active = &role_info->rlink[i][0];
+		h2c->act_role[i].map_role_status =
+			u8_encode_bits(active->connected,
+				       RTW89_H2C_CXROLE_V101_ROLE_STAT_CONNTECTED) |
+			u8_encode_bits(active->pid,
+				       RTW89_H2C_CXROLE_V101_ROLE_STAT_PID) |
+			u8_encode_bits(active->phy,
+				       RTW89_H2C_CXROLE_V101_ROLE_STAT_PHY) |
+			u8_encode_bits(active->noa,
+				       RTW89_H2C_CXROLE_V101_ROLE_STAT_NOA) |
+			u8_encode_bits(active->rf_band,
+				       RTW89_H2C_CXROLE_V101_ROLE_STAT_BADN);
+		h2c->act_role[i].map_clips_bw =
+			u8_encode_bits(active->client_ps,
+				       RTW89_H2C_CXROLE_V101_CLIPS_BW_CLIENTPS) |
+			u8_encode_bits(active->bw,
+				       RTW89_H2C_CXROLE_V101_CLIPS_BW_BW);
+		h2c->act_role[i].role = active->role;
+		h2c->act_role[i].ch = active->ch;
+		h2c->act_role[i].noa_duration = cpu_to_le32(active->noa_dur);
+	}
+
+	h2c->mrole_type = cpu_to_le32(role_info->mrole_type);
+	h2c->mrole_noa_duration = cpu_to_le32(role_info->mrole_noa_duration);
+	h2c->map_dbcc_linkmode_chg =
+		le32_encode_bits(role_info->dbcc_en,
+				 RTW89_H2C_CXROLE_V101_DBCC_EN) |
+		le32_encode_bits(role_info->dbcc_chg,
+				 RTW89_H2C_CXROLE_V101_DBCC_CHG) |
+		le32_encode_bits(role_info->dbcc_2g_phy,
+				 RTW89_H2C_CXROLE_V101_DBCC_2G_PHY) |
+		le32_encode_bits(role_info->link_mode_chg,
+				 RTW89_H2C_CXROLE_V101_DBCC_LINKMODE_CHG) |
+		le32_encode_bits(role_info->rsvd,
+				 RTW89_H2C_CXROLE_V101_DBCC_RSVD);
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
 #define H2C_LEN_CXDRVINFO_ROLE_SIZE_V2(max_role_num) \
 	(4 + 8 * (max_role_num) + H2C_LEN_CXDRVINFO_ROLE_DBCC_LEN + H2C_LEN_CXDRVHDR)
 
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index 16e173c5d1bb..53b5695f9070 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -2603,6 +2603,40 @@ struct rtw89_h2c_cxinit_v10 {
 	struct rtw89_btc_init_info_v10 init;
 } __packed;
 
+#define RTW89_H2C_CXROLE_V101_ROLE_STAT_CONNTECTED BIT(0)
+#define RTW89_H2C_CXROLE_V101_ROLE_STAT_PID GENMASK(3, 1)
+#define RTW89_H2C_CXROLE_V101_ROLE_STAT_PHY BIT(4)
+#define RTW89_H2C_CXROLE_V101_ROLE_STAT_NOA BIT(5)
+#define RTW89_H2C_CXROLE_V101_ROLE_STAT_BADN GENMASK(7, 6)
+
+#define RTW89_H2C_CXROLE_V101_CLIPS_BW_CLIENTPS BIT(0)
+#define RTW89_H2C_CXROLE_V101_CLIPS_BW_BW GENMASK(7, 1)
+
+#define RTW89_H2C_CXROLE_V101_DBCC_EN BIT(0)
+#define RTW89_H2C_CXROLE_V101_DBCC_CHG BIT(1)
+#define RTW89_H2C_CXROLE_V101_DBCC_2G_PHY GENMASK(3, 2)
+#define RTW89_H2C_CXROLE_V101_DBCC_LINKMODE_CHG BIT(4)
+#define RTW89_H2C_CXROLE_V101_DBCC_RSVD GENMASK(31, 5)
+
+struct rtw89_btc_wl_active_role_v101 {
+	u8 map_role_status;
+	u8 map_clips_bw;
+	u8 role;
+	u8 ch;
+	__le32 noa_duration;
+} __packed;
+
+struct rtw89_h2c_cxrole_v101 {
+	struct rtw89_h2c_cxhdr hdr;
+	u8 connect_cnt;
+	u8 link_mode;
+	__le16 role_map;
+	struct rtw89_btc_wl_active_role_v101 act_role[RTW89_PORT_NUM];
+	__le32 mrole_type;
+	__le32 mrole_noa_duration;
+	__le32 map_dbcc_linkmode_chg;
+} __packed;
+
 static inline void RTW89_SET_FWCMD_CXROLE_CONNECT_CNT(void *cmd, u8 val)
 {
 	u8p_replace_bits((u8 *)(cmd) + 2, val, GENMASK(7, 0));
@@ -5412,6 +5446,7 @@ int rtw89_fw_h2c_cxdrv_init_v7(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_init_v10(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_role(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_role_v1(struct rtw89_dev *rtwdev, u8 type);
+int rtw89_fw_h2c_cxdrv_role_v101(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_role_v2(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_role_v7(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_role_v8(struct rtw89_dev *rtwdev, u8 type);
-- 
2.25.1

