Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0C33F4DDD
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 18:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785003111; cv=none; b=DJFtorT+ErQw9rKAhqmMULL16s0RJ9mPARtr063e415hFANdC6jwVpSu+a7PMcjf2HhKuaU32iTkTmA9u6po0vPd+4AC0z1Fn+85kDWPyzSLwyVKDtsNo3QDnBJdKPG0Rrn01h2YP+8NiAMyzPhjoMe2OaMoni4FNSbljeSL9qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785003111; c=relaxed/simple;
	bh=R5+AM8MsBV1hJRBd//ih/Emez4JeTWQv30n6Tlqgei4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=UWEG2F/6v+dYW0itBLu2fqYVPbt5GzELBHq4w7biRs6UkpH1wkmm+B0fi6HkbX9egIw60vDb68cr3dAY9rmu4XahpQp7U8grB+nufN55WvmJ9DBLh/7wppl1FKhnpR95vq5ABRqXPX2JtaTg7wgPtU3QyEi0/AZy5sOBCKIgLu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KQenNCQm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HaW8vzrJ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KQenNCQm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HaW8vzrJ"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66PGvgiB1975170
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 18:11:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=oViaTxTEJFf8D4uFBbYAXO
	cG09FPtk8+dz6gicLx8n0=; b=KQenNCQmmimFSxBZ+AiQ3hlXWavaJyKWSWl9fi
	0Q5TUIrwQHBJqYgOXRImgwSxbm6eC7phgCcRXkingMAghiM5yRifY4Yc/rH157TZ
	6sWBnzZmwymqRmRkeGjcF7+PQAxleiqrRgXeiB3TwRFZhY4IChN7TtwFmUYRI5w1
	u+e5GvvNa1WqOHn7yT4PNmRAyFapoqITAXt6CPecFfVJgSnaS1dl3H7AuIVd/ZmJ
	5np3d0fl8lStRq7U0C0MXbCnfdtFqBuFhDAki+U+pU2qyDHedQ9CeTjwAj98P0jy
	cE/3dl9jvKJ3zxsdi2y6iu7VJermEvScCYfWiYYf0e6gCJIg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmpajh8yf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 18:11:49 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-388b404eaa4so2055707a91.0
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 11:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785003109; x=1785607909; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=oViaTxTEJFf8D4uFBbYAXOcG09FPtk8+dz6gicLx8n0=;
        b=HaW8vzrJlrGEURn8pCQUGMFpddC9pYP0B91q6BZlZWscrvd2DXGhH5ujKBRJDzipGp
         ccSUpqWhbU5o4GHK8kepGoub36CtiDEQuqQvjRtGEBFx8HhCdAFlyIv0+x6TXf0HMv2H
         BWgRLkg5WPWhoJLfsk3zmZZmHm+m6YV8jNnagKYA+etcXpEhcsdbqCNUCuE0DUOOdyes
         ApTEyhdrRm8OP7hMrkQN6Tj7pPShtQPEZDkHmFsfKm+bkDEsPhepndGzPkm4L2l7pikS
         14MJ1Q5+qLzzhST5jthC9aSkHjDQOYIuJo4pZrOKgY+PWHGm6emh2/fiADz1l+40qUeC
         wgoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785003109; x=1785607909;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=oViaTxTEJFf8D4uFBbYAXOcG09FPtk8+dz6gicLx8n0=;
        b=Q7RylvmrpFw738PtKzWr5SYQpKeDl3PPQ4LIdzFpE4eclLgebzDugDkvwY8tarvIvo
         4wtRVIpxuTC0zGTDEi77ZlxzocsW3XRxLxGJ6LGUoiGnJ4KrCGRfCbzkuhQk4obt/kGh
         Ddi8biF4OITzRonqdL7vpvLqTqNjuBJdcbAdngzWX9E3SE82dbd45wtBLhRMCuRvNram
         bqVnVx9JwKlNSM6bEM/6x3UPuqg5NP93gCjtpz9oHDTksYExtW3kbrnIpeXm4jy2aJ/w
         N3dclaBcx8HqVxyDw9l68daa+7ctjzAK2L4g4z+bMcM83cEOHJaVmPhzNwePPNMPeMMU
         hIww==
X-Gm-Message-State: AOJu0YxIigPa9qiHEr2ArjzkKo5sr2SbNdcvujVcEUeu67bHNm/wMglO
	m15/1065LSPQ2W4ODnZz47QLrgt1zDnea+5/3M+TERA0hsjczmSO3T99QjD2abCBvNrq9doZQ/W
	CFMnXZ8Va5P8UxRVpJtSc7WN5VacmP9a5s4c9QqPc4YVI29xwMuaeLes9tjaJeS/f9rcvIA==
X-Gm-Gg: AR+sD12ZcpyDzfl3QmS/6jSL1Kkq0saFhxLpzPYqRNCgs6yzSXfjEZUY8AblF0a1B0k
	DGRzH6GM9ZRlXEXz/PdNay0G0mwo54EI8prspWTtthMko4164y/xjig5o+DirGAfKPHQPHnLQ3E
	UnAST+cYd12CnWl7ITRsFXkhd4Po/T2PrQOk2wVjXSOKfFLrDCU+HMQJuActSxZzn0wdzeaxjrW
	fBue0zplvV/QzSge8d6YCl33rBanlJNy4JBbsSJPIpj3Mp4sXTMwLeV5jX16Unhbl6CiBbEczO/
	NiMRiJFRk6vlgV96/Kgu3nXAFK3TQlwAfecQxTOAzvbNhxas9VCnsb+bvqsPosjXQLDqY4r4pul
	15+lexawtWvLgxLX3uWjOMMmOTicco8OZ3f0Anxwlbtfbp1IUsdRLja0=
X-Received: by 2002:a17:90b:3c8e:b0:37f:db06:229c with SMTP id 98e67ed59e1d1-38f2960fabbmr2985131a91.22.1785003109190;
        Sat, 25 Jul 2026 11:11:49 -0700 (PDT)
X-Received: by 2002:a17:90b:3c8e:b0:37f:db06:229c with SMTP id 98e67ed59e1d1-38f2960fabbmr2985120a91.22.1785003108789;
        Sat, 25 Jul 2026 11:11:48 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d13003f12sm64692635c88.2.2026.07.25.11.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2026 11:11:48 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH ath-next 0/2] wifi: ath12k: Cleanup ath12k_firmware_mode
 enumeration
Date: Sat, 25 Jul 2026 11:11:44 -0700
Message-Id: <20260725-consolidate-firmware_mode-v1-0-aedff0ce0ba5@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGD8ZGoC/42NUQrCMBBEryL7bUoSaUv98h5SZE22dqFJNIm1U
 np3Q0/gz8BjmDcrJIpMCc6HFSLNnDj4Aup4ADOif5BgWxi01I1sVStM8ClMbDGTGDi6D0a6uWB
 JdCejVT3Yu+4MlP0z0sDL7r4C5lF4WjL0pRk55RC/++ms9v4P/6yEFFg3iLW01pr2ElKqXm+cT
 HCuKgH9tm0/v11m1tMAAAA=
X-Change-ID: 20260717-consolidate-firmware_mode-93c215fdb29c
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: O4jaRMeKRwDVodOkAezjPDHmPSoRlP9-
X-Authority-Analysis: v=2.4 cv=A8Bc+aWG c=1 sm=1 tr=0 ts=6a64fc65 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=G7SgPBRoAAAA:8 a=UXYPoygNbYHkjK84YqUA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22 a=2rYB-OeQH5pmQqQB7sEg:22
X-Proofpoint-GUID: O4jaRMeKRwDVodOkAezjPDHmPSoRlP9-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI1MDE3MyBTYWx0ZWRfX8jbFG0fNuB6+
 FLCeXGbBjEgc6Fl1W73peouLYmWrlAo9qmXKNMBTIAVnzFNGHd6V9hWX9ujbX3rKfBRiyN9xp50
 vX/N++MKisrwFhkfa9ihznSGkiaryfqUdeKekxaH2NxuJfWNOrrWsN77i9ZrqHRJKGiGHtLWvya
 PeE7nMJHMH7meCSL/rc7vNAznL1voSkslek67lDO/uNkfQJzXnBFXmgUHHb8KUUwEW4kpnvKvAO
 yMgjOklLsekHm+Q7mUhfA0qiNO/vz3Kwude5KeFgZuX+2TvA5Q8EHR4nxD1tX9EQh8VDspIkkL+
 ZA7LSiAoghv9k1DXTUSHJ3y8qGnenwFL+cIocfkb+VVOQO3L3tHR54uEQNjvzPUcyQc01gP2MiF
 E0nohVipvfKrHYNWq/D8AWvow1hKYFzE0VBAf5MbChImivz64koFnn+tr5ENZbNfMwkdNTCQFcF
 wFXozgAvTwlHXlxvuJw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI1MDE3MyBTYWx0ZWRfX8PTvdLVrGoMl
 wDcYgDKospZCF/LhjA1Gund8xFmhzaLwAEhXeT71wjbvp6ZAR4VcuhgsvYZ1rcvyEKko+7Sve/+
 CE4fknkePrlt4hxX4hEk+R4tMKxlbZQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-25_05,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 adultscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607250173

This series inspired by [1] for ath11k, but takes a more comprehensive
approach.

[1] https://lore.kernel.org/all/TYZPR01MB55561DF4543A0265B47A58CDC9C92@TYZPR01MB5556.apcprd01.prod.exchangelabs.com/

---
Jeff Johnson (2):
      wifi: ath12k: move firmware_mode enum to qmi.h
      wifi: ath12k: rename firmware_mode enum members to use QMI namespace

 drivers/net/wireless/ath/ath12k/core.c |  5 +++--
 drivers/net/wireless/ath/ath12k/core.h | 10 +---------
 drivers/net/wireless/ath/ath12k/mac.c  |  2 +-
 drivers/net/wireless/ath/ath12k/pci.c  |  3 ++-
 drivers/net/wireless/ath/ath12k/qmi.c  |  8 ++++----
 drivers/net/wireless/ath/ath12k/qmi.h  | 14 ++++++++++++--
 6 files changed, 23 insertions(+), 19 deletions(-)
---
base-commit: 189721a4afa1804315e7dcfca9ca0539c7b1d7af
change-id: 20260717-consolidate-firmware_mode-93c215fdb29c

