Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC27A468C26
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 07:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543488; cv=none; b=j5Sc5w6yhB6VQY1M8i74zWckINbmUcavX/K/hRl3CUSTVjoCXxSv90P9a290oM1kVcFqo8/hgvdi0IQ/vhEK5zxx8+u5IhmnITNOjuWz1mjyWFtw5vykbNSK8ZFLPcAI2fBlE7xHRSKdVGxTGe/tgHNSLPD+eMXOAWVll8inlKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543488; c=relaxed/simple;
	bh=FJgn/Pxn3xstxiMTnXW2CbzUrMQ6PJJ7f18FXfGsnhA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qvLBNcZ33uQGUyYxjfZg3lyT8ADzzqXA2svhAyPNyRGsj0XMol8ld9gdPRcZvesDJB7Kj1dl/kRUgig1THJAuC8ti3lMWFGQ75pEd3/xTtDw9Ca0VB0qGbhlkViFMyyrYaZ4H+0QrYNsvWh60VNmN4Lj2mHAbH5lHvhfQUFTNa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=luYNhhy5; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="luYNhhy5"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G7OMLs82168611, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789543463; bh=hJyyGwIRRp+SUmqbIUYuOwHYji0Qvd3mgsAyw6oXkbQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=luYNhhy527Q9HuQZcpJPujJkgxknrF3QY4b5zth3l4q7sJtrxvOzTP8M3+FJ9uXmH
	 Hc3l5/6rwVIL3TgvKHr8fOmLiM98YPZi23DmG7Vhq4210+8dJK/+UR1SMeWr6LTQ2d
	 GY3j1q45E/bWWeSM54EH/3OTAr5yDSpn1E80uW2ur5rcbphhSpvj8jQ4Kl1X0LwtTk
	 qFmMmWWoBondE3gz3wIGFd5xwExQ1SU03rPYbnipwBNVx2/b9fI6BuGiDASClXfjnP
	 +m2a4OiSs+yqFccAorpnCES/f8+/ZKxDpwVbTerODO9EmAYvbj3neOcfsnwGLO8gmW
	 B0oa1tRuylVGA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G7OMLs82168611
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 15:24:23 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:24:21 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 15:24:21 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 13/15] wifi: rtw89: coex: check null-tx fail ratio in nullsta report
Date: Wed, 16 Sep 2026 15:22:36 +0800
Message-ID: <20260916072238.62574-14-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260916072238.62574-1-pkshih@realtek.com>
References: <20260916072238.62574-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

Add a BTC_DCNT_NULL_TX_FAIL error check driven from the nullsta
(fcxnullsta) report. When such a report is handled, _chk_btc_report()
now invokes _chk_btc_err() for BTC_RPT_TYPE_NULLSTA.

The check reads the null-1 slot TX count, late count and ok count from
the report, handling both fcxnullsta v7 and v2 layouts, and only
evaluates once at least BTC_NULLTX_CHK_PERIOD (100) null-tx attempts
have accumulated. A late-to-ok ratio worse than BTC_NULLTX_FAIL_TH (8)
increments the fail counter while a healthy ratio resets it, and the
null1_tx_late error flag is raised once the counter reaches
BTC_CHK_HANG_MAX consecutive periods. The check is skipped while FDDT
training is active.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 39 +++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 2392883df528..f88431a0db87 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -1317,14 +1317,19 @@ static void _get_reg_status(struct rtw89_dev *rtwdev, u8 type, u8 *val)
 #define BTC_CHK_WLSLOT_DRIFT_MAX 15
 #define BTC_CHK_BTSLOT_DRIFT_MAX 15
 #define BTC_CHK_HANG_MAX 3
+#define BTC_NULLTX_CHK_PERIOD 100
+#define BTC_NULLTX_FAIL_TH 8
 
 static void _chk_btc_err(struct rtw89_dev *rtwdev, u8 type, u32 cnt)
 {
 	struct rtw89_btc *btc = &rtwdev->btc;
+	union rtw89_btc_fbtc_cynullsta_info *ns = &btc->fwinfo.rpt_fbtc_nullsta.finfo;
 	struct rtw89_btc_cx *cx = &btc->cx;
 	struct rtw89_btc_bt_info *bt = &cx->bt0;
 	struct rtw89_btc_wl_info *wl = &cx->wl;
 	struct rtw89_btc_dm *dm = &btc->dm;
+	const struct rtw89_btc_ver *ver = btc->ver;
+	u32 tx_cnt, late, ok;
 
 	rtw89_debug(rtwdev, RTW89_DBG_BTC,
 		    "[BTC], %s(): type:%d cnt:%d\n",
@@ -1514,6 +1519,37 @@ static void _chk_btc_err(struct rtw89_dev *rtwdev, u8 type, u32 cnt)
 		else
 			dm->error.map.w2b_scbd_no_sync = false;
 		break;
+	case BTC_DCNT_NULL_TX_FAIL:
+		if (dm->fddt_train)
+			break;
+
+		if (ver->fcxnullsta == 7) {
+			ok = le32_to_cpu(ns->v7.result[1][1]);
+			late = le32_to_cpu(ns->v7.result[1][2]);
+			tx_cnt = le32_to_cpu(ns->v7.result[1][4]);
+		} else if (ver->fcxnullsta == 2) {
+			ok = le32_to_cpu(ns->v2.result[1][1]);
+			late = le32_to_cpu(ns->v2.result[1][2]);
+			tx_cnt = le32_to_cpu(ns->v2.result[1][4]);
+		} else if (ver->fcxnullsta == 1) {
+			ok = le32_to_cpu(ns->v1.result[1][1]);
+			late = le32_to_cpu(ns->v1.result[1][2]);
+			tx_cnt = 0;
+		} else {
+			break;
+		}
+
+		if (tx_cnt < BTC_NULLTX_CHK_PERIOD)
+			break;
+
+		if (late * BTC_NULLTX_FAIL_TH > ok)
+			dm->cnt_dm[BTC_DCNT_NULL_TX_FAIL]++;
+		else
+			dm->cnt_dm[BTC_DCNT_NULL_TX_FAIL] = 0;
+
+		dm->error.map.null1_tx_late =
+			dm->cnt_dm[BTC_DCNT_NULL_TX_FAIL] >= BTC_CHK_HANG_MAX;
+		break;
 	}
 }
 
@@ -2684,6 +2720,9 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 			goto err;
 		}
 		break;
+	case BTC_RPT_TYPE_NULLSTA:
+		_chk_btc_err(rtwdev, BTC_DCNT_NULL_TX_FAIL, 0);
+		break;
 	case BTC_RPT_TYPE_MREG:
 		if (ver->fcxmreg == 7)
 			break;
-- 
2.25.1

