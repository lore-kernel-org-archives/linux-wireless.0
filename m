Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C8B3CCA11
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 07:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785309523; cv=none; b=rnrX9JNy2cizywpLAY6Or0yrrC6Qp6t59Pt27eF4Woh5NkQjTNRP9OACrxhWVvChZfLgMuZ55feZ8Fn81VZaqpp88OS6t7+NhCd+X2yEd8EP2oXPzrg6NgQu3Izbc8nCZOlz0aIvkHurMJVlCVK6+CmyqvdqVD3HbMoxOtiqN9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785309523; c=relaxed/simple;
	bh=6DL5gUV/KCusJU3Wrx8NLq2t1UUqe7vLzlv3Amy2pHg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WQ2Ul+CyWaQsrBLKlx0JwssXApiIrSFk3kC+JDSph8Z5ETLLO7VGWdXC2v0XKkLnKdOckYq6FHd3o8/zTNiy/W5CdqDBsixg3dJ5lrpld67jd5sGkDIpRqaJu07/OCbFfzdk2HzirKfSEG28qv6OSBwAgNOUW0tK4I1/rOhUvLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DMyFrFTa; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=L0L52dfd; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DMyFrFTa";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="L0L52dfd"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T5hpRF677262
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 07:18:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5ny0swmE7MmuvYquYFpfbom/etRJNh+llibZoszEySI=; b=DMyFrFTaHPGui9GW
	4dRbOZh8CsrwNWcC6T013tJCfGXi7hSQG7uoeUpYS34MztU97PA/s36KAZT7y2Gg
	CYFJbKps4QkaIAGki0mbjXxPFh9QcVWoFNBEsWaDIjCVooh05UwCCyYimJT7y3ri
	qErKZBKh6eh8/O0ohgO59b9VUCZSfar4HY9yS5q+j3BpBxEYKak+ullmBg0L9RBe
	ctrj66tbnUtjrP6tUiGdAPgxk2A07uNl6IFcTWV+BiMfkonTYAX8rVPaHjml/PMA
	gbeSemuwoYngyGpeSxMDO1XzD9zyMoQ605IOM3zlxcOZryn5+ix5Qi+K2IO425u6
	KtCHYA==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqbmm0b9s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 07:18:36 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb74d5db64eso685911a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 00:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785309516; x=1785914316; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5ny0swmE7MmuvYquYFpfbom/etRJNh+llibZoszEySI=;
        b=L0L52dfdU20cwlRmdOvghFs8QVV0zXkixNRnnLNaoreLnPXV+I7TPxSAgqgRydLZTd
         TfDGkck7pvdiy9fankm5x3+fwgmudBXacVTAdk/LHL/wePSlzbSGcSGE/CvARjeNoN9Y
         tHycerLlR5GgMvC+FwPnSqiWYeOw3ZasUf/tT2Yt0iahMI31Z8qYngxKtGzLeWka940Y
         4oXjADYsZtmUpUhylShb3FFk0o/8rdol40ZWvv2xixN3moqj6Nbk7SZbGzmlNFixkfQz
         v1LS7pCLxaqaK/TT115AOCc1UwY/fxB0GDF5cfl6IWxXqNudzVTOzyt9bUAUoIdgdyVU
         eVBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785309516; x=1785914316;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5ny0swmE7MmuvYquYFpfbom/etRJNh+llibZoszEySI=;
        b=l9vBDmTJ1bZidNx9rp0VJlCkKQknA9husB2nCgy7yzqGLs/KLu46lIY+/js3SfU32r
         ugJmU3c7ZLvRtqObv4/Aa9gQIAc0MEbM/zZrgITYry02D7qlD/rqtklp4/cdyH7169sR
         67745gcWRqc8NcLcaZOa1kcAdffeeBs+EsaLyBf6R/P3EWJTuYHeIPYyWzWFO7urKfjD
         56INaKoYr6GVQ5sx5XGbE1AcERML+eozeE9LTswcmjZzpISRn5wzq31EHOXz/uKISq2a
         md+Y39UGfE2tyqjVTYYghoHOAkA8Jx26Qg0Zle8QonrHzV6W3KjoL7SJyHkZs/2SXMg4
         uFzA==
X-Gm-Message-State: AOJu0YxXi1C1UOqNQIKlQniiy/grcy56fcYfdXhfLntMaOCS8bLZ9Lif
	y2e7aOecSKr9SadLPJ0Z8b+J0geBRwITCi42Di4Rs2qrz8gbrWJ0yTOLNrm1XOK2YkzaB7Z9kKo
	wHO1Cqcse3qwawjbFU10CVYtpIc9ePB+khh6pgAb2Imrpxa6pCJM+/pFNn5qbMHw5cu2vJQ==
X-Gm-Gg: AR+sD11hm1FsjYXiDFYUjjv8mj5HTADT9++oEelMSdXtNzjvMyvOsir//JcESmsRKT9
	nYb9zPtGOTc0SOV/TsbmKBZKsMvDS/1as84Ho6l+MTQiosPHVQ3mZ+n7BX9mooG8K+4+KQQV7dI
	qDDYNeaDyAokeXF+m65sUrNOLSZgtIeZO7FCCH31fB/mEM8ivAND9RwJw4WlIEHxDl5DxjSSTdR
	Gu0GauVBmDWlLw8RspMsfIMWBp0PwvGE6EBZorCb+GAUZgeQ0aKlD1Z2o/qEgIqfKPtzJmZBiZp
	RWYEjOSxcRJ231mWWaiSgGUBkxy4yD6BdqvCucgyjlfLoLzgLK4ZqCetqNYe94stE0pIpSbi+59
	ON472C2DUOCehG3VIX/WBhqf2SGeqa1dXWRVaf0y71fN1kLB590Kf/g==
X-Received: by 2002:a05:6a20:1d98:b0:3bf:e2dc:bc85 with SMTP id adf61e73a8af0-3c8ba5bf3dbmr6517781637.40.1785309515931;
        Wed, 29 Jul 2026 00:18:35 -0700 (PDT)
X-Received: by 2002:a05:6a20:1d98:b0:3bf:e2dc:bc85 with SMTP id adf61e73a8af0-3c8ba5bf3dbmr6517749637.40.1785309515426;
        Wed, 29 Jul 2026 00:18:35 -0700 (PDT)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbdb78ae98asm474793a12.1.2026.07.29.00.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 00:18:35 -0700 (PDT)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 15:18:11 +0800
Subject: [PATCH ath-next 1/4] wifi: ath12k: signal regd update completion
 when reg event is dropped
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-ath12k-regd-wait-timeout-v1-1-504aa6e7e93c@oss.qualcomm.com>
References: <20260729-ath12k-regd-wait-timeout-v1-0-504aa6e7e93c@oss.qualcomm.com>
In-Reply-To: <20260729-ath12k-regd-wait-timeout-v1-0-504aa6e7e93c@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: qNGmIbkxIOGzwqOG9YMYucNw7x8x22xU
X-Proofpoint-ORIG-GUID: qNGmIbkxIOGzwqOG9YMYucNw7x8x22xU
X-Authority-Analysis: v=2.4 cv=R/Uz39RX c=1 sm=1 tr=0 ts=6a69a94c cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=Bb4tyEC6cNv58RkMtAsA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDA1OCBTYWx0ZWRfXwF6JrAqDmitL
 OJrWci6qE4Ez4zq9BEm/gV8h1+Iw2UozOuTTbSw1+6KxAc2WEfwl7pVNyWfqaEiGmBZxSSsNHrm
 iRbx/us8IxGimMvloin1EaVwZeviZ6GYv5wccDE3ERo7VEzpBvc4cc2X1akzedNSbOiNp7enm3I
 2OZf4BKPT1ozkRpuH4wv6YQW/MDCIzGAUKkAN+8kBoT8dNMB8IRhKiJv3LflAx4HaQGHuGM/0Xk
 PyEFOIpUG6kSefWV91f5LzzA0iz+MafY9axOW/cD7Rm+5ktbFZIHHiyHuoNXgQHeAzGvrcbh2Ij
 pZZvDFY+och5UOoHZnTnFTK/L8lqZcqUMvtL/0VJLe/JqaQfCNat7ATWHfj+jqJkkx01uaOLP+F
 FMzj5KDFIa0ByF+X2A/h/oxu6KKssWZugQV2uB2FjYKfXs78J5dNXuZaXZQs4d1GDMxKDwJTWhV
 K00VX4/Xy/pIlpYhz0A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDA1OCBTYWx0ZWRfX85+g9gPc+QqO
 g+pX53emNsyUVGqt3sfWQig7cEArW6NGkFYVeF2PBz4h7cuGimFQdbOkQ+wydAje4vq5fWKhobY
 5xgqYawrMATIkPaD0ys35gtNZXBDJb0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_02,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607290058

During driver bring-up, ath12k_mac_hw_register() reinitializes
ar->regd_update_completed and sends a set current country command to
firmware. It then relies on the regulatory event from firmware to signal
that completion via ath12k_reg_chan_list_event().

However, when the country being set is identical to the one already
applied at boot time, ath12k_reg_validate_reg_info() returns
ATH12K_REG_STATUS_DROP through the "Avoid multiple overwrites to default
regd" path. In that case ath12k_reg_chan_list_event() jumps to mem_free
before assigning pdev_idx, so pdev_idx stays at its initial value of 255,
'ar' remains NULL and complete_all() is never called.

As a result the reinitialized completion is left unsignalled and the next
ath12k_regd_update() waits the full timeout, printing:

  Timeout while waiting for regulatory update

Fix this by assigning pdev_idx from the event's phy_id right after it is
extracted, before validation, so that the drop and fallback paths still
reach complete_all(). Change the guard at the end to check the index
against ab->num_radios so that an out-of-range phy_id does not lead to an
invalid pdevs[] access.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 906619a00967 ("wifi: ath12k: handle regulatory hints during mac registration")
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 2b707ffc1a20..e9ec56a0e8db 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -6964,6 +6964,14 @@ static int ath12k_reg_chan_list_event(struct ath12k_base *ab, struct sk_buff *sk
 		goto mem_free;
 	}
 
+	/*
+	 * Set the valid pdev_idx before validating so that, even when the
+	 * event is dropped or falls back, the completion the caller in
+	 * ath12k_mac_hw_register() may be waiting on is still signalled at
+	 * the end and it does not time out.
+	 */
+	pdev_idx = reg_info->phy_id;
+
 	ret = ath12k_reg_validate_reg_info(ab, reg_info);
 	if (ret == ATH12K_REG_STATUS_FALLBACK) {
 		ath12k_warn(ab, "failed to validate reg info %d\n", ret);
@@ -6980,7 +6988,6 @@ static int ath12k_reg_chan_list_event(struct ath12k_base *ab, struct sk_buff *sk
 	}
 
 	/* free old reg_info if it exist */
-	pdev_idx = reg_info->phy_id;
 	if (ab->reg_info[pdev_idx]) {
 		ath12k_reg_reset_reg_info(ab->reg_info[pdev_idx]);
 		kfree(ab->reg_info[pdev_idx]);
@@ -7019,7 +7026,7 @@ static int ath12k_reg_chan_list_event(struct ath12k_base *ab, struct sk_buff *sk
 
 out:
 	/* In some error cases, even a valid pdev_idx might not be available */
-	if (pdev_idx != 255)
+	if (pdev_idx < ab->num_radios)
 		ar = ab->pdevs[pdev_idx].ar;
 
 	/* During the boot-time update, 'ar' might not be allocated,

-- 
2.25.1

