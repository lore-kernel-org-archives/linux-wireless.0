Received: from mta0.migadu.com (out-74.mta0.migadu.com [91.218.175.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C2C4DDB4D
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 09:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790846326; cv=none; b=f3EmQzrQ9ialYJPZ82jjD9SBPK5O/SXO/x0XFBGpi/L8kM9HzaldcjD9a2GmLAvzWIVMrdi80MeoFNS7AJ6Oe2uOWGF0v+LKycl3wn0MjJAxpeOExSepSPo6PgI7RosOA4wOyNUB17NfF+bbQGBH/hvRU+CqQzJIkXELBpJK5sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790846326; c=relaxed/simple;
	bh=eNG8BScnJdNZgXMf4qWyzYfjiOoVwJlF0IPUmJ3vQVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5AFoqiL5ZrpxWzXJO1Tp8/kK98G3tZSe3VxEMwCAdit3sjgbojnDjAMEE/D4stQAgLSbeIQq0FhF/4oMeVmS1Lc6AfP4Y2LzSKPzXyT7zD7zezl4bheIEV5qogV/H+XFQRpQEceAOX+SU/e4veEAgii5MiXfcjb4IGvzcr5O4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jnwmqGxN; arc=none smtp.client-ip=91.218.175.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jnwmqGxN"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=eNG8BScnJdNZgXMf4qWyzYfjiOoVwJlF0IPUmJ3vQVc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790846321; v=1; x=1791451121;
 b=jnwmqGxNF8kEQRJaLroCKCFIQaVSi0hpwNMtVf/A3ELEGySIiGYXzB/h8PP6dB/xJM/4ZHfe
 TFT32FpttLut0OeGaHpOxzZeyMwJnKOFfPQEaN+Xu0fIK53Qxmc0MlZ8Z90pYdDDg5Oeyf9mE4G
 jBaLIciG2Z6m9ogLYVdMNqAU=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 722e9d43f43a6d07;
	Thu, 01 Oct 2026 09:18:41 +0000
X-Mizu-Trace-ID: 722e9d43f43a6d07
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH rtw-next v6 1/6] wifi: rtw88: move the 88xxa CCK power detect setter to phy.c
Date: Thu,  1 Oct 2026 11:18:30 +0200
Message-ID: <20261001091835.67909-2-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261001091835.67909-1-luka.gejak@linux.dev>
References: <20261001091835.67909-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The CCK power detect setter in rtw88xxa.c programs values that are not
specific to that chip family. The RTL8723B wants the same setter, but
pulling in the whole rtw88_88xxa module for one helper is not worth it.

Move it to phy.c as rtw_phy_cck_pd_set(), where the rest of the CCK power
detect code and the level enum already live. rtw8812a and rtw8821a call
the core version, so rtw88xxa.c no longer provides it.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/phy.c      | 39 +++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/phy.h      |  1 +
 drivers/net/wireless/realtek/rtw88/rtw8812a.c |  2 +-
 drivers/net/wireless/realtek/rtw88/rtw8821a.c |  2 +-
 drivers/net/wireless/realtek/rtw88/rtw88xxa.c | 38 ------------------
 drivers/net/wireless/realtek/rtw88/rtw88xxa.h |  1 -
 6 files changed, 42 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index e2ac5c6fd500..e2515a662bb3 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -811,6 +811,45 @@ static void rtw_phy_cck_pd(struct rtw_dev *rtwdev)
 		chip->ops->cck_pd_set(rtwdev, level);
 }
 
+void rtw_phy_cck_pd_set(struct rtw_dev *rtwdev, u8 new_lvl)
+{
+	static const u8 pd[CCK_PD_LV_MAX] = {0x40, 0x83, 0xcd, 0xdd, 0xed};
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+
+	/*
+	 * Override rtw_phy_cck_pd_lv_link(). It implements something
+	 * like type 2/3/4. We need type 1 here.
+	 */
+	if (rtw_is_assoc(rtwdev)) {
+		if (dm_info->min_rssi > 60) {
+			new_lvl = CCK_PD_LV3;
+		} else if (dm_info->min_rssi > 35) {
+			new_lvl = CCK_PD_LV2;
+		} else if (dm_info->min_rssi > 20) {
+			if (dm_info->cck_fa_avg > 500)
+				new_lvl = CCK_PD_LV2;
+			else if (dm_info->cck_fa_avg < 250)
+				new_lvl = CCK_PD_LV1;
+			else
+				return;
+		} else {
+			new_lvl = CCK_PD_LV1;
+		}
+	}
+
+	rtw_dbg(rtwdev, RTW_DBG_PHY, "lv: (%d) -> (%d)\n",
+		dm_info->cck_pd_lv[RTW_CHANNEL_WIDTH_20][RF_PATH_A], new_lvl);
+
+	if (dm_info->cck_pd_lv[RTW_CHANNEL_WIDTH_20][RF_PATH_A] == new_lvl)
+		return;
+
+	dm_info->cck_fa_avg = CCK_FA_AVG_RESET;
+	dm_info->cck_pd_lv[RTW_CHANNEL_WIDTH_20][RF_PATH_A] = new_lvl;
+
+	rtw_write8(rtwdev, REG_CCK_PD_TH, pd[new_lvl]);
+}
+EXPORT_SYMBOL(rtw_phy_cck_pd_set);
+
 static void rtw_phy_pwr_track(struct rtw_dev *rtwdev)
 {
 	rtwdev->chip->ops->pwr_track(rtwdev);
diff --git a/drivers/net/wireless/realtek/rtw88/phy.h b/drivers/net/wireless/realtek/rtw88/phy.h
index 8449936497bb..8a843aac7350 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.h
+++ b/drivers/net/wireless/realtek/rtw88/phy.h
@@ -65,6 +65,7 @@ void rtw_phy_config_swing_table(struct rtw_dev *rtwdev,
 				struct rtw_swing_table *swing_table);
 void rtw_phy_set_edcca_th(struct rtw_dev *rtwdev, u8 l2h, u8 h2l);
 void rtw_phy_adaptivity_set_mode(struct rtw_dev *rtwdev);
+void rtw_phy_cck_pd_set(struct rtw_dev *rtwdev, u8 new_lvl);
 void rtw_phy_parsing_cfo(struct rtw_dev *rtwdev,
 			 struct rtw_rx_pkt_stat *pkt_stat);
 void rtw_phy_tx_path_diversity(struct rtw_dev *rtwdev);
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8812a.c b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
index 2078eb6e3628..781b66ccde67 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8812a.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
@@ -929,7 +929,7 @@ static const struct rtw_chip_ops rtw8812a_ops = {
 	.set_ampdu_factor	= NULL,
 	.false_alarm_statistics	= rtw88xxa_false_alarm_statistics,
 	.phy_calibration	= rtw8812a_phy_calibration,
-	.cck_pd_set		= rtw88xxa_phy_cck_pd_set,
+	.cck_pd_set		= rtw_phy_cck_pd_set,
 	.pwr_track		= rtw8812a_pwr_track,
 	.config_bfee		= NULL,
 	.set_gid_table		= NULL,
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821a.c b/drivers/net/wireless/realtek/rtw88/rtw8821a.c
index cab85203b828..6096d3b8e41b 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821a.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821a.c
@@ -875,7 +875,7 @@ static const struct rtw_chip_ops rtw8821a_ops = {
 	.set_ampdu_factor	= NULL,
 	.false_alarm_statistics	= rtw88xxa_false_alarm_statistics,
 	.phy_calibration	= rtw8821a_phy_calibration,
-	.cck_pd_set		= rtw88xxa_phy_cck_pd_set,
+	.cck_pd_set		= rtw_phy_cck_pd_set,
 	.pwr_track		= rtw8821a_pwr_track,
 	.config_bfee		= NULL,
 	.set_gid_table		= NULL,
diff --git a/drivers/net/wireless/realtek/rtw88/rtw88xxa.c b/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
index 2eaadcfec4cb..c298fa0fb2a6 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
@@ -1947,44 +1947,6 @@ void rtw88xxa_phy_pwrtrack(struct rtw_dev *rtwdev,
 }
 EXPORT_SYMBOL(rtw88xxa_phy_pwrtrack);
 
-void rtw88xxa_phy_cck_pd_set(struct rtw_dev *rtwdev, u8 new_lvl)
-{
-	static const u8 pd[CCK_PD_LV_MAX] = {0x40, 0x83, 0xcd, 0xdd, 0xed};
-	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
-
-	/* Override rtw_phy_cck_pd_lv_link(). It implements something
-	 * like type 2/3/4. We need type 1 here.
-	 */
-	if (rtw_is_assoc(rtwdev)) {
-		if (dm_info->min_rssi > 60) {
-			new_lvl = CCK_PD_LV3;
-		} else if (dm_info->min_rssi > 35) {
-			new_lvl = CCK_PD_LV2;
-		} else if (dm_info->min_rssi > 20) {
-			if (dm_info->cck_fa_avg > 500)
-				new_lvl = CCK_PD_LV2;
-			else if (dm_info->cck_fa_avg < 250)
-				new_lvl = CCK_PD_LV1;
-			else
-				return;
-		} else {
-			new_lvl = CCK_PD_LV1;
-		}
-	}
-
-	rtw_dbg(rtwdev, RTW_DBG_PHY, "lv: (%d) -> (%d)\n",
-		dm_info->cck_pd_lv[RTW_CHANNEL_WIDTH_20][RF_PATH_A], new_lvl);
-
-	if (dm_info->cck_pd_lv[RTW_CHANNEL_WIDTH_20][RF_PATH_A] == new_lvl)
-		return;
-
-	dm_info->cck_fa_avg = CCK_FA_AVG_RESET;
-	dm_info->cck_pd_lv[RTW_CHANNEL_WIDTH_20][RF_PATH_A] = new_lvl;
-
-	rtw_write8(rtwdev, REG_CCK_PD_TH, pd[new_lvl]);
-}
-EXPORT_SYMBOL(rtw88xxa_phy_cck_pd_set);
-
 MODULE_AUTHOR("Realtek Corporation");
 MODULE_DESCRIPTION("Realtek 802.11ac wireless 8821a/8811a/8812a common code");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/realtek/rtw88/rtw88xxa.h b/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
index 09a45c1a4129..d9c8db58909c 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
@@ -170,6 +170,5 @@ bool rtw88xxa_iqk_finish(int average, int threshold,
 void rtw88xxa_phy_pwrtrack(struct rtw_dev *rtwdev,
 			   void (*do_lck)(struct rtw_dev *rtwdev),
 			   void (*do_iqk)(struct rtw_dev *rtwdev));
-void rtw88xxa_phy_cck_pd_set(struct rtw_dev *rtwdev, u8 new_lvl);
 
 #endif
-- 
2.55.0

