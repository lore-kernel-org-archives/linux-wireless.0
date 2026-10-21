Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792573808;
	b=oSBpnxDc6WmebMsL/fGDz48Bs6/Kzt3cLAHe0fJIt/vQSuKy28kqB8LfH6GqisDeL9Co
	 AeIxuYVy3IrT5de/A3c0zUPR+YGCOa//LB2AHfvktgeMj6mFfelb/6rsTGU5hal9Oi92l
	 v0aCiz8PIgac8H60UokXX20i3A30ht4Kz8bI6wa7TyBYvuAAKUuSCfANWg6mR2XSjTZFg
	 +XB2OcghupaLzyyKPi1t/5wFUn5f2QiGab5Wn0aH4hZvXjFl/BSCkSH9U8BALwVpjgKOq
	 9pGWQcHOURHyLoLkb4q2xIriBmOTnAwQ2Z6jH+4W/RxG0RicLJDj1ZFAzv0gDcgyhsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792573808;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=Du3tEgvL55yjePVWq7XInLS86N3i/yJW/fLUSRhGwFc=;
	b=mjqyrNXlpj8NhRbUuULh7jo0OVHWPm6kFlNdJfWEhL3MAlBBVOP3HAVPi4tW2kixMxka
	 GaDYCqdX0FcBdehz8mD1yAGWhy3KuOElg3Q0XklU3Pxw6tvw57k74lBs1wAkrkry7YGlK
	 g1D3hsnhfVTBPU3L8wCAKI0SyK6gdA8dounIkRJwdj7sSTNDkyR0etUQ/Fm6rGQihhhaD
	 Mm2Xcz5oe1SWC2HVcpxq0s60PCiajWpJv6GIew11Ozq3MwbPQfjJhs0DBkpYMsguKX0Zq
	 etWnHPm4ENwYxPYGfw3eJ4r4jtz7V4ZNQ86m2PlWw+ns7Sy/baGPOBT+2GLBkq9fNGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=e6WmxSca;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=N0i9iWns;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB92B60A3825
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:10:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB92B60A3825
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=e6WmxSca;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=N0i9iWns
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69L90sE0135040
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:10:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Du3tEgvL55yjePVWq7XInLS86N3i/yJW/fLUSRhGwFc=; b=e6WmxScaXt/H1L0T
	oIOT4jdLmg5Xx5oHu3TlicZMCE0IyQyLKvadZrb3bkvH4h9Gs7f7z+t9gPbU/C5d
	xLDMsOvpHiR8WCezSzkErNp8UpOVjvoJeMVfPfzn59fIq3u9U2vu9VT7MAs5GRqq
	ouumRq3wRVBjzQxwkPnIMbDMu2RyZjsGa2HetyhXNVD3nR4nmT2yOy+Ij0hvG/rm
	0NHu71HFDI4Z7D7zSsBa1tadOI/V/bINxsg1clnk0oSZcXPrIy0suHrvpvEn/Jhm
	YabiEVT571AJnzQq8Am3NVf04tf1dW+pORxmR+BGy5E+FTbdSYL/RpLqc+9rhdom
	bLVFcg==
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4heh5r28sy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:10:06 +0000 (GMT)
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4f4612a1a5cso1799963b6e.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 02:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792573806; x=1793178606; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Du3tEgvL55yjePVWq7XInLS86N3i/yJW/fLUSRhGwFc=;
        b=N0i9iWnsFwgOlPxcBzPSxrSnh6EkXSFIAHMAVbGi80oUfsZ0cfsgwVUwmlhKEjQ1Tj
         rrtNeIVpOoqnaBIrt22OEaWmwabBovCH1yv49w6UO7d39mU1EUvE3uK4H4BAFM5CbNXb
         rX25y7+MVnQgdmXRqDRfpdE/G8tKHzqeTjLfQbewL7yVJemO0GVpj7Y8sqJoeBaZfeTj
         HWpXHaWFkr+0HqN+Nmt3jXRmj8kdkv3zGSD93dm+jSCRW2XAjgBPMQNkHEuqRnylCJb1
         gHqxE5ErDlWXW2+WQMJYElAKBc1gZn16k/37wB4lHTlUBkUf8xVLPmFcvnXxlK1Od7tJ
         g1Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792573806; x=1793178606;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Du3tEgvL55yjePVWq7XInLS86N3i/yJW/fLUSRhGwFc=;
        b=HKbaJF0sJQ0YtaSRIGgnskIrsMleYUh1/Zza1qQpP4L/htebZ4FddltI29diQS2IFx
         smtk/nPfprQLnJFhPlI4K2AqoM/FRW8LwK1qR5iWLWw5QXJhXLrfWMRwfD/452FCZLd+
         hBWMZ5Um9JUv0HR6GM/3D69L6UyyevQIOMsbnvG8HKvbs5QcesRmg5xx78UPrmINooZu
         FYXw7U4LyGlsFfZvk0Eg4NQVz0xSemJWOXuHoBT5qfZVKc15te+7UQeZXCUgaoZVB32A
         WXRdsIlqM0vlLcamQ7uUQSqq8osS6lbDzXtx9i9o/0jpoBBQg3FKPc+HCshOupn/5WB5
         MXYA==
X-Forwarded-Encrypted: i=1; AKwUvBxdeRPwAgr9Sdqmgq9PMZzr6GRzj0CxucPd4LY+yPHxEyTM2xSU48jM3G2yfIYijkeTaaTJT4Q1aetxt2tbig==@vger.kernel.org
X-Gm-Message-State: AFq9FYKuk7nUYSEJbcv/U1n1ZfBk1SRxsAzLmtcGqBVuMtVU60oQxWbl
	YOHfZgjprucbgEsP8cKcEbXcLFZqaYS6aYxdmzLWTS6Dh6LyID0FzogudRgZQ1jmcJCj75XmeeL
	RukkuKVLD6OgD06d/TO7rhPzXpD2YxsbFOYRZ6RQ0r2sJ6uyM27fA0RC+q1sgZb3VA60EHShzo5
	8SP36I
X-Gm-Gg: AYBFou1SivfX9gFM2rAgzufAVy5wK5vo5gVfUem++2L9hv3SOQ/StaPkSbr61ZB3xGY
	Ompq+yOhymJm7bFEJsA28ZJei3MHa4hAR83X2Ur1/76ZhH/zEY5EUOrWAc4nSgC15Hy6pPQb/Ld
	iW4Ey22Ny3hVsLNdYYoiZ3VxY/WhFhyjJnH2jeJ75KoalkzlaAF/NelzaGQZyKjv7MmpnWNn4zs
	P60mLTOKspcdUEDvrlCkKZfIw4aLVA+7L6PEMV6w7cJO8i9Ta0w0GakwcO3O6RDJTQqWux04Yvb
	yBtVbf23tpeZRMSRDyj1q8pGtwc8S2H/Zqsrwg4Sh8LUZaojXpZ4XdyQZhNE8EaVBCngKJ1WnhB
	nwdISu0a5f6AF3VhPVL8eIqyjk/ACyr0gq6SU0x3KsSOCfvaF/A==
X-Received: by 2002:a05:6808:238a:b0:4c5:6a01:210a with SMTP id 5614622812f47-55354eead93mr595934b6e.17.1792573805797;
        Wed, 21 Oct 2026 02:10:05 -0700 (PDT)
X-Received: by 2002:a05:6808:238a:b0:4c5:6a01:210a with SMTP id 5614622812f47-55354eead93mr595928b6e.17.1792573805299;
        Wed, 21 Oct 2026 02:10:05 -0700 (PDT)
Received: from hu-kangyang-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-552a182d59bsm1554595b6e.0.2026.10.21.02.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 02:10:04 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 02:09:35 -0700
Subject: [PATCH ath-next v2 7/8] wifi: ath10k: remove now-unused
 driver_recovery completion
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
Message-Id: <20261021-10k-sdio-crash-v2-7-5df80bf16e86@oss.qualcomm.com>
References: <20261021-10k-sdio-crash-v2-0-5df80bf16e86@oss.qualcomm.com>
In-Reply-To: <20261021-10k-sdio-crash-v2-0-5df80bf16e86@oss.qualcomm.com>
To: Kang Yang <kang.yang@oss.qualcomm.com>, Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792573790; l=3510;
 i=kang.yang@oss.qualcomm.com; s=20260921; h=from:subject:message-id;
 bh=0MX56h+G5vwBMUj7+Wrtzk4LSA9Q2kd7+MXHjWNs0hE=;
 b=LGw/a4nmclHQqbw5nk6z8pHL0GkmeSMpeDV1FEEwwcgoI2ith6J/WXIEPvgej7S28mDffcwrM
 cP7O9Dpfi8hAkxg3A2kk37Fx3QlT+Udh4xnKevnIXhwFF0BhMLqR3o4
X-Developer-Key: i=kang.yang@oss.qualcomm.com; a=ed25519;
 pk=qz684ZqyU2kfjPKl3UVYeUcHg1oCLfFIhi0n3vK+MFk=
X-Authority-Analysis: v=2.4 cv=aI5lOr9m c=1 sm=1 tr=0 ts=6ad8816e cx=c_pps
 a=AKZTfHrQPB8q3CcvmcIuDA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=THAtv8xtLSZw0h4mMwsA:9 a=QEXdDO2ut3YA:10
 a=pF_qn-MSjDawc0seGVz6:22
X-Proofpoint-ORIG-GUID: xhODQYjIy1Sk8Dgsm6Qgrg9Bigr37yk8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDAzNiBTYWx0ZWRfX0hdhp/qQPXGR
 64RddffA11RnXrMt9NvTNVUaNIY/dbfOo966X8flBfIwdbdGsb8BbrmJEHNf6OMsWt9YwlZ27mg
 8LwWBybudj4rjcGld9MVY8VqmUupnE4ITuvy5Mk3zRPy5TJjeM8pTFBRv8WPA48o83m5JsqB3Zm
 ZjYQhOZ+eta3gKCpNZzfEHmZgInowVoMVXXhjDgNd6LTbqlpczNj6EQF1zXSi/YEvZurWpHGkoC
 hEUTakz/c05rQ+k8HmFZN1SjmSNtfSmGGOqq+1SQNvdILrd7fuytGHAfCGur39R4ck+lDWkXI1E
 T6BQTpXKsGoWxTedakyrcSYAwdsR4hkxk8CPwOhXZ1li5k3ye29JCfpeie2oCNvPNyZqoDYlArN
 blUi6rO9ChiQ0FE7jVqvOJTpLGROA9ikldc46eY2NrzH5DWCMs7VUzHEjSMZrXv3YgReYm+Ic13
 vuOzGaQ+9/sNw/ff6VQ==
X-Proofpoint-GUID: xhODQYjIy1Sk8Dgsm6Qgrg9Bigr37yk8
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDAzNiBTYWx0ZWRfX95iTaXBc1bJV
 YCgj8rPW+WjU27AZMptdfoS8zp5ewi2kDLo9TADa+zZ2taGWCQggmGHfEOzxh/aeNPqZDTbKhZw
 GnFlzH5LpuppTM/TjYfdvI/Jf1U6jAs=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_02,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 impostorscore=0 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 adultscore=0 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210036

Previous patch removes the recovery monitor's dependency on
driver_recovery, leaving SNOC removal as the only
remaining user.

Replace the SNOC teardown synchronization with
cancel_work_sync() and cancel_delayed_work_sync(),
which already provide the required guarantee that
recovery work has stopped before resources are freed.

Remove the now-unused driver_recovery completion and
associated initialization and cleanup code.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1
Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00189

Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 3 ---
 drivers/net/wireless/ath/ath10k/core.h | 1 -
 drivers/net/wireless/ath/ath10k/mac.c  | 1 -
 drivers/net/wireless/ath/ath10k/snoc.c | 8 ++++----
 4 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 66585cfa6d96..7692e1a8b2e6 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2617,8 +2617,6 @@ static void ath10k_core_restart(struct work_struct *work)
 	struct ath10k *ar = container_of(work, struct ath10k, restart_work);
 	int ret;
 
-	reinit_completion(&ar->driver_recovery);
-
 	set_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags);
 
 	/* Place a barrier to make sure the compiler doesn't reorder
@@ -3716,7 +3714,6 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 	init_completion(&ar->scan.completed);
 	init_completion(&ar->scan.on_channel);
 	init_completion(&ar->target_suspend);
-	init_completion(&ar->driver_recovery);
 	init_completion(&ar->wow.wakeup_completed);
 
 	init_completion(&ar->install_key_done);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index a1ded2cba103..7c961308d7b9 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1067,7 +1067,6 @@ struct ath10k {
 	} hif;
 
 	struct completion target_suspend;
-	struct completion driver_recovery;
 
 	const struct ath10k_hw_regs *regs;
 	const struct ath10k_hw_ce_regs *hw_ce_regs;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 693b935536c2..5f828704f8ef 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8177,7 +8177,6 @@ static void ath10k_reconfig_complete(struct ieee80211_hw *hw,
 		cancel_delayed_work_sync(&ar->recovery_check_work);
 
 		/* Clear recovery state. */
-		complete(&ar->driver_recovery);
 		atomic_set(&ar->fail_cont_count, 0);
 		atomic_set(&ar->pending_recovery, 0);
 
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 8f171ab6f4de..1ec58ec1029b 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1916,10 +1916,10 @@ static void ath10k_snoc_remove(struct platform_device *pdev)
 
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc remove\n");
 
-	reinit_completion(&ar->driver_recovery);
-
-	if (test_bit(ATH10K_SNOC_FLAG_RECOVERY, &ar_snoc->flags))
-		wait_for_completion_timeout(&ar->driver_recovery, 3 * HZ);
+	if (test_bit(ATH10K_SNOC_FLAG_RECOVERY, &ar_snoc->flags)) {
+		cancel_work_sync(&ar->restart_work);
+		cancel_delayed_work_sync(&ar->recovery_check_work);
+	}
 
 	ath10k_snoc_free_resources(ar);
 }

-- 
2.34.1

