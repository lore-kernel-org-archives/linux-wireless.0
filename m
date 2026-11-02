Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793601530;
	b=05gAfLcb477GZ3cpoW6YhG2WL8/j6exDr2AbZkiukf/tANokUu9hMeUURK1JeuR6ZGfS
	 NRLR7twUHQjacuEE5mfaT4D4XkPYelo4ix/vl+tOXNuyKYv0j5+YEDzXgTrx9DP2Z/ulw
	 YAfstdEoRlAkbL3yG+rjiF7H9Hc+Grfe3T3E/G3hnIYHEsdj+UWmsNl91Kqm73ckgum3R
	 /eHKJtkSD+qn3XeWTZ7tTTQm1+cg1W2PU/sI7gB5rX+DwRrUYlveQb/cqbv3/J08x8b7h
	 xGAlYvwZK4RaTwt+4rS1v4DnKAw2hc+AqXE9YLbzfCxP1r7l60GM6EEwJTPhVydN3Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793601530;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=MiL1WhFr3Ulb8v7dpJjuraCoLDtcPlOsberrX0tY8lY=;
	b=39E1rgYJuYIOJLnWrffO4dhG4iQnpZUBOKa0MpDd9hn/aox17FaBKs9Chgns3faOZ+26
	 zYPddRLv86FkwIgOLhD+FShYKy96FQ2XcjsIPHl94lVCuABDIxnxJEyKQ68+C5/dIxhDs
	 C32qgdLhcx6goMg99huP25HnvX///vzRGZpVR+KmAhBYP1OsszbWBKKpOZlRCU9X9iOK3
	 owt1uOBMkC1qBIPRYxTc7FBaPEXKP3WgXMBN0FuhsBGeNwkPNvEED+DgBpmHhFWC8HnHz
	 +sRr83tFTAfDe/LikbsvEVnDbjClH8tWpDoGuMUwSqmETO6+SyIGK+Ob00FOm3j5Hpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=UIu2Cu9w;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=TnEMI21g;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E716A606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 06:38:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E716A606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=UIu2Cu9w;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=TnEMI21g
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A23vI973324645
	for <linux-wireless@vger.kernel.org>; Mon, 2 Nov 2026 06:38:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=MiL1WhFr3Ulb8v7dpJjura
	CoLDtcPlOsberrX0tY8lY=; b=UIu2Cu9wI4E9ymRcqhqdzXslzn56htlgS+xV6p
	fOSaDgTtqvNB64yGLAGYFg41KKrSombpsbJK5WdlSlNpirpq9hQwkmtn7Fg44x2a
	Qe3P5+0BDEK394z6fiW3abmVH7bqYpLaToZ000lZCiNbNcXzXRuRQZXV/ig8yEnz
	od489dQZ8qnsrwnvAEiiFaPQ3PGIGwhGQGfuFRyyDtmunebiu1c7ExJ5O1EZnx82
	sHkJ3hO+g11kzNLN9ybTMkTkEjtZVYdHeAFs3yzQtz65gJ1h2qSNggok+Q8DICJY
	MuEZ6EWRdf4Pr/FA2RQdxE3JwK/yGUn5c75FpJwD1KQxJ7Cg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hn7b6nmsh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 06:38:48 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3abb4c24125so2208580a91.3
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 22:38:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793601528; x=1794206328; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=MiL1WhFr3Ulb8v7dpJjuraCoLDtcPlOsberrX0tY8lY=;
        b=TnEMI21geMhsLoCYAzVJJmEHM/5us9+Zjlewgn0B0bSS5wnTWH9j0B6nFgcKuxSTIT
         zE1M4oJciJPqsymChmdXWcT3AkpMCS2En6Y4rtp3IYinNUdSGV3w1yAtNTf1K68+bxrg
         l2qFf0muKMEgPJKpQ8QvuQKUBgJtlwYNFa83K3PK6/VCy8qKtzIsukiXWt0Nw0psR8vb
         rZZtiq9JmbHOj+8Q31cJBa4zq8LNTvMDKp4QBW6XjPpWtlRWkw0rmQS9tumjWa+UQxW0
         1a/sAZJYikGyk+JBlViURGjjFUORMTmOwkV85kNwVe21WyEu58sk5Kmu6juE0u+izq1t
         TulQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793601528; x=1794206328;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MiL1WhFr3Ulb8v7dpJjuraCoLDtcPlOsberrX0tY8lY=;
        b=fQwrFbk7LgCFoYTxcKdXOk7bCowBLzJy69+c5/KbdCuPwYVOxRist1MUvJr1C8fJXJ
         nhTJOUelNi71vmWw84XN/uTsXJ71FtHqfdBL4q23ZFjMMkBBYNs9Gea9KjmCNnfcxxpi
         hRJ+tR3eqcZhbL3KIQSJdqlV6m3muKevq0crGUO2VUUQCp51VrjQeONOzRT/SUFjnMDA
         FA0q+EMR+VoFruN9kfEuac0O2MztmEbY56I90PD+6rhBIa9Nqhe2NOFNUIhLlsBmn4ma
         OgitWWNf5PQdv0EdX8UxmLK4ywz86RPMvkDyfWcDXVuswecWoM1AZvM0OA/nlWBoXLzx
         4ziw==
X-Gm-Message-State: APuU4Z+4qZrJQWa7R+RXsvLgZpX2hAQDq1XrZvxhVbGCXl9ytD428PTM
	PZlc/jn82H7KdNcrrJNIzlcfF5Mrr3FVWcUKJPXyfLeJlUjH5eA9BTgEpy4M9tpCOGTX/DBczym
	KwUB9jcrtXTRiZOPxePWMWKinZVhqirHmzjUlG3hCeV6u8QgXgowv+QECS+6g8ciC+MFD04Iryv
	GJ3hCN
X-Gm-Gg: AYBFou3VKOgcxCLTqU7AIn2HmkQv0ICRChijcRDGWTv8SM9P4wVxJM/5I4AFoElmOIs
	Ph/VaINhzevnfjeT3x5ydPe0hBTHYZvBOtTtUyEGFtGufo35+cgVY64QSI6yhTs0NxEMxdP3vnw
	llXJ+3+SUUtpelGA4OmR0a9nluxp9zCwoFcyy49dggcVmlkttBspmuJpo5UyitRmr4DhR3sNCHb
	TCMSho0sZbYRhcWB7JBJzCrjwUyqumevJl1h6HSVOusu8NLPt9U3LqfRQ2p1Otk0QdmHvvOpRgI
	yfBF++OgM3s80rAEJwHHTM14bmgQo3prUZnCj+1ADttDUfOX3ZTOM0i+0GVr0kV8z+rqeAfW4SL
	OzLxq+YQGgDwfbFWUlZTV2BMaxCYtC8pSojjm+Vxis7LKh21gDign+UWmDLehrwkegPHtiWGmsv
	U7r5gkBlxdKAS9lvxkx0E7/dPbSS9Z
X-Received: by 2002:a17:90b:5645:b0:3ad:53e2:78c1 with SMTP id 98e67ed59e1d1-3ae89776880mr7446929a91.10.1793601527575;
        Sun, 01 Nov 2026 22:38:47 -0800 (PST)
X-Received: by 2002:a17:90b:5645:b0:3ad:53e2:78c1 with SMTP id 98e67ed59e1d1-3ae89776880mr7446915a91.10.1793601526913;
        Sun, 01 Nov 2026 22:38:46 -0800 (PST)
Received: from [127.0.1.1] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e949077sm17313475a91.9.2026.11.01.22.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:38:46 -0800 (PST)
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Subject: [PATCH ath-next v4 00/11] wifi: ath12k: resolve RX link id via
 logical link id on WCN7850/QCC2072
Date: Mon, 02 Nov 2026 14:38:09 +0800
Message-Id: <20261102-ath12k-logical-link-id-v4-0-f4c7807c299b@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANIv6GoC/3XNwW7DIAwG4FepOJcKm4zATnuPaQcgToOahi1kU
 acq7z6LQ3tpLpZ+2f/nuyg0Jyri/XAXM62ppDxxaI4HEQc/nUmmjrNAhUa1aKVfBsCLHPM5RT/
 KMU0XPpGeemwsWEQKgsvfM/XpVuFPwR050W0RX7wZUlny/Fc/rlD3FbfQ7OErSCV9CO6tNwSdb
 j9yKaefXz/GfL2eeFR5xafmFOxqyBpFTa4F7SHGHU0/NFDK7WqatWgMqWBtZ4J7oW3b9g/xQwF
 TaQEAAA==
X-Change-ID: 20260728-ath12k-logical-link-id-aef2481822eb
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: sXFqLVn4JGhc_r3lTonfZ0KYT9d2uVGm
X-Authority-Analysis: v=2.4 cv=QuvLTlyd c=1 sm=1 tr=0 ts=6ae82ff8 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=AaJ870xVPVGd3DHDvMsA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: sXFqLVn4JGhc_r3lTonfZ0KYT9d2uVGm
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDAyNiBTYWx0ZWRfXzT6D5wIRdB+U
 9wmB7T+b2CI/vY/Zh0dakZeZ2mXkShL8vedlvVpyJwIAIKqZ+hDJ4TO46dREtZc5+pnRTboP1/S
 5fGCS7mSBXJcTuz6F0AAoGGYD/yGPP0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDAyNiBTYWx0ZWRfXyaF0RlC4w8Cv
 Rm3/Txc5eqtbgZbLwO3UHLZWbRK/hsYle8xdmhlCTI0xqhsk5YddTFA2Olu1gVXTakRt4GXlQYp
 XGDqTrvyR7k+CL0y3jlNCl63nmYwyNyqsIbbvcyFUoaMCaWkxTrieZ483uXudXrsVYoX3WW7SLc
 FL0ZIrmovVi2JzIeLI4pyVM7IfuJC3ncuUOku5/tTNTMXcr87eOU/Lh1VusHyO44jKiR8HmNvRV
 6s8i8hiTVLf483x0nXbzplr9yxkVje9ka0kxKtTWTh9BTn1Qe1wea7CjNzY9kLhF7kW9XJu5ZAW
 jNhDvrH4yZKIOCZ7IHCJFZgqZ6d71xv5x7jXzlmcN4znQBZfGEG1QvBJ10MQFKv+P3X2g9wK+xo
 JbumCrgFjZUjscrxAnYG2cNF+IpUPO1z+xQAtze4wU5EX3jwLXCc1vz8CamQuUrYmaEEo6wytsJ
 Z6O09PpG87fxRWi4sKA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 malwarescore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020026

ath12k currently relies on hardware link id to resolve the link peer. This
works for QCN9274, IPQ5332 and IPQ5424 but breaks WCN7850/QCC2072 which use
logical link id instead. Commit a2fe9dc70f3b ("wifi: ath12k: Fix low MLO RX
throughput on WCN7850") tries to fix it using peer_id but actually that fix
doesn't work always. From user PoV, current code has datapath issues like
EAPOL frames getting dropped on QCC2072, and finally MLO connection failes.

Add support for logical link id based link peer resolution to fix it.

---
Baochen Qiang (11):
      wifi: ath12k: fix potential OOB access due to unverified hardware link id
      wifi: ath12k: skip hw link id match for devices without hw link id support
      wifi: ath12k: rename ath12k_dp_peer::hw_links to link_id_map
      wifi: ath12k: rename ath12k_dp_link_peer::hw_link_id to drv_link_id
      wifi: ath12k: rename ath12k_skb_rxcb::hw_link_id to drv_link_id
      wifi: ath12k: derive device id without drv_link_id for single device group
      wifi: ath12k: add support for HTT_T2H_MSG_TYPE_PEER_EXTENDED event
      wifi: ath12k: allocate logical link id on host when firmware does not report it
      wifi: ath12k: derive REO RX drv_link_id per device via HAL ops
      wifi: ath12k: derive WBM RX drv_link_id per device via HAL ops
      wifi: ath12k: use link_id_map to resolve RX link id for all devices

 drivers/net/wireless/ath/ath12k/core.c             |   1 +
 drivers/net/wireless/ath/ath12k/core.h             |   3 +-
 drivers/net/wireless/ath/ath12k/dp.c               |  18 +++
 drivers/net/wireless/ath/ath12k/dp.h               |   1 +
 drivers/net/wireless/ath/ath12k/dp_cmn.h           |   3 +
 drivers/net/wireless/ath/ath12k/dp_htt.c           |  17 +++
 drivers/net/wireless/ath/ath12k/dp_htt.h           |  15 ++
 drivers/net/wireless/ath/ath12k/dp_peer.c          | 169 +++++++++++++++++----
 drivers/net/wireless/ath/ath12k/dp_peer.h          |  26 +++-
 drivers/net/wireless/ath/ath12k/dp_rx.c            |   8 +-
 drivers/net/wireless/ath/ath12k/dp_rx.h            |  16 +-
 drivers/net/wireless/ath/ath12k/hal.h              |   6 +-
 drivers/net/wireless/ath/ath12k/hw.h               |  22 +--
 drivers/net/wireless/ath/ath12k/mac.c              |  53 ++++++-
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c      | 112 +++++++-------
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h      |   8 +-
 .../net/wireless/ath/ath12k/wifi7/hal_qcc2072.c    |   8 +-
 .../net/wireless/ath/ath12k/wifi7/hal_qcn9274.c    |  16 +-
 .../net/wireless/ath/ath12k/wifi7/hal_qcn9274.h    |   1 -
 .../net/wireless/ath/ath12k/wifi7/hal_wcn7850.c    |  17 ++-
 .../net/wireless/ath/ath12k/wifi7/hal_wcn7850.h    |   6 +-
 drivers/net/wireless/ath/ath12k/wifi7/hw.c         |  15 +-
 drivers/net/wireless/ath/ath12k/wmi.h              |   1 +
 23 files changed, 400 insertions(+), 142 deletions(-)
---
base-commit: 090ef659b1f31fe852e956b0ebf274cc7d967cb7
change-id: 20260728-ath12k-logical-link-id-aef2481822eb

Best regards,
-- 
Baochen Qiang <baochen.qiang@oss.qualcomm.com>

