Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198133DD86A
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 07:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785137200; cv=none; b=Qa7MRTftryHLzbo8mczLh1UdFxT8NSpwfH4JZW7d9js1wvckp6nRiKMUu1eFaLFourzUU+UgyanwWRul6sO1N56hpD4s96y7HCgIdLjtS/vLkxsgL+U4mLz8jppYZVdwZ2Hv7thVDta9/Rw3DWuoR24tMv5BjqWUoyS3/GH72ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785137200; c=relaxed/simple;
	bh=nPYM4G08xx9B+wxqYdlxN3W6h6owFj9A6+Jp8XQ/hzc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nQG3udo6hTLziyhp0qRt/CQszu439CS3WMdITVIsKcIowWMTZTgHj0hQZ1kNafT/agnSi0EjC0tHVPd7l81Pu4yqp0hg7/5t/P3AKGCo98OWXAfTdAuO12PQwpfy8EqTHPbYGI0r+RYsXBjHT1fg3LQA0H2NoSffLQB5DL+COSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=biAXVulA; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Nj+qcrUZ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="biAXVulA";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Nj+qcrUZ"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66R1g3Pr1768795
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 07:26:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=R/cpPPDkMi4x5SQoHxbHCb12AP510lOhLC2
	bI2PQq+0=; b=biAXVulAft9KI7k7Pt6Rx+vmVPJu3QcuTMSnfW5ce19NPXlO19J
	UIfaJKEdX+eIi/RUsdpVAnZPqtI4mZqOzNfLRO9D7SrB0pBRwqXNB0jNDw02GHSF
	Fn62fU4z+ab8n3Nh750dgWKc5cx1lrncZsetc56dOFq3YsnLRHQ2up5HZiDEsPYc
	uUEd93zh3AcmPvXQ19bI0WDb+8dfzPy4mPSHGn4WnJbeqag+eufrUZk/XOd/Rx6f
	NsIgdDP5uNxp86YQBR8mQqHt7e1Fr9UO556lqGc6E8/00l5hs4sFQat9VA45aWlc
	ierr2np/D0yhSE3+SSCYwEygg4Id0Xs2jhw==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmpajmsw7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 07:26:38 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84e09f9b07cso359857b3a.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 00:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785137197; x=1785741997; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=R/cpPPDkMi4x5SQoHxbHCb12AP510lOhLC2bI2PQq+0=;
        b=Nj+qcrUZFQrAg4btX9knBLoMw0zG+mkxRnGs1W2PWA8WsjngHHqQ5c/WrnFrJUCdPP
         bLKsCwNFUQpQ7CUkfrswgyyYJaigdJxyqvj5olJZ9RTv6bTQuC21AFJlJo2vz5qf16Yy
         vYtekj3Qpc9HPTSHK+OCAfydijZdDjCB/ndehPYTna6y/msumHKyl7ZrpZrr1+Ezr1/7
         kqQgtb5eWZonaabV6ZFJ/jau1zsvq2RGWEhsFRpbBhhU3YFraja3sKeppN2VQ3BVAFGY
         JsBUejhj2OEDmXMWJa3M0NAU9sgEkvxkXM0pUXKvVAXS9+PhFlmdKrtOJW/QV2CpGuFM
         B2jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785137197; x=1785741997;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R/cpPPDkMi4x5SQoHxbHCb12AP510lOhLC2bI2PQq+0=;
        b=juji90eCopuNo0K7ZdxE52dXbhTQmNZPkyOeOo0Z17G1ma8RG5gqiO5xnvYfnAB/8h
         iUJy9A28ugVGmzlN+U5SLfazf7Ya+hFOAVt64G5roX5g49M4df2CzENyGR8nYt/o3YM/
         lkiJYVugUjydT4IuBM8Z+UroA81uvUHpn5YYLpcIRwcsSlM+DYTMQmC0TFKqllsvczVm
         3GuDNQNfIaOc60p4jYEh1zntWly3OlHRzxK508UO/ZJDaidBwAgrtcJ2s/mQx9P9dkGO
         725+pGzw9pjENai+lE54NdQH752In3Mn5K5pxEeQQ5KXSy8G5vLenHDmKSt9cFVYg27p
         yGgA==
X-Gm-Message-State: AOJu0Yyq43/B193H1wl3rdLl5oVRb+4l0UagN5wVTedlkTLaBFaRaj+o
	2syFEj9vm3slUPRqYTE0gRMIeM3dsGFgcVHUiD0omtFGf9UgR5hGuyORdQZGnuZXaGCTmcUfH4+
	J/kJZph7SdXosVyolnDUTecps+7IwXl7AU30eI652kMV+a6QL2UscySkNZnYINeaUtQ2zxw==
X-Gm-Gg: AR+sD10IYP+GIQUNtB8x8ER2kagJcTwGx19W5/hK1REyLXJcqNCwJhiI4h5DZ5ZNYnY
	RXq6aWTqFL8+Eyae6779NRNcKH1qVw862X9OVx/XDf+by4RZFzQPjkvBgllQ0RLvRq57y1L9UDp
	IdDAq5YXbIsglXFY9kKYolj7J5fvMrtccUKjI1v63XrDyql75QdS8e1rPOtVqsgzvGlhNCUhSwO
	ZnJn1qNh7Hi0fCYaRILFCWmLdov0BwnSsXuv/6F5b2mvdf+BXwOlGYBd7Wtw0hmPpqPLO7WuuHZ
	SGRjiv1sT0ApHtAdKfy+gSsQ508pA9vPWUfoPJjyX3UM9JmEwGQ71LmT3MzFJ11Dwi8KBTYYMP5
	Ls26XCI4JDd9NG08bqVgmdbQP9A==
X-Received: by 2002:a05:6a00:4009:b0:848:7e85:f210 with SMTP id d2e1a72fcca58-84e59573605mr7416060b3a.4.1785137197351;
        Mon, 27 Jul 2026 00:26:37 -0700 (PDT)
X-Received: by 2002:a05:6a00:4009:b0:848:7e85:f210 with SMTP id d2e1a72fcca58-84e59573605mr7416026b3a.4.1785137196820;
        Mon, 27 Jul 2026 00:26:36 -0700 (PDT)
Received: from hu-lingwu-sha.qualcomm.com ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e533ce1f7sm2603424b3a.34.2026.07.27.00.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 00:26:36 -0700 (PDT)
From: Linghui Wu <linghui.wu@oss.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        linux-kernel@vger.kernel.org, Linghui Wu <linghui.wu@oss.qualcomm.com>
Subject: [PATCH ath-next] wifi: ath10k: snoc: use memcpy_fromio() for MSA ramdump
Date: Mon, 27 Jul 2026 12:56:29 +0530
Message-ID: <20260727072629.2297208-1-linghui.wu@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: aPt8570Y8vyihCyjQGmhkasfEslZIXZx
X-Authority-Analysis: v=2.4 cv=A8Bc+aWG c=1 sm=1 tr=0 ts=6a67082e cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=WRuc8sxw1qBzrRBfCfEA:9 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: aPt8570Y8vyihCyjQGmhkasfEslZIXZx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDA3MiBTYWx0ZWRfX+suWMnrbXvYi
 ER/M5iFgcG5tG7iJW6YmASHRT0PqG4SINfk9MEzmiEP8pNewj6rxa6pg0PY8ladDIYI7ABgos2J
 gzvaZs7gUQDUTlXwl60koTGCDJjz2ARX+cB+0C7UR+Y5Ral/65SLGOxEqssE1bTbNCNy4Q/RzLP
 Axrbeb2w3SrJE9TDUrSNytHLHSL2nUFBzZJf/Fri6pUWKMqBYY5wfcHMB3PNpzoQ/bhJjL6Mbcy
 ibmLIFo/wsJj3+uYjwWrJaV0ax600wmlQcTPM1Vmz+YUklA46zbFTJ0RNqiXVXyWB3++y0jfGpb
 UiXc0VPaVjZ4z7sbKhbEvfC9ljXMF089GRP1VT9iepY4cWN1B2QCJbSrwtkPhlB7mDb7N7IpLPt
 EkBzYU/e6h0zvNJWHQsBiivpirlPONB49txAQKZnVPA5q0u5Rle2VNRguglSBoTJqjZWJUjcWn0
 ooLkCbCL8OLD+N8KecA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDA3MiBTYWx0ZWRfX5D2kYQK2ge3E
 Ro/jkdm3njO5zSIYsuR9s8FbzwNxen/y8q/8q0QOW9N618aP3xgaHKz+iHfWDtRPz3vYY+NBjdz
 kFY7SgOM2+GTzOeoFb9UM8sZS8M8bdg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_01,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 adultscore=0 lowpriorityscore=0 spamscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270072

On WCN3990/SNOC the MSA region is mapped with devm_memremap(MEMREMAP_WT).
On arm64 such a mapping is not Normal-cacheable, so unaligned accesses to
it are not permitted. ath10k_msa_dump_memory() copies the region with a
plain memcpy(), whose optimized __pi_memcpy_generic implementation issues
wide/unaligned loads. This triggers an alignment fault (FSC=0x21) Oops in
ath10k_snoc_fw_crashed_dump() while collecting the devcoredump:

  Unable to handle kernel paging request ... FSC=0x21: alignment fault
  pc : __pi_memcpy_generic
  lr : ath10k_snoc_fw_crashed_dump [ath10k_snoc]

The Oops both leaves the firmware RAM dump buffer zeroed (no dump is
captured) and crashes the kernel, which in turn breaks modem SSR
recovery.

Use memcpy_fromio(), which only performs accesses that are valid for such
a device-memory mapping. The generic memcpy_fromio() implementation aligns
the source before issuing word-sized reads and stores the destination with
put_unaligned(), so it is also safe for the coherent DMA allocation used on
the non-reserved-memory path. ath11k and ath12k use the same pattern
when copying target memory into crash dumps, so call it unconditionally
here too.
The MEMREMAP_WT pointer is a plain void *, so an explicit __iomem cast is
needed; use __force to keep sparse happy.

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.3.7.c5-00107-QCAHLSWMTPL-1

Fixes: 3f14b73c3843 ("ath10k: Enable MSA region dump support for WCN3990")
Signed-off-by: Linghui Wu <linghui.wu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 310650227..695473eb0 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -7,6 +7,7 @@
 #include <linux/bits.h>
 #include <linux/clk.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -1475,11 +1476,15 @@ static void ath10k_msa_dump_memory(struct ath10k *ar,
 	hdr->length = cpu_to_le32(ar->msa.mem_size);
 
 	if (current_region->len < ar->msa.mem_size) {
-		memcpy(buf, ar->msa.vaddr, current_region->len);
+		memcpy_fromio(buf,
+			      (const void __iomem __force *)ar->msa.vaddr,
+			      current_region->len);
 		ath10k_warn(ar, "msa dump length is less than msa size %x, %x\n",
 			    current_region->len, ar->msa.mem_size);
 	} else {
-		memcpy(buf, ar->msa.vaddr, ar->msa.mem_size);
+		memcpy_fromio(buf,
+			      (const void __iomem __force *)ar->msa.vaddr,
+			      ar->msa.mem_size);
 	}
 }
 
base-commit: 913998f903fb1432c0046c33003db38a9e8bedb1
-- 
2.43.0

