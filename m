Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28517435539
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 15:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784908579; cv=none; b=qY0W01kei0k7YpNsaUL8K+eGAVONrmNiH1UMHO9098VXyKP4qYUu8fVLucY0BlNOFN1jC+JSf73aE/QaC2kaz/G9wRvt3UgpVLhdkj4j1ShFV5azuYrIFjW+sEK02UVFZUjNVPSTCt3dqfEuRX8DfUVRPXMxb475+8YoDPO799o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784908579; c=relaxed/simple;
	bh=Q/4GgiOSKTN2diBwqCPhS0mbGb3SANDHLrOJ3sFSBws=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=iwdOaHApNXYkBebsFu2ZaADEtlEN+2jdXMjI4j10QD3MagvemiFNCE2Kvi432tFALTUAe6/GGN3hDwj5F0LD9C8fe7jQTfoXIspnZhXjdxWGbmLcgNGWY/K+2GWwF6DQ/UrX3anCqBroYNn/c/s/+0i5nN6Vqpy0M35+8vVV54w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=E+nh548w; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BWMiyBpA; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="E+nh548w";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BWMiyBpA"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66ODb8Ja3344390
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 15:56:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=Z2ZfzNUzZr0/QvK+IxoV2a
	jRXSGo7XNid0+pePDQW7g=; b=E+nh548w1aa9Yx6fOwBRX5CpC9nSStfE/ghM5V
	xjj+lnE0lzvozhgacQIP0PlxpcKxMCeVEw1ZAxYtscpcKWjTs6kd1EGm182DeQvV
	/osCHVW4fD4/jck7Er2mZEbeYGO7ZIATG/YCssnoypHmzSe+EIkzVzbshloNKnN7
	28h0fvjHQ7T7idNvtcN140AUU14ymWfngZ43NqpHqjGNsIOW/uawUi6uwc1C9aDp
	8rXiJSBUNqYA/gDa/MeHJiHQE7SdPJuLyxUg0XW8bLknDc+516VrZCc4GpGsML+j
	H0XwhhgmeW0zofx2dy/QgIf7+I97w1WqvRVyeVnT1B2rRAUQ==
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fm8cf0qc0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 15:56:17 +0000 (GMT)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7eb6a8c61deso328187a34.3
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 08:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784908576; x=1785513376; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Z2ZfzNUzZr0/QvK+IxoV2ajRXSGo7XNid0+pePDQW7g=;
        b=BWMiyBpAmRxG1SGGPNi8Lp59bYz/pgZw1B5Tcawidst6zydEDtrMYhYErfqsDOcHW8
         jazLWtj53wvIcG7lk+yLeLzPML6p8DlvgpTbjU8+ND+c82r7kW5uVw2c2rZvIDCG9i5L
         xcP3nDeySYIu0Za2YgFLx8/3y/5S59KXGHomDp2W5FOGuhr/889wYIVuocolGQmfUGFu
         Bf1xZ1xz0kIguFXH18xWNLPKOnRN3YM4gk/8ucRLvlAOA7SA12BaFv/MaGqlr2+LBQek
         HhC6dx7ync3WdTHTsY6864GYncQlyqZ8t9vcAx6wwcQr/NzoZ9nMjDAs1R2jNxPX7QOx
         3g2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784908576; x=1785513376;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Z2ZfzNUzZr0/QvK+IxoV2ajRXSGo7XNid0+pePDQW7g=;
        b=J7Br+VVwzKgnn3PkUWsjcnS6APUNki/uvKrgnEPZcy1AEw1SOBLZp78D+ayinj5bCH
         Gs6XwnaAREqLRkkHGjhX3dzxkSScmiNmC6cxB/T7tQhBIJCx2GEEwVUUERKb+rhKXzmP
         bU0955IGFrFw3NE6R+jDQamGCPsbrxuXxkt3MRRFzkVv6fQ65d+IVPIBQlXc5ODX+ne+
         qmdLV824X1u2zc+fo7+RK5oWmXlOLteD69wMo1qF3w/l58+teRBMz0L3vVu8SmIKdyIl
         XFiIVjXOTNs4M4tl7Gyv1TBPG5h1ZZXvD5JSM1WI897899wFkz69peQImbZiwWgDsVBq
         JIoQ==
X-Gm-Message-State: AOJu0Yx/sR8L62PHG3RLTU28fs4bYotJULsid1RDIVLnf0OqE6pz+KWr
	wd0gdSubCFB+Hm+WTK09WHKry86Tvb51OR0Vt/it4DSm2h+PIbjv7rQp8FLwiPqva6kF/6FU+Ok
	a2zVGnelAPb8KVGng+YUXyu4P8/xc2iD0sPuih/GjcKSkbYAmRH4YODQBGTJ/VMdaKBckUQ==
X-Gm-Gg: AR+sD12n9e6eKiPyx17vud/830bpPOcPp0bNSn8Sgdrhm0uD8JaqSQaRmX8dHig24O1
	P2HKZw1UEMAMHrmmZlCXOGGX6NJDqAwQ8i5QUWafNk9CKChS8J2fe6cFLxtR0N3KmsKKZw0WCIH
	Eade8RN5ah6OwJ81u0lzsXz5NJejHq0qMmQvH6xHBfuw7WfeBNoeAlQ8NsBNt6/Uip5UMentLUs
	Q7pnCVqnu/6nfpLs+8Ma1lpVJgi13IXA4OiX6olY1NFoVxaU93UVGZ/KNmWxDg5ODxObLed6XUY
	66n3QFP8bihvJ0PJzi0FR6R60PZwG80w3XOMxG582xMLWXhASXVKgHiMhaTNJrP6Wlc7g1zkM5X
	LI5RTJiMjTW0q709jlcGe9ysf9OEeGx9uOwG9ngiyr/4hYkv/ryjJXg8=
X-Received: by 2002:a05:6820:1f10:b0:6a3:8738:4106 with SMTP id 006d021491bc7-6aad3fc8f81mr4302783eaf.26.1784908576499;
        Fri, 24 Jul 2026 08:56:16 -0700 (PDT)
X-Received: by 2002:a05:6820:1f10:b0:6a3:8738:4106 with SMTP id 006d021491bc7-6aad3fc8f81mr4302750eaf.26.1784908576002;
        Fri, 24 Jul 2026 08:56:16 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6aaf9385b35sm134591eaf.7.2026.07.24.08.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 08:56:15 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH ath-next v2 0/2] wifi: ath: Fix buffer overreads in CSA
 switch count event processing
Date: Fri, 24 Jul 2026 08:56:12 -0700
Message-Id: <20260724-ath12k_wmi_process_csa_switch_count_event-cleanup-v2-0-02a45d7246c0@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAByLY2oC/6WPwW7DIBBEfyXiXCLALbg59T+iCOFlXaPG4LLYS
 RX530vcY3tqLiONRpo3c2OEOSCxw+7GMi6BQorVqKcdg8HFd+TBV8+UUFoYqbkrg1Qf9jIGO+U
 ESGSBnKVLKDBYSHMsFheMhcMZXZwnbvpOvsrOeOMbVnunjH24bswjq3U84rWwU02GQCXlr23MI
 rf8Ae4iueBeixaEca027i0R7T9nd4Y0jvsq9zU/ANX8FwBCYi9FB9o1vwH3V4t6+ImqoO7Z+bb
 HF1TY/gFa1/UbMHwiKM0BAAA=
X-Change-ID: 20260716-ath12k_wmi_process_csa_switch_count_event-cleanup-7fb191b7d7d3
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDE0MiBTYWx0ZWRfX8i9WRE//2C+x
 I456aLdqXNvQmveUF0PvdDqOnln82WWiAGsceMHRaQJL0LWiNrY77jU/avX1iL+wMl8fzOnDg/R
 fhGqbutGQRvcs7bCrDtYZe69rV9WNCg=
X-Proofpoint-GUID: cs1tNc-XsKzMK2E8A1u20w85Ll5UFNh8
X-Proofpoint-ORIG-GUID: cs1tNc-XsKzMK2E8A1u20w85Ll5UFNh8
X-Authority-Analysis: v=2.4 cv=er/vCIpX c=1 sm=1 tr=0 ts=6a638b21 cx=c_pps
 a=+3WqYijBVYhDct2f5Fivkw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=bC-a23v3AAAA:8 a=EUspDBNiAAAA:8 a=jy0UIgyy91Gj8lWLAW8A:9 a=QEXdDO2ut3YA:10
 a=eYe2g0i6gJ5uXG_o6N4q:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDE0MiBTYWx0ZWRfXyqW4T5YpC24D
 Y/WnYCj+hZl2ctr0gYNyGifVklERRz1Xxko0sT6XZC1bztCSSRCfOixzmifp8BNaNqBrNryvlYx
 PkEFB5cBiXEWS+JJ4UtdX6ehGgWxbwhcJPU2wPD+zRaxKSPvyl7H6On36eTf7G1Il6hhNKRL6TH
 DGoTlzjr7/7jY7+91HpMaNxsCoL1KN5S8+T8r+Cyfv7/brC96ww+PsMPOr93iwKB5E+o0/nGfbQ
 j276cAPNtrbkH1muO2f/pWT7hbgtsxF9mUfcq32e7V7VHNdnICeIsxS/LnA1Pkn/AB10afNWjon
 KFn74TUgmerz7490nOHLcEwr15Pdj0b/GMs8jXN+RIsNCUwL1JOmDit7+kuQEDamo4d22IEf9Cl
 QBhjof/KfiYLVC29I2D3gB339GNom3M2o5ZAWwfLcsb/+mFeZqlf/lXJKMXILua8dtLBpt04NTd
 rmXghBwKpmjUhFs0zLQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 impostorscore=0 spamscore=0 clxscore=1015
 bulkscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607240142

Both ath11k and ath12k fail to properly sanitize the CSA switch count
event.

---
Changes in v2:
- Add Fixes: tags to both patches
- Carry forward the Reviewed-by: tags
- Link to v1: https://patch.msgid.link/20260723-ath12k_wmi_process_csa_switch_count_event-cleanup-v1-0-c01ef10bc6a3@oss.qualcomm.com

---
Jeff Johnson (2):
      wifi: ath12k: fix overreads in ath12k_wmi_process_csa_switch_count_event()
      wifi: ath11k: fix overreads in ath11k_wmi_process_csa_switch_count_event()

 drivers/net/wireless/ath/ath11k/wmi.c | 21 +++++++++++++++++++--
 drivers/net/wireless/ath/ath12k/wmi.c | 16 ++++++++++++++++
 2 files changed, 35 insertions(+), 2 deletions(-)
---
base-commit: 0ceb105245b5e57f803bdc0e79dc077fc06ff384
change-id: 20260716-ath12k_wmi_process_csa_switch_count_event-cleanup-7fb191b7d7d3

