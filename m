Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792600222;
	b=V26cU+hBLSJx7pc0/YmCazzVMMOB9I4exssYW3IPueOViMl9UMv8pLWSY1ATJZWCvUnT
	 kf6oRbjxWicvCvPXBsn/dTQtWt8VxWE7hwJCGQLuX6D10b+mvedIpPMrYoCMJCFjk0Lqh
	 YKLOz2tCpY/Q0oLGT1bqRe11Gb8ar89DihccDHKRH26jGBDQXlqPtQy9WCTtzj4wqfbo4
	 7ywtm9VcK4b7L2xcYuW16GZdQlFYNvzotB4fB704mLtfuTMouJRTZEM8ZiNidprzGKwiF
	 84CaVqHi5cjbHB6xnvECs68gO7RYTydEr4EQCAlpcfC9mGjopL6DAF9430S+jNTngpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792600222;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:To:Cc:Subject:Content-Language:From:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=tlGZKGlDFlSxsOTfMCF1bMEShPw4Brtj/kvvPvd5sbU=;
	b=WOU7Yroe+pMT6LhWOLdvjLOTfdBaAZ6lJQCpLw/izHuH5sGkiYDZzfnBkWK4L9Tm9rkj
	 7/lzNSrgc3iY0Z9oGNx3jKmk3k3/gamycWKqAWYOfq2siYttdb9tlQaTr1IgZLxMF6via
	 8kflR2o9WPAPVa3xDoW9ppalYhh6ISvgyc6V/xgPpNboaSM9pot5yQdhcWQJfyLPvX2qD
	 AayJTkeHX8/jzBXI1GfXxMTXWVNYCG0RtOYztJNXXaVCeB7u0AKCUF2iNgwzjPMTgVeKy
	 /Ee684VhGOM4En0PI4S/OUUEJqKeMlHJe2Swa/Ix5AD7mLqW6z9ooG/6ayXGby25oXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=k9kKQk30;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=bDu0rbls;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC899606A31E
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 16:30:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC899606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=k9kKQk30;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=bDu0rbls
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LG3kbH900795
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 16:30:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=tlGZKGlDFlSxsOTfMCF1bM
	EShPw4Brtj/kvvPvd5sbU=; b=k9kKQk30PUdLl8ArJ8roU9rVGZsUL1RO7QsJ6g
	ibh9aMHMuoBPsgbxArYJ27WZ9Lqa7wCmj5wPMERpZGXfdC6IUW/NWKFO17jieEz5
	sI0n6UQfSz9gN0jsOwLkNk8za2ylYUkFD3CCu8grAojXmaAmK3TgUZ1/QUZNLoOL
	vP6euYLIeP+f3mNiN4oDMxJiEvkOgq49Uz1jQ86ScJLBXifSDnpJZXJ7ZvlpXLFD
	3KDt6Hw8Ckg+rOpOn6KqBV8+Rnbr7K2rws0Ga73hVFuRiboaMVf0UNgySz/LUf0h
	YFb4WvFf6KFfLhEOnKTbiKb9+Pi/O2aiJEa9Tp2Vc6KJVnkw==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf0k2g4rv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 16:30:20 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cd0b795aa8cso16309a12.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792600220; x=1793205020; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=tlGZKGlDFlSxsOTfMCF1bMEShPw4Brtj/kvvPvd5sbU=;
        b=bDu0rblsvP8LM4qiNCntZg9K1fYPeIu81VGBe8DHPnDMybsJEI4MzK8DCXr+M5OsL7
         AqTWRMGVPjQjM6ThweDNrKZJh6Tl5AQ4IXnwIifU64cjJhR4ohcbav93CZR/3hSO9vDM
         ZEliJG4kzs0zT00KvWMYu7jb9yFyRrGs5aubh+dg04iFM0W3G7dTGO0C5KyiagfkDfr8
         0xtiWUNhP1WRqYX/076fLLYoLmFeY8JdTRyIfmjVSzLwZIgbYdNdUTYNlWoKgwXPIACu
         hVvq4spShopCVEy+osKzGpl9htLhWnGvHECnFdwk6Zyk1T0qlUgU3VxgfqcTXq1CkUGP
         waFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792600220; x=1793205020;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tlGZKGlDFlSxsOTfMCF1bMEShPw4Brtj/kvvPvd5sbU=;
        b=ZJjtoyQs+9yQBEfh8xdYaEMw+nUVt8wiCZ7kmgyA1gSEXFr1wHF4NIQ092NZnAx3U6
         zi70FM7J/4L/Z4/prsfzpfTGJTSEvPnOtQOYccjkBVoMu1F5B8q13ZXcMXoACs+AR0Xn
         wFYzdZioJdg63oCt+V9z0DI5aF/SVDhQ9slTHGNFLnGSE71Sq2qMkj4rVTCFYFwlzGxb
         naTlXb1cMb8aFpsWTdnqNSmMS6JERZ8wqJrKur+R6dYxE6UllXliqmFbLwNC1jmtX2Jp
         eY+i48c5dvVXj535wfI6KlxDKjWQ7W2fbPFH8qapO/QlsoyF1Zlv3TVlZr4Jp4thQL5v
         WhCg==
X-Gm-Message-State: AFq9FYKWTNbPSit9d73/HnFX2N4ZbzsNuV8DcPCKRwyZQqo/UdFeLZki
	7RnaVCuCLU7rg0+T1SN7iPXOr+o0n6MQ6OnYfou0DlLFKxtMFDhaHjH9G7dvu50URbRXDHdv40N
	NjaOFCHB9leZv0vWJlc8y8an68t1Aa2Yt/PJEqweMjKNiamH4obdPmW7wSYKCCNErdTNpN1Rl5w
	Efqw==
X-Gm-Gg: AYBFou1AYg7AcPM8GDHqRko3fQnOC5blKj3nMAs3abcqAc0yUJfhJBHJsoh4NeA9NL1
	HW926VGQ0cW164m/MhgSuLnyRXK8RYRO2Hi1EOUR+0JbX8XMgDzyBkcjd5X6PHwX9KvIAUqwni2
	RH18XhOESuXIcBQ7QgiU3YjK/F0uSoCQcSUzW5n10U9fDGA7lHs9DaKDW2pXoX+MrLMshQL+Zxh
	iJ2t3PKCYhBUV3EGSJvJ1N1HkVl0pDlDKxuoQmT9YuyMGNzIsuVOA3PzZ1A44R03b4h2uLaoMwC
	kv0POs1I6LE0DrfDWrX+mwvY5U4RZQExfearcGIg54nn5Va2sPODbLBOaeyqaG26v4Yel2Dzx2V
	020lswq30FDsoPdnMlPLSfXNnWX9KxcURJmZ0
X-Received: by 2002:a17:90b:3d90:b0:3a0:d7f2:5a58 with SMTP id 98e67ed59e1d1-3ad86da5631mr1499984a91.3.1792600219431;
        Wed, 21 Oct 2026 09:30:19 -0700 (PDT)
X-Received: by 2002:a17:90b:3d90:b0:3a0:d7f2:5a58 with SMTP id 98e67ed59e1d1-3ad86da5631mr1499969a91.3.1792600218678;
        Wed, 21 Oct 2026 09:30:18 -0700 (PDT)
Received: from [10.81.91.45] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada4954979sm157338a91.17.2026.10.21.09.30.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 09:30:17 -0700 (PDT)
Message-ID: <51c9bb4a-e86f-47b3-96a0-38288b460bcb@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 09:30:17 -0700
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        jjohnson@kernel.org
Subject: [PULL linux-firmware] ath10k, ath11k and ath12k firmware ath-20261021
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA2NSBTYWx0ZWRfXxDePud8mwm59
 2PG3VQutfb8804ecVENwqfOK+8HkgJvCnuNSLb4nDDLnlg2eqpDqB8pcZzjURQjTpidXCZJJa47
 QmgmelDoG6YmJxe4gNAAbVlxXAs7s0E=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA2NSBTYWx0ZWRfX+7jNtCUAeajb
 dtpmOlOBafLY39Pg7ZJEjJzdDraypAEImmyWH3ldydK9YIlCtWBPBjbnM110ojuW32GH2pykAcp
 QA3CQkaxJoCPDoBJbCiTj2N/SyuU6wPSOK/FjSPRevi/73WBGG0tlyo9XZ3s8bF854UzBzSCe6b
 5bRFTJqlYn8WwTruiUIlZLrwGzPTBhMKA97UR3+Tdykx7gM1Ex4R11mU1KcL5Bx4dVY8aMXDcH+
 mPr3kj0Smfnzb6d3wFlfuL8hZbgBZmaSrUnHFiPDs3Ao0FY7vzfzmnNSGFxha92wlGMkS+3VwMq
 4aanYMdm/v+oq7RPYTrYpHkw+ViEi3/yDaCzcHQxil+BFuIERSa/H30t4S0JEOKwIFPtSWLvHrQ
 KPuYtfK03YtgGdqiAUz4IOYaOMjx4P3IsLxYL+4Don1W4vUv8FLZnMfR66G7HsLDDjIMvkD11ax
 T9t8QboJ6CSiIpzC83A==
X-Proofpoint-ORIG-GUID: PJcwgppJ-alBoo7HrPnoBHebCATUyv71
X-Proofpoint-GUID: PJcwgppJ-alBoo7HrPnoBHebCATUyv71
X-Authority-Analysis: v=2.4 cv=K/+3jCWI c=1 sm=1 tr=0 ts=6ad8e89c cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=rlMSw0Raz3rYzQdK8EQA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610210065

Hi,
Here's a new pull request for ath10k, ath11k and ath12k firmware.

There are no changes for ath11k or ath12k.

For ath10k update WCN3990 shikra/wlanmdsp.mbn to WLAN.HL.3.3.7.c5-00226.

Please let me know if there are any problems.

Thanks,
/jeff

----------------------------------------------------------------

The following changes since commit 59f9fc2ef8d1e312d2a613d4e1ffad2ff31a0a01:

  Merge branch 'qcom-fw-version-qca-path' into 'main' (2026-10-21 14:46:20 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ath/linux-firmware.git ath-20261021

for you to fetch changes up to 0c5fbfd280e21e243f5956a0823cdf958839ebe3:

  ath10k: WCN3990: hw1.0: update shikra/wlanmdsp.mbn to WLAN.HL.3.3.7.c5-00226 (2026-10-21 09:16:32 -0700)

----------------------------------------------------------------
Jeff Johnson (1):
      ath10k: WCN3990: hw1.0: update shikra/wlanmdsp.mbn to WLAN.HL.3.3.7.c5-00226

 WHENCE                                   |   2 +-
 ath10k/WCN3990/hw1.0/shikra/wlanmdsp.mbn | Bin 3811820 -> 3808072 bytes
 2 files changed, 1 insertion(+), 1 deletion(-)
