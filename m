Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793253175;
	b=OcpI7OmUtTJoV30Txf8YvSYCvsq3jnauI65YvzppYHxh9H13X7P1QExZ95BoD4pwfmvT
	 y3g3UVmcEMfeeZO2dwl6YmstcwBB9x1z23wFJ9uhudMS+fX/j/9UA3HDDfR3df4coAav6
	 TaVBzqJI/Ya7aD8AMD34zN8TLzbGYddZ5NAGjqQjuAqaB7lleJnbtd2z3EUjQe5/3iDD4
	 oarVylvFa1CRSXwjxoSKZ/tzogS+MZmUSvtEhhpoENv8piOyrlsDNkLghvoazeTXcKene
	 eVeGfUyJ4l5vYonKpR6Fv7LzaHiskbGIqIE7OnQf5eJ+1zB6VcBsKl2Y6BBqIScQt1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793253175;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=V23s9bCyVcCdH8M7D8Dk9ZF6eDdzvnUS/pC1voQNDK8=;
	b=4MuetCGlzthROG4KvucrBr4Xr/+tSqSCucURsDkhGqPnGTFzR+2jEC0JGISwX6OWhVAP
	 8YHw+5/XhAH5gCLzP+X6wL+eJz06KZfODIEhu0+dO5HViTFaM7v0K0pfFwJyIDhbaxr8f
	 u64Ld8/DXT8sALlmi09l2IWn6V1r6QAjjnEKUFG71RMDT9/RnxbMN+2qM4YMRYyY6iekc
	 L6WRN7haozSS0Hp9wMHjOHlc+YRp15ceN6+7FwBdlSnXvnLbj1ytCqfHeAwKmVU9LzkXZ
	 ZHh1fm5s/ylp5AbjeKRu28UKzR2p3WY01mi9/GXcQCrvyQRSj2Onp5KzoJUOTVgzQMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yIPzbEjh;
	arc=none smtp.remote-ip=209.85.215.179
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E53A60A2603
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 05:52:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E53A60A2603
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yIPzbEjh
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cd5c9e52398so954976a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 22:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793253175; x=1793857975; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V23s9bCyVcCdH8M7D8Dk9ZF6eDdzvnUS/pC1voQNDK8=;
        b=yIPzbEjh60KP8ft6HvyRgZfuypQd6pDrNjRYVrE35DRMpXFZYw2RmL9+lCOMyooBcd
         TjotDTSBEPS3nVoaXJhbFqEYKUvH8KQ737yhILPCc0pALxSDuAK0rYcPgS6c96uSqS13
         DEH7WRGUKmrWO/vEZJ28VUT106vukGCmjf0R6vuBFztRUed2zFEC8TjzpgOeMzpjwYw+
         hgdLV3jyNZvsVcdyvIzubVO2w75a1wDqgAw7iTSFlWQyaz5lZqXHXiTMbNyAtkiCXCuY
         uytJGUX5DuMqNlMq+kjzctUbJPhrDnJPbQSqasOH9Rhvpb+zoqdLjydwdETUI1eAecl2
         1tzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793253175; x=1793857975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=V23s9bCyVcCdH8M7D8Dk9ZF6eDdzvnUS/pC1voQNDK8=;
        b=nMOprlVRGZgBC0aCFe1hMurJCDCpzuCoQE0mS86hbQErLpsPw+FCUAjlbK6nDlxJm2
         PB8WYklcrncGxrJXkt2lIIi3wDQrUyUEYFsO890taRxTjrxi4VeE1QvcVhAr5CABJtJj
         QoTD6lgT2u0LxquxaXH6Blj11qf8D7VnNnUiUtjNUz4F4pToLmYD2Z1jq1F4wcqgAhyN
         n1O31Z5B0T9DxzSc09X66muBWDNiYokKWJS0IWOQnoEyOOYfLjV9o8ND1hb1fNXbyPM3
         MdHaglfIMlOfCqymZZWxmaBgN28NuMvCuBHLQ9ebXC4Vx6DlbqjVPg09u5HYZ8wwSe05
         iSnw==
X-Gm-Message-State: AFq9FYLbP+GJv7Pxu49yB4GHmrkmggusjaWPZq/ykXNWB9RGauS71iBF
	XA+iPxaAa3xobbHAxOq52nXPxlp/UwiDmZob1GyFMj/Mmtf/dvGtEKuXM2NXrYZd
X-Gm-Gg: AYBFou0E2WVB1lKs1xl88HYbWltSy9K2BVDcwazTewT6B7tx/S15Q8ZBiiMsGAD769s
	YSutUlYbXvXqn8SK/mbcKQV1f8muJymQcNhC3N9eVHyOtZx0NyNxCoo7ghlmIc1TgSQK23Ml77h
	k+If8M/ZZApxzkiTvKpK74gTkei3po7zHuzdmxdpuWQVtfX/NzOW/QlyYw6s32yPx1x5lpB1l+s
	cPNIubl/Wd+ou8uS9nAqrfTr450nGo1R1nRRUWnnQ/G/pS03VpUszTwJTgMJ+qh2vw6SOZ617/6
	Mo0/1Uq254p+xPwQ4965GrLtUcu793jCLE94zUi+Hwqk0+YCbp+6HUqRJL7sbsSiXzsROWZO44U
	xDLoh1X0PFSzob4+nCjrO1Uyn2oN+RnfXKk5x9bHo6RIbS04Q18l+AylkDn+THMMNT3sWmm+P6I
	dU7JqYtpt41lcHi9zPc9Z7Z7+D5qKStveMHMgNWGLyPFsDfJPDuVHec45J+njCU1cgVZxcA1esk
	rgluAifEy66oKwb3ZQlzULOFLInASdHxwlgc2COL0DgT9kEg6bdyQluae524f2Q0fJfeHMZN0R0
	f3SKopjyakqjIs/x5nJmFA+wZ365F0PSUPbhlLniy9akoVu2EreDhkMtOxJvtCAnHetnhGchdeY
	cH9bgmM8Sxh32Z6ekltj1r9PCyA==
X-Received: by 2002:a17:90a:ec8d:b0:3ac:9f00:3bc8 with SMTP id 98e67ed59e1d1-3ae581d3d6bmr3496760a91.36.1793253174425;
        Wed, 28 Oct 2026 22:52:54 -0700 (PDT)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3ae6e2a703esm2523531a91.0.2026.10.28.22.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 22:52:54 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] wifi: rtw88: 88xxa: adapt channel sensing to receiver gain
Date: Thu, 29 Oct 2026 13:52:07 +0800
Message-ID: <20261029055212.84711-6-hjf3108@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261029055212.84711-1-hjf3108@gmail.com>
References: <20261029055212.84711-1-hjf3108@gmail.com>
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
 drivers/net/wireless/realtek/rtw88/rtw8812a.c |  10 ++
 drivers/net/wireless/realtek/rtw88/rtw8821a.c |  10 ++
 drivers/net/wireless/realtek/rtw88/rtw88xxa.c | 123 ++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/rtw88xxa.h |   5 +
 5 files changed, 149 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index d59f6e323adf0..796fea308fdf7 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -1787,6 +1787,7 @@ struct rtw_dm_info {
 	bool is_bt_iqk_timeout;
 
 	s8 l2h_th_ini;
+	s8 l2h_th_lb;
 	enum rtw_edcca_mode edcca_mode;
 	u8 scan_density;
 };
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8812a.c b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
index c8008cf43da9d..d93c4776e0303 100644
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
index 17d3677ca463c..f7391f6aa3039 100644
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
index 586bb57a10061..aff62d61f4719 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
@@ -2040,6 +2040,129 @@ void rtw88xxa_cfo_track(struct rtw_dev *rtwdev)
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
+	int igi_diff = EDCCA_IGI_BASE - dm_info->igi_history[0];
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
+		dm_info->edcca_mode, dm_info->igi_history[0], l2h, h2l);
+}
+EXPORT_SYMBOL(rtw88xxa_adaptivity);
+
 MODULE_AUTHOR("Realtek Corporation");
 MODULE_DESCRIPTION("Realtek 802.11ac wireless 8821a/8811a/8812a common code");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/realtek/rtw88/rtw88xxa.h b/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
index 09b72d33f62e1..b8719c278df73 100644
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

