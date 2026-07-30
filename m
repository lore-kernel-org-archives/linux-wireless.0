Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A291383983
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 03:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785381036; cv=none; b=ptGb1p+6h7kyb+CVbpvVfqQrINum6fVYVic4BW71n8EPTXfSZvsU/zqPARVti0qVZEnSHVV2iJg7PidEpTsSM+nCsZhCsmqmVff2gddsLlSWvREBANNKAE+tWXuhMuQ9kgd8BqpF5OcJbIApKGVO1tDqa/hL6/nz3MfB2evn7AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785381036; c=relaxed/simple;
	bh=aEGf7PIuBZ+MHW/eqEqoQXnJ2uzCpXMwo/25tnWSSRM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sPHJohLfUoBIXn0sVHBGqydAF8lYF6tuMoahqvB30FUzB6gu2p9RkOQANXElj+eFLVzYoL7cLLqqVY7wzjWMUutXCt+A6VIprrXyR2SFHLMr4ENgV6wbLy0zLzvqBkPJd3uolqXMse4xSn/mA96w7hSatzA6bmTWk/xYgYdwFY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QpFLYYSS; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=V48qyDDQ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QpFLYYSS";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="V48qyDDQ"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U2CHRb3644030
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 03:10:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=ZYFFatroACJ
	PZgrWGjCltvltJd9wtFIF3w6l6ozfvvM=; b=QpFLYYSSZNMpQiFouLUf7ZcAk/B
	FyZdTeRvEEFToQoOiczCsE1wVuo3B1fTaEIOWoI6QWm3M1D22kjYnLz/r8NJ2eqF
	dAUkUw19e1sb3iGgmleSFq82xp0xUXuuQdeJC/JSZY5CfzyipwSyUkwmQz52OZRE
	H6as6scN0vk9NR1QSzeMesrFIKP9hQDiJrwvjMM6gT1QHC/UvaZhPAehqQXjCg23
	vBkMPzlhsduUdJFe0O4si6bPzkA5UKT4MbsqXtYxsBlDU7tQpSb11qzYGcXivWC5
	Kpvu2v2y9zFgDIOpOxG7knr5nycAQKhd4B78f+XmuIfvGL3GohHQivaKvdg==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqwmfr6cr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 03:10:33 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cc5faecf01so34428885ad.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 20:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785381032; x=1785985832; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZYFFatroACJPZgrWGjCltvltJd9wtFIF3w6l6ozfvvM=;
        b=V48qyDDQQMKL+QiTNL8RcdVQd2KTnQVvhNuc/Ju5HhVlueOg3aMc9FRg/ZcatYt24R
         iHPb9LJeK1Ed+m6z/oSIFaJjn+AUw70Cj9xBBZJLcxIYJ9IQEm1BSBDLdMg+OXwkMAHX
         qvxHhfdaKr+nhrDx8IUO2wInzn5wTa11b372zTfLj5cabWTIJq9eCzpONCLi4KEkJ7mF
         Pm76+SzjvPZJn8fRslrIqx/9sXVdRVDx+74oZ7leapnLzP27ANGyNwe9Gm0dYmGKDqaf
         rIrLGZiK1xVw6u26ygePPtTUPW0Ec/dNwo4QgWbAzjfPAYWfvTFThwtsvF6ai3qBzXNy
         hy2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785381032; x=1785985832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZYFFatroACJPZgrWGjCltvltJd9wtFIF3w6l6ozfvvM=;
        b=R2Aqdoa45E6Bh6bxn2KKFMxsxTX0ZARbiAwUDXJ+Uy2FkejaQVfj83vgRicvq/zQRE
         5zLvtET/IxoUb8/8BskasGYIOebwgqv0w1/L6GJLLbdmN4n0eFw/66BAxcMryfs5yJNX
         NB4wGNa7IvqbWUagXNiwmuUTJislcdfGF/QI8SDJyMMx2/NTeFAbExjYK570fZOMRvth
         5FGXqBcyfYyk1rvsYsY7Q0PDEAWLG/xqMT3aFHQ8yhuyc7ydApo7PZt9/3VWTjr+RhFa
         +fgD06mfxP82RClEIJNpa4anGQhPWN8TrWEw53Y2Lz2DSkOn6KQYccLE340KJYhdPnvP
         iIEg==
X-Forwarded-Encrypted: i=1; AHgh+Ro0E1t8Lyn8rYusYDRoWRIqXN5BQdofIPt47SPUnJk3DzKqKeA5PIvsC6/tNhSGR6hP0L/oDoma/s/gfd6kxQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwkgS2fBWBYmpkzpkJRCF1u4LkGQz1vRXHdXJ/l9sKpWM+xnVKi
	Zb4AWw8WMU6ElohHd9Dqspo1hLpB6xj1gTDuhnDYL5OY+1tmW4Cd1o+JK4eo4l1j75p3LlArXWR
	HcwvMBmU9wRsNg584UH9ReE4mot17i698yBIWXFz+7q5sPP2Tnc5rbUJQHp3oAmjenf93NQ==
X-Gm-Gg: AR+sD12dbZkfMqoeNjVxBtwiKKOAximMpopv0x+AEokDjocMtxmOet6urXl/H0qi9py
	OPdzGHdF+fX8++d9jbXnKEBCBYpIxduFhhBujvFJZ66V7JW7VMmb2pHUvvReqQHSvsuDXoIbmRD
	+L3g1aQz6Ra9tGndlPmqXHj4lt++ZAXSKoyhgMMvDby5I1WKZ69c7hD4xQ4qGp3hkTtfzJq7cUV
	g43/nfJTS7qtM50UuakxV8vjd+sitxbPbpEYLziVv9HkuD+CTL5RwnR+L+J2zHG+Wk8JGrUP19X
	/e4Ahrpjz5JMJ2wMdli6MXMtxHqbnv8+uh8XRtLq4pXhoq6caU0ghzf9CgvXCaOh6lqAHMG1PbM
	X5ZUkGbjTK0ggcFapObBZ8E21ImjsjebJVTw0JQ1CYK1u3TmG+lTD+8ww7Ug=
X-Received: by 2002:a17:902:c404:b0:2bd:8395:fedd with SMTP id d9443c01a7336-2d035cd9f0emr8998225ad.37.1785381032152;
        Wed, 29 Jul 2026 20:10:32 -0700 (PDT)
X-Received: by 2002:a17:902:c404:b0:2bd:8395:fedd with SMTP id d9443c01a7336-2d035cd9f0emr8998015ad.37.1785381031701;
        Wed, 29 Jul 2026 20:10:31 -0700 (PDT)
Received: from Z2-SFF-G9-MQ.ap.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022c2e5b2sm18928035ad.74.2026.07.29.20.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 20:10:31 -0700 (PDT)
From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Subject: [RESEND PATCH ath-current 2/3] wifi: ath11k: fix NULL dereference in ahb remove when QMI init incomplete
Date: Thu, 30 Jul 2026 11:09:47 +0800
Message-Id: <20260730030948.147892-3-miaoqing.pan@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260730030948.147892-1-miaoqing.pan@oss.qualcomm.com>
References: <20260730030948.147892-1-miaoqing.pan@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: oqtTnlLFX4l-glWpgGtXJV_dVGf6fkA1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDAxOCBTYWx0ZWRfXzeHoXB0K4LHA
 rH+5pqGhp6jAx8jrAduhIFMIpJw+3C+7El4jmc6yPSIjHpCSVG25xSOAumoADA4w187miY49ysU
 WpoOcJ5E6pytlIVvLoA4SGnT7xmxcb/PAeUeu16UraGQoych+P8UIQVrdjQQ3nb6RQjjzdFPcOB
 vABDR96gA8Qb6sbC9En1HHsT4RwRYgLpoXKQp3m0xOjsyDGMRjpg2+D9oIMPFjvK1P1MYWUPZ+z
 vZqrJJg5gwtVxbkWpCXQNO7Hh6xuZVT+eV/DVbhKRdMmtc9YetneHHlE/63TcH9ADPnt2taot/F
 OMInwpnD//Wg9hj+iwyXqkk48cYxbxuAnf+O/1Vdutf9ADkkQLxdmhw6kMuScLG4N/Sde99lxpg
 kC1F29VFwTPh8tb7vAaCSuO/rvA/IrRhlGljt4sDXYEdsdRZMGfHWyGNp+Y18co7vnJH4BrKQg0
 BjrZJpneKTqobZFkRJg==
X-Proofpoint-GUID: oqtTnlLFX4l-glWpgGtXJV_dVGf6fkA1
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDAxOCBTYWx0ZWRfXxSWn7DsCtwa9
 p+JQ/5gHMyNIp3VzG9LTwga4yfHCCQ9qyF0C82QnyaUTZLXhaF/90xbsy2DAxhFQIpoqcmEYBZ4
 8WFXDyC+DIutiE6kcTmV+4amVdAIL7U=
X-Authority-Analysis: v=2.4 cv=F5BnsKhN c=1 sm=1 tr=0 ts=6a6ac0a9 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=1dbm4JsyFlBaYKuhsR8A:9 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_09,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300018

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

