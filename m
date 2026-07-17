Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103492F28EA
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784269244; cv=none; b=kQBVmlyu/RUc1wbFZTLhGit/VDjxICb6oBQIPGpWzzw/WEH/MHI6N8LeD+K5BSn/B3HHNBOfPQBE2lDVyq6QEm/o04bgFpIFY8bUa17/wYuIwVD9DWo4MXAb8UH9P9u8QRPa2hjd/4lEMfj6C8iN73+Z/PKM7BQwur8M4h1iv8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784269244; c=relaxed/simple;
	bh=/lkTyXySJFgEH/rMOkHuGoxosLKB8MnqDjQX30e8j5c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nl+mRLoo9vO9ZMrfehi+GtFXUlXNXTb/wUe5x94K7aKophhzZVobFvRjwK9vID+YGqiXBykjngVxEjWxW+E7yi7+ZYxAkYN14RRuQlp4R65+d15tJncWxaApfYEJ8cvA+nWcRS+TPO/iN2X4C3n/BgvxQ0ew5Pjt3cVtFLZSh20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=EIrEbG09; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="EIrEbG09"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H6KeWF24163641, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784269240; bh=tbj8xK5UEIM+uvXV6FjUZsf1ETu+uFA+aG29rxPWGhk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=EIrEbG09AvhoQ3Tw+HGEbu1q6RRe5aKRBy1nMKoHmM8IMtUUhCqL7gQ8R5vDq3Sqi
	 T8Y4HMYgcm2KUShVMZECtZ9g0i70Qrew7MAIgLRGfcMrEbaJPCP3v4imOjAEw+RNCk
	 bdmoYkJxs125fYAKIVQeQ1o6fQmY1oFkH0xYpVt+iF3xKUmc+mzG0keeu+87awgP9N
	 8djEH9ISwf4zT5KiRzlR1jcxVBOgx+nxDrkyZpHNVGx+ZnWw9OKokOniTVA2b8lRn3
	 exAf7jJtgRU2MpldH/OwxTIWVM43j/2TDRjDN+hVp/eBprxFbfMf/W10/+/ouaU9ec
	 IFS/ChxtX0Q9A==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H6KeWF24163641
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:20:40 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:20:40 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 14:20:40 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <sc.lee@realtek.com>, <wenjie.tsai@realtek.com>
Subject: [PATCH rtw-next 5/9] wifi: rtw89: 8922d: bypass TXIQK when scan
Date: Fri, 17 Jul 2026 14:19:06 +0800
Message-ID: <20260717061910.54466-6-pkshih@realtek.com>
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

From: Chih-Kang Chang <gary.chang@realtek.com>

When connected to an AP and a scan is triggered, the FW may fail to
transmit probe request because switching channels may load an
uninitialized TXIQK table. Therefore, bypass TXIQK during scanning
to avoid using invalid calibration values.

Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.h     |  1 +
 drivers/net/wireless/realtek/rtw89/reg.h      | 10 +++
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 64 ++++++++++++++++++-
 3 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 9b7f197a3af2..2d9113cb43f9 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -6284,6 +6284,7 @@ struct rtw89_iqk_info {
 	u8 iqk_table_idx[RTW89_IQK_PATH_NR];
 	u32 lok_idac[RTW89_IQK_CHS_NR][RTW89_IQK_PATH_NR];
 	u32 lok_vbuf[RTW89_IQK_CHS_NR][RTW89_IQK_PATH_NR];
+	u32 iqc_bak[2];
 };
 
 #define RTW89_DPK_RF_PATH 2
diff --git a/drivers/net/wireless/realtek/rtw89/reg.h b/drivers/net/wireless/realtek/rtw89/reg.h
index 053028b9ef16..756b94dcd475 100644
--- a/drivers/net/wireless/realtek/rtw89/reg.h
+++ b/drivers/net/wireless/realtek/rtw89/reg.h
@@ -10121,6 +10121,7 @@
 #define B_S1_DACKQ8_K GENMASK(15, 8)
 #define R_NCTL_CFG 0x8000
 #define R_NCTL_CFG_BE4 0x38000
+#define B_NCTL_CFG_BE4_SPAGE GENMASK(25, 24)
 #define B_NCTL_CHK_EN BIT(3)
 #define B_NCTL_CFG_SPAGE GENMASK(2, 1)
 #define R_NCTL_RPT 0x8008
@@ -11061,6 +11062,15 @@
 #define B_KTBL0_MLD_IDX0 GENMASK(25, 24)
 #define B_KTBL0_MLD_IDX1 GENMASK(27, 26)
 #define B_KTBL0_RST BIT(31)
+#define R_CFIR_CTRL_A_BE4 0x38124
+#define R_CFIR_CTRL_B_BE4 0x38224
+#define B_CFIR_CTRL_KIDX0_EN BIT(8)
+#define B_CFIR_CTRL_KIDX1_EN BIT(24)
+#define R_TX_IQC_A_BE4 0x38138
+#define R_TX_IQC_B_BE4 0x38238
+#define B_TX_IQC_X GENMASK(31, 20)
+#define B_TX_IQC_Y GENMASK(19, 8)
+#define B_TX_IQC_DPK BIT(3)
 #define R_KTBL1A_BE4 0x38154
 #define R_KTBL1B_BE4 0x38254
 #define B_KTBL1_TBL0 BIT(3)
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index 929bcfc8089d..fde4117bcd49 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -2765,14 +2765,74 @@ static void rtw8922d_rfk_band_changed(struct rtw89_dev *rtwdev,
 {
 }
 
+static void __rtw8922d_txiqk_disable(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_iqk_info *iqk_info = &rtwdev->iqk;
+	u8 path, kidx;
+
+	for (path = RF_PATH_A; path <= RF_PATH_B; path++) {
+		kidx = rtw89_phy_read32_mask(rtwdev, R_KTBL0A_BE4 + (path << 8),
+					     B_KTBL0_IDX0);
+		if (kidx == 0) {
+			rtw89_phy_write32_clr(rtwdev, R_CFIR_CTRL_A_BE4 + (path << 8),
+					      B_CFIR_CTRL_KIDX0_EN);
+		} else if (kidx == 1) {
+			rtw89_phy_write32_clr(rtwdev, R_CFIR_CTRL_A_BE4 + (path << 8),
+					      B_CFIR_CTRL_KIDX1_EN);
+		} else {
+			rtw89_phy_write32_mask(rtwdev, R_NCTL_CFG_BE4,
+					       B_NCTL_CFG_BE4_SPAGE, 0x1);
+			rtw89_phy_write32_clr(rtwdev, R_CFIR_CTRL_A_BE4 + (path << 8),
+					      B_CFIR_CTRL_KIDX0_EN);
+			rtw89_phy_write32_mask(rtwdev, R_NCTL_CFG_BE4,
+					       B_NCTL_CFG_BE4_SPAGE, 0x0);
+		}
+
+		iqk_info->iqc_bak[path] =
+			rtw89_phy_read32(rtwdev, R_TX_IQC_A_BE4 + (path << 8));
+		rtw89_phy_write32(rtwdev, R_TX_IQC_A_BE4 + (path << 8), 0x40000002);
+	}
+}
+
+static void __rtw8922d_txiqk_enable(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_iqk_info *iqk_info = &rtwdev->iqk;
+	u8 path, kidx;
+
+	for (path = RF_PATH_A; path <= RF_PATH_B; path++) {
+		kidx = rtw89_phy_read32_mask(rtwdev, R_KTBL0A_BE4 + (path << 8),
+					     B_KTBL0_IDX0);
+		if (kidx == 0) {
+			rtw89_phy_write32_set(rtwdev, R_CFIR_CTRL_A_BE4 + (path << 8),
+					      B_CFIR_CTRL_KIDX0_EN);
+		} else if (kidx == 1) {
+			rtw89_phy_write32_set(rtwdev, R_CFIR_CTRL_A_BE4 + (path << 8),
+					      B_CFIR_CTRL_KIDX1_EN);
+		} else {
+			rtw89_phy_write32_mask(rtwdev, R_NCTL_CFG_BE4,
+					       B_NCTL_CFG_BE4_SPAGE, 0x1);
+			rtw89_phy_write32_set(rtwdev, R_CFIR_CTRL_A_BE4 + (path << 8),
+					      B_CFIR_CTRL_KIDX0_EN);
+			rtw89_phy_write32_mask(rtwdev, R_NCTL_CFG_BE4,
+					       B_NCTL_CFG_BE4_SPAGE, 0x0);
+		}
+
+		rtw89_phy_write32(rtwdev, R_TX_IQC_A_BE4 + (path << 8),
+				  iqk_info->iqc_bak[path]);
+	}
+}
+
 static void rtw8922d_rfk_scan(struct rtw89_dev *rtwdev,
 			      struct rtw89_vif_link *rtwvif_link,
 			      bool start)
 {
-	if (start)
+	if (start) {
 		__rtw8922d_tssi_disable(rtwdev, rtwvif_link->phy_idx);
-	else
+		__rtw8922d_txiqk_disable(rtwdev);
+	} else {
 		__rtw8922d_tssi_enable(rtwdev, rtwvif_link->phy_idx);
+		__rtw8922d_txiqk_enable(rtwdev);
+	}
 }
 
 static void rtw8922d_rfk_track(struct rtw89_dev *rtwdev)
-- 
2.25.1

