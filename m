Received: from mta0.migadu.com (out-93.mta0.migadu.com [91.218.175.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DBC3AEF20
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 09:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790759775; cv=none; b=caZOKTxy6JtOYH+4/b1iLPSqutZPwWDzV1CMeduc3a8ruJGg8RaU4w37B3MQR8Eui3YvZu+h2sxgVuk9xt0+OZzBWtgSVgTH8e5s3phvvCLq/aDemfKXjJ26oY9/DyDF0WeYH9AA4xXbgv/4eXgCVWMNWw5/4WkdvAiKaEpsk5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790759775; c=relaxed/simple;
	bh=Kf8zSrTZEGWcDXuxh06HOIyDtHviyBTU6Jnxhrq3A5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1/AmhC4+tfjBKL6lGBTtQMEyVDCLUem6fU8yLkKNieC3CBekW/Oac9/4Qj8usHpGEnlNgXQDGGXJk2djbDCdD+kOc07f/7mfdpxn90cbwrvihLtui7Nf65m/CnVflA9ZwKMg+ZTDX0QO2WkNdu6SzYZGw8jHTpbQlVEzwKBBcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U0LSfnsQ; arc=none smtp.client-ip=91.218.175.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U0LSfnsQ"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Kf8zSrTZEGWcDXuxh06HOIyDtHviyBTU6Jnxhrq3A5U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790759770; v=1; x=1791364570;
 b=U0LSfnsQIGzgImz23uiie1dHfEvXWbR8cPEsGTlNewqU3HqOXZ6iRVVE9TWZD6WfHorqapCG
 87IbC4kMFY7PBHUeRU8RWWK2NV6P/oe4/4LXHz2n3q5ueroxvdiN0m7KeQaToBnX7HSWKWdy+EA
 oS5cZeJ2B5bJpvqBkbdeHzog=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6bcfbb48d7dd0fdd;
	Wed, 30 Sep 2026 09:16:10 +0000
X-Mizu-Trace-ID: 6bcfbb48d7dd0fdd
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v5 rtw-next 1/7] wifi: rtw88: move the shared 88xxa init helpers into the core
Date: Wed, 30 Sep 2026 11:15:58 +0200
Message-ID: <20260930091604.52891-2-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930091604.52891-1-luka.gejak@linux.dev>
References: <20260930091604.52891-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The adaptive control, EDCA and CCK power detect helpers in rtw88xxa.c
program values that are not specific to that chip family. The RTL8723B
needs all three of them, which would make that chip select RTW88_88XXA
and pull in a whole chip module for three helpers.

Move the CCK power detect setter to phy.c as rtw_phy_cck_pd_set(), where
the rest of the CCK power detect code and the level enum already live,
and the two MAC init helpers to mac.c as rtw_mac_init_adaptive_ctrl()
and rtw_mac_init_edca(). The chips that need them call the core
versions, so rtw88xxa.c no longer provides any of them.

The two REG_USTIME_* writes are not carried over. rtw88xxa_power_on()
writes the same values a few lines later, and rtw_set_channel_mac()
writes them again on every channel set, so the register state of the
existing chips does not change.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/mac.c      | 22 +++++++
 drivers/net/wireless/realtek/rtw88/mac.h      |  2 +
 drivers/net/wireless/realtek/rtw88/phy.c      | 38 +++++++++++
 drivers/net/wireless/realtek/rtw88/phy.h      |  1 +
 drivers/net/wireless/realtek/rtw88/rtw8812a.c |  2 +-
 drivers/net/wireless/realtek/rtw88/rtw8821a.c |  2 +-
 drivers/net/wireless/realtek/rtw88/rtw88xxa.c | 65 +------------------
 drivers/net/wireless/realtek/rtw88/rtw88xxa.h |  1 -
 8 files changed, 67 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index eaa928bab240..83f142f61df5 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -1419,3 +1419,25 @@ int rtw_mac_postinit(struct rtw_dev *rtwdev)
 
 	return chip->ops->mac_postinit(rtwdev);
 }
+
+void rtw_mac_init_adaptive_ctrl(struct rtw_dev *rtwdev)
+{
+	rtw_write32_mask(rtwdev, REG_RRSR, 0xfffff, 0xffff1);
+	rtw_write16(rtwdev, REG_RETRY_LIMIT, 0x3030);
+}
+EXPORT_SYMBOL(rtw_mac_init_adaptive_ctrl);
+
+void rtw_mac_init_edca(struct rtw_dev *rtwdev)
+{
+	rtw_write16(rtwdev, REG_SPEC_SIFS, 0x100a);
+	rtw_write16(rtwdev, REG_MAC_SPEC_SIFS, 0x100a);
+
+	rtw_write16(rtwdev, REG_SIFS, 0x100a);
+	rtw_write16(rtwdev, REG_SIFS + 2, 0x100a);
+
+	rtw_write32(rtwdev, REG_EDCA_BE_PARAM, 0x005EA42B);
+	rtw_write32(rtwdev, REG_EDCA_BK_PARAM, 0x0000A44F);
+	rtw_write32(rtwdev, REG_EDCA_VI_PARAM, 0x005EA324);
+	rtw_write32(rtwdev, REG_EDCA_VO_PARAM, 0x002FA226);
+}
+EXPORT_SYMBOL(rtw_mac_init_edca);
diff --git a/drivers/net/wireless/realtek/rtw88/mac.h b/drivers/net/wireless/realtek/rtw88/mac.h
index b73af90ee1d7..b7adc4dd0255 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.h
+++ b/drivers/net/wireless/realtek/rtw88/mac.h
@@ -30,6 +30,8 @@
 
 void rtw_set_channel_mac(struct rtw_dev *rtwdev, u8 channel, u8 bw,
 			 u8 primary_ch_idx);
+void rtw_mac_init_adaptive_ctrl(struct rtw_dev *rtwdev);
+void rtw_mac_init_edca(struct rtw_dev *rtwdev);
 int rtw_pwr_seq_parser(struct rtw_dev *rtwdev,
 		       const struct rtw_pwr_seq_cmd * const *cmd_seq);
 int rtw_mac_power_on(struct rtw_dev *rtwdev);
diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index e2ac5c6fd500..ee16474ac026 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -811,6 +811,44 @@ static void rtw_phy_cck_pd(struct rtw_dev *rtwdev)
 		chip->ops->cck_pd_set(rtwdev, level);
 }
 
+void rtw_phy_cck_pd_set(struct rtw_dev *rtwdev, u8 new_lvl)
+{
+	static const u8 pd[CCK_PD_LV_MAX] = {0x40, 0x83, 0xcd, 0xdd, 0xed};
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+
+	/* Override rtw_phy_cck_pd_lv_link(). It implements something
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
index 2eaadcfec4cb..c95405eacfa3 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
@@ -520,29 +520,6 @@ static void rtw88xxa_init_wmac_setting(struct rtw_dev *rtwdev)
 	rtw_write32(rtwdev, REG_MAR + 4, 0xffffffff);
 }
 
-static void rtw88xxa_init_adaptive_ctrl(struct rtw_dev *rtwdev)
-{
-	rtw_write32_mask(rtwdev, REG_RRSR, 0xfffff, 0xffff1);
-	rtw_write16(rtwdev, REG_RETRY_LIMIT, 0x3030);
-}
-
-static void rtw88xxa_init_edca(struct rtw_dev *rtwdev)
-{
-	rtw_write16(rtwdev, REG_SPEC_SIFS, 0x100a);
-	rtw_write16(rtwdev, REG_MAC_SPEC_SIFS, 0x100a);
-
-	rtw_write16(rtwdev, REG_SIFS, 0x100a);
-	rtw_write16(rtwdev, REG_SIFS + 2, 0x100a);
-
-	rtw_write32(rtwdev, REG_EDCA_BE_PARAM, 0x005EA42B);
-	rtw_write32(rtwdev, REG_EDCA_BK_PARAM, 0x0000A44F);
-	rtw_write32(rtwdev, REG_EDCA_VI_PARAM, 0x005EA324);
-	rtw_write32(rtwdev, REG_EDCA_VO_PARAM, 0x002FA226);
-
-	rtw_write8(rtwdev, REG_USTIME_TSF, 0x50);
-	rtw_write8(rtwdev, REG_USTIME_EDCA, 0x50);
-}
-
 static void rtw88xxau_tx_aggregation(struct rtw_dev *rtwdev)
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
@@ -1103,8 +1080,8 @@ int rtw88xxa_power_on(struct rtw_dev *rtwdev)
 	rtw_write32_mask(rtwdev, REG_CR, 0x30000, 0x2);
 
 	rtw88xxa_init_wmac_setting(rtwdev);
-	rtw88xxa_init_adaptive_ctrl(rtwdev);
-	rtw88xxa_init_edca(rtwdev);
+	rtw_mac_init_adaptive_ctrl(rtwdev);
+	rtw_mac_init_edca(rtwdev);
 
 	rtw_write8_set(rtwdev, REG_FWHW_TXQ_CTRL, BIT(7));
 	rtw_write8(rtwdev, REG_ACKTO, 0x80);
@@ -1947,44 +1924,6 @@ void rtw88xxa_phy_pwrtrack(struct rtw_dev *rtwdev,
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

