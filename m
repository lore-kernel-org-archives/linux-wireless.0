Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793430648;
	b=KMI0ZDSOdKet7CAbeHxysN2bADjzYO45fbk+KUVMciMZuTNUHEhntRW7LjGHbkj4iekv
	 9AawvV2iC5/+mwCOTYfqYkRI/Y7srFzIp3ae3TZr8cy0B5lk154IhcsryeL3KS9wb3SWd
	 BkF1LyNaqlBR5OpXxE5PE/greES4iDa5O9iYJCDYsH2Z6OVddLMEqOwriIFxbMOW46MqF
	 Oglk1l43OBiXCoot6afBUzPQvDvemcYJKO7oXue413lBNecSXOfpWjy0xgT8eKBclATlF
	 yy6+4P+q1cZlyA2GXnRvV8YaLhNYrNqkl8fRPFbjyyVwXzePntWchal5nepJudmOQKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793430648;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hIbCKUk+U6FsLHVkr6pPqtyC0W3f5NodOwSHEwiGNpQ=;
	b=Ss1QrWJ7t8Q567Ru92/czj/cdMsQMtdWTAER3/0dwBvlXGcG5tOl4/5uO+5yhsgepBP6
	 emzJ0CU/gjqeV9z95HIq6Vte/J7ADR6x7UdCHrTMMumfwSO8yYgDmHrw4qVPwCd2mNDYK
	 n62tupEQ8ECdlfxUUoI6QvqY63rqo8ia3FQXAXPhaLHBvXg/ydIqooQshb6/qIroVQ9wX
	 OZAZuX47KhhNx3iUg9sOZGUo6DKpCKq822aoSE6ynFRqAuHWkGRLl9dyUuSV6aKFETdi8
	 eDPtNWBpWvHlK8SgK5z4mzj5zxUySe+oRZ2GQepSgrctokyGAls/fdMwGD4OSCK3+gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q5uEKOIB;
	arc=none smtp.remote-ip=209.85.216.41
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF45606A337
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 07:10:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5DF45606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q5uEKOIB
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ab98332238so843812a91.3
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 00:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793430629; x=1794035429; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hIbCKUk+U6FsLHVkr6pPqtyC0W3f5NodOwSHEwiGNpQ=;
        b=Q5uEKOIBTV9QGM03Zaz+qCvMKmlNEqR+kn+WGYekyYkAJ2kgD3ViDc6ifJpdLuhB03
         bHUyNPA2bkfGpUuqCwYdGrWgpSkucsZlDX3GcDdA/mUR6wXqP5TDzunspQsAuuUYmyiI
         JHKHGjJjTTtx6do4oH3SJhlTd1ownBxGV4brwuWfu+iTV1hE57RhHmXZIVqn6J2TYaXY
         PpmPPqZLu+lof6oJtiXm6thSgph0zqWgYPcNF8ZumgEKWVdH85i51RuBiog7He2yvirV
         9VenchdnzJboxKB8xODTK/1qhxlf/+biyuQwQbFLFKtqDctZ1w3NbejZNx0KSuGjHZRm
         jE2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793430629; x=1794035429;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hIbCKUk+U6FsLHVkr6pPqtyC0W3f5NodOwSHEwiGNpQ=;
        b=SCn9Dn/LBS48tqWJ8NfhzOOH7qouWqQ++waRnnoyCaSX1r2EgZjDcl/3kXxZxjINNx
         joJPi7EpL5tJqGTG7nKWLS/K1BwrxoYUlIzyzyeUHTg2ZL/JJjXziS2502i8PdeLCgi3
         5+iSqUzwVDO+3XEyRjQv4+xDEuNetTePFH8bvL9taI4PiWSHQiOvgZnUAdAmKwz7gNLP
         jS+GJs3PMQaCxJahldtLppFeuMva3GwqmgQFYM1mdJWgV+oC0n1QSLKz1EMYPaFirAj3
         gja545XGjIkTknuEnhgyqt5zEcMXuNUKu6y4Z8TGNUCBN3Q5t6PIdm+1BQ4eWtU1BidZ
         216Q==
X-Gm-Message-State: AFq9FYLt36x01g+vdF2NUpjS2vuGOXKwHRTty/IrwC1zjSBu7kPq5tIy
	vr6QWTO9bhSGUkynGfHZ2kREdyPIyxzWdzi4L8SSR9DkSXNKfpSlPDMNqPZxCBOc
X-Gm-Gg: AYBFou1ZKcZDmW/O9VXFI8/Swob1mmpQhMbybT9I0OT9t1QekQDPv/HynMfNOmJI974
	fXsJV+KSKAUT3fWPWu2p50Gc84qGXfHP0Fpxl4egmnjQwX48aLhIf/hpvRDgeziph2wbj6ftzlO
	vjUgTKO1HDAx2nU4Ncc7x1N29jXB9JRNbamaHmDGJAIAqUrRnQFy1mwa3YdEhHUiC12xm85VlR3
	l5n9h79tP1oXyv+9cz+wh1XeegJ/+ng2Bc8qS6C4UKJyS3qCZt2NKqVoK7q3D/W3sT3s7OflXrU
	Agf1Z1cwSyd7dFSqTwKkA0WRunN5FC3oYwh/Z9hA70XNMKDR60AokFVovIxI02xN+jr7tc6VvCh
	oLpw4nVxQ/GgX4he8clDS5IFK9U3nbSqIv6HJVYNsP2nIZM2Rv/5ZT1h3H0l8vC1WZI+hMFY6jw
	IkiHsV36B5dt4wc1bcNEvFjwQ+BYG4sgOF3FUCJWeRK/Gnk+OPsPVyA+z0zgKt21h/H5ZDldVFU
	etNe/9g4vdN0Lt/KunQAI9jlUpOxJYz1ajUVy500p+j/eD6ByfZGbRdedJLTm/zQwLqXkHH8Qy9
	lK+G4HEvWftQ6ZHJaiG4Nb7tRvNT12xVqPBSQ76CjqOo7qOn7ogp/I4Xzi3UrkpuwQisxrZhzPS
	+LcaO
X-Received: by 2002:a17:90b:3b51:b0:3a0:cbe2:9e0c with SMTP id 98e67ed59e1d1-3ae897c8800mr4019346a91.63.1793430628615;
        Sat, 31 Oct 2026 00:10:28 -0700 (PDT)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3ae845432e4sm6670459a91.3.2026.10.31.00.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 00:10:28 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH rtw-next v2 4/7] wifi: rtw88: prepare frequency-offset correction for more chips
Date: Sat, 31 Oct 2026 15:09:44 +0800
Message-ID: <20261031070950.425176-5-hjf3108@gmail.com>
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
index e2515a662bb30be88920236e8b7d42791b8880c2..d0c1fb65be9563c5fc29a7d18a1c9e8589730b10 100644
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
index 8a843aac7350ad07aa64388ee712f2617120289c..b551cb860d6255ff149c76d437a7c5af1ef68b56 100644
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
index 32d9709f2c2431a2df2f363e548f2c510fe41c34..54f012a2383912142a45cce88c3a11101f7d6464 100644
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
index fc62b67a15f216496bfb572a55366f900a2d6734..c27e4c394a435cb11fc755bb8806ee1b51a30e47 100644
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

