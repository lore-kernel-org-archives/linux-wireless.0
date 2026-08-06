Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3A638F945
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 10:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786011224; cv=none; b=uAb/3vRahCiH341+4+EGgcKbhG7zuzpmnWOo0Aixfl/lkTMn2tYIpaKhif7Gs+I6f9qmb7rANWxuFSR03e2eVIFN3wV54bkH8pXPn9lajbyUTbdvZeHqCBzA4J/LwtRPY0lW/P8CEnb2NMtQQAtTXlW6gjKcnSo9RdRwU190ELY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786011224; c=relaxed/simple;
	bh=YatH49AKhGG5zVMfQd7MifhyCvwFQpkORRP3Io+GSTM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DJ5ToGq39uyLkCRbRnMn48mfUBtyE/KX3fuDQGNrR7qVWtofnBFawklwPbys0O/m1krW5vFA6i+NzTfqISmE7xyfuZxSIHfxoTJ89JzdOJdPnjfh3pZ9auy771QyqHcwhxs2KQNM2QmCl2OyIxXLKRQPX+DebTIhBU3DhkykEKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cJ/5JT27; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IgJvl/WS; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cJ/5JT27";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IgJvl/WS"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769nc0H1227552
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 10:13:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Xz+Xi3sIoSg
	ATAmnnTJCucX6u98YnUmIS2O6aEmGou4=; b=cJ/5JT27fAacIEjgkT+I4O0PWDf
	5d73bWYAerUeOm0vPWsOgug5yr8gwEp3HAg+zNax2nL3t9n+KuBxQx68+G0ykWQc
	Ugt2MoW577nkg7+HGA2kvRVTcdkHJoO3+o2uYnMlAD7dXGT22CKLnIf1eW4z/zOo
	wLG0ULkMnMPHr+H0iDyDCDGo1ntGTJAGhMKL/vZ8kOtpJatfvJKQMzdJ4AoWU3+i
	RR0UuIoOLyozJseR6V+8Ygc7xwaTnZhTNhEjPUvpAHU0IBX8tyndjADAjwZvKro7
	RCwTLFzCbx5F4mt2fPwp6YfclqwoAK6koQAl5AJ59WaD4FVRAee1Cy0Vo6w==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvqdug88m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 10:13:42 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-381250979d5so2245911a91.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 03:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786011221; x=1786616021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xz+Xi3sIoSgATAmnnTJCucX6u98YnUmIS2O6aEmGou4=;
        b=IgJvl/WSEg5sF+ih9M667ctqG/yvi0APMOU/2Q2RvnmPwHoOOVEtOGDbCi3kl5F8rd
         Dkm/3Qk6i6AOU11dz4W4jMj5pWdvDiMmt+ljym4zIR4fSKIA+iLWS0F8icVIwOBSR5kG
         Hfm0KUQ4R013cfJqR09WOiWPVnoPtvrEri4CeVF66PIP2i6+G4ROB2BfdSp3LYTzTjR3
         M+u5LsIEmtnI4NBF0zcfERJrfs6DNJ62DNmiOiH/jVhltP7m0jhrT76MKfjUVDjKHh4J
         y+DYb05i6dq11e03Dz7X1mmAIbTdsTgtdQlriLBImDqHQArKOXIwSjZlYmoh66YOhSqI
         qENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786011221; x=1786616021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Xz+Xi3sIoSgATAmnnTJCucX6u98YnUmIS2O6aEmGou4=;
        b=qE6iXACPIuflf4ZbcviK5/I5GQPxS2pyEkEIxI/peRw7Naze9M+du7lJIGyTkZTObH
         qLc+L0NKXrB1zQ77tKkDsKOD9leYLbnIg9KIBc2DwBCXP8yvYAr59QDOaB7d/3w0eP77
         UaJ1DX/ZAhaVKGNZk19WEMYw5dMIBrkstfBX5jVMJJcqwExcyczYITpKJ/uAybNuVpWE
         pCEHXEZWFzjy6sJ/7ySKSVlcw9RgXgfUmM1CsI0DA+EE7X/ncboZOsQXK1s5nB13sOXJ
         TTYBDwAsQZRKYg2ZaI0juLNV56pGxi+IBTzEY+X/dejl297tHLtLZuOdnl1HQ7H3bVNM
         C+jg==
X-Forwarded-Encrypted: i=1; AHgh+Rq7NTUqc2w+alLTHCZXWfDhq9AI6mL0nzlHl1Z8N63SWWTfXhM73rnxgtoSFu3H9jnCgwkIPQUPpt5K+6f1oQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw619sfF0WWwnUINZid2eM1hs/WZg8BZKqv4pnQLfA5fo9jueqf
	HTJHWujP9refL9r35tikV5D1n57//ef0PDv9ZdMSKxPz73BQPOrwqpNeKc4nCiAx6MXXJmEHDxN
	eslBL8trNfUVUmKOTMeAHQqTC05DfkZc1qXd1bz02YdlMz/cCqqeTtXDYC/awoWaWOTzKsfLwSs
	8zMTgW
X-Gm-Gg: AR+sD12ugfcTV99bGoX0I2rzVBLYDOwXyZujWEglHNoouvrRZM7aPeR89YUyEwasTiF
	1ezCPyq0RIfl5ojd3QIuCaTLLyhHFUswkoH9Y8kIpDZtaL/YkOUFUdFHAbBcm/14iLxg1MGF57r
	XV6wvHlwpD4j7E3WuLPx/AdvnQpYkXE0SuZEmGHMnwwekDSldGPCSU4aWnUo2PVf2yp7gfstGrN
	on2g7TD0bA4SrCb0cDeFsQrzKWMylrAqfoLEd9trt4lQEFLH8zXrK6/VAL+ioO5XG5LwN0fXgrv
	3rDgLkmGZKLBGauBwEMfCnCS84OUqytgFscHgKcUwxxwh5uj7byoG3lUT3TYYS1tJuvl2W8VC7N
	kJGp39J2RUmgVWg4lacLbAMJ5RnUGIyLN02EGkWDwjTj9SW5Z4WBwbrmGNnk=
X-Received: by 2002:a17:90b:17c6:b0:38f:1a2e:6e56 with SMTP id 98e67ed59e1d1-3903c59330amr12938704a91.9.1786011221405;
        Thu, 06 Aug 2026 03:13:41 -0700 (PDT)
X-Received: by 2002:a17:90b:17c6:b0:38f:1a2e:6e56 with SMTP id 98e67ed59e1d1-3903c59330amr12938657a91.9.1786011220912;
        Thu, 06 Aug 2026 03:13:40 -0700 (PDT)
Received: from Z2-SFF-G9-MQ.ap.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39085dc396dsm1257090a91.3.2026.08.06.03.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 03:13:40 -0700 (PDT)
From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Subject: [PATCH ath-current v2 2/3] wifi: ath11k: fix NULL dereference in ahb remove when QMI init incomplete
Date: Thu,  6 Aug 2026 18:13:30 +0800
Message-Id: <20260806101331.484063-3-miaoqing.pan@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806101331.484063-1-miaoqing.pan@oss.qualcomm.com>
References: <20260806101331.484063-1-miaoqing.pan@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: JqapuQ8iVet9elxir3y8obqP3VZrqANL
X-Proofpoint-ORIG-GUID: JqapuQ8iVet9elxir3y8obqP3VZrqANL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA4MCBTYWx0ZWRfX1JnPcjutmmqi
 +TJHAZ/CJ8lZKQn7M29YXhdhnCR7hKfYR3pSwoscB/7e8NYr0HDS9MER5VPQnCW4Z0jscx8IGNT
 pncqD9wburbmaJrBGKbwHtj9eQ3VUOu0V2QuLeVvMW6wX6fxtvd1FnRgLO9/tXOkJhK2uQS/S4H
 UzC3a6zirBDJ/k4KgYoho5Y+IxWMB+fiaL5Fc80b7NPYftS+bDoYs+6kWa6HnGocl7cx9MPw4hf
 zR3vG+GE5DM1PfjoBmjaTsaT4KP6m5ITDDyNA8NPoPB54mzg4LEdcd1dMGDH35B1I/cXJnBCRJo
 d7O6cQjJm1i2/8RLnWtYv5eRXdF7L1aI/iG2+Z7Vt5mtoUGoMiVHSC48U7Xq+c9sJue+aih5P4H
 GcMyYPW9m2dYfvB3Sm3TLvrBVYlup11JRm9b4qRoVHBMcd0hEdE87lhjmoZe6jUpYAlP38JbbWF
 1KowvAekCOLzeuNqp1A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA4MCBTYWx0ZWRfXxU13hDf5BQWp
 Tuq/RebzeNyTOfzO0Btsrs4YaDxxtVyJjSO8l5vUwol0y14UQJKFX1S+37vLCO6+N+zXs6l+NxE
 qeBj1l06rEcbsRvGC1kLG4JkmFiIvw8=
X-Authority-Analysis: v=2.4 cv=bdtbluPB c=1 sm=1 tr=0 ts=6a745e56 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=yEnPkioJ1CB-1oi1TZ0A:9 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608060080

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
check and skipping ath11k_core_deinit() if ATH11K_FLAG_REGISTERED
is not set, core initialization did not complete and CE pipes may
remain uninitialized, making ath11k_core_deinit() unsafe.

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.2.0.c2-00204-QCAMSLSWPLZ-1

Fixes: 00402f49d26f ("ath11k: Add support for WCN6750 device")
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index e417b0a0f2d7..c3ce5ea36e3c 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1296,14 +1296,15 @@ static void ath11k_ahb_remove(struct platform_device *pdev)
 {
 	struct ath11k_base *ab = platform_get_drvdata(pdev);
 
-	if (test_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags)) {
+	ath11k_ahb_remove_prepare(ab);
+
+	if (!test_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags)) {
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

