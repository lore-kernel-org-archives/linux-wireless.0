Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793253172;
	b=fLOnurJ53ulFYL/X6j0PXkbv7TIWSJ74ct7K8fmU5oO85cQ7tP+mteyPSmHtoS0rq8DM
	 77SkDnOpQlTbv6jv/xMa9Q1/dKZHdaQ5TlJoj77S8jPLPQZirWlOYYZobXXYodO1NbvME
	 SOpH1/mHcbpw2b42dwclcG8EWYpG4h03gkPlFMXzBov0PqTJ3Moc7WdV1fVxiXheV20BA
	 yypoGcQPFQEwFWGB9jlnX6EJZqP3Xt/GAJa1d8SGBuvM8xoGUSLhT7eyiqIhUneaOgrpZ
	 BMG8/p67CdYVtTlQwPyxMhTx/nOqFx7FxHs8W6PH18XB3Kkt5aS2YcS83zqbifL5HxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793253172;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wqnw2SVFICJmyB2CE6aJCeG34DwAkjqaL2ooV287fPo=;
	b=NqmY2Sda6VyFQO41O6Hu69dzPIi4XFQHFmQYKPXCiVZYxXQk1+L2rEuu18rDnuluokL0
	 fnHcg6OCU36jOO1oKx0sZa7/a0j5zDKQCHGfnfE4iQOUZhWWC1PDJz74e0nNfqxuuME+l
	 Cu/mI3knw1kCXeBVbSilLSk/jPwGDSAo0Ex6sMoByX4f3eVz5G5oJnHV4k+WGx5XokL6N
	 DYuBoIQU+VKMc0vVAx1IWQd2VP9CxXun8H9pTfeERSUFvCVRuK59gwSd6AaDdfQ/5q9pH
	 N6eY05tu6TsryCxuKRv/gjNb0Kx7Ls/cuMllQnnxeSryCjAg9x1EDFKPd8tnPzwbMQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DACRyT9m;
	arc=none smtp.remote-ip=209.85.215.171
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D099606A321
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 05:52:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D099606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DACRyT9m
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-ccca948203aso751540a12.3
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 22:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793253171; x=1793857971; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wqnw2SVFICJmyB2CE6aJCeG34DwAkjqaL2ooV287fPo=;
        b=DACRyT9mI9NZXe4q91GANwaV50un6tB5ky/XHmVYUi458RYcv+MOcCqjLdmKW6aYq7
         gXC+T2wbtsH81I6GigF0upVP5g87HX1JWYkrJUULe2L0JbZyErRUnSQcvGJrWI/iwmv+
         0z+OcZ/ULYRohmo6/gRhcxPQA0fKWmzg96OWNlXLAGSlxXMF2l51N1QlBXYYLxSulZtt
         WlcKmONb9KH/HFD0jEVLmRujibsNfg8VRDXiziALBNabmE0GWNd9qecjQAm1AHtMiyMe
         8cvcdwf5gOwXZ+M/6F6iX7f3t2apWWTPyG8va4k+AuhhSE3yEru+is5/yuc1+qCC1OGp
         zC5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793253171; x=1793857971;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wqnw2SVFICJmyB2CE6aJCeG34DwAkjqaL2ooV287fPo=;
        b=ac+XipO65rJfT9EWxsghPd50oxm2G65xuA2fQzKVOVFwzkkUqE7gDhTnr37vmf4/gt
         6Fe13CnPIfiq5WdqEJZ7w92QAbFMNm/BnNL+4IRh/mZxvryH8W3DX3nQ54/8YCbbff3+
         Z+6bjt0jftwFjccSs0aQWwf24yqdPYZtTtPc1/gUrd+xoFQ4exhVO771HGcFqbjmrG9D
         evcRIHm3ARW6v3vuMbWs0fcf75BA+gYovuimP59VQqtUKCrCP/X8ool48Il2C1Nto1Ek
         RC6f/iZOR10UstFs6WyaAfDmbGWJbburMFssrP47xyUNafK+R4sRg2zNhjs483tF5ZeY
         pTbA==
X-Gm-Message-State: AFq9FYJuy0zDl2EpRI8dza/KJW/mZh1y/q9jvhKTXdMrXxLR6nl/JfYq
	awCXkPmhBzj6OH5J2cGD26SE2Z9RTTHZDUE9yFuPG4Si9kiw9koFM62nMJnAoWDB
X-Gm-Gg: AYBFou0zsCNWXXNBmKYsgzi4r4UxeBT9pPp0Dvna8/mVN+SVjJFvOEGasaAeVWOSn83
	pHFREnbRwP64Qg1zauAHEn6zqbYv5dpX5mzJPShuFo4zY6/XJ/8EAPgxU6kk9esDnEDrxHKBM/i
	PhFblkjGjxACEPLeHL57EKwKK5GobwJFEICfEFhiP0nVDQBTZSxOghG280EmJVUz5hf1QL4kr7p
	765/Rw8EkQkH2c+Qh6Efn0oTovNAVvny1ZIlZBz3rlHymf+f2vQd4M8VFRariu21rRmGERBecyH
	fgcSfT1Bl8RPSXM6pll0m5az7Kd77AQyp1OUb82G63TDjHHfJjy83lgqLjUC91leXATYBaRajmo
	57ccVV+UE22WtcXC6Pg2n85YJ5wc31a/6jIed5QkvscTTwUkx8DD/4DCSoIGo3gQMOZIX1Z97MN
	3HW/od0cbYKI11CD+DOhjEIaEIC/QmeUtYXoeE6j3W5TN/8cYYHFDoE3X/B4P6STz7Ay+yTsFI9
	j0+EDb61pDzSgSldl8miJ7xl6+oJZOMSobSlErB/GHKASHnGLKIF8nOUluo7MIA9GcPSfJWIO1/
	wRAq68/tY8lKR7IqeXbmjs0T4l4jHDwbaNLpx4n3oU7JNVUf3w9gupuFClrpSPYCXvWe+A+JoG9
	lbBlF+g==
X-Received: by 2002:a17:90b:35cb:b0:3ac:8897:7b9f with SMTP id 98e67ed59e1d1-3ae5817ae3fmr3202592a91.43.1793253171072;
        Wed, 28 Oct 2026 22:52:51 -0700 (PDT)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3ae6e2a703esm2523531a91.0.2026.10.28.22.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 22:52:50 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] wifi: rtw88: 88xxa: correct carrier-frequency offset
Date: Thu, 29 Oct 2026 13:52:06 +0800
Message-ID: <20261029055212.84711-5-hjf3108@gmail.com>
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

Use the newly promoted helpers to implement support for 88xxa

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/phy.c      |  5 +-
 drivers/net/wireless/realtek/rtw88/rtw8812a.c |  2 +
 drivers/net/wireless/realtek/rtw88/rtw8814a.c | 31 ++++++++++--
 drivers/net/wireless/realtek/rtw88/rtw8821a.c |  2 +
 drivers/net/wireless/realtek/rtw88/rtw88xxa.c | 47 +++++++++++++++----
 drivers/net/wireless/realtek/rtw88/rtw88xxa.h |  1 +
 6 files changed, 73 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index d0c1fb65be956..69998c0d7c1f8 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -687,13 +687,14 @@ static void rtw_phy_parsing_cfo_iter(void *data, u8 *mac,
 	struct rtw_rx_pkt_stat *pkt_stat = iter_data->pkt_stat;
 	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
 	struct rtw_cfo_track *cfo = &dm_info->cfo_track;
+	u8 path_num = min_t(u8, rtwdev->hal.rf_path_num, 2);
 	u8 *bssid = iter_data->bssid;
 	u8 i;
 
 	if (!ether_addr_equal(vif->bss_conf.bssid, bssid))
 		return;
 
-	for (i = 0; i < rtwdev->hal.rf_path_num; i++) {
+	for (i = 0; i < path_num; i++) {
 		cfo->cfo_tail[i] += pkt_stat->cfo_tail[i];
 		cfo->cfo_cnt[i]++;
 	}
@@ -794,7 +795,7 @@ u8 rtw_phy_cfo_xcap_track(struct rtw_dev *rtwdev, u8 xcap_max, bool bt_hold)
 {
 	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
 	struct rtw_cfo_track *cfo = &dm_info->cfo_track;
-	u8 path_num = rtwdev->hal.rf_path_num;
+	u8 path_num = min_t(u8, rtwdev->hal.rf_path_num, 2);
 	s8 crystal_cap = cfo->crystal_cap;
 	s32 cfo_avg = 0;
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8812a.c b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
index 5d58dff4fcee7..c8008cf43da9d 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8812a.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
@@ -943,6 +943,8 @@ static const struct rtw_chip_ops rtw8812a_ops = {
 	.coex_set_rfe_type	= rtw8821a_coex_cfg_rfe_type,
 	.coex_set_wl_tx_power	= rtw8821a_coex_cfg_wl_tx_power,
 	.coex_set_wl_rx_gain	= rtw8821a_coex_cfg_wl_rx_gain,
+	.cfo_init		= rtw_phy_cfo_xcap_init,
+	.cfo_track		= rtw88xxa_cfo_track,
 };
 
 static const struct rtw_page_table page_table_8812a[] = {
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8814a.c b/drivers/net/wireless/realtek/rtw88/rtw8814a.c
index 2db05a83766d6..3c65cd838ce15 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8814a.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8814a.c
@@ -145,7 +145,7 @@ static int rtw8814a_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 	efuse->usb_mode_switch = u8_get_bits(map->usb_mode, BIT(4));
 	efuse->rfe_option = map->rfe_option;
 	efuse->rf_board_option = map->rf_board_option;
-	efuse->crystal_cap = map->xtal_k;
+	efuse->crystal_cap = map->xtal_k & 0x3f;
 	efuse->channel_plan = map->channel_plan;
 	efuse->country_code[0] = map->country_code[0];
 	efuse->country_code[1] = map->country_code[1];
@@ -284,9 +284,15 @@ static void rtw8814a_config_cck_rx_antenna_init(struct rtw_dev *rtwdev)
 	rtw_write32_mask(rtwdev, REG_CCKTX, BIT_CMB_CCA_2R, 1);
 }
 
+static void rtw8814a_set_crystal_cap(struct rtw_dev *rtwdev, u8 crystal_cap)
+{
+	rtw_write32_mask(rtwdev, REG_AFE_CTRL3, 0x07ff8000,
+			 crystal_cap | (crystal_cap << 6));
+}
+
 static void rtw8814a_phy_set_param(struct rtw_dev *rtwdev)
 {
-	u32 crystal_cap, val32;
+	u32 val32;
 	u8 val8, rf_path;
 
 	/* power on BB/RF domain */
@@ -308,9 +314,7 @@ static void rtw8814a_phy_set_param(struct rtw_dev *rtwdev)
 	rtw_load_table(rtwdev, rtwdev->chip->bb_tbl);
 	rtw_load_table(rtwdev, rtwdev->chip->agc_tbl);
 
-	crystal_cap = rtwdev->efuse.crystal_cap & 0x3F;
-	crystal_cap |= crystal_cap << 6;
-	rtw_write32_mask(rtwdev, REG_AFE_CTRL3, 0x07ff8000, crystal_cap);
+	rtw8814a_set_crystal_cap(rtwdev, rtwdev->efuse.crystal_cap);
 
 	rtw8814a_config_trx_path(rtwdev);
 
@@ -1269,6 +1273,8 @@ static void rtw8814a_query_phy_status(struct rtw_dev *rtwdev, u8 *phy_status,
 			pkt_stat->cfo_tail[i] = cfo[i];
 			dm_info->cfo_tail[i] = (cfo[i] * 5) >> 1;
 		}
+
+		rtw_phy_parsing_cfo(rtwdev, pkt_stat);
 	}
 }
 
@@ -2068,6 +2074,19 @@ static void rtw8814a_bf_config_bfee(struct rtw_dev *rtwdev,
 		rtw_bf_remove_bfee_su(rtwdev, bfee);
 }
 
+static void rtw8814a_cfo_track(struct rtw_dev *rtwdev)
+{
+	struct rtw_cfo_track *cfo = &rtwdev->dm_info.cfo_track;
+	u8 crystal_cap;
+
+	crystal_cap = rtw_phy_cfo_xcap_track(rtwdev, 0x3f, false);
+	if (crystal_cap == cfo->crystal_cap)
+		return;
+
+	cfo->crystal_cap = crystal_cap;
+	rtw8814a_set_crystal_cap(rtwdev, crystal_cap);
+}
+
 static void rtw8814a_fill_txdesc_checksum(struct rtw_dev *rtwdev,
 					  struct rtw_tx_pkt_info *pkt_info,
 					  u8 *txdesc)
@@ -2102,6 +2121,8 @@ static const struct rtw_chip_ops rtw8814a_ops = {
 	.cfg_csi_rate		= NULL,
 	.led_set		= rtw8814a_led_set,
 	.fill_txdesc_checksum	= rtw8814a_fill_txdesc_checksum,
+	.cfo_init		= rtw_phy_cfo_xcap_init,
+	.cfo_track		= rtw8814a_cfo_track,
 
 	.coex_set_init		= rtw8814a_coex_cfg_init,
 	.coex_set_ant_switch	= rtw8814a_coex_cfg_ant_switch,
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821a.c b/drivers/net/wireless/realtek/rtw88/rtw8821a.c
index 6d106ae70d914..17d3677ca463c 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821a.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821a.c
@@ -889,6 +889,8 @@ static const struct rtw_chip_ops rtw8821a_ops = {
 	.coex_set_rfe_type	= rtw8821a_coex_cfg_rfe_type,
 	.coex_set_wl_tx_power	= rtw8821a_coex_cfg_wl_tx_power,
 	.coex_set_wl_rx_gain	= rtw8821a_coex_cfg_wl_rx_gain,
+	.cfo_init		= rtw_phy_cfo_xcap_init,
+	.cfo_track		= rtw88xxa_cfo_track,
 };
 
 static const struct rtw_page_table page_table_8821a[] = {
diff --git a/drivers/net/wireless/realtek/rtw88/rtw88xxa.c b/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
index d3dd0ebfb4024..586bb57a10061 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
@@ -279,6 +279,7 @@ int rtw88xxa_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 	efuse->crystal_cap = map->xtal_k;
 	if (efuse->crystal_cap == 0xff)
 		efuse->crystal_cap = 0x20;
+	efuse->crystal_cap &= 0x3F;
 	efuse->pa_type_2g = map->pa_type;
 	efuse->pa_type_5g = map->pa_type;
 	efuse->lna_type_2g = map->lna_type_2g;
@@ -632,9 +633,19 @@ static void rtw88xxa_init_beacon_parameters(struct rtw_dev *rtwdev)
 	rtw_write16(rtwdev, REG_BCNTCFG, 0x4413);
 }
 
+static void rtw88xxa_set_crystal_cap(struct rtw_dev *rtwdev, u8 crystal_cap)
+{
+	if (rtwdev->chip->id == RTW_CHIP_TYPE_8812A)
+		rtw_write32_mask(rtwdev, REG_AFE_CTRL3, 0x7FF80000,
+				 crystal_cap | (crystal_cap << 6));
+	else
+		rtw_write32_mask(rtwdev, REG_AFE_CTRL3, 0x00FFF000,
+				 crystal_cap | (crystal_cap << 6));
+}
+
 static void rtw88xxa_phy_bb_config(struct rtw_dev *rtwdev)
 {
-	u8 val8, crystal_cap;
+	u8 val8;
 
 	/* power on BB/RF domain */
 	val8 = rtw_read8(rtwdev, REG_SYS_FUNC_EN);
@@ -653,13 +664,7 @@ static void rtw88xxa_phy_bb_config(struct rtw_dev *rtwdev)
 	rtw_load_table(rtwdev, rtwdev->chip->bb_tbl);
 	rtw_load_table(rtwdev, rtwdev->chip->agc_tbl);
 
-	crystal_cap = rtwdev->efuse.crystal_cap & 0x3F;
-	if (rtwdev->chip->id == RTW_CHIP_TYPE_8812A)
-		rtw_write32_mask(rtwdev, REG_AFE_CTRL3, 0x7FF80000,
-				 crystal_cap | (crystal_cap << 6));
-	else
-		rtw_write32_mask(rtwdev, REG_AFE_CTRL3, 0x00FFF000,
-				 crystal_cap | (crystal_cap << 6));
+	rtw88xxa_set_crystal_cap(rtwdev, rtwdev->efuse.crystal_cap & 0x3F);
 }
 
 static void rtw88xxa_phy_rf_config(struct rtw_dev *rtwdev)
@@ -1621,6 +1626,17 @@ void rtw88xxa_query_phy_status(struct rtw_dev *rtwdev, u8 *phy_status,
 			power_b = power_a;
 
 		pkt_stat->signal_power = max3(power_a, power_b, min_rx_power);
+
+		pkt_stat->cfo_tail[RF_PATH_A] =
+			(s8)le32_get_bits(rpt->w2, RTW_JGRPHY_W2_CFO_TAIL_A);
+		pkt_stat->cfo_tail[RF_PATH_B] =
+			(s8)le32_get_bits(rpt->w2, RTW_JGRPHY_W2_CFO_TAIL_B);
+
+		/* convert to kHz (used only for debugfs) */
+		for (i = RF_PATH_A; i < rtwdev->hal.rf_path_num; i++)
+			dm_info->cfo_tail[i] = (pkt_stat->cfo_tail[i] * 5) >> 1;
+
+		rtw_phy_parsing_cfo(rtwdev, pkt_stat);
 	}
 }
 EXPORT_SYMBOL(rtw88xxa_query_phy_status);
@@ -2009,6 +2025,21 @@ void rtw88xxa_phy_pwrtrack(struct rtw_dev *rtwdev,
 }
 EXPORT_SYMBOL(rtw88xxa_phy_pwrtrack);
 
+void rtw88xxa_cfo_track(struct rtw_dev *rtwdev)
+{
+	struct rtw_cfo_track *cfo = &rtwdev->dm_info.cfo_track;
+	bool bt_hold = rtwdev->efuse.btcoex && !rtw_coex_disabled(rtwdev);
+	u8 crystal_cap;
+
+	crystal_cap = rtw_phy_cfo_xcap_track(rtwdev, 0x3F, bt_hold);
+	if (crystal_cap == cfo->crystal_cap)
+		return;
+
+	cfo->crystal_cap = crystal_cap;
+	rtw88xxa_set_crystal_cap(rtwdev, crystal_cap);
+}
+EXPORT_SYMBOL(rtw88xxa_cfo_track);
+
 MODULE_AUTHOR("Realtek Corporation");
 MODULE_DESCRIPTION("Realtek 802.11ac wireless 8821a/8811a/8812a common code");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/realtek/rtw88/rtw88xxa.h b/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
index 0aaf7aa4aafdd..09b72d33f62e1 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
@@ -172,5 +172,6 @@ void rtw88xxa_phy_pwrtrack(struct rtw_dev *rtwdev,
 			   void (*do_iqk)(struct rtw_dev *rtwdev));
 void rtw88xxa_bf_config_bfee(struct rtw_dev *rtwdev, struct rtw_vif *vif,
 			     struct rtw_bfee *bfee, bool enable);
+void rtw88xxa_cfo_track(struct rtw_dev *rtwdev);
 
 #endif
-- 
2.55.0

