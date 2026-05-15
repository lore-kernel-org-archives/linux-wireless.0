Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF961DF26E
	for <linux-wireless@vger.kernel.org>; Fri, 15 May 2026 01:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778809521; cv=none; b=X9zP6lmLGHDH2cHOPyPi1E463HNjJE5OhxyGDirULL5ijdKmmZxAS17Ga1/Efp4QUZr6DJzhyZIj5GMTVQXyDBy+TuB/fN9bl5LkZ1v36iPCNtzeYVv2w3RujsqgMTEeidRej9eGzVSEDEpRWo/Hy/Ddbuhh+DpQ/4NPQmXCNWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778809521; c=relaxed/simple;
	bh=gpNGfFHMVlOmo5/TG32iVKWifzRxO4SWEly35+GmI8M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=krh5H2KQuQ+u3jratpRJcmxFtiK/S74lyOWCm/wRRTRagJkz67rdVWNDaajF2JI5lXKADuyIJwdUCLvLJIdkSgNllNDcQ0kA68P9aQYOrv/CwFt/gkgZHNNfMqryUYEXBT3e6IU48G2p3NcacPjAfHR0/N4r7v2IqEUMSXIf8dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=KUXjcLzk; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="KUXjcLzk"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 64F1jIRw92587231, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1778809518; bh=UB6/nZr05lqNQSrapKS1jIYub9HCyQ0q2lv8K6++vE4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=KUXjcLzkefxNI1w/h1wIzkIm5G3wpItPlRGN6ouGLEsboEmHvqsuY8/6VYcaMlqll
	 Ud+eXBv5Sq6tYg4s8JrXwbKMUr9SFai+ahVRUiQESOVZJx/e2J6JZkUQ2ldkbGuc6+
	 4Q8H0ROkFQeh7XjHG6TgL83l/jc0WHAYSiLa6eGqcvlbGxETp1VP3X5m569adjD2X9
	 iefRoqbWFEQTOaeYNQsYwOdm2/BAI3WoFPomYXGs9WAufl8A4LVQ7K+SMOxHW12Kln
	 5x9mtbtdSrWSg6uJLr5drexnEEZo2eah5D+xbG7A2GFg4BhOOY7Cw31WYSXqD0AtOh
	 sX0e+1VIo9EOQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.27/5.94) with ESMTPS id 64F1jIRw92587231
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 15 May 2026 09:45:18 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 15 May 2026 09:45:18 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 15 May 2026 09:45:18 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <timlee@realtek.com>, <dian_syuan0116@realtek.com>, <phhuang@realtek.com>,
        <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 07/13] wifi: rtw89: clear auto K delay value before downloading firmware
Date: Fri, 15 May 2026 09:44:27 +0800
Message-ID: <20260515014433.16168-8-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260515014433.16168-1-pkshih@realtek.com>
References: <20260515014433.16168-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Once downloading firmware, do calibration on delay function to ensure
firmware can do proper delay for hardware IO.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/mac.c    |  3 +++
 drivers/net/wireless/realtek/rtw89/mac.h    | 12 ++++++++++++
 drivers/net/wireless/realtek/rtw89/mac_be.c |  7 +++++++
 drivers/net/wireless/realtek/rtw89/reg.h    |  4 ++++
 4 files changed, 26 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index 87e3320b5a81..6153162ad9b0 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -4318,6 +4318,8 @@ int rtw89_mac_partial_init(struct rtw89_dev *rtwdev, bool include_bb)
 			return ret;
 	}
 
+	rtw89_mac_fwdl_preconfig(rtwdev);
+
 	ret = rtw89_fw_download(rtwdev, RTW89_FW_NORMAL, include_bb);
 	if (ret)
 		return ret;
@@ -7477,6 +7479,7 @@ const struct rtw89_mac_gen_def rtw89_mac_gen_ax = {
 
 	.reset_pwr_state = rtw89_mac_reset_pwr_state_ax,
 	.disable_cpu = rtw89_mac_disable_cpu_ax,
+	.fwdl_preconfig = NULL,
 	.fwdl_enable_wcpu = rtw89_mac_enable_cpu_ax,
 	.fwdl_get_status = rtw89_fw_get_rdy_ax,
 	.fwdl_check_path_ready = rtw89_fwdl_check_path_ready_ax,
diff --git a/drivers/net/wireless/realtek/rtw89/mac.h b/drivers/net/wireless/realtek/rtw89/mac.h
index 75691a9549a7..69f8d7d818a0 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.h
+++ b/drivers/net/wireless/realtek/rtw89/mac.h
@@ -1112,6 +1112,7 @@ struct rtw89_mac_gen_def {
 
 	int (*reset_pwr_state)(struct rtw89_dev *rtwdev);
 	void (*disable_cpu)(struct rtw89_dev *rtwdev);
+	void (*fwdl_preconfig)(struct rtw89_dev *rtwdev);
 	int (*fwdl_enable_wcpu)(struct rtw89_dev *rtwdev, u8 boot_reason,
 				bool dlfw, bool include_bb);
 	u8 (*fwdl_get_status)(struct rtw89_dev *rtwdev, enum rtw89_fwdl_check_type type);
@@ -1725,6 +1726,17 @@ static inline int rtw89_mac_efuse_read_ecv(struct rtw89_dev *rtwdev)
 	return mac->efuse_read_ecv(rtwdev);
 }
 
+static inline
+void rtw89_mac_fwdl_preconfig(struct rtw89_dev *rtwdev)
+{
+	const struct rtw89_mac_gen_def *mac = rtwdev->chip->mac_def;
+
+	if (!mac->fwdl_preconfig)
+		return;
+
+	mac->fwdl_preconfig(rtwdev);
+}
+
 static inline
 void rtw89_fwdl_secure_idmem_share_mode(struct rtw89_dev *rtwdev, u8 mode)
 {
diff --git a/drivers/net/wireless/realtek/rtw89/mac_be.c b/drivers/net/wireless/realtek/rtw89/mac_be.c
index dd0dbe78a1ed..f24c119b99f1 100644
--- a/drivers/net/wireless/realtek/rtw89/mac_be.c
+++ b/drivers/net/wireless/realtek/rtw89/mac_be.c
@@ -622,6 +622,12 @@ static void rtw89_mac_disable_cpu_be(struct rtw89_dev *rtwdev)
 	rtw89_write32(rtwdev, R_BE_UDM2, 0);
 }
 
+static void rtw89_mac_fwdl_preconfig_be(struct rtw89_dev *rtwdev)
+{
+	rtw89_write32_clr(rtwdev, R_BE_FW_AUTO_CAL_DELAY, B_BE_WCPU_FW_DELAY_COUNT_VALID);
+	rtw89_write32_mask(rtwdev, R_BE_FW_AUTO_CAL_DELAY, B_BE_WCPU_FW_DELAY_COUNT_MASK, 0);
+}
+
 static void set_cpu_en(struct rtw89_dev *rtwdev, bool include_bb)
 {
 	u32 set = B_BE_WLANCPU_FWDL_EN;
@@ -3288,6 +3294,7 @@ const struct rtw89_mac_gen_def rtw89_mac_gen_be = {
 
 	.reset_pwr_state = rtw89_mac_reset_pwr_state_be,
 	.disable_cpu = rtw89_mac_disable_cpu_be,
+	.fwdl_preconfig = rtw89_mac_fwdl_preconfig_be,
 	.fwdl_enable_wcpu = rtw89_mac_fwdl_enable_wcpu_be,
 	.fwdl_get_status = fwdl_get_status_be,
 	.fwdl_check_path_ready = rtw89_fwdl_check_path_ready_be,
diff --git a/drivers/net/wireless/realtek/rtw89/reg.h b/drivers/net/wireless/realtek/rtw89/reg.h
index 716747c3a10e..226664615c5e 100644
--- a/drivers/net/wireless/realtek/rtw89/reg.h
+++ b/drivers/net/wireless/realtek/rtw89/reg.h
@@ -4329,6 +4329,10 @@
 
 #define R_BE_SECURE_BOOT_MALLOC_INFO 0x0184
 
+#define R_BE_FW_AUTO_CAL_DELAY 0x0188
+#define B_BE_WCPU_FW_DELAY_COUNT_VALID BIT(15)
+#define B_BE_WCPU_FW_DELAY_COUNT_MASK GENMASK(14, 0)
+
 #define R_BE_FWS0IMR 0x0190
 #define B_BE_FS_HALT_H2C_INT_EN BIT(31)
 #define B_BE_FS_FSM_HIOE_TO_EVENT_INT_EN BIT(30)
-- 
2.25.1

