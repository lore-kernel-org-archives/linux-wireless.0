Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6594438024
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 10:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786010854; cv=none; b=fN3+VT9PId4RoOCpK8AvV6LATV+oh+bRhvTaO/EyK5yc0zDcYB5A1tb9Jr9fq0OBfMUr0EarsqnRlFv8AG8K2hKigNRDwHRSfuDB/3RZ4HStRH+f496QPTZOoTiZDVa6c3aj1s6yKbc9ZiF3wmdNYHQ/KsLO8MTlTa7Q5BFL2zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786010854; c=relaxed/simple;
	bh=zkIyrD0LtcKmokmX7wJVEdwobsTHp2ekxdppZlTjbV0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l1krztyVoP6GLLYbKJWZ2Pced0bpLqiGI5ctB4JyUoN3rhwcRE+cn13QpknBL57TPchmDXUSEiTKA6sojboU5J5bjKUFHvqq6o1bx5OlB1MHPII8y8E9hy9BQ41suNFMoSqj05cFfMEDfQYFnQ0Ie11H7F/yM0puid9jHH08O5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QFfOvukj; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HjYPejSm; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QFfOvukj";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HjYPejSm"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769nsmh1871574
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 10:07:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=NA8MWFLnRkH
	6OIWjAyG2+978gj5PqzR5yRejjiikDww=; b=QFfOvukjNMVxOIuIQofvBCBa45+
	HGKkd5XpEcRvwi7ZhbvhySTiCkWqWvk7l/YQ8YbZclgZF5ei5jW+dhkIW6PrRKAH
	vmWIUN2YHKt0vhyu2jCixgZVnwVyw7f0e0wiJqyfht+IECPLM2vkY3MbhcpZi5ll
	03xdnrZbdoKGuzSYJJaspTRGoRg+95yhq2c1UfNT6VhnVClVIUCHUtZiEhh1c6Vp
	1fVPXSIqg9ZKGEBa3P1hANFX3yUICMexPVGAqAgnf7Ins91GXcydvmAaHzsxWc98
	WK4H6ebolhUOa54855D47IIIu0dt47RisesN+6FReb2kK1ksQezTSzbegBA==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvjud1ewj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 10:07:23 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cc640dfde3so24438925ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 03:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786010842; x=1786615642; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NA8MWFLnRkH6OIWjAyG2+978gj5PqzR5yRejjiikDww=;
        b=HjYPejSmH66mQq2WMAdYtB5gKour4zHzC60dyXUnu9UvZ+LF5hi830LLnJ6CJDWkdz
         U8HaWRcgRH5dz3CR74viZOdMJ7Qrdr51vadmXVz9a+3o4hip0PpkNfsVcVqX+6JiO1RA
         1HPaPlVDuhAw+E6dKF5+H8HlbQ7wiCs3aywfnUrC12J4VtQN9WXxxzOcoA8DcREedVi0
         mbVRXNv8ghnm6fFdtzUD4kRcOb8aT0c6UAz5eAbcQSPMpzZe+k9Irt1k5ugbA6HNuC+U
         ZDPP30cSOdzemKRyqbIyBRAhrjNDZiVLZLvdB0fzh3Dzn9+O531TIlp3c737pNHOHwQh
         RqNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786010842; x=1786615642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NA8MWFLnRkH6OIWjAyG2+978gj5PqzR5yRejjiikDww=;
        b=mUrsjUta/FXX5CmjnOwH04ieVc4WsX4y0yKEhOpwNQ3wNyxl3I98sEXJoPAKDXceGN
         Yxj/CE8i3R9PJdISJZb5M4PdgP93Wqy4k8m433hojTHDo+GrM6viAGtgZXoT1fJTb38F
         UetulJe44CTJwkH+6tyWQfPh3w/q76J4cxXn6zDjHVe3cD6DiFLuEwRhvEBe/5kZrfIx
         rqCU/ghzDu80nNM2lrl0FNO9ZsFtAq/vANH8PQazjql+lcJNwUZs93jQt3N2LjFQEPli
         FjZ9wfkwfqipXDX6mtPaxRH/O6MWSLWGma2UWnryFlFZMW30k1sLEFv6emFczmztZXvE
         rFxg==
X-Gm-Message-State: AOJu0Yws1Ixn050lkN2pDo9kPVbU1XtHBLY9y+60Sy4cig86+lPSpkLT
	K3kb/QP2zu8y3gwhQQnyt7jYqoox9BGLR1aeNWxWQNZoV2OGpSiD40jFWgZW5wENCrq5spdMS9C
	JKzc9nrzXuD8yC522h5EGqwCt9cwwbyIpuhAmfuTESR3r5Tb385Nye6qvoDCuyhyIh1jNVxnhfZ
	u/Dw==
X-Gm-Gg: AR+sD11EwSEr+q8flQYKrGj7RcHjhK2j1KyaZEo15B9asm7B9xFHQvcfkKfJpZVFmN2
	LeKQ0Eq8FnlC3nxBJNdNAGrhFFcK4UJG+V6IUmBlf+Nb78ZfDeg8tfg6cBIo2kJ7Vz15aOv0XZb
	+H741WaDpFJGU2JHP0VxCgwQQUVOEIoPGBqMfAD6MZGEn3Xx1wKg6IgfMfupWSN4ii6r9WNu5o0
	3j3em6aZIl1lkJf77GkW5GPuYsaqZgBrj8rV/eh2cC0TBzUku9QcnHB0ZiN58kLvvungxQ4zrie
	SU1YI7FJkWnJ6XbkH/ieP15HF1YrfIIGJuYArA2SE0e/9qmX66RQkwfmP6HVKXe0MD9lHMBnEc+
	gLTRVD3gs6a5eNfaLYKeZQsIr7Tc0AqcMPZ8Li8uLTujWr4baix7B
X-Received: by 2002:a17:902:d548:b0:2c9:e846:a57e with SMTP id d9443c01a7336-2d0ca15a0bcmr166585565ad.0.1786010842464;
        Thu, 06 Aug 2026 03:07:22 -0700 (PDT)
X-Received: by 2002:a17:902:d548:b0:2c9:e846:a57e with SMTP id d9443c01a7336-2d0ca15a0bcmr166584825ad.0.1786010841983;
        Thu, 06 Aug 2026 03:07:21 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0b6fbf2c6sm24027115ad.34.2026.08.06.03.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 03:07:21 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next 2/8] wifi: ath12k: rename wbm_status to htt_status in HTT TX completion
Date: Thu,  6 Aug 2026 15:36:56 +0530
Message-Id: <20260806100702.3479326-3-pardeep.kaur@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA3OSBTYWx0ZWRfX6oknYjTHjT+B
 QoftzvIldQFtd/lRUmpdSnDfMYt/xixmy78Yo8bOGqsxdjzq+o2i4m9eQ4kx/Y7qZE5ufXPjNhR
 TxU3PeZ5/8adNIFmWf4H2wX9rot8tBf/YXlSVyDju/dxS2pBjF7E3XeNRcZdJOoUttChwlWKKnG
 8fWbR6Lnn45hnyC9kjp5soPoyBziAjrUFUDtqQTrp0axfbOSo1aIKsWG9WxHJmxv+HWnDCP1slr
 wj2XxRHJFrWD8GuqMDbAsqWNr7vm2bXEZ1Y9JPRGb7tt7zmGONU7wQd6PXKeSVV/Qh4NpHQ61oB
 P35YeTVjskoQ+5qqSFkXjwUHwobEG82J2z4GL03CNqpsmRayfKzfnSjxHTFH/zT/+wuT0nLLKYb
 0rYsYC/X43mQQ5EwFU49cIR3N63lpGkKxqoNeeYgPyUC2BzMzoDfMmUW/DIbBGf8iIHj9EQ92U9
 rBI6EG8P5TvFZfAdC4g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA3OSBTYWx0ZWRfX/JV+BQWe+gzs
 QbWaewoG4Fxn1zMIRzDNbpA7hCqQB8E/KjKU/S0xxGwzTtNDkRT4+fy7FIlX8zDErgG8JpZYoS/
 stnu0z4+Gftd37JZeg8o11QWBcNb06M=
X-Proofpoint-GUID: ojPCgJpMkg7af-IxEqrTwOk70OaACwMn
X-Proofpoint-ORIG-GUID: ojPCgJpMkg7af-IxEqrTwOk70OaACwMn
X-Authority-Analysis: v=2.4 cv=DeInbPtW c=1 sm=1 tr=0 ts=6a745cdb cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8
 a=RuwI03aZ9ZQFnXGR-2kA:9 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060079

From: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>

The variable wbm_status in ath12k_dp_tx_process_htt_tx_complete()
holds a value from the HTT TX WBM completion status field, not a
generic WBM status. Rename it to htt_status to accurately reflect
the field origin and improve code clarity.

Also fix ts.acked assignment inside the HAL_WBM_REL_HTT_TX_COMP_STATUS_OK
case to use true directly since the condition is always true within
that case branch.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Signed-off-by: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
Co-developed-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index 632230e77802..d46a3d14f018 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -575,21 +575,21 @@ ath12k_dp_tx_process_htt_tx_complete(struct ath12k_dp *dp, void *desc,
 {
 	struct htt_tx_wbm_completion *status_desc;
 	struct ath12k_dp_htt_wbm_tx_status ts = {};
-	enum hal_wbm_htt_tx_comp_status wbm_status;
+	enum hal_wbm_htt_tx_comp_status htt_status;
 	u16 peer_id;
 
 	status_desc = desc;
 
-	wbm_status = le32_get_bits(status_desc->info0,
+	htt_status = le32_get_bits(status_desc->info0,
 				   HTT_TX_WBM_COMP_INFO0_STATUS);
-	if (likely(wbm_status < MAX_FW_TX_STATUS))
-		dp->device_stats.fw_tx_status[wbm_status]++;
+	if (likely(htt_status < MAX_FW_TX_STATUS))
+		dp->device_stats.fw_tx_status[htt_status]++;
 	else
 		WARN_ON_ONCE(1);
 
-	switch (wbm_status) {
+	switch (htt_status) {
 	case HAL_WBM_REL_HTT_TX_COMP_STATUS_OK:
-		ts.acked = (wbm_status == HAL_WBM_REL_HTT_TX_COMP_STATUS_OK);
+		ts.acked = true;
 		ts.ack_rssi = le32_get_bits(status_desc->info2,
 					    HTT_TX_WBM_COMP_INFO2_ACK_RSSI);
 
@@ -611,7 +611,7 @@ ath12k_dp_tx_process_htt_tx_complete(struct ath12k_dp *dp, void *desc,
 		 */
 		break;
 	default:
-		ath12k_warn(dp->ab, "Unknown htt wbm tx status %d\n", wbm_status);
+		ath12k_warn(dp->ab, "Unknown htt tx status %d\n", htt_status);
 		break;
 	}
 }
-- 
2.34.1

