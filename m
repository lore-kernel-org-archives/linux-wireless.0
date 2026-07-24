Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278AF3D9551
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 13:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784901478; cv=none; b=qOSka5kNz687c/LdrqJLMqPgqS88vVMWhyvVyiQgZoSJ0KNK9g2CQlL/9GZyN9kWa0jngQfivSKzicywgs2qn+9OFZMdtRErpLv7Y6aFbcDkc86hDZhE5yYsDkhF5eMsU+T++3T9TUkcrsIsgMadffgiiGrtEbSF5mzLuZM6ijo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784901478; c=relaxed/simple;
	bh=dDCcIx7AqLYFzF35i2tP1xZGMDnjb34X5ukUH38Wc6w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dxou8v9QNqL/Nd/p4l6AB41SSQDAoKrOdvZijKe+BHUA7kkFOW2GdWz6KZeJ+fG5kZc72tjYPM5dhGCtghAL6dAvKdIbKk6EsGa60Yo2+PK0x3RS94yCoVmrE3OBXmAx5kjaILei78NCNXhOuZEotcGnN+re6oTPyLjtgNLDo5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=aFKEwXUm; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="aFKEwXUm"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66ODvsOgB1179852, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784901474; bh=dJNHIk6Z6c3MaQdJ7zZWhgvU3XV39D5lK7hpcfvDdO8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=aFKEwXUm6/HBa/rdzQdeOMs6WjDiYtTg0UitZrhL32zZFIlRVc6Q8eb3l/k8GKLSB
	 G9Wmt7zAzsLUjcc5kld/TlqgZLvLkSjeRBxSkBAVnkxyJkpxGoer4cVyRbDpNxARPm
	 t+cpY5JvXAi054OAjS7cDphnJP/V6CdBH/sWJy0L0WoHwigKMbV0S86UuOjQIIUcle
	 g4exxdxppOuenFbwBzAwWP3oIbMN2PEKeREc3e7jFs7msBZkllMSl3jV7d6bQO7T30
	 lDj13c6UG4h/811Umfd0uo8AIqvIhVaoPWmfmrWX90Elu9YfHUrPY2LXwj8o9sX7x5
	 HYBujzExcKvXQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66ODvsOgB1179852
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 21:57:54 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 21:57:53 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 21:57:53 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 14/14] wifi: rtw89: coex: Handle Bluetooth LE-Audio related coexistence feature
Date: Fri, 24 Jul 2026 21:56:40 +0800
Message-ID: <20260724135640.3195044-15-pkshih@realtek.com>
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

Implement event handler of BTF_EVNT_BT_LEAUDIO_INFO C2H command, and
related coexistence mechanism for Bluetooth LE-Audio feature.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 199 ++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/core.h |  35 +++-
 2 files changed, 233 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 6b3e199398cf..0e42c720819a 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -951,6 +951,7 @@ enum btc_reason_and_action {
 	BTC_RSN_ACT1_WORK,
 	BTC_RSN_BT_DEVINFO_WORK,
 	BTC_RSN_RFK_CHK_WORK,
+	BTC_RSN_UPDATE_BT_LEAUDINFO,
 	BTC_RSN_NUM,
 	BTC_ACT_NONE = 100,
 	BTC_ACT_WL_ONLY,
@@ -975,6 +976,8 @@ enum btc_reason_and_action {
 	BTC_ACT_BT_A2DP_PAN,
 	BTC_ACT_BT_PAN_HID,
 	BTC_ACT_BT_A2DP_PAN_HID,
+	BTC_ACT_BT_BIS,
+	BTC_ACT_BT_CIS,
 	BTC_ACT_WL_25G_MCC,
 	BTC_ACT_WL_2G_MCC,
 	BTC_ACT_WL_2G_SCC,
@@ -6076,6 +6079,43 @@ static void _action_bt_pan_hid(struct rtw89_dev *rtwdev)
 	}
 }
 
+static void _action_bt_bis(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_btc *btc = &rtwdev->btc;
+	struct rtw89_btc_dm *dm = &btc->dm;
+	u16 policy_type;
+
+	if (dm->bis_tdma)
+		policy_type = BTC_CXP_OFFE_2GBWISOB;
+	else
+		policy_type = BTC_CXP_OFF_EQ0;
+
+	_set_ant(rtwdev, NM_EXEC, BTC_PHY_ALL, BTC_ANT_PTA);
+	_set_policy(rtwdev, policy_type, BTC_ACT_BT_BIS);
+}
+
+static void _action_bt_cis(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_btc *btc = &rtwdev->btc;
+	struct rtw89_btc_bt_link_info *bt_linfo = &btc->cx.bt0.link_info;
+	struct rtw89_btc_wl_info *wl = &btc->cx.wl;
+	struct rtw89_btc_dm *dm = &btc->dm;
+	u16 policy_type;
+
+	if (bt_linfo->a2dp_desc.active) {
+		dm->slot_dur[CXST_W1] = 80;
+		dm->slot_dur[CXST_B1] = 20;
+		policy_type = BTC_CXP_PFIX_TDW1B1;
+	} else if (wl->status.map.traffic_dir & BIT(RTW89_TFC_UL)) {
+		policy_type = BTC_CXP_OFF_BWB0;
+	} else {
+		policy_type = BTC_CXP_OFF_BWB1;
+	}
+
+	_set_ant(rtwdev, NM_EXEC, BTC_PHY_ALL, BTC_ANT_PTA);
+	_set_policy(rtwdev, policy_type, BTC_ACT_BT_CIS);
+}
+
 static void _action_bt_a2dp_pan_hid(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_btc *btc = &rtwdev->btc;
@@ -6692,6 +6732,7 @@ static void _action_by_bt(struct rtw89_dev *rtwdev)
 	struct rtw89_btc *btc = &rtwdev->btc;
 	struct rtw89_btc_bt_info *bt = &btc->cx.bt0;
 	struct rtw89_btc_bt_link_info *bt_linfo = &bt->link_info;
+	struct rtw89_btc_bt_leaudio_desc leaudio = bt_linfo->leaudio_desc;
 	struct rtw89_btc_bt_hid_desc hid = bt_linfo->hid_desc;
 	struct rtw89_btc_bt_a2dp_desc a2dp = bt_linfo->a2dp_desc;
 	struct rtw89_btc_bt_pan_desc pan = bt_linfo->pan_desc;
@@ -6715,6 +6756,12 @@ static void _action_by_bt(struct rtw89_dev *rtwdev)
 	if (bt_linfo->pan_desc.exist)
 		profile_map |= BTC_BT_PAN;
 
+	if (leaudio.bis_exist)
+		profile_map |= BTC_BT_BIS;
+
+	if (leaudio.cis_exist)
+		profile_map |= BTC_BT_CIS;
+
 	switch (profile_map) {
 	case BTC_BT_NOPROFILE:
 		if (pan.active)
@@ -6740,6 +6787,13 @@ static void _action_by_bt(struct rtw89_dev *rtwdev)
 	case BTC_BT_PAN:
 		_action_bt_pan(rtwdev);
 		break;
+	case BTC_BT_BIS:
+		_action_bt_bis(rtwdev);
+		break;
+	case BTC_BT_CIS:
+	case BTC_BT_CIS | BTC_BT_HID:
+		_action_bt_cis(rtwdev);
+		break;
 	case BTC_BT_A2DP | BTC_BT_HFP:
 	case BTC_BT_A2DP | BTC_BT_HID:
 	case BTC_BT_A2DP | BTC_BT_HFP | BTC_BT_HID:
@@ -7909,6 +7963,140 @@ static void _update_bt_scbd(struct rtw89_dev *rtwdev, u8 bid)
 	}
 }
 
+static void _update_bt_link_cnt(struct rtw89_dev *rtwdev,
+				struct rtw89_btc_bt_info *bt, bool b56g)
+{
+	struct rtw89_btc_bt_link_info *b = b56g ? &bt->link_info_56g :
+						  &bt->link_info;
+	struct rtw89_btc_bt_leaudio_desc *leaudio = &b->leaudio_desc;
+	struct rtw89_btc_bt_a2dp_desc *a2dp = &b->a2dp_desc;
+	struct rtw89_btc_bt_hfp_desc *hfp = &b->hfp_desc;
+	struct rtw89_btc_bt_hid_desc *hid = &b->hid_desc;
+	struct rtw89_btc_bt_pan_desc *pan = &b->pan_desc;
+
+	b->link_cnt.last = b->link_cnt.now;
+	b->link_cnt.now = 0;
+	b->link_cnt.chg = 0;
+
+	b->link_cnt.now += hfp->exist;
+	b->link_cnt.now += hid->exist;
+	b->link_cnt.now += a2dp->exist;
+	b->link_cnt.now += pan->exist;
+	b->link_cnt.now += leaudio->bis_exist;
+	b->link_cnt.now += leaudio->cis_exist;
+}
+
+static void _update_bt_leaudio_info(struct rtw89_dev *rtwdev, u8 bid,
+				    void *buf, u32 len)
+{
+	const struct rtw89_chip_info *chip = rtwdev->chip;
+	struct rtw89_btc *btc = &rtwdev->btc;
+	struct rtw89_btc_cx *cx = &btc->cx;
+	struct rtw89_btc_bt_info *bt = (bid == BTC_BT_1ST) ? &cx->bt0 : &cx->bt1;
+	struct rtw89_btc_bt_link_info *b = &bt->link_info;
+	struct rtw89_btc_bt_leaudio_info *src = buf;
+	struct rtw89_btc_bt_leaudio_desc *leaudio;
+	bool bt_56g = false, cis_exist, bis_exist;
+	u8 bis_cnt, cis_cnt;
+
+	if ((src->len & BIT(7)) && bt->band_56G_support) {
+		b = &bt->link_info_56g;
+		bt_56g = true;
+	}
+
+	leaudio = &b->leaudio_desc;
+
+	if (!memcmp(b->leaudio_raw_info, src, BTC_BTINFO_MAX)) {
+		rtw89_debug(rtwdev, RTW89_DBG_BTC,
+			    "[BTC], %s return by leaudio-info duplicate!\n",
+			    __func__);
+		bt->bcnt[BTC_BCNT_LEAUDIO_INFOSAME]++;
+		return;
+	}
+
+	memcpy(b->leaudio_raw_info, src, BTC_BTINFO_MAX);
+
+	bis_exist = u8_get_bits(src->bis_cis, RTW89_BTC_LEAU_INFO_L2_BIS_EX);
+	cis_exist = u8_get_bits(src->bis_cis, RTW89_BTC_LEAU_INFO_L2_CIS_EX);
+	bis_cnt = u8_get_bits(src->bis_cis, RTW89_BTC_LEAU_INFO_L2_BIS_CNT);
+	cis_cnt = u8_get_bits(src->bis_cis, RTW89_BTC_LEAU_INFO_L2_CIS_CNT);
+
+	rtw89_debug(rtwdev, RTW89_DBG_BTC,
+		    "[BTC], %s: bis_exist:%d bis_cnt:%d cis_exist:%d cis_cnt:%d rssi:%d\n",
+		    __func__, bis_exist, bis_cnt, cis_exist, cis_cnt, src->rssi);
+
+	if (!bis_exist && !cis_exist)
+		memset(leaudio, 0, sizeof(*leaudio));
+
+	leaudio->bis_cnt = bis_cnt;
+	leaudio->bis_exist = bis_exist;
+	leaudio->cis_cnt = cis_cnt;
+	leaudio->cis_exist = cis_exist;
+
+	if (leaudio->bis_exist)
+		b->status.map.profile_map |= BTC_BT_BIS;
+	else
+		b->status.map.profile_map &= ~BTC_BT_BIS;
+
+	if (leaudio->cis_exist)
+		b->status.map.profile_map |= BTC_BT_CIS;
+	else
+		b->status.map.profile_map &= ~BTC_BT_CIS;
+
+	_update_bt_link_cnt(rtwdev, bt, bt_56g);
+
+	leaudio->rssi = chip->ops->btc_get_bt_rssi(rtwdev, src->rssi);
+
+	leaudio->bis_cnt_last = leaudio->bis_cnt;
+	leaudio->bis_exist_last = leaudio->bis_exist;
+	leaudio->cis_cnt_last = leaudio->cis_cnt;
+	leaudio->cis_exist_last = leaudio->cis_exist;
+}
+
+static void _update_bt_bistdma_info(struct rtw89_dev *rtwdev, u8 bid,
+				    void *buf, u32 len)
+{
+	struct rtw89_btc *btc = &rtwdev->btc;
+	struct rtw89_btc_cx *cx = &btc->cx;
+	struct rtw89_btc_dm *dm = &btc->dm;
+	struct rtw89_btc_bt_info *bt = (bid == BTC_BT_1ST) ? &cx->bt0 : &cx->bt1;
+	struct rtw89_btc_bt_link_info *b = &bt->link_info;
+	struct rtw89_btc_bt_bistdma_info_le *src = buf;
+	struct rtw89_btc_bt_leaudio_desc *leaudio;
+
+	if ((src->len & BIT(7)) && bt->band_56G_support)
+		b = &bt->link_info_56g;
+
+	leaudio = &b->leaudio_desc;
+
+	if (!memcmp(b->bistdma_raw_info, src, BTC_BTINFO_MAX)) {
+		rtw89_debug(rtwdev, RTW89_DBG_BTC,
+			    "[BTC], %s return by bistdma-info duplicate!\n",
+			    __func__);
+		bt->bcnt[BTC_BCNT_LEAUDIO_INFOSAME]++;
+		return;
+	}
+
+	memcpy(b->bistdma_raw_info, src, BTC_BTINFO_MAX);
+
+	rtw89_debug(rtwdev, RTW89_DBG_BTC,
+		    "[BTC], %s: bis_start_end:%d bis_trx:%d\n",
+		    __func__,
+		    u8_get_bits(src->bis, RTW89_BTC_BIS_INFO_L2_START_END),
+		    u8_get_bits(src->bis, RTW89_BTC_BIS_INFO_L2_TRX));
+
+	leaudio->bis_trx = u8_get_bits(src->bis, RTW89_BTC_BIS_INFO_L2_TRX);
+	leaudio->bis_start_end = u8_get_bits(src->bis,
+					     RTW89_BTC_BIS_INFO_L2_START_END);
+
+	leaudio->diff_t = (src->diff_t_hb * 256 + src->diff_t_lb) * 625 / 1000;
+
+	if (btc->ant_type == BTC_ANT_SHARED && leaudio->diff_t > 13)
+		dm->bis_tdma = true;
+	else
+		dm->bis_tdma = false;
+}
+
 #define BTC_BTINFO_PWR_LEN 5
 static void _update_bt_txpwr_info(struct rtw89_dev *rtwdev, u8 *buf, u32 len)
 {
@@ -9606,6 +9794,14 @@ void rtw89_btc_c2h_handle(struct rtw89_dev *rtwdev, struct sk_buff *skb,
 	case BTF_EVNT_CX_RUNINFO:
 		btc->dm.cnt_dm[BTC_DCNT_CX_RUNINFO]++;
 		break;
+	case BTF_EVNT_BT_LEAUDIO_INFO:
+		bt->bcnt[BTC_BCNT_LEAUDIO_INFOUPDATE]++;
+		if (buf[BTC_BTINFO_L0] == BTC_BTINFO_BISTDMA)
+			_update_bt_bistdma_info(rtwdev, bid, buf, len);
+		else
+			_update_bt_leaudio_info(rtwdev, bid, buf, len);
+		_run_coex(rtwdev, BTC_RSN_UPDATE_BT_LEAUDINFO);
+		break;
 	case BTF_EVNT_BT_QUERY_TXPWR:
 		bt->bcnt[BTC_BCNT_TXPWR_UPDATE]++;
 		_update_bt_txpwr_info(rtwdev, buf, len);
@@ -10107,6 +10303,7 @@ static const char *steps_to_str(u16 step)
 	CASE_BTC_RSN_STR(ACT1_WORK);
 	CASE_BTC_RSN_STR(BT_DEVINFO_WORK);
 	CASE_BTC_RSN_STR(RFK_CHK_WORK);
+	CASE_BTC_RSN_STR(UPDATE_BT_LEAUDINFO);
 
 	CASE_BTC_ACT_STR(NONE);
 	CASE_BTC_ACT_STR(WL_ONLY);
@@ -10131,6 +10328,8 @@ static const char *steps_to_str(u16 step)
 	CASE_BTC_ACT_STR(BT_A2DP_PAN);
 	CASE_BTC_ACT_STR(BT_PAN_HID);
 	CASE_BTC_ACT_STR(BT_A2DP_PAN_HID);
+	CASE_BTC_ACT_STR(BT_BIS);
+	CASE_BTC_ACT_STR(BT_CIS);
 	CASE_BTC_ACT_STR(WL_25G_MCC);
 	CASE_BTC_ACT_STR(WL_2G_MCC);
 	CASE_BTC_ACT_STR(WL_2G_SCC);
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index aaed155ea423..09c19a6b9058 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -1383,6 +1383,8 @@ enum rtw89_btc_btinfo {
 	BTC_BTINFO_MAX
 };
 
+#define BTC_BTINFO_BISTDMA 0x48 /* cmd value that identifies BISTDMA data */
+
 enum rtw89_btc_dcnt {
 	BTC_DCNT_RUN = 0x0,
 	BTC_DCNT_CX_RUNINFO,
@@ -2167,6 +2169,31 @@ struct rtw89_btc_bt_txpwr_desc {
 	u8 le_gain_index;
 };
 
+struct rtw89_btc_bt_leaudio_info {
+	u8 cmd;
+	u8 len;
+	u8 bis_cis;
+#define RTW89_BTC_LEAU_INFO_L2_BIS_EX BIT(0)
+#define RTW89_BTC_LEAU_INFO_L2_BIS_CNT GENMASK(3, 1)
+#define RTW89_BTC_LEAU_INFO_L2_CIS_EX BIT(4)
+#define RTW89_BTC_LEAU_INFO_L2_CIS_CNT GENMASK(7, 5)
+	u8 rssi;
+	__le32 hbrsvd;
+} __packed;
+
+struct rtw89_btc_bt_bistdma_info_le {
+	u8 cmd;
+	u8 len;
+	u8 bis; /* BIT(2) ~ BIT(7) is rsvd */
+#define RTW89_BTC_BIS_INFO_L2_START_END BIT(0) /* 0: BIS start, 1: BIS end */
+#define RTW89_BTC_BIS_INFO_L2_TRX BIT(1) /* 0: BIS Tx, 1: BIS Rx */
+	u8 diff_t_lb;
+	u8 diff_t_hb; /* diff_t = (diff_t_hb * 256 + diff_t_lb) * 0.625 ms */
+	u8 hb1rsvd;
+	u8 hb2rsvd;
+	u8 hb3rsvd;
+} __packed;
+
 struct rtw89_btc_bt_leaudio_desc {
 	u32 bis_exist: 1;
 	u32 bis_exist_last: 1;
@@ -2177,7 +2204,9 @@ struct rtw89_btc_bt_leaudio_desc {
 	u32 rssi: 8;
 	u32 bis_cnt_last: 3;
 	u32 cis_cnt_last: 3;
-	u32 rsvd: 8;
+	u32 bis_trx: 1;
+	u32 bis_start_end: 1;
+	u32 rsvd: 6;
 
 	u16 diff_t;
 };
@@ -2213,6 +2242,9 @@ struct rtw89_btc_bt_link_info {
 	u8 ble_scan_en: 1;
 	u8 reinit: 1;
 	u8 rsvd: 6;
+
+	u8 leaudio_raw_info[BTC_BTINFO_MAX]; /* raw LE audio info from BT mailbox */
+	u8 bistdma_raw_info[BTC_BTINFO_MAX]; /* raw BIS-TDMA info from BT mailbox */
 };
 
 struct rtw89_btc_bind_bt_status {
@@ -4085,6 +4117,7 @@ struct rtw89_btc_dm {
 	u8 lps_ctrl_scbd: 1;
 	u8 lps_ctrl_scbd_last: 1;
 	u8 lps_ctrl_change: 1;
+	u8 bis_tdma: 1; /* BIS TDMA mode active */
 	u8 scbd_write_instant;
 	bool scbd_b2w_update;
 	bool scbd_w2b_update;
-- 
2.25.1

