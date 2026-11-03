Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793692411;
	b=O84dXqQtg3ddF2ND6VdrwChPZQv7KLW20TAbgo/UMwdcukGBaSMcZNP/kw5XqFam/zQ7
	 WqdIqDWEYSL1kBxr0KNSbYyw7Gehf8QKx2A0CcB0LOjNASkgYtFwAkN/0jlIOvmjIonGy
	 DVhXH1geo3OVtyf/7FzR0tDoxasQ6UXv/DPke5vuZYI3kFYo5yOlgqlTl4HNGpCjsEi7B
	 xik/dEbLEa3fMBcgWrjvteHqmm0SaFYeBVjKxzs9FivE2iQ94trDFeONB79xap381vHck
	 pejbP0eo8PBIkVaSOiy97J403ncYqNctc9vj4kW/PuFvUIYnYU/a6U72uu59z1IXP0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793692411;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type;
	bh=ifu4Rtu9IC2haBk8gc42Y10vAOTIm0Fs4UZIYKsOyTM=;
	b=A3cd+zdCJtFiWnwXWn9q/acuO0xTfK5JGPwX8HhGUMPnPKbfrqVYg334R+o1GfAQm4U/
	 0hDNaQXPrw39MU8TpWHN5QtDlAA3Szlu8t6FvNN8UO92zjAG5S0fVWKyo6zoKTTwOmpdv
	 gOmo/OEpTrzEn2Tc8Srsyn7dr8poL80ux63jqmEYG6DVuYpl2UHV/YQDIv5TnuruUWEgB
	 3qRdpBgEaGbAOn62B2allKCqpOW7LfwP71yIOpRuFwit8CI4yMRq8Xoq10afkBbqMrPC3
	 dmLHvwU2djudZeqagKsaeXlW1W/DfXfd970CBpTrkflkMOzjeT6E5GGGISr74i/3MOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=dbsE5RGi;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43599606A324
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 07:53:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43599606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=dbsE5RGi
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A37rRppD2864310, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793692408; bh=ifu4Rtu9IC2haBk8gc42Y10vAOTIm0Fs4UZIYKsOyTM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=dbsE5RGiXprQ+XiRxws++NyB9STJfyapJXxuFe/16IlIpRTfFCB+s27BY9XKs67FJ
	 Zkb1etQIBnkHAMRpJkW84qT1BGyWWfHFFVq+CbfTRhOA7HejoIzGr5COxDtiNhhdUD
	 MbQXpiE39pFLOivAfFbknkCTknthHkh/6RXoks/Xd/B0tUls+Sbl+dpG60lSNx10dS
	 VXqsygnAl7AwtryVTYnE4he/pOKAmMCYwiWeUa+pHPRL5AT4fnVfT5dEcESr/KG7cF
	 6K76LiY0QTPO+Ecnak+pn8uTJb/v9C+hrXJ6PhOCeLdT260MRugG6E67ivCtPaV9no
	 DItryCeQk6Grw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A37rRppD2864310
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Tue, 3 Nov 2026 15:53:28 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 15:53:25 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 15:53:24 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 15:53:24 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <timlee@realtek.com>
Subject: [PATCH rtw-next 1/2] wifi: rtw89: enable low-latency power-save optimization for RTL8852B/RTL8852BT
Date: Tue, 3 Nov 2026 15:52:54 +0800
Message-ID: <20261103075255.56487-2-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261103075255.56487-1-pkshih@realtek.com>
References: <20261103075255.56487-1-pkshih@realtek.com>
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
Content-Type: text/plain

From: Chin-Yen Lee <timlee@realtek.com>

The low-latency power-save optimization (LPS) was originally
introduced specifically for RTL8852A to improve interactive
application performance by exiting power-save during packet
bursts.

To extend this feature to RTL8852B and RTL8852BT, introduce
a new flag "support_low_latency_lps" in chip info instead of
hardcoding chip ID checks. Enable this capability for RTL8852A,
RTL8852B, and RTL8852BT while explicitly disabling it for other
supported chips.

Signed-off-by: Chin-Yen Lee <timlee@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.c      | 2 +-
 drivers/net/wireless/realtek/rtw89/core.h      | 1 +
 drivers/net/wireless/realtek/rtw89/rtw8851b.c  | 1 +
 drivers/net/wireless/realtek/rtw89/rtw8852a.c  | 1 +
 drivers/net/wireless/realtek/rtw89/rtw8852b.c  | 1 +
 drivers/net/wireless/realtek/rtw89/rtw8852bt.c | 1 +
 drivers/net/wireless/realtek/rtw89/rtw8852c.c  | 1 +
 drivers/net/wireless/realtek/rtw89/rtw8922a.c  | 1 +
 drivers/net/wireless/realtek/rtw89/rtw8922d.c  | 1 +
 9 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 58ee5efc3b5e..bfa31d365bef 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -3006,7 +3006,7 @@ static bool rtw89_core_proto_stats_can_lps(struct rtw89_dev *rtwdev,
 					   struct rtw89_vif *rtwvif,
 					   enum rtw89_tfc_interval interval)
 {
-	if (rtwdev->chip->chip_id != RTL8852A)
+	if (!rtwdev->chip->support_low_latency_lps)
 		return true;
 
 	if (rtwvif->burst_active)
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 0d893b992a4a..cce2c2e48080 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -5837,6 +5837,7 @@ struct rtw89_chip_info {
 	bool support_sar_by_ant;
 	bool support_noise;
 	bool support_fw_cmd_ofld;
+	bool support_low_latency_lps;
 	bool ul_tb_waveform_ctrl;
 	bool ul_tb_pwr_diff;
 	bool rx_freq_from_ie;
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8851b.c b/drivers/net/wireless/realtek/rtw89/rtw8851b.c
index 272f4f4e1fb9..a7facfe96884 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8851b.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8851b.c
@@ -2647,6 +2647,7 @@ const struct rtw89_chip_info rtw8851b_chip_info = {
 	.support_sar_by_ant	= false,
 	.support_noise		= false,
 	.support_fw_cmd_ofld	= false,
+	.support_low_latency_lps = false,
 	.ul_tb_waveform_ctrl	= true,
 	.ul_tb_pwr_diff		= false,
 	.rx_freq_from_ie	= true,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852a.c b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
index 5207df4f9cd5..3b5e3c178440 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852a.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
@@ -2418,6 +2418,7 @@ const struct rtw89_chip_info rtw8852a_chip_info = {
 	.support_sar_by_ant	= false,
 	.support_noise		= true,
 	.support_fw_cmd_ofld	= false,
+	.support_low_latency_lps = true,
 	.ul_tb_waveform_ctrl	= false,
 	.ul_tb_pwr_diff		= false,
 	.rx_freq_from_ie	= true,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852b.c b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
index d19388b86aca..138f499af677 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852b.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
@@ -1025,6 +1025,7 @@ const struct rtw89_chip_info rtw8852b_chip_info = {
 	.support_sar_by_ant	= true,
 	.support_noise		= false,
 	.support_fw_cmd_ofld	= false,
+	.support_low_latency_lps = true,
 	.ul_tb_waveform_ctrl	= true,
 	.ul_tb_pwr_diff		= false,
 	.rx_freq_from_ie	= true,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852bt.c b/drivers/net/wireless/realtek/rtw89/rtw8852bt.c
index 23ad02d1fcd4..7306ae7db096 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852bt.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852bt.c
@@ -866,6 +866,7 @@ const struct rtw89_chip_info rtw8852bt_chip_info = {
 	.support_sar_by_ant	= true,
 	.support_noise		= false,
 	.support_fw_cmd_ofld	= false,
+	.support_low_latency_lps = true,
 	.ul_tb_waveform_ctrl	= true,
 	.ul_tb_pwr_diff		= false,
 	.rx_freq_from_ie	= true,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852c.c b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
index e556ba0c14a7..bdcce2e94f99 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852c.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
@@ -3222,6 +3222,7 @@ const struct rtw89_chip_info rtw8852c_chip_info = {
 	.support_sar_by_ant	= true,
 	.support_noise		= false,
 	.support_fw_cmd_ofld	= true,
+	.support_low_latency_lps = false,
 	.ul_tb_waveform_ctrl	= false,
 	.ul_tb_pwr_diff		= true,
 	.rx_freq_from_ie	= false,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922a.c b/drivers/net/wireless/realtek/rtw89/rtw8922a.c
index e48300287697..a3b5da979768 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922a.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922a.c
@@ -3270,6 +3270,7 @@ const struct rtw89_chip_info rtw8922a_chip_info = {
 	.support_sar_by_ant	= true,
 	.support_noise		= false,
 	.support_fw_cmd_ofld	= false,
+	.support_low_latency_lps = false,
 	.ul_tb_waveform_ctrl	= false,
 	.ul_tb_pwr_diff		= false,
 	.rx_freq_from_ie	= false,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index bdf9bcf2cf22..43d9df619260 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -3791,6 +3791,7 @@ const struct rtw89_chip_info rtw8922d_chip_info = {
 	.support_sar_by_ant	= true,
 	.support_noise		= false,
 	.support_fw_cmd_ofld	= false,
+	.support_low_latency_lps = false,
 	.ul_tb_waveform_ctrl	= false,
 	.ul_tb_pwr_diff		= false,
 	.rx_freq_from_ie	= false,
-- 
2.25.1

