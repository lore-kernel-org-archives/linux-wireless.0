Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA07C356761
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 01:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785373520; cv=none; b=FNqYGIdlyEBJ20GrTMoPNO3uBNjkJc+5Z3XKwd324rP8DPaVwqFxD9iFpzzakHK4g8Rpw/YbOKSdzZcnYaAewVlFz4Cf1zzSfJjGj2vzxhwHO1I44y97eLkEWfRnZguWt4EjlPBHCVNrDatXNkrlFPsfbWgFhSYGlkwp8XEG5dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785373520; c=relaxed/simple;
	bh=aEGf7PIuBZ+MHW/eqEqoQXnJ2uzCpXMwo/25tnWSSRM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LicwASO6NZMfmzoCLHeC7dlbftv0GXXwGe/3gpgLaykd/zFnKN9KxJEadL8Sqr9JczF+HNXn9sD96s0x5VgXUXcWn7Rjf7yCoFYqvWIvMjSXHN86CnqsAeu7ljAcArv6GtZFIt6qaSFaQ/jNxv9l6zypnnc/1Ebhh5wGubNXh0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LF2JPwHN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gaXVtGLh; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LF2JPwHN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gaXVtGLh"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U0g3Qv3587015
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 01:05:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=ZYFFatroACJ
	PZgrWGjCltvltJd9wtFIF3w6l6ozfvvM=; b=LF2JPwHNAcAcRwVXVbQLYDQpR/D
	P2naiK7e4f11l1YD7xBCQKmaQ8VqNdMYY8+YGg+s311mubJgqor8QIgBG1d8VRrt
	RgQiUxt9596wIjwRhI9+H+YSAdPcvFmteLemLceqWVK/TWEiUHaR99eYyZgkyQ3O
	7/nW/4W5s1CZKvir+XvdueqV4qpRRfgSDKgUE0psXABp8ncW2Swy1jyJ19FN1VxU
	MfBjLfPP5PkSt8NxVnTS40atlyUSSTF3hUedA0PdDiN2EXtVOMe1ms+1jzKNa7wb
	+ColVwaVGurZThRV3Iy/klA1tfvPTQYdub2RrO8qFt82Pc2uxfI2WmqY03w==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqv2ng354-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 01:05:17 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8488ac68185so3556264b3a.2
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 18:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785373517; x=1785978317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZYFFatroACJPZgrWGjCltvltJd9wtFIF3w6l6ozfvvM=;
        b=gaXVtGLh06txl2SqmVfCemq6yySaUZWkG4QfEwbFQsEesl0VlSR492AGE6pdvzX5/T
         1lB0nvCIHj/5qfxUVmt2TwDWj8zS1aNXDzofZqjUD1uquksW3ptKNJTZECNgn1CC52UN
         mySM+gvY6J3xs6rqXFgWcivEehUxmn5/2A0loSIuTLmBe68cd5pfrgL3hMfU4USyJIBP
         adCwCD18wTRRW+FPxFevLu3Dhqi1Eb7Ty0v6CYAF+jIOpgMVoGu44SOnW3GcPziMBQdd
         3Kg1NES2ZyP2N5ov53fZjfQmCmNHmxzHhGA85wB7zf7kjSYEVwnZCorkcS0MHNudgRzt
         Y7JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785373517; x=1785978317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZYFFatroACJPZgrWGjCltvltJd9wtFIF3w6l6ozfvvM=;
        b=oZDDAl7YG81jV0CXoc+5d5JcpDCukFA5Azi9mp8YrKsIliICT7GtO2RD1RZzFwvZ4D
         HaJDNVpMUU4qTtbD95K4Sk57Fpek4v1Df38FHzFawspV3wXEEcDOUg30remJAysivRBn
         A4TR/ZNDPaKZ/AegjKwIOhUKEGU2z2nB4NR3KQvix4OIQMLsEU1lBTDLX7kZJGNkd+vW
         d87DG9qNLPelgWjZpcgN0ZnYD78nEpRJAz1ZhdYWFPmMQnfPQf6VyEtNIZ2DGdTlwbTp
         jnGyql4ybKdIWHK+8VtigFdvKHzvwinuxW7cr+XMHA6Xz/xgtzDnCgrct10yOjLnRsKL
         65/Q==
X-Forwarded-Encrypted: i=1; AHgh+Ro5YA3+I98A0OXfoKD6W+m3FFziQ9J3ievweBTQIGeOoL9LGxZxWfXeATBgrrSe7mgd3oFbmVeEWEPuYj+Wsg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx998Gbnzf6Dpcy8e5jtFRgcuqDtu0bTLoqgqZ0tDOHq0ewsPfR
	gajg6eliFXu8rDIhTlRieyI5CHMktXbTQRhoGguPoa0GZsL4S8/p+f/2BIzd9ByP3GcRZhGoHtm
	XCd4JstPACYKWvJuCGFCxrOy7Qc/30VlT8RxbGcB1vFX0kuXJOYfMmwCc1Olwk1eVO6sPaQ==
X-Gm-Gg: AR+sD13nF2FxkGeMLC2XL9H8yFoXH5xqV45qpMf7dZCL/r/bEEEzxpV0DdlxtlNQPne
	d1unu5MfTrIQiGWVmPSFT5u51XBZSNiqA5Y8S1rU3X6rT7q2TxsVmzleV6s91Qt/CZ2hfCLJAkQ
	X4zr1aULJXgtJq8JhTl8e8BMRmS8GCFq2xjhCUw708K7vuDCulhDzrSm8F0p41X3VikZvMi7Z2n
	JwYfeladEXj6tL5+tJnfQXyhWzMc2/luipQl6ZRciexXFW5Ak06/drrYnZykSADvhZx4AVa5N5v
	+u+bbay+P6V7eExqvnbb0OEs4/kG5Z94rPi0/+91dZraHE0JAJn3D0kUlv3C8sjw55bFVEzjvQc
	+INMXrjoXnIwaVtOhRtTdw86C+FZTh5Zdk22jE2nKM+hO0P13wC28vbPXFeo=
X-Received: by 2002:a05:6a00:3495:b0:847:9aa8:d3bb with SMTP id d2e1a72fcca58-84ebc1f5e37mr658356b3a.12.1785373516683;
        Wed, 29 Jul 2026 18:05:16 -0700 (PDT)
X-Received: by 2002:a05:6a00:3495:b0:847:9aa8:d3bb with SMTP id d2e1a72fcca58-84ebc1f5e37mr658319b3a.12.1785373516286;
        Wed, 29 Jul 2026 18:05:16 -0700 (PDT)
Received: from Z2-SFF-G9-MQ.ap.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe23120sm2168563b3a.11.2026.07.29.18.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 18:05:15 -0700 (PDT)
From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
To: jjohnson@kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Subject: [PATCH ath-current 2/3] wifi: ath11k: fix NULL dereference in ahb remove when QMI init incomplete
Date: Thu, 30 Jul 2026 09:05:04 +0800
Message-Id: <20260730010505.143458-3-miaoqing.pan@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260730010505.143458-1-miaoqing.pan@oss.qualcomm.com>
References: <20260730010505.143458-1-miaoqing.pan@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDAwNCBTYWx0ZWRfXztGg1yqx7H5N
 QYzwottjWbWWs/2xl5nXwM7O8PdYLt0fZfeUcQ7eFUJjL8xsB03ybLTRN9cOXet9zqWKS4mp9g7
 wuTIfR6kmLOooAowVQ6EpfeLh1EJHHs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDAwNCBTYWx0ZWRfXzPHHsdGuegn3
 TAZN+jEUZYeqdVqrugHmvvZMmsdAUfLhThOkQKRTewNmtVy2oL/cqGcmA2RQKeK7GNS1QFT8JaI
 JKxvn95XrVyzNQ5Kx5XJ6yiH3/HyCf2O8HxOnsA3ptNS2cVKGNxAXycc7NsGZh7ybQd97n7u6Bj
 ibXPuilmZUcvowho6HKM3u09/4usGtbZS8itb1mhmghSUfo534bgvZPOM5fiPzsBcsRL83VPaYt
 HcS6/6LjOq05itOMjmvO2tFw1P1doS2+BcLAipMEW5RSsGl+YYCJtrrH4ZSECvH0LT/pvf2mByN
 FTEBDJ+/RWsus4VsnjpmRbYyPkQd1wZS5wGnFlNLNRYA3CHAdUJLRypJLA7xwtOU6rk0+Cxw/uM
 oxaLc7TIUHvioWdTQ5PJXHkjKCLBXPhXJKSFN6FP0Qn2Mpr7O93rLFP5H3znqpPrrF0/CeR0OF8
 ZFgCyoHSElG3qCLTDQg==
X-Authority-Analysis: v=2.4 cv=HJzz0Itv c=1 sm=1 tr=0 ts=6a6aa34d cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=1dbm4JsyFlBaYKuhsR8A:9 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-ORIG-GUID: OKNlxqhT4uWcdjqxGtA8sJct1rEtiFVe
X-Proofpoint-GUID: OKNlxqhT4uWcdjqxGtA8sJct1rEtiFVe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_09,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300004

On WCN6750, if QMI messages never arrive (for example when qrtr_smd
is not ready), WLAN initialization stops before the device is fully
registered. In this case ATH11K_FLAG_QMI_FAIL is not set because no
QMI event handler is executed.

When the driver is removed, ath11k_ahb_remove() still calls
ath11k_core_deinit(), which eventually triggers
ath11k_ce_cleanup_pipes() on uninitialized CE pipes and results in a
NULL pointer dereference in ath11k_hal_srng_access_begin():

  ath11k_hal_srng_access_begin+0x14/0x68 [ath11k]
  ath11k_ce_cleanup_pipes+0x184/0x190 [ath11k]
  ath11k_pcic_stop+0x24/0x38 [ath11k]
  ath11k_core_deinit+0xfc/0x1c0 [ath11k]
  ath11k_ahb_remove+0x38/0xa0 [ath11k_ahb]

Fix this by invoking ath11k_ahb_remove_prepare() before the state
check and skipping ath11k_core_deinit() when either QMI initialization
failed or the device was never registered. If ATH11K_FLAG_REGISTERED
is not set, core initialization did not complete and CE pipes may
remain uninitialized, making ath11k_core_deinit() unsafe.

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.2.0.c2-00204-QCAMSLSWPLZ-1

Fixes: 00402f49d26f ("ath11k: Add support for WCN6750 device")
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index fb5640882b98..7f5f5c8d7c56 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1265,14 +1265,16 @@ static void ath11k_ahb_remove(struct platform_device *pdev)
 {
 	struct ath11k_base *ab = platform_get_drvdata(pdev);
 
-	if (test_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags)) {
+	ath11k_ahb_remove_prepare(ab);
+
+	if (test_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags) ||
+	    !test_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags)) {
 		ath11k_ahb_power_down(ab, false);
 		ath11k_debugfs_soc_destroy(ab);
 		ath11k_qmi_deinit_service(ab);
 		goto qmi_fail;
 	}
 
-	ath11k_ahb_remove_prepare(ab);
 	ath11k_core_deinit(ab);
 
 qmi_fail:
-- 
2.34.1

