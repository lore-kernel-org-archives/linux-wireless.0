Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD03376BF2
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391374; cv=none; b=GbdXr/rAWxeXg807CHTeQtTt/HVPb12nvS7ddkvVViYSLiiSN4oKfEgNpWtAg1DOMU6GzEMlo0psUiop3BMNCoF+OGEQk5inWy7wLJMYe84JNHfUnUC9WoIVcJpA+IEuAnjn80wwtAiZFAPU6amkn8N88NCL0h5CPtYb1wwQg00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391374; c=relaxed/simple;
	bh=vYoxLjVCCgV7wWuAuPaQl5x9+ekKLYOsAVGScFc/iLA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YNqPr2AaSfKu7Xa/XJSM6Asuat+9QrkcOMpGH85f+q+4gJnv9DYWCFZGBYWg6l8749eCgJku6n3lN9WxcbX9Jjb4I6+fZX4L2vDza8D/0YZkuOgZ0r3Y1N/lE0EwX44kRpzNIZGhpm7zViFvu5ddpP0ODzAXj765ki1tNxoMLys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Nf2ywiDM; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Nf2ywiDM"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66U62nIG2985921, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785391369; bh=805t/kXDYWlWoIgr2eGmm/qgYRQf7Y9JxgW3Ay3pUZw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=Nf2ywiDMZGjgZVfKDOOdwfLjSA2+yA+g2oLQDgXvuESzpjVdt5cjang0vkuFFyucd
	 7jZ/U5fDJ1iAwrsA4TD8DQLRUj6paqDGVaWCWSFN8W9cFT3CbdA9om8YI1O3oZcyFk
	 /DYE4X68/vGspl0bBPizDobK8AFoxJjzSiIlbmu90iZesqcPiIcrWRmAON+ogVP79a
	 0zxRFClmsY4qN15Ds2Q1Ga6H3u+PsB265StX9YxX+7fq5FnmsvFQ7sOzAK3uqUpx1B
	 aS9ua7tz52qNiYFtj53Jb5TyRunbx31cUOmBX4cT3vCAE1FPNsx8tItGSf8AeN/ZiI
	 zTodPx+bIDWZg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66U62nIG2985921
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 14:02:49 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 14:02:50 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 14:02:49 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Thu, 30 Jul 2026 14:02:49 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 5/7] wifi: rtw89: coex: Port _update_bt_ctrl_lps() for BT profile-based LPS control
Date: Thu, 30 Jul 2026 14:02:18 +0800
Message-ID: <20260730060220.55844-6-pkshih@realtek.com>
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

The old lps_ctrl_scbd logic in _update_bt_scbd() blocked WiFi LPS only
when mode == BTC_WLINK_V0_2G_STA, which created a dead-lock while
WiFi already in LPS suppressed TDD binding so mode was never set to
BTC_WLINK_V0_2G_STA, lps_ctrl_scbd stayed 0, and WiFi remained stuck
in LPS. Port _update_bt_ctrl_lps() from the reference implementation to
check BT profile existence (A2DP, HFP, PAN) for both radios directly,
with out_of_band and freerun guards so LPS is only blocked when WiFi and
Bluetooth actually share a band. Call it from both _update_bt_scbd() and
_update_bt_info() so profile changes reported via either SCBD or BT info
C2H correctly update lps_ctrl_scbd. Also remove the dead
lps_ctrl_scbd_last field.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 51 +++++++++++++++--------
 drivers/net/wireless/realtek/rtw89/core.h |  1 -
 2 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 2f06fcf0d67f..39dff9fdc1cd 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -3238,8 +3238,6 @@ static void _fw_set_policy(struct rtw89_dev *rtwdev, u16 policy_type,
 	else
 		btc->btc_ctrl_lps = dm->lps_ctrl_scbd;
 
-	dm->lps_ctrl_scbd_last = dm->lps_ctrl_scbd;
-
 	if (btc->btc_ctrl_lps == 1)
 		rtw89_set_coex_ctrl_lps(rtwdev, btc->btc_ctrl_lps);
 
@@ -7778,6 +7776,35 @@ void rtw89_coex_rfk_chk_work(struct wiphy *wiphy, struct wiphy_work *work)
 	}
 }
 
+static void _update_bt_ctrl_lps(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_btc *btc = &rtwdev->btc;
+	struct rtw89_btc_bt_info *bt0 = &btc->cx.bt0;
+	struct rtw89_btc_bt_info *bt1 = &btc->cx.bt1;
+	struct rtw89_btc_dm *dm = &btc->dm;
+	bool lps_ctrl = false;
+
+	if (dm->out_of_band || dm->freerun)
+		lps_ctrl = false;
+	else if (bt0->whql_test || bt1->whql_test)
+		lps_ctrl = true;
+	else if (bt0->link_info.a2dp_desc.exist ||
+		 bt0->link_info.hfp_desc.exist ||
+		 bt0->link_info.pan_desc.exist)
+		lps_ctrl = true;
+	else if (bt1->link_info.a2dp_desc.exist ||
+		 bt1->link_info.hfp_desc.exist ||
+		 bt1->link_info.pan_desc.exist)
+		lps_ctrl = true;
+
+	if (dm->lps_ctrl_scbd != lps_ctrl) {
+		dm->lps_ctrl_scbd = lps_ctrl;
+		dm->lps_ctrl_change = true;
+	} else {
+		dm->lps_ctrl_change = false;
+	}
+}
+
 static void _update_bt_scbd(struct rtw89_dev *rtwdev, u8 bid)
 {
 	struct rtw89_btc_bt_link_info *bt_2g, *bt_56g;
@@ -7786,7 +7813,7 @@ static void _update_bt_scbd(struct rtw89_dev *rtwdev, u8 bid)
 	struct rtw89_btc_dm *dm = &btc->dm;
 	struct rtw89_btc_bt_info *bt;
 	u32 val, any_bt_connect, any_bt_6g_connect = 0;
-	bool bt_link_change = false, lps_ctrl = false;
+	bool bt_link_change = false;
 	u8 id, id_start, id_stop;
 
 	if (!rtwdev->chip->scbd || bid > BTC_ALL_BT)
@@ -7879,25 +7906,12 @@ static void _update_bt_scbd(struct rtw89_dev *rtwdev, u8 bid)
 			bt_56g->status.map.connect = any_bt_6g_connect;
 		}
 
-		/* if specific profile exist */
-		if (bt->link_info.a2dp_desc.exist ||
-		    bt->link_info.pan_desc.exist ||
-		    bt->link_info.hfp_desc.exist ||
-		    bt->whql_test)
-			lps_ctrl = true;
-
-		if (dm->lps_ctrl_scbd  != lps_ctrl) {
-			dm->lps_ctrl_scbd  = lps_ctrl;
-			bt_link_change = true;
-			dm->lps_ctrl_change = true;
-		} else {
-			dm->lps_ctrl_change = false;
-		}
-
 		bt->run_patch_code = !!(val & BTC_BSCB_PATCH_CODE);
 		bt->scbd = val;
 	}
 
+	_update_bt_ctrl_lps(rtwdev);
+
 	if (bt_link_change) {
 		rtw89_debug(rtwdev, RTW89_DBG_BTC,
 			    "[BTC], %s: bt status change!!\n", __func__);
@@ -9136,6 +9150,7 @@ static void _update_bt_info(struct rtw89_dev *rtwdev, u8 bid, u8 *buf, u32 len)
 					 RTW89_COEX_BT_DEVINFO_WORK_PERIOD);
 	}
 
+	_update_bt_ctrl_lps(rtwdev);
 	_run_coex(rtwdev, BTC_RSN_UPDATE_BT_INFO);
 }
 
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index bc9db0c16473..34187b6c820b 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -4116,7 +4116,6 @@ struct rtw89_btc_dm {
 	u8 fdd_en: 1;
 	u8 tdd_en: 1;
 	u8 lps_ctrl_scbd: 1;
-	u8 lps_ctrl_scbd_last: 1;
 	u8 lps_ctrl_change: 1;
 	u8 bis_tdma: 1; /* BIS TDMA mode active */
 	u8 scbd_write_instant;
-- 
2.25.1

