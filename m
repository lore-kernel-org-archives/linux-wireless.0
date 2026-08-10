Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765BE3CA4A8
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786373096; cv=none; b=QnHPjdYGu61V6t4uJrfadXo6F9meaq4e3IojASqIgr8xuZ8r9/jB6OAv4oc1b8o7xgX5kIk5nRCnbt5pWmYK7bmJ1uPRyk9C2oOcf6Em31hcex+DtHLh/ZLTo6J9E5IIPDXoZqwe+BblXjL3vr7Y4WyGJzluCUwp+kz4uZB+7tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786373096; c=relaxed/simple;
	bh=PspUP3YRpzHDbBDu+0wjY0OLj5Ffvzk5O0oJX+MdjTI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RqdyOn7qQwG8ilbynR43L0G7eTViUg0zgA4nxLYw2rZMbJvrNOgzuc9AapFUHaAo6mCxwGHkp0Q1BuI+59X8wt0VJee9T8YTqzWjmkh1xqTVnJKg9x43jCj4KpureSAJuH1YX8BV1Hj9lby/oqjCRTQG7zD4Yq5hflnuUlYt0VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Gfq9TM3x; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=R5v7okjA; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Gfq9TM3x";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="R5v7okjA"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67ACjoHS398981
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:44:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=JzME1hBKyGB
	vUEI4XmEOk/d4ajVZXCMyMBXyGj3QNWk=; b=Gfq9TM3xJYaBV+WxzJC3V+TVUgK
	jYnci2D6rE1xBKwrOmLR+rrW+PcPVU7k7+HBrH+sPsRtO70FwGp0ZL73zLGM89b8
	+s3Aju5J7zpUPratv/crc3RlaFaFaoa0pS1e1H8LXh0054KZvuRJjW9wet1/ZRG8
	3hUHPDDbaa9Dkxe60oO0FSDu2LFjafG9T2iSH6/L/kZw1TFcCMEP/M69WHJ7maaE
	Wj87IczNDNKwlu4gmcerIcfcVVMbkuIsma3BenjLRS8A+SclkeFG0eJXjhnBWzDW
	ZDYzNx2eW0pQ1lCFcJOttX4VMWg3KeWNoHIsMtL4VXCA6VJOytVgoLvX7LQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fycges4va-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:44:54 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e7ff7b375so2252827a91.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 07:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786373093; x=1786977893; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JzME1hBKyGBvUEI4XmEOk/d4ajVZXCMyMBXyGj3QNWk=;
        b=R5v7okjAnwtoSAZ4WClj/uO/au+GzgZj+3VWvBdOqyUNVNH9SZ2ql/lopnQfwY+u2e
         4kufjWxwTXHAjHBZuLltlc2gMXSqzMO0za4r212/GmAyHHgsP+aILJc5k8Zl17gYnCrs
         BmtRTCacMbNmWouTJZmIJh0hVpj41kRVL3vZtcV3sjczqfhsf6QGkQDKyLTKrz/ttwMM
         tcxetjixLXra/tXl7vTi/kfgxQK+92yISI3sAdHcXO6erAqjJyWA4Ip7zSimdcyvZBDf
         fqBV0ea0SMgzz55pvLySKVrF0xKEqOjEz4nqIRK2Y0hy3Rdq7Dd7h7WJQCY4aw5Y7Vzz
         J60w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786373093; x=1786977893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JzME1hBKyGBvUEI4XmEOk/d4ajVZXCMyMBXyGj3QNWk=;
        b=SLS9GWizPlLQkwPB4qkgKu9QO1PAoKvd2s5LMfN/+9De8+YyHuhd1ns0EGqoBGXHfe
         41xh8TKXud+nadAOJ6iohLSuTbAKTkJ0I6pAW1ox5Sf60dtLdbVXmtJkQ9Pl6kudF2rl
         rzNX59sMk8CDueAkGwJ/0Ya+bx+JvlYx5xLY2hd8nj/8bcNYHSvZh41p9Obcv8yYUxHn
         Ngo5BkDCMdAZh8b1xiPqM3nVIdNtUfC8hTn/76wRzg4VipeRF24kIXMfeulYDQ3sOSIL
         0AuvMx2DFr2gItr5y/DAqQsD6ctb1+6OELkAHbUhdD/mAzV9jgvMpvZ94ivGJXhfFtip
         4m1g==
X-Gm-Message-State: AOJu0YyYkicc6hXvg6aNOVUYZdz5tbEG/mz6STy0DibgMGBniSPDt4AG
	eQuPrDDVMSNS8JyzykykutHSfUHDuzu1Bk2g2cprkitJNTnclAPaq8v89yQoYPxyalHiCjRVYDc
	H6iu1B2lRByhOnUWmSJ8pmWKiAqysg5l+2/JrXgcWwpUfvFY6mD9+ggkVoUoDdo9j2fbhAQ2jkQ
	ZmZA==
X-Gm-Gg: AR+sD10XOJR7NKSHVvLOBSMhFS1Mhr7hXADTfPJhnOIqoiOAMLhdKw02cp5HMln5pLc
	bYcs6j83zlHZ/DfT/dVWM5HTVPK2xEYVvfF8dpTJzYPsxrRIKkYKuB/7TpKk3hvkrq6/2P9lYDf
	UoP4UiI1/jvnLE0eEKPyqc/BppCZ2Hxgu4TaRlds0XfNFAH8ufObrEMVLijq4iKboa11t/yLjMk
	rVi3LuBW7eNfBo76nGih/2sNyqcXqB7OPS2yrsuOG2AFSZZcFktv/TrOFv8gAPM8/8DXOgOHrQO
	rcFeqx9xRTC/GVZkZRD+IqqZ9gt3vdeSMcJKvFp8n2vVKBp1TB423ql7KopYs0x1ULmP/CxVPiv
	wPJS6PEAA3nbI/xNT8uzCqtHd2tjbhyeSzS14cD0T/Er+VVCi/rhj
X-Received: by 2002:a17:90b:380e:b0:381:528a:808c with SMTP id 98e67ed59e1d1-3909d89bb6emr28802845a91.12.1786373093146;
        Mon, 10 Aug 2026 07:44:53 -0700 (PDT)
X-Received: by 2002:a17:90b:380e:b0:381:528a:808c with SMTP id 98e67ed59e1d1-3909d89bb6emr28802784a91.12.1786373092699;
        Mon, 10 Aug 2026 07:44:52 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3926254ee45sm12797317a91.2.2026.08.10.07.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 07:44:52 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v3 1/8] wifi: ath12k: fix out-of-bounds access on TX stats arrays
Date: Mon, 10 Aug 2026 20:14:37 +0530
Message-Id: <20260810144444.2033607-2-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260810144444.2033607-1-pardeep.kaur@oss.qualcomm.com>
References: <20260810144444.2033607-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: Ia2z5c-H3qqarGZHpfFlGjcddTMyKgU2
X-Authority-Analysis: v=2.4 cv=R4cz39RX c=1 sm=1 tr=0 ts=6a79e3e6 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=l51fLghi-aCFcmm4dtIA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: Ia2z5c-H3qqarGZHpfFlGjcddTMyKgU2
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEyNiBTYWx0ZWRfXywLR2h7QeTLc
 9WbRMF2f5ymsgyVahy7XYQDUvVbCBDRi7Xcjpn6YJCrKKFK2sKVS5+2psuXxuGjX56yUYvlhYxn
 ad85XH4KEXTbzBhF8rl50S/CatfB5Ho=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEyNiBTYWx0ZWRfXwIxf6uoqE2J9
 8WR51qXb9EgZJVndHSxib6OAMgFDR0mJMfY40Jy1662YcrMGs99PjLxm4x1FyM/VtWVt8mUab5M
 2r2WcuqUmvLn6OidR4h+7E8D+UYSzaYignDcp9qBoNDtVuaSZjyY5VT4HGl0oMOggo/1iADjXK1
 SCa5SrpXhagrIsEFnrc0WQ7YmQgOZMQ8SS1pDdJRKN4KPPtLsZYfqzXXvp1O3QCYkzmevqoX9DP
 zoFxCsgpuMFQVGQuXu7l5QUMAsTS9HWckwAAfrLlS38rtRQmjug2s1i2oGLnPe3CTYJZuzMnnog
 PxkrmKcAyqorHp2J+cg2UsxZ/56g3tXl5tBHaUwVW/k8jWxy8QP5NaVhLNbn1H/ILbxm/bHhLwa
 9z3AFn1bsyk/KaWbDTilQHVsuf2td3du2uuI9niHkoWUvrF90Uv6R9mLsaV9o3d/VQHpsHM4jSe
 0bDj6i8vBBJn3YFemdw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_03,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608100126

From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>

The fw_tx_status[], tx_wbm_rel_source[], and tqm_rel_reason[] arrays
are indexed directly by values read from hardware without bounds checks.
Values at or beyond MAX_FW_TX_STATUS, HAL_WBM_REL_SRC_MODULE_MAX, or
MAX_TQM_RELEASE_REASON respectively would write past the end of the
arrays causing memory corruption.

Add likely() bounds checks before incrementing each counter. For
tx_wbm_rel_source[] and tqm_rel_reason[], add WARN_ON_ONCE() on the
out-of-bounds else branch. For fw_tx_status[], no WARN_ON_ONCE is added
since the switch statement that follows already calls ath12k_warn() in
its default: branch for unknown values, avoiding a double-warn.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Fixes: c5c62287e690 ("wifi: ath12k: Add device dp stats support")
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index 587d58eeccfa..3d635cac8f8c 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -582,7 +582,8 @@ ath12k_dp_tx_process_htt_tx_complete(struct ath12k_dp *dp, void *desc,
 
 	wbm_status = le32_get_bits(status_desc->info0,
 				   HTT_TX_WBM_COMP_INFO0_STATUS);
-	dp->device_stats.fw_tx_status[wbm_status]++;
+	if (likely(wbm_status < MAX_FW_TX_STATUS))
+		dp->device_stats.fw_tx_status[wbm_status]++;
 
 	switch (wbm_status) {
 	case HAL_WBM_REL_HTT_TX_COMP_STATUS_OK:
@@ -984,11 +985,17 @@ void ath12k_wifi7_dp_tx_completion_handler(struct ath12k_dp *dp, int ring_id)
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
base-commit: 691e5e43b2aa
--
2.34.1

