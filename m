Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556B643A81A
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 10:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786011219; cv=none; b=ogsXd2X9dA1iCcidwOT/byM9JWFcEl7i3rv2GZNmQqNRLGSSCjO54IVjhY4jdyc/Nt3Mo6JjKHM3nP523DXn1oni4c99RwVA6M+e+Y8FsLWJgnXgzAfPNBSWwBvvtsyT+QFPKXGgzBGj4qmCdxaB+YSkVhIApE3Q7nuzXQGWmp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786011219; c=relaxed/simple;
	bh=+pR5n7eGlW+E7zhNjzn+gm8Yjgj3/7hEZypFFuXVL9I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=V0UgfMq43a0joDq/GsLlLVVxMFqoiGqSQRjSHx+8kmO1wBNbpsEbuikIM79YxIDO8dk3qQvnMoRfR7TOMCgnpLlvHrp+STfIxSyq52Pxn1O4xi915xcFdWdO1KYZSV3Uvy5O69+Z7vksCdyxQpUbK4H95nsA3MUhpMQJWalqTVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CCFOmEOY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=L4N5sdec; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CCFOmEOY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="L4N5sdec"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769oGcA2106070
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 10:13:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=nlgUItZJi20p/1QnUqzNvFnZEGbn4NO6CQM
	mZuQlRVQ=; b=CCFOmEOYr4KkZYLLNaquTMfb+X5C3doMyVCDR4tpfAwve1r9oeC
	hvoHZc9txUyx4en0bf6CXRIltQxQl1vzOaj29KFdOdlZSRhnvvGKiJcjp/p1pqg1
	osM7iarJY3voOMD9QbwNbGTDR91utA4v0lI8Z+O4HIGCHlVzY+Z8St2Kf/vg0mfM
	Lzzec/TY+Tz6elGla/4QMOoQlYVGfSfEXy/RHU70GM+GqZufjq2b6mVJqcqi6QLg
	VQGrKt/xUyZw0VIR6zDwvwh4JphSDw1Xi+OLS3bMRypP285P7pd3lXkZ/DU96+vg
	k7UdDjWbNRqaf8tRUoi41WSlMIq4nEwifdw==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvq730atc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 10:13:37 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38fa7b09921so3271517a91.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 03:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786011217; x=1786616017; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nlgUItZJi20p/1QnUqzNvFnZEGbn4NO6CQMmZuQlRVQ=;
        b=L4N5sdec2n3h/e6iGOE0AXP/No8pZwy6HB5nNywfYc+TA7JPbR18styCrhKUSGY0mG
         E6K2+T706l8UYGerPQDlPD0pGXlK91G/rcLHSxenMUgPPYo4UZ1tbE7/4j21CGi5ztLl
         cj3tmTzy6xjQ3d8FhyDAMEqoIeJzbg7CwVkrX/ia7XvdF5BP0C2HnFmP6E04rOqiLLn3
         SSW3omvZmoLiXbcoPxTkgZ2MUFCoHzvAd0qcqr1GcSVlgsM/f89KUuuYtMlXhJBEFeAg
         pClyJo7VC/4uoEzWl8arj00fMJOZUEe3e6j12VdLmzfe+j9KjPuIpJ2p2dRlFxK6E5h3
         Y29g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786011217; x=1786616017;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nlgUItZJi20p/1QnUqzNvFnZEGbn4NO6CQMmZuQlRVQ=;
        b=OzaI0CFeeZPIBLr4jJ4O3ghaqEJMY44Xxx4DNBbI78zReAt8t0aHhtC/sx1tXSwkyR
         ExmTWO42RAgZDJJrWnZw6P3YkARNvsuQ2ivPgierFexE7xmvKyZN5eSBW+7sSSlw/9w8
         RwMj2eKABk3Blp8fhdDoROK3wbqVX3SAmxxuRnretFErsJYWpbxLc+o6KwBZXLxPz60y
         Om/oJuWs4UcsVBeIKfHEBg5AiP6sVHZ9TL21vkOL98UkT7eG5ijRaGvhEIpQUwmSj/+g
         Dz7uh2dUXIqP4gYO5lQwSEO8ZvLToSzeeGGOPB+Yce8TGbRmxKaoiCLZRkA57/794SZg
         Krpg==
X-Forwarded-Encrypted: i=1; AHgh+Rpn3MRI2cmql8Yk9q4PEwl/6Mts8Q2mck5eOq0iqYtYgk36VGWGQL7R3louYF92KfWabeTiBGXfcQSidOmP8A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyg/k/FTq8pfKqMOsugpOrGLrmoSw91XIMd3P1l3ZKuXcaB+SD3
	f+FAsDP1a6nKMJtclvQIM96sG7WUxFAMOMN5FcBWMtCAFN7Rk/Nz5RlegueQAM965lDUDe0c5Y5
	uiiuEaSgLT+2MlYPDmtNHi7OGdPygf+QQ2XmbbStuw0Lk2L78yylWvOoUmLn/KA8LRBncRg==
X-Gm-Gg: AR+sD10sgd3PoNbf93hb6188uCCaJd/pe9mweo+ye1tSK7T2mGMTqqKsnApiZ1XaDyt
	PfgiUl4AMM3rZ/XvGsz4gT1bjbiuytuLN6BgVATO8YWWLxQP1EJbiMn1AMmQpGOlwnmIEw8yM2N
	OJweDS8XzuB/jpwQTytIdrqJneSFVmDFPEaEKfcu6hFq3Kjim+cjXZc1WKNRYKFV2TP8/UEKip6
	u3nCsDiFNLLsOUIodtAeYPpmZ5TloyBU1y7RE7t979BHIySvK/kiXdTRq+x2Dx07zuopqJW6z4y
	/ChiBjc3B8thRDgVm2/7sD1kv/VHBEMSn6OIHXvUIeLci0hJB8DvZtEzlU1WOu2q8ktvJYdw4TK
	zPcIvR8xWk6SXQF60r0Y9IZbC9DqU3GX1AuCfSDhKNNpwfzi+MiJNa7tPI1Y=
X-Received: by 2002:a17:90b:4f91:b0:37c:6910:5758 with SMTP id 98e67ed59e1d1-3903c542f55mr11253248a91.1.1786011216824;
        Thu, 06 Aug 2026 03:13:36 -0700 (PDT)
X-Received: by 2002:a17:90b:4f91:b0:37c:6910:5758 with SMTP id 98e67ed59e1d1-3903c542f55mr11253211a91.1.1786011216409;
        Thu, 06 Aug 2026 03:13:36 -0700 (PDT)
Received: from Z2-SFF-G9-MQ.ap.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39085dc396dsm1257090a91.3.2026.08.06.03.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 03:13:36 -0700 (PDT)
From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Subject: [PATCH ath-current v2 0/3] wifi: ath11k: fix QRTR readiness related WLAN initialization failures
Date: Thu,  6 Aug 2026 18:13:28 +0800
Message-Id: <20260806101331.484063-1-miaoqing.pan@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA4MCBTYWx0ZWRfX+TXD8/KcO0gY
 RBnFsMRuNFG5ulQNiK9W/YWzHxOhJb2qBGh98a6ej7NIpabSCj2uMqq6W493NiiGSSjJCQkLR2T
 dJXWpobODyJ79b4KbcQ3g4TvR9SxGO2B+29sLesHVlm/syhBy8fh/rY95Qn/FRfCYXC+HSdRXhs
 TNQ5ITx3wI94x3ubPaHu5Iq7ZjnDi5w+VGr/3jrIuFoYACHQd0raVgz0dOoxhBVtiQe/ovk8Dqn
 TzB5Zitz4milZDRyfhOG3NbVjfyQdOqkT6jlZ4zzVtnXHcnSBhYKNV6DhASCmC88+D9apI1sYBC
 PDBr9zVbVuceALe975jqjMwu88s4ea1CKI4Cq26TfpHu5K9L3IdIquQHBL8cRNXdEXEki7/r9z/
 aSNkpoamGCOsrtApKJLQec6zYKD4c6LCMS9U69ua5xajFQCK8JNhiKPkcPcJBD++BoJGK4hnxJ3
 LJVFnBxZ8SkM+d8RgXw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA4MCBTYWx0ZWRfX2M5IlDCbgOUB
 CQxo7I8bsiEt0OHpNH0OrGsCizaCXzJEIbz9rqd38NwDOr9rna+hgxNflNKe3ksFuXlLkrVNXJR
 duvRCkgrQeDdbAabiU7RUuQrDlIW/m4=
X-Authority-Analysis: v=2.4 cv=EeH4hvmC c=1 sm=1 tr=0 ts=6a745e51 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=utuh3fF2I9Z6vZmf31cA:9
 a=zZCYzV9kfG8A:10 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: bCA4XcrlU0y45mvEnKukE0o2dEvRvf3s
X-Proofpoint-GUID: bCA4XcrlU0y45mvEnKukE0o2dEvRvf3s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 suspectscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 clxscore=1011 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060080

On WCN6750 platforms, QRTR SMD may not be available when ath11k starts
during boot. If QMI messages never arrive, WLAN initialization can stall,
leaving firmware running but no wireless interface created.

It also hardens the cleanup path to avoid crashes when deinitializing
partially initialized devices after QMI setup failures.

---
v2: Replace the ATH11K_FLAG_QMI_FAIL guard with !ATH11K_FLAG_REGISTERED.
---
Miaoqing Pan (3):
  wifi: ath11k: fix sporadic WLAN initialization failures
  wifi: ath11k: fix NULL dereference in ahb remove when QMI init
    incomplete
  wifi: ath11k: unregister PM notifier on QMI init failure path

 drivers/net/wireless/ath/ath11k/Kconfig | 3 +++
 drivers/net/wireless/ath/ath11k/ahb.c   | 7 +++++--
 2 files changed, 8 insertions(+), 2 deletions(-)


base-commit: 0ece44d394570806e97c8471a50dc9f584516ef6
-- 
2.34.1

