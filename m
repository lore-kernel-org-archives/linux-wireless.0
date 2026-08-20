Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F107638C407
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787204895; cv=none; b=UuMpSRkQ6KBnNbEehmHmOJY8MRMg8z1DPsIOIW5HSCO11qRp+eL4Zn7yu05EG2nJw5KXz9vcQPAF4XRoUA/ugsVLxBCTIUNBFUCVIpToP8ukqWoAAwT/oJFBTNlVSuIeZdq2mQ5RZBFL4K9XeKQYbOy0LKTb73yIAor10usQGFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787204895; c=relaxed/simple;
	bh=kxk4vCw05ILczeFHg/NEZem7GuCgkvRsx+uwT2rnkdg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=m6tmD+nB2XdszqSdgRCDF1qjhwu3V7+9vHDuk4B3SyKuLbN5qi2axP05hRR+bu22x5LkijsWvKq34+PumDIj+BEWMT2B+uWk1L+O7O7/2u+bdIm/tkBkILV0nR0A0ZpHKMwSi1Kuvu5KJQ+esOIzSDvHkciNnUsKtIgoHn5rPYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RtOL1Sg/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=K6BFDZpC; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RtOL1Sg/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="K6BFDZpC"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67K5UGLL1028081
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=6KUfB+zYy6tDKwxr07i6VcoSbL28yueCyKa
	NPo7rWBo=; b=RtOL1Sg/oxt4xz2gjN/+b5xwt276xR5SV1V188rF7NY6ib2o/Ew
	YFKsKUjlXGmXINaunA/bXww4gMhXINc0J3Ffx7N6YkX2Uy+Sz8pjKBoPiQVTS5Xv
	PRRIhFC/8gQv31wsktYpa0dDYhBHYDsX7sPaJs2x5Zv6PJrD4dH04K242Ho2lvlO
	BooxT8urazi7Z+ImZQSsFPPvflJQRJe8vxGJ96EGF54/QlivrFVlAskOSU6PIjME
	Csdk96gNijOx68fEdT9tsSJxJ6IuFkzVMXGJpg3xxA5IE/XbVtn+LTd46K4xRgDH
	e1soGck2euk7CWw0VlbYrwzVKOrhTP9ZuXQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g5es4kavn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:48:12 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3950b1371a7so2786675a91.2
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 22:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787204891; x=1787809691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6KUfB+zYy6tDKwxr07i6VcoSbL28yueCyKaNPo7rWBo=;
        b=K6BFDZpCY2WXdTGDrFkm0KB+9VutUXprnAIfOub9tVG+tZ2DqDE81UWxm06d6mLPDj
         10GBD5wXKz87bumuubKQwtgsfuI8qa7H7OwSlTkdeOg61Sihocat7NGTf6qZEkQixlFq
         VWpFp3Ui5dUezqpqPtGZBHY1WWvOLu/mlnX4sUiPHqA5tdzHQDHvptqLoRmj+wwbwdKf
         ZNQqSQBQ/X6h5K9D0pHtPGEBW1lGgJQ6IBa5NFbC5Ypxiz1P1bejkLMfq+HCECHFQD3w
         GVqPXiER9PP7ihzfnQyOMQLIF15Gv0T8p6rnB0b0i2pQLF/lX/2RbqdMOVqtptMYkcYm
         u7bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787204891; x=1787809691;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6KUfB+zYy6tDKwxr07i6VcoSbL28yueCyKaNPo7rWBo=;
        b=QnxfJH+oczp2K1pW2liW9PANZhy63LpZBL4/w+TTCXSnlbvU3DpYpyxV+6FFdJmOkj
         V5Hd+BqX8/MG/lZKKSkpGko3N0czHIR26K38sXJM9mehhXBe+W7rFzIT7fWjYo/zHj0o
         eRmZ4nDJ83rLEG5TYLXUw/wz6Ma4ne3IvGhnP/VW+tFCYjdQPJfvNtgO7ta3mcm2/9kE
         FbXLznBJhkH2RXEXhOhqbjGW6XH+o/hV5mpZgTEIbYHALnO46NFRqF/AI5lf508yGncy
         KKaiV4JOomTGEAaUVvzJYjDERGYnoW0Dk5rztxihdpRQc/sYHk58Yl8e3nIz+wZM/3bf
         XVJg==
X-Gm-Message-State: AFuF++noix6v1fz/pADpJ/ebXPBJeRUri0DIjPtsyfsPFfv7VCi3kl7g
	+MAZzKZaOxkKrKYDH2needxvWrY+DKmG33n6IUKS3AGIBEZvlPR3M8wxiFOswrMnRrbdJnQLtpM
	oqDUhxjEtpmiZ8y7rjDzkuNn3Ox3BgUwRKeQ/rSICbPidT9wNPVca1n9J7MaVWk4NFnYl2g==
X-Gm-Gg: AR+sD13P8lMKfRuH3FMGwdSlRVrnUC3woBcNwK521OEeBpK6uAl4XwyJ2BVIbuZTWEF
	LQTl0iyKfJjI70dxfknULQPoBTrsbExfijM1PZfA9w+RhmpskVQZx1XLd17h3W5FsOjULBs0B4a
	ncChDWhKrH5xaV8SKKfsr5L0SlEEc3v7VFG90PjDCxdesF0eZd8W40VlnHry5hSfED8XiVtAvtF
	l6GAU0olq+sTRPdvy1vUr26nE8OLQ1GK83pxwErOVJmDHYYyLqzkSw7h0rqlUTHaqvuqx1UaiiK
	aT67JkOlY5R6lxTmKXCyCvT+bi5GxbpUcD+ScZ6Fx8wfl0AqJc/x61222kS+sENnc18IDh5X1fV
	3rzBooY0lxR57CpSqD1mLwHtpgKLb+1ZxJfN0dDNAy5dwWFNAsmQ92XukbFk7ns62VHz9o1OViJ
	g4EhP+5TXiVks3ff8MCkoUL+s=
X-Received: by 2002:a17:90b:1e4a:b0:37f:c97a:939f with SMTP id 98e67ed59e1d1-39580ace5fcmr17925311a91.7.1787204891577;
        Wed, 19 Aug 2026 22:48:11 -0700 (PDT)
X-Received: by 2002:a17:90b:1e4a:b0:37f:c97a:939f with SMTP id 98e67ed59e1d1-39580ace5fcmr17925235a91.7.1787204891156;
        Wed, 19 Aug 2026 22:48:11 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fbf3dc2sm5440931a91.17.2026.08.19.22.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 22:48:10 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jjohnson@kernel.org,
        quic_kiranv@quicinc.com, baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com, quic_periyasa@quicinc.com,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Subject: [PATCH ath-next 0/7] wifi: ath12k: convert DP profile parameter macros to inline helpers
Date: Thu, 20 Aug 2026 11:17:57 +0530
Message-Id: <20260820054804.3222296-1-aaradhana.sahu@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 1tcCVroQw-p3QwveDApY-MOxGwgWwWnf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA0MCBTYWx0ZWRfXy15mLrZ9/cMO
 1wQDP7URf4HgvXRUVjPQAOLiRSgoomo3mHneDeJprHtztHxsZlFvEsWNG/P42YPVROhuQISBJGS
 hCvTzb2G7CZPi48Cv5RkoaYkhHDHWXbFLoyzP0xgTYPZ7J6MQKhSA37kLf6lb/AtMdNStO6j0tb
 TeWilmclayKJKzRC/3cKP/cH9HuELNVNM7pkOeljgaNcxqDSfUtqP0TQJNOFe1hkSbSI0zkc7eV
 Joz1yBO8GyZ/vGK09mJGhvhtjBhUSuw2kUjPgwwoKwmhNg6kEImOTkuTH9V8zyPGh9ylUzN0e2u
 8B7wbr1iKjabGffEpjxoOiuG8Qf3umznz7disHcnFSueP3zljpACy9MeQiN6179NzHklYWxh31w
 nR8q4EwxLfSC0Hrtjs4YNfwGQxFl0cdxSLko62UXHWdkgueTXsNunETK87VFYEQ+ZDpfgJcvbvs
 qL7wXmNWkQUGTqtub9A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA0MCBTYWx0ZWRfXyEyMB5roAj1h
 m0zTDDnUW987HD7LJ75z5Z5ETBj0VjfB8f0IpcFrryujIzJ/G2yfL30vnyz6DXNhQB9ElA2MCwH
 93aR9hPkt+jrLiHUEvK+bZT//gyDGNo=
X-Authority-Analysis: v=2.4 cv=CN8amxrD c=1 sm=1 tr=0 ts=6a86951c cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=z779poplHCvFrhnLu2gA:9
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: 1tcCVroQw-p3QwveDApY-MOxGwgWwWnf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 bulkscore=0 clxscore=1015 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608200040

Convert the Data Path (DP) profile parameter macros to static inline helper
function without changing any functional behavior.

Aaradhana Sahu (7):
  wifi: ath12k: move dp_profile_params to dp.h
  wifi: ath12k: convert DP_TX_COMP_RING_SIZE to inline helper
  wifi: ath12k: convert DP_RXDMA_MONITOR_BUF_RING_SIZE to inline helper
  wifi: ath12k: convert DP_RXDMA_MONITOR_DST_RING_SIZE to inline helper
  wifi: ath12k: convert ATH12K_NUM_POOL_TX_DESC to inline helper
  wifi: ath12k: convert ATH12K_RX_DESC_COUNT to inline helper
  wifi: ath12k: convert DP_RX_RELEASE_RING_SIZE to inline helper

 drivers/net/wireless/ath/ath12k/core.h        |   9 --
 drivers/net/wireless/ath/ath12k/dp.c          |  81 ++++++++------
 drivers/net/wireless/ath/ath12k/dp.h          | 100 ++++++++++++------
 drivers/net/wireless/ath/ath12k/dp_rx.c       |  12 ++-
 drivers/net/wireless/ath/ath12k/mac.c         |   5 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c |  12 ++-
 6 files changed, 140 insertions(+), 79 deletions(-)


base-commit: e07447e654476262558bee570f4cf456e2b32565
-- 
2.34.1

