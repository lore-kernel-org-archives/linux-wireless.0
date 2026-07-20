Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8DB394793
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784529814; cv=none; b=ibJutKAzOY0PrQE2DhC8UjeuMYkScGdZ4SxUUMoLf5MxdS1ITGLs5smb+S82QoKNxjlM+bUZ9g9qL0Wa1s9Sv2D+O9rWcTYUocXt5Ta5C2L/pstO8P5SPgUqz2WGvMCmQP8nX7KScrkNEEp8DFRn5seF/EIbhZc0+4SLt/c2ES0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784529814; c=relaxed/simple;
	bh=2o9y9Zi9OmwlQIIlWoLdNRV+GUZXbtrrxZklrrhkszo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dJpWP1LMKjgz5TLsYHNrlGY7LW/GWg4rm2SH8Tr82PBTPwdw2IWAeFWxNbFfLagjdG+22hyFUXLdFtDF56n3tuKQYtU3Y/lDgnNhXYBJcR8mBSuNxnV4mBlbPY2FfG11o2Mop/2tizcUP3fF2XuRugC6ZbP8fxeDzvBvy5zmp64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iQG191W6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fYDRsaQc; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iQG191W6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fYDRsaQc"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66K6Rjps1713672
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qRoN7bGojJCnIgc2vmQfLaoan0NtbsUh2lM4erLlpsk=; b=iQG191W62psaUrZl
	6LcroeTmikfWHeUpy7OjMDpMax9N5bVs6MehlI5rN2yEOObCD6tSx/28X3StcHuC
	QsmOlOLB7JKj2jBFBfJrtAM7lSScVqY0ODWwX+BMiB8Tzla98OKKNMextHBWU0ne
	yzsIJ+BskXTLkSfLel+6M8IVUNsnerih45LDR1h0TaXwZp/mfwZe4vTOjabpP8Lv
	rdamhrb70mBoxMQwJLP+WFfjYLwCQ3nJCuM0iSso1QRM3fZzi+yssdRZG7yBJCbN
	ZuUHFkRGgsG6UpBuvqzg9TNRl2FybYQOwyF41yZEEArKZZ0zcVsUDgKlFiGxOy7v
	ql4Jww==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fg2dc4tyf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:43:31 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-848662cd2a1so6982693b3a.2
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 23:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784529810; x=1785134610; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qRoN7bGojJCnIgc2vmQfLaoan0NtbsUh2lM4erLlpsk=;
        b=fYDRsaQcH8TTfNXJzAh87bkkIslhRwhP2NEQZf0cM/1lskD4Aa7xHk5CEZuIVYfB+A
         qpFgerxFHvyoXplmWG/PfHbVgdzOkMlnXHdl7s2xKqP1q+kOYDw3IUYuwAgqlFN9ercn
         kGe5VTKw9QxZ1cKIjtxmbK/vbj7WEplSFklYukj6zNQcBB4+8xgZxVzp+3Gue84MI55/
         BNorZW/Gtz27F3Wou3AAGBaVLsOBemiMdzGnD5CP9UTWkdn2m8cr6gb54MAPXSlGxCry
         N/d+eWUvcQn8k0Kv+cXXjHVEGJWhYNi3lQmYJ0tYOJlQE6h8cXhHCutnF0+P+4xFnEtE
         9tgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784529810; x=1785134610;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qRoN7bGojJCnIgc2vmQfLaoan0NtbsUh2lM4erLlpsk=;
        b=YaNbZGZKK1IXQWd5FMlgluBQ8SNi1sWvTVtl7Mhiat7UpQ+tu6xoaA7yDjG5NEFR7c
         +xplZf3hv6Hy3UiuFnKVFkWLkmK8aWKR+YqhiePoDqWR/VC/oXDnYISGz+DapxMDtTE1
         2KfT06g/HaGTCVa+701YgZpVAvjf/yNBXqVag4zpDpTld7ue3wimKbfKA9l/2Ldkldlg
         KbjlrazdodmHOhUSKW2Ueze/v/d09ogJ25dBi36kPM6x/aFDm+zc8RDWrFsiXRjT5ena
         z7WPlN/2+lTfQQY7138eVClavvkSlwvt4Jd0AgK0iqSXAU/4Ft9KAGlmsDExHrHYfGuF
         VQeg==
X-Gm-Message-State: AOJu0Yy4RscU0rHxj8QNKSJ610B9dPJMhOB+ZCxHEyYIOYhVXhD593ua
	Osp7DRVgHmVmU33VAXLpofMM8Moa619L+waZNgWb5sv3W/Psyfufjt56fqZ4xZtodOJVqIH/tNf
	SXwzQt8yu9zJS+OUxfHZ6hw8bpMx0g2q9vZNuJr/b2RGWpF+FVh9Vn/mtwcvI5x8+MhNccQ==
X-Gm-Gg: AfdE7cnaRprciTWdoOghEKPkhSf/9ysxGJYo5FJwJzT9h5O5fEJu1sTfNbXIjt7mYtr
	T2vIbVZoMpvH2xTJluRIUqdboFOqfp2kPlHvUfaoNyiDXBC3L4q6kpXt0yg1C6xg+QvBOc96vbB
	QBm9uO8BuN3emMmM98VT4nYiPw5HThh+qBgK99L/FNAQPLbacXKyDIHGOnWLSXVK8ugesiqE7+i
	WylJ4mmlz5P8HPsAsDjImOmAqrSJWOt3o9KKTK0NOnR7duFo/+AkbzDYtOzAu2swrVmk+1lhnQZ
	2QQNca6vtkxm3LN47+azTOab2qfC8sAMb9R8MDNJEi9BTr3pVfqhEU3RqtmEk377qnmynaj/MVK
	jf2ayLpsBxwEmJjjIRVDz4RcfWu0CT5hiyFWnhd9YVlfNGbp2IwHtqg==
X-Received: by 2002:a05:6a00:228e:b0:845:d6a5:716b with SMTP id d2e1a72fcca58-84c292736cdmr12076560b3a.23.1784529810435;
        Sun, 19 Jul 2026 23:43:30 -0700 (PDT)
X-Received: by 2002:a05:6a00:228e:b0:845:d6a5:716b with SMTP id d2e1a72fcca58-84c292736cdmr12076544b3a.23.1784529809974;
        Sun, 19 Jul 2026 23:43:29 -0700 (PDT)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c3793ec61sm3812097b3a.42.2026.07.19.23.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 23:43:29 -0700 (PDT)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Mon, 20 Jul 2026 14:43:22 +0800
Subject: [PATCH ath-current v2 1/8] wifi: ath12k: fix out-of-bounds
 clear_bit in ath12k_mac_dp_peer_cleanup()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-ath12k-fw-allocated-ml-peer-id-v2-1-630632758a80@oss.qualcomm.com>
References: <20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com>
In-Reply-To: <20260720-ath12k-fw-allocated-ml-peer-id-v2-0-630632758a80@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDA3MiBTYWx0ZWRfXy2Vcy7IAQJp7
 9h2J/Hh3xPVUvqGrWAp9CJcOQ+PDfz8NiJV+c7J7vwitlABZmwMQcFBxMYDpUFfaX/Hy9g3fNXz
 q10coLFlSTMNyqO4IThNoYAEFTV2sJw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA3MiBTYWx0ZWRfX+g3TRk2zZpYM
 3wTU2orCiec119S++8Fr910x3xgborGEtRk1YfnPl+PSZ0BMhy+AZjMe3V+sajkKCXOUL1C9SGn
 69oPTDY4QOTn7zYKF3549lNe7J63zHY4eTt83DO0Cf1Ib7+eLb+LTeXP92X+OgkgR9fgysfakh3
 1+8m1R3CfhSi3TXLSbnfJ5I8kf4KK0n+J1gU1zbxQuxEQyfC8FDmBTNdpb085XHUnnuWvm6oJmE
 C8wjpylwpslN5/dMkEFuLqieVHqkqdmFXPpOdMJLtEloblQi0aGMgOXmUGSJXckvTAsTSLSjNUw
 0BtHdwaBcRQK0E+s59V7G7EbC9m+HY2e2RGmD9/4DTpj5dC6Fw29VYlo7O6986rjuYvH3prl1ie
 T1XFUkzik/AQzBe8U3iOZCet1Wl70yrSvDQC+yj70qsFgEBTwPnXzaP/EZh2acSE9CqkAX12XON
 o7108qTOvNhyTVSsmuw==
X-Proofpoint-ORIG-GUID: NnURlTVtBHLYMYVo8ijskaKyHROvALLZ
X-Proofpoint-GUID: NnURlTVtBHLYMYVo8ijskaKyHROvALLZ
X-Authority-Analysis: v=2.4 cv=FOQrAeos c=1 sm=1 tr=0 ts=6a5dc393 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=IU88uQVEuTzBCV0X16QA:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_01,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 adultscore=0 bulkscore=0 spamscore=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607200072

ath12k_mac_dp_peer_cleanup() clears the ML peer ID slot on the
free_ml_peer_id_map bitmap by indexing it with dp_peer->peer_id. That is
wrong: dp_peer->peer_id for an MLO peer always carries the
ATH12K_PEER_ML_ID_VALID bit (BIT(13)), so clear_bit() is invoked with
index >= 0x2000, which is far outside the bitmap of ATH12K_MAX_MLO_PEERS
(256) bits and corrupts memory adjacent to ah->free_ml_peer_id_map. The
intended bitmap entry also never gets cleared, so subsequent
ath12k_peer_ml_alloc() calls eventually run out of IDs.

The ID without the VALID bit is what ath12k_peer_ml_alloc() returned and
is stored in ahsta->ml_peer_id. Use that instead.

While there, also reset ahsta->ml_peer_id to ATH12K_MLO_PEER_ID_INVALID so
the bitmap and ahsta->ml_peer_id stay in sync;

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Fixes: ee16dcf573d5 ("wifi: ath12k: Define ath12k_dp_peer structure & APIs for create & delete")
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/mac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 490c134c1f29..b7eba8ea981b 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -1283,8 +1283,11 @@ void ath12k_mac_dp_peer_cleanup(struct ath12k_hw *ah)
 	spin_lock_bh(&dp_hw->peer_lock);
 	list_for_each_entry_safe(dp_peer, tmp, &dp_hw->dp_peers_list, list) {
 		if (dp_peer->is_mlo) {
+			struct ath12k_sta *ahsta = ath12k_sta_to_ahsta(dp_peer->sta);
+
 			rcu_assign_pointer(dp_hw->dp_peers[dp_peer->peer_id], NULL);
-			clear_bit(dp_peer->peer_id, ah->free_ml_peer_id_map);
+			clear_bit(ahsta->ml_peer_id, ah->free_ml_peer_id_map);
+			ahsta->ml_peer_id = ATH12K_MLO_PEER_ID_INVALID;
 		}
 
 		list_move(&dp_peer->list, &peers);

-- 
2.25.1

