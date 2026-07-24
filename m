Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65EB5456E0D
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 18:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784918000; cv=none; b=rH0JCnlmxB2OoWp9jo4QRZHwzR6MDERiQopG499Tx/OPIItQXx+viy+NX0YI3vguB5cuJdlyCokzY5r078jK3uJ8SQkZYfP4mBL5Cna5aPdfFih4OGzO426JT6md5rsvaETzqQjhqSI0s46c3GW+ZqarQ/ezbkDvIPN/GUL202o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784918000; c=relaxed/simple;
	bh=IYN67CTWlWd5uqMLGI0fNx7E6o60K7yIkYCVeDsihQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JX+VlQ3Jk/8CWrRsOhYyR2wpxubo3Ljtg9t37igQKBdPL955FoDO2vL3yCOR4SySw2/gvRHRTyq+n6BpmhOtA0DFB9CqpHAUDtpLlOQ3l1hCTs3aK/fEm8icAfjRzzIYG9FqsQSuijyCgDDRK55CrtQxGG+NltQJY5d0AV9PEh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Lm27fKR/; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Lm27fKR/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784917993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c4AM1rkorXxEKoTyPoChFB0VfWSxWEZDMaaj1rQDeBo=;
	b=Lm27fKR/oXOQYU+oIn47B36IawiM+cbHZH33EuC/ntRFzq+h2S5QnW9/NEUhwkMxMJNy5y
	qaeKzWTzr9WGWzHXEqZpgf6V5bHVU3F0mu++UtsCp/UtT/kVAx1cGp0VSw9bJa21TTHm4D
	eMBqXYWY9FJ5nF5DnPBchL12wndGB0Y=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH 17/19] wifi: rtw88: calibrate and tune the PHY for RTL8723BS
Date: Fri, 24 Jul 2026 20:33:10 +0200
Message-ID: <20260724183310.197159-1-luka.gejak@linux.dev>
In-Reply-To: <20260724181858.192903-1-luka.gejak@linux.dev>
References: <20260724181858.192903-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

Three PHY adjustments this chip needs. The IQK has to run once at the
first power on and not again when leaving IPS, because repeating it
disturbs a working link; the vendor driver calibrates only during the
initial hal_init for the same reason. Loading the parameter tables
overwrites the per-rate TX AGC values with the by-rate cache, so the
vendor power-by-rate bytes have to be restored after a channel set. And
the scan-time initial gain has to be lowered, without which the site
survey does not reliably hear an AP that the chip associates with fine.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/main.c | 114 ++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/main.h |   2 +
 2 files changed, 116 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 16228cae252e..a2ef4479f408 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -43,6 +43,89 @@ MODULE_PARM_DESC(disable_lps_deep, "Set Y to disable Deep PS");
 MODULE_PARM_DESC(support_bf, "Set Y to enable beamformee support");
 MODULE_PARM_DESC(debug_mask, "Debugging mask");
 
+#define RTW8723BS_REG_BB_SEL_BTG	0x0948
+#define RTW8723BS_SCAN_IGI		0x1e
+
+struct rtw8723bs_txagc_entry {
+	u8 rate;
+	u8 pwr_idx;
+};
+
+/* Vendor/staging per-rate TXAGC PG bytes for 8723BS 2.4 GHz. */
+static const struct rtw8723bs_txagc_entry rtw8723bs_pg_txagc[] = {
+	{ DESC_RATE1M, 0x38 }, { DESC_RATE2M, 0x36 },
+	{ DESC_RATE5_5M, 0x34 }, { DESC_RATE11M, 0x32 },
+	{ DESC_RATE6M, 0x44 }, { DESC_RATE9M, 0x44 },
+	{ DESC_RATE12M, 0x42 }, { DESC_RATE18M, 0x40 },
+	{ DESC_RATE24M, 0x38 }, { DESC_RATE36M, 0x36 },
+	{ DESC_RATE48M, 0x32 }, { DESC_RATE54M, 0x28 },
+	{ DESC_RATEMCS0, 0x44 }, { DESC_RATEMCS1, 0x42 },
+	{ DESC_RATEMCS2, 0x40 }, { DESC_RATEMCS3, 0x38 },
+	{ DESC_RATEMCS4, 0x36 }, { DESC_RATEMCS5, 0x34 },
+	{ DESC_RATEMCS6, 0x30 }, { DESC_RATEMCS7, 0x26 },
+};
+
+/* Lower the scan-time initial gain so the 8723BS SDIO site-survey hears the AP. */
+static void rtw_scan_set_8723bs_igi(struct rtw_dev *rtwdev)
+{
+	if (!rtw_is_8723bs(rtwdev))
+		return;
+
+	rtw_write32_mask(rtwdev, REG_RXIGI_A, MASKBYTE0, RTW8723BS_SCAN_IGI);
+}
+
+/* rtw_load_table() only populates the by-rate cache; restore the staging
+ * 8723BS PG bytes after the generic channel power update and push them to the
+ * chip TXAGC registers.
+ */
+static void rtw8723bs_reapply_pg_txagc(struct rtw_dev *rtwdev)
+{
+	struct rtw_hal *hal = &rtwdev->hal;
+	u8 path;
+	int i;
+
+	if (!rtw_is_8723bs(rtwdev) || hal->current_band_type != RTW_BAND_2G)
+		return;
+
+	mutex_lock(&hal->tx_power_mutex);
+	for (path = 0; path < hal->rf_path_num && path < RTW_RF_PATH_MAX; path++)
+		for (i = 0; i < ARRAY_SIZE(rtw8723bs_pg_txagc); i++)
+			hal->tx_pwr_tbl[path][rtw8723bs_pg_txagc[i].rate] =
+				rtw8723bs_pg_txagc[i].pwr_idx;
+	rtwdev->chip->ops->set_tx_power_index(rtwdev);
+	mutex_unlock(&hal->tx_power_mutex);
+}
+
+/* Staging runs PHY_IQCalibrate_8723B() only during initial hal_init, never on
+ * IPS leave. Match that: run IQK once on the first power-on, then on later
+ * (IPS-leave) power-ons just restore the PTA antenna path and reset RF_WLINT.
+ */
+static void rtw_power_on_8723bs_sdio_rfk(struct rtw_dev *rtwdev)
+{
+	const struct rtw_chip_info *chip = rtwdev->chip;
+	struct rtw_efuse *efuse = &rtwdev->efuse;
+	u32 pta_path;
+	u32 saved_path;
+
+	if (!rtw_is_8723bs(rtwdev) || !chip->ops->phy_calibration)
+		return;
+
+	pta_path = (efuse->bt_setting & BIT(6)) ? 0x80 : 0x200;
+
+	if (rtwdev->initial_rfk_done) {
+		rtw_write32(rtwdev, RTW8723BS_REG_BB_SEL_BTG, pta_path);
+		rtw_write_rf(rtwdev, RF_PATH_A, RF_WLINT, RFREG_MASK, 0x0780);
+		return;
+	}
+
+	saved_path = rtw_read32(rtwdev, RTW8723BS_REG_BB_SEL_BTG);
+	rtw_write32(rtwdev, RTW8723BS_REG_BB_SEL_BTG, pta_path);
+	chip->ops->phy_calibration(rtwdev);
+	rtwdev->need_rfk = false;
+	rtw_write32(rtwdev, RTW8723BS_REG_BB_SEL_BTG, saved_path);
+	rtwdev->initial_rfk_done = true;
+}
+
 static struct ieee80211_channel rtw_channeltable_2g[] = {
 	{.center_freq = 2412, .hw_value = 1,},
 	{.center_freq = 2417, .hw_value = 2,},
@@ -904,6 +987,8 @@ void rtw_set_channel(struct rtw_dev *rtwdev)
 
 	rtw_phy_set_tx_power_level(rtwdev, center_chan);
 
+	rtw8723bs_reapply_pg_txagc(rtwdev);
+
 	/* if the channel isn't set for scanning, we will do RF calibration
 	 * in ieee80211_ops::mgd_prepare_tx(). Performing the calibration
 	 * during scanning on each channel takes too long.
@@ -1429,6 +1514,34 @@ int rtw_power_on(struct rtw_dev *rtwdev)
 	rtw_fw_send_phydm_info(rtwdev);
 
 	wifi_only = !rtwdev->efuse.btcoex;
+
+	/* 8723BS SDIO: on an IPS-leave power-on (IQK already done once) skip the
+	 * BT-path coex init entirely - scan_workaround re-establishes the PTA /
+	 * coex state. Run the once-only IQK via the RFK helper; on the first
+	 * power-on, finalise coex with the vendor init H2C toggle that enables
+	 * the 8051 management TX scheduler.
+	 */
+	if (rtw_is_8723bs(rtwdev)) {
+		bool ips_wake = rtwdev->initial_rfk_done;
+
+		if (!ips_wake)
+			rtw_coex_power_on_setting(rtwdev);
+
+		rtw_power_on_8723bs_sdio_rfk(rtwdev);
+
+		if (!ips_wake) {
+			rtw_coex_init_hw_config(rtwdev, wifi_only);
+			rtw_fw_coex_tdma_type(rtwdev, 0x08, 0x00, 0x00, 0x00, 0x00);
+			rtw_fw_set_gnt_bt(rtwdev, 1);
+			rtw_fw_coex_ant_sel_rsv(rtwdev, 0, 0);
+			rtw_fw_query_bt_info(rtwdev);
+			rtw_fw_coex_tdma_type(rtwdev, 0x08, 0x00, 0x00, 0x00, 0x00);
+			rtw_fw_set_gnt_bt(rtwdev, 0);
+		}
+
+		return 0;
+	}
+
 	rtw_coex_power_on_setting(rtwdev);
 	rtw_coex_init_hw_config(rtwdev, wifi_only);
 
@@ -1485,6 +1598,7 @@ void rtw_core_scan_start(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif,
 	set_bit(RTW_FLAG_SCANNING, rtwdev->flags);
 
 	rtw_phy_dig_set_max_coverage(rtwdev);
+	rtw_scan_set_8723bs_igi(rtwdev);
 }
 
 void rtw_core_scan_complete(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index aa09fef8c19f..c6d993e989dd 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -2151,6 +2151,8 @@ struct rtw_dev {
 	struct rtw_wow_param wow;
 
 	bool need_rfk;
+	/* Run the initial IQK once, not on every IPS leave. */
+	bool initial_rfk_done;
 	struct completion fw_scan_density;
 	bool ap_active;
 
-- 
2.55.0

