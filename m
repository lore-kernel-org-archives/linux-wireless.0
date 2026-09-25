Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6087A380FC6
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790351887; cv=none; b=bNuFERkJ2KqdfG9C2N1H093udN+vL3CzoikGYxylwUt+BJcf4Srg2XQMUeFL8AX1aXjwluW1sqWQ/CgQyndygioofAC4yWUbYmrr39fhjG5Gl8KaKVywCENxJs6z51oiz+zghAgFk1jzIHrKt5rulZ3A/YdTjCVbp4KmQLkcJVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790351887; c=relaxed/simple;
	bh=6/aq0wXwPIukqmyIpiHgBaMAEwS3rqhWHEw9Ijrs0kA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y+fKS+/BahapG1AmwGCCLHgRtgnDXtGXXscQzEop+2p7j4yS1ACFVMrEbWOyScctuHd1a3YpDq26q3kJe2IzkxPLmr/gtxcUveMMnWh6WQs1sP9Es/prfh6F9OOAs2p0qVZlTVCk6JSbCL0eCH0UPr4qqM2qINdBlBDEKm/JacA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=o8AcaWl3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AfUUM5oa; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="o8AcaWl3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AfUUM5oa"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68PBLc4T900255
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:57:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=EBl2dFsWiMsFSqUAN5NQylf+8ZNg8zQAaPd
	vj+WmO8o=; b=o8AcaWl3pzLm7MttTikh/ZzAMiyEqPkxid/F2lrgp/UB/VlvgSU
	LfEQW+w+JPZ6ufnUF6kbgpilPCbo8SGf6zf/4VN4jV6HYSTdHbDjzIt5tcOkou/n
	5z0aqkPkcHX2XuGrHSxzm2/dUpDduAet6l7J1aIYdU7kzbKuKYT2sMa9aAsKsqWa
	/9ZqppQitZ4ALWqInj/J9j3lIRpr1HP/vl4rUzOWwyf1AYkB8mhd4qxOqHakYv3N
	Ilon22rLMfQM8JUO1SzsSEvaicmV8JOLgGmeIcE/gC+tNJcwZsAbH/lLXJBlI6ST
	ZOsRheDYR7yKt7UFMw4ty3uhPa7ukGPUjAA==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gwr100x4r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:57:55 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8696b921ac0so906543b3a.3
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 08:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790351875; x=1790956675; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EBl2dFsWiMsFSqUAN5NQylf+8ZNg8zQAaPdvj+WmO8o=;
        b=AfUUM5oaFNZEkxJ2iLCsP32iY90zDDQw9OYdPABe9lhtfHzEOA3Ro9SjuWT/srLUGb
         xWi1sLyIE3NCNfp9bxXOQh9jASAHM4zvk8ysDkWAxe7bePXthAcKYIgrowK/wAI8M6eu
         o+EsIXvNnkXQ4A5oZ3PnlZlvMKKUMkebQ0kSr8Fa+/84EYfKuaPMlqPoM6xyucYm0Tk7
         /res64zv9GF6b+mKpl4GsBr8nWoZIpfGinsTIzO/Qio2SAUAwsFKnr/qvzgYNeXEBy33
         FN3hXccLzVtttwd9D+Ifu6spD3jq6NmAuTBSQEVbToOcy4GLMFpUC7bqFXx1sqjuyO9N
         iGtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790351875; x=1790956675;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EBl2dFsWiMsFSqUAN5NQylf+8ZNg8zQAaPdvj+WmO8o=;
        b=gqcRsMymAPWp7gVkyIu4BiFxJejRQuUQO5a3eCvTwcwwMhLtLDXWT+gJkcdoTMY/Mo
         d6GIJBYVNApjNu1sUk9MMrnVrxT4WE4qzmmRrCXKnrSG6UKWgSTeRWWIJA+hkS4maLcd
         u88U20FZqW3HhivqwEYL42DmzHByO5Nfz7rheaLfX7Gp/BmI2Kk6E/8L0vRsL0wny/jD
         ATQRVj44BUyD2QUQrLaKTZWGcLaq1V1Eg9/HSycu7R309WCbzE3Tu8s8btef9kV1pP5h
         lYgk67YxcASudqtLTLahrIp/okyWz+im8x44tQ1bOFORAVR7WXG+i3ffUhCUUx2F1m4O
         iWWA==
X-Forwarded-Encrypted: i=1; AKwUvBxM4/1az/E8MqBe5ETd9fAWeLmr2dxfbg3gFlWKBPLIqGpgtXAc6xO4yTKhzRIL1TW6mMBYwRxn9EZ7Opmw3A==@vger.kernel.org
X-Gm-Message-State: AFuF++lZwLhdZLiZF3pzShUu4jnqsl37HlaPhydRbN03D/w5Uv+udT2F
	qcJex9osfSWCBYHzlvh4lXvrZoLIkXUIGeJtUtlOen+I7wUzR6IQVUuuz7iBUIZ61ZDbA5D7Sr0
	CrS2XR3Szhwi5PpuOnGjcgm+Dfk6lEf36r5HDb+wCtbmLlbq/b7pTGbYQmbTRou8aIvPp2g==
X-Gm-Gg: AYBFou1RD1xFyT+AuNxNFfegYr86uTIQGas+INWr9lBra5F2Bd5WKIQW2/L2BqYFMBN
	DdYMPQ3HSupTxmdBTxOv4jA8Q3Axp51CqcUlzu0C8tKuu6rXb2/ObSs8DEE9spVKM9b8Gcg+gF3
	vo/luZYp06/i6VEGzV+OoxBcAfn285XPsL+1c45jq3ZGBS5rUrxqK0r2SY5JPF9neacGLjgK4Ta
	ksswFiUBs2O/L7ymSaSYINsjJhzqRxI37N07DTCXlz8lshNBdXWQZu/j8B2HJt62Y9c6GPQwTet
	dRgBDdbDQGvmtHla8wtKs9N6AXR7TLiKmYLlcSlQFH2iazELJm58Clqi+VmQSPK8D9JPyDr9N4v
	vZ26NnPgb1afwiPHE7loCqZBRwxo=
X-Received: by 2002:a05:6a00:2d96:b0:880:d0d9:fece with SMTP id d2e1a72fcca58-880d0da1e8fmr852030b3a.36.1790351874734;
        Fri, 25 Sep 2026 08:57:54 -0700 (PDT)
X-Received: by 2002:a05:6a00:2d96:b0:880:d0d9:fece with SMTP id d2e1a72fcca58-880d0da1e8fmr852010b3a.36.1790351874126;
        Fri, 25 Sep 2026 08:57:54 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87ff354d854sm1361299b3a.2.2026.09.25.08.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 08:57:53 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
To: Sumit Garg <sumit.garg@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Rob Clark <robin.clark@oss.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>, David Airlie <airlied@gmail.com>,
        Simona Vetter <simona@ffwll.ch>,
        Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
        Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
        "Bryan O'Donoghue" <bod@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alex Elder <elder@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jeff Johnson <jjohnson@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Abel Vesa <abelvesa@kernel.org>, Sean Paul <sean@poorly.run>,
        Akhil P Oommen <akhilpo@oss.qualcomm.com>,
        Abhinav Kumar <abhinav.kumar@linux.dev>,
        Jessica Zhang <jesszhan0024@gmail.com>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-remoteproc@vger.kernel.org,
        Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Subject: [PATCH 0/8] Migrate PAS clients to qcom_mdt_pas_load() and qcom_pas_prepare_and_auth_reset()
Date: Fri, 25 Sep 2026 21:27:29 +0530
Message-ID: <20260925155737.4161358-1-mukesh.ojha@oss.qualcomm.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA2MyBTYWx0ZWRfX7skUjx8KEx9e
 ZRKnK4hb4Ug7y09pmcU2eb19UVl8LBfaLeF604UQDcQScsYPbJ2DeG4Bp2JsqvC3KgDCPKRa9IT
 p+dC5Pssq0tUgeeyVWf3EZpVNz0GFF7+YHYpEk3vc8gUntXJFaqhX+FWZLT8otJZZ+LzsQTPEXR
 jTrPe0y+6KFI7aT0JJnXN5lqG9Jo7DtRTJuqoB0h2EYhvKgwS17a46JgUdDTxJ7HqyAR8VUXnRO
 RbTVDrqZMydI482eGhiK+ii8kpgkowi5+QE1YzCs01TjVDlHnvcwmopi/JnUehIVbaAwZia+J1b
 uyA9FM6PJ7972CJnj/laiRzKuillmw1U97uKSVKtfwzvU3uVPPlnTi6u8nsW/LCWmOFP1u4y29x
 llpbRUxwzFcvaprnSsau3Qeu1Pwgbt8mhj+MOGEAd+m9ujyvryte48u0jRawVNt+3bFZj4rBJHm
 Fekj9/d7PzCWhLX/FjA==
X-Authority-Analysis: v=2.4 cv=ZfKIpcVA c=1 sm=1 tr=0 ts=6ab69a03 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=zG7KPAmT95cOeVn0dqYA:9
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-ORIG-GUID: GajxAzuG8zy_BYCeNp_GAbdSqMaJkRpj
X-Proofpoint-GUID: GajxAzuG8zy_BYCeNp_GAbdSqMaJkRpj
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA2MyBTYWx0ZWRfXxfS2OHcF6Nqk
 MxWhHlvEdS2js7rtCHyUBDBbvRmcp+4VTr6ldZ/7I5kifss+EGwcqBy3MV1/xkCJSTSjTKNy8pP
 H4McbA65OHAkv22nTO58837gSyuenD4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 impostorscore=0 clxscore=1011 malwarescore=0
 priorityscore=1501 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250063

In preparation to remove qcom_mdt_load() and qcom_pas_auth_and_reset()
public function, migrate every user to the new PAS context-aware API
qcom_mdt_pas_load() and qcom_pas_prepare_and_auth_reset().

This series migrates every remaining caller of the deprecated APIs
(qcom_wcnss, adreno zap shader, iris, venus, IPA, ath12k) and then
removes qcom_mdt_load() and qcom_pas_auth_and_reset() entirely.

This series is based on top of although no dependency as such.
  firmware: qcom: pas: Make MDT buffer retention explicit


Mukesh Ojha (8):
  remoteproc: qcom_wcnss: migrate to qcom_mdt_pas_load() and
    qcom_pas_prepare_and_auth_reset()
  drm/msm/adreno: migrate zap shader loading to qcom_mdt_pas_load() and
    qcom_pas_prepare_and_auth_reset()
  media: iris: migrate firmware loading to qcom_mdt_pas_load() and
    qcom_pas_prepare_and_auth_reset()
  media: venus: migrate firmware loading to qcom_mdt_pas_load() and
    qcom_pas_prepare_and_auth_reset()
  net: ipa: migrate firmware loading to qcom_mdt_pas_load() and
    qcom_pas_prepare_and_auth_reset()
  wifi: ath12k: migrate firmware loading to qcom_mdt_pas_load() and
    qcom_pas_prepare_and_auth_reset()
  soc: qcom: mdt_loader: remove qcom_mdt_load()
  firmware: qcom: pas: remove qcom_pas_auth_and_reset()

 drivers/firmware/qcom/qcom_pas.c              | 16 -----
 drivers/firmware/qcom/qcom_pas.h              |  3 -
 drivers/firmware/qcom/qcom_pas_tee.c          |  6 --
 drivers/firmware/qcom/qcom_scm.c              |  7 +--
 drivers/gpu/drm/msm/adreno/adreno_gpu.c       | 21 +++----
 drivers/media/platform/qcom/iris/iris_core.h  |  2 +
 .../media/platform/qcom/iris/iris_firmware.c  | 20 +++----
 drivers/media/platform/qcom/venus/core.h      |  2 +
 drivers/media/platform/qcom/venus/firmware.c  | 29 ++++-----
 drivers/net/ipa/ipa_main.c                    | 24 ++++----
 drivers/net/wireless/ath/ath12k/ahb.c         | 31 +++++++---
 drivers/remoteproc/qcom_wcnss.c               | 12 ++--
 drivers/soc/qcom/mdt_loader.c                 | 59 ++++++-------------
 include/linux/firmware/qcom/qcom_pas.h        |  1 -
 include/linux/soc/qcom/mdt_loader.h           | 12 ----
 15 files changed, 96 insertions(+), 149 deletions(-)

-- 
2.55.0

