Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47662BE632
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2026 08:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769503895; cv=none; b=nc1d1DPdVHSoqQ2/k0BMsbdxxc/YEE+9qUCaVznBfvYyJ/BMcLgMIEHRhtSmZYjrgZDgT+pOTHpz9s1miD/PV8LwQiKFEkGuOGpftpWWb3FRsS7HvkHBR7APJRJO+4uYp5lXf5YNok0TL7wZG9/shRf5/Ny7EdRj/81IPQ80SsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769503895; c=relaxed/simple;
	bh=hVz/xgpS42PmEn/Y4stx0TBf6B0NoMh8buuNsABlQnw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dOg5FYCRlPFCM7XZ0KJVz7OHL7sE582PNKQNrxJM+S1gyd9EQ/h8PZ/zwHtMOh1N4wkNZlUVgj4TJg+DzKlYpASOmNPWz/ooa794Ng9aGaY9UxmL9g4SRf/S43Lv+4ht8NFhydLy2FMSBSXTDrZ+iMKs0Cu3ML/pGVtmPJaD2Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=N/O9ludM; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="N/O9ludM"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 60R8pVAc92655467, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1769503891; bh=I5EtkhhSgYExfWWgYqzYLjlmo2i0cw6rK0kVe04k6Aw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=N/O9ludMkxxWoLJnEgRARpq0tzLrAIitmAW2l6kJrbvmXShf5ajbSfowQsrMm1rKF
	 GWDnoin/Kna1GTGqgkrY36P+Av05rJPd3Pk7Th0N3bZ5MX6Zw+b4zSWGcpZ5dSW0ZK
	 u2lrAF6vjNuV+kwtmPUqyKY4ZddYsczPuNq2o4qQM0CJNI9sHAgwWhWGCB6MLNfqNy
	 fHmPmixS6bGQSJkJBouP8oW0uggPy1a1bCPG4xqxIZebdYSGMV1MAbN3P5m1bCK8bO
	 dfvxLM//OUxrcGLPYetH8QVww6AWRGAhwWdh8ZfYXuLDnR3hh8DJBU++BWEwNbEYwj
	 MddwRGF0rNEBQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.21/5.94) with ESMTPS id 60R8pVAc92655467
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2026 16:51:31 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 27 Jan 2026 16:51:31 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Tue, 27 Jan 2026 16:51:31 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <dian_syuan0116@realtek.com>,
        <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 2/6] wifi: rtw89: debug: tweak Wi-Fi 7 SER L0/L1 simulation methods
Date: Tue, 27 Jan 2026 16:50:32 +0800
Message-ID: <20260127085036.44060-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260127085036.44060-1-pkshih@realtek.com>
References: <20260127085036.44060-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Zong-Zhe Yang <kevin_yang@realtek.com>

SER (system error recovery) L0/L1 simulation has two kinds of methods.
How to choose them depends on FW features. But, Wi-Fi 7 misused them.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/debug.c | 69 ++++++++++++++++++----
 drivers/net/wireless/realtek/rtw89/reg.h   |  4 ++
 2 files changed, 62 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/debug.c b/drivers/net/wireless/realtek/rtw89/debug.c
index 56b52e780dac..d46691fa09bc 100644
--- a/drivers/net/wireless/realtek/rtw89/debug.c
+++ b/drivers/net/wireless/realtek/rtw89/debug.c
@@ -3538,7 +3538,7 @@ rtw89_debug_priv_early_h2c_set(struct rtw89_dev *rtwdev,
 	return count;
 }
 
-static int rtw89_dbg_trigger_l1_error_by_halt_h2c(struct rtw89_dev *rtwdev)
+static int rtw89_dbg_trigger_l1_error_by_halt_h2c_ax(struct rtw89_dev *rtwdev)
 {
 	if (!test_bit(RTW89_FLAG_FW_RDY, rtwdev->flags))
 		return -EBUSY;
@@ -3546,6 +3546,31 @@ static int rtw89_dbg_trigger_l1_error_by_halt_h2c(struct rtw89_dev *rtwdev)
 	return rtw89_mac_set_err_status(rtwdev, MAC_AX_ERR_L1_RESET_FORCE);
 }
 
+static int rtw89_dbg_trigger_l1_error_by_halt_h2c_be(struct rtw89_dev *rtwdev)
+{
+	if (!test_bit(RTW89_FLAG_FW_RDY, rtwdev->flags))
+		return -EBUSY;
+
+	rtw89_write32_set(rtwdev, R_BE_FW_TRIGGER_IDCT_ISR,
+			  B_BE_DMAC_FW_TRIG_IDCT | B_BE_DMAC_FW_ERR_IDCT_IMR);
+
+	return 0;
+}
+
+static int rtw89_dbg_trigger_l1_error_by_halt_h2c(struct rtw89_dev *rtwdev)
+{
+	const struct rtw89_chip_info *chip = rtwdev->chip;
+
+	switch (chip->chip_gen) {
+	case RTW89_CHIP_AX:
+		return rtw89_dbg_trigger_l1_error_by_halt_h2c_ax(rtwdev);
+	case RTW89_CHIP_BE:
+		return rtw89_dbg_trigger_l1_error_by_halt_h2c_be(rtwdev);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int rtw89_dbg_trigger_l1_error(struct rtw89_dev *rtwdev)
 {
 	const struct rtw89_mac_gen_def *mac = rtwdev->chip->mac_def;
@@ -3600,19 +3625,22 @@ static int rtw89_dbg_trigger_l0_error_ax(struct rtw89_dev *rtwdev)
 
 static int rtw89_dbg_trigger_l0_error_be(struct rtw89_dev *rtwdev)
 {
+	u8 val8;
 	int ret;
 
 	ret = rtw89_mac_check_mac_en(rtwdev, RTW89_MAC_0, RTW89_CMAC_SEL);
 	if (ret)
 		return ret;
 
-	rtw89_write32_set(rtwdev, R_BE_CMAC_FW_TRIGGER_IDCT_ISR,
-			  B_BE_CMAC_FW_TRIG_IDCT | B_BE_CMAC_FW_ERR_IDCT_IMR);
+	val8 = rtw89_read8(rtwdev, R_BE_CMAC_FUNC_EN);
+	rtw89_write8(rtwdev, R_BE_CMAC_FUNC_EN, val8 & ~B_BE_TMAC_EN);
+	mdelay(1);
+	rtw89_write8(rtwdev, R_BE_CMAC_FUNC_EN, val8);
 
 	return 0;
 }
 
-static int rtw89_dbg_trigger_l0_error_by_halt_h2c(struct rtw89_dev *rtwdev)
+static int rtw89_dbg_trigger_l0_error_by_halt_h2c_ax(struct rtw89_dev *rtwdev)
 {
 	if (!test_bit(RTW89_FLAG_FW_RDY, rtwdev->flags))
 		return -EBUSY;
@@ -3620,23 +3648,42 @@ static int rtw89_dbg_trigger_l0_error_by_halt_h2c(struct rtw89_dev *rtwdev)
 	return rtw89_mac_set_err_status(rtwdev, MAC_AX_ERR_L0_RESET_FORCE);
 }
 
-static int rtw89_dbg_trigger_l0_error(struct rtw89_dev *rtwdev)
+static int rtw89_dbg_trigger_l0_error_by_halt_h2c_be(struct rtw89_dev *rtwdev)
 {
-	const struct rtw89_chip_info *chip = rtwdev->chip;
+	if (!test_bit(RTW89_FLAG_FW_RDY, rtwdev->flags))
+		return -EBUSY;
 
-	if (RTW89_CHK_FW_FEATURE(SIM_SER_L0L1_BY_HALT_H2C, &rtwdev->fw))
-		return rtw89_dbg_trigger_l0_error_by_halt_h2c(rtwdev);
+	rtw89_write32_set(rtwdev, R_BE_CMAC_FW_TRIGGER_IDCT_ISR,
+			  B_BE_CMAC_FW_TRIG_IDCT | B_BE_CMAC_FW_ERR_IDCT_IMR);
 
-	rtw89_leave_ps_mode(rtwdev);
+	return 0;
+}
+
+static int rtw89_dbg_trigger_l0_error(struct rtw89_dev *rtwdev)
+{
+	const struct rtw89_chip_info *chip = rtwdev->chip;
+	int (*sim_l0_by_halt_h2c)(struct rtw89_dev *rtwdev);
+	int (*sim_l0)(struct rtw89_dev *rtwdev);
 
 	switch (chip->chip_gen) {
 	case RTW89_CHIP_AX:
-		return rtw89_dbg_trigger_l0_error_ax(rtwdev);
+		sim_l0_by_halt_h2c = rtw89_dbg_trigger_l0_error_by_halt_h2c_ax;
+		sim_l0 = rtw89_dbg_trigger_l0_error_ax;
+		break;
 	case RTW89_CHIP_BE:
-		return rtw89_dbg_trigger_l0_error_be(rtwdev);
+		sim_l0_by_halt_h2c = rtw89_dbg_trigger_l0_error_by_halt_h2c_be;
+		sim_l0 = rtw89_dbg_trigger_l0_error_be;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
+
+	if (RTW89_CHK_FW_FEATURE(SIM_SER_L0L1_BY_HALT_H2C, &rtwdev->fw))
+		return sim_l0_by_halt_h2c(rtwdev);
+
+	rtw89_leave_ps_mode(rtwdev);
+
+	return sim_l0(rtwdev);
 }
 
 static ssize_t
diff --git a/drivers/net/wireless/realtek/rtw89/reg.h b/drivers/net/wireless/realtek/rtw89/reg.h
index 3239f358aafc..9b2e97ed5c7d 100644
--- a/drivers/net/wireless/realtek/rtw89/reg.h
+++ b/drivers/net/wireless/realtek/rtw89/reg.h
@@ -4960,6 +4960,10 @@
 #define R_BE_SER_L1_DBG_CNT_7 0x845C
 #define B_BE_SER_L1_DBG_2_MASK GENMASK(31, 0)
 
+#define R_BE_FW_TRIGGER_IDCT_ISR 0x8508
+#define B_BE_DMAC_FW_ERR_IDCT_IMR BIT(31)
+#define B_BE_DMAC_FW_TRIG_IDCT BIT(0)
+
 #define R_BE_DMAC_ERR_IMR 0x8520
 #define B_BE_DMAC_NOTX_ERR_INT_EN BIT(21)
 #define B_BE_DMAC_NORX_ERR_INT_EN BIT(20)
-- 
2.25.1

