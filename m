Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DB5495AEF
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 10:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791455133; cv=none; b=BfUhYj0dhwH7wkSIra/+nEppZc21sIr0fE1Qvkxn3eJKh9JXhBtxNXB2ZPHmHD25B8DQFzBDRnFi/+gmUyqFOJarSQ6ocSALCczME1gaWChuEIFeXyfDzYsX/52lVYmO1N/+5qbSevrlJrKDA4Ab1sOyJkEoiO5PXgDOJDm3yEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791455133; c=relaxed/simple;
	bh=K/tVYy+6qbueVtZCWtLkH9tCPTJuOOQjJyOkjda3fGo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YTzH8yAOmseddjaM82/o15RM/YdvhSUaofquZgLqZJAflip5KeATRuCoB6KqiZdXXFbmPPdSoe22GEpB20Vf7gF628cgSC5EA4UkgciD4l2/RqmdpxzEbIJmnKyorv4qjDzZSqk9YHb0Uad2TwR9QQuSLcglN9YtIDeeM9o1VLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WYh3HATT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TqmiYmpD; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WYh3HATT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TqmiYmpD"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6987KMc61845748
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 10:25:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	zmsQbMNmP8i2tzXsasw6FBSJec6UK8O4ko7kuCL95o8=; b=WYh3HATTj8NQpdVL
	L8WrDjTB4ZCgvC/7USEJiUlpIxDYZ6O5opUIPus/1BpblGXK5l4NHAuMNaFiru2v
	wZXylQIDpUO6VseYuURW/9Uw5sm5YaCY9msqDpWy0MLoVQmPtlcW9EUhCVB5W0ZJ
	mLa+Q+DeuNDemPxy7mkvpYCYTIx/L6NekzopJijbFkXlOSIVUmh4exIlm9FEmDb9
	KAxE+E1KC5dFaipXHZhhPsbA/OHsk8K4sE2pWKN1KDBs7vb16Pu/VhMXRNsIUcWv
	a3E03xgrSHi3fn7oan3pwjpxk91VgLE/qnZmZPwVKfp5j/ab6FkrLVvivQQTzp+L
	yZO/sg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5xe3jhrh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 10:25:31 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e60770381cso19167445ad.0
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2026 03:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791455130; x=1792059930; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zmsQbMNmP8i2tzXsasw6FBSJec6UK8O4ko7kuCL95o8=;
        b=TqmiYmpDrXUaAfi0V8EaZCOxc/tD6kL/d3lQxqB6zWRaLzkYTRDTjtvw1DAlZMRnOA
         blg1epLOHJ2Tz4pNMtx6FNOgrX1gJaUNyydKwCJwYc1DiVIbZBtA3y+aD2w5YdC/d2h5
         ARMHRenRWAwDz43BCGfXodR/pTLFzyN3a+oBtuFoXxHid7YzxXrd8EgHYWf/9X0cPvnE
         /WkFguJfgGQAybEX8Nk94RId5UVwJsm6P6rghpmIf++OM5vm8x8pY9rZPnd9wkA7eNVI
         Xicev8sSBfwiY50JJjKeEoW7C6uZKbM+OSvI2Ztn7wOT7Zdckhmi9zQmfpObr8kQU7cE
         cZ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791455130; x=1792059930;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zmsQbMNmP8i2tzXsasw6FBSJec6UK8O4ko7kuCL95o8=;
        b=gnnDPzubMGUsl7N0mgMGKcvJjT/MNMoIZwsPJWSJwA3tLMAku+hdon19PCyl7iqL8Q
         dlAK99bq0CETp3FDazZDL0TAadooAPYKpQgwVwmVGhKIZHYWDj5tdw5H4tQGA8xZifeP
         28Vu6juGVG1XRJE0k4WrDDRUo5KgGOC1+7H9vh2Hyp0X1BvJWBqS0NV9+uX8edwEGM+u
         PROMIuI3QKhIbtqPjsNCmTrM4sgoVldAUGTyiwLChQ2htkEuZZJhSmNExVorbh/j6Fdk
         azysTokdaPXmucfYQYT0mknWWxrBf01x4fySuoZCwLfHzJP8utYIZjSRa/Z0DZ4Dp4lp
         /7Lw==
X-Gm-Message-State: AFq9FYKIeThMlFxI+hjlOWckD9JPcZaIuox7exANB1ZNsbSwqqnwdhpA
	QVCNnihcWusfiTYEq3i11PAOK2IRaXR10C/0l4O3r66jW0iMnbR/rMIupRuj9XrRqT7rsRqby61
	aOcrWpArJoQFX77DMH4Jz3rWoIGf5Evc6MLzh1wJl91r0LxRbpb8Cg8cBdG/oJ805AClTvw==
X-Gm-Gg: AYBFou3kkMVlFOcjeOhnVL8fhGrxH47+1A/YoatUOCctcmP3Yep0lQWyjzdluZsGHDT
	yJJYZ+GvTsEAyY86dB3l0sW9MK++u/8TYH9rOfBytaOc0jBMubZihNcY0eCjPwoz9cIM0cP19nJ
	6XM8yMuNCUK5sSsXWrw5c/j9xLOCiv3KvmEMezkdd8LiGLEIGAtJTYliriqbQTgFhJHWbElDx64
	GuRPsvI82xtoL/yvPnzwGuCGS8Gx7TOH3CI+ozW7QEkaoAlsVL9jtgQliIW9F5Rh9C5qZr+03SG
	qTK9DObt4k3pKHR/MJy+MdlWsFVbQ6fMYOuBPckvuDwjb7hL3OkywriKIUsk/7ttu5y0l/wwI+A
	liH3cIG3r0KSedqk8Lx+0RRBEaWeiceJSb28OChMGiUcYY1QWoBfCHqDNH40Mz3MzRcip1O7fJ/
	uX1NAIQZQ6Nsso/SRhMtJ9dw==
X-Received: by 2002:a17:903:4b03:b0:2e7:e73e:7091 with SMTP id d9443c01a7336-2e7e73e7348mr18214305ad.31.1791455130111;
        Thu, 08 Oct 2026 03:25:30 -0700 (PDT)
X-Received: by 2002:a17:903:4b03:b0:2e7:e73e:7091 with SMTP id d9443c01a7336-2e7e73e7348mr18214035ad.31.1791455129590;
        Thu, 08 Oct 2026 03:25:29 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e6046fe39csm22081655ad.16.2026.10.08.03.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 03:25:29 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Date: Thu, 08 Oct 2026 15:54:13 +0530
Subject: [PATCH ath-next 17/17] wifi: ath12k: Add QCN6432 AHB support
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-mpp_bringup-v1-17-2c5797b5e4ac@oss.qualcomm.com>
References: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
In-Reply-To: <20261008-mpp_bringup-v1-0-2c5797b5e4ac@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath12k@lists.infradead.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfXzbg/WkfLmJPq
 TMTnXROTIEprVhEtZ+ZmVXYuH0MkF04cJKuEUKnpTOxQM6fCKBBR/UsdnIxintYZETedwCBCf0R
 3g7a1oR73wAIVH56Oo2IS7hGSi4dRY0=
X-Proofpoint-ORIG-GUID: UtK9czhtyAT6oKC5bhhu2Q4UL9fkfsxY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA0MSBTYWx0ZWRfX5kyuPIE1x4e6
 X0NKngIfBQHi016yaIAHTROJgPj26CdZoWKaB03EtxAXBuEJOxp7lPwnvgHLkhnKT2U7434JF/4
 yvahGyB0XLiY+G4lo42osHr3hprAJ6HY2NfNdgPhA9cu2/+kkj2qxXBV6SJ7U+t4bGgrnKeWUhh
 Qh32O152RQbrgivjwDLCq+9LnOHkKDU6AV7B/U7rUyAJhqhdvZvrVA1Mmv1Lcq8EWL89STAeSIz
 7229y4/CCDkQKFnMpue5GY+KqXDtuisKcj+TIUUP+e+fukjpZZeoZO0bG1Z47+ddO8ZqgkOWnCv
 BXTdjmarB1P7l+KVd6PsVxbCGyZOn7MCv89rV3JXenO6qN6GOFxRdGbul9VKFb2D8lDVlg2GkTs
 9NQnSLr54zli3yzJTS9Ed7DrzyaFg/u2QqAmJ4oqBSarMNuocZu6t1zX1XHZ0fZWblDHPq6GZ6b
 t2BxBIGe4GWspVkNdqQ==
X-Authority-Analysis: v=2.4 cv=IIuXmQvG c=1 sm=1 tr=0 ts=6ac76f9b cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=R6GObu012cZLLkk_EdgA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: UtK9czhtyAT6oKC5bhhu2Q4UL9fkfsxY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080041

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
index 3872aeeb9ba7..04974a6b423d 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/ahb.c
@@ -1210,6 +1210,9 @@ static int ath12k_ahb_resource_init(struct ath12k_base *ab)
 
 	ab->mem_len = resource_size(mem_res);
 
+	if (ab->hw_params->hybrid_bus_type)
+		return 0;
+
 	if (ab->hw_params->ce_remap) {
 		const struct ce_remap *ce_remap = ab->hw_params->ce_remap;
 		/* CE register space is moved out of WCSS and the space is not
@@ -1266,10 +1269,14 @@ static void ath12k_ahb_resource_deinit(struct ath12k_base *ab)
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
index 86359ed1eeb2..98e74bdf0112 100644
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
+	{ .compatible = "qcom,qcn6432-wifi",
+	  .data = (void *)&ath12k_wifi7_ahb_desc[ATH12K_HW_QCN6432_HW10],
+	},
 	{ }
 };
 

-- 
2.34.1

