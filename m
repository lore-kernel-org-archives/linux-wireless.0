Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793430635;
	b=P3eQpjHcgUYdGfqKhjsKElyTse4eN7DEdOtX6F6OaO2AmqIqg4Ig9zkZClR/T2wD8W5T
	 3yAOM7yPqjcxoep/0f0Wx9z7D5f1mFObY5jMqU5IFF2yS3AT/Lw4SzjgXlJXf1d4Xxunm
	 zZxLWJggw2rpsMQVZqoKfIuQeMXH1tuOA7irGCkAyWe4uzMErw2uBXny02FQs8xnm9orN
	 zywp8ZEKFUmtOBqf7jqNQ8sFsQh73NwKCwl6tzRyPT0aYaIa1qH5U6m0m8dwK7fpWddRQ
	 tAVKnUBXVEB07+bhvKq+l4YNNaVG5geKZ947gqube8eZ3nvTf1Usw2Nwve/n94LUpPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793430635;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bO1u3VfNC7GkGYAT3VXz0hQ/AM+UqWaHVbhrz6dZ+E4=;
	b=unMZqteamWgEwjMCTy+ekPDLTPzD6LGd5jdfaPxxFexhtfk5ULlVOnrOQF83tIvw8CAU
	 yVhEUG9De+atL06Rc7mdcePJDg8Xw4JBuW668hP3xIkB4NLxaVpHraUagt0TLrid1ERah
	 DOG8TDLg50wKE4zQ4i/jGeN1PZI+y9GYdP8b/EmUmCwc95ey5y4PkOFIVnprASQI9ctlO
	 A5si+Fb3hIA0i5JnYMNlSRvPV2t+ts70QgMk3GgamvlxCNltpasRhJf/sEGmfqN1s4EB/
	 /Z7mFjIlfBi+uu/g9lNyyexTmm/A0sCWCaIFma/JJiqB3VDjyp4a+aCMzPvwKEcMv5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="x2Sxr/q7";
	arc=none smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D737606A31C
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 07:10:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D737606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x2Sxr/q7
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3ae6b4c669fso1646045a91.0
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 00:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793430634; x=1794035434; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bO1u3VfNC7GkGYAT3VXz0hQ/AM+UqWaHVbhrz6dZ+E4=;
        b=x2Sxr/q72QAxWU4hyA7OhhMasd4kMZGGTWwAaxnOHc+T55EI1AKloGAbTlntXLKVqw
         G68CHpUFnKFyBkQUV5h+EZEuFYfJTNlHG0QWXzK1GhWcd1Dill05y8HuBPnC9FTTXbyp
         SvQVOhKMaweSSQQfHJvZSwsfbvW0UM5IGMIrSm20jCy2/9ukcPWTcPznHqllOMO57yle
         mhldWF9K0SLkU+wK2ALj14tslUUrwjZxFpBIgCoZ2izlXkwmOtSXfbxGryBNehoDc/jZ
         oBDwjz2XsKFcTpptaVQN6YIv5ku1Hba5TUG3zE36IvngR84z6jAc2oM8FcQesXyoe0cf
         cwNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793430634; x=1794035434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bO1u3VfNC7GkGYAT3VXz0hQ/AM+UqWaHVbhrz6dZ+E4=;
        b=D2i71SsEVUc2vp1jkPgF27MwaJv+g3lVkLQwkNma+6KMwo9g9CbgGthvuSYtqMZYTW
         f2rHiexuFmRVvWqlBq50KWWfsJP2o9TXh57afaBCg5tWP3SmZnZ0O7Xhj50pan7ztTjI
         W5Pnj8rlSWPtAr/wWmY1Dz7gkQPQW7YwmL5E0I7p+7OgfFWvGRkUxl8hlTnZznu5gLSg
         RlU4i5OH77UAOqL3JxqwBbDjycaMP76yEG2aDM3P5xnbIkNk83ahe1awkA4uRgjrgHo2
         4qGzB2SKnjBlND8VjbEMYtvvZDieV6R3QJjNQlU2Z2uL81nszdqlKkLpAlSbk3a1swhg
         c9qw==
X-Gm-Message-State: AFq9FYKit5igEfeZ0t+FA+FctPHO6oWcw1ll1el2FX85IimygZ9FhC3v
	TzQVdLWle6rJOrA5f5HXCjuw3anScYMtPMqidNx4G1wcH1uT7qVQn+NAxDxQybRW
X-Gm-Gg: AYBFou2asGzuubUGxuvGTMwBNCtrVI1XrF/O5s7dJiMq+oS4kvi1GW5RHoW62q9aosq
	iBpaHBVB9oR0vppfSNtJVOas/w2+sXaU6wuHstmv4K7jT43jbdxhD6kgnCsUFUSMIXybzP3XTZt
	Au+Ehn59aXKE8a7HtwyrkGPzy+8Lnrzw/BDL9NmkaiJCuapvCf7UxyuGxze/6SqtkKoHOi/dDz/
	GBu3GiqWp+S1Glx/GAH4Ugbf1CRI1p/44QA03tX185TqOwVMF+JAFsmHUdNu5wTrSlZFPdqeWg3
	sc5+06VoCA1OzfCqbRCsprxseXF3ZjFDlTPWtQqc+PzOeOfs0rLx7Wugu1nKMgI/nU/1LWvUnTQ
	+gcAJI4F3cFjZJlkDHF46Nt9ixSBN4nm9X+LHWelIA51Qej12medzr1CvyP0F+eGyGlBLOYPa45
	PcuPrlIVod0oP3+IltomAyWJbaV9cGn0+n8GDji2Bv+CBjQigc4c0YLFMouBmDy4/Sh/jWXeBPW
	6e2l7jpw9M+n4ojFPYEqitjbB1iCRoR5VvWNaihzvVoV0JhZfM7vjly0a91mbzJrH0YoqXZPzTl
	JWv0ASLHdOA94gmndJUhy/R2EXYrtJTc21HsEiD1GnfPKR1ak9KaZTm91ByLQZjwajRnrl+k9HU
	ItNOF
X-Received: by 2002:a17:90b:1cc4:b0:39e:6c68:fd91 with SMTP id 98e67ed59e1d1-3ae897c030cmr2224198a91.38.1793430634346;
        Sat, 31 Oct 2026 00:10:34 -0700 (PDT)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3ae845432e4sm6670459a91.3.2026.10.31.00.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 00:10:33 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH rtw-next v2 6/7] wifi: rtw88: 88xxa: adapt channel sensing to receiver gain
Date: Sat, 31 Oct 2026 15:09:46 +0800
Message-ID: <20261031070950.425176-7-hjf3108@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261031070950.425176-1-hjf3108@gmail.com>
References: <20261031070950.425176-1-hjf3108@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement adaptivity for 88xxa, since they support it in
the hardware.

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/main.h     |   1 +
 drivers/net/wireless/realtek/rtw88/phy.c      |   7 +
 drivers/net/wireless/realtek/rtw88/rtw8812a.c |  10 ++
 drivers/net/wireless/realtek/rtw88/rtw8821a.c |  10 ++
 drivers/net/wireless/realtek/rtw88/rtw88xxa.c | 125 ++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/rtw88xxa.h |   5 +
 6 files changed, 158 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index d59f6e323adf0c9bf9aeab7a62adb77e3e5f9d74..796fea308fdf7bf2b46f42c703b1b518327e1e0a 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -1787,6 +1787,7 @@ struct rtw_dm_info {
 	bool is_bt_iqk_timeout;
 
 	s8 l2h_th_ini;
+	s8 l2h_th_lb;
 	enum rtw_edcca_mode edcca_mode;
 	u8 scan_density;
 };
diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index 69998c0d7c1f851bb30d2702233d62e14b305bf0..7a04aec9a045f1e308a4c5d331c900e013996bd5 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -377,6 +377,10 @@ void rtw_phy_dig_set_max_coverage(struct rtw_dev *rtwdev)
 		DIG_CVRG_MIN);
 
 	rtw_phy_dig_write(rtwdev, DIG_CVRG_MIN);
+
+	/* EDCCA thresholds can be relative to the IGI */
+	if (!rtw_fw_feature_check(&rtwdev->fw, FW_FEATURE_ADAPTIVITY))
+		rtw_phy_adaptivity(rtwdev);
 }
 
 void rtw_phy_dig_reset(struct rtw_dev *rtwdev)
@@ -388,6 +392,9 @@ void rtw_phy_dig_reset(struct rtw_dev *rtwdev)
 	rtw_dbg(rtwdev, RTW_DBG_PHY, "Resetting IGI=%#x\n", last_igi);
 
 	rtw_phy_dig_write(rtwdev, last_igi);
+
+	if (!rtw_fw_feature_check(&rtwdev->fw, FW_FEATURE_ADAPTIVITY))
+		rtw_phy_adaptivity(rtwdev);
 }
 
 static bool
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8812a.c b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
index c8008cf43da9df68a8c1dfb277d529a1191bda01..d93c4776e0303f52273d92eaa75341ebbcfcb066 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8812a.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
@@ -945,6 +945,8 @@ static const struct rtw_chip_ops rtw8812a_ops = {
 	.coex_set_wl_rx_gain	= rtw8821a_coex_cfg_wl_rx_gain,
 	.cfo_init		= rtw_phy_cfo_xcap_init,
 	.cfo_track		= rtw88xxa_cfo_track,
+	.adaptivity_init	= rtw88xxa_adaptivity_init,
+	.adaptivity		= rtw88xxa_adaptivity,
 };
 
 static const struct rtw_page_table page_table_8812a[] = {
@@ -999,6 +1001,11 @@ static const struct rtw_hw_reg rtw8812a_dig[] = {
 	[1] = { .addr = REG_RXIGI_B, .mask = 0x7f },
 };
 
+static const struct rtw_hw_reg_offset rtw8812a_edcca_th[] = {
+	[EDCCA_TH_L2H_IDX] = {{.addr = 0x8a4, .mask = MASKBYTE0}, .offset = 0},
+	[EDCCA_TH_H2L_IDX] = {{.addr = 0x8a4, .mask = MASKBYTE1}, .offset = 0},
+};
+
 static const struct rtw_rfe_def rtw8812a_rfe_defs[] = {
 	[0] = { .phy_pg_tbl	= &rtw8812a_bb_pg_tbl,
 		.txpwr_lmt_tbl	= &rtw8812a_txpwr_lmt_tbl,
@@ -1089,6 +1096,9 @@ const struct rtw_chip_info rtw8812a_hw_spec = {
 	.bfer_su_max_num = 2,
 	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
 	.max_scan_ie_len = IEEE80211_MAX_DATA_LEN,
+	.edcca_th = rtw8812a_edcca_th,
+	.l2h_th_ini_cs = 10,
+	.l2h_th_ini_ad = -17,
 
 	.coex_para_ver = 0, /* no coex code in 8812au driver */
 	.bt_desired_ver = 0,
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821a.c b/drivers/net/wireless/realtek/rtw88/rtw8821a.c
index 17d3677ca463cf633d8c138612deaa676bc02986..f7391f6aa3039c7ba4d88249d968a5f1763ea866 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821a.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821a.c
@@ -891,6 +891,8 @@ static const struct rtw_chip_ops rtw8821a_ops = {
 	.coex_set_wl_rx_gain	= rtw8821a_coex_cfg_wl_rx_gain,
 	.cfo_init		= rtw_phy_cfo_xcap_init,
 	.cfo_track		= rtw88xxa_cfo_track,
+	.adaptivity_init	= rtw88xxa_adaptivity_init,
+	.adaptivity		= rtw88xxa_adaptivity,
 };
 
 static const struct rtw_page_table page_table_8821a[] = {
@@ -944,6 +946,11 @@ static const struct rtw_hw_reg rtw8821a_dig[] = {
 	[0] = { .addr = REG_RXIGI_A, .mask = 0x7f },
 };
 
+static const struct rtw_hw_reg_offset rtw8821a_edcca_th[] = {
+	[EDCCA_TH_L2H_IDX] = {{.addr = 0x8a4, .mask = MASKBYTE0}, .offset = 0},
+	[EDCCA_TH_H2L_IDX] = {{.addr = 0x8a4, .mask = MASKBYTE1}, .offset = 0},
+};
+
 static const struct rtw_rfe_def rtw8821a_rfe_defs[] = {
 	[0] = { .phy_pg_tbl	= &rtw8821a_bb_pg_tbl,
 		.txpwr_lmt_tbl	= &rtw8821a_txpwr_lmt_tbl,
@@ -1193,6 +1200,9 @@ const struct rtw_chip_info rtw8821a_hw_spec = {
 	.bfer_su_max_num = 2,
 	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
 	.max_scan_ie_len = IEEE80211_MAX_DATA_LEN,
+	.edcca_th = rtw8821a_edcca_th,
+	.l2h_th_ini_cs = 10,
+	.l2h_th_ini_ad = -17,
 
 	.coex_para_ver = 20190509, /* glcoex_ver_date_8821a_1ant */
 	.bt_desired_ver = 0x62, /* But for 2 ant it's 0x5c */
diff --git a/drivers/net/wireless/realtek/rtw88/rtw88xxa.c b/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
index 851d198f76f3b10d5ba77c7e07e4be9d7fd54e4b..ee72380757721dab7dc409aabc24b2b825969465 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
@@ -2040,6 +2040,131 @@ void rtw88xxa_cfo_track(struct rtw_dev *rtwdev)
 }
 EXPORT_SYMBOL(rtw88xxa_cfo_track);
 
+#define EDCCA_TH_MAX_88XXA		0x7f
+#define EDCCA_L2H_CAP_88XXA		10
+#define EDCCA_L2H_INI_NORMAL_88XXA	20
+#define EDCCA_DBG_PORT_88XXA		0x209
+#define EDCCA_DC_BACKOFF_88XXA		2
+#define EDCCA_LB_START_88XXA		(EDCCA_L2H_H2L_DIFF - 30)
+#define EDCCA_LB_RETRY_88XXA		(EDCCA_LB_START_88XXA + 18)
+
+static void rtw88xxa_set_rf_mode_rx(struct rtw_dev *rtwdev, u32 data0,
+				    u32 data1)
+{
+	u8 path;
+
+	for (path = RF_PATH_A; path < rtwdev->hal.rf_path_num; path++) {
+		rtw_write_rf(rtwdev, path, RF_LUTWE, BIT(19), 1);
+		rtw_write_rf(rtwdev, path, RF_MODE_TABLE_ADDR, RFREG_MASK,
+			     0x18000);
+		rtw_write_rf(rtwdev, path, RF_MODE_TABLE_DATA0, RFREG_MASK,
+			     data0);
+		rtw_write_rf(rtwdev, path, RF_MODE_TABLE_DATA1, RFREG_MASK,
+			     data1);
+		rtw_write_rf(rtwdev, path, RF_LUTWE, BIT(19), 0);
+	}
+}
+
+static void rtw88xxa_set_lna(struct rtw_dev *rtwdev, bool enable)
+{
+	if (rtwdev->chip->id == RTW_CHIP_TYPE_8812A)
+		rtw88xxa_set_rf_mode_rx(rtwdev, 0x3f7ff,
+					enable ? 0xc26bf : 0xc22bf);
+	else
+		rtw88xxa_set_rf_mode_rx(rtwdev, 0x0002f,
+					enable ? 0xfb0bb : 0xfb09b);
+}
+
+static u8 rtw88xxa_edcca_count(struct rtw_dev *rtwdev)
+{
+	u8 cnt = 0;
+	int i;
+
+	rtw_write32(rtwdev, REG_DBGSEL, 0);
+	for (i = 0; i < 3 &&
+	     rtw_read32(rtwdev, REG_DBGRPT) & BIT_DBG_CCA_BUSY; i++)
+		usleep_range(3000, 3500);
+
+	rtw_write32(rtwdev, REG_DBGSEL, EDCCA_DBG_PORT_88XXA);
+	for (i = 0; i < 20; i++)
+		if (rtw_read32(rtwdev, REG_DBGRPT) & BIT_DBG_EDCCA_BUSY)
+			cnt++;
+
+	return cnt;
+}
+
+static s8 rtw88xxa_edcca_search_floor(struct rtw_dev *rtwdev)
+{
+	s8 l2h = EDCCA_LB_START_88XXA;
+
+	rtw_phy_set_edcca_th(rtwdev, l2h, l2h - EDCCA_L2H_H2L_DIFF);
+	msleep(30);
+
+	while (l2h < EDCCA_L2H_CAP_88XXA && rtw88xxa_edcca_count(rtwdev) > 1) {
+		l2h++;
+		rtw_phy_set_edcca_th(rtwdev, l2h, l2h - EDCCA_L2H_H2L_DIFF);
+	}
+
+	return l2h;
+}
+
+void rtw88xxa_adaptivity_init(struct rtw_dev *rtwdev)
+{
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+	u32 dbgsel = rtw_read32(rtwdev, REG_DBGSEL);
+	s8 l2h;
+
+	rtw_write32_clr(rtwdev, REG_TX_PTCL_CTRL, BIT_DIS_EDCCA);
+
+	rtw88xxa_set_lna(rtwdev, false);
+	l2h = rtw88xxa_edcca_search_floor(rtwdev);
+	if (l2h >= EDCCA_LB_RETRY_88XXA)
+		l2h = rtw88xxa_edcca_search_floor(rtwdev);
+	rtw88xxa_set_lna(rtwdev, true);
+	rtw_write32(rtwdev, REG_DBGSEL, dbgsel);
+
+	dm_info->l2h_th_lb = l2h + EDCCA_DC_BACKOFF_88XXA;
+	rtw_phy_set_edcca_th(rtwdev, EDCCA_TH_MAX_88XXA, EDCCA_TH_MAX_88XXA);
+
+	rtw_dbg(rtwdev, RTW_DBG_ADAPTIVITY, "EDCCA L2H floor %d\n",
+		dm_info->l2h_th_lb);
+}
+EXPORT_SYMBOL(rtw88xxa_adaptivity_init);
+
+void rtw88xxa_adaptivity(struct rtw_dev *rtwdev)
+{
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+	/* igi_history[0] keeps the pre-scan IGI while scanning */
+	u8 igi = rtw_read32_mask(rtwdev, REG_RXIGI_A, 0x7f);
+	int igi_diff = EDCCA_IGI_BASE - igi;
+	s8 l2h_lb = dm_info->l2h_th_lb;
+	s8 l2h, h2l;
+
+	/* toggle the ADC mask to work around an EDCCA hang */
+	if (rtwdev->chip->id == RTW_CHIP_TYPE_8812A) {
+		rtw_write32_set(rtwdev, REG_FPGA0_RFMOD, BIT(10));
+		rtw_write32_clr(rtwdev, REG_FPGA0_RFMOD, BIT(10));
+	}
+
+	if (dm_info->edcca_mode == RTW_EDCCA_ADAPTIVITY) {
+		l2h = min(dm_info->l2h_th_ini + igi_diff, EDCCA_L2H_CAP_88XXA);
+		h2l = l2h - EDCCA_L2H_H2L_DIFF;
+	} else {
+		l2h = EDCCA_L2H_INI_NORMAL_88XXA + igi_diff;
+		h2l = l2h - EDCCA_L2H_H2L_DIFF_NORMAL;
+	}
+
+	l2h = max(l2h, l2h_lb);
+	h2l = max_t(s8, h2l, l2h_lb - EDCCA_L2H_H2L_DIFF);
+
+	rtw_phy_set_edcca_th(rtwdev, l2h, h2l);
+
+	rtw_dbg(rtwdev, RTW_DBG_ADAPTIVITY,
+		"EDCCA mode %d, IGI 0x%x, L2H %d, H2L %d\n",
+		dm_info->edcca_mode, igi, l2h, h2l);
+}
+EXPORT_SYMBOL(rtw88xxa_adaptivity);
+
 MODULE_AUTHOR("Realtek Corporation");
 MODULE_DESCRIPTION("Realtek 802.11ac wireless 8821a/8811a/8812a common code");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/realtek/rtw88/rtw88xxa.h b/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
index 09b72d33f62e1e99a2ac5af23ac1630dabb38ef9..b8719c278df7326842e09509fc52d12f226fd417 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
@@ -139,6 +139,9 @@ struct rtw_jaguar_phy_status_rpt {
 
 #define RF18_BW_MASK		(BIT(11) | BIT(10))
 
+#define BIT_DBG_CCA_BUSY	BIT(3)
+#define BIT_DBG_EDCCA_BUSY	BIT(29)
+
 void rtw88xxa_efuse_grant(struct rtw_dev *rtwdev, bool on);
 int rtw88xxa_read_efuse(struct rtw_dev *rtwdev, u8 *log_map);
 void rtw88xxa_power_off(struct rtw_dev *rtwdev,
@@ -173,5 +176,7 @@ void rtw88xxa_phy_pwrtrack(struct rtw_dev *rtwdev,
 void rtw88xxa_bf_config_bfee(struct rtw_dev *rtwdev, struct rtw_vif *vif,
 			     struct rtw_bfee *bfee, bool enable);
 void rtw88xxa_cfo_track(struct rtw_dev *rtwdev);
+void rtw88xxa_adaptivity_init(struct rtw_dev *rtwdev);
+void rtw88xxa_adaptivity(struct rtw_dev *rtwdev);
 
 #endif
-- 
2.55.0

