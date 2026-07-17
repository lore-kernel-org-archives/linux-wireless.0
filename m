Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14363D1AA2
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784271579; cv=none; b=dXuzRZAuwjaRRvrk2jwNJ/k0hviYvS3LiRj39BpYlVCvjCeeCq+oQdUjgWLKuxnnnSfv79GxLVX+AeOEgQiuRxXOxaSwkqNIkMu389W5w2h0MRPkEe90IML95XioqWrUVCbbDCtcWyhneFERo7Rl4gQLdXPIFrF5Wohft0Ln1Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784271579; c=relaxed/simple;
	bh=UzeP+KRX0dmeAdn3RH63CohXeaiBFh027a7+2RzlOLc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IrlD3X3KmJArtGLdwEAdXtymFpE9dpQ/RsR75kI1J6Y40SpYyc4jkbEks8SeIkEoXP0m6bzsA7rPHbkvKxAxXhOS0Lh4etz+JDkmxPePs/nswINEcI5x6k8bWHAWDSxK6Z/AXstOePS3uiNZx7/5uKjgcCGWDNsyWiSHqZeDdzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=rh5pJIEK; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="rh5pJIEK"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H6xZaK54176996, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784271575; bh=WgKMxe53rTcLl7FgOwUjDshICo7T44uO9Xe+kAb7ukU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=rh5pJIEKgETIOe6QEQSuww2yK7c69vnFAZL4+gB7qok5mtDO2aSAR0/JI8hImmckj
	 PmR24gSH+OylMSR/5WZUUTwNE2RTsAcC7mUzyI0HpdKgjKXX3vNNg50AECYfnBwn/a
	 FmiWXDRk7PpHwUpUQM7DdRKwBVKHLfaa2qwDTvoafHCdMzgaPfZX/DQp12hq7EI2Vi
	 txVfYEdKNS5bY63r62iGo9XUe7y0sXff5TWB4B/c+WMqcVfEzPzCNEBk26z+ykPwEf
	 mwXTI/1X/oRpbDfGOP3kLvY0BTDD6UM4w5fQm25uptKqWVOJivhMFkqD/1hGrDv4Ew
	 j8ev8+r51RGPA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H6xZaK54176996
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:59:35 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:59:35 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 14:59:35 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 10/13] wifi: rtw89: coex: Add slots version 2
Date: Fri, 17 Jul 2026 14:57:36 +0800
Message-ID: <20260717065739.64124-11-pkshih@realtek.com>
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

Slots structure version 2 uses new TLV-Header to package slots information,
patch related entry for version 2.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 54 ++++++++++++++++-------
 drivers/net/wireless/realtek/rtw89/coex.h |  8 ++--
 drivers/net/wireless/realtek/rtw89/core.h |  9 ++++
 3 files changed, 51 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 51108ce5ce31..65d4e9139342 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -1133,7 +1133,7 @@ static void _reset_btc_var(struct rtw89_dev *rtwdev, u8 type)
 		/* set the slot_now table to original */
 		btc->dm.tdma_now = t_def[CXTD_OFF];
 		btc->dm.tdma = t_def[CXTD_OFF];
-		if (ver->fcxslots >= 7) {
+		if (ver->fcxslots >= 2) {
 			for (i = 0; i < ARRAY_SIZE(s_def); i++) {
 				btc->dm.slot.v7[i].dur = s_def[i].dur;
 				btc->dm.slot.v7[i].cxtype = s_def[i].cxtype;
@@ -1721,6 +1721,10 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 			pfinfo = &pfwinfo->rpt_fbtc_slots.finfo.v1;
 			pcinfo->req_len = sizeof(pfwinfo->rpt_fbtc_slots.finfo.v1);
 			fwsubver->fcxslots = pfwinfo->rpt_fbtc_slots.finfo.v1.fver;
+		} else if (ver->fcxslots == 2) {
+			pfinfo = &pfwinfo->rpt_fbtc_slots.finfo.v2;
+			pcinfo->req_len = sizeof(pfwinfo->rpt_fbtc_slots.finfo.v2);
+			fwsubver->fcxslots = pfwinfo->rpt_fbtc_slots.finfo.v2.fver;
 		} else if (ver->fcxslots == 7) {
 			pfinfo = &pfwinfo->rpt_fbtc_slots.finfo.v7;
 			pcinfo->req_len = sizeof(pfwinfo->rpt_fbtc_slots.finfo.v7);
@@ -2232,6 +2236,15 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 				     memcmp(dm->slot_now.v7,
 					    pfwinfo->rpt_fbtc_slots.finfo.v7.slot,
 					    sizeof(dm->slot_now.v7)));
+		} else if (ver->fcxslots == 2) {
+			rtw89_debug(rtwdev, RTW89_DBG_BTC,
+				    "[BTC], %s(): check %d %zu\n",
+				    __func__, BTC_DCNT_SLOT_NONSYNC,
+				    sizeof(dm->slot_now.v7));
+			_chk_btc_err(rtwdev, BTC_DCNT_SLOT_NONSYNC,
+				     memcmp(dm->slot_now.v7,
+					    pfwinfo->rpt_fbtc_slots.finfo.v2.slot,
+					    sizeof(dm->slot_now.v7)));
 		} else if (ver->fcxslots == 1) {
 			rtw89_debug(rtwdev, RTW89_DBG_BTC,
 				    "[BTC], %s(): check %d %zu\n",
@@ -2687,7 +2700,7 @@ static void _append_slot(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_btc *btc = &rtwdev->btc;
 
-	if (btc->ver->fcxslots == 7)
+	if (btc->ver->fcxslots == 2 || btc->ver->fcxslots == 7)
 		_append_slot_v7(rtwdev);
 	else
 		_append_slot_v1(rtwdev);
@@ -2902,7 +2915,7 @@ static void rtw89_btc_fw_set_slots(struct rtw89_dev *rtwdev)
 	struct rtw89_btc_dm *dm = &btc->dm;
 	u16 n, len;
 
-	if (ver->fcxslots == 7) {
+	if (ver->fcxslots == 2 || ver->fcxslots == 7) {
 		len = sizeof(*tlv_v7) + sizeof(dm->slot.v7);
 		tlv_v7 = kmalloc(len, GFP_KERNEL);
 		if (!tlv_v7)
@@ -3096,7 +3109,7 @@ static void _fw_set_policy(struct rtw89_dev *rtwdev, u16 policy_type,
 			   btc->policy, btc->policy_len);
 	if (!ret) {
 		memcpy(&dm->tdma_now, &dm->tdma, sizeof(dm->tdma_now));
-		if (btc->ver->fcxslots == 7)
+		if (btc->ver->fcxslots == 2 || btc->ver->fcxslots == 7)
 			memcpy(&dm->slot_now.v7, &dm->slot.v7, sizeof(dm->slot_now.v7));
 		else
 			memcpy(&dm->slot_now.v1, &dm->slot.v1, sizeof(dm->slot_now.v1));
@@ -4404,7 +4417,6 @@ void rtw89_btc_set_policy(struct rtw89_dev *rtwdev, u16 policy_type)
 	struct rtw89_btc *btc = &rtwdev->btc;
 	struct rtw89_btc_dm *dm = &btc->dm;
 	struct rtw89_btc_fbtc_tdma *t = &dm->tdma;
-	struct rtw89_btc_fbtc_slot *s = dm->slot.v1;
 	u8 type;
 	u32 tbl_w1, tbl_b1, tbl_b4;
 	bool tdma_on = false;
@@ -4428,14 +4440,16 @@ void rtw89_btc_set_policy(struct rtw89_dev *rtwdev, u16 policy_type)
 	switch (type) {
 	case BTC_CXP_USERDEF0:
 		*t = t_def[CXTD_OFF];
-		s[CXST_OFF] = s_def[CXST_OFF];
+		_slot_set_le(btc, CXST_OFF, s_def[CXST_OFF].dur,
+			     s_def[CXST_OFF].cxtbl, s_def[CXST_OFF].cxtype);
 		_slot_set_tbl(btc, CXST_OFF, cxtbl[2]);
 		btc->update_policy_force = true;
 		break;
 	case BTC_CXP_OFF: /* TDMA off */
 		tdma_on = false;
 		*t = t_def[CXTD_OFF];
-		s[CXST_OFF] = s_def[CXST_OFF];
+		_slot_set_le(btc, CXST_OFF, s_def[CXST_OFF].dur,
+			     s_def[CXST_OFF].cxtbl, s_def[CXST_OFF].cxtype);
 
 		switch (policy_type) {
 		case BTC_CXP_OFF_BT:
@@ -4498,16 +4512,23 @@ void rtw89_btc_set_policy(struct rtw89_dev *rtwdev, u16 policy_type)
 		*t = t_def[CXTD_OFF_EXT];
 		switch (policy_type) {
 		case BTC_CXP_OFFE_DEF:
-			s[CXST_E2G] = s_def[CXST_E2G];
-			s[CXST_E5G] = s_def[CXST_E5G];
-			s[CXST_EBT] = s_def[CXST_EBT];
-			s[CXST_ENULL] = s_def[CXST_ENULL];
+			_slot_set_le(btc, CXST_E2G, s_def[CXST_E2G].dur,
+				     s_def[CXST_E2G].cxtbl, s_def[CXST_E2G].cxtype);
+			_slot_set_le(btc, CXST_E5G, s_def[CXST_E5G].dur,
+				     s_def[CXST_E5G].cxtbl, s_def[CXST_E5G].cxtype);
+			_slot_set_le(btc, CXST_EBT, s_def[CXST_EBT].dur,
+				     s_def[CXST_EBT].cxtbl, s_def[CXST_EBT].cxtype);
+			_slot_set_le(btc, CXST_ENULL, s_def[CXST_ENULL].dur,
+				     s_def[CXST_ENULL].cxtbl, s_def[CXST_ENULL].cxtype);
 			break;
 		case BTC_CXP_OFFE_DEF2:
 			_slot_set(btc, CXST_E2G, 20, cxtbl[1], SLOT_ISO);
-			s[CXST_E5G] = s_def[CXST_E5G];
-			s[CXST_EBT] = s_def[CXST_EBT];
-			s[CXST_ENULL] = s_def[CXST_ENULL];
+			_slot_set_le(btc, CXST_E5G, s_def[CXST_E5G].dur,
+				     s_def[CXST_E5G].cxtbl, s_def[CXST_E5G].cxtype);
+			_slot_set_le(btc, CXST_EBT, s_def[CXST_EBT].dur,
+				     s_def[CXST_EBT].cxtbl, s_def[CXST_EBT].cxtype);
+			_slot_set_le(btc, CXST_ENULL, s_def[CXST_ENULL].dur,
+				     s_def[CXST_ENULL].cxtbl, s_def[CXST_ENULL].cxtype);
 			break;
 		}
 		break;
@@ -10081,6 +10102,7 @@ static int _show_fbtc_tdma(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 static int _show_fbtc_slots(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 {
 	struct rtw89_btc *btc = &rtwdev->btc;
+	const struct rtw89_btc_ver *ver = btc->ver;
 	struct rtw89_btc_dm *dm = &btc->dm;
 	char *p = buf, *end = buf + bufsz;
 	u16 dur, cxtype;
@@ -10088,11 +10110,11 @@ static int _show_fbtc_slots(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 	u8 i = 0;
 
 	for (i = 0; i < CXST_MAX; i++) {
-		if (btc->ver->fcxslots == 1) {
+		if (ver->fcxslots == 1) {
 			dur = le16_to_cpu(dm->slot_now.v1[i].dur);
 			tbl = le32_to_cpu(dm->slot_now.v1[i].cxtbl);
 			cxtype = le16_to_cpu(dm->slot_now.v1[i].cxtype);
-		} else if (btc->ver->fcxslots == 7) {
+		} else if (ver->fcxslots == 2 || ver->fcxslots == 7) {
 			dur = le16_to_cpu(dm->slot_now.v7[i].dur);
 			tbl = le32_to_cpu(dm->slot_now.v7[i].cxtbl);
 			cxtype = le16_to_cpu(dm->slot_now.v7[i].cxtype);
diff --git a/drivers/net/wireless/realtek/rtw89/coex.h b/drivers/net/wireless/realtek/rtw89/coex.h
index e17407696d8a..3238c44429a9 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.h
+++ b/drivers/net/wireless/realtek/rtw89/coex.h
@@ -424,7 +424,7 @@ void _slot_set_le(struct rtw89_btc *btc, u8 sid, __le16 dura, __le32 tbl, __le16
 		btc->dm.slot.v1[sid].dur = dura;
 		btc->dm.slot.v1[sid].cxtbl = tbl;
 		btc->dm.slot.v1[sid].cxtype = type;
-	} else if (btc->ver->fcxslots == 7) {
+	} else if (btc->ver->fcxslots == 2 || btc->ver->fcxslots == 7) {
 		btc->dm.slot.v7[sid].dur = dura;
 		btc->dm.slot.v7[sid].cxtype = type;
 		btc->dm.slot.v7[sid].cxtbl = tbl;
@@ -442,7 +442,7 @@ void _slot_set_dur(struct rtw89_btc *btc, u8 sid, u16 dura)
 {
 	if (btc->ver->fcxslots == 1)
 		btc->dm.slot.v1[sid].dur = cpu_to_le16(dura);
-	else if (btc->ver->fcxslots == 7)
+	else if (btc->ver->fcxslots == 2 || btc->ver->fcxslots == 7)
 		btc->dm.slot.v7[sid].dur = cpu_to_le16(dura);
 }
 
@@ -451,7 +451,7 @@ void _slot_set_type(struct rtw89_btc *btc, u8 sid, u16 type)
 {
 	if (btc->ver->fcxslots == 1)
 		btc->dm.slot.v1[sid].cxtype = cpu_to_le16(type);
-	else if (btc->ver->fcxslots == 7)
+	else if (btc->ver->fcxslots == 2 || btc->ver->fcxslots == 7)
 		btc->dm.slot.v7[sid].cxtype = cpu_to_le16(type);
 }
 
@@ -460,7 +460,7 @@ void _slot_set_tbl(struct rtw89_btc *btc, u8 sid, u32 tbl)
 {
 	if (btc->ver->fcxslots == 1)
 		btc->dm.slot.v1[sid].cxtbl = cpu_to_le32(tbl);
-	else if (btc->ver->fcxslots == 7)
+	else if (btc->ver->fcxslots == 2 || btc->ver->fcxslots == 7)
 		btc->dm.slot.v7[sid].cxtbl = cpu_to_le32(tbl);
 }
 
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 110549b268d4..5018c642dba0 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -3091,6 +3091,14 @@ struct rtw89_btc_fbtc_slot_v7 {
 	__le32 cxtbl;
 } __packed;
 
+struct rtw89_btc_fbtc_slots_v2 {
+	u8 fver; /* btc_ver::fcxslots */
+	u8 tbl_num;
+	__le16 rsvd;
+	__le32 update_map;
+	struct rtw89_btc_fbtc_slot_v7 slot[CXST_MAX];
+} __packed;
+
 struct rtw89_btc_fbtc_slot_u16 {
 	__le16 dur; /* slot duration */
 	__le16 cxtype;
@@ -3116,6 +3124,7 @@ struct rtw89_btc_fbtc_slots_v7 {
 
 union rtw89_btc_fbtc_slots_info {
 	struct rtw89_btc_fbtc_slots v1;
+	struct rtw89_btc_fbtc_slots_v2 v2;
 	struct rtw89_btc_fbtc_slots_v7 v7;
 } __packed;
 
-- 
2.25.1

