Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341CD403B1E
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 06:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790750778; cv=none; b=hOxOsBRkpu1pQMV+brHodRDP2Glv28zFEiPlrSPNJO6in83dJjmTGGecleBCdUQHUQ4lvZaHFaw1VR+crXZmgRyB7aIt5sjrMoSgSaBkAxbJP5fiakfqI4PHT8DUOMT52OuCh8DVh08ozfMeLSKbl41k5gWQGVm0eQmw5GlkBjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790750778; c=relaxed/simple;
	bh=lA+CAHNkE3gtAjM107yiiZvLTjNWZAVaA/z5VMGQ9OM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MINwd9wW4tou2/jIA6JsbJd3LfTJ9wNoqeBWugh5xy6q4nZjouMzWU/Q/a6kPq2CoZwpDdXUxUA3OBFZYe1aszTwz20T/cAZhBScAUcsBf4e9JWPagZObr3gd3mek+UESLG1FAiIzkg8wyfG9FRl9Akts85LlBqcfsoxdL2rnR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=gVDqK34I; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="gVDqK34I"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68U6kAqQ51882935, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790750770; bh=0mUokPLNYDIO59RPXOTtxf1DB/4Y4yIGSOnPkRIkLIc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=gVDqK34IwYG9rwasGKV3XYBLJiUWS7aqQ33OY63JyI6Tkfc5zjwHnv+xNlZT3mcny
	 RBh7vWcuTormdbZ1xawfucX8fOQvunJlVz9pseEyg0Idwzeq2DzjnOy/5PInaLYnYG
	 +YR5A5JGRnZpD0lIktVciwfOp4JDweQVFLaXqea6RhJ4h9AWE9hQy1pzk6vzBX+S1L
	 TblP2vwlwMDGKYYhmbCB8MpxX9XQXcceOAQLdptBFqvlhkj3g3ovwcsg8PRfe9weEg
	 nu6U1EbhAn7dJxmXreSOndlAUUtkCcL0L1ajIUyBBGr0soQMkj9vhASZeFDLkeIpFc
	 WDmCqneZLfnUQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68U6kAqQ51882935
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 14:46:10 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 14:46:11 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 30 Sep 2026 14:46:10 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <echuang@realtek.com>,
	<wenjie.tsai@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 1/6] wifi: rtw89: ps: send H2C command related to MLO info when FWIPS
Date: Wed, 30 Sep 2026 14:45:19 +0800
Message-ID: <20260930064524.39403-2-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260930064524.39403-1-pkshih@realtek.com>
References: <20260930064524.39403-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Chih-Kang Chang <gary.chang@realtek.com>

When entering FWIPS, also send the H2C command related to MLO info, the
same as in LPS. Otherwise, the firmware cannot get enough information.

Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/fw.h  | 11 +++++++++++
 drivers/net/wireless/realtek/rtw89/ps.c  |  7 +------
 drivers/net/wireless/realtek/rtw89/wow.c |  6 ++++--
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index 9b616ec9323b..b879bdd94b88 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -5871,6 +5871,17 @@ int rtw89_chip_h2c_wow_cam_update(struct rtw89_dev *rtwdev,
 	return chip->ops->h2c_wow_cam_update(rtwdev, cam_info);
 }
 
+static inline void rtw89_fw_h2c_lps_ch_ml_info_routing(struct rtw89_dev *rtwdev,
+						       struct rtw89_vif *rtwvif)
+{
+	if (RTW89_CHK_FW_FEATURE(LPS_CH_INFO, &rtwdev->fw))
+		rtw89_fw_h2c_lps_ch_info(rtwdev, rtwvif);
+	else if (RTW89_CHK_FW_FEATURE(LPS_ML_INFO_V1, &rtwdev->fw))
+		rtw89_fw_h2c_lps_ml_cmn_info_v1(rtwdev, rtwvif);
+	else
+		rtw89_fw_h2c_lps_ml_cmn_info(rtwdev, rtwvif);
+}
+
 /* Must consider compatibility; don't insert new in the mid.
  * Fill each field's default value in rtw89_regd_entcpy().
  */
diff --git a/drivers/net/wireless/realtek/rtw89/ps.c b/drivers/net/wireless/realtek/rtw89/ps.c
index 23a9c7a0704a..3639292eba7a 100644
--- a/drivers/net/wireless/realtek/rtw89/ps.c
+++ b/drivers/net/wireless/realtek/rtw89/ps.c
@@ -187,12 +187,7 @@ void rtw89_enter_lps(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif,
 
 	rtw89_fw_h2c_rf_ps_info(rtwdev, rtwvif);
 
-	if (RTW89_CHK_FW_FEATURE(LPS_CH_INFO, &rtwdev->fw))
-		rtw89_fw_h2c_lps_ch_info(rtwdev, rtwvif);
-	else if (RTW89_CHK_FW_FEATURE(LPS_ML_INFO_V1, &rtwdev->fw))
-		rtw89_fw_h2c_lps_ml_cmn_info_v1(rtwdev, rtwvif);
-	else
-		rtw89_fw_h2c_lps_ml_cmn_info(rtwdev, rtwvif);
+	rtw89_fw_h2c_lps_ch_ml_info_routing(rtwdev, rtwvif);
 
 	if (ps_mode && can_ps_mode)
 		__rtw89_enter_ps_mode(rtwdev);
diff --git a/drivers/net/wireless/realtek/rtw89/wow.c b/drivers/net/wireless/realtek/rtw89/wow.c
index 7a2d6904951f..b9892ab84225 100644
--- a/drivers/net/wireless/realtek/rtw89/wow.c
+++ b/drivers/net/wireless/realtek/rtw89/wow.c
@@ -749,10 +749,12 @@ static void rtw89_wow_enter_ps(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_vif_link *rtwvif_link = rtwdev->wow.rtwvif_link;
 
-	if (rtw89_wow_mgd_linked(rtwdev))
+	if (rtw89_wow_mgd_linked(rtwdev)) {
 		rtw89_enter_lps(rtwdev, rtwvif_link->rtwvif, false);
-	else if (rtw89_wow_no_link(rtwdev))
+	} else if (rtw89_wow_no_link(rtwdev)) {
 		rtw89_fw_h2c_fwips(rtwdev, rtwvif_link, true);
+		rtw89_fw_h2c_lps_ch_ml_info_routing(rtwdev, rtwvif_link->rtwvif);
+	}
 }
 
 static void rtw89_wow_leave_ps(struct rtw89_dev *rtwdev, bool enable_wow)
-- 
2.25.1

