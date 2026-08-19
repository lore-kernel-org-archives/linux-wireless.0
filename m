Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371203CF202
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 06:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787122488; cv=none; b=rzxv/PxX8j+zJ2sCfZsQDfweoNKlO8jWDjOwHFIb9295R2sNDe2UmT0T9/DlJcWwi6JLn4JTrHNOjbn9TIn1OIDlypGz6irpiyKp8TzVoOrxwf29PhmGDwQX4k8jyiGBeSX5o36YNuZAZusrKgf0vZjwpsbAbNdHFdyVnL/kuVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787122488; c=relaxed/simple;
	bh=iNsMS23ZXl5tbDAv8KyzF+kHvl+vjFgZpz6Oz5o46Nw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jG0nM581ngM0M8dXXWdRfi3JTg6xky33rl208AzXHVoQ2pxdnT/uHTT+o1ll0E/iFZLN5m1JMe1vuuFfPea9RbW7j5h+ekCsNYKsHEjeGijRd5yQVSMDeW0vk+douYbEdSpEERp4ayGZkbXXlFa8pDxYPxtegPup1auYuPrOH2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KaNQYbtH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gazjGeie; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KaNQYbtH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gazjGeie"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67J6Z3tq3670844
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 06:54:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=J1hyIU0VPAz
	TAC7wOt7yHN0zXh9gRTdD0IkZMzab1Wo=; b=KaNQYbtHHun2jBV5bmoAq6RhP3K
	SAd6KzkNVbbw6wyiAuF4Y4ePDHrCFqgFf+umIb9LIAXBe9x1o/5Un9rSilb6ZSdS
	ekEiGZoRxOEK/tU7/GzkdXQXHXATRNYCSmCkjE2kA2CLf5oKy2rYRC5WxOzBdbPf
	8vUHbHtPVDFw+DFIBMgrfrKPNFf/aEGT+wKvLAhZSqkkfwzvTC4hibayo1yzpLzg
	H06BIauEkXSEGQfAZOsfd+fGH8VdfxH1afWcIUeEwhZoW4x5eoNY2Fk0x1JWUJFA
	WYh0sIZIqnFHLqCgGehhsKyAOECWH3o/Te2sXdTaYe4wSi6OeCF+dx509IA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yftstrn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 06:54:46 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e22137fb3so1322556a91.0
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 23:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787122486; x=1787727286; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J1hyIU0VPAzTAC7wOt7yHN0zXh9gRTdD0IkZMzab1Wo=;
        b=gazjGeieMK16LT+NeRydGgal6uy0tqi1giNQ5MOKyUhDlo2g1zitN8q2sRX6C56u6z
         lBtcwi1YKfMoEhKjWw0g1oauRIh/XH3dCYhZga0mfiISDvro4DNhdw64xpy3tBJaEmG5
         Icau1/swKpN4Npp+Nv2/H/YQscvz8jYBEDe+KeWb1wsi6qjwzcYDgVFBWbMcxcsL+kB0
         /LDhRdycLxEW+bzyBpZ+6TJ21uIImrxNoOzT3Lc0lFEFiC0ySAsBObKxnKy8IqCyCxWz
         rOhObR3risKuPqO8FfDb2KOYs98N0lJcrMnYx6E4Oc8x4k8JdxbXYvM5OA4cgS2K8lzq
         wqAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787122486; x=1787727286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=J1hyIU0VPAzTAC7wOt7yHN0zXh9gRTdD0IkZMzab1Wo=;
        b=jDobVFL9N3OZUylFVDR+Vl3/z6U0eFQKlrSB28m2NJ3Nhu/jmudllJCYLUEYL2gl94
         BxeTZuPaJz9v/h4N51gMTviuzdpyuCw6P8Cvgynlw9yBQjRmHVFGo+V++16258QkR9+n
         ODMfJNxUtVKeGP7ajxrtMv8I+RHgK4UsTJBuaw0SjBPzJ0ZtjEeEn82nNTewZ6iwtFQr
         5o+Nhimml3/FxdvosUmelvfektVjeRgGtDNM6WoTQVh0odtym8BSlcDNGj17/m8d1DCv
         VvRk3h3EsKD9DbtgAsELp9ghI0lg2zldQy80c1Wd/D+q0MhAvdOQ2w2o1A1l9Wbmgxws
         QuKw==
X-Gm-Message-State: AOJu0YxD2eaeVXGbIyYwTJBhGuGNoxTxDGFlSBPAmP9rS4+MbPDnhBdO
	0QXMVv7L6UskElLxVaX+GRmeu7ap6/gR9/R2K34Elw34ttpFnNERWF2UTgMAm04M0Io5WPIv+b7
	QOR/XfulN5h3JsZkUk5VnUcPCtd2X2CuvrhWcRFPOhGhU5AM1qnI5kE9qD9UkoJurHVxRSA==
X-Gm-Gg: AR+sD11Au3FsTDiGkaoLIbUWV1TR+aV734SKYylgcqz/tC80NLws3eu6GS7swhpEp2B
	+WH9lYcDCUo7dn3pZzcVeDdhZM4D9/AcC6JeYBQ3oBw2U6LPn2v6L20GSsmsNh/4xqfhQg9Lf4X
	kmWTw1nwWvAKsAPyCNoF2lDWikBL/yflXs8MwSWZio7bZabzempF8Wjv0S+Qt5F7pw8GRSBMmJf
	4/NGDXwfbGbD1/CiqPdGrQ5vZ02rv1Wypi8i23v9x4elueRMpIyVpbLLpPe4H1EoYWVKWjdX7kj
	BE6kSpLIzEXHVIR91CEajG/CrYCsqwBU2flGgdf3g69TNWi8BFWHKZ9agolNmkeeM9yZ6kQUoKo
	ZHFguydYd9I/YWpoTxpEB3CYTrMoWk8o22PgCusA7Jrhp1iAELd1998fzBY/BTMh7pu05hVTWmf
	jhjjxMZNBtPxGUCl60tTARe7s=
X-Received: by 2002:a17:90b:544f:b0:381:152b:d596 with SMTP id 98e67ed59e1d1-3958108a4b0mr4652383a91.11.1787122485552;
        Tue, 18 Aug 2026 23:54:45 -0700 (PDT)
X-Received: by 2002:a17:90b:544f:b0:381:152b:d596 with SMTP id 98e67ed59e1d1-3958108a4b0mr4652327a91.11.1787122485115;
        Tue, 18 Aug 2026 23:54:45 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fb4ffcasm1526626a91.6.2026.08.18.23.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 23:54:44 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Subject: [PATCH ath-next 1/2] wifi: ath12k: Free allocated CE IRQs on request_irq() failure
Date: Wed, 19 Aug 2026 12:24:24 +0530
Message-Id: <20260819065425.2044186-2-aaradhana.sahu@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260819065425.2044186-1-aaradhana.sahu@oss.qualcomm.com>
References: <20260819065425.2044186-1-aaradhana.sahu@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=FIorAeos c=1 sm=1 tr=0 ts=6a855336 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8
 a=1B4byUU5Bt7BwlcAXWAA:9 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDA1MCBTYWx0ZWRfXxz6f+mi/gyd3
 xia11VjvstnWCdYusxOGnf/WBVuXo4+mgXIiaDeJlfwesrAhLazV5T3hWeYDhr6gxyxXYY2VcBQ
 qAIQPCOAJnYeAFpIezVFgEV90fuljMM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDA1MCBTYWx0ZWRfX3aXf53fW4Zw+
 dzu2w6+RBgbC/KqlpmrnxzTWiCs6RPXSNaHVrZ+m8NMrI2gtfwXwf7FKkRjJu+UD7267zZmWt4+
 Ml3nA8ojkLd0+YtDGNvfsXZgFevpiOpEkmzJCOOmXg8QLiywhifNMNV9BBLLUyetXR/tiyYDRVZ
 qdrKcGbHUCf1WGujzYV6orcv77DV68THY0q7tMJgIgTfOpYGHOVPCqbPZ7gvuegd8kMLqzme15L
 58EiOJKKmCCjWzvm+XpI4tAWOcDvh8qbBBuy1axhrxF5TjfFi+XX1MMZIKt8c2C5Kd0adrmkI2S
 relDw8ow1eOGiEK1qgQ50krB4FuR2gRHMlsMBoqq2iYYQYjpzekcPhEzsU12ElhQrpA+Br2yO3w
 NjKMB3tvQ3WHa2jMBIMMX9LZ6onVtx0dD2ku2HRIGpxYe9BjfgfUxF9Ci4d+CK8x7+FoafdcO3N
 qXRYrJdHvvXdoYoxkiw==
X-Proofpoint-GUID: EjtqaoG9PPh3spbXo-HyGdnENXB7bh9u
X-Proofpoint-ORIG-GUID: EjtqaoG9PPh3spbXo-HyGdnENXB7bh9u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_02,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608190050

When CE IRQ configuration fails, the driver does not release all IRQs
that were successfully requested before the failure. This can leak IRQ
resources during probe failure.

Free the previously requested CE IRQs before returning from the error
path to ensure that partially initialized IRQ resources are properly
cleaned up during probe failure.

Factor out the CE IRQ cleanup into a helper to reuse the cleanup logic
during both error handling and driver teardown.

Also free CE IRQs when external IRQ configuration fails, before
returning from the error path.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/pci.c | 29 ++++++++++++++++++---------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 6441927b5382..9a78d2f69f94 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -313,6 +313,19 @@ static void ath12k_pci_sw_reset(struct ath12k_base *ab, bool power_on)
 	ath12k_mhi_set_mhictrl_reset(ab);
 }
 
+static void ath12k_pci_free_ce_irq(struct ath12k_base *ab, int num_ce)
+{
+	int i, irq_idx;
+
+	for (i = 0; i < num_ce; i++) {
+		if (ath12k_ce_get_attr_flags(ab, i) & CE_ATTR_DIS_INTR)
+			continue;
+
+		irq_idx = ATH12K_PCI_IRQ_CE0_OFFSET + i;
+		free_irq(ab->irq_num[irq_idx], &ab->ce.ce_pipe[i]);
+	}
+}
+
 static void ath12k_pci_free_ext_irq(struct ath12k_base *ab)
 {
 	int i, j;
@@ -330,15 +343,7 @@ static void ath12k_pci_free_ext_irq(struct ath12k_base *ab)
 
 static void ath12k_pci_free_irq(struct ath12k_base *ab)
 {
-	int i, irq_idx;
-
-	for (i = 0; i < ab->hw_params->ce_count; i++) {
-		if (ath12k_ce_get_attr_flags(ab, i) & CE_ATTR_DIS_INTR)
-			continue;
-		irq_idx = ATH12K_PCI_IRQ_CE0_OFFSET + i;
-		free_irq(ab->irq_num[irq_idx], &ab->ce.ce_pipe[i]);
-	}
-
+	ath12k_pci_free_ce_irq(ab, ab->hw_params->ce_count);
 	ath12k_pci_free_ext_irq(ab);
 }
 
@@ -671,6 +676,8 @@ static int ath12k_pci_config_irq(struct ath12k_base *ab)
 		if (ret) {
 			ath12k_err(ab, "failed to request irq %d: %d\n",
 				   irq_idx, ret);
+
+			ath12k_pci_free_ce_irq(ab, i);
 			return ret;
 		}
 
@@ -681,8 +688,10 @@ static int ath12k_pci_config_irq(struct ath12k_base *ab)
 	}
 
 	ret = ath12k_pci_ext_irq_config(ab);
-	if (ret)
+	if (ret) {
+		ath12k_pci_ce_irq_disable(ab, ab->hw_params->ce_count);
 		return ret;
+	}
 
 	return 0;
 }
-- 
2.34.1

