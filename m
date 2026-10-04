Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398EF3E2777
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 03:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791085627; cv=none; b=uRb+6jZUyI/QQk/TuYf2adClUsdkSP7R0VU7TKDeVWAnAnGbmF6EaNXO13f27su0xlQ/g/c4ddnNT901rx74ANDgrfqcRv/LLo9lcCK/87OaJ0x+BNhmop+z9Scn6NbEoa0CXqNTA44dyASWoL3C6ZimtDcglf6pl7cdlgpm/pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791085627; c=relaxed/simple;
	bh=BHonB+oftk1JEtdzoApotFfHT71JtmUloebDGh85fw4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WhaNfNnvq4DNanY3OFSQ0V77SNn9CIZ9OGU+uv9GcAMKmFSXHbEC2Hx4ySglctBKKzqbPtCjV/gGND0lERxl/0vMWTDBsAAFXDIvnc5P2hs4oiECiMjS2aXgn65u104diBZmz1G4OazX6kgyriABzkVylQWCwDstN7VozcPmuXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=kFEikl6+; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="kFEikl6+"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6943l3KG1829622, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791085623; bh=u0xBAKqd4sMm3YXCX4+Zqvaz8rC/UP9w4rGNGZtMzDQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=kFEikl6+cP30d6QPworDCB9g3WehVyW7k0Hx14jVh6xUcY7uOD5zt9tJORHTjnKsT
	 wXwjF9UJ5EJJE9vxnuSQe1sGTW24ZlgL+9MiIeJKv50MP9Y0H7sC0M0z86e1q9A6tX
	 9srSqLfZj+6/B6t7DnXszZL870bDdtq98GjL3+xfO23MJ7Oy1LmwXOkvsbWWqgfiK1
	 MtUGlAWKLxDWJfYAe1qPCfgLqyeSTDw22IbZr0novurndkxKy0REr3qEwDSz85cyHT
	 VrDhz8VMY/7pfIBH+2VPIkWf+dRPK96uRg1lK0VmAzT4QPcciNCPsgOp6Uco1sSmBv
	 S5ZJfSlKlvnpg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6943l3KG1829622
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 4 Oct 2026 11:47:03 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:47:04 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:47:03 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Sun, 4 Oct 2026 11:47:03 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 11/15] wifi: rtw89: coex: set the WL/BT antenna map on shared-antenna chips
Date: Sun, 4 Oct 2026 11:45:16 +0800
Message-ID: <20261004034520.33695-12-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261004034520.33695-1-pkshih@realtek.com>
References: <20261004034520.33695-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

The WL/BT space-interaction map that decides whether a WL RF-path and a
BT take a TDD or an FDD action is built from the antenna-division map
with the cross-talk map. A WL RF-path that physically shares its
antenna with a BT must be marked in the antenna-division map, otherwise
it is only ever marked interacting when the measured WL RSSI happens to
fall below the BT Tx interference threshold, and a shared-antenna design
with a strong WL signal gets bound to FDD where it has to coexist in
time instead.

Chips with a single BT never filled that map, so fill it from the RFE
type that the antenna configuration is already derived from: mark the
one WL RF-path that carries the BTG circuit as sharing with the only BT
whenever the antenna type is shared, and leave the map clear for the
dedicated-antenna RFE types where the BT has an antenna of its own. The
second-BT and external-coexistence columns stay clear because these
designs have neither.

This is driver-internal state only. The coex init information these
chips send to firmware has no antenna-map field, so what reaches the
firmware is unchanged.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/rtw8851b.c  | 5 +++++
 drivers/net/wireless/realtek/rtw89/rtw8852a.c  | 5 +++++
 drivers/net/wireless/realtek/rtw89/rtw8852b.c  | 5 +++++
 drivers/net/wireless/realtek/rtw89/rtw8852bt.c | 6 ++++++
 drivers/net/wireless/realtek/rtw89/rtw8852c.c  | 5 +++++
 5 files changed, 26 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8851b.c b/drivers/net/wireless/realtek/rtw89/rtw8851b.c
index db37ad6653bc..272f4f4e1fb9 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8851b.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8851b.c
@@ -2119,6 +2119,7 @@ static u8 rtw8851b_get_thermal(struct rtw89_dev *rtwdev, enum rtw89_rf_path rf_p
 static void rtw8851b_btc_set_rfe(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_btc_module *md = &rtwdev->btc.mdinfo;
+	struct rtw89_btc_dm *dm = &rtwdev->btc.dm;
 
 	md->rfe_type = rtwdev->efuse.rfe_type;
 	md->kt_ver = rtwdev->hal.cv;
@@ -2127,6 +2128,8 @@ static void rtw8851b_btc_set_rfe(struct rtw89_dev *rtwdev)
 	md->ant.isolation = 10;
 	md->kt_ver_adie = rtwdev->hal.acv;
 
+	memset(dm->ant_xmap, 0, sizeof(dm->ant_xmap));
+
 	if (md->rfe_type == 0)
 		return;
 
@@ -2145,6 +2148,8 @@ static void rtw8851b_btc_set_rfe(struct rtw89_dev *rtwdev)
 		md->bt0_pos = BTC_BT_BTG;
 		md->wa_type = 1;
 		md->ant.diversity = 0;
+		/* the only BT shares the BTG antenna with WL path A */
+		dm->ant_xmap[BTC_RF_S0][BTC_BT_1ST] = 1;
 	} else { /* ant.num == 2 */
 		md->ant.type = BTC_ANT_DEDICATED;
 		md->bt0_pos = BTC_BT_ALONE;
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852a.c b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
index 4b364f039464..5207df4f9cd5 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852a.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
@@ -1836,6 +1836,7 @@ static u8 rtw8852a_get_thermal(struct rtw89_dev *rtwdev, enum rtw89_rf_path rf_p
 static void rtw8852a_btc_set_rfe(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_btc_module *md = &rtwdev->btc.mdinfo;
+	struct rtw89_btc_dm *dm = &rtwdev->btc.dm;
 
 	md->rfe_type = rtwdev->efuse.rfe_type;
 	md->kt_ver = rtwdev->hal.cv;
@@ -1850,12 +1851,16 @@ static void rtw8852a_btc_set_rfe(struct rtw89_dev *rtwdev)
 	md->ant.diversity = 0;
 	md->ant.isolation = 10;
 
+	memset(dm->ant_xmap, 0, sizeof(dm->ant_xmap));
+
 	if (md->ant.num == 3) {
 		md->ant.type = BTC_ANT_DEDICATED;
 		md->bt0_pos = BTC_BT_ALONE;
 	} else {
 		md->ant.type = BTC_ANT_SHARED;
 		md->bt0_pos = BTC_BT_BTG;
+		/* the only BT shares the BTG antenna with WL path B */
+		dm->ant_xmap[BTC_RF_S1][BTC_BT_1ST] = 1;
 	}
 	rtwdev->btc.btg_pos = md->ant.btg_pos;
 	rtwdev->btc.ant_type = md->ant.type;
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852b.c b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
index c3c53a6b8119..060c99532936 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852b.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
@@ -748,6 +748,7 @@ static void rtw8852b_rfk_track(struct rtw89_dev *rtwdev)
 static void rtw8852b_btc_set_rfe(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_btc_module *md = &rtwdev->btc.mdinfo;
+	struct rtw89_btc_dm *dm = &rtwdev->btc.dm;
 
 	md->rfe_type = rtwdev->efuse.rfe_type;
 	md->kt_ver = rtwdev->hal.cv;
@@ -762,12 +763,16 @@ static void rtw8852b_btc_set_rfe(struct rtw89_dev *rtwdev)
 	md->ant.diversity = 0;
 	md->ant.isolation = 10;
 
+	memset(dm->ant_xmap, 0, sizeof(dm->ant_xmap));
+
 	if (md->ant.num == 3) {
 		md->ant.type = BTC_ANT_DEDICATED;
 		md->bt0_pos = BTC_BT_ALONE;
 	} else {
 		md->ant.type = BTC_ANT_SHARED;
 		md->bt0_pos = BTC_BT_BTG;
+		/* the only BT shares the BTG antenna with WL path B */
+		dm->ant_xmap[BTC_RF_S1][BTC_BT_1ST] = 1;
 	}
 	rtwdev->btc.btg_pos = md->ant.btg_pos;
 	rtwdev->btc.ant_type = md->ant.type;
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852bt.c b/drivers/net/wireless/realtek/rtw89/rtw8852bt.c
index 3d93cee562c2..23ad02d1fcd4 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852bt.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852bt.c
@@ -636,6 +636,7 @@ static void rtw8852bt_rfk_track(struct rtw89_dev *rtwdev)
 static void rtw8852bt_btc_set_rfe(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_btc_module *md = &rtwdev->btc.mdinfo;
+	struct rtw89_btc_dm *dm = &rtwdev->btc.dm;
 
 	md->rfe_type = rtwdev->efuse.rfe_type;
 	md->kt_ver = rtwdev->hal.cv;
@@ -653,6 +654,10 @@ static void rtw8852bt_btc_set_rfe(struct rtw89_dev *rtwdev)
 	md->ant.single_pos = RF_PATH_A;
 	md->ant.btg_pos = RF_PATH_B;
 
+	memset(dm->ant_xmap, 0, sizeof(dm->ant_xmap));
+	/* the only BT shares the BTG antenna with WL path B */
+	dm->ant_xmap[BTC_RF_S1][BTC_BT_1ST] = 1;
+
 	if (md->rfe_type == 0) {
 		rtwdev->btc.dm.error.map.rfe_type0 = true;
 		return;
@@ -669,6 +674,7 @@ static void rtw8852bt_btc_set_rfe(struct rtw89_dev *rtwdev)
 	} else {
 		md->ant.type = BTC_ANT_DEDICATED;
 		md->bt0_pos = BTC_BT_ALONE;
+		dm->ant_xmap[BTC_RF_S1][BTC_BT_1ST] = 0;
 	}
 }
 
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852c.c b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
index 624f23b3f2a1..e556ba0c14a7 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852c.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
@@ -2609,6 +2609,7 @@ static u8 rtw8852c_get_thermal(struct rtw89_dev *rtwdev, enum rtw89_rf_path rf_p
 static void rtw8852c_btc_set_rfe(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_btc_module *md = &rtwdev->btc.mdinfo;
+	struct rtw89_btc_dm *dm = &rtwdev->btc.dm;
 
 	md->rfe_type = rtwdev->efuse.rfe_type;
 	md->kt_ver = rtwdev->hal.cv;
@@ -2623,12 +2624,16 @@ static void rtw8852c_btc_set_rfe(struct rtw89_dev *rtwdev)
 	md->ant.diversity = 0;
 	md->ant.isolation = 10;
 
+	memset(dm->ant_xmap, 0, sizeof(dm->ant_xmap));
+
 	if (md->ant.num == 3) {
 		md->ant.type = BTC_ANT_DEDICATED;
 		md->bt0_pos = BTC_BT_ALONE;
 	} else {
 		md->ant.type = BTC_ANT_SHARED;
 		md->bt0_pos = BTC_BT_BTG;
+		/* the only BT shares the BTG antenna with WL path B */
+		dm->ant_xmap[BTC_RF_S1][BTC_BT_1ST] = 1;
 	}
 	rtwdev->btc.btg_pos = md->ant.btg_pos;
 	rtwdev->btc.ant_type = md->ant.type;
-- 
2.25.1

