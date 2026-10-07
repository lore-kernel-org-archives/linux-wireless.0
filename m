Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EB9439F62
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 09:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791365077; cv=none; b=liAjwj0HJpgqy60BHKyVB9Npn47wsY55fMWn4L0I79O+RV6kgQnfjnPChwvpFemNRPYRjfu/kCRySgcfLgThFWiwSQZpEAhlMIN8ITBKYUl4iY/pTc/C9pDbULLogTV0xY2m8A0jtB2ttFLcw3oQUb9kL/UVdj5jEjyd7Qvhgig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791365077; c=relaxed/simple;
	bh=czGHphqBgYs6gHPwviv5ySMy2P74dcbu3/abDIc9XP8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Yjg/vDuhuz96IUBF7DGC+Kk7cdvWaK6hueYHRqcRPl7/AbD1sJBGOd/PIGXF9UlNmReacQ0u73XsZUo8Uv2oNuzMQ6JpVeZxcB5G0VWUWhaz1yMbILchEKzisRF8I91vGHvGlvxupyByudhOSD3jl0iitilrPty5AjgwG3mHWFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XRDbbty8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Wm0Hjmuc; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XRDbbty8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Wm0Hjmuc"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6977jmWD3686138
	for <linux-wireless@vger.kernel.org>; Wed, 7 Oct 2026 09:23:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=ynqDIYHMa1ewQNzuLLg6pW
	Nb0JVIGJCGjVJeZk61aoc=; b=XRDbbty8qiLC+1OwApa1LDFNUQRaF55Kh9b5iS
	ThVcYwBxYB8OyH4UP8PumcCA/89eQaz9MHBL62xxvAs2yw0t2wO8njY99/acEMNN
	ELdQ3Lx2Ph/MyA0/oX+y+2YPxUrkKAE52KwU+LcJ7CwcjTFm8RMqoeyRoUvYL+mp
	Vsurp5lGLIy+FVmUbLS/rAppoueXS/OUJioP5ZUaR7IqAPibXcAxam6KAqLO2MIo
	qG7ftysMe1cIqkPhIHXnvqgC4frpzv6c60shWwQoz6Q3O8dJpHs5xPIV0l343snM
	ySDFPSKPGsNzNakQQeAuIWOUOdvoB6WOoq9vP8o1CZP13irg==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5c609eyh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 09:23:53 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-88f2b158139so2385039b3a.0
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 02:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791365033; x=1791969833; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ynqDIYHMa1ewQNzuLLg6pWNb0JVIGJCGjVJeZk61aoc=;
        b=Wm0Hjmuc7vGZnddocicDv/UTGziyP5Dz9OtEL6KZ5x7OnjJyN2LhXoLh18Wv0KjzWH
         4BUAKEsczjpA88jL1TnGWnPKYynZi1RW6KlBmc2EX81ZWcYjorZeaGXrBwfEvOy5WUHv
         7RChoI8tXAKREsl81CoJL/KVuI3clsUgL+xoTO+sFqNiE/RWxfDCywpeffxITLnNrlMU
         UmdpNR75Fb5hBDH9Neu/FQUqJNhCZiJglgxkDmKKBue6Q0dl0ouVk4DEDgzI+MGjSs8A
         PK8W/+/cbtvAjTfe+a+sVIs9Pe4KME+fMzj5lLzCIdHhRa98C5y05x8nBfXEbqZhf36u
         TkzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791365033; x=1791969833;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ynqDIYHMa1ewQNzuLLg6pWNb0JVIGJCGjVJeZk61aoc=;
        b=QuGxDOQxRrGIr5ga3yLi+Qi+EKnnDCRNCh3qyL7QnjvmfAfV+tAWHDaaYRPIgGdm1e
         faQ9tTpwGfU39WoTFh+UF5g+eqj/TluDk9Syxvpzu4oyjQHSnd+ka5y76UznaKtEQu0d
         xwrdAgk/2tQEO/gn1IJQncO3yHEz0cGsTXLCzJTlnQZgH2nGZku4oL/WoIorHEHaALRq
         s66rAHVN8uo7yNkdT9F88XLuAP425RJOvLDUBLfPspjY7TUMNaeraOQ61LvmqtolNzAT
         DRDDBYgcGCslccgMlS4FCLTpBy6ndTyTucp+yrAMqubMgC3/e7WR/vXQR+Kh2C/wl9SH
         OtZQ==
X-Gm-Message-State: AFq9FYJTOMyZnV4O/geqL+YnLLpNI6Lc738veJfPHO7tjtgLHcL871Bz
	GMzBkuZGwq190NkANBpsbMH4N4XLlOqJn6xBojL29eEumhrv22VgXKmVrF0Jfvoe62eI+VPOv82
	mcqtAg6PPBtw0rtyz0nJOa+D6tbflQgACbN6clWCKj9ReParcu68FCIQ4P0F1spm5n5Lvww==
X-Gm-Gg: AYBFou3BhQ2qj3sk8M80J+w9wx1p9br0YJ8msQCyIGJJUTqFupRXrX78is4PJEoLeX1
	wXKqdk3cR6bePGfWuanr4I3BsztOXuj90mUJ1DjClDRwVO0u953FI+rhBjpgGbrYevNZxW6Vf7f
	PMT7ztiNZVTt+Fv7rtHVkxbEZjO2LSEC8BFAjPDOLiSclMt343ysVvFogHA3b/l2N+GVZ2da0VX
	xDJm0y43WGYoxJ4agaPSz+6BvLdNoUpr1z6rEnTFoDl2m0Mdu6jqELYiTrl1xqJNfXvuFy3UgGP
	Ip0QTEwb7h+TIe+V7KrZDz0yMZhzvIXlJzqZmcwYsA/2fsGJyns4jWFNtFuLgGXd6CThjmoUxuF
	O14vH7m69axrxpCGGahFGCgqiGXqPYQowWQ0nTMzeBihrDY5NyB3cKI29gXJzymZW22k4AZkYCT
	Ca2GDEZKJZyOdeIE+naVl5fRQ=
X-Received: by 2002:a05:6a00:2d23:b0:87c:e6aa:30e4 with SMTP id d2e1a72fcca58-891b4fd5adcmr1424242b3a.48.1791365032479;
        Wed, 07 Oct 2026 02:23:52 -0700 (PDT)
X-Received: by 2002:a05:6a00:2d23:b0:87c:e6aa:30e4 with SMTP id d2e1a72fcca58-891b4fd5adcmr1424232b3a.48.1791365032065;
        Wed, 07 Oct 2026 02:23:52 -0700 (PDT)
Received: from hu-aarasahu-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89271257af8sm119128b3a.41.2026.10.07.02.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 02:23:51 -0700 (PDT)
From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Subject: [PATCH ath-next 0/2] wifi: ath12k: Configure RXDMA buffer ring
 size per memory profile
Date: Wed, 07 Oct 2026 14:53:31 +0530
Message-Id: <20261007-mpp_ws-v1-0-739b1fb87d24@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJMPxmoC/yWMUQrCMBAFr1Let4GkaEu9iohs061dwRiy0RZK7
 26sn8MMs0I5CSvO1YrEH1F5hQLuUMFPFO5sZCiM2taNs7Y1zxhvsxqyRzec/Ei+I5Q4Jh5l2Uc
 XUJ5M4CXj+jf67h/s8++DbfsC56svrXQAAAA=
X-Change-ID: 20261007-mpp_ws-a041d5cfac9a
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
        Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-ORIG-GUID: QMB2xumSL6IxWqUyhb5oCHkVPA9y0UaP
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDAzNyBTYWx0ZWRfX221sZaLGawC/
 QhqTildZoYV8FN5S7xz0ndnoUcOb0fVxMyH4yb3kh538gPfi/aeoSrAUK9pw+KOL7O7//02GwrT
 x81VNs5kuXIxsMuKvbgUAdzxO5xbG+Y=
X-Authority-Analysis: v=2.4 cv=PM+aavqC c=1 sm=1 tr=0 ts=6ac60fa9 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=PwSPXMvPeXUFY5uDVUIA:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-GUID: QMB2xumSL6IxWqUyhb5oCHkVPA9y0UaP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDAzNyBTYWx0ZWRfX8Vp+WVOy6PHY
 Mq5WjTFrsiRmwYalafppWtHrNv1WZUdoPkHeW8SSc0AlB7owp8MrkUit7NzcakVxWIgn8dn5H3K
 /VV1YsauOq8K5KcRD04B5YMpno4fYcDkWa/RI9Tux9tlWLkut6liWnKXuBSSZ+piuAHEQTq91iA
 4o1JQtDq98+xTrPcvF6ll1V+B05poMp1wxa4KifZGXi5LMSLYod8YXrtVKAjHEbthl1BKpVBON0
 LZ2JLPE6i3T1qMxN6NIKyaNl1Bf8l0bKr5sP3g36/Of5h4w9xiYgp90WuJag4ioXzUJMtutcchK
 ynAMMoOBc4PillQzxJO/tkrBlio5uk7kxLxs4T9H7bud/t1m/BeDyjjKS7GOHWJ8nSMH4nJAhse
 Hw3JG+8jwrHHPAkWnCnrxPztMTBZRqI6ewisJ5qzqekfkDCXrxmjc+6/Cj8JyVJji5No0oGpD8y
 yOrm66gN1KdHjZcwcHg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610070037

The RXDMA buffer ring size is currently hardcoded and shared across all
memory profiles. This makes it difficult to tune the ring size based on
the requirements of individual profiles.

This series first makes the RXDMA buffer ring size configurable through
the memory profile configuration and then increases the ring size for
the default profile to improve RX traffic handling.

Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
---
Aaradhana Sahu (1):
      wifi: ath12k: Make RXDMA buffer ring size configurable per memory profile

Pavankumar Nandeshwar (1):
      wifi: ath12k: Increase RXDMA buffer ring size for default memory profile
 
 drivers/net/wireless/ath/ath12k/core.c  | 2 ++
 drivers/net/wireless/ath/ath12k/dp.h    | 8 +++++++-
 drivers/net/wireless/ath/ath12k/dp_rx.c | 2 +-
 3 files changed, 10 insertions(+), 2 deletions(-)
---
base-commit: a90ebf2176db07c5d91e0a62e15ded1fd50710a0
change-id: 20261007-mpp_ws-a041d5cfac9a

