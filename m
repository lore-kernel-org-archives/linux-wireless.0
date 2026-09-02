Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C1D38887C
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 05:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327068; cv=none; b=H3xepCpBFCCLq4caaOIffyf8nMTJlU0WfkQaCQ3x/4GkvOdGEBIZOskkT0wt2qBDHcE4C7PJlHz7EEWvCvaDYe1KQkNF1KNHfHOxhgdVpi6Ky71tGTU5j2cmeRoxAu77rJPnM4Qx57bRN1+BTIjOjXqcw3S42gBQKfWgFOo6mn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327068; c=relaxed/simple;
	bh=dMMPtC0EM5mM3+MImcQDYHKQXLsSvzfJiFpkCnK3u38=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IijiqsNNnbvuw7v6oLCTi7ogV+RclvpWLXZGs6w6O8Pu0nTAXZfURWCn7B7FVyffa7akiAI060JfKAAErLJP6kMFIwmI5IS5PWIo/qZJ9xWGYOv2ujv2hj94IcFJeQ+mDZW6AdW7oYWDXmGt5CDjI5AV6aHfgH4hVpm8WqveZrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=a5X0ozh4; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="a5X0ozh4"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6825V38902368492, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788327063; bh=v78FfpixUEnDAQLyXElN7HqbSoNGKRYY2x2LltG00eo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=a5X0ozh4jRrSZ/BtELsV1xd8Zqgn60Xu6ceEuEdFfXnb8udAYfyhbZ864g8Ncs1po
	 pTVpeWvadGIiVPJVHAttTKIgGQykp5YdYEF5SWUtmcWDz1pbPMdOoFNu5idIdkhuom
	 7m15pC31z57k4WyjrBStTTOYgf0raTd7K57YBsSMqyxNl04Iz13joNH+qGBPYhF7t6
	 rMhtavFZx32odmvpWFSVbYX3ZNo+pCy3VaE2IHA0EyJU9MBVf33mn3GIoJr+eLAfnc
	 ADCI6Nzhq6Emb0l4qPCzuez7nn12Al532e/iBVU/rxm1kBGAh3Wj1by2mndw+RWTeO
	 6krRI36IRDfbA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6825V38902368492
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 2 Sep 2026 13:31:03 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 13:31:03 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 13:31:03 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next v2 09/14] wifi: rtw89: 8922d: bypass RX IQK when scan
Date: Wed, 2 Sep 2026 13:29:53 +0800
Message-ID: <20260902052958.50371-10-pkshih@realtek.com>
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

