Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72443546E6
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 03:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785381031; cv=none; b=Tv/BSHJFNIzvIYeJLTHuNn5Utx1OI04Td69W+rYVrDuIt2XGehtKEwO4lpv83rlkWOR6/noyCE4SOnhodbqGrt5Zhih47EPVCf0YEYXu36TQx5E6ubLdq2ViMPBv4nNxWlPMO2EmCUfihP05DAuMCCjTm9vJrqbILq7qUplnaHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785381031; c=relaxed/simple;
	bh=fC1t8irMzrqTCGOKBjonB7JdN/QOcvzgo3NQt+zkMGc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NHIsABlO6cG96MLUepjXZoqzmgdV2g+KnutoX1n38DHAIRJCgCAFm+wR1+8AnNQZq4rxjMclejeeZ+dKfgUko3FOdKhnMMtaGHOKcjtrmQXl22tzdA3O8YcOcW3kr5VtlKXnTS/OAnpJ/uyBVXsyjcirrk3RyHpL/aqn3fk0GbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=U15F9i/N; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cMEne8ao; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="U15F9i/N";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cMEne8ao"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U2jfuO3713291
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 03:10:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=9l214qgUdXGA8WVoj0GqLP3Zunwqu6mDgUR
	nXJ+2pGg=; b=U15F9i/N1SSt6loXq1vZFNYOtTcZJGwuX+7+u4XCVJxImQdXQ4u
	Kw5js5vgn+WGHw4X7og/BlWjW9K5RbQj3KUJ2IplbWdUDcsq8sDw4AJgbrC433gY
	oZEamkOs/4VI53Z8dCF0VE6nv1FwOQmPxwJoNwopfMzxvd10qhYM8ukqJUJUwWWp
	2Jv64wQNwrKuGcbc1WrErw6IfeZdUZ6myEBMlp5x+Z+Wzjc2cj8ikxbM0XDQZF33
	6tMnkpGpRkQ+pAnLZnWU3Hx01lD+nIDbmAbDdYk95L3pPD3wq3QSFugW7DT+G9H+
	d22SyBNfNJ01ntDLqO7aEyu65w25BkJc45A==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqx43g33v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 03:10:28 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cca5e0a0c9so30447425ad.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 20:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785381027; x=1785985827; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9l214qgUdXGA8WVoj0GqLP3Zunwqu6mDgURnXJ+2pGg=;
        b=cMEne8aoyRR7r4CqAaOfKT1YELXERwOrR1ZA3PdYe59YSX7YXGn1hDfRWF8/3hudTV
         nz9O8r6Hz+tvxdK6jsGoVX9dK8zj6wRlgn09yz7OVxG2IHdOYnJWOaxMcN2CH96+JmoW
         TBdVWF4leILw8SRB4kJ0+UMMNZrkV6Wao4vdUq5xSvRK1gi1ZmG3a1ORvvlXa/7DwTZk
         mJir33EWvyWZR8qmLPoFlc40rVLytlD4BIQ6Qk+eXFRp9q5JP0cMEMPCl/HEgBUxVy0c
         PzCgRGuHHR/axSd73Aqkh/YNQit6fXuCuQ/4nji0gHePYW0g7rh3j4PVj6S/1eP9kFhG
         ABqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785381027; x=1785985827;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9l214qgUdXGA8WVoj0GqLP3Zunwqu6mDgURnXJ+2pGg=;
        b=gyzUmpy85WoL3gHddFDtOXWKIb/aN+JkuRkC3saocVt8TBwvIca01l2IQ3E+0Leotn
         H64yOYuY16m7os4XDrtBo+rXsiz4SieDx6v0WnpXhzeq3R8bkjPnFXLAV96m3JdP8mib
         7nl63oBviSy71K008X2lnABdSmRbqqzj9mNhYr3L019HcjWc7rIcs7SRaJN/fPInFvKP
         U4IqXTSGzD2RjJBaagpXfywhSk92Ja9+Xv6V4VL5hdgLNARTF6RNlQv6+8uIxhLL9s+4
         jsb7xNH+PmmFLJSt7hBzsFObDUbpzpcmtj8uPJP8xAAIvFk8h8XYDbJHCwW7Ar0C4YDU
         y+cw==
X-Forwarded-Encrypted: i=1; AHgh+RqA2ES7xOx4+LUmPJSNZdJ7W/ehbQI7JlIWP9PCIg9bajNe1UDDeUPzFLCZYRLUZmF3i0t8Wj1l+3/VvylTqQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwUgK0dOb0oOgp0Nh/2vktJiZis4WxDe9qKQGUkxp0ATTLoDrlS
	fFYnVfewO9Tt3Ha4A2oqUgqXgnKlbzett3ZEaS93kTlc23i5YMXZrIB+gIKHUmc4eMzTT5+oTlQ
	NPFsADRrrO8pWq7+4GRKUbWIjl9pTuDcUR5DLnMHUpBUAOqq7AchKFMdDOGXN7beYvjuJnQ==
X-Gm-Gg: AR+sD11mtkl4egqBsfFGEcAJ0Ypj8LZGddtEyA8qs7te7zMpV/P4WTkVOMjA7GWBLfm
	bqcO4+nxw5T8s/lVdc9agjumHB0NmfXTROjOy2XNOb/1V/n6c4CtncP6BPpDMtkUlmp+EB5k2mb
	rlpGkPwNBVfTM2mZyNSgwFYHYRfGHsiDx2QS1AiieAftqUkuVFMWS5miEDNn0FODVEAQXODDmVN
	NMW0DKNNTePSn8RM8LCe1wVPcPzfJbaNXgoberDcLpVYqB1u2MUC+9b1jyvpPJHHX++QQBkiIFq
	D6QJsrJWIWuAj499XiB1ezM/+ELSNvykzstM5sP5Z7+yHkus8/h6lGEtpMlzg85tIFFcw4GmOqL
	SWdhwq42n7yh0+mqKEfBmJmpbQcw94/8rgPYAII+1q4Z9SZfGdY7g9Cv/4pA=
X-Received: by 2002:a17:902:ecd2:b0:2ca:ce91:f027 with SMTP id d9443c01a7336-2d035cd98c5mr9333365ad.36.1785381027524;
        Wed, 29 Jul 2026 20:10:27 -0700 (PDT)
X-Received: by 2002:a17:902:ecd2:b0:2ca:ce91:f027 with SMTP id d9443c01a7336-2d035cd98c5mr9333055ad.36.1785381027098;
        Wed, 29 Jul 2026 20:10:27 -0700 (PDT)
Received: from Z2-SFF-G9-MQ.ap.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022c2e5b2sm18928035ad.74.2026.07.29.20.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 20:10:26 -0700 (PDT)
From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Subject: [RESEND PATCH ath-current 0/3] wifi: ath11k: fix QRTR readiness related WLAN initialization failures
Date: Thu, 30 Jul 2026 11:09:45 +0800
Message-Id: <20260730030948.147892-1-miaoqing.pan@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: pG3PN4Jte_fArDPRM8NZGQXaDXR0VzXY
X-Authority-Analysis: v=2.4 cv=H+jrBeYi c=1 sm=1 tr=0 ts=6a6ac0a4 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=Hy-6OMvPWsRTGNkc5tYA:9
 a=zZCYzV9kfG8A:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDAxOCBTYWx0ZWRfXzAq7Sfm45hWv
 bHHOyu10gQtfH4CpopQcjoGWwQ6v7TtU3aeeM46hfrHJNx6CuUOIMFroXBhk5vydqR+5L/vmyqb
 wnuzdeihlm1ouyia2aGu5bb0tEGQIzuc6D6/8pkI4O/h7wIUL30q0CMuPgYjwaUeDjHC05zHFjE
 4td+NoikId8ERGYlFQCGvJ8mCXCH8UlcO0oFcRtn/6kRNwXuL3hEo6Wg8+/jWR8ZrwW1MfuwGZx
 9wZIDMcqoa9W+9DGC0bHdZv0xVNCA0Sds+0SKhbfE2MlmkGQZYceoSUFyQmZWKPabuG8UK7mvXh
 /GGELzNl/mNoZih/W4uCPTGlijPuZhZM9GbDd0lZtDptG7TbqlZICGPlwpeKJIP0G3wB9Vy8+Vj
 KLLmogKLB4JlKrsl++4ph5/Mcky0JB6cXy0/eaUUtyC+BykoIao7lxVd7RjFzcIfBVQwMntULfH
 Y/hy0pPV+LkrlprH93Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDAxOCBTYWx0ZWRfX9Tu3sg+S1EPL
 zVOZ+l6tBd7zq6CQd4I9vzsbScDzgQjkRnrBUWVWyajzrWctKB38p22x67g5bmWPovMtn7AeEx4
 8oK8tQ8pd+M9rB1UZM+tzqysywfeGi0=
X-Proofpoint-ORIG-GUID: pG3PN4Jte_fArDPRM8NZGQXaDXR0VzXY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_09,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300018

On WCN6750 platforms, QRTR SMD may not be available when ath11k starts
during boot. If QMI messages never arrive, WLAN initialization can stall,
leaving firmware running but no wireless interface created.

It also hardens the cleanup path to avoid crashes when deinitializing
partially initialized devices after QMI setup failures.

---
Miaoqing Pan (3):
  wifi: ath11k: fix sporadic WLAN initialization failures
  wifi: ath11k: fix NULL dereference in ahb remove when QMI init
    incomplete
  wifi: ath11k: unregister PM notifier on QMI init failure path

 drivers/net/wireless/ath/ath11k/Kconfig | 3 +++
 drivers/net/wireless/ath/ath11k/ahb.c   | 8 ++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)


base-commit: 6776197cc88d0d397084bc47bca7e983017cecc2
-- 
2.34.1

