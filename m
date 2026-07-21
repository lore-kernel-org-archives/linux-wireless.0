Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAE640912B
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 06:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784616647; cv=none; b=OI4F3HcvIXNSJhBzJs+80nd2npjDe40xvSiI1KRXf0vkxhErYBZPtKcqRG5Rf3bNM91UWuTQeDhhMVBq7QY4HiJx3K+P24TV6bEuwdDLonjOzhrSEFEWXIjYur7scPXtVnPd7YYGzWWulrH7V+vh0DrnPpASvQ2zW2Kh95V5B18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784616647; c=relaxed/simple;
	bh=OljVdw7B5U+1cp7GY7KEDiCg+xfH3jtmmVK1ozdt1n8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pC21MF9ABDCajDe7DB7u6NTpluz7K1gEy46Dh44r8jp0D4+tshR3GjkLS1K8eO6YfgR41jlF/qJamxud+95I+a1ie1O8fH1ENPsBl3z4UlGTwgslzwUaO6gk2bE0sG6s7IUhz/qaM1gysrAXHJ3r6cXKWtLno+MFGPJuClJr+kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YdMODnOd; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LY850FHo; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YdMODnOd";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LY850FHo"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66L67LPv4106956
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 06:50:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=MLkC3kwEWarNnqA7wdIi6MKhNZVVDXMKgzT
	xlcchG8k=; b=YdMODnOdC+LzfNcE+8xcGtAqiuX0DCfhlMVxa/9csY5475eh6/9
	HNDNDdIfp5hAZy0IIe5/FzijPiogx0pWz3EzY1mXd0EwJUCgepVeMLq45iKQZ/pa
	8rF1CJ4FDWKK5zZ0dIac4qkwfhW18AlKZ2lDyEYPC7pF8+OrvQa/qxLCY+oT8D40
	//NNZLRoIGdGIiWqNzuiduPw5yh0/vV5N34z3qTgb+Ei3/N/HwEzswiSBnyhFm0a
	xn6aVKFjEfTfpLuIpDWATo+MpE5g6rYktWrKB4VHvuNnF2AATHCh3hMrtoY9jdc3
	qUbiSYTLoywMuEuuOaAjwzjOIFAzd+Fru/Q==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fhvqn9k84-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 06:50:44 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8487eb67173so17156093b3a.2
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 23:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784616644; x=1785221444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MLkC3kwEWarNnqA7wdIi6MKhNZVVDXMKgzTxlcchG8k=;
        b=LY850FHo8vKu/mZAQjMpAweV3Twk2JKKq3fD5szlZ5tEY+t1KcMTC3PNQbd8caKYHQ
         uSBe14qAPmyBNq0iGOzW6dRkDQ1xzELQRUBVxFbZSSBQsH2jgnvQlH7NXEbcephDdIgD
         AHHud9wQYcoC1JpDT2+Qiju7dATXqv7n7Zab6iG3EE4qeFW2IAB9Nm5mBa5OFqMYimTv
         gdWoIeSVXchALfIfXv2ba8S7RhC9QdEM48gPulbCtMi9ZwgexdYZZ4G64K1YQ8P5bxW/
         AYx5L2jYFV/vRwLQ6+G2jlYQZaV62f9dIfbzdHunbMULuyjI8YXBME19dO10XjwCdmKt
         uolw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784616644; x=1785221444;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MLkC3kwEWarNnqA7wdIi6MKhNZVVDXMKgzTxlcchG8k=;
        b=GZz9mqDl/BUt2QVzI835tovaweGF3WyOKvAKgLYJ/7zH5KxKrECaHjdZMnhH/HEipq
         GBDFdpkLu7J2Y3zmtNB4fPKhTn8PRJ1ziaEVvYB+7IAySVJPWbI4CxcLMBhMrlJGg/fK
         fDenkM6c7JRoMWedYVBhPI0OsYQpOSOdgY922/GWGLFmrr91iC4BKxcxXaQC66UQMc+T
         xOvcSq/MkWTl3Ku30zasJzo7usoGZGBRemwUug7q82qPvei97GoB5JPhuvqgg2fLN21M
         GCLP16gpXC4HgX/3pnvLr51nQh10wDhC5g8IinhanRBP4pefEg351TG/KzDnFXfQqjm2
         4XWg==
X-Gm-Message-State: AOJu0YwF6HT1etwkM5K3InZoKYJeFB3llW3TVpiP353DQuCOF6XrN+Kd
	JO+nbTaUx700FXL3Ddam/wu85zASSjZWnwKTJLFc1WcWYLajgHgNOz63xIGUCNjd6WFOkfjaonE
	l16WeYtsjQHi94TqAZBOBGG0oKDWgZg6LfwBL066eWHMISVhvtglSabPweeU/htnt0WxFOw==
X-Gm-Gg: AR+sD112myyBoQH1e5bUuTQ9BjrqoNDMHEvt9O0qD59io5XSjhoGm+ZCa9EeVSodtPU
	HdqTWdICGO4QV5NO6GfZIUh2BIzw7N8GKxfQd9TXULQN/XV7YNmRhFHFwUAHwKnrURR3EJS+zjC
	bL+zt/XtJuqOMuWV6oG1jlFNfdb7eCza0RHr6ep5st6UJEZz9F62K5jeL8dg0D6mXLi9ISZao4F
	Mss12gl1lK9eBRBIDuFl9AazdtojEjnZasVO/UA/wOengsleMJ1wWNJ1gdN7fL46Xl5YmCJI7BI
	UuuApeigJnhBRj19I8v6RtIpuTlFLWmMFhBPok38E/mfkU/y/82kEuXjwq7NKgh7n1Aaz5BbCCQ
	0/qYWuChDLR2duk1N6GPU5Bhq5jRDV0sUdrcLMTcD+9LNm1ShJMkW3dAT2BortyVqbyR71itu15
	ALRjM+dWA7ua6GGOkpaGMWeyQ=
X-Received: by 2002:a05:6a00:26c2:b0:84e:6b5:e959 with SMTP id d2e1a72fcca58-84e06b5fa0bmr1057006b3a.78.1784616644333;
        Mon, 20 Jul 2026 23:50:44 -0700 (PDT)
X-Received: by 2002:a05:6a00:26c2:b0:84e:6b5:e959 with SMTP id d2e1a72fcca58-84e06b5fa0bmr1056991b3a.78.1784616643856;
        Mon, 20 Jul 2026 23:50:43 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2af9ef6dsm6902392b3a.57.2026.07.20.23.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 23:50:42 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Subject: [PATCH ath-next 0/2] wifi: ath12k: add MultiPD support for AHB platforms
Date: Tue, 21 Jul 2026 12:20:36 +0530
Message-Id: <20260721065038.126046-1-aaradhana.sahu@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDA2OSBTYWx0ZWRfX7xyajoenxnLk
 Hb1bvPo6jo0yrI3wqZH5C5oo/P0e6YdEjLhGgVFLeBtHFqqOR0UiNx9xH8FSmc4iodjZLrbxFjK
 dvYEdUmqsaiYkP/dcghzbxQO6rC9hLOaa4CA8qwTpOoAWiyjcIeexafxnr3gOrnknXzIaBmnrpg
 TVBysUkY0ru0jvL9cGoiZV5i1sVTV3z3bD60SniEtItBmOF3P+df1nBeWmlEHhIB58jqIIlE6xD
 ha1J2ngXQwn2U8js63f8iJY2PHRbcmeldzyaf5moVSy8/YkHCw4jbf8KOaU1Hp4Wan35lwgE22O
 tVBV2h7G4IxhNMGNsXeAvlNdSzGj0s2VgDfkWA2YuG3hXcBS7os5+cqZhbOT3dRFPUtDGBievDv
 Tl+VRO0CfwjWcgNUGavNahsH9AKFzEvL7gFz84U0qhFhOuh0+2KyHNPXZuRNA1xmfXtRdJLEN65
 1iWxVa+jpnZEU4cn4DQ==
X-Proofpoint-ORIG-GUID: 4Lk6ez78QDp4ah7x_ZCi6Pj53QtQ3c2U
X-Proofpoint-GUID: 4Lk6ez78QDp4ah7x_ZCi6Pj53QtQ3c2U
X-Authority-Analysis: v=2.4 cv=M5F97Sws c=1 sm=1 tr=0 ts=6a5f16c4 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=b1_ylXVzjByToN5sv7EA:9
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDA2OSBTYWx0ZWRfX8jLt8sh1mqoV
 cwc0PMS9tuf+SpVbl+9dkpIvZwihyUN6DgwBpd0ne19tGTjsbSdi46HR5pWKaMiR3R4GNj3SD2o
 OIlzw7I2jUrlqEXj5Y7dy2lGFkiHOdQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_06,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 impostorscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607210069

On AHB-based MultiPD platforms, multiple UserPDs can share a common
RootPD. Each UserPD requires its own firmware image and PASID, while
RootPD resources and services are shared across all UserPDs.
Add the required infrastructure in ath12k AHB to support MultiPD
platforms.

The first patch introduces a platform descriptor to keep
platform-specific configuration in one place and provide userPD
mapping support.

The second patch moves RootPD-related information into a shared
structure so RootPD operations such as boot and notifier registration
are performed only once and remain active while any UserPD is still
running.

Aaradhana Sahu (2):
  wifi: ath12k: add AHB platform descriptor support
  wifi: ath12k: Share RootPD state across UserPDs to avoid duplicate
    operations

 drivers/net/wireless/ath/ath12k/ahb.c       | 209 ++++++++++++++++----
 drivers/net/wireless/ath/ath12k/ahb.h       |  34 +++-
 drivers/net/wireless/ath/ath12k/hw.h        |   1 -
 drivers/net/wireless/ath/ath12k/wifi7/ahb.c |  90 +++++++--
 4 files changed, 271 insertions(+), 63 deletions(-)


base-commit: 189721a4afa1804315e7dcfca9ca0539c7b1d7af
-- 
2.34.1

