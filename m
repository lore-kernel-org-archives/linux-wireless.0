Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792573798;
	b=DLMDI3UG7OJP/T3qKzyM8MnOYOjJsu7QXCA+CO5VC6wAh+8iX7l7uMwVp5n8gMTcG1h+
	 657l+PqL28/qHYSl+i4NYwfz13sLU4/YZJKsAqwsL9dfxJMKc1cBSKzK2h4fEToE9XtzQ
	 DR/JkTy9GMXBd4DKCsi8Ly9kzGbbfLJH4SuURtzXqauO+MB+UrXNwTwDL798aa9L5iKd0
	 eJfclAEsCBeF1ZqmyarzhNcmoGzfX/cOhaKu2HEZ0R6G0EHSqVL61dq2s+eAhSV4gwOYy
	 yDsjThMVNFs3uAIr/vTQug8cRTwlHYB0pt0oOBRq6c1UvAe+1VXwVgiakbFXF0T2ePw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792573798;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=5F7IlOn+wHpmLBy6fLf5kOnI9xug8iEABbhwTUEk5nI=;
	b=zhlQbncfGczLcrDy19A50P/fO6bCtEAjte/zWyMezKVzryU+CaTP3CmO8cddPIbur2pR
	 Sxz+l+HpuCFsdZxeFemTH4+YhUV14Dw+kaurDBTLkY6H7FpFvPpmprCfIp3I9Rg7eNRxC
	 hsJ8M0NeyR761GF3RUxeV+U9H0Y2CVd8/mggXiSGeSpYBrhfHnmNAHgXrnscAMeyT/8Nq
	 vpLZDT1XpiYFiniFvZYkVZDXZFir3IyIRI6Itv67EngBCzcv91MZ6qXf+zCrYKbmAQA6+
	 gPPJgpiCxT6BE2i9J7fq4zUa/WGCoHgN2PqQe+q+Nqhlmd5mZ3AHSITQ12NwXC/pQGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=V6GIuVdy;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Tu1PFHtp;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5319B606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:09:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5319B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=V6GIuVdy;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Tu1PFHtp
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69L5jPuk3573370
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:09:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5F7IlOn+wHpmLBy6fLf5kOnI9xug8iEABbhwTUEk5nI=; b=V6GIuVdyLj48pIuA
	zPLCxfn0QM+Z+de4KDq9R1uskHyqRt/VhFrUjfJZt3cR4mBXJj39mQNYJ84hPAaW
	/wGn5lPuqTq3gPvO0NjvcA7WzhcJaCdwVhCEDoNBiwrJhCvp/kOCpB/2ref7sIzP
	99UZBG1hygSYT6TzVEZus8OlPMGk6NwnpjQgpb+otdse734MYnIoSkTz6vOIuAyl
	nt2+7czxx5Sa51KB6DD9BZP2wqYF8H/VgXosYul302UuIYN55e4ZeSERppAcAYI8
	yDGruEWd0FhEs+HQSr0hZDc810pexaqsPimmjANux5N/Blub2gkRS/7ENQmeJ/E3
	0sEZVg==
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hed9hu5kb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:09:55 +0000 (GMT)
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b26d8d2498so630589b6e.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 02:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792573795; x=1793178595; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5F7IlOn+wHpmLBy6fLf5kOnI9xug8iEABbhwTUEk5nI=;
        b=Tu1PFHtpYhYQufl4F57qkJ6kF9ZTOm3/4NJpce3ihyPEGM+Uu1RuxhYj/oX2hj5RqN
         Y0DeXN2/AdfL9kp1n0Kk2p7ZKCl1QmHWzf1YJB+mZOOlDjgLimZzmYDniuEyNGvmZIyI
         vyG8TvHuXduQ7hjoEjGyXQHfUlwsocIXS+XV6dqtcbEprOv6bIYbXvJ6J6xRgHlJUeL8
         Tp5YrlDvRc42nZWUlMKt3hL/8DC5RxQqJTj9ybPO4SlvkhMnprs9qTaX6Jbn3GRpnm7z
         7WFAMdCHZ8VpJOHLcf3vDi0tM82jYnPxRDT1b0Q6+/C3fj8EgIP+VOA249apoy3KN0NJ
         YQAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792573795; x=1793178595;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5F7IlOn+wHpmLBy6fLf5kOnI9xug8iEABbhwTUEk5nI=;
        b=VYHmksxw64Gvjjq/5naZPUjRuQC2YQZocDY4O9sVQFFoSuvIk9V7hbl4xS9s4MvoJR
         ipSIyVjPVp6/+hlb/MjzoMWFu0IAXnLi6mDBIj4iXfZfi5MT42UHtab1LTjl0WICd90O
         ZQ+bNDpUQ+FFCxP6t3skWoQdgPJZov6/8uSmejLR8TvaECvW4kyZXCRn+lYLLlsmWfN+
         JFhQJ44c85m/sx5kSMBB/BkXa6cxXtJkuIHBWB1cGHBaegmDX034+j0o2GlvO/DWybD+
         TgD1DuaRSOiiUC/xtt7lgCJMdQ0almHJm118Nt7RN5dqtJIAmfN0xhq4bKdghHa0uUfJ
         y4PQ==
X-Forwarded-Encrypted: i=1; AKwUvBwSnSwfmvbC4MQ48r0xzNa0hQhHcBRCX1fi7j0UuizC6gpoVn5CAY47XulV8H/AZOnjf6DcE7EvFUelOHPdBQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYKtn3by6QUC8IEYS0DQc8fuslWEaNhaIMceR4Mu7t5YdtJcI0Wn
	jSQzGflBfM1QTS0cU4yCSkxzoHROGr9xG4joKSm4HiF9Lc5fcc8TKLTDWPv2Ozc4QPkXuqENNtW
	ImTPXPjSOYsFNuCPp4krfy8oSQlxOvK3jGBzMzoueDBZTH68oPRhvQBXwASummkXhl8m3TPADb4
	QoTSb1
X-Gm-Gg: AYBFou3rO1BJ3brD8+JzHENt06Xjalg/cvoJ4cpEOw8o/SmTOqXqd8AorXrAcs8AX15
	aBAjhbRu2B7wTAr7K7E7Dnp5IT7TljH7zFMmWiMcmBVoQ6sU/djLWvcI2FWO6WtrjivhqUZgRV+
	bBVaH2wbUsPmLJqf1nPP1e5pxF/lLH27M7Pinjzll/PFKbywhdVI3HOio15SwyJq3tRHXPUKL3G
	1VCbsvuB+T6PfPhatbvaalXZsl2nzZVfIE3LMRUNGn/Zugl33yV7SZhxMxF0sEr/kCvU5N+snH/
	U+6snRJDNPN8WcaEyKwX5Ukir9NG3JjgKPH/dMeCnxoEc7h0NEkz0fX5eIk43W/iIS34SLLxDu9
	UNChSaFk7p/TGePK/FMvRfQcM2yfafdAks4n28uzpVfraCfK2Ag==
X-Received: by 2002:a05:6808:1a0d:b0:4d5:27da:a494 with SMTP id 5614622812f47-5536254f291mr774448b6e.46.1792573795273;
        Wed, 21 Oct 2026 02:09:55 -0700 (PDT)
X-Received: by 2002:a05:6808:1a0d:b0:4d5:27da:a494 with SMTP id 5614622812f47-5536254f291mr774430b6e.46.1792573794833;
        Wed, 21 Oct 2026 02:09:54 -0700 (PDT)
Received: from hu-kangyang-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-552a182d59bsm1554595b6e.0.2026.10.21.02.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 02:09:54 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 02:09:29 -0700
Subject: [PATCH ath-next v2 1/8] wifi: ath10k: fix SDIO aux workqueue
 starvation in recovery detection
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-10k-sdio-crash-v2-1-5df80bf16e86@oss.qualcomm.com>
References: <20261021-10k-sdio-crash-v2-0-5df80bf16e86@oss.qualcomm.com>
In-Reply-To: <20261021-10k-sdio-crash-v2-0-5df80bf16e86@oss.qualcomm.com>
To: Kang Yang <kang.yang@oss.qualcomm.com>, Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792573790; l=5192;
 i=kang.yang@oss.qualcomm.com; s=20260921; h=from:subject:message-id;
 bh=3Qvk9OIDyUsTcNIe2E6YYBLeFS5QkCqczUNU9XX2Ltc=;
 b=/O3hXTgsWHEdzcy23qkDooJoPrVrXISYeUkF8n/JJVz2iG+8pFgdWFao923KHmgVaUVmdFilg
 OPjRpKdTUPQDvG6YXgwiwvXrK0vHlt6MgsLFS6quiCjEGdPyC9DsQXy
X-Developer-Key: i=kang.yang@oss.qualcomm.com; a=ed25519;
 pk=qz684ZqyU2kfjPKl3UVYeUcHg1oCLfFIhi0n3vK+MFk=
X-Authority-Analysis: v=2.4 cv=YuKa1IYX c=1 sm=1 tr=0 ts=6ad88164 cx=c_pps
 a=yymyAM/LQ7lj/HqAiIiKTw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=FvdSVOc6Z0cOWoVicyIA:9 a=QEXdDO2ut3YA:10
 a=efpaJB4zofY2dbm2aIRb:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDAzNiBTYWx0ZWRfX2+4l05IqLLq9
 CtLo8uGv2HTkcCsEa/ZbeqRm/OrKo2FmC5aKn/PE7dTelbZafmDp/1bDc60J5cUt/Hj9Uedmo5s
 +OxTIV/YyuiqMVZJQ2aVzXxhXo5LWkA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDAzNiBTYWx0ZWRfX2jDXhyzSce4p
 JGSZFRSZqu81dAriX3v61+yOR944OWCweAJzg8PZ6LcZBcjOUk/wjy0bGacZuSPyzQZJGtajBsH
 yvjMGd3Y5BZXBeXgdchXpCXLD+mmN4GVKYd2UxcCV4HcmUn9p/STrV1zOROj51H0uNNo4gu9580
 Cnsz5681by3ZJPIqqqogLkYdYbcrySh328j9kM2i5d7n6s298ZNyzMBDwk2GbIUxO2/OOIeY6R2
 JRqhh6dmLJp1oMLJ5hHhARq6H6W+Hce/x6kZ1cQg5AR9p2Hjhj54LE/0Y9nJlrRtnPlgbqDKKvD
 Cw/meRzCctt+md7RNBg/C5eFWSihy6FpBjOWxr+xdvM9YfPkERP7sLBbfjCpVtZAk8CJ9XjbAgB
 YYuioo+M2ac/m10yUcMzmLuEyPz3YwlH01gSL1favLIV6IieCt8lNovvAFdSNxR/UdupyZuIPAL
 x2OlwKX8L+LcFBZegEA==
X-Proofpoint-GUID: uDf1hiAZzunE8pzT5BxSArVJhuwSXapF
X-Proofpoint-ORIG-GUID: uDf1hiAZzunE8pzT5BxSArVJhuwSXapF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_02,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 suspectscore=0 spamscore=0 clxscore=1015
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210036

Recovery monitoring runs on workqueue_aux, which is also
used by SDIO RX dispatch and WMI SERVICE_READY handling.

A single firmware crash may generate multiple recovery
triggers. Recovery detection currently handles each one by
waiting for recovery completion on workqueue_aux. On SDIO,
this blocks the same workqueue needed to deliver recovery
traffic, preventing recovery from completing.

As a result, otherwise recoverable firmware crashes fail
with:
  ctl_resp never came in (-110)

Treat duplicate recovery triggers as part of a single
recovery attempt by gating recovery startup in
ath10k_core_start_recovery() with an atomic_cmpxchg() on
pending_recovery, and by making the monitor path check the
elapsed time since the attempt started instead of blocking
on a completion.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1
Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00189

Fixes: f35a07a4842a ("wifi: ath10k: move recovery check logic into a new work")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 64 +++++++++++++++++++---------------
 drivers/net/wireless/ath/ath10k/core.h |  2 ++
 2 files changed, 37 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 7c2939cbde5f..07beefa06c4c 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2494,46 +2494,52 @@ static int ath10k_init_hw_params(struct ath10k *ar)
 static void ath10k_core_recovery_check_work(struct work_struct *work)
 {
 	struct ath10k *ar = container_of(work, struct ath10k, recovery_check_work);
-	long time_left;
+	unsigned long recovery_start = READ_ONCE(ar->recovery_start_jiffies);
+	int fail_count;
 
-	/* Sometimes the recovery will fail and then the next all recovery fail,
-	 * so avoid infinite recovery.
-	 */
-	if (atomic_read(&ar->fail_cont_count) >= ATH10K_RECOVERY_MAX_FAIL_COUNT) {
-		ath10k_err(ar, "consecutive fail %d times, will shutdown driver!",
-			   atomic_read(&ar->fail_cont_count));
-		ar->state = ATH10K_STATE_WEDGED;
+	if (ar->state == ATH10K_STATE_WEDGED)
 		return;
-	}
 
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "total recovery count: %d", ++ar->recovery_count);
+	/*
+	 * Pure monitor: only ath10k_core_start_recovery() starts a fresh
+	 * cycle. Bail if there is nothing in flight.
+	 */
+	if (!atomic_read(&ar->pending_recovery))
+		return;
 
-	if (atomic_read(&ar->pending_recovery)) {
-		/* Sometimes it happened another recovery work before the previous one
-		 * completed, then the second recovery work will destroy the previous
-		 * one, thus below is to avoid that.
-		 */
-		time_left = wait_for_completion_timeout(&ar->driver_recovery,
-							ATH10K_RECOVERY_TIMEOUT_HZ);
-		if (time_left) {
-			ath10k_warn(ar, "previous recovery succeeded, skip this!\n");
-			return;
-		}
+	if (!time_after(jiffies, recovery_start + ATH10K_RECOVERY_TIMEOUT_HZ))
+		return;
 
-		/* Record the continuous recovery fail count when recovery failed. */
-		atomic_inc(&ar->fail_cont_count);
+	/* Record the continuous recovery fail count when recovery is late. */
+	fail_count = atomic_inc_return(&ar->fail_cont_count);
 
-		/* Avoid having multiple recoveries at the same time. */
-		return;
+	if (fail_count >= ATH10K_RECOVERY_MAX_FAIL_COUNT) {
+		ath10k_err(ar, "consecutive fail %d times, will shutdown driver!",
+			   fail_count);
+		ar->state = ATH10K_STATE_WEDGED;
 	}
-
-	atomic_inc(&ar->pending_recovery);
-	queue_work(ar->workqueue, &ar->restart_work);
 }
 
 void ath10k_core_start_recovery(struct ath10k *ar)
 {
-	/* Use workqueue_aux to avoid blocking recovery tracking */
+	if (ar->state == ATH10K_STATE_WEDGED)
+		return;
+
+	/*
+	 * SDIO raises several triggers within microseconds of one crash;
+	 * only the first winner starts a fresh cycle and stamps the
+	 * deadline. Losers do nothing while the owner runs recovery.
+	 */
+	if (atomic_cmpxchg(&ar->pending_recovery, 0, 1) != 0)
+		return;
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "total recovery count: %d",
+		   ++ar->recovery_count);
+	/* Start a fresh failure budget; the last cycle may not have completed. */
+	atomic_set(&ar->fail_cont_count, 0);
+	WRITE_ONCE(ar->recovery_start_jiffies, jiffies);
+	queue_work(ar->workqueue, &ar->restart_work);
+
+	/* Start monitoring after publishing the recovery timestamp. */
 	queue_work(ar->workqueue_aux, &ar->recovery_check_work);
 }
 EXPORT_SYMBOL(ath10k_core_start_recovery);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index dfee432615eb..c739fbadc8bb 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1215,6 +1215,8 @@ struct ath10k {
 	unsigned int recovery_count;
 	/* continuous recovery fail count */
 	atomic_t fail_cont_count;
+	/* jiffies when the current recovery attempt started */
+	unsigned long recovery_start_jiffies;
 
 	/* cycle count is reported twice for each visited channel during scan.
 	 * access protected by data_lock

-- 
2.34.1

