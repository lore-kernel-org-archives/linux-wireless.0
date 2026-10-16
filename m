Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89A73B8D7E
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792120989; cv=none; b=C+uc2eyNqO2kSYtbn0ryJDjSlrZZO4BluX+SGSRqubWcDdhsjWGAnksPMtomfrEXSV/kzuxbCXucwZbjh59U8pYw45Jc3x2gBPGUVRmYtFCCT923pDGVyjR8xZqrV6CCn0GFE+J1kXdlpSKzMs3ZR5KH+y6puIWRVLxcbaAol7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792120989; c=relaxed/simple;
	bh=oSOCS0VBj3DNzjAR+TkGA03Y0EsosNVo9a1JHQfcHLQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VbsU777/ow48EMOXlsuuF84zK0R9wbrP508c1B5LNQ1sI3B83/NjwBEHr1vbZAFHMMvlSuBw84uvSZC3Em/xgptHcH0j91mRdh2HpuU8XmDy4HmgjAu7U39zys7ukRbnuyCeOxM/FJV+TFeiwVkzF4/bEcOVIRSuuhADnEEnfgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JWE75Mf3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AdTUNc9N; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JWE75Mf3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AdTUNc9N"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69G27FWt3202386
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:23:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LlYuG6WB38gIzmIC/YDa25c8nS2xNNSGEFoJZF8X6UA=; b=JWE75Mf3H5ggkTcH
	KL6JvNmkPzi5ayxxi8n675rcfS3aX3hLGdEo4WffSfbXiqA6q859/N0xixZYx3sM
	jPpPevJpqO9HglFL44Z+dcb3bDLK+q8z/6d2HbP3mCGRklU4ixQR5NtypDcmq3H2
	M1vW4bn9A4HADRXwrknJt4ydJ77L+aj/BGawS847xUPdk07ub/qjmKS5cP+V6XoR
	eWbwrJumyuopgyZpeCSmnFX/y6lCngfcVV0XXM8oRdCYX8mhU0Rpa8irBb3Hpaxu
	+ivcmQIp3WC6QRStiKbvffz74US5gUEoGl3Wv2RTneRyv69iQLZPkNidJ86sdqD0
	v/8hfQ==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hb3r39u32-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:23:07 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-30bcb065bfdso10585652eec.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 20:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792120987; x=1792725787; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LlYuG6WB38gIzmIC/YDa25c8nS2xNNSGEFoJZF8X6UA=;
        b=AdTUNc9NTUli/+e2DWGMRPagpYoUflhOm84GFz8WXNtl3cHXJ2Cdqu1szoFTYIKX6n
         RHB14HnN0o0Slj1NFERq2sKkFoRneG2LP04jz29sIOX4k/tmqWcW0vWRvreu0lfCKdax
         I1UlE7c/VtHeIFnEIuAHiFu72F3uk/LHWLOTZ/+EaQfE7AjtUzbtj+D9ms0XVHKWhcRR
         ygVPwpFOuZqe1L3uAO1bbSw+lP1x1tNZGU0stn8G7jaov12N3Z8AnwhApMjnLzKylzpC
         9F3Ca/7UzhUOo0+IbBnL/F/uZerVWxeCsOFiD3ytwnvtTJAMW3T84txEuByrlD+XEeJy
         dylw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792120987; x=1792725787;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LlYuG6WB38gIzmIC/YDa25c8nS2xNNSGEFoJZF8X6UA=;
        b=eQYygRVjXmIm+L5c/ecC9zDRMuBJXNQj/XHaecvWLk6Byzq4XE7kBipU6MDc5925Pd
         ckiW0SUFzU4ae1jlXWLgs3I8wW7KNrBPN3XHz4hv6fPoDVsbQfScgJtm3uPhj12cbwS6
         amQnDXRkhvvT0JzFVclR7HQmsObLSIwcRpIQkqI5B3xseMQM7hIKTwVYfSfEhII7AE7O
         NSN2/YIRwdm9uAMZXbImaCe1T/QeKKbyPQX3JIJ54v3UYTOEm3VCl4leN27f0jnr17Dn
         UEC+blGk90KpR+nB1VXw5Q7VSyzR9b9ZnxUzeLsi2Vnfg5o+bsKxCScw9kU6vEyh69eT
         cgVg==
X-Gm-Message-State: AFq9FYJL3GE9wyYZrneUqYYwDAAsNeUbiiYjrU9NUZlYKbOp8kAXwWCl
	O4/dtIZyyyK0q3bstoTzDY2pwNzP2jIoHkb/WvaL52bgK2gVdDCFZl18ObqeMRoaIhX6g8l/0zF
	jTgDHsgm9V68v8y2dfLyKjp6DfnWIdgrx9LhIrVIuybXAhgBLbflu3XGnFPb0zyvyuMHM0A==
X-Gm-Gg: AYBFou1mpLjxTYp6cdQ1Pgh5r9WJPEsZIQeKF1iJGdFKEGBoh+pdUaxEfF3qwhViBYy
	BiirR96k+t+S/fB4Gm4e3w0hqAJMixB1GFdxUtBeoBKZhuDlRLHSIUNV9Db4YcJmHXiv6Hu1rsx
	/c8bREisYBWxkS5aeZZMyX1/fUkeptqh1f+IyY3UDVY+GXc5/C8ZMduiCTmifkYGgkkOs2kN7aU
	8CCWuk0yYIAyhzHLD+BFKpUTneat34uA3Hr6Hjb1id1tt52qa4CXWWpXeXWz6HsmzfzjdqKul6J
	kzvFjTFWwOuGTK+fDjSuy8UXUH7S0UjmuKegjojpRgKDurM5ORwJ0nEhVQUGLyR+IcRhJdGKqa9
	P5x3UAljGSO4SMNBpU6a2o6NJ2LnAiTA8q4DA5WGlhIg3MMPgmlS+Q0kdtQAOouyqqF17vuYLqc
	Wyssl82v87CmFL+9IRiltogQ==
X-Received: by 2002:a05:7300:e9dc:10b0:35e:9c54:d41b with SMTP id 5a478bee46e88-35e9c54d579mr8417799eec.21.1792120987257;
        Thu, 15 Oct 2026 20:23:07 -0700 (PDT)
X-Received: by 2002:a05:7300:e9dc:10b0:35e:9c54:d41b with SMTP id 5a478bee46e88-35e9c54d579mr8417767eec.21.1792120986630;
        Thu, 15 Oct 2026 20:23:06 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360819be413sm2256698eec.13.2026.10.15.20.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:23:06 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 08:51:54 +0530
Subject: [PATCH ath-next v2 17/17] wifi: ath12k: Add QCN6432 AHB support
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mpp-bringup-v2-17-f510c33bfcf5@oss.qualcomm.com>
References: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
In-Reply-To: <20261016-mpp-bringup-v2-0-f510c33bfcf5@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfXxcPlTXeFHfC5
 73rrU4oNk1yj+kWYckJ32hMKe2OKT2L1DBKkYavMadjZ9BV6HjpPp9icXZ6iojDJxIKtm95+uy/
 aLKeS/UelLc2u9XfqbILysaQWvk+USJLKwfaXrC9JsintIPr7SqASBPZVZHkvzegVF04c/7+MXO
 VRuwwjmLUqIYUUdQ+wlP8QtzXlPXn21wo2DCyYdiNddMQT5B+YTlCiaU10CSM8usNoQP3zUMrw1
 Y6z34Xd+zlnw+bx1MXLGyOZRxVHSiRY6Z7VnObyaPugKGEfV16cobz9IWoPq9sGDevEZPHiLefY
 iIGDR98VMCq/gLk7+3DF4f1Jt5jLWUAZvAdLAdPnikuxh2AL4aiM+NMbzbapmRFNRpYLXwl+tt9
 eZ2unSkioz5apGN+H0CMTBoi6w9usSa3WZVk8PrDfmWqXn7osK0rczsKAD49ucI4rzq6+iS7cnb
 YcyOrWoLHp8nNXeK2/g==
X-Proofpoint-GUID: TFDFOYbDyVbFCNPZ4q3nKTrbYM2zfKBT
X-Proofpoint-ORIG-GUID: TFDFOYbDyVbFCNPZ4q3nKTrbYM2zfKBT
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAxMiBTYWx0ZWRfX27a9hKDda5p+
 46FqMZOP5zGo0rC/d+nR9vOAVf2dIr/fxrkrTjXLtA9ousua/UOCxTuc0xjw7gVPfiPj96K4Zox
 BJraakt94mi3DEFEZQ4gUCn8ySZQBcU=
X-Authority-Analysis: v=2.4 cv=INGXmQvG c=1 sm=1 tr=0 ts=6ad1989b cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=R6GObu012cZLLkk_EdgA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 suspectscore=0 bulkscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160012

Add AHB support for QCN6432 by adding its hardware descriptor and
device-tree compatible entry.

QCN6432 uses a hybrid bus where the CE memory is handled through the
PCI interface. Skip the CE remapping and cleanup in the AHB resource
initialization and deinitialization for hybrid bus devices.

Also add the UserPD mappings required for the QCN6432 devices.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1
Tested-on: QCN6432 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/ahb.c       |  9 ++++++++-
 drivers/net/wireless/ath/ath12k/wifi7/ahb.c | 11 +++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
index cecafc12e8a8..b55590c64a2c 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/ahb.c
@@ -1233,6 +1233,9 @@ static int ath12k_ahb_resource_init(struct ath12k_base *ab)
 
 	ab->mem_len = resource_size(mem_res);
 
+	if (ab->hw_params->hybrid_bus_type)
+		return 0;
+
 	if (ab->hw_params->ce_remap) {
 		const struct ce_remap *ce_remap = ab->hw_params->ce_remap;
 		/* CE register space is moved out of WCSS and the space is not
@@ -1289,10 +1292,14 @@ static void ath12k_ahb_resource_deinit(struct ath12k_base *ab)
 	if (ab->mem)
 		devm_iounmap(ab->dev, ab->mem);
 
+	ab->mem = NULL;
+
+	if (ab->hw_params->hybrid_bus_type)
+		return;
+
 	if (ab->mem_ce)
 		iounmap(ab->mem_ce);
 
-	ab->mem = NULL;
 	ab->mem_ce = NULL;
 
 	clk_disable_unprepare(ab_ahb->xo_clk);
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/ahb.c b/drivers/net/wireless/ath/ath12k/wifi7/ahb.c
index 889361e637af..ae5380eb6f8f 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/ahb.c
@@ -18,6 +18,8 @@
 
 static const struct ath12k_ahb_userpd_map ath12k_wifi7_ahb_userpd_map[] = {
 	{ .io_start = 0x0c000000, .upd_id = ATH12K_AHB_USERPD_ID_0 },
+	{ .io_start = 0x21e00000, .upd_id = ATH12K_AHB_USERPD_ID_1 },
+	{ .io_start = 0x19e00000, .upd_id = ATH12K_AHB_USERPD_ID_2 },
 };
 
 static const struct ath12k_ahb_desc ath12k_wifi7_ahb_desc[] = {
@@ -33,6 +35,12 @@ static const struct ath12k_ahb_desc ath12k_wifi7_ahb_desc[] = {
 		.ops = &ath12k_ahb_hif_ops,
 		.supports_multipd = false,
 	},
+	[ATH12K_HW_QCN6432_HW10] = {
+		.hw_rev = ATH12K_HW_QCN6432_HW10,
+		.auth_enabled = true,
+		.ops = &ath12k_ahb_hif_ops_qcn6432,
+		.supports_multipd = true,
+	},
 };
 
 static const struct of_device_id ath12k_wifi7_ahb_of_match[] = {
@@ -42,6 +50,9 @@ static const struct of_device_id ath12k_wifi7_ahb_of_match[] = {
 	{ .compatible = "qcom,ipq5424-wifi",
 	  .data = (void *)&ath12k_wifi7_ahb_desc[ATH12K_HW_IPQ5424_HW10],
 	},
+	{ .compatible = "qcom,qcn6432",
+	  .data = (void *)&ath12k_wifi7_ahb_desc[ATH12K_HW_QCN6432_HW10],
+	},
 	{ }
 };
 

-- 
2.34.1

