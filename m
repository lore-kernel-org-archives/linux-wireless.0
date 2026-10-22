Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792691420;
	b=O7yUsx0oPYTZY3fHIS26r/AQ+vCERuqQyNeOf83cuyDQE/bGP7/45rVLFsg24ZLhfiny
	 hN+t3vgO2Cs2nBa2zXaCZgezaReiH6mGvZ5QTbfESicCQzm0sSIQcTZgAUJbEzdMAg/zI
	 rziLNsCfOOOx/jmQ9GfK7aAAf5JFSwQQaRZaKi2wGMrpcVLkiOEhRo+uWohazL1dyMJFm
	 7UAGKd+FmktEuCOwFAWVZ6idUZ6nBanFPCXKAwau6Xsv8BjhrOvI09dyVh8aNizKsyH0R
	 pcBO9pii/STvngt56YIqXrIUTwiXGUiyIvW8ZKodzP7+3B/LZshpLtB9XsKSFJ48kMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792691420;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:To:Cc:Subject:Content-Language:From:Content-Type:
	 Content-Transfer-Encoding:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=gugNWHoGVfRUDNY8Vu+7grh/eYK/jhHtdCQenYRhq5A=;
	b=FeI0R4xqBmI74IdhDH8Ms+FNzKQ7WvXLlzEs4uHI0c3G70u3MTLw7X4Wf9u/hpeasNLa
	 75TsMWgDhVXhKuqmgv7cVYV3P9DGfZuIlkENbpn9BVhBPN4kNq2WtLx9cUiHKiFbN9Pxx
	 /G94P/nKRRgE7iNMHuzQEr+5eaJVUvSDkExyq8V0wKDkDlG4zDHnb0YPt2yv86Uh9pGTU
	 9yjHVwBYLPzBaeejtbYnXYgAExmuHbTTx1HkF2UGR/ccuiziID6gmF4kp7jOZD0pktwUJ
	 NjSk016kCOcK5L43KjjrCkCwSJtiIZ/cstM/gn1Dz01pz90pM+V72e5OuB0gnx98T1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jBxbkPjm;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=fbTw8yRE;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD02606A319
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 17:50:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5AD02606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jBxbkPjm;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=fbTw8yRE
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69MEFwtq3555210
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 17:50:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=gugNWHoGVfRUDNY8Vu+7gr
	h/eYK/jhHtdCQenYRhq5A=; b=jBxbkPjmSWBgZFfe9z5p4TTSrX7oxGJ8YxEtpx
	U3+FwdYuMh/PmrSH9Plo6+C+IUDdbJJTIeHlCcxc+U+XSk86ggHymLs5oKbyModJ
	yMikKvui/bkVVD9NNBWiozG7Hjn3yXPiUCUXIR3/HdUe7Ne+P2MvB43+79+UaFDL
	FA8CT1g5GPy/ofhuM3J23uY1k8tBVnB6TO3eAuPh/RQcV0JDPkAtXKgHAJhazYg4
	EEO0AD6Wtjt0g2db3ePVHiVY+GT+PwplxrTwZuGWUozikth5H142Av1KGPgf7mW2
	6vzqwj1dq7SJSwdcGG2fo8+LQt6M/ul0Y45UQZNie8dKyVSw==
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf93acua0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 17:50:19 +0000 (GMT)
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-151ba226e1bso31112c88.0
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 10:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792691419; x=1793296219; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gugNWHoGVfRUDNY8Vu+7grh/eYK/jhHtdCQenYRhq5A=;
        b=fbTw8yREyZOpDS7FQ9lHkoKyb1y1ySHWH+BVf7HIwHZuAh2ReGod3kH9jvEHjep+8D
         aMIk9dyQJMwPFzm0WlG0rVzcgGWZRAWnPWO4DQiQP+MqliW2l7a3NITtB2DsA6SU5Oaq
         3jdp6Wh8FHpRHfi57YWTgLrw2JdhIUGzxwfJPYv5EE2KqOA65F38Z9ENqktnzzVMlCin
         XjmB43sZza/ibXi8adqgsKKdHiNrD8WxlyfORnJB87U9w70J4GPYCRWFG44SQ0MjD6hB
         DCb0vd7YScwbbCo3mVQmnOUKliVNNRDIvMHWTAJddhY2JFzyJvIX4432H6LbLYuT96Pl
         mSjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792691419; x=1793296219;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gugNWHoGVfRUDNY8Vu+7grh/eYK/jhHtdCQenYRhq5A=;
        b=L1ZeaMwGbjsOJAdA+iyiqxByVZV4ZKCaTvNqQMqRkiF7ZvGg1Q7vNypL5IbtmZCjrq
         m3FF9bqwtfmeNedpBCL6D8EqbWiKeX6KivYh9BEMggaZKtiCbhLkwPAts75Hl+dVtcbK
         bIcBEqhsjwtebSIOyThpdQIvaxJN38GMwIH2SoScMSv9zTeORvA02NKBIE/HO+OWo8ZA
         sPvAckdnsxnP7slL9JX596YAJ8Pvi3fFhzV1Z3A444z74OIsnXhCiWSTW33q6hqOgwJF
         HTOmIzHhntXzRZH3dVpqw15Yo/4kqCZ6Ddd0zcb9NezNRRlgQl0N8pD+ZOBbA0sCvxdQ
         vMHQ==
X-Gm-Message-State: AFq9FYJ0lZmwvCjsywjQfLuzuHIwZkdPVIkDe3JwSBg7yg7jwktSgPXx
	lP5v7CDxzXk0KHtABaJ5dgf2d0cW3EpL0M01P4DkkVGt1ww+0LtOaP+LpRShavgiok/wQre/yWK
	zxS1N1CFerysxzaWFIplkjCn1DICC/0ivA3NyTJxSkx1KBeGFEl7YYbp/d9qQBbUzgpGGww==
X-Gm-Gg: AYBFou1LF1Be/oICEPp40YeXIIk7h+8g91/Iho87O2v00PN9G1SXobVjqnWa00UxqCC
	kZd8SH+bO1lbJDUo/7OjhwWBGIn1CUt1XkKvaQeVWr3rqLjUV8h5XapXxBYZVf19tk7YBROtNyO
	1pejqvbU0VCf0El4YdRAGq6b3dwsw/+dzhyKxlTz90KXn4CY9py82e0Z/DeMv9crfuqiARQWz6l
	NryHSFTBEmupTCEQTBqfKEaDWK40vKkJk+wPMDD2jsU465U22rVBkcqZBjL8rQspjdaB+da4zt8
	r/FGqE2z4Oa4TFFPCohg3UN+UBp5EeTyEM5/q0QqJxVBF5NV/EwwRLYkN3MMw7huBPXyQW00B2p
	RiuzVx9uPtqFVlzK3+RbbySEyBtlPlC2IajkV
X-Received: by 2002:a05:7022:2507:b0:151:ece6:b16b with SMTP id a92af1059eb24-190a4c1fa2emr9771922c88.7.1792691418466;
        Thu, 22 Oct 2026 10:50:18 -0700 (PDT)
X-Received: by 2002:a05:7022:2507:b0:151:ece6:b16b with SMTP id a92af1059eb24-190a4c1fa2emr9771872c88.7.1792691417718;
        Thu, 22 Oct 2026 10:50:17 -0700 (PDT)
Received: from [10.81.91.45] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-195a7f440e4sm140975c88.7.2026.10.22.10.50.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 10:50:17 -0700 (PDT)
Message-ID: <b1845835-415b-4c20-91c0-fdb23de1e1cb@oss.qualcomm.com>
Date: Thu, 22 Oct 2026 10:50:15 -0700
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
Subject: [PULL linux-firmware] ath10k, ath11k and ath12k firmware ath-20261022
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=JudkP84C c=1 sm=1 tr=0 ts=6ada4cdb cx=c_pps
 a=bS7HVuBVfinNPG3f6cIo3Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=wC-Lp9yRyfpcNyighFwA:9 a=QEXdDO2ut3YA:10
 a=vBUdepa8ALXHeOFLBtFW:22
X-Proofpoint-ORIG-GUID: aEF5W-nkEVpB4ke7MvYZLjXMqljcoy22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDA3MSBTYWx0ZWRfXwtaORabMDo7I
 IjIwQRbFPonvdgb3GR36lvmhG2JOJg8PnqZ0YCDlbtAPCTs93VEUww/+9jR8hdL05DFRYGe9IRz
 9RLNpePrul1BrT5Fo3fqdthc2dulqFE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDA3MSBTYWx0ZWRfX3tzct6a2uO5f
 JVYtzRMm1iDAgOnILwd7FEiRLg4Sz9jq7GdTwRTGA/x8ALKJJkxOYObmOjBIl8kePcsezajlkzt
 oa70CcuEWIUcyxvq2kiKHJCaJRijbJ88W2uehNGOBdgJdl0taghpLlaFNzdW7U4LnJ8wVXmKhiL
 x8BjSMTfqpY3vUpE7fbAfx7ZHHVnuA3IM/+MVZvzuJL/9Uz/gRwv78hDwKRJdDgmA7XqV53/DWE
 Dc0hL52Ua74JneqFKTX3cxbPv26OcxCsZUH9sG+Zb8ypW0OEfEW2eUGCYVkyW3/Vr3qCNW7E2aN
 ObE8jxqQ2o/ZdjDWEyY+flM9CEWTRkWTNu5cjyfPOgXuXi2fH9uGKGICEFTGUpP0HnAkYbE9KCf
 kUvJX64xj30jvmuVScAMSqmwXitBe2OA3FCuJnrZR7XtrX5KNQCgvEkylz3tKfjn9rT5kna7HW7
 tExhj2Ch1D5GFc6e6aQ==
X-Proofpoint-GUID: aEF5W-nkEVpB4ke7MvYZLjXMqljcoy22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 malwarescore=0 impostorscore=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610220071

Hi,
Here's an updated pull request for ath10k, ath11k and ath12k firmware.
This supersedes the request for ath-20261021.

There are no changes for ath11k or ath12k.

For ath10k update WCN3990 shikra/wlanmdsp.mbn to WLAN.HL.3.3.7.c5-00226.

Please let me know if there are any problems.

Thanks,
/jeff

----------------------------------------------------------------

The following changes since commit 00b1df13f9d0adebcb90bd110a4a22de5115e077:

  Merge branch 'main' into 'main' (2026-10-22 09:39:18 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ath/linux-firmware.git ath-20261022

for you to fetch changes up to 72f3b81c89fbc52677b9dbbfa92cde0ae00a36e2:

  ath10k: WCN3990: hw1.0: update shikra/wlanmdsp.mbn to WLAN.HL.3.3.7.c5-00226 (2026-10-22 10:45:11 -0700)

----------------------------------------------------------------
Jeff Johnson (1):
      ath10k: WCN3990: hw1.0: update shikra/wlanmdsp.mbn to WLAN.HL.3.3.7.c5-00226

 WHENCE                                   |   2 +-
 ath10k/WCN3990/hw1.0/shikra/wlanmdsp.mbn | Bin 3811820 -> 3808072 bytes
 2 files changed, 1 insertion(+), 1 deletion(-)
