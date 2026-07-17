Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01A5280CC1
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784269260; cv=none; b=vEFRXxGSFhsEKqYLZ4KxhDLrVJxOUUkwOWdv2W9I52CP5whZMpclmOfUkh5yK1Z5BXK7YHGvkfLhtIM42kPtLxonuS4vfnhcYGAML+brpPA18LnBjreMhzXyb6WKmDrXOYkCMwsyNcTFSLYh2BiP3E6rU16a9S2mLo/01QAVOoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784269260; c=relaxed/simple;
	bh=saPuHGim2Sav1FuBWJQ5H13cx2DwQ2OXiTN8FdSg6XE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CU/RXZgq4G9rjc4zIGWlIDMWJDQaKaqswLZFyRyjC9XbSxwqhvmTAGw0dUXbUQ6h+eUsVazLY9uIQDskYfcH+lk84zD8jy7OKwdYp6ESXzEScCXMNmgEpNHERBFpU/GLuh6fGEK+TmEufisacR6TC0DMJFPu4p2NDhcmWOrCivc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=vF1k8zpD; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="vF1k8zpD"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H6KuvsE4163705, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784269256; bh=Lu4rWU4jwt6z8/FMyg1mKQeanCl4Jc9AA1iyHjkYNJI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=vF1k8zpDifTp9UQpbDAnbtb90YIvAG7b8K3b2ktdz987lcMAlkLuOL/y0i885s256
	 42NF5zDMG4D9/oQQ0eL8eI3XZ4x1ndGPsy4zzZOb5NGX6KD9hPVOPI9ktpXMYy1RPJ
	 dHwtJe3DCwlXRoQZbY4u0ipQIVIvPUccuoLXUNL1SvWSo0c01o292pgaWA1J2/KQz/
	 lT55Vr5aQHpcVSvQ0bthycMvMcXErgBwKsNdTAQu25ioWxM45MMf2mPqr5eJ4a40rZ
	 sixJGDDG7oDLG/JHMKNLxdLz0dpBz9GkndM334jprjESv7saIYhVhCaAtJkZf52s3T
	 ELooLguvMOqJA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H6KuvsE4163705
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:20:56 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:20:56 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 14:20:56 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <sc.lee@realtek.com>, <wenjie.tsai@realtek.com>
Subject: [PATCH rtw-next 8/9] wifi: rtw89: 8922d: reduce IO in power-on function
Date: Fri, 17 Jul 2026 14:19:09 +0800
Message-ID: <20260717061910.54466-9-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260717061910.54466-1-pkshih@realtek.com>
References: <20260717061910.54466-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

To improve initial time, merge some IO to reduce IO times. Two registers
are:
 1. R_BE_SYS_PW_CTRL: 0x4[12:11]=0, 0x4[18]=1, 0x4[15]=0, and 0x4[10]=0
 2. R_BE_SYS_ADIE_PAD_PWR_CTRL: Merge 0x18[6] and 0x18[5]

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index fde4117bcd49..fd4c92ba3f7b 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -518,14 +518,15 @@ static int rtw8922d_pwr_on_func(struct rtw89_dev *rtwdev)
 	}
 
 begin:
-	rtw89_write32_clr(rtwdev, R_BE_SYS_PW_CTRL, B_BE_AFSM_WLSUS_EN |
-						    B_BE_AFSM_PCIE_SUS_EN);
-	rtw89_write32_set(rtwdev, R_BE_SYS_PW_CTRL, B_BE_DIS_WLBT_PDNSUSEN_SOPC);
-	rtw89_write32_set(rtwdev, R_BE_WLLPS_CTRL, B_BE_DIS_WLBT_LPSEN_LOPC);
+	val32 = rtw89_read32(rtwdev, R_BE_SYS_PW_CTRL);
+	val32 &= ~(B_BE_AFSM_WLSUS_EN | B_BE_AFSM_PCIE_SUS_EN | B_BE_APFM_SWLPS);
+	val32 |= B_BE_DIS_WLBT_PDNSUSEN_SOPC;
 	if (hal->cid != RTL8922D_CID7090)
-		rtw89_write32_clr(rtwdev, R_BE_SYS_PW_CTRL, B_BE_APDM_HPDN);
+		val32 &= ~B_BE_APDM_HPDN;
+	rtw89_write32(rtwdev, R_BE_SYS_PW_CTRL, val32);
+
+	rtw89_write32_set(rtwdev, R_BE_WLLPS_CTRL, B_BE_DIS_WLBT_LPSEN_LOPC);
 	rtw89_write32_clr(rtwdev, R_BE_FWS1ISR, B_BE_FS_WL_HW_RADIO_OFF_INT);
-	rtw89_write32_clr(rtwdev, R_BE_SYS_PW_CTRL, B_BE_APFM_SWLPS);
 
 	ret = read_poll_timeout(rtw89_read32, val32, val32 & B_BE_RDY_SYSPWR,
 				1000, 3000000, false, rtwdev, R_BE_SYS_PW_CTRL);
@@ -581,14 +582,13 @@ static int rtw8922d_pwr_on_func(struct rtw89_dev *rtwdev)
 	if (ret)
 		return ret;
 
-	rtw89_write32_set(rtwdev, R_BE_SYS_ADIE_PAD_PWR_CTRL, B_BE_SYM_PADPDN_WL_RFC1_1P3);
+	rtw89_write32_set(rtwdev, R_BE_SYS_ADIE_PAD_PWR_CTRL,
+			  B_BE_SYM_PADPDN_WL_RFC1_1P3 | B_BE_SYM_PADPDN_WL_RFC0_1P3);
 
 	ret = rtw89_mac_write_xtal_si(rtwdev, XTAL_SI_ANAPAR_WL, 0x40, 0x40);
 	if (ret)
 		return ret;
 
-	rtw89_write32_set(rtwdev, R_BE_SYS_ADIE_PAD_PWR_CTRL, B_BE_SYM_PADPDN_WL_RFC0_1P3);
-
 	ret = rtw89_mac_write_xtal_si(rtwdev, XTAL_SI_ANAPAR_WL, 0x20, 0x20);
 	if (ret)
 		return ret;
-- 
2.25.1

