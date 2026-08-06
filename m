Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB41435AB4
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 10:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786010845; cv=none; b=DDEnz4LwVvFIrhuh7ssBBgsIlF/BrhKv/sd0mWV7bvQNSFDcG95AZU4VSwZJpIjg0ZSSQZEQfevxKHyjNzWrvR6244mIHID+tg/qfuKKn/sZ6RPCQuprCwYs7Ocl6y0bW8f0sIfKMnzPsBfmbDONh9CD71HM6fpzaTXEOuA8Lf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786010845; c=relaxed/simple;
	bh=12qURBaXe+VHVvlbhm3Cu4vyINZGxaOnV/zbqdV3a/E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YCct1PvvW3s1ab9a/aS5uMWkeZ52jP03MGhHUuutiz4pICBErqcjww2VG3VwHvlNBLZItqCiPlZ7GjEkR9whrQCunhLcJH1uIUMIZkstinL+R3bJqThsD2YsEQPVDuVCMoDECae1CNCrE9mi2l1yNCdv4yVnZI5RCxgIMFjBH1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=P/OJqEJR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SUBtX2mu; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="P/OJqEJR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SUBtX2mu"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769nn031579328
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 10:07:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=YwGMP9ynsxK
	lI/ohrLuFqx2UZfFwtRO5rMgbVYv71W8=; b=P/OJqEJRFIm9QMNzVviDe5tjBPn
	EpPO104l8k30KRclWdOqVy397bmsDUQ36qsV6K/rfuaKrE3KvBlOkt+ih26PDN6/
	4H6BV0q9I2L6bTcaIIOKTLnbnkl5Sl2kOS2wfcbEf6Fxeoy9a4HY8yxOzDv/EvDX
	aQ5nUL5Q5800PXv5OSu/R5Kkl0IBDkEgNOSTGDuWMr4J9kBAFWo1cSnJUX/AaXtC
	c1qZ5jQ8TaS6VEgq6ONAHBT9ANkk0963lMFbvqi8HG/XygD9+mR2+vhmLbrnsmM2
	NxSxSqXaWzL5pbU2p3Y7QpjcEopRl6lUcNPrK2mC62eSmFv8i+U2tA69r/A==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvju8hfdu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 10:07:19 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cec4226c70so34532365ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 03:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786010838; x=1786615638; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YwGMP9ynsxKlI/ohrLuFqx2UZfFwtRO5rMgbVYv71W8=;
        b=SUBtX2muGI+kppMSZxXEeStv6QL/TGnJlZhGjLGm/vQ5QhO+BLsIcNga87q9Ki1tuU
         ekA+OYORy0Q/LoltT1j2o5G4RR6fmPcipfhaosmE9zT2s/uPqLywtfLikKqeJ5qSrkgm
         7dDYCkyAybpAsmkGsLjD03BK/UNTcOFXHRD3rTBOmPlHkImOOZyAwIQqRmR5K41H8bKP
         LHOuo+ZjCUkiXvnOFZ0CJqM9u5WJjOTNW7YAJ9fdKc+fcCgvOfFIjSXhI4qXXyJckknx
         N1MjoPS9x/ORocJ22MAF+uybTu6yxjxB4S9seGogjCtcv/oWqEhHtALyCbT7zkfd9Osa
         96pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786010838; x=1786615638;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YwGMP9ynsxKlI/ohrLuFqx2UZfFwtRO5rMgbVYv71W8=;
        b=W+GDzBd78rsGuLr4SWip/Hx+yICh3X3DTNKuXEprlKxO1q2/I6nSBXOn5gJDwb8He0
         hIZmEGHzgMnPLEI8qvaFiTyx8xNQFmhSGaoZzf4CHQG4N8RLQSCZAMEd66NEQOOk6f6i
         7PMpOWMUv2dEIbalz7+K8IMg/2I9/1fRtxcpPL0U0KEOoE3edjPp5cGIYz70OYdKhd2g
         YFM1G7XtCDynCKtpoVFnfTQuJ3jsvDN8OMxBq1fiCYw+FpHPy51s+ANv21+4afUqKT/Y
         vVXv94nH+gIdriqGnwA2gdnJsPshTZSW6MzCSMV7z8PG6sBaJGzzLvgcigUEdP67k4D4
         1FPg==
X-Gm-Message-State: AOJu0Yx1/Tiis32dKUxtuaaq7+3+2DqHW7olEfwG6ofO0kknJCREHhAi
	ghWuVkgC1f4jJU80oHelmcYta2gvNkOC4hCg0uKx9/qXpqgf9zJe+SBurFC8cEI0dQ+mu2nz5As
	3/7YLHxHMl2RR4nERLwKR711+vsFxR9QIpov75/hKLw5xo5JUTRw6GVdASYw3ouJU9pDkdw==
X-Gm-Gg: AR+sD11b8erTvtmMy2T9CJGam+lotsbwbO0kCi/eqr9Z+cH6bBfT/Gpc1qvIMAJ3VW3
	8qEeiP1CPYcKcMQUvVZt7z2ZLLe14o/6gUVGp90EXgqKgPhVylllJouUc9EvFuh7RfZTp2/c4WR
	fBcEZPY1E1u0+zTCDTis094DbyyinoMVAuMUksN4GA4tPXM25mDt49MjclvcAmvmU1qRYju6cOQ
	mLq9W5wkcyU2YxBQRE3jSb6gyeTF2iaWiHP2spJv5p4qIzQfRSAgBJ2c+Qdv+fEfnyLXDKr3MJ+
	/PLEPKqCevva3PTJHPqlV6Es090SytyKVDQg8wXjd8wW+NugMJA2x7FMXnx1BMHp87oEcsr+yp7
	IRCP4b907R3+7mioV+yKlOjrSoBZqJXNdX/mpEbpH6mF2ttf0X8z/
X-Received: by 2002:a17:903:32cc:b0:2c9:9a2e:dab0 with SMTP id d9443c01a7336-2d0ca712e40mr147464265ad.3.1786010838113;
        Thu, 06 Aug 2026 03:07:18 -0700 (PDT)
X-Received: by 2002:a17:903:32cc:b0:2c9:9a2e:dab0 with SMTP id d9443c01a7336-2d0ca712e40mr147463765ad.3.1786010837623;
        Thu, 06 Aug 2026 03:07:17 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0b6fbf2c6sm24027115ad.34.2026.08.06.03.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 03:07:17 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next 1/8] wifi: ath12k: fix out-of-bounds access on TX stats arrays
Date: Thu,  6 Aug 2026 15:36:55 +0530
Message-Id: <20260806100702.3479326-2-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806100702.3479326-1-pardeep.kaur@oss.qualcomm.com>
References: <20260806100702.3479326-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: Ln5qN4i-gdQHnsnBvtjNmV5i3k1UPDAl
X-Proofpoint-ORIG-GUID: Ln5qN4i-gdQHnsnBvtjNmV5i3k1UPDAl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA3OSBTYWx0ZWRfXwrr7IOgZMZuz
 1rlct2BvB467Ms1oiY3ZQ0E6hg4MkkjEmoqOCZ11vGXOyfZaV0aHZwyhNSs2CHNVPDpgl6Qr1MM
 73qo3knvIOZw4rpHqEveIcsi627/k27Xk3FPAzGsRF1cXjm48uyD0cIj5MSc4Pfuvav7GBIxHA5
 C3xfbK9ULOCfOeZ1aUDAyjqlvAlB7BJx8YgohucAnT60fro6ph0pq/sJQ57k1fG45JxrXopb2EB
 FlM7OWTnbU5lssT2GcbVzxkjhFIlsVM7uwyZ28cVgcemX2sijg1mQSso0vfJPLGnBYUtNtDhYcN
 DILXIRVovpQ0JGenRclxv0ziZMjLPcgc5VK6MLSm2Wp7RJQNscJuhnI8i1humsKrBqbjJ81tZcf
 464ZHJ49EjV5ahkjiY+JQd52DA6yIWBGm/kKKDH8O7LsIGZgWEJcSiDBRsDYh3RpOXlXkI07xYV
 Io1vM3Btyf2YDDLsdKg==
X-Authority-Analysis: v=2.4 cv=K5cS2SWI c=1 sm=1 tr=0 ts=6a745cd7 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=QbJcohpuGl3nbjs-xDYA:9 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA3OSBTYWx0ZWRfX2knV0MdddIXj
 XG2JVXWzqPFDmF3BItrhbVyv6cpl/jX4JqydmQbYmGStv4Nux4nu9BLDpNx6dHtviv+n+S4sxNM
 ZhW974QW7P2OI7F7bxUaxKzHOdM8W5g=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060079

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
index 587d58eeccfa..632230e77802 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -582,7 +582,10 @@ ath12k_dp_tx_process_htt_tx_complete(struct ath12k_dp *dp, void *desc,
 
 	wbm_status = le32_get_bits(status_desc->info0,
 				   HTT_TX_WBM_COMP_INFO0_STATUS);
-	dp->device_stats.fw_tx_status[wbm_status]++;
+	if (likely(wbm_status < MAX_FW_TX_STATUS))
+		dp->device_stats.fw_tx_status[wbm_status]++;
+	else
+		WARN_ON_ONCE(1);
 
 	switch (wbm_status) {
 	case HAL_WBM_REL_HTT_TX_COMP_STATUS_OK:
@@ -984,11 +987,17 @@ void ath12k_wifi7_dp_tx_completion_handler(struct ath12k_dp *dp, int ring_id)
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

