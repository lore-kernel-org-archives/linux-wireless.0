Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739C436492C
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391361; cv=none; b=iuFWhFZJwObQyMgGM3OW2VV/QO88wpp8815q9douVbDA/CRj9NiTbq6G+UywPBres2IHs+ZfBA8oaxdUQXVfgRzScqtUlk5IJX919eftkhTT3Q8MfnTaHGHA58s9m+TDllJYGGdBuVrDhX+H/NaQs3q1c8FXGnoi5oLs+XynZAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391361; c=relaxed/simple;
	bh=m5vYO4OL7CtCEk4+lar7J8GjRcQPAkK8n9XmGESBHeE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ab14dKO5SQ6ihXjSXR+TDVqdRc36pM6jI3SPWKBU6YtLx77zHxxzJi9Mnzt4hflUoTchMtqhEJk8usQ59MhlTE8T2PP9uiNwzbmhMr4Eo/EsJlCEFz8f16unx0fkZpOl8VKU2synJMOUdDYfjnWXA05qY70oaypmvJS270AGMAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=XexI490O; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="XexI490O"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66U62WTN0985862, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785391353; bh=K6izpbqqlN3/aeKNh1pwnlXgjj14Mq6dkqC1On+J9XY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=XexI490Omade+TUs6fg1ryqa9Eq6Pqiui8rLce2bryfCwNeQdOsB5xKSGMiq5XU3p
	 BDewCOs2M+iOOh7+ohP6etN3KpgpRn245CxkE+qV1Z150DMlNUOMzcW9bbnaxtkGF0
	 pICyB0euP9L8fQBK01KfBkrxgomd8wtrpQZnFuopPQT/HjX5U7F2F3vK21sLMROIdY
	 FcYkfeDaOkrblMdEmthHFS/PbfF3q6EpqoO9ukDet4yZYTb+yNSnS4K4Oly4TP2h5Q
	 Vio1HsBwk62Q5hOy6zpdpYZQc7Fzi1U61c5pxWIaFAf6OUEGgGsFWVGus9yHzNJC03
	 ooZ2uVyVJfMyA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66U62WTN0985862
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 14:02:33 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 14:02:33 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Thu, 30 Jul 2026 14:02:33 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 2/7] wifi: rtw89: coex: Fix BT-info parsing for 5/6 GHz band & dual Bluetooth
Date: Thu, 30 Jul 2026 14:02:15 +0800
Message-ID: <20260730060220.55844-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260730060220.55844-1-pkshih@realtek.com>
References: <20260730060220.55844-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

The _update_bt_info() function always parsed BT-info for bt0 and used a
single raw_info buffer regardless of which BT device sent the packet or
which RF band it belongs to. This caused two bugs:

1. BT-info packets from bt1 were incorrectly parsed into bt0's state.

2. BT-info packets from 5/6 GHz BT (L1 bit7=1) overwrote the 2.4 GHz
   link_info and raw_info, breaking duplicate detection across bands.

Fix by adding the bid parameter to select bt0/bt1, detecting the 5/6 GHz
band flag (L1 bit7) to route packets into link_info_56g with a dedicated
raw_info_56g buffer, and updating the early-return mask to ignore bit7
when checking the length field.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 61 ++++++++++++++++-------
 drivers/net/wireless/realtek/rtw89/core.h |  3 +-
 2 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index fd9ddd55c192..d5b1c68539d9 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -9005,23 +9005,46 @@ static u8 _update_bt_rssi_level(struct rtw89_dev *rtwdev, u8 rssi)
 
 #define BT_PROFILE_PROTOCOL_MASK GENMASK(7, 4)
 
-static void _update_bt_info(struct rtw89_dev *rtwdev, u8 *buf, u32 len)
+static void _update_bt_info(struct rtw89_dev *rtwdev, u8 bid, u8 *buf, u32 len)
 {
 	const struct rtw89_chip_info *chip = rtwdev->chip;
 	struct rtw89_btc *btc = &rtwdev->btc;
+	struct rtw89_btc_bt_a2dp_desc *a2dp;
 	struct rtw89_btc_cx *cx = &btc->cx;
-	struct rtw89_btc_bt_info *bt = &cx->bt0;
-	struct rtw89_btc_bt_link_info *b = &bt->link_info;
-	struct rtw89_btc_bt_hfp_desc *hfp = &b->hfp_desc;
-	struct rtw89_btc_bt_hid_desc *hid = &b->hid_desc;
-	struct rtw89_btc_bt_a2dp_desc *a2dp = &b->a2dp_desc;
-	struct rtw89_btc_bt_pan_desc *pan = &b->pan_desc;
+	struct rtw89_btc_bt_hfp_desc *hfp;
+	struct rtw89_btc_bt_hid_desc *hid;
+	struct rtw89_btc_bt_pan_desc *pan;
+	struct rtw89_btc_bt_link_info *b;
+	struct rtw89_btc_bt_info *bt;
 	union btc_btinfo btinfo;
+	u8 is_bt_56g = 0;
+	u8 *raw_info;
 
-	if (buf[BTC_BTINFO_L1] != 6)
+	/* Bit7 is used for RF-band: 0:BT_2.4 GHz, 1:BT_5/6 GHz */
+	if ((buf[BTC_BTINFO_L1] & 0x7f) != 6)
 		return;
 
-	if (!memcmp(bt->raw_info, buf, BTC_BTINFO_MAX)) {
+	bt = (bid == BTC_BT_1ST) ? &cx->bt0 : &cx->bt1;
+
+	if ((buf[BTC_BTINFO_L1] & BIT(7)) && bt->band_56G_support) {
+		b = &bt->link_info_56g;
+		is_bt_56g = 1;
+		if (b->status.map.connect)
+			bt->rf_band_map |= BIT(RTW89_BAND_5G);
+		else
+			bt->rf_band_map &= ~BIT(RTW89_BAND_5G);
+	} else {
+		b = &bt->link_info;
+		bt->rf_band_map |= BIT(RTW89_BAND_2G);
+	}
+
+	hfp = &b->hfp_desc;
+	hid = &b->hid_desc;
+	a2dp = &b->a2dp_desc;
+	pan = &b->pan_desc;
+	raw_info = is_bt_56g ? bt->raw_info_56g : bt->raw_info;
+
+	if (!memcmp(raw_info, buf, BTC_BTINFO_MAX)) {
 		rtw89_debug(rtwdev, RTW89_DBG_BTC,
 			    "[BTC], %s(): return by bt-info duplicate!!\n",
 			    __func__);
@@ -9029,16 +9052,16 @@ static void _update_bt_info(struct rtw89_dev *rtwdev, u8 *buf, u32 len)
 		return;
 	}
 
-	memcpy(bt->raw_info, buf, BTC_BTINFO_MAX);
+	memcpy(raw_info, buf, BTC_BTINFO_MAX);
 
 	rtw89_debug(rtwdev, RTW89_DBG_BTC,
 		    "[BTC], %s(): bt_info[2]=0x%02x\n",
-		    __func__, bt->raw_info[2]);
+		    __func__, raw_info[2]);
 
 	hid->type = 0;
 
 	/* parse raw info low-Byte2 */
-	btinfo.val = bt->raw_info[BTC_BTINFO_L2];
+	btinfo.val = raw_info[BTC_BTINFO_L2];
 	b->status.map.connect = btinfo.lb2.connect;
 	b->status.map.sco_busy = btinfo.lb2.sco_busy;
 	b->status.map.acl_busy = btinfo.lb2.acl_busy;
@@ -9050,11 +9073,11 @@ static void _update_bt_info(struct rtw89_dev *rtwdev, u8 *buf, u32 len)
 	hid->exist = btinfo.lb2.hid;
 	a2dp->exist = btinfo.lb2.a2dp;
 	pan->exist = btinfo.lb2.pan;
-	_update_bt_link_cnt(rtwdev, bt, 0);
+	_update_bt_link_cnt(rtwdev, bt, is_bt_56g);
 	btc->dm.trx_info.bt_profile = u32_get_bits(btinfo.val, BT_PROFILE_PROTOCOL_MASK);
 
 	/* parse raw info low-Byte3 */
-	btinfo.val = bt->raw_info[BTC_BTINFO_L3];
+	btinfo.val = raw_info[BTC_BTINFO_L3];
 	if (btinfo.lb3.retry != 0)
 		bt->bcnt[BTC_BCNT_RETRY]++;
 	b->cqddr = btinfo.lb3.cqddr;
@@ -9065,14 +9088,14 @@ static void _update_bt_info(struct rtw89_dev *rtwdev, u8 *buf, u32 len)
 
 	b->status.map.mesh_busy = btinfo.lb3.mesh_busy;
 	/* parse raw info high-Byte0 */
-	btinfo.val = bt->raw_info[BTC_BTINFO_H0];
+	btinfo.val = raw_info[BTC_BTINFO_H0];
 	/* raw val is dBm unit, translate from -100~ 0dBm to 0~100%*/
 	b->rssi = chip->ops->btc_get_bt_rssi(rtwdev, btinfo.hb0.rssi);
 	bt->rssi_level = _update_bt_rssi_level(rtwdev, b->rssi);
 	btc->dm.trx_info.bt_rssi = bt->rssi_level;
 
 	/* parse raw info high-Byte1 */
-	btinfo.val = bt->raw_info[BTC_BTINFO_H1];
+	btinfo.val = raw_info[BTC_BTINFO_H1];
 	b->status.map.ble_connect = btinfo.hb1.ble_connect;
 	if (btinfo.hb1.ble_connect) {
 		if (hid->exist)
@@ -9101,7 +9124,7 @@ static void _update_bt_info(struct rtw89_dev *rtwdev, u8 *buf, u32 len)
 	b->multi_link.now = btinfo.hb1.multi_link;
 
 	/* parse raw info high-Byte2 */
-	btinfo.val = bt->raw_info[BTC_BTINFO_H2];
+	btinfo.val = raw_info[BTC_BTINFO_H2];
 	pan->active = !!btinfo.hb2.pan_active;
 
 	bt->bcnt[BTC_BCNT_AFH] += !!(btinfo.hb2.afh_update && !b->afh_update);
@@ -9114,7 +9137,7 @@ static void _update_bt_info(struct rtw89_dev *rtwdev, u8 *buf, u32 len)
 		hid->type |= (hid->slot_info == BTC_HID_218 ?
 			      BTC_HID_218 : BTC_HID_418);
 	/* parse raw info high-Byte3 */
-	btinfo.val = bt->raw_info[BTC_BTINFO_H3];
+	btinfo.val = raw_info[BTC_BTINFO_H3];
 	a2dp->bitpool = btinfo.hb3.a2dp_bitpool;
 
 	if (b->tx_3m != (u32)btinfo.hb3.tx_3m)
@@ -9785,7 +9808,7 @@ void rtw89_btc_c2h_handle(struct rtw89_dev *rtwdev, struct sk_buff *skb,
 		rtw89_debug(rtwdev, RTW89_DBG_BTC,
 			    "[BTC], handle C2H BT INFO with data %8ph\n", buf);
 		bt->bcnt[BTC_BCNT_INFOUPDATE]++;
-		_update_bt_info(rtwdev, buf, len);
+		_update_bt_info(rtwdev, bid, buf, len);
 		break;
 	case BTF_EVNT_BT_SCBD:
 		bt->bcnt[BTC_BCNT_SCBDUPDATE]++;
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 09c19a6b9058..bc9db0c16473 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -2705,7 +2705,8 @@ struct rtw89_btc_bt_info {
 	struct rtw89_btc_rf_para rf_para;
 	union rtw89_btc_bt_rfk_info_map rfk_info;
 
-	u8 raw_info[BTC_BTINFO_MAX]; /* raw bt info from mailbox */
+	u8 raw_info[BTC_BTINFO_MAX]; /* raw bt info from mailbox (2.4G) */
+	u8 raw_info_56g[BTC_BTINFO_MAX]; /* raw bt info from mailbox (5/6G) */
 	u8 txpwr_info[BTC_BTINFO_MAX];
 	u8 link_weight[BTC_BT_BMAX]; /* Link Weight for RF-band/HWB selection */
 	u8 rssi_level;
-- 
2.25.1

