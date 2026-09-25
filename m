Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40515349CE2
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790339211; cv=none; b=SNNyyPI26wBNXn+DZPYG6O+ujxsLP6cu666+2tm5Eywt0dfnVQEQqrbv1QUO0+WCZbbnHQJUzXJ4FrgIm9+dtOkZkmk5iEduBA41WCENLblucVdCCK10Zp2mBe96GFgYQDL9W3xRs6335l2J4ZDeQya/HsImDBzN8S0VVFHisxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790339211; c=relaxed/simple;
	bh=LVgFASRo7F5a3oNBm2BMula0qqWi2OyQWiQDa7dBAKo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PY5kA6onKeQxwVdy/ROlVQnhtaEP6KHqq9vzUneyKNvG7kBhwiSJ6nRp/T8QSMdNQeSOoGA3FkngNqNZElL2+nbQ6bM9hepMxZo+OyBxJ4Ab1ft40TyLWs0ok2xY0u6VCx+LzEp+dgmBlgfLkHwJPZtjMIumROAewjug0LKuuXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hwIJntDx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=eoxBhllQ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hwIJntDx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="eoxBhllQ"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68P5J3wA756734
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	s9XRsPP9WKACEPq6mNyj1Ik9HYcI9okPsPcrUsTmRV8=; b=hwIJntDx1Mswiptk
	Uds0wgBb16Brp+5nbUVCduooqwGrUCHv8puTme9x4dPOngg5hWag5AulSe9lLdfZ
	fzEuevGryY/lkM4M8MFcSzmTO+VlFZrtF9SvWw0Mb/FGl6Iwn5PJ0jg7S812BQo6
	fpVNkHbTAZ9R9+TrJMUK0QfwNBpQl2AH+Ilgm7pHkQyiPAl7ldTgEa5L8+NQCBW5
	CG6S3bXzxgdFyCWQhXdwOuOVkoj9BPPQUNyZxVM5+7xC+RIuEr+DTMMElsM9YV4g
	vftEWABqWGMjNLfSE/vYp6jSC8yEoLGgjv0kGHJaMra0e6MMQJQ98QzuloNS6Y+e
	5HB/7Q==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gwjq099v3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:26:48 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39af92138f9so1123830a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 05:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790339208; x=1790944008; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s9XRsPP9WKACEPq6mNyj1Ik9HYcI9okPsPcrUsTmRV8=;
        b=eoxBhllQeYNAZd4h4DjRgUjXhUpkjgaaGh1gNd7aqb3Mrz07zmL3XQc+iPm5eOKkQB
         xNDTI3HXZlsu6vY9KeVdnatqgGIG1ACy0sFuHOLrhAAdaYnPZj10M6PyUyKKRyJAPqUP
         fgkZglrwr9tBKQ16XrPG+JEfz5aNBkGT+7BSIpmpr4+DKYXwK4OXxD/4WgQpKbRQHmLy
         AkE9/JYAcNmw4dL6smLAgkzlbnN0+Caj2e/8MhhsgKqJRRsX8L4OY2fq1DPqMGDCUS7V
         x+f4eNG+pggWeadC7S0TA00eYLHA2pJQL1ri6cUXozxkr2q0JuUIEkZtPUNjnTozTvfm
         5/nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790339208; x=1790944008;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s9XRsPP9WKACEPq6mNyj1Ik9HYcI9okPsPcrUsTmRV8=;
        b=xWl8M32RJcLqkPzQMd50wbZGQ/aT+GzxOKGAyok6MsOzaEj7RCUjFERDohPyO2+SYE
         EdE70iBFrVndvURXsp4CCJpTX3+6kCs6mLFJ8afhl4D+wSSaDSYntitjt2JVKVilMxPQ
         jQL35WxK60bjHuEgBKvNcifdnXCVhDJfR21SyNB+FBrU37fJRkMq0wLSxmDRKhHiwKDu
         FqioyR4a9alcnm1ojMKn2lqBMQd+iZb6dBDCDHERigU42/A+HrzcNj70ngTWQ8o9D/nt
         PcPZZwvQSIxh/xNrOVLJ0OpOp5cx34booSPFEn/x8lZ/a6Sd2dGVWmyVL5Y/UizELKG4
         9WWA==
X-Forwarded-Encrypted: i=1; AKwUvBz/zgfXRsmpYStlU3fSRLnEfjhG0kXVmjBqPx02Nu4xuimAzYHtg+uQ7dFSHQHYYUZ7xYAK36QEnv2Ef8Ak3g==@vger.kernel.org
X-Gm-Message-State: AFuF++kbmFuIJ7Lcyf6K3AAmOc0Hvg0rBZxJsuEsotnJvgnZJuiqZFlb
	VqZShE1AGW3WOaI1eTbNHWBOXJjYIUxYTq3Zn9mu6lGytc/BjLNwOjPKOxzs0cuphxPEz7QV9S3
	YxyZY9LJa8mKirUkC/6qRocau86udBQ1m/Oc+GGPiodIXeWaJ1WvRHpmvdIfOAomViQiQio/MXv
	0KOJDw04g=
X-Gm-Gg: AYBFou0XJpErs+UfMDBmSz7aNGYtxu37Mh25pG0CL2H86d6WrfoD74tx9tQmlircelB
	2hAgh4EkctxX80Zw5A1rwX6RQeKk0j3qM7W70iyBpoJYM85zeez4pRAihmXh5hUDEsOvD+HUsYI
	FudrGGOZDSL1MNhgd/25tQrv5U5jysxvc2qTVSTiRJwKMraPseGwCsJK15ByC8TcerpfUXcRpOS
	mpZpRTRdns7/tykyb8/J4WopaD1937GQ+9R5W4p5zjj/WDE3ZD23eH3iQUhNdKfvlRZRO+pBDud
	0u9WSrjV8H25Z0hn/owySQwMg1MllKg65Rr7yaKGVPwG/cdF98RxcIkBtewKhLrgudIg7g98QBp
	yK5+M6TaD1oQMlSVQ8EtpaiCKRQhiAJDuDDFODzfRVwxznzwOqD4=
X-Received: by 2002:a17:90b:2b50:b0:3a0:903b:f25a with SMTP id 98e67ed59e1d1-3a098acac80mr3949848a91.22.1790339207882;
        Fri, 25 Sep 2026 05:26:47 -0700 (PDT)
X-Received: by 2002:a17:90b:2b50:b0:3a0:903b:f25a with SMTP id 98e67ed59e1d1-3a098acac80mr3949838a91.22.1790339207251;
        Fri, 25 Sep 2026 05:26:47 -0700 (PDT)
Received: from hu-kangyang-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b998dbf2sm4401671a91.12.2026.09.25.05.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 05:26:45 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
Date: Fri, 25 Sep 2026 05:26:31 -0700
Subject: [PATCH ath-next 1/8] wifi: ath10k: fix SDIO aux workqueue
 starvation in recovery detection
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-10k-sdio-crash-v1-1-14baf913df94@oss.qualcomm.com>
References: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
In-Reply-To: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: Kang Yang <kang.yang@oss.qualcomm.com>, linux-wireless@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790339204; l=5344;
 i=kang.yang@oss.qualcomm.com; s=20260921; h=from:subject:message-id;
 bh=LVgFASRo7F5a3oNBm2BMula0qqWi2OyQWiQDa7dBAKo=;
 b=Zz1nrSVTtjpkrc2ByhmKdsD4QpJqjpC+MRL7xUKO6VMTcXwtLWLidTE9QPNxwu2FRH7989ua5
 2/Dqe+9brDqAGkxQ/JMYti3Qz+EM62Vfmm8gz853ZFTHn2MbRdat+hA
X-Developer-Key: i=kang.yang@oss.qualcomm.com; a=ed25519;
 pk=qz684ZqyU2kfjPKl3UVYeUcHg1oCLfFIhi0n3vK+MFk=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA0OSBTYWx0ZWRfX7bTdVX429VQT
 z7PcZcSXCej8MNUWI1FL8XAE/7kUmPK0l94s6wrxt+cI5e+0K6E4qOY23iDiQWA9n+Q2o2oR0Qr
 qcQ5pGxFZL2hMgIFsjfbBVmQCGCZNSw=
X-Proofpoint-GUID: P_EVOQ7TFIaDuYvA-J2Xco_spYVxdhfI
X-Proofpoint-ORIG-GUID: P_EVOQ7TFIaDuYvA-J2Xco_spYVxdhfI
X-Authority-Analysis: v=2.4 cv=LNPz05W9 c=1 sm=1 tr=0 ts=6ab66889 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=FvdSVOc6Z0cOWoVicyIA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA0OSBTYWx0ZWRfX4NJCxoZGVwOS
 Efvh5ImK09XIryHqE+Kcwvey8qAyR9rDCdPvD5pXNDMeB073ZZmOkTHo4USt5Rm9wzRbnyi0gqY
 t68idnnmnFHaeo4J5ZOp1ILDZFsgME8h51LSquYLIHpWIaFdu3iGrdMe/jwH+CX51dAD6ubOjEr
 RMI5pmJapcSXCP8Qlg+0aGsTZUmN8f+SXpedLdq5wGw66EuIcylUF5xHh5RVveRSGjTQz/xjN25
 XSUM4kKiyDdqldGGcQQaQsL/CvbPuHofS8nUo23SZ9TbWYhPzOUCWHWM6Zi+26wJozgZ9ZAJfYX
 8etJTOkYhj8IDL9oA5Id92msmjyi3OOg1qMnI3fPrJzeHzMpyo5OdVoPEMb6CCdVloKjh55Kxaf
 KreSHoIAgP5cx6c/Zuu9DPj/uv0iQ/K+v7WUtA+BLflpnIQ9kU+jl485hCdZXoWfcDsPSvY9V5d
 MCKfji9V91GiFRd7jqQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 clxscore=1015 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250049

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

Fixes: f35a07a4842a ("wifi: ath10k: move recovery check logic into a new work")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 70 ++++++++++++++++++++--------------
 drivers/net/wireless/ath/ath10k/core.h |  2 +
 2 files changed, 43 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 7c2939cbde5f..ad087e64db9f 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2494,46 +2494,58 @@ static int ath10k_init_hw_params(struct ath10k *ar)
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
+	/*
+	 * Reset fail_cont_count on a fresh cycle so a stale monitor
+	 * from a just-succeeded cycle -- one that inc'd between
+	 * reading pending_recovery == 1 and ath10k_reconfig_complete()
+	 * clearing it -- does not bleed into the new cycle's
+	 * failure budget.
+	 */
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

