Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792738944;
	b=xDIvpKwSSjFyAP+L7bS0WCLdoRspYjCsJFAeaz3ibIY42bcJqC/4WRZ7R4nZonhrME2h
	 MnhO2UDp7yg1MYumPAI8k6VAZ+vEHImMCbVR85eTg2pKVazVTF99QjEEglRIvh3NN9210
	 6i0sHUVpBe4R+UVccP7qUgoJ9iD0FqRKCA8JQY8KnFsvPGuR2D/7VrhAcmJA2V4Bu8dcp
	 AbPrvmwBdaI5IGRxRwUS2J4EUn0Fbtq4Kq/Hh6S/dwNrTBgs7ikFiprjAkOWKOYABO+n3
	 c8XQ98Zso2i8rs6wsA9k5PzbpGraA/SDfQqaQ49gEmOqmIVeLieZ5yaPE6UScyAaZjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792738944;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=6aNW9dnDX6TbyEdH720nm0hjQAKn0nJnCofDm4yX0So=;
	b=risCLRNuq+UFJrCF74CHsqEDOgeo0gWiGzksfVZEjvGzDFquZUbb9hX0nffKxZ4Oaju/
	 M+Ymp1UjvxxvASOf2k62ItbUwWUNbZ/fqv45n+Ctfp+8w2tcLM/XYMeRueymAbNs02yWt
	 GTW/MIiDKZeo5Mr5gGV6a7CUa04+cIBIlG/gd/0cQ6WZmiLreiYqFLvQseUKkf0nxLFbe
	 Io44mhvNeA7/+f+0/YOktj/dSPxz5psRROgCH4kK/UrPBOo7EtS808MHspa32RawZoQOj
	 qK+1Rm+6LFnAiNZ34mEjQE76CnXeCDzheOMPY/8CO/W1DlRYotYE73u+y0IHm/bT60w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=CkWWPHAy;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=jyF9m3Pg;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508B8606A31E
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:02:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 508B8606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=CkWWPHAy;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=jyF9m3Pg
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1F1Od1335237
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:02:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	6aNW9dnDX6TbyEdH720nm0hjQAKn0nJnCofDm4yX0So=; b=CkWWPHAyDYD1bpsB
	j5Ru1/0ODhwtBUAhbwHf3AbGnqRap6yVn+9A/bvySg3tneSkbhIDxFaDcI8KdFY7
	WM8fahZOQyKWXHg4HnMHuhiZLD2W2XDSNkPfyJWpIxtYfKkfAlf7I1xGVBl09TxU
	HkFk+7FlMg1f7UZ02BZIOertxVSNSnhPi+k+8vsddcaWNSz3kKEhc0ossFMlYyes
	7iZfVEtGjRuDH7CmvpNPlS/fOotlNCiUc8+5BqSiB0/3dHvMvkU/okhtSjZzhvBj
	yaoJD/N/e3EBnQ8IW82AknBgUp1DxVHQSqM8zPSIEdaYjTEX1b3ny65koxzhs77P
	IIPtMA==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfsyk9tct-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:02:23 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cd5fd34fee0so403533a12.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 00:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792738943; x=1793343743; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6aNW9dnDX6TbyEdH720nm0hjQAKn0nJnCofDm4yX0So=;
        b=jyF9m3PgjOBWPZLdIa4wPV/KfdU39RgTeN7amlkFp2zQ8krpPWT1kVpFu9HCvfUTVI
         ld34B0I0o2iE+LORSCQZc+T1mwl0DsApiQhQlo4mbexpwRZIMd0WqXTO1BrFYvu1JMxO
         EENRl+R1DC3PKsnyw70S3O7rGRMHymLsWdc4q9n81NyO/Mryf+AuZgF9AQiLkFLHUxoX
         bsLWmHMd8HeNeMuGYaHdUtYbLSJp3uDH1wrj0Nn+qu3KlIBYn+/mWt2D/c4GE/4LIhg8
         l/Q77+46Ptk2HRLjSiOnYY44CBCDdFLV52ZY189rxruVHDbyWhKpmOJ/SMudN+9r0jUS
         XPYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792738943; x=1793343743;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6aNW9dnDX6TbyEdH720nm0hjQAKn0nJnCofDm4yX0So=;
        b=G8v+wA6O1u6+e/X9+QLb3Pv9kkrY4+9XiP5Eigt1kEZPcipH2P9df/aPTYZrhCdNNM
         cjciZoK04PWep26XFeGKz9jaq8m5Cz8G02Wz5+WOIdYvYz9EymjZdsOikpbFkrVS/bzE
         BrQN3/Hx2y169Q9F2jpnP9H57ttQeS8UGPzMgAt5RYy7Pi/MGowQiAD2gPlkUPmZjZcb
         O5A53RDs3vAxKz08YyQyIOnhK1vamtI1BQkBCbCnAGP5v9c89xUs1qM138hzRWD2NPy7
         OnZbPXmfieNoiGE/gH9YHnicPXe7ydXh0GoihlrBjG1Gaj7sZnpzMO57eUHcY65jB+2e
         GIJA==
X-Gm-Message-State: AFq9FYLrUgeGli2cNKypVMRF4fhpU8RSvHXBjuakv0Lcvj0WdFxWkP/Q
	5+IzZCg8+5McUbir0BqrHTrpMD6o97EKRa9FoTGIfAzTDdeAPFbYNIRcqEbUGPXeC87wlFvKOq1
	Aih2dA99p1ULNxizu4xe+VfghRtcaOTWPnuv+nKpELZ3Zxy1gHDGo7q+ajHl43uqprUge/A==
X-Gm-Gg: AYBFou1oVwcE1hw0tfNE3KJ3ohX4sQ4QUB3UyUHpZVFGT7hWxDp11M+ZVWnyTpPDNHd
	kCocTaBHOJthUm+scX8qpiVYQcuXQped0pSxO8/rMhZLnTp4UXK4YmlYg9WPO9Ye/xnUNMaESLO
	adBwvx8+r2IlS6upJPINEviVxkq36zli1nqaLRaJc0S9RxFUhPYCMNxnFXpcJa0+bf1uOwDKqQM
	+Y5xpgB7cTC2Dq8lKEQ2B2Ah/GTKAo+oDKEMsRk07w2rjECfqvVbMd7LalA1YXVL4HojdZ7BS0b
	yvtM11Khhv8rR0GpFN7GUjYc1DschRFsLKc+h+KY6xglv4GAeSecE/Uszs7l+3mYA9y491OmShz
	W1XlD+5gKg+UfT773nQ4lq/ZqwmEkPs5gli3YEdaRSyY8M9aAD7y9ogGgADUyJsWqV89owvsCDD
	DD4O6umLiJ3DvWLjwuvckdEA==
X-Received: by 2002:a17:90b:3f8d:b0:3a7:9e3d:b3 with SMTP id 98e67ed59e1d1-3adce7f0654mr926882a91.66.1792738942687;
        Fri, 23 Oct 2026 00:02:22 -0700 (PDT)
X-Received: by 2002:a17:90b:3f8d:b0:3a7:9e3d:b3 with SMTP id 98e67ed59e1d1-3adce7f0654mr926860a91.66.1792738942184;
        Fri, 23 Oct 2026 00:02:22 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8ba8a6dcdsm399751a12.18.2026.10.23.00.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 00:02:21 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 12:31:19 +0530
Subject: [PATCH ath-next v3 16/17] wifi: ath12k: Resolve userPD ID per
 device
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
Message-Id: <20261023-mpp-bringup-v3-16-19f3fcbf7b5f@oss.qualcomm.com>
References: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
In-Reply-To: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfX8MoB1PEntCLg
 KEJHKwfAOMfmwM3vPAi9n8TYwrYC0DlDs+mJO4hIPck4eGVz3PuP65B9MmprOvFMMQO26Kbt0pi
 yKklC54A2mfpRVVSaU42D5UtXBmZnUc5wKo/8trfWWoNfQLUF2MYBj3/+O8AeX74+a0nI1MHJoi
 jxQbyqcxs9RGGemBnX+RZTMk1XwDmQFxzBtjFC8/c8AtiVRXwxEZ4BnEP1sDOKVbdpjVOvVWDEO
 2BulB9tMymqzMvGqnoR92B+R1flME5dEXMHvofQwdqPONJ5F22LUN+wLC2Hxyp3RhxAn3UtK1Ul
 JjOWGZbBxv57XloXZxA2vJxa66bPzotYGapggwzBI1vr1PaDtcCRD6egLgHRVmrxhL0ZAx4IzPD
 EFlOmDhJ98eSiFAlrv78YCHrq/yRqVQyI19svvhk5f0cwl6Smh5KYZb8G+gO3FIJPnWdbeV5B/J
 ezjOg+dbmyFFE9s6Xew==
X-Proofpoint-ORIG-GUID: vy5WZN20M22Xoblrz2GHrcy6ogSRYW4K
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfX4y3Yo5agO7Ho
 +wiQKhHnTS1sbqVXg+zrA3ZwxbFuLwuYpCR7AJGQ/7R3YZ4KCX6weEs/Yc+sGeyHBoZtPJl42dJ
 rWuaBQri+yWUWy8xYwkY/wbg6FUoAmM=
X-Proofpoint-GUID: vy5WZN20M22Xoblrz2GHrcy6ogSRYW4K
X-Authority-Analysis: v=2.4 cv=GLKdgeNK c=1 sm=1 tr=0 ts=6adb067f cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=OMOyA7uMCkrHFcBVPHAA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230027

Currently, the userPD ID is hard-coded during AHB probe. This does not
work for multi-PD platforms where different devices can have different
userPD IDs even when they use the same compatible string.

Resolve the userPD ID based on the device address so that the correct ID
is assigned to each device. The userPD ID is used to determine the
firmware name and PAS ID for firmware authentication.

Also set the multi-PD support based on the AHB device descriptor.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1
Tested-on: QCN6432 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/ahb.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/ahb.c b/drivers/net/wireless/ath/ath12k/wifi7/ahb.c
index bff48b2fe124..889361e637af 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/ahb.c
@@ -16,6 +16,10 @@
 #include "core.h"
 #include "hal.h"
 
+static const struct ath12k_ahb_userpd_map ath12k_wifi7_ahb_userpd_map[] = {
+	{ .io_start = 0x0c000000, .upd_id = ATH12K_AHB_USERPD_ID_0 },
+};
+
 static const struct ath12k_ahb_desc ath12k_wifi7_ahb_desc[] = {
 	[ATH12K_HW_IPQ5332_HW10] = {
 		.hw_rev = ATH12K_HW_IPQ5332_HW10,
@@ -43,6 +47,26 @@ static const struct of_device_id ath12k_wifi7_ahb_of_match[] = {
 
 MODULE_DEVICE_TABLE(of, ath12k_wifi7_ahb_of_match);
 
+static u32 ath12k_wifi7_ahb_get_userpd_id(struct ath12k_base *ab)
+{
+	const struct ath12k_ahb_userpd_map *map;
+	struct resource *res;
+	size_t i;
+
+	res = platform_get_resource(ab->pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(ath12k_wifi7_ahb_userpd_map); i++) {
+		map = &ath12k_wifi7_ahb_userpd_map[i];
+
+		if (map->io_start == res->start)
+			return map->upd_id;
+	}
+
+	return 0;
+}
+
 static int ath12k_wifi7_ahb_probe(struct platform_device *pdev)
 {
 	const struct ath12k_ahb_desc *desc;
@@ -60,7 +84,8 @@ static int ath12k_wifi7_ahb_probe(struct platform_device *pdev)
 	ab->hw_rev = desc->hw_rev;
 	ab->hif.ops = desc->ops;
 	ab_ahb->scm_auth_enabled = desc->auth_enabled;
-	ab_ahb->userpd_id = ATH12K_AHB_USERPD_ID_0;
+	ab_ahb->supports_multipd = desc->supports_multipd;
+	ab_ahb->userpd_id = ath12k_wifi7_ahb_get_userpd_id(ab);
 	if (!ab_ahb->userpd_id)
 		return -EOPNOTSUPP;
 

-- 
2.34.1

