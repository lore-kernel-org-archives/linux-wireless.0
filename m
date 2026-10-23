Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792738906;
	b=WhB2ZX4Y+P2fclVfKvTSxfbbMzsn/LS363T0baZLh+UPu/LWf6Bec0cMSxfzVezPMi2j
	 TJ8VkBOJQqq7Rsod/WBl2ZzudDwC7g0+DakvSpDya5OijONP0HAeQmBiZ0pyMJGWVRmRm
	 5853oyqueDdCKdlf1OFdiXh6YGYDGcR+JW4Ngr4b6wWZlCYxyG7S9xIsaBWxybMLdZtDO
	 lsogIBJxwIJ05z3zJgmWZg4skRtSt/yCh4wdtnCL7UfI1YisVbLM9tpK+J5Qrfu/rDEfS
	 wtY2obs9IcQQjLPMaqAasOoor6FLNOLv5OX+pl9gpt1WbCgWQ/bVWH1L+K3sy0ZeONQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792738906;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=JPK8TpslLB70Y0ZK7uSlOz+BfsMVxoZ5QXzjmcBIqTA=;
	b=vPHfp//+bajW05ecF1rmp08S1ybYtQTbDXZZhuWiD0MH+Gliu44utlJac8ozAP4FLv5j
	 9jARNYTZkI1+RtIx5KQIAbWQG+oQfl7Ehtv3wQEemkDJ7uFlXq6m0RHHq1HBDnMFGnM4a
	 /fRMddHdrJA7aRjN7IgHMQxNECREu0VX40oA96tXGzg7rwVnRBEI8rKIrEJFSJZn0StCH
	 QttS6XITE65OUhCvJR/4YO9h662ANYCpvSLXG0DGL1QQgHOlPw8klJPp6pe4H6sw2jXNs
	 KSGrhr7Nd7h3nUiB2Z5uVAhVheziH5/AZG6UAGFWusdwxVEGXBuf9TjrgRkQ5Prin8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=gIx07uIp;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DlmfepYP;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C536460A6F4F
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:01:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C536460A6F4F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=gIx07uIp;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DlmfepYP
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N1F9G5425693
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:01:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	JPK8TpslLB70Y0ZK7uSlOz+BfsMVxoZ5QXzjmcBIqTA=; b=gIx07uIpAk0MAa3y
	XfM9O9xdl/hoqcBEf02hqOhSPN2l5cf0wK0tzBPEPz7dRf1Mpk51Nf1hzornWqf6
	cDubKLQnk6/lTEUdG0rISQYZwQSp++p47xTmMCTgdUFIUjkhW1SuD+Ur8EFMjPUU
	IX7zzrHmilfv4vAViXxwnrdXi2dD5wK6rdhtvZvPk926BpjDURWJMeGq82Vgfv7s
	Jp2z67p16pl59Wm1UNBhrSyuIxQDUR8W35OrNEOoeU8x4j9WDQ2jMfZR7aU13p7l
	U8o6BYT8DnwPErGf2cK7RueV8qzIOWfKuacki28+v2VgV7Bc+Qyhbms858KZiGNB
	0h3fpA==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfqms2bdx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 07:01:45 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cd65285537aso245191a12.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 00:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792738904; x=1793343704; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JPK8TpslLB70Y0ZK7uSlOz+BfsMVxoZ5QXzjmcBIqTA=;
        b=DlmfepYPMt+X5u4r7L9v8VH6shAWHvgK0MrVJFlfgpFiCq3F7l3GCtXI2CS8U6m/Gw
         cQZPoKrPzjtpOZXxD+hpns+tMLprA+zzX2nHDmixY3QSH15VBaaa0KlOv2VUJ+CvuDjI
         PILASu2xpgwtCyRRIsCyfEuewSSMZpcFoVXYduu0xqdiExb6UWOFaXhp/jZlXiGETmSU
         OTGyeFNErW3F8tvYcfTAgo78ZOxc4WJ9kbMM2uksz4zGku6e7J4M4GoKqyLzUVb+0mw0
         zN7nDLk+v8ubeQl5RLiiP6Suf5M7EE70FILkBs4BSD5dUq/v3a1dQOaXdcFvzgCrW2PX
         HKRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792738904; x=1793343704;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JPK8TpslLB70Y0ZK7uSlOz+BfsMVxoZ5QXzjmcBIqTA=;
        b=vDMlVJMRnRUp/uEFvlRoNEGRPaQH7TZVU1Vmg1M8iYAryD7ApTUxI+XC+mJtaCBOE6
         GrMhgch1hjmKlYW12br7g4VCSHcEJGVUuxEyRy7fAX9iBdcCDVqoabpO3NMw/I2E1b4X
         dqAcSVROcGyTZTElyV9AwrS8nYaeoBCbW7JxRGxcGMlIi1grsVoP9i9NDbwnEF/vNznX
         0br0wqP5dFHvlW2XwWC6ClagkxglMu3XPwxvrq5bLnxY8gf1b/GmTsgEtR886FwC/Nb7
         aAXdqhT+RKNBVI1gMMGmTo3hqYPh9hTjZIe4FoATizN2XMbi2n3TjfF1MybqqGRF4uTC
         z/WQ==
X-Gm-Message-State: AFq9FYLllQZa/9r9gtBPb2XKlD2nY1TACVLFJWyTzxjUzfvTJTVkcgiv
	8Fjszn8n6Q++rOlwZKSF+j5uldcX5Lts9qhbPmfEVzDEV3VeENyF4/9SP/4oBkDxIgQn0wKNDsT
	6nvGdUmJ9POgo1/Zj0ynxblb/6NRdUvPYyQ3TFDcs3Wnr1pPsgdLOPxrMFkQFDUwzzgL7OQ==
X-Gm-Gg: AYBFou0uRnEBfnYlEuNsyTI/1y8so3aE7if+YYTFbZ1iqZYikuX9jQbgZ0m5WDLL98i
	+rfqFo/oxmVsSoQYn7nxhk77x7z0fEqu8OkUP2m8tMx7DteVMo8EBFfSUEWvhP36hK4G+HOwfcc
	DoBXbPl9zEQ5fruhLMEI8xyk7KxGv0awC0YeiSFNklT4AJs0XMg9wOJGQsWghL3VQT9iUCLLmaS
	Nfiozwdd6n8CgrTFhO87iE4TTLLnDCkYJxZ8oK4OfgzM0OAa6CQtkm0qdksdiIYSVM89l1y2JyP
	eg6Swn0+db8k7XRbljlUvZYp60hAapt6Y0c80i+fNFw/To6WScxGqe0FJ7xGF/YOxSQCGOk2tue
	v7fnAnGH9XN5PWUY94d0HIN+HJnFcV0TNKR3EbF7KKpFZcRTEWsUdvo5SR1B41rAxCatv/eJ4YZ
	QD661aKrQI8eHymFCRPTEOIA==
X-Received: by 2002:a05:6a21:7704:b0:3e2:a935:8bc4 with SMTP id adf61e73a8af0-3e369227495mr1035882637.13.1792738904479;
        Fri, 23 Oct 2026 00:01:44 -0700 (PDT)
X-Received: by 2002:a05:6a21:7704:b0:3e2:a935:8bc4 with SMTP id adf61e73a8af0-3e369227495mr1035854637.13.1792738903977;
        Fri, 23 Oct 2026 00:01:43 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8ba8a6dcdsm399751a12.18.2026.10.23.00.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 00:01:43 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Fri, 23 Oct 2026 12:31:10 +0530
Subject: [PATCH ath-next v3 07/17] wifi: ath12k: Add hybrid_bus_type in
 ath12k_hw_params
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
Message-Id: <20261023-mpp-bringup-v3-7-19f3fcbf7b5f@oss.qualcomm.com>
References: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
In-Reply-To: <20261023-mpp-bringup-v3-0-19f3fcbf7b5f@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfX5/Lq+Dfaunbv
 vy2MbIHLxabbl84d2b5AFMaWUMt4fHg0kSzJ1EC1ic4o+bxGF2dg+nSRlfhlqsIo2FipB4+3+xh
 N0GEvVJkQjpON70fMAKhr8D4z6XIhF2BpEHCEmbph1kuqbaovqEQWv3Q3zsTzN/DhYu2+plJqOh
 R1wUL578Fg8TbJTlBfY6jPFuOR0ruxAMe1ECI53C0xJlBgqArM/42QgRZqwFIHxI7xrZIpaIdOb
 a1xDgNrAjnil0Ez6qvOYs6h8+JrAvtwhB/AdUVK7gEx0ipYBPUVPSsa9H4oNz/qdu6S1/xrl7YS
 UkfQBjdCubMp1Ajgdqok9SJrPoH1K7Syd8jhE6SoalXmam5g6w2yacQL2S5YJNepG2xrc+MHk03
 0vD+x2rMrVIgTzJBVvVEdJdz26dbvEsRVELayPIJh7MCfeTGGKKMR7+2DHSS19jNHAPJnXiBiOm
 otZ3RGuKspnhjhdITgA==
X-Proofpoint-GUID: dFGmHCrFchF58fK1ITYFOYhEgjIB3t2K
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAyNyBTYWx0ZWRfX7Gze6wkrXhkG
 gl1/0Yqzv9Y8G5uSYzV4fhsBqqAFazpJsW2p8Pgo/zqKqooHR55oHiqnUPbVmLi5PqNWDlmlCOJ
 U1DA+eJRD/IYcmum7iLyNKmf3Oa7/jI=
X-Authority-Analysis: v=2.4 cv=UdbE26SN c=1 sm=1 tr=0 ts=6adb0659 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=ZOe4Ua_9D0VdX46zIBUA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-ORIG-GUID: dFGmHCrFchF58fK1ITYFOYhEgjIB3t2K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 bulkscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610230027

QCN6432 is a PCIe-based device attached to the WCSS Q6 processor,
but it is registered as a platform (AHB) device. It uses AHB APIs
for probe and boot. Because of this hybrid nature, it is called as
a hybrid bus device.

Introduce a hybrid_bus_type field in ath12k_hw_params to indicate the
hybrid nature of the device.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1
Tested-on: QCN6432 hw1.0 AHB WLAN.WBE.1.6-01322-QCAHKSWPL_SILICONZ-1

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/hw.h       | 6 ++++++
 drivers/net/wireless/ath/ath12k/wifi7/hw.c | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
index 833aa6d43ce4..fb807d5a6ae4 100644
--- a/drivers/net/wireless/ath/ath12k/hw.h
+++ b/drivers/net/wireless/ath/ath12k/hw.h
@@ -240,6 +240,12 @@ struct ath12k_hw_params {
 
 	bool host_alloc_ml_id;
 	bool advertise_iface_mac_pool;
+	/*
+	 * True for devices with PCIe hardware registered as AHB platform devices.
+	 * Such devices use AHB APIs for probe/boot but PCIe APIs for operation.
+	 * Example: QCN6432 (PCIe device attached to Q6, registered as AHB).
+	 */
+	bool hybrid_bus_type;
 };
 
 struct ath12k_hw_ops {
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index acc4eabcf2bc..f7992f8c917f 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -498,6 +498,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 
 		.host_alloc_ml_id = true,
 		.advertise_iface_mac_pool = false,
+		.hybrid_bus_type = false,
 	},
 	{
 		.name = "wcn7850 hw2.0",
@@ -594,6 +595,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 
 		.host_alloc_ml_id = false,
 		.advertise_iface_mac_pool = true,
+		.hybrid_bus_type = false,
 	},
 	{
 		.name = "qcn9274 hw2.0",
@@ -686,6 +688,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 
 		.host_alloc_ml_id = true,
 		.advertise_iface_mac_pool = false,
+		.hybrid_bus_type = false,
 	},
 	{
 		.name = "ipq5332 hw1.0",
@@ -772,6 +775,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 
 		.host_alloc_ml_id = true,
 		.advertise_iface_mac_pool = false,
+		.hybrid_bus_type = false,
 	},
 	{
 		.name = "qcc2072 hw1.0",
@@ -869,6 +873,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 
 		.host_alloc_ml_id = false,
 		.advertise_iface_mac_pool = true,
+		.hybrid_bus_type = false,
 	},
 	{
 		.name = "ipq5424 hw1.0",
@@ -958,6 +963,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 
 		.host_alloc_ml_id = true,
 		.advertise_iface_mac_pool = false,
+		.hybrid_bus_type = false,
 	},
 	{
 		.name = "qcn6432 hw1.0",
@@ -1044,6 +1050,7 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 
 		.host_alloc_ml_id = true,
 		.advertise_iface_mac_pool = false,
+		.hybrid_bus_type = true,
 	},
 };
 

-- 
2.34.1

