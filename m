Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793253168;
	b=1E5VbAvI9gdKmgKA+XvczR9FuYZ9xH2Ris4Ap72BvsWrT25CYbn2LbllratgLf/3ebsm
	 9g3DKRiPHjP/qQCHwG6Ehs9Ng0yFIykfMPGyIz/VmMjgw6br4agGFYHaP9rj6wxLPJ1xw
	 ZZGaYMeFiQcGZeMnDhIaGn5sR3ChmA+9WTfAMO4ysppzbeYkDJj3ICVhn80u/VIOPXwhg
	 SxyGe7xSKNBAW5gojhd/snT4sMYGRmVpSsUpMC/hjayW2fP6V1ozcOhGeFdCwCEtviAB0
	 uUt5mkwWep/8GznAdGnyOLXo+gvpuaea5EUfWjjpr1hPx4YmWf5cjwDaxvncL7T+AiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793253168;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=z88Q5EeTnawS+p2nN6kL6qyx6o7T/bG268+nyy3JWlc=;
	b=IK5QgTqFaeHC651Y1K//0wZnnihhHp7TcKbI+6ITczDvJps0s+vSeo5PRuy3PHnf76w2
	 QbN8ednPPecCvII30TOiGnmaVGbIQuiI3M735qZuQQ6520n4a3s1of2R6P86A2VjFdhwj
	 ThLikZwRt/9xhoa2lFSY/dF0ZY/u4/JOE8lvE3PD8O37fEV1XinNjGbx4DG31cyMaIbMw
	 zoYAXcztfWiOtVllXnfVmI6myfKSYhfPW7+GhOOTEeLjIWJ3fGcK2CkeuN0EXysphP7z4
	 VvZcuEv6d7QVlSfMjfVh5api7gpnHnar+3wwpDBMgrIK0z7BI1BogESV9cUFGiU0tlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EnDYbKdJ;
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA2C606A322
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 05:52:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2CA2C606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EnDYbKdJ
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3ab2cb8d577so1415521a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 22:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793253167; x=1793857967; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z88Q5EeTnawS+p2nN6kL6qyx6o7T/bG268+nyy3JWlc=;
        b=EnDYbKdJqB/h860RP0Lnqduwkz9EaFnkwkf3uc3AdCO8yZGJlbiHBJFaDQFYwzXB4t
         ZTjzr8Fda6tU0wbjpfQqjA1AB8hTxO5NYdC966RIgXD5KscOaArIT7sSwuurjEi8hnyj
         ez0+jH9CuW4c7iHoxWYcgVREuTMN85CfyVek5mL9EyJVP2QipFQnDO5n2A7Fg+GKgnKA
         hRRKl5rR/mGUsy1qbAFZzJBuwhMPF1Ev4PoA1WA7bz1GbybMpnk400WE4tzHyVO02qKw
         jTON8PTfz3HNfNal9Glk/2Nh18CIpRrsuXjgqeDkWOvO8YsoSRwF4WtPqRGp7A43angH
         wAkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793253167; x=1793857967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=z88Q5EeTnawS+p2nN6kL6qyx6o7T/bG268+nyy3JWlc=;
        b=uD37rbDZFrSf3wNGerObWBarKXE1mvzh91lxFtaHI9hEicixcyvIMUNRYCk3KaQgf5
         ORKe9RWCc3mdxxJvRvIqJdPfYp5+ghXzNfi0aHcJDVz1SWBrJbwMhrBaA0DxynpUcB2i
         WkmxELAv70wN9LGWYPxwFAA7QR4T939EQpJT9bYJAYNZZKwnS6mSIKSiTgN3rb99Dbif
         C0mzwiSLs/ELQc7mOgulCYnxftubk3DITGtXZrKLPC/Sz2rvsgQ889mhI1u1c+4MahOe
         FLZtKkzhAWOriOncU0ILpir3WVWTPSVt4RxHtF9mVwGFLquIH69nZnrks1xSDa5GILMg
         11Tg==
X-Gm-Message-State: AFq9FYJX25+HRQfJ4jSBrBo21bs5oTHQM64kT45kAqZvjwqRebN3qGfa
	5xj4sr/Z+/80OLFKxbGKXrYDtatP68mbQYU7kUHp69retH5kyvzl9KSu
X-Gm-Gg: AYBFou32umBD1/G5GayuOUBROj5jsDjgDD6vuhlT9sfUscaNlXPz9FIb6AUfh43AssE
	vbtjYNdbtAwZcScG2R1yBwYraqOgelvKLD2uWc4w1uTVbW7Ywf7ZEuwfFHcpjZiRGmc2OglhfRX
	UaMv0oG/2BpeA7p/PXmHgGO1a9hn3dj/6JBCuj3HV3krtpt6eUQ9IuoSvujrw543965k5xf3rKC
	wmApc7pdUkj/EmZAwxxOdIXZ/eaFA9o/pNbvu0z7FdJiVgF/ptWReKlVsCEycgcAdDOXZEammzU
	3gwK+eCa3HqA/bbhbJM98dB9tdKwsKxbDKyJpdI02VF9IoyeIgajC0Zi2navOt6sCuDIgLwOTEE
	jXVZQoNZM0gJDxPD4gxJxvoDvcuONKzwE4L/lX9ThgcpdjXPJxw0m5wiDrtCITJ1/kVcJGaCScc
	hnoOo1Mm+5F6N5G//TjwaOvjNj1TRLZboaFJgLuNCjM0TOrDnd7d9V9AjMRSsiH8uL4m6Of2/gr
	bjigWuDSw+1dGEdb8xdGBwUrObDzU54EZDOOhcjZp5bFQJtN9MxEkK8QFPWH98TCSu2GBQ6tl4v
	8CF3cF8vB+d+mUFhfl8QHPvjV2aXSNDNKTn1VK51nnQroWpoik8hYXw7SNBJ6xHkarkk3CGoMQR
	uVrr8
X-Received: by 2002:a17:90b:3c44:b0:3ac:c024:b275 with SMTP id 98e67ed59e1d1-3ae57df3da7mr3620262a91.9.1793253167530;
        Wed, 28 Oct 2026 22:52:47 -0700 (PDT)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3ae6e2a703esm2523531a91.0.2026.10.28.22.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 22:52:47 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] wifi: rtw88: prepare frequency-offset correction for more chips
Date: Thu, 29 Oct 2026 13:52:05 +0800
Message-ID: <20261029055212.84711-4-hjf3108@gmail.com>
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

Promote chip specific functions into the common core for cfo tracking.
These become helpers which can be used by the other drivers.

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/phy.c      | 106 ++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/phy.h      |   2 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 100 +----------------
 drivers/net/wireless/realtek/rtw88/rtw8822c.h |   3 -
 4 files changed, 113 insertions(+), 98 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index e2515a662bb30..d0c1fb65be956 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -720,6 +720,112 @@ void rtw_phy_parsing_cfo(struct rtw_dev *rtwdev,
 }
 EXPORT_SYMBOL(rtw_phy_parsing_cfo);
 
+#define CFO_TRK_ENABLE_TH	20
+#define CFO_TRK_STOP_TH		10
+#define CFO_TRK_ADJ_TH		10
+
+static u8 rtw_phy_cfo_tracking_reset(struct rtw_dev *rtwdev)
+{
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+	struct rtw_cfo_track *cfo = &dm_info->cfo_track;
+
+	cfo->is_adjust = true;
+
+	if (cfo->crystal_cap > rtwdev->efuse.crystal_cap)
+		return cfo->crystal_cap - 1;
+	else if (cfo->crystal_cap < rtwdev->efuse.crystal_cap)
+		return cfo->crystal_cap + 1;
+
+	return cfo->crystal_cap;
+}
+
+void rtw_phy_cfo_xcap_init(struct rtw_dev *rtwdev)
+{
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+	struct rtw_cfo_track *cfo = &dm_info->cfo_track;
+
+	cfo->crystal_cap = rtwdev->efuse.crystal_cap;
+	cfo->is_adjust = true;
+}
+EXPORT_SYMBOL(rtw_phy_cfo_xcap_init);
+
+#define REPORT_TO_KHZ(val) ({typeof(val) _v = (val); (_v << 1) + (_v >> 1); })
+static s32 rtw_phy_cfo_calc_avg(struct rtw_dev *rtwdev, u8 path_num)
+{
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+	struct rtw_cfo_track *cfo = &dm_info->cfo_track;
+	s32 cfo_avg, cfo_path_sum = 0, cfo_rpt_sum;
+	u8 i;
+
+	for (i = 0; i < path_num; i++) {
+		cfo_rpt_sum = REPORT_TO_KHZ(cfo->cfo_tail[i]);
+
+		if (cfo->cfo_cnt[i])
+			cfo_avg = cfo_rpt_sum / cfo->cfo_cnt[i];
+		else
+			cfo_avg = 0;
+
+		cfo_path_sum += cfo_avg;
+	}
+
+	for (i = 0; i < path_num; i++) {
+		cfo->cfo_tail[i] = 0;
+		cfo->cfo_cnt[i] = 0;
+	}
+
+	return cfo_path_sum / path_num;
+}
+
+static void rtw_phy_cfo_need_adjust(struct rtw_dev *rtwdev, s32 cfo_avg)
+{
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+	struct rtw_cfo_track *cfo = &dm_info->cfo_track;
+
+	if (!cfo->is_adjust) {
+		if (abs(cfo_avg) > CFO_TRK_ENABLE_TH)
+			cfo->is_adjust = true;
+	} else {
+		if (abs(cfo_avg) <= CFO_TRK_STOP_TH)
+			cfo->is_adjust = false;
+	}
+}
+
+u8 rtw_phy_cfo_xcap_track(struct rtw_dev *rtwdev, u8 xcap_max, bool bt_hold)
+{
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+	struct rtw_cfo_track *cfo = &dm_info->cfo_track;
+	u8 path_num = rtwdev->hal.rf_path_num;
+	s8 crystal_cap = cfo->crystal_cap;
+	s32 cfo_avg = 0;
+
+	if (rtwdev->sta_cnt != 1)
+		return rtw_phy_cfo_tracking_reset(rtwdev);
+
+	if (cfo->packet_count == cfo->packet_count_pre)
+		return cfo->crystal_cap;
+
+	cfo->packet_count_pre = cfo->packet_count;
+	cfo_avg = rtw_phy_cfo_calc_avg(rtwdev, path_num);
+	rtw_phy_cfo_need_adjust(rtwdev, cfo_avg);
+
+	if (bt_hold) {
+		cfo->is_adjust = false;
+		return rtwdev->efuse.crystal_cap;
+	}
+
+	if (cfo->is_adjust) {
+		if (cfo_avg > CFO_TRK_ADJ_TH)
+			crystal_cap++;
+		else if (cfo_avg < -CFO_TRK_ADJ_TH)
+			crystal_cap--;
+
+		crystal_cap = clamp_t(s8, crystal_cap, 0, xcap_max);
+	}
+
+	return (u8)crystal_cap;
+}
+EXPORT_SYMBOL(rtw_phy_cfo_xcap_track);
+
 static void rtw_phy_cfo_track(struct rtw_dev *rtwdev)
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
diff --git a/drivers/net/wireless/realtek/rtw88/phy.h b/drivers/net/wireless/realtek/rtw88/phy.h
index 8a843aac7350a..b551cb860d625 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.h
+++ b/drivers/net/wireless/realtek/rtw88/phy.h
@@ -68,6 +68,8 @@ void rtw_phy_adaptivity_set_mode(struct rtw_dev *rtwdev);
 void rtw_phy_cck_pd_set(struct rtw_dev *rtwdev, u8 new_lvl);
 void rtw_phy_parsing_cfo(struct rtw_dev *rtwdev,
 			 struct rtw_rx_pkt_stat *pkt_stat);
+void rtw_phy_cfo_xcap_init(struct rtw_dev *rtwdev);
+u8 rtw_phy_cfo_xcap_track(struct rtw_dev *rtwdev, u8 xcap_max, bool bt_hold);
 void rtw_phy_tx_path_diversity(struct rtw_dev *rtwdev);
 
 struct rtw_txpwr_lmt_cfg_pair {
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 32d9709f2c243..54f012a238391 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -4243,103 +4243,13 @@ static void rtw8822c_set_crystal_cap(struct rtw_dev *rtwdev, u8 crystal_cap)
 	rtw8822c_set_crystal_cap_reg(rtwdev, crystal_cap);
 }
 
-static void rtw8822c_cfo_tracking_reset(struct rtw_dev *rtwdev)
-{
-	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
-	struct rtw_cfo_track *cfo = &dm_info->cfo_track;
-
-	cfo->is_adjust = true;
-
-	if (cfo->crystal_cap > rtwdev->efuse.crystal_cap)
-		rtw8822c_set_crystal_cap(rtwdev, cfo->crystal_cap - 1);
-	else if (cfo->crystal_cap < rtwdev->efuse.crystal_cap)
-		rtw8822c_set_crystal_cap(rtwdev, cfo->crystal_cap + 1);
-}
-
-static void rtw8822c_cfo_init(struct rtw_dev *rtwdev)
-{
-	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
-	struct rtw_cfo_track *cfo = &dm_info->cfo_track;
-
-	cfo->crystal_cap = rtwdev->efuse.crystal_cap;
-	cfo->is_adjust = true;
-}
-
-#define REPORT_TO_KHZ(val) ({typeof(val) _v = (val); (_v << 1) + (_v >> 1); })
-static s32 rtw8822c_cfo_calc_avg(struct rtw_dev *rtwdev, u8 path_num)
-{
-	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
-	struct rtw_cfo_track *cfo = &dm_info->cfo_track;
-	s32 cfo_avg, cfo_path_sum = 0, cfo_rpt_sum;
-	u8 i;
-
-	for (i = 0; i < path_num; i++) {
-		cfo_rpt_sum = REPORT_TO_KHZ(cfo->cfo_tail[i]);
-
-		if (cfo->cfo_cnt[i])
-			cfo_avg = cfo_rpt_sum / cfo->cfo_cnt[i];
-		else
-			cfo_avg = 0;
-
-		cfo_path_sum += cfo_avg;
-	}
-
-	for (i = 0; i < path_num; i++) {
-		cfo->cfo_tail[i] = 0;
-		cfo->cfo_cnt[i] = 0;
-	}
-
-	return cfo_path_sum / path_num;
-}
-
-static void rtw8822c_cfo_need_adjust(struct rtw_dev *rtwdev, s32 cfo_avg)
-{
-	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
-	struct rtw_cfo_track *cfo = &dm_info->cfo_track;
-
-	if (!cfo->is_adjust) {
-		if (abs(cfo_avg) > CFO_TRK_ENABLE_TH)
-			cfo->is_adjust = true;
-	} else {
-		if (abs(cfo_avg) <= CFO_TRK_STOP_TH)
-			cfo->is_adjust = false;
-	}
-
-	if (!rtw_coex_disabled(rtwdev)) {
-		cfo->is_adjust = false;
-		rtw8822c_set_crystal_cap(rtwdev, rtwdev->efuse.crystal_cap);
-	}
-}
-
 static void rtw8822c_cfo_track(struct rtw_dev *rtwdev)
 {
-	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
-	struct rtw_cfo_track *cfo = &dm_info->cfo_track;
-	u8 path_num = rtwdev->hal.rf_path_num;
-	s8 crystal_cap = cfo->crystal_cap;
-	s32 cfo_avg = 0;
-
-	if (rtwdev->sta_cnt != 1) {
-		rtw8822c_cfo_tracking_reset(rtwdev);
-		return;
-	}
-
-	if (cfo->packet_count == cfo->packet_count_pre)
-		return;
-
-	cfo->packet_count_pre = cfo->packet_count;
-	cfo_avg = rtw8822c_cfo_calc_avg(rtwdev, path_num);
-	rtw8822c_cfo_need_adjust(rtwdev, cfo_avg);
-
-	if (cfo->is_adjust) {
-		if (cfo_avg > CFO_TRK_ADJ_TH)
-			crystal_cap++;
-		else if (cfo_avg < -CFO_TRK_ADJ_TH)
-			crystal_cap--;
+	u8 crystal_cap;
 
-		crystal_cap = clamp_t(s8, crystal_cap, 0, XCAP_MASK);
-		rtw8822c_set_crystal_cap(rtwdev, (u8)crystal_cap);
-	}
+	crystal_cap = rtw_phy_cfo_xcap_track(rtwdev, XCAP_MASK,
+					     !rtw_coex_disabled(rtwdev));
+	rtw8822c_set_crystal_cap(rtwdev, crystal_cap);
 }
 
 static const struct rtw_phy_cck_pd_reg
@@ -4985,7 +4895,7 @@ static const struct rtw_chip_ops rtw8822c_ops = {
 	.cfg_csi_rate		= rtw_bf_cfg_csi_rate,
 	.adaptivity_init	= rtw8822c_adaptivity_init,
 	.adaptivity		= rtw8822c_adaptivity,
-	.cfo_init		= rtw8822c_cfo_init,
+	.cfo_init		= rtw_phy_cfo_xcap_init,
 	.cfo_track		= rtw8822c_cfo_track,
 	.config_tx_path		= rtw8822c_config_tx_path,
 	.config_txrx_mode	= rtw8822c_config_trx_mode,
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.h b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
index fc62b67a15f21..c27e4c394a435 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.h
@@ -181,9 +181,6 @@ const struct rtw_table name ## _tbl = {			\
 #define REG_ANAPARLDO_POW_MAC	0x0029
 #define BIT_LDOE25_PON		BIT(0)
 #define XCAP_MASK		GENMASK(6, 0)
-#define CFO_TRK_ENABLE_TH	20
-#define CFO_TRK_STOP_TH		10
-#define CFO_TRK_ADJ_TH		10
 
 #define REG_TXDFIR0		0x808
 #define REG_DFIRBW		0x810
-- 
2.55.0

