Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B554B8DF8
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784811309; cv=none; b=EJhHEZKb01g9adc7132h7K8JciqbIQdYy6w1+6oirnanEAs/cL1lsx4OmIQ+dEV8FrU6bsfK/gz+u2vX0pAdhG3Pka9ox5oshum73zXysBATghBUF92exTGk8N6If7z0w4eWi9XQARjs+1ftz/bfmeombJ/fUkmxuSnE3Th2tu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784811309; c=relaxed/simple;
	bh=6Ezejd1EpPGnbAduRhKLgoBYkXPAN0wGUaUx9RKn8Go=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ADcebla715n5owf6CP5AWIFe0VrKq93V+CTFI9RC/HtARBcGkmeAR97bGNbMKB6KggOAqk4AF6Uru+mmSCFYb/7AbklraPxrt0LAWNe1OZcYDZ60QCJo9tjGSSU+HKb84X03HnMZ/lhwbLwL1nyA8103aItEhKs3Fuaj6iPsk5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RxWwKJXc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BKcpk+Nx; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RxWwKJXc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BKcpk+Nx"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N8qbMW3606119
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=/6EZd+9FomL
	kt0GnaYzNx2Z6mRDMuGpXFZ3Y6/gAR5k=; b=RxWwKJXcVh7JuANUTTFqX0SbWhB
	C866yt0Lv6qG2HPHJfy62LD4B42mMfS+w+NyyARmWsX0Cf9aD/rApbjzZqBSxkVI
	Y+6uqK3eSIJZAHlawgrqBi6Aqb1HJOUnlDQTUVgHUeyl6XNFeZPuQBH/zP3z35mw
	2vkZk70cnUBT1XB62tR2I+4mpQMud0/a5ANtLBkfWwJzC51iOI3xSzppak1kUZeG
	ZLqarj0Zj2cHGgNbFVsvR8QZlN7FNHoDc7CBPWPNbSh0hSEoIUJ1u3SfWT3ezz6j
	RECyIJUiEKPyQXQjTXanRk/II4fvOfmYAIsH+6IOM+LJatwkk0X887nPxIQ==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fke7qhcb6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:05 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c856470fe9fso589203a12.2
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 05:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784811305; x=1785416105; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/6EZd+9FomLkt0GnaYzNx2Z6mRDMuGpXFZ3Y6/gAR5k=;
        b=BKcpk+Nx4/DToShLLmQqj+y0e3vP0z/TmOKGPdbabcpnTjjrlkT1zwNGG8YPuuN2A7
         20w9Wnpe77/1gy5yLckfh778Nojp1274OK8XZBI0W8m/zx6RuY0TfrK29zgYIhk+N3FS
         Q3zT28KY50YyNP6DZqPx3A1+bga2OLHHa1MV/Fs8XkX6UVPuISPqlsLKKpHreJwUkVT4
         ENHf7yF2jw69wGrEQbxz+K4mDE0dGYxdsU/gD5sp0NWcsk9tKVQpEKnC/PfJLwXi+txu
         Ptpha5w6hXh50jB77SytCIkbGLqIqqTjhU4OA71WUH1jruPA/7p3eWdopbBeMlY8f8Qe
         tKmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784811305; x=1785416105;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/6EZd+9FomLkt0GnaYzNx2Z6mRDMuGpXFZ3Y6/gAR5k=;
        b=YfrHV9mjXytSMOKwDP47/S7Iuj2XgtWNDc8hIeqkoV/CN8cBTJczxZi2+WfvsPxTrz
         o1P1IxXMbPTtnLDKgDWSSzAkn/fOk6vEnzQ3H+vjnBhH7yvTYm19L2U97F7hOxAJqYvI
         AydPNU0KKBW2XPKS/44HgoeNovMT7XcIfroSW/Vrs3RZY+sVt/HS2LN5K+xYzhfj+PFW
         EsByUWVzHavkSvScZmxd4qsJHHNsd7frF7/eCEiBq9chQJoKZlkqR7iQrzWWNuT3+O9Q
         bhLGZd2exTJhhhywAxv45KQHtVVIxsqCCvAR+tO092VwUSUem52ayo/FMkxCNlyvIPG2
         dGSw==
X-Gm-Message-State: AOJu0YxUVMq+m8edAr6wnriK0eaczL019eyArKdKjGwJpvmpkB7B/GpT
	6t4tgwS14CJvZRbjNwnyyNQRWvUG0IBu0X7HeaWoIHzpmTKsCY5JARz0x+bGziUQVgHdoDy8s3M
	S3kMnnZUAIpmi1EoUEOSE1l0nBDiAtmC9x0HtE7yBwfXl6NEZzqkFDCeIhZzHcawWS5IytA==
X-Gm-Gg: AR+sD10fJgAZ+P9GvkCf65xPcP0Ro81FhuW4uRSw1FE3vP0eUYXc39G/3IKUSyw/+f9
	V7UPjdARsxvEDgWRbY5gUogtDrs/yObsuCsr3zJm8LymEJ8/TFNL8uELBTgQxglS85mOLdBf9bv
	O800GjK7TlXCONNB5jbOMHSlPIw1wLVfgpjanzjydgUX70Bvb3RAxmj6xUg9Kgd+R5VfJww0pB5
	h3TLuhY9xyhaTiymo5jUm7PbbkRyWf4+nLiDuwfxjhT8I9rfHNW9n9dXzym4nmWq1Z/NFC3VI42
	YrJLwpoKFtumwNarx5QBkexkrkJiJ6UMUnuvF8RaSZUbWE7Flt5wiSFVp+7HR6ui4OJ/9xDQnyN
	WKPRsRFWuPqNhbG+n4HfURWSam6z6XlNjRVIqPcsnSidVgrOJL8v9
X-Received: by 2002:a17:903:1b07:b0:2cf:4505:6bcf with SMTP id d9443c01a7336-2cfa6c54aefmr36683155ad.29.1784811304803;
        Thu, 23 Jul 2026 05:55:04 -0700 (PDT)
X-Received: by 2002:a17:903:1b07:b0:2cf:4505:6bcf with SMTP id d9443c01a7336-2cfa6c54aefmr36682895ad.29.1784811304328;
        Thu, 23 Jul 2026 05:55:04 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f350475sm32998385ad.70.2026.07.23.05.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 05:55:03 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next 1/8] wifi: ath12k: fix out-of-bounds access on TX stats arrays
Date: Thu, 23 Jul 2026 18:24:41 +0530
Message-Id: <20260723125448.922361-2-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260723125448.922361-1-pardeep.kaur@oss.qualcomm.com>
References: <20260723125448.922361-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEyNyBTYWx0ZWRfX8oET0Z4a18uO
 FNcF5zrOaq+LzZovpld7sqcHzMEAfFYkjtkdit3jljXXgBaVOcfgSAn3AhOcDFcoNIMtylIy5nd
 SLCNrp2JEbBCiH+DQdS6elW9h7sm3R0=
X-Authority-Analysis: v=2.4 cv=aYxRWxot c=1 sm=1 tr=0 ts=6a620f29 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=QbJcohpuGl3nbjs-xDYA:9 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-GUID: BFoZxelDROaiYghkcr_Ak7bVZiY6v7ii
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEyNyBTYWx0ZWRfXySYpglmzrpca
 /7l9mKRFCclQN6f9y2xz2selhCo2M2kc964ZMZRapdpQ2Ox/Zl7U0d4GlGojPlpAow7MCaZ58WS
 GtTi+uevmvzYi8f+ibUOC8OPxONKWP6mIXgd37zPXRduJDKRAx/X/udzepK98Vp5AVFHhXpkT1L
 wvJGzlVf3pPCckXOwrJkhqW3BrpK/D2/xAd0x2z516GF5OeY3cXdvXamMvbtj58e/BwpPeiBjIW
 stHSbm3vVmjol4fSGD+jzbb7q1da5S7r1Ux5lliT2WC2ki0MWVMEI8lBSGQS8jNMMew7vO+FylX
 cnehV/Vo26CX88lpED6tWGinon/a5Oz1tlLf+Q9cNmDMoS+rSrtT3cOZpvlJCgivfY/xr53iM+D
 YYhK2T4RV5ymR2pi+lyjXX+dzc6o0AkIimIKXLnQnoAmHSeJK2jLHhAUG4eq8KdzC0k3n6vFmFG
 wWYq23a8REMFH19/dcA==
X-Proofpoint-ORIG-GUID: BFoZxelDROaiYghkcr_Ak7bVZiY6v7ii
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607230127

From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>

The fw_tx_status[], tx_wbm_rel_source[], and tqm_rel_reason[] arrays
are indexed directly by values read from hardware without bounds checks.
Values at or beyond MAX_FW_TX_STATUS, HAL_WBM_REL_SRC_MODULE_MAX, or
MAX_TQM_RELEASE_REASON respectively would write past the end of the
arrays causing memory corruption.

Add bounds checks using likely() and WARN_ON_ONCE() before incrementing
each counter, consistent with the existing pattern used elsewhere in
the ath12k codebase.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Fixes: c5c62287e690 ("wifi: ath12k: Add device dp stats support")
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index d2749de44553..1d55ccacbff4 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -520,7 +520,10 @@ ath12k_dp_tx_process_htt_tx_complete(struct ath12k_dp *dp, void *desc,
 
 	wbm_status = le32_get_bits(status_desc->info0,
 				   HTT_TX_WBM_COMP_INFO0_STATUS);
-	dp->device_stats.fw_tx_status[wbm_status]++;
+	if (likely(wbm_status < MAX_FW_TX_STATUS))
+		dp->device_stats.fw_tx_status[wbm_status]++;
+	else
+		WARN_ON_ONCE(1);
 
 	switch (wbm_status) {
 	case HAL_WBM_REL_HTT_TX_COMP_STATUS_OK:
@@ -922,11 +925,17 @@ void ath12k_wifi7_dp_tx_completion_handler(struct ath12k_dp *dp, int ring_id)
 		/* Find the HAL_WBM_RELEASE_INFO0_REL_SRC_MODULE value */
 		buf_rel_source = le32_get_bits(tx_status->info0,
 					       HAL_WBM_RELEASE_INFO0_REL_SRC_MODULE);
-		dp->device_stats.tx_wbm_rel_source[buf_rel_source]++;
+		if (likely(buf_rel_source < HAL_WBM_REL_SRC_MODULE_MAX))
+			dp->device_stats.tx_wbm_rel_source[buf_rel_source]++;
+		else
+			WARN_ON_ONCE(1);
 
 		rel_status = le32_get_bits(tx_status->info0,
 					   HAL_WBM_COMPL_TX_INFO0_TQM_RELEASE_REASON);
-		dp->device_stats.tqm_rel_reason[rel_status]++;
+		if (likely(rel_status < MAX_TQM_RELEASE_REASON))
+			dp->device_stats.tqm_rel_reason[rel_status]++;
+		else
+			WARN_ON_ONCE(1);
 
 		/* Release descriptor as soon as extracting necessary info
 		 * to reduce contention
base-commit: 32f39e331f889a0424f7a0a82893f628e2705727
--
2.34.1

