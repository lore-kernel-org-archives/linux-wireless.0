Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792738893;
	b=0XYWKzwDb6sECyX7fXUGcoE6FgQgadsSrCJDCuI/T17qHAwdMvzen+kx9go/9PVkgWmL
	 Kg/QbHpHn33wVj/Nrsob3WaeNM+Q6sUWsGodCjeEYcegJDduFkA/NGl9hKHy0XZRhKbm2
	 hHL3aOVsDWngIdaaeEIQrOUCeHxh00tKyV7XD4o8GUskQKy6HdvOYWgZB+GnklRdjZ2lu
	 HN0WCgilCjkYgH4/5osQK9+c+F0GQqmCq19i/2iQ+IxHeQQBzZh2WMi5r47j6wTe9l846
	 l9+uWouGib72FvWsvGyvLf3VU0DCKT/EBAUsKAku8+3uRoBUOyCV3VAgnPGI1Sjp8hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792738893;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=+vOE8sL9t6xNjcUysD0wOX3Qs2fD0W5uM0CzKej9jTQ=;
	b=p7EjEwH7VA2RIecsdkd0jyzva9GyL+LKWrmDblyVk+nx3yuC3clLKhel91e//348R3JS
	 OV1cBiAvxyvbIuNIv5CONQFWI3DkZBYZFyN/2rz8i0SZfKd8np5DaYhbvxwrSBhh5ye/l
	 YqJB+FHnEIF9IsnXDTEcT2qcxWKfrG3yJce4R3c9kBlJ06H4uxGojFagIOQWNpvvlVChA
	 /+fIMOv1THZmTF+nfVUyPeog1IjeTi2/Cxa5kZNkGViUI8tnWvggrwh/GIFhWhHKxStBj
	 whHijXwB2FiKXBF7Y9wdMGTxS35lt8bJOX0H03A8GyI/7spuDzRlbSm1TDdVsWLTDkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=hKQbarb1;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=IBn2Yq8R;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F309360A2602
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:01:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F309360A2602
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=hKQbarb1;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=IBn2Yq8R
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1EsN7772842
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:01:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+vOE8sL9t6xNjcUysD0wOX3Qs2fD0W5uM0CzKej9jTQ=; b=hKQbarb1BYVCgfgx
	WS/Joh4mAyMiwZ+731RXvNT5GoeO+DnRvJPZCjaDWqav7xWvyXBSnAnsxiBd0CwB
	ETcvfgUrr4SxmD2LArtCpzPKqy+Gj9TNydj9Au+PZYMtiYHD0Pd8IlgxBTeSUX4y
	0KY/aoPUDqOaZB33uIFi0KlfXcdyyk7XN2u9NvPK5XYbQVaLoq+Gch+FUl7GGhNv
	EEm6g+YBCSuc3wqf37qD+r/y/lBc/e8LzRPWKsZJBmMTvcfqrZhFpTLFp1GcPgIj
	/IXihBPgO/NyjMUysbnHPIzSj8s6LnOZ4+9lIdG8asbHKuFvB5EdVrm/4MRFX8EB
	3wYDgw==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfqmttbm8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:01:32 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cd67d4bbdffso463399a12.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 00:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792738891; x=1793343691; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+vOE8sL9t6xNjcUysD0wOX3Qs2fD0W5uM0CzKej9jTQ=;
        b=IBn2Yq8RtI2cQVRhH/1Cs+qyx1iA8767pMv3ELW+fjdaPPhL+mLSSpeRBIe8dZ+JQb
         okgoG/z5P6dtTeRjanNUKvFu8kcDI9SJSSjR+FQQezUZC6SKcluiA9xsZubShmVSpcvf
         IBRMhSM5//7UUtrbSJGopcG+p+GjZGg2dzN57RGqeCWRIUqlgfDxRe3YIz0a9b6NlFE/
         B0/AKmjGVobfqly/6X5/Rz4i2ixavTLOMmIMWsWq8jnQV/Rk24a0trxckpX5dLfNufkd
         wwPG+2f0KuSuaRwYn5RYoMJIClrV8ZwXpRbuNN5WGXiTbtVNgDjnSLd5VTYIlIrVU1h7
         gUuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792738891; x=1793343691;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+vOE8sL9t6xNjcUysD0wOX3Qs2fD0W5uM0CzKej9jTQ=;
        b=SnkEifyeDv4xuN91EIIO3eftXWmG3DRGUVQuWEqrPSeBeyBW6qCSRRHIsGsxW7s+QF
         CAK7TLsQeYUYy/PSP9DmYhg9bTzxro40K27pENqCrEXLNLzqEkGpQAMd4xTqqoZDO5nk
         IbITRqzIBlBSgKn0VDnnnyDZSjREsZYQYYpHvkPmReMuxCgsC+NT4h+c4xxBr62QQ2lm
         D7HHl/byl8bFEUQ9xxHC37WMuTPU6fJVo65zFVetROz8b72cfN6gWWOdcwPDOzXvOJbu
         fiQDs6SbH3iIO5w4BUFJ51x6fMqfEhI9LVxHx5xJRHYNHFIwRFdfs47KotY8PGr5BwSj
         b7iA==
X-Gm-Message-State: AFq9FYIg/4xhTjDrzql37yMUFjRXJxwG3EXbKIKRdecaVKFo2zBjjmh/
	VM8IU26W18hr1uJwxR7zUWpSNZN+u0mlJqLmC49xwyaQR2p0AQQaK1cCByMULT5dffXldUSwWK6
	g+EDadmrQcld0bHWvOysjugylwYICIua0Q8u3MDhSkh4KqoLF9ez8Qm32UNYKcQQ0S5sP2Q==
X-Gm-Gg: AYBFou3LO2gOBN0zWtV2whSM1fbUoBwWxnR5vyPLllT9o1dLkevtUIcjhD9hf3T9IU1
	bZ/w2uhaSpx/RY4n/MtisINFky/HFz2/ejR5aFFAJKAvSF1RACy32GCfFf40tgd/aKxSsQ+G349
	L/5Pb2+M39jywEEFlFtin9IZLU2lJgkn5QAZyaAtmYVnT6xJlZ/4yyxGYPJbtu09SJBEBrt1AJM
	fjXvD89FWzUs3V5fEZrn2+E+wS9ZRtVRewVOtzNAk62bAnlPXE8mngsSW2iyNQHuvZ+ABro1nbC
	+orFXxFcxGIcbuYtL7rmklgju8W588un0rCL6GGXaJNxaPSVEPpXS8p0zJY+F9f8BExVGibM/O6
	O09W2Ej9GOx9WxjnqxnIDIb7KrA8kzT3JPkwAOpYFDNj2DIY/64i9xpxyeSq/GK/SPboqkIAVlJ
	xKkhrXIsIMtsZ/+tfuYDRsUg==
X-Received: by 2002:a05:6a21:7e8e:b0:3de:48e4:c37d with SMTP id adf61e73a8af0-3e3693502dbmr832380637.26.1792738891412;
        Fri, 23 Oct 2026 00:01:31 -0700 (PDT)
X-Received: by 2002:a05:6a21:7e8e:b0:3de:48e4:c37d with SMTP id adf61e73a8af0-3e3693502dbmr832359637.26.1792738890923;
        Fri, 23 Oct 2026 00:01:30 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8ba8a6dcdsm399751a12.18.2026.10.23.00.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 00:01:30 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 12:31:07 +0530
Subject: [PATCH ath-next v3 04/17] wifi: ath12k: Add hardware ring mask for
 QCN6432
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
Message-Id: <20261023-mpp-bringup-v3-4-19f3fcbf7b5f@oss.qualcomm.com>
References: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
In-Reply-To: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Authority-Analysis: v=2.4 cv=Gt3XaU1C c=1 sm=1 tr=0 ts=6adb064c cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=qBdOBzyLVJzNEwNtDhoA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: tk7yJhsWPWs57U3bO_jJyS59bWJSqLzz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfX1kowaonmarmS
 B52d2HSjznjKFNJxB1Q8piT3uGs515CXyFZpn46jInfadebRB8+ke8ODrixzhDL8x3rkz0VNoUL
 J/y4E0iVP6WhXq9ij5aCr1h8LHvZQdh6juhB+hPzvrTCxiU8+I6veksD+B6iRQvLcqu9FwmfPXW
 D+Ybg9fISUQ22lNu5gUGK2dqgwCtzmG8WCjwfAX74o+8dQG9CUQuckl+Hmv7pVNDb/sKQkSJh9f
 9QA5AduthZBANpYAFuhW9e5zAEiD6PBIShuaFTv2qNFjmdWXyrZ2FlL7iNQDlEbCLFprb7xyQeU
 poEsX2nA9QPFORHrltuscCw3jXxoTLyrbUbX9zKkuO2mYZd4dnchozTWd/rTVSKuhBw+sHFexY3
 EEELpi/TgaLgvL7HcPKm1JdTfXa2NpJg1K9T998haQg7lyugrpXLF5d78EZWKZo/ev3dQn5piF0
 JA+syt7Ciq76/IZCYnw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfXxpDEPCs+5ZYq
 x8SIvziMJE/Stdyd/+KeHvGM6oUIin62iLDEuK4pkOdl8TdQnyEpt/rWkpnfsgvRhOu/DxDZa0I
 16EwHegmOQTf0lhnUBtx/Rx5Y+Z9GQo=
X-Proofpoint-ORIG-GUID: tk7yJhsWPWs57U3bO_jJyS59bWJSqLzz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 phishscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610230027

From: Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>

Add hardware ring mask configuration for QCN6432 to support interrupt group
mappings for various hardware rings.

The QCN6432 requires a different ring mask configuration compared to
IPQ5332 and QCN9274, with support for up to 12 external IRQ groups
instead of the previous maximum of 11. Hence add a dedicated ring mask
structure that defines the interrupt group assignments for TX rings,
RX rings, RX monitor destination, RX error handling, RX WBM release,
REO status, Host2RXDMA communication, and TX monitor destination.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1
Tested-on: QCN6432 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1

Signed-off-by: Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/hw.h       |  2 +-
 drivers/net/wireless/ath/ath12k/wifi7/hw.c | 52 +++++++++++++++++++++++++++++-
 2 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
index 52558dd126a0..833aa6d43ce4 100644
--- a/drivers/net/wireless/ath/ath12k/hw.h
+++ b/drivers/net/wireless/ath/ath12k/hw.h
@@ -127,7 +127,7 @@ enum ath12k_bus {
 	ATH12K_BUS_AHB,
 };
 
-#define ATH12K_EXT_IRQ_GRP_NUM_MAX 11
+#define ATH12K_EXT_IRQ_GRP_NUM_MAX 12
 
 struct hal_rx_desc;
 struct hal_tcl_data_cmd;
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index 643c95c9bccd..acc4eabcf2bc 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -332,6 +332,56 @@ static const struct ath12k_hw_ring_mask ath12k_wifi7_hw_ring_mask_wcn7850 = {
 	},
 };
 
+static const struct ath12k_hw_ring_mask ath12k_wifi7_hw_ring_mask_qcn6432 = {
+	.tx  = {
+		ATH12K_TX_RING_MASK_0,
+		ATH12K_TX_RING_MASK_1,
+		ATH12K_TX_RING_MASK_2,
+		0, 0, 0, 0, 0, 0, 0, 0,
+		ATH12K_TX_RING_MASK_3
+	},
+	.rx_mon_dest = {
+		0, 0, 0, 0, 0, 0, 0, 0,
+		ATH12K_RX_MON_RING_MASK_0,
+		ATH12K_RX_MON_RING_MASK_1,
+		ATH12K_RX_MON_RING_MASK_2,
+		0
+	},
+	.rx = {
+		0, 0, 0, 0,
+		ATH12K_RX_RING_MASK_0,
+		ATH12K_RX_RING_MASK_1,
+		ATH12K_RX_RING_MASK_2,
+		ATH12K_RX_RING_MASK_3,
+		0, 0, 0, 0
+	},
+	.rx_err = {
+		0, 0, 0,
+		ATH12K_RX_ERR_RING_MASK_0,
+		0, 0, 0, 0, 0, 0, 0, 0
+	},
+	.rx_wbm_rel = {
+		0, 0, 0,
+		ATH12K_RX_WBM_REL_RING_MASK_0,
+		0, 0, 0, 0, 0, 0, 0, 0
+	},
+	.reo_status = {
+		0, 0, 0,
+		ATH12K_REO_STATUS_RING_MASK_0,
+		0, 0, 0, 0, 0, 0, 0, 0
+	},
+	.host2rxdma = {
+		0, 0,
+		ATH12K_HOST2RXDMA_RING_MASK_0,
+		0, 0, 0, 0, 0, 0, 0, 0, 0
+	},
+	.tx_mon_dest = {
+		ATH12K_TX_MON_RING_MASK_0,
+		0, 0, 0, 0, 0, 0, 0, 0, 0,
+		0, 0
+	},
+};
+
 static const struct ce_ie_addr ath12k_wifi7_ce_ie_addr_ipq5332 = {
 	.ie1_reg_addr = CE_HOST_IPQ5332_IE_ADDRESS - HAL_IPQ5332_CE_WFSS_REG_BASE,
 	.ie2_reg_addr = CE_HOST_IPQ5332_IE_2_ADDRESS - HAL_IPQ5332_CE_WFSS_REG_BASE,
@@ -926,7 +976,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 		.internal_sleep_clock = false,
 
 		.hw_ops = &qcn9274_ops,
-		.ring_mask = &ath12k_wifi7_hw_ring_mask_ipq5332,
+		.ring_mask = &ath12k_wifi7_hw_ring_mask_qcn6432,
 
 		.host_ce_config = ath12k_wifi7_host_ce_config_ipq5332,
 		.ce_count = 12,

-- 
2.34.1

