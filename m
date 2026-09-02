Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD6824DFF9
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 05:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327089; cv=none; b=iCu2p+VdxkPmL6wC9co85FQCpDME+V2HYob6KuWfkcn18mqDHOtGqKkir9e30secxw8JMnIYQE7t6AtA/6JzZ6kzFahpqcvT/S7G3EvhG/15mW0K404V/HSafpjQOI41KABc8kAjvViKcPzPatRthJkcQSycrfSLAZiCUiLPBNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327089; c=relaxed/simple;
	bh=7Guw8tlFh5N0eB5nRp9rA4i0PnpBBvK1MkwwmyixlfI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f5sVD2kwSw/uOMrqdgtgrUV47PKRlm7xGbvN1SBnYFVxISNETMnjUqZnmfjvhq/FJ+q8VrqV4rgrk6OeWYT1XqE7Qwvh22Ujh9Ygxk8dotEoqWS/p+6Bqdmw+FMb4IvZBUDvGQdlSZAOwMlQbgdWfjCempoNUHxUYL0fQvnZ1vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=IbeT2OPv; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="IbeT2OPv"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6825VP7C02368580, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788327085; bh=WBdFBTRwOU78uSqV63OqfjkkdFVjUudSvplD2Fz4/7E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=IbeT2OPvVG3TRA1askm1cqkTMBdtID3PmZ0LQ0jhr+cTzEiDrZ8L9JLQOFF8EtJ9V
	 q8jAAzGh1g0MZCHY5C44UIOvU3VwEW1M9g7U/PATzfJGLv/c88cNwAz04Wsk2LuLCo
	 W/ynpcef2izjiaavCbt+CO9+8kc49CxQZpe3xfB/IcU07pRHdamBGCkH74VHR5sLcw
	 FlmrtqczMjdbffifYJ9ENJ0RqoQwO/sEsHe4wc7En2lwpNeHzeMtfU2lPqICXUPDr4
	 GF1lr74luD1pQFSQnkiVGmtdKwwPEgoDDpQsaleHqGsTP8ikwt+6cNg4AXwl8s75Vr
	 /b8JL/BfHIt5A==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6825VP7C02368580
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 2 Sep 2026 13:31:25 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 13:31:25 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 13:31:25 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next v2 13/14] wifi: rtw89: skip tracking things when entity is paused
Date: Wed, 2 Sep 2026 13:29:57 +0800
Message-ID: <20260902052958.50371-14-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260902052958.50371-1-pkshih@realtek.com>
References: <20260902052958.50371-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Zong-Zhe Yang <kevin_yang@realtek.com>

In some situation, such as HW scan/ROC, entity will temporarily be paused.
They usually have special handling on chanctx. However, things in tracking
work focus on the operating channel. It would be better not to count these
temporary periods. So, add a check before doing tracking things. Also, LPS
will be expected to be off before pausing entity and during the period when
entity is paused.

Besides, since the flow where to call rtw89_recalc_lps() is based on iface
adding/removing, disabling has no need to depend on whether entity mode has
became MCC. Before MCC starts, there must be at least two ifaces first. If
two ifaces exist, rtw89_recalc_lps() will have already disabled LPS.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/chan.c | 12 ++++++++++++
 drivers/net/wireless/realtek/rtw89/chan.h |  1 +
 drivers/net/wireless/realtek/rtw89/core.c |  6 ++++++
 drivers/net/wireless/realtek/rtw89/ps.c   |  6 ------
 4 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/chan.c b/drivers/net/wireless/realtek/rtw89/chan.c
index 7205fca8ac1a..a7ba47bd9abd 100644
--- a/drivers/net/wireless/realtek/rtw89/chan.c
+++ b/drivers/net/wireless/realtek/rtw89/chan.c
@@ -3230,6 +3230,9 @@ void rtw89_chanctx_pause(struct rtw89_dev *rtwdev,
 
 	lockdep_assert_wiphy(rtwdev->hw->wiphy);
 
+	if (test_bit(RTW89_FLAG_LEISURE_PS, rtwdev->flags))
+		rtw89_warn(rtwdev, "LPS isn't off when pausing chanctx\n");
+
 	if (hal->entity_pause)
 		return;
 
@@ -3247,6 +3250,15 @@ void rtw89_chanctx_pause(struct rtw89_dev *rtwdev,
 	hal->entity_pause = true;
 }
 
+bool rtw89_chanctx_paused(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_hal *hal = &rtwdev->hal;
+
+	lockdep_assert_wiphy(rtwdev->hw->wiphy);
+
+	return hal->entity_pause;
+}
+
 static void rtw89_chanctx_proceed_cb(struct rtw89_dev *rtwdev,
 				     const struct rtw89_chanctx_cb_parm *parm)
 {
diff --git a/drivers/net/wireless/realtek/rtw89/chan.h b/drivers/net/wireless/realtek/rtw89/chan.h
index a9a5f1b307a2..f99aca9ef6a4 100644
--- a/drivers/net/wireless/realtek/rtw89/chan.h
+++ b/drivers/net/wireless/realtek/rtw89/chan.h
@@ -185,6 +185,7 @@ void rtw89_query_mr_chanctx_info(struct rtw89_dev *rtwdev, u8 inst_idx,
 void rtw89_chanctx_track(struct rtw89_dev *rtwdev);
 void rtw89_chanctx_pause(struct rtw89_dev *rtwdev,
 			 const struct rtw89_chanctx_pause_parm *parm);
+bool __must_check rtw89_chanctx_paused(struct rtw89_dev *rtwdev);
 void rtw89_chanctx_proceed(struct rtw89_dev *rtwdev,
 			   const struct rtw89_chanctx_cb_parm *cb_parm);
 
diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 24275c2250e7..80c4877e2dab 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -5496,6 +5496,9 @@ static void rtw89_track_ps_work(struct wiphy *wiphy, struct wiphy_work *work)
 	if (rtwdev->scanning)
 		return;
 
+	if (rtw89_chanctx_paused(rtwdev))
+		return;
+
 	if (rtwdev->lps_enabled && !rtwdev->btc.btc_ctrl_lps)
 		rtw89_enter_lps_track(rtwdev, RTW89_TFC_INTERVAL_100MS);
 }
@@ -5521,6 +5524,9 @@ static void rtw89_track_work(struct wiphy *wiphy, struct wiphy_work *work)
 	if (rtwdev->scanning)
 		return;
 
+	if (rtw89_chanctx_paused(rtwdev))
+		return;
+
 	rtw89_leave_lps(rtwdev);
 
 	if (tfc_changed) {
diff --git a/drivers/net/wireless/realtek/rtw89/ps.c b/drivers/net/wireless/realtek/rtw89/ps.c
index 31bb5dcd284a..34105d030537 100644
--- a/drivers/net/wireless/realtek/rtw89/ps.c
+++ b/drivers/net/wireless/realtek/rtw89/ps.c
@@ -363,13 +363,8 @@ void rtw89_recalc_lps(struct rtw89_dev *rtwdev)
 {
 	struct ieee80211_vif *vif, *found_vif = NULL;
 	struct rtw89_vif *rtwvif;
-	enum rtw89_entity_mode mode;
 	int count = 0;
 
-	mode = rtw89_get_entity_mode(rtwdev);
-	if (mode == RTW89_ENTITY_MODE_MCC)
-		goto disable_lps;
-
 	rtw89_for_each_rtwvif(rtwdev, rtwvif) {
 		vif = rtwvif_to_vif(rtwvif);
 
@@ -387,7 +382,6 @@ void rtw89_recalc_lps(struct rtw89_dev *rtwdev)
 		return;
 	}
 
-disable_lps:
 	rtw89_leave_lps(rtwdev);
 	rtwdev->lps_enabled = false;
 }
-- 
2.25.1

