Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793430623;
	b=b/hjJo45S3DwO9qK+s6jnjQtlgo0B97GAbpoS7WeN547OYHlrfAXRSih9FZm6KVorT1x
	 mqIwcFNQmG7WJGlzekVS7z2LOi57vADPh+XCgZcT+xWska+EOGJtxQV2If4mKUbUnQd+Z
	 A7OETg9Wk5yYS9rCP71AuKMGSm9IcSmNN/hAZ4ugRYbenWexLKqsmV9hpQLpXybHt6Hsy
	 pCQL+bSJeiCBzv6ZZNmWDe/ou7H4naVurVKlGp72NLVojA+6p1ot+lvIybqPETyOmKgBM
	 rg0hsSFyjnv5BZlY6xeyiELpkIhiesTQOb6PAwAJghLk97JYTkY+d06jpepDPAG0rKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793430623;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Gwhi7r1l69ILdE3mOeo4t5v+4g6xaUOMbADBTNVfQsc=;
	b=SNeaMF4MowXb6R2PBl+y5wrwiBHoLzU6OqmS8wpgk5aU+/SJFWH2lvDzPEFlhWA7tElZ
	 wMt12lxabTtzkoKahEqGDkQR0wvK0Gi/49Di1q2ndvUwqLj8RWLWDFVLjD+g5LbS/zFvc
	 rjK9u0GCOLWFGqge8qHxUeAXhGplx51QoDqzXZHLm/5a1LQzXKqW5frxjhvqZzLNwjQjd
	 hYEimZUEs4QGzvY2te+db/Nhk/tLEfknTI6uDaL8yInIGzNUrzIXw2lFj4sm8avBPhQM7
	 KKGPgf2ZvYsxif+GdWfwYSbFoZ7OmuVLcqEpif6hZsLUbL9Xk81wt9lwqXZdFoYVc/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ROG0X5SV;
	arc=none smtp.remote-ip=209.85.216.41
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6446A606A31C
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 07:10:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6446A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ROG0X5SV
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ab98332238so843778a91.3
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 00:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793430623; x=1794035423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gwhi7r1l69ILdE3mOeo4t5v+4g6xaUOMbADBTNVfQsc=;
        b=ROG0X5SV9iavdhHremQBwJa1lCARajvp/nyFrxWB+G20h7pmmDT3FlyajhJyaFk1Ox
         /knDOu2XCQeG+VgtiDNvSr8NB4M8FUrVdq1sK6YRl56qhZnbucJ8LHV0rRuQYKZBO8Ji
         jnWCpBTsw04E2gTvMnsrAVCPSfY4DvG+OmqINzCSXv5B5vrlunPbRVKzKIFY3AG0QSGW
         2JNO6IaIrkb409ga9bTqqcrg4usbnREjZZrWtWiTwTP9ypZsg7Ec1hOjotW78JAACOqO
         5sPCWH6d+DqXRE7dUj720VnT3apUqT2Orn5bkrtowgg2fKkWYxC3nL6mGmzouDg7ZuKw
         /V3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793430623; x=1794035423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gwhi7r1l69ILdE3mOeo4t5v+4g6xaUOMbADBTNVfQsc=;
        b=FSmbwCQ9EEUbJjcHr//s9jBCqmLaZnKeYkBdKDD2UtEMNM7+9rGm4/lglzBwheasHh
         nGdav65cnR48o+WivqZalo2en1ShwTxNSnAQyki+JBYAYwbZ0qW1fTPWt9NeII2NrnYl
         JrnwrT/Ex65os5TzHTFGKk7m3vmcspmjSESwyh0zjZ1myoDJcJyaayYW4VE+aaKfZyC9
         v+EfPMCyBvNodrEJmkXZufzc58WDqIAKdsj2MlJvLN7+rFhgWdMeBDZBwIyc9ntIniIP
         v3y0i0++V/k1l+w3dU0xaYCrI1Zs1JMeOa4E2AuP2YKEkBOQxKc+xOIbzGn2aoyvcnpe
         54Bg==
X-Gm-Message-State: AFq9FYJSaG1rgMpz8z9VwBxEFn755T87ZlIorcdRO11ugmnrI8YZ2AwK
	nPLovHMi600gMEvkvF3BHizEnOi/jY2qpx+HSLhqvpXdDbQ7mYSodRoa
X-Gm-Gg: AYBFou23y2XcU1b0huKWn3Eg67QTRjyzdAd+mG6Ew3fphkAu4n6fxAjO8z2tsEX2BzA
	bf1Nq5/naA9d6UqiWgXcYxmT/P1AfWrouUWlT4aWPNWF6XzXIIqVA05SMSOTjU3DWy9wfCl+KIZ
	P8+4ZXwSO8IHpYBstOecTJ7BZeUxofmGwQpW9rVzE2onJ4UiBiKZAdxB7W/7J5L8cpKHFcIcE32
	KQUvwFcO5ceM3As58K1U+hHbHpdv36rd5pZOhL6ykLM5ukuSi9WMMh4zr9VAOos1aYTAa3LQ8xF
	mfyxD/J3FkpVrJjzF4g6L5CLzn6o3kgobFcUis8LM7wd86oPNk2D2+q+TAxakuu/zlSYX6YPtii
	RBN5COZ4xEopLCn6fh9Fpt5D+tlvVwawqoXHMoLrKKzKJP0WUpYYLULBk0dbFeWT3W64IhsY01e
	VSaKVxvkqUzFT9g4ClNbVbH716ZWJoGsied5j32W5iuS1//h1RFATYyn43rkxCrAAhx/YE3FloZ
	bg7xJ4UHzU2CbnNcamEPIH5wHOl0Rv7qz/ccz2XzLNNW33ZrJLn8TR77hUZadHbE7JqlTsUKnoq
	ZRLISyToKCwYRjLmSY+cG2fh0OrkU+OHlP5xkeC7p1n8LgeeOm3+hkGM/zZpKIZUZeG+QyC6Rz8
	uGM1+5gWuIKmLRnPcPqJOKHZRWA==
X-Received: by 2002:a17:90b:5863:b0:3ac:9ed8:f30d with SMTP id 98e67ed59e1d1-3ae89764095mr3805756a91.39.1793430622539;
        Sat, 31 Oct 2026 00:10:22 -0700 (PDT)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3ae845432e4sm6670459a91.3.2026.10.31.00.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 00:10:22 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH rtw-next v2 2/7] wifi: rtw88: 88xxa: receive VHT SU beamformed transmissions
Date: Sat, 31 Oct 2026 15:09:42 +0800
Message-ID: <20261031070950.425176-3-hjf3108@gmail.com>
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

Implement beamformee support for 88xxa since they have
support for it.

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/bf.h       |  2 +
 drivers/net/wireless/realtek/rtw88/reg.h      |  1 +
 drivers/net/wireless/realtek/rtw88/rtw8812a.c |  3 +-
 drivers/net/wireless/realtek/rtw88/rtw8814a.c | 36 ++++++++++-
 drivers/net/wireless/realtek/rtw88/rtw8821a.c |  3 +-
 drivers/net/wireless/realtek/rtw88/rtw88xxa.c | 62 +++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/rtw88xxa.h |  2 +
 7 files changed, 104 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/bf.h b/drivers/net/wireless/realtek/rtw88/bf.h
index a5d3010e6be6ef776b1c604207f68d6331721feb..0aa78fb6a7e64435e4d5fc18f3e9c70a01d73135 100644
--- a/drivers/net/wireless/realtek/rtw88/bf.h
+++ b/drivers/net/wireless/realtek/rtw88/bf.h
@@ -12,6 +12,8 @@
 #define REG_ASSOCIATED_BFMER0_INFO	0x06E4
 #define REG_ASSOCIATED_BFMER1_INFO	0x06EC
 #define REG_TX_CSI_RPT_PARAM_BW20	0x06F4
+#define REG_TX_CSI_RPT_PARAM_BW40	0x06F8
+#define REG_TX_CSI_RPT_PARAM_BW80	0x06FC
 #define REG_SND_PTCL_CTRL		0x0718
 #define BIT_DIS_CHK_VHTSIGB_CRC		BIT(6)
 #define BIT_DIS_CHK_VHTSIGA_CRC		BIT(5)
diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index afcdb66fdb9a11a44bf52c790aea2cc69aeb851c..f8ec1e2931f63a06a72626bf3168256728ed933b 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -671,6 +671,7 @@
 #define REG_IQK_COM96		0x0984
 
 #define REG_FAS			0x09a4
+#define REG_CSI_CONTENT_VALUE	0x09b4
 #define REG_RXSB		0x0a00
 #define BIT_RXSB_ANA_DIV	BIT(15)
 #define REG_CCK_RX		0x0a04
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8812a.c b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
index 55f1d3d3240be24580bdc4a7b3456b8ff8340e70..5d58dff4fcee7c4b3194794266cb48cd472014f9 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8812a.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8812a.c
@@ -931,7 +931,7 @@ static const struct rtw_chip_ops rtw8812a_ops = {
 	.phy_calibration	= rtw8812a_phy_calibration,
 	.cck_pd_set		= rtw_phy_cck_pd_set,
 	.pwr_track		= rtw8812a_pwr_track,
-	.config_bfee		= NULL,
+	.config_bfee		= rtw88xxa_bf_config_bfee,
 	.set_gid_table		= NULL,
 	.cfg_csi_rate		= NULL,
 	.led_set		= rtw8812a_led_set,
@@ -1084,6 +1084,7 @@ const struct rtw_chip_info rtw8812a_hw_spec = {
 	.old_datarate_fb_limit = true,
 	.usb_tx_agg_desc_num = 1,
 	.iqk_threshold = 8,
+	.bfer_su_max_num = 2,
 	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
 	.max_scan_ie_len = IEEE80211_MAX_DATA_LEN,
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8814a.c b/drivers/net/wireless/realtek/rtw88/rtw8814a.c
index 5bb55606f14a126806acb354658c150150ae0cce..2db05a83766d65123edc95f50a40d3f93bfb1dba 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8814a.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8814a.c
@@ -4,6 +4,7 @@
 
 #include <linux/usb.h>
 #include "main.h"
+#include "bf.h"
 #include "coex.h"
 #include "tx.h"
 #include "phy.h"
@@ -115,10 +116,13 @@ static void rtw8814a_init_hwcap(struct rtw_dev *rtwdev)
 			   BIT(RTW_CHANNEL_WIDTH_80);
 	efuse->hw_cap.ptcl = EFUSE_HW_CAP_PTCL_VHT;
 
-	if (hal->rf_type == RF_3T3R)
+	if (hal->rf_type == RF_3T3R) {
 		efuse->hw_cap.nss = 3;
-	else
+		hal->bfee_sts_cap = 2;
+	} else {
 		efuse->hw_cap.nss = 2;
+		hal->bfee_sts_cap = 1;
+	}
 
 	rtw_dbg(rtwdev, RTW_DBG_EFUSE,
 		"hw cap: hci=0x%02x, bw=0x%02x, ptcl=0x%02x, ant_num=%d, nss=%d\n",
@@ -2039,6 +2043,31 @@ static void rtw8814a_led_set(struct led_classdev *led,
 	rtw_write32(rtwdev, REG_GPIO_PIN_CTRL_2, led_gpio_cfg);
 }
 
+#define RTW_NDP_RX_STANDBY_TIME_8814A	0x40
+#define RTW_SND_CTRL_SOUNDING_8814A	0xDB
+
+static void rtw8814a_bf_enable_bfee_su(struct rtw_dev *rtwdev,
+				       struct rtw_vif *vif,
+				       struct rtw_bfee *bfee)
+{
+	rtw_bf_enable_bfee_su(rtwdev, vif, bfee);
+
+	rtw_write16(rtwdev, REG_SND_PTCL_CTRL + 1, 0x0202);
+	rtw_write8(rtwdev, REG_SND_PTCL_CTRL, RTW_SND_CTRL_SOUNDING_8814A);
+	rtw_write8(rtwdev, REG_SND_PTCL_CTRL + 3,
+		   RTW_NDP_RX_STANDBY_TIME_8814A);
+}
+
+static void rtw8814a_bf_config_bfee(struct rtw_dev *rtwdev,
+				    struct rtw_vif *vif,
+				    struct rtw_bfee *bfee, bool enable)
+{
+	if (enable)
+		rtw8814a_bf_enable_bfee_su(rtwdev, vif, bfee);
+	else
+		rtw_bf_remove_bfee_su(rtwdev, bfee);
+}
+
 static void rtw8814a_fill_txdesc_checksum(struct rtw_dev *rtwdev,
 					  struct rtw_tx_pkt_info *pkt_info,
 					  u8 *txdesc)
@@ -2068,7 +2097,7 @@ static const struct rtw_chip_ops rtw8814a_ops = {
 	.phy_calibration	= rtw8814a_phy_calibration,
 	.cck_pd_set		= rtw8814a_phy_cck_pd_set,
 	.pwr_track		= rtw8814a_pwr_track,
-	.config_bfee		= NULL,
+	.config_bfee		= rtw8814a_bf_config_bfee,
 	.set_gid_table		= NULL,
 	.cfg_csi_rate		= NULL,
 	.led_set		= rtw8814a_led_set,
@@ -2231,6 +2260,7 @@ const struct rtw_chip_info rtw8814a_hw_spec = {
 	.rfe_defs = rtw8814a_rfe_defs,
 	.rfe_defs_size = ARRAY_SIZE(rtw8814a_rfe_defs),
 	.iqk_threshold = 8,
+	.bfer_su_max_num = 2,
 	.max_scan_ie_len = IEEE80211_MAX_DATA_LEN,
 
 	.coex_para_ver = 0,
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821a.c b/drivers/net/wireless/realtek/rtw88/rtw8821a.c
index 6096d3b8e41bee6cdc2d05500d2fbeb9e097430e..6d106ae70d9142b45337057311dc423158e7dabc 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821a.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821a.c
@@ -877,7 +877,7 @@ static const struct rtw_chip_ops rtw8821a_ops = {
 	.phy_calibration	= rtw8821a_phy_calibration,
 	.cck_pd_set		= rtw_phy_cck_pd_set,
 	.pwr_track		= rtw8821a_pwr_track,
-	.config_bfee		= NULL,
+	.config_bfee		= rtw88xxa_bf_config_bfee,
 	.set_gid_table		= NULL,
 	.cfg_csi_rate		= NULL,
 	.led_set		= rtw8821a_led_set,
@@ -1188,6 +1188,7 @@ const struct rtw_chip_info rtw8821a_hw_spec = {
 	.old_datarate_fb_limit = true,
 	.usb_tx_agg_desc_num = 6,
 	.iqk_threshold = 8,
+	.bfer_su_max_num = 2,
 	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
 	.max_scan_ie_len = IEEE80211_MAX_DATA_LEN,
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw88xxa.c b/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
index c298fa0fb2a6b94118527a297affa5e6e8ab633d..87253fffe78cd6f5b58a325eef42b58b968e2d46 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw88xxa.c
@@ -138,6 +138,7 @@ static void rtw88xxa_read_usb_type(struct rtw_dev *rtwdev)
 		efuse->hw_cap.nss = 1;
 	else
 		efuse->hw_cap.nss = 2;
+	rtwdev->hal.bfee_sts_cap = 1;
 
 	if (rtwdev->chip->id == RTW_CHIP_TYPE_8821A)
 		goto print_hw_cap;
@@ -197,6 +198,67 @@ static void rtw88xxa_read_usb_type(struct rtw_dev *rtwdev)
 		efuse->hw_cap.ant_num, efuse->hw_cap.nss);
 }
 
+#define RTW_NDP_RX_STANDBY_TIME_88XXA	0x50
+#define RTW_SND_CTRL_REMOVE_88XXA	0xC8
+#define RTW_SND_CTRL_SOUNDING_88XXA	0xCB
+
+void rtw88xxa_bf_config_bfee(struct rtw_dev *rtwdev, struct rtw_vif *vif,
+			     struct rtw_bfee *bfee, bool enable)
+{
+	static const u32 csi_rpt_regs[] = {
+		REG_TX_CSI_RPT_PARAM_BW20,
+		REG_TX_CSI_RPT_PARAM_BW40,
+		REG_TX_CSI_RPT_PARAM_BW80,
+	};
+	struct rtw_bf_info *bf_info = &rtwdev->bf_info;
+	u8 slot = bfee->su_reg_index;
+	u32 addr_bfer_info;
+	u32 csi_param;
+	int i;
+
+	if (bfee->role != RTW_BFEE_SU || slot >= 2)
+		return;
+
+	addr_bfer_info = slot ? REG_ASSOCIATED_BFMER1_INFO :
+				      REG_ASSOCIATED_BFMER0_INFO;
+
+	rtw_dbg(rtwdev, RTW_DBG_BF, "chip %d SU beamformee %s slot %u\n",
+		rtwdev->chip->id, enable ? "enable" : "disable", slot);
+
+	if (!enable) {
+		rtw_write32(rtwdev, addr_bfer_info, 0);
+		rtw_write16(rtwdev, addr_bfer_info + 4, 0);
+
+		clear_bit(slot, bf_info->bfer_su_reg_maping);
+		bfee->su_reg_index = 0xff;
+
+		if (!bf_info->bfer_su_cnt)
+			rtw_write8(rtwdev, REG_SND_PTCL_CTRL,
+				   RTW_SND_CTRL_REMOVE_88XXA);
+		return;
+	}
+
+	if (hweight8(rtwdev->hal.antenna_rx) == 2) {
+		rtw_write32(rtwdev, REG_CSI_CONTENT_VALUE, 0);
+		csi_param = 0x01090109;
+	} else {
+		rtw_write32(rtwdev, REG_CSI_CONTENT_VALUE, 0x01081008);
+		csi_param = 0x01080108;
+	}
+
+	rtw_write8(rtwdev, REG_SND_PTCL_CTRL,
+		   RTW_SND_CTRL_SOUNDING_88XXA);
+	for (i = 0; i < ETH_ALEN; i++)
+		rtw_write8(rtwdev, addr_bfer_info + i, bfee->mac_addr[i]);
+
+	for (i = 0; i < ARRAY_SIZE(csi_rpt_regs); i++)
+		rtw_write32(rtwdev, csi_rpt_regs[i], csi_param);
+
+	rtw_write8(rtwdev, REG_SND_PTCL_CTRL + 3,
+		   RTW_NDP_RX_STANDBY_TIME_88XXA);
+}
+EXPORT_SYMBOL(rtw88xxa_bf_config_bfee);
+
 int rtw88xxa_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
diff --git a/drivers/net/wireless/realtek/rtw88/rtw88xxa.h b/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
index d9c8db58909cad07b06ab993a08b246b1a9bf74d..0aaf7aa4aafdd396bff25a8fcd880a5514e589ba 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw88xxa.h
@@ -170,5 +170,7 @@ bool rtw88xxa_iqk_finish(int average, int threshold,
 void rtw88xxa_phy_pwrtrack(struct rtw_dev *rtwdev,
 			   void (*do_lck)(struct rtw_dev *rtwdev),
 			   void (*do_iqk)(struct rtw_dev *rtwdev));
+void rtw88xxa_bf_config_bfee(struct rtw_dev *rtwdev, struct rtw_vif *vif,
+			     struct rtw_bfee *bfee, bool enable);
 
 #endif
-- 
2.55.0

