Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2570B1A6836
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 06:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787726526; cv=none; b=VbQJU/3w0g8JICGYpazrjjbMWHwfQkMzZGKkKIFNd/vWrQWeMYVYYqcSp6DX3PA+cuIncw6Se2VNhhZdDwbnBSSNOVfqwyNXq0a51ndgNq3ZrHz+DI/jhFoPenI6VIj8UpafWPGAseOASGP9UFROBlwMjy2y/qIKk8d1a1kicBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787726526; c=relaxed/simple;
	bh=dMMPtC0EM5mM3+MImcQDYHKQXLsSvzfJiFpkCnK3u38=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u3gKTcHT29UXwrzNUajCIJQyHGRSU26cJFeF2JYcm3y2kNSlojqCu8tvhjUI4N4Xgc+IHhU3e1nngZyqtN5cSangWkKtOyRpnsiJm4HGipG3GU7Euy5K7BfI65s7eAuxjR8FFuh/Zn8fZ2cW74Ful5u5COjFEwqN6TIEFrn7k4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=C5FekYJ7; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="C5FekYJ7"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67Q6g24N1353462, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787726522; bh=v78FfpixUEnDAQLyXElN7HqbSoNGKRYY2x2LltG00eo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=C5FekYJ71fgLf3ypJooHiUvgnuA7zbbHL+MAcxHTCzup2Id6eiBPg6f1la9zvfwX9
	 QR4Sc3Vr/i8Rr0tk9z+JJJKpIGuf3zaw16GIIsuCepohw5Cs0qtxd0L7Gw16VIROCK
	 GjrHWPSWkqEmIRdwM18DrPGoHM7si2+VnoOeV496prGpkS5INWZKZvd3F7vCBpANrW
	 XgpNnfHhG/2xa5+7JvSgSuMwQzpEw8maVCDTDnk8mM+9lijonVY2aErhqmVwYp9O1c
	 NjrdVO4+VXeaCHijDvNst5K6kSkZZcA2DT2GqUB3ma5daxVGoNyUCEAFqBwYdwQ0x5
	 xAla66CkTR2UA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67Q6g24N1353462
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 14:42:02 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 26 Aug 2026 14:42:01 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 26 Aug 2026 14:42:01 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 09/14] wifi: rtw89: 8922d: bypass RX IQK when scan
Date: Wed, 26 Aug 2026 14:40:56 +0800
Message-ID: <20260826064101.58892-10-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260826064101.58892-1-pkshih@realtek.com>
References: <20260826064101.58892-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Similar to TX IQK, when connected to an AP and a scan is triggered,
the FW may fail to receive frames because switching channels may load an
uninitialized RX IQK table. Therefore, bypass RXIQK during scanning
to avoid using invalid calibration values.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/phy.c      |  5 ++
 drivers/net/wireless/realtek/rtw89/reg.h      |  4 ++
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 60 +++++++++++++++++++
 3 files changed, 69 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/phy.c b/drivers/net/wireless/realtek/rtw89/phy.c
index ebf6ecf08c35..cd56f9164cf4 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.c
+++ b/drivers/net/wireless/realtek/rtw89/phy.c
@@ -3575,6 +3575,8 @@ static void rtw89_phy_c2h_rfk_rpt_log(struct rtw89_dev *rtwdev,
 			    "[IQK] iqk->fwk_status = %x\n", iqk->fwk_status);
 
 		for (i = 0; i < 2; i++) {
+			struct rtw89_iqk_info *iqk_info = &rtwdev->iqk;
+
 			rtw89_debug(rtwdev, RTW89_DBG_RFK,
 				    "[IQK] ======== Path %x  ========\n", i);
 			rtw89_debug(rtwdev, RTW89_DBG_RFK, "[IQK] iqk->iqk_band[%d] = %x\n",
@@ -3593,6 +3595,9 @@ static void rtw89_phy_c2h_rfk_rpt_log(struct rtw89_dev *rtwdev,
 				    i, iqk->iqk_tx_fail[i]);
 			rtw89_debug(rtwdev, RTW89_DBG_RFK, "[IQK] iqk->iqk_rx_fail[%d] = %x\n",
 				    i, iqk->iqk_rx_fail[i]);
+
+			iqk_info->iqk_rx_fail[0][i] = iqk->iqk_rx_fail[i];
+
 			for (j = 0; j < 6; j++)
 				rtw89_debug(rtwdev, RTW89_DBG_RFK,
 					    "[IQK] iqk->rftxgain[%d][%d] = %x\n",
diff --git a/drivers/net/wireless/realtek/rtw89/reg.h b/drivers/net/wireless/realtek/rtw89/reg.h
index 7a3ca9c82548..4291e8115f10 100644
--- a/drivers/net/wireless/realtek/rtw89/reg.h
+++ b/drivers/net/wireless/realtek/rtw89/reg.h
@@ -11072,13 +11072,17 @@
 #define B_KTBL0_RST BIT(31)
 #define R_CFIR_CTRL_A_BE4 0x38124
 #define R_CFIR_CTRL_B_BE4 0x38224
+#define B_CFIR_CTRL_RXKIDX0_EN BIT(0)
 #define B_CFIR_CTRL_KIDX0_EN BIT(8)
+#define B_CFIR_CTRL_RXKIDX1_EN BIT(16)
 #define B_CFIR_CTRL_KIDX1_EN BIT(24)
 #define R_TX_IQC_A_BE4 0x38138
 #define R_TX_IQC_B_BE4 0x38238
 #define B_TX_IQC_X GENMASK(31, 20)
 #define B_TX_IQC_Y GENMASK(19, 8)
 #define B_TX_IQC_DPK BIT(3)
+#define R_RX_IQC_A_BE4 0x3813c
+#define R_RX_IQC_B_BE4 0x3823c
 #define R_KTBL1A_BE4 0x38154
 #define R_KTBL1B_BE4 0x38254
 #define B_KTBL1_TBL0 BIT(3)
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index 4d003b303ae7..287a9476bb77 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -2864,6 +2864,64 @@ static void __rtw8922d_txiqk_enable(struct rtw89_dev *rtwdev)
 	}
 }
 
+static void __rtw8922d_rxiqk_disable(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_rfk_mcc_info_data *rfk_mcc = rtwdev->rfk_mcc.data;
+	u8 path, kidx;
+
+	for (path = RF_PATH_A; path <= RF_PATH_B; path++) {
+		kidx = rfk_mcc[path].table_idx;
+
+		if (kidx == 0) {
+			rtw89_phy_write32_clr(rtwdev, R_CFIR_CTRL_A_BE4 + (path << 8),
+					      B_CFIR_CTRL_RXKIDX0_EN);
+		} else if (kidx == 1) {
+			rtw89_phy_write32_clr(rtwdev, R_CFIR_CTRL_A_BE4 + (path << 8),
+					      B_CFIR_CTRL_RXKIDX1_EN);
+		} else {
+			rtw89_phy_write32_mask(rtwdev, R_NCTL_CFG_BE4,
+					       B_NCTL_CFG_BE4_SPAGE, 0x1);
+			rtw89_phy_write32_clr(rtwdev, R_CFIR_CTRL_A_BE4 + (path << 8),
+					      B_CFIR_CTRL_RXKIDX0_EN);
+			rtw89_phy_write32_mask(rtwdev, R_NCTL_CFG_BE4,
+					       B_NCTL_CFG_BE4_SPAGE, 0x0);
+		}
+
+		rtw89_phy_write32(rtwdev, R_RX_IQC_A_BE4 + (path << 8), 0x40000002);
+	}
+}
+
+static void __rtw8922d_rxiqk_enable(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_rfk_mcc_info_data *rfk_mcc = rtwdev->rfk_mcc.data;
+	struct rtw89_iqk_info *iqk_info = &rtwdev->iqk;
+	u8 path, kidx;
+
+	for (path = RF_PATH_A; path <= RF_PATH_B; path++) {
+		if (iqk_info->iqk_rx_fail[0][path])
+			continue;
+
+		kidx = rfk_mcc[path].table_idx;
+
+		if (kidx == 0) {
+			rtw89_phy_write32_set(rtwdev, R_CFIR_CTRL_A_BE4 + (path << 8),
+					      B_CFIR_CTRL_RXKIDX0_EN);
+		} else if (kidx == 1) {
+			rtw89_phy_write32_set(rtwdev, R_CFIR_CTRL_A_BE4 + (path << 8),
+					      B_CFIR_CTRL_RXKIDX1_EN);
+		} else {
+			rtw89_phy_write32_mask(rtwdev, R_NCTL_CFG_BE4,
+					       B_NCTL_CFG_BE4_SPAGE, 0x1);
+			rtw89_phy_write32_set(rtwdev, R_CFIR_CTRL_A_BE4 + (path << 8),
+					      B_CFIR_CTRL_RXKIDX0_EN);
+			rtw89_phy_write32_mask(rtwdev, R_NCTL_CFG_BE4,
+					       B_NCTL_CFG_BE4_SPAGE, 0x0);
+		}
+
+		rtw89_phy_write32(rtwdev, R_RX_IQC_A_BE4 + (path << 8), 0x40000000);
+	}
+}
+
 static void rtw8922d_rfk_scan(struct rtw89_dev *rtwdev,
 			      struct rtw89_vif_link *rtwvif_link,
 			      bool start)
@@ -2871,9 +2929,11 @@ static void rtw8922d_rfk_scan(struct rtw89_dev *rtwdev,
 	if (start) {
 		__rtw8922d_tssi_disable(rtwdev, rtwvif_link->phy_idx);
 		__rtw8922d_txiqk_disable(rtwdev);
+		__rtw8922d_rxiqk_disable(rtwdev);
 	} else {
 		__rtw8922d_tssi_enable(rtwdev, rtwvif_link->phy_idx);
 		__rtw8922d_txiqk_enable(rtwdev);
+		__rtw8922d_rxiqk_enable(rtwdev);
 	}
 }
 
-- 
2.25.1

