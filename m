Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC34374E6F
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785392298; cv=none; b=dh9jSFRlluwzLPzlDHaVWGSEjQdZBCXM6BlzSEAICAuTBY8ihdyGVBAGGrCYGnlKByKV11TvFKfpuzDn7Wc0jrl69SdII/Tf6cO1V8YZfNWFWdymPsT2ScOAkqcAzQTe+0xtze9Q3aFYkTRtE8SFlnZBTP0LADSV/GzLGfCw/2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785392298; c=relaxed/simple;
	bh=XFcEJ069LxbrWrK9Bn9Ibjwp5XZPIGMJ480EXI2NIa8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SLioQsl8zqnZS79msc22A40rB1zFtZfbMiY9fAozFJSJdRm9GMbuMLX8Zy9ELMrIb/ryrI4sF2eJw07vWWHRn45pTiq80ihjGudOPhZRwask9PA1haOe5+OSq9aV6xuLySEwYTv7/CXLiH7jCBlWUvt07tN4Y1bjIC6x7u5GfwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XnyyKKtY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=L6hq1PbX; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XnyyKKtY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="L6hq1PbX"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U67eeI098321
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:18:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oRW5qOR78uymx55Gxa/cWKNfN13pJyrdbmSmzxnm0Lg=; b=XnyyKKtYAJG2AvCz
	J+wQ2u4jDZGYzNlcrTkt2qR/Xsa5J+D34IQde6c8RYSkgXOqI8HJYYXWNR863vwD
	I8KKKoHtEtdrzGwHH8h/lMjRnK+NemiWtAagzPWjzvaC2XkCUXN351aMeWJQy4mh
	WAYhF3rEtKeW7r7HdsRe7sqwIop+WeWYH0EVMX+SlZ5h8w3OuUxuuDsNk3n6NEGG
	4VncgrZBWWoql2nCkEgBmvuoe95Aa+pb/sbqWT3SE339jPH8hNegBBZtorJb3+Q/
	DERKBP+XWFvR2goKO//d3w2TT8mUl127Ss5fFUPZsMrpPeVudui9PcOGovVe+DLp
	WcEpdg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fr12t81cj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:18:04 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e8fee6af3so2060764a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 23:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785392283; x=1785997083; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oRW5qOR78uymx55Gxa/cWKNfN13pJyrdbmSmzxnm0Lg=;
        b=L6hq1PbX9+6Pf+n6ulhw+mxHksbKp8Cnjz0fCIZVzI192wSsgKCoApezyhzZ/CxeXm
         PZf0x3Q6Bfaflg4IZcKT40CwtIvWrg/RaL0t59GD8kNndRZ+GDRvJEttWYesmzHvWZNO
         EI6uAWLJBpnCoyqEG+hzkHJmqSygHlnnFfVlqVz0dslhVP+OdmKbAHQszx6JbIinRJWT
         eDh1s4LQFAF6JVhPxJHJFht7bT8Vd48qeqhBq5m6GrHzigVkCQ1g4n9FTfVnSmVD17fG
         cf35CZTcD9NB1TYy7/7i+S95gxLiwJFtCb+CyTpx5Q8IBGPHDJ9WrKSdBEAN3IMvvY5k
         H2DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785392283; x=1785997083;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oRW5qOR78uymx55Gxa/cWKNfN13pJyrdbmSmzxnm0Lg=;
        b=FhUfiVZ2XyjWwXs/Iw5tSGTvAalVhMFprT0kAQyOG/9U5nnONgeum7Ao/ct1Z4pQX2
         gMxXcB9tKjjKnACS0GGaH/BqU1MYvBLMc3tHmXe4VcTt2teCGMqqtwm0JE93pxZKikoN
         YgWQmVxTFny29bnEcgqelFce0Emy25X5Q9Aa9QCRALJJXcY4JKHyij0L57h/BqO8jwgi
         GxTJdvFpWLgQfH/hThM5aHRQm6tOsssVe4oDM4i6akzLE03NPFw1mpVmDOl0w6SupOns
         hpdLw7ulA9ZGC0pR5i+2qxSrhS2D9AsgB1qjeOqnEfSuEofw4IQ3SO16RPBoo7CDnRBJ
         +1Qw==
X-Gm-Message-State: AOJu0YxGZvp5JyBtpaNE6K7AJQlF95ZoCN+ZtChYV4HO8D4GhjdIFk5I
	+pSrNJkWmQ8IWxiFhdoEF98RQm7UjkZZTCccKjpVvCa8fTWZTriUVwkl/GO5nS7UGHq04oIYbn4
	sXRprm/ioOv94rNpdxC5FBhwU45gXOVk5NrGXn7b2/MVqIiUVZihsxj2PqTk5XPxiHhw+QhO9qk
	l57A==
X-Gm-Gg: AR+sD12iezL73o8hoNx4qKuopeLXtcSn4n9X44p+9RmInAda22j9lKsAIlESp8n7XYI
	lsJ3Vg7HVu2lwaqUcVcwAHCmT4FdHtdzUTnet8jCKyPEImHe3nKFSJv5ZMCCjVv58PpYU0CIw2/
	3x2b8+/5vxGoh+POM1Tmt2+hPxfXOZ3bEzZkMZ5TYlhO/nzUbQYxmNeESbyWhb4TRK5FypqJ+EN
	rh8PJU4Y4S4KqFKPAiMEUGikQTzZDGRj115Vp2goyE3xV0X0YcGq/t7jnl1fAYZC21ZQiR2ARmX
	Cr1JPYTXjIj1ZiZhswI4UWu07XK21uyNNpMlIjE1Etbwco2p34d3OZPFQ6DMSsxZclm7NaoTcbJ
	YSprnrLA49WfJSziJ0ecxfbr4N7NLIOmw39F29PEU30GZWoxUuMwCHw==
X-Received: by 2002:a17:90b:278d:b0:37f:9cdf:f03e with SMTP id 98e67ed59e1d1-38f9c0329bemr1179880a91.33.1785392283079;
        Wed, 29 Jul 2026 23:18:03 -0700 (PDT)
X-Received: by 2002:a17:90b:278d:b0:37f:9cdf:f03e with SMTP id 98e67ed59e1d1-38f9c0329bemr1179839a91.33.1785392282571;
        Wed, 29 Jul 2026 23:18:02 -0700 (PDT)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f9b928f09sm457254a91.2.2026.07.29.23.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:18:02 -0700 (PDT)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 14:17:40 +0800
Subject: [PATCH ath-next 1/3] wifi: ath12k: use per-device max QMI chunk
 size
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-ath12k-align-qmi-memory-v1-1-0fef98dda614@oss.qualcomm.com>
References: <20260730-ath12k-align-qmi-memory-v1-0-0fef98dda614@oss.qualcomm.com>
In-Reply-To: <20260730-ath12k-align-qmi-memory-v1-0-0fef98dda614@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA0MiBTYWx0ZWRfX+4sec7eBV2QT
 ef947nwEstxBybucOqxtDw8ZJOYORpC4gc6CeXV6tVSefR5VCNIsLtBKznsSBVEkYX8cZN1nOcR
 0a0AYjxpGLmyiykap3dRW3jQlU+sf1pMSEiRVyb1JqVUYZkQVsxP/ES8e+ffdBmd5EPNrIDB7CB
 g60T6kYG5PonBMyU4cKZ0ZxODB+gw3MO3kPyk3UJTDGx52HHrl1JABZd1HpfiVqgxPWWdk/D+oy
 vAQK/EP82ICMwhVuCg+SrGwXsr7E+UcmPX9qH7MMbVnjIt47zBhzQLYq+Hu8QBpLVS4kmGAgQyW
 NoOaKTqH24UeoqOdB2G8J8IKLk9piv/bg7emuiZBmkRvURGq1X5MP+T2u8uYSPe3+n1PNCv1/t9
 jpnoTLHReE5XszmLMHRWtyWWYVJ3PO1lA0bWJHSVhkFUT8IiPT6fPKLnzL6GqP4Msstrd3abXsp
 yVrb1rUq8uvq2UrLcKg==
X-Proofpoint-ORIG-GUID: gqINs0SgoYgP2IBHqXrxgRHQ8o9I4sAm
X-Proofpoint-GUID: gqINs0SgoYgP2IBHqXrxgRHQ8o9I4sAm
X-Authority-Analysis: v=2.4 cv=Lc8MLDfi c=1 sm=1 tr=0 ts=6a6aec9c cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=FELcvhUeWYCIvslz9-4A:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA0MiBTYWx0ZWRfX5HGjIeVx/yk+
 6E8DZPzpK099nfYnDdRjQ5U5EwBODlwjbrMjqilnkr/juhGecZRs/zzxv8xb7cXRyTSfrXWg84U
 3AyySNGaDY3RV8wOjKBCnn9WI4UvPNE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_01,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300042

When a target memory chunk fails to allocate, ath12k_qmi_alloc_chunk()
compares the requested chunk size against ATH12K_QMI_MAX_CHUNK_SIZE to
decide whether to ask the firmware to retry with smaller chunks
(-EAGAIN) or to give up (-ENOMEM). This threshold is the boundary that
tells a first (big) request apart from a retry (small) request, so it
has to match the size the firmware actually falls back to on retry.

That fallback size is not the same across all firmware, though. On
WCN7850 and QCC2072 the firmware splits the request into 512 KB chunks
on retry, whereas on QCN9274, IPQ5332 and IPQ5424 the firmware retries
with larger 2 MB segments instead of 512 KB. A single hardcoded 2 MB
threshold is therefore wrong for the former, and a hardcoded 512 KB
threshold would be wrong for the latter.

Replace the hardcoded ATH12K_QMI_MAX_CHUNK_SIZE with a per-device
qmi_max_chunk_size parameter: SZ_512K for WCN7850 and QCC2072, SZ_2M for
QCN9274, IPQ5332 and IPQ5424. No functional change for the latter (the
value stays 2 MB); the former now use the correct 512 KB boundary.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3
Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00074-QCACOLSWPL_V1_TO_SILICONZ-1

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/hw.h       | 1 +
 drivers/net/wireless/ath/ath12k/qmi.c      | 3 +--
 drivers/net/wireless/ath/ath12k/wifi7/hw.c | 7 +++++++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
index bb1c104e1a65..78a13b169e99 100644
--- a/drivers/net/wireless/ath/ath12k/hw.h
+++ b/drivers/net/wireless/ath/ath12k/hw.h
@@ -167,6 +167,7 @@ struct ath12k_hw_params {
 	u8 max_radios;
 	bool single_pdev_only:1;
 	u32 qmi_service_ins_id;
+	u32 qmi_max_chunk_size;
 	bool internal_sleep_clock:1;
 
 	const struct ath12k_hw_ops *hw_ops;
diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index bb61c78e5c29..f96d847ac92f 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -18,7 +18,6 @@
 #define SLEEP_CLOCK_SELECT_INTERNAL_BIT	0x02
 #define HOST_CSTATE_BIT			0x04
 #define PLATFORM_CAP_PCIE_GLOBAL_RESET	0x08
-#define ATH12K_QMI_MAX_CHUNK_SIZE	2097152
 
 static const struct qmi_elem_info wlfw_host_mlo_chip_info_s_v01_ei[] = {
 	{
@@ -2655,7 +2654,7 @@ static int ath12k_qmi_alloc_chunk(struct ath12k_base *ab,
 					   &chunk->paddr,
 					   GFP_KERNEL | __GFP_NOWARN);
 	if (!chunk->v.addr) {
-		if (chunk->size > ATH12K_QMI_MAX_CHUNK_SIZE) {
+		if (chunk->size > ab->hw_params->qmi_max_chunk_size) {
 			ab->qmi.target_mem_delayed = true;
 			ath12k_warn(ab,
 				    "qmi dma allocation failed (%u B type %u), will try later with small size\n",
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index 296180fbdc21..23a855018bc4 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -7,6 +7,7 @@
 #include <linux/types.h>
 #include <linux/bitops.h>
 #include <linux/bitfield.h>
+#include <linux/sizes.h>
 
 #include "../debug.h"
 #include "../core.h"
@@ -369,6 +370,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 		.max_radios = 1,
 		.single_pdev_only = false,
 		.qmi_service_ins_id = ATH12K_QMI_WLFW_SERVICE_INS_ID_V01_QCN9274,
+		.qmi_max_chunk_size = SZ_2M,
 		.internal_sleep_clock = false,
 
 		.hw_ops = &qcn9274_ops,
@@ -461,6 +463,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 		.max_radios = 1,
 		.single_pdev_only = true,
 		.qmi_service_ins_id = ATH12K_QMI_WLFW_SERVICE_INS_ID_V01_WCN7850,
+		.qmi_max_chunk_size = SZ_512K,
 		.internal_sleep_clock = true,
 
 		.hw_ops = &wcn7850_ops,
@@ -553,6 +556,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 		.max_radios = 2,
 		.single_pdev_only = false,
 		.qmi_service_ins_id = ATH12K_QMI_WLFW_SERVICE_INS_ID_V01_QCN9274,
+		.qmi_max_chunk_size = SZ_2M,
 		.internal_sleep_clock = false,
 
 		.hw_ops = &qcn9274_ops,
@@ -643,6 +647,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 		.max_radios = 1,
 		.single_pdev_only = false,
 		.qmi_service_ins_id = ATH12K_QMI_WLFW_SERVICE_INS_ID_V01_IPQ5332,
+		.qmi_max_chunk_size = SZ_2M,
 		.internal_sleep_clock = false,
 
 		.hw_ops = &qcn9274_ops,
@@ -728,6 +733,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 		.max_radios = 1,
 		.single_pdev_only = true,
 		.qmi_service_ins_id = ATH12K_QMI_WLFW_SERVICE_INS_ID_V01_WCN7850,
+		.qmi_max_chunk_size = SZ_512K,
 		.internal_sleep_clock = true,
 
 		.hw_ops = &qcc2072_ops,
@@ -821,6 +827,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 		.max_radios = 1,
 		.single_pdev_only = false,
 		.qmi_service_ins_id = ATH12K_QMI_WLFW_SERVICE_INS_ID_V01_IPQ5332,
+		.qmi_max_chunk_size = SZ_2M,
 		.internal_sleep_clock = false,
 
 		.hw_ops = &qcn9274_ops,

-- 
2.25.1

