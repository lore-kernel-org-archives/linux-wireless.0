Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85159474261
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 08:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788252987; cv=none; b=Bkv6xaELavHjcDr1uHxN1TBFgxsJAQ5eWf6I7fuOhPI/FeKMBkTiEb8LGPw1aPtb3w+2Vt2HpOLtQhMM4qUc1j4imK1IfD5YHIvcPhxCHEI+BDHrNy2LBPDSqdaFKKubF7VCrTZB0q458UYmjbSn/lPMpcw3I5lNzsopOibdhg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788252987; c=relaxed/simple;
	bh=kkY8RSU86lDTkYaKIXtf0swB37cfBDY8zqsiv/wALWM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=I0jBL7FhJeuL+e1O5hgORSleR5LiWTuo9xlTbl+Di+xAepIahjTnmsgAt34pAjHFRDTYCb08XOIrXuTMDuFiHPliOocZU9HtsvLcmYJypgI/MXV1FR+tNkSCWLNZzm8QsILaOegvbHdn1hEGN0G1I6bcPQYsDUxMWKUOd14JJxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QyrmW8KZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=STTKZFm7; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QyrmW8KZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="STTKZFm7"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68179CWf2061542
	for <linux-wireless@vger.kernel.org>; Tue, 1 Sep 2026 08:56:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=Y9XBPzABw0UQkcDXKURVyK4ifQ2SzxR3C1Q
	/2MVPQ5w=; b=QyrmW8KZLLUAU1nWsb36jgRsPlGyJd71HtQTUeXTIElMYRYjr3q
	dfHudVScwqVl+oiCoRCtEuBIwGEG5lryiuR9aWgLa78iR0sQFq9kgw3JcMZZ6wSA
	RUS5uOD4cIFJdzaVw1WKPtQjJnEWfiyJwW+hLcK4YLsXySoQeZmaX4L+42P0ehmR
	4KGKvKQfyKOMKxIJuKvnifI6q+EMb1Dsm+2ItdfaLq+QQDlagWlLP4v2OLy51MEI
	4v4svHdYUb8Y8pvfHuK50qpxMo1gUBf72H3d94eL3ANJ0dLNQuIGJ2sXEw5jcWoG
	PpyE9JP8mbWu5xgDMUvR5V69bnbvsdSwHDQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gdqbh162u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 08:56:24 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cfa4e4684bso16668635ad.2
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 01:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788252983; x=1788857783; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y9XBPzABw0UQkcDXKURVyK4ifQ2SzxR3C1Q/2MVPQ5w=;
        b=STTKZFm7CMwOqxs3w/qJ7UftELEJG7bUaKlEVSmZ1oIAkCkvzS/tKZoUkoTnSEKjCm
         TnA05sJr61YqPkYs0zPxo/6UWP9/D40hQpl7uNF90WVbvJbk3tbNDffctpglEI+xF30/
         mSiNflyD2st1I+zasCPtPE41BJ8N+pjyq0KWLZRTFWt0iWJ+8+mx33AImcqshOUp0Iri
         te4q0c1JFRYuk54ERhHvxjHlHPCDazKpNJir3pOjUds/9fQad+H1U3Wu25/6K5JMMtwL
         mEmL8sHLjWhtYWLrWr9TcR4ZIpKcCR3iYKBb/1Vu76UfXjljaf+2snF0YwGDrneaeToN
         qH9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788252983; x=1788857783;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y9XBPzABw0UQkcDXKURVyK4ifQ2SzxR3C1Q/2MVPQ5w=;
        b=BgSoJ2AeDtDsGWLYkpAksA6F7HQGe9w17ipKxkoC5nVtqiwzQl8EvSmPNwNPhqn1iX
         Z0q8B2RfnfgWLIX2XiCqMZEcWMNI/cAzOUMqwmWOVbnwXLH6PqP3IX8g3ZNr19OAdA66
         4/sxXsnAPu1DjWCNmVbOJyHYD40ji5EH6oW1r9N1jKuEyloPxYawINgKMiOB5WUIuLbz
         LnKAPDsJog41RKCr6cbvbMhOgKID81EmI+xF9KCqM4UEbajLilBEmSDy4zVJLHNdh93J
         x05FW9Oz1O8iMLRnXOFzXBEveyK3wRLXQoC0banumcWTeuItiIw6iIw/N7pZxtuyO1Wx
         tfmQ==
X-Gm-Message-State: AFuF++mVPm6FVYZFb0X5QghkFiFvceheDWLY2oXWlGD+vV6QwY6YBpX8
	HdO4nBplejCr+sRO+vNBNYKuMOftcvB9sMwRDMWd2dsZ46Bu2T3/gmj41UgAuanhi8qPxih55eI
	avdJ3g4CIPw/ZXFv/3i9t2z1I0ZKBCaiWpIe/jWMBgMKRgBMUG3mGNlYgDZP16KJRgIBiQ2aDu8
	zWWA==
X-Gm-Gg: AYBFou2r9sxXLc/scg/BfEjeAZ9AoeoueCfNKGjsc/BsCHDTv0UwhdgDh9fOxtkkevK
	8UbuAWxGRLQGkHXliUdk+Zpg04XXjXo/Y89AFxoR03s3dkASovcTZRf2aR5DoTW564EISt0VicS
	CGgG8UrmQOolYSxB+iZJeJFIFhn0sqw7ddqVlV70t3HdSQsLe4tirPBPafuRcPBvZcHbhc6/4VG
	wBEm8En2MU3d1dJsrZOlraOpinQZFtNG9Nujh7CVW61W6paU1Xe80qGsk2WfBR4xsBV+Z3IzzM9
	i2Z6J0R+PE/DEge7icZkb8c9CzATunyF9c8gb3wYywN3CbaohPQMI6us/brj5PMoQNyCZax9OXK
	2Dx5r/QsZH1sivxPXEktlYbPv5I3IANTbcW1C0gNNSV7spAAomGV+DIxPBPNr3K4ffK5/0Sf5Ap
	0t435PtNbeiH0aEA==
X-Received: by 2002:a17:902:d588:b0:2d7:1e07:4859 with SMTP id d9443c01a7336-2d74dbe40e6mr528217915ad.2.1788252983165;
        Tue, 01 Sep 2026 01:56:23 -0700 (PDT)
X-Received: by 2002:a17:902:d588:b0:2d7:1e07:4859 with SMTP id d9443c01a7336-2d74dbe40e6mr528217215ad.2.1788252982493;
        Tue, 01 Sep 2026 01:56:22 -0700 (PDT)
Received: from hu-aisr-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32b5bef7683sm22490776eec.12.2026.09.01.01.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 01:56:22 -0700 (PDT)
From: Aishwarya R <aishwarya.r@oss.qualcomm.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Aishwarya R <aishwarya.r@oss.qualcomm.com>
Subject: [PATCH ath-next 0/2] wifi: ath12k: remove duplicated STA state from link peers
Date: Tue,  1 Sep 2026 14:26:14 +0530
Message-Id: <20260901085616.2959268-1-aishwarya.r@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA3OSBTYWx0ZWRfX/t3sFsQCL2o+
 np9SmP7VFyR4Z7LanV2uk23iqEaNesCqcp8/ZcdDMvboeFVHEgUjlIm74oyViOSarEFaqIwU9Ua
 C9vzPQ3/cszqIP4NV4UbUfvRoUhA8uQ=
X-Authority-Analysis: v=2.4 cv=R9wz39RX c=1 sm=1 tr=0 ts=6a969338 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=UqWUxUh_XSH1bq3hZJ4A:9
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: TI1Vsjg2gZgM2o5pPHXf6nBhC3u4dKAo
X-Proofpoint-ORIG-GUID: TI1Vsjg2gZgM2o5pPHXf6nBhC3u4dKAo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA3OSBTYWx0ZWRfX5wTgjMJFr42l
 roHRM84sP6i9ccPEI5aQLYV28JygK8SnBqJuuEP/9PT66QcpDSH4lxAVV/HOnmwgoT1RxPG1q/G
 b6+Td0wBzRcokL5RFcOdnDG/E61CJVt57mfcydbOaC3ZzJ47WIhuqzqlj7DWm6I6Jff/8NWlzVK
 O//ChgHhBJAUJkter7CGYjaHDdxXiPaDTCDySTRtXNUqmDXSFeFI0+FEhGEak/ezHjaMv0XgoSS
 GXHerxWQNjS96IPJphkDosYsUaxjBS7n6YosO2jLLAqXNBc16UhorUFaeGBZN02vABk6wZ8Xe97
 Sp8MH1J11jFaI+U1R+ce3tdplqeYCdeQGBU8CUOU74x+cMDOzpbaaJKP9wN+H+B6wF/BZz75nQu
 7U1a08PRI4ZgzJuFKZg9Ty2C1fZxt0PjnngN/Tz9FLPVeTa3WTVXac1MxMFQoK9yyO9LJ0sp2UJ
 FtW7rL3iFiG54q0bToA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_02,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609010079

ath12k_dp_link_peer currently carries state that is not inherently
link-specific. Both the station pointer and authorization state are
shared across the links belonging to the same logical peer or station,
yet are stored separately in each link peer.

This series moves ownership of these fields to structures matching their
actual scope:

  * Store the station pointer only in ath12k_dp_peer.
  * Store authorization state only in ath12k_sta.

Doing so eliminates duplicated state, reduces bookkeeping required when
the state changes, and makes the ownership model clearer.

Patch 1 removes the duplicate sta pointer from ath12k_dp_link_peer and
updates users to retrieve it through ath12k_dp_peer.

Patch 2 moves is_authorized from ath12k_dp_link_peer to ath12k_sta and
updates authorization handling accordingly.

Aishwarya R (2):
  wifi: ath12k: store station pointer only in dp_peer
  wifi: ath12k: move is_authorized flag to ath12k_sta

 drivers/net/wireless/ath/ath12k/core.h        |  2 +
 drivers/net/wireless/ath/ath12k/dp_htt.c      |  2 +-
 drivers/net/wireless/ath/ath12k/dp_peer.c     | 29 ------------
 drivers/net/wireless/ath/ath12k/dp_peer.h     | 17 +++++--
 drivers/net/wireless/ath/ath12k/dp_rx.c       |  2 +-
 drivers/net/wireless/ath/ath12k/mac.c         | 47 ++++---------------
 drivers/net/wireless/ath/ath12k/peer.c        |  2 -
 .../net/wireless/ath/ath12k/wifi7/dp_mon.c    |  2 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 15 +++---
 drivers/net/wireless/ath/ath12k/wmi.c         |  2 +-
 10 files changed, 36 insertions(+), 84 deletions(-)

base-commit: e07447e654476262558bee570f4cf456e2b32565
-- 
2.34.1

