Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793754649;
	b=cnk2q/W9YXK7YOM7kWB81mhFz5hJH+iFaQdqHPoRd9yk7xl37ruR+z54HkC8JGzRw1vr
	 xQcMFP6rw1ZBoqeVdZzFAhzBA6/qD8krNhuThr/vfoTHbJa2jF3a/I3+jskyRUBpomKNf
	 DzUfxZLoZDLvMtkmGOeT/Y7hGSiISaySExK7I/oN2T/u32duL6ugghq1OFCIVukc0sIY8
	 YZ9G16BoYFRdx85VIo6z7SfF+4tnSZZ5QghTMQZblHRKG6ELyrbI9SvK9lz3BCXhe8z3X
	 ihZDicOdwuhhsgKm9LgysESw9SGhPjqKzBl2SSSoRMTsazLoxVd2DqbhbsHx5rVqjvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793754649;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:
	 Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=Gz3p90Mwjj78yrY6+KCh5AMVvJlH+FYsm8LlGXSt+HQ=;
	b=P3GbifT/debGXeqffzz3nTsl9s/bTx8FF8d4LF8KALArew86zWQSx4nFQ0GyIp4Iewzm
	 1kfGP87qcuH/C6LxAh0+Vb55uNgmGSjDFJMZ58tZsZbiiNmSF9Qv7DCwsUt/8EtyJJhx8
	 uUpP4snnoME98sWQc/e7jqR0wfCzLoiNdsPc5gRMPzSYKFyRzzrX+niGN/46ybnqHMOWT
	 RoovHHNHnUM+6oxPlSGg/iobH+OpTPxyh2ezSxNrEIOMbig10aQzdvFPFZgA0q5sXHdmE
	 qoiuKqvXwh6Xl/BDtaPhPkROip99AIAXj1nyVoQxD5R3xbtAhMptr6FhB5OD7S9YYpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Ommyusu+;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="DZ/mkcfs";
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900C6606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 01:10:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 900C6606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Ommyusu+;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DZ/mkcfs
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40S6Un4071412
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 01:10:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=Gz3p90Mwjj78yrY6+KCh5A
	MVvJlH+FYsm8LlGXSt+HQ=; b=Ommyusu+wiTp5j+qkiyBYUq4/ImZOYRPss9mum
	5tO4Tx2M/7ahYNQ0MSphQ6fJQLpbvT9zC5xYSCcNYwTacbU7/VsXIAPDQzwKZmgL
	eKbCmRGWZUQJvba1NuuU946yZXw+Ja/3VU7Zz1AEelaqMLiXV5+woamJtbBiHLEj
	YexzEzh5ZCwG+5xOSCdOKfuOrlOwc5MijPJqnHCWLblZ70mLIdIwtwwypUS9gmYa
	b3kQHFUWI+RDzq5trr6883ilz4Cd8y5STRmmXqvPrOHu01yLAVkZYJEh6oJSy7gZ
	jPzo0As0we6LLCoEFDRenLlyXaxsEwEqzQ9WDkjyFBThGFpw==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqh2bjm4w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 01:10:47 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36cec75d8caso43169eec.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:10:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793754646; x=1794359446; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Gz3p90Mwjj78yrY6+KCh5AMVvJlH+FYsm8LlGXSt+HQ=;
        b=DZ/mkcfsLsbY9YMKgzVKbiKRdxC1E6W1OVdCdkl7c8qNVFSZt4IF58k2j+EzSf8pT4
         IrIHaoXB+j+2BSnLynYQ13j3E4Uvk355dwOgGhLPk6O3DbjBM/ux6Vw3wVxD/CNEAZw2
         wNyykdbkQrr98UjB320naudIh+F0ea3lmLFmPtWmBbAn3lz/GMiSk+drktsWJTywq+et
         us5i5p8s7tit2uiwCmBBAtqqfhHsWdrdefigjPFF6Qgwu6XcK9jJ+lexL1haG3vRCnhw
         SZ8v5qFNZOl/BQlWRZAkKMTlSAy5VPEim7TtrBcgfL4yH5OWhk55kUhkBT4xYj//WXuA
         d46g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793754646; x=1794359446;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Gz3p90Mwjj78yrY6+KCh5AMVvJlH+FYsm8LlGXSt+HQ=;
        b=OC0raMJILumTBfSbtHtH6A9Ry3Kj96PBsImygFzOTXdsCh344+iYgB9g11QdSrdvuq
         eectznyhMYDpE0Vk/5YU73BQeiNQW3mDbgoalwdmcvCKBsH3wTFsMST/VpwkFRG3xVlR
         j3f07yUHtOKhZEZMiIhz5soE3/UFd8k8CjbE6Lu+XK63y1awcA4uD1fqTTO7DBh+Njfo
         tnGCnQNiwsg15V0BYGX1+Q2ZyjJH96X/A16EiCHHeDBPOumS3V3FhUYnL3lcMg0+sdjo
         sLgsH5+zcEOTPDPkKHTWCc9Ia/bjd9DNnheC2vkcuSpeLxA/2pVXdvvZxkYJZAc5ekXd
         sXVg==
X-Forwarded-Encrypted: i=1; AKwUvBw5hpqYdGfsYraey4Pab5CguUhPLKFN5LGcd2lMZQuuYhlinmKDbE+geKKceeaUyniEG5OhDd9aPpbY7K6erQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z/rMDyEtCJTK/AKJQkdcKNcl7vp02VGEM1WBwRdqF9zrtJNJJWe
	WjXnONdcVlNIH+zrl0y4G8ynMUPFwuFym4aWDdRjqaQgiUP5En1+qaJPQfuJhZBfZlP5schXKAP
	UTBizJxg6OgKb9Sii4PHAMCcbgo5JWLlv+rBMgKjpb91WredeYIhpOc1JncbvJZ58VabBYg==
X-Gm-Gg: AYBFou0LhkwXNPtQicYVewBTXXCEoOZ9Dod4aFIdL5JxGHGTnFMYk31d30UGdaW3ZLi
	a6ERsAZ8HkrB3zM4vICujFlIvnvYPCqxEhXzXvNze89+i7/2Vw9hkb6wh8iMsy/x7hULBwPyq2/
	krF+IWFghDV5MICKC+f0EO/S03LfwRSJtyUt9NftxdCAUiCbcdDXq7AJmBtFbq28QQicG2Gt7ai
	pCwYF+Dq7usyD6wKIpyNmuyRHZMzoVNku42nY1fgJUU62cEbUU0ugAFHALEpNGMUqHqwgF98v8d
	ghhZ6FinN4hLEB6bspCHcpzOy9USERcKXuP2RIN/+GpvskyrRFBgBZu95x5WQx0t5SW41hdRb+N
	0+NFilAC8cYXO3lV8ZJRE5rJOtmsI63ZMiDEN3ofIz+GuEWCbNqBvOs/eBW1TY5P73oGjrjbUYE
	fUBq5ilDJafbFufeSglECp8KeyBMK8F6i/S6FB
X-Received: by 2002:a05:7301:2ab4:b0:36c:a26f:83c4 with SMTP id 5a478bee46e88-36ca26f863cmr1213453eec.13.1793754646262;
        Tue, 03 Nov 2026 17:10:46 -0800 (PST)
X-Received: by 2002:a05:7301:2ab4:b0:36c:a26f:83c4 with SMTP id 5a478bee46e88-36ca26f863cmr1213405eec.13.1793754645654;
        Tue, 03 Nov 2026 17:10:45 -0800 (PST)
Received: from ath12k-linux2.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38a54ccsm2288670eec.4.2026.11.03.17.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:10:45 -0800 (PST)
From: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
Subject: [PATCH ath-next v3 00/13] wifi: ath12k: ng: add Wi-Fi 8 REO
 command support
Date: Tue, 03 Nov 2026 17:10:43 -0800
Message-Id: <20261103-reo-cmd-b4-posting-v3-0-861adf04b516@oss.qualcomm.com>
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
X-B4-Tracking: v=1; b=H4sIABOG6moC/32RTW4bMQyFr2LMugokUr9e5R5BF6SGjCeoPc5ob
 KQIfPfK0yBAiyAbAQT1vvdIvg9NlknasN+9D4tcpzbNp17gj91QD3R6FjONvR7AQrQF0Cwym3o
 cDXtznts6nZ4NKUBC5wk5DF14XkSntw36NNB6MCd5W4effzvtwi9S1zvz4+8ir5fuu34IzrTWQ
 3fd73zJGWqNJaAldJFy1OgSW87Rl4qSAmrFsnE+VVEFMNcMuUQumhmLklVbBEE5wZhBKIr7V9X
 75CIDR8acKyMUS86P3dIrC6Y+fInZ/qdKShwRYwpQQ6eC+ADgXEjVBoLsAzsb0l3F1MTU+Xic1
 v2OoGdyGLz0eBITKt4Txuqq9Ik0g1otJNvWDlNb5+X3dqOr25b03TmuzliTfMHQDQhGeZxbe3i
 90K+7+0N/NuoVPknOgvuSBJ0kWVB9BtZaviDdbrc/ES0wAEUCAAA=
X-Change-ID: 20260923-reo-cmd-b4-posting-af227314a3b5
To: Jeff Johnson <jjohnson@kernel.org>, Ripan Deuri <quic_rdeuri@quicinc.com>,
        Pavankumar Nandeshwar <quic_pnandesh@quicinc.com>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        ath12k-review@oss.qualcomm.com
Cc: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.16.0
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfX6M+isoWJD64N
 K8U7H7NyXVaDK2aZFcPbvRDrfwM4fE6YhPbbd2AlhNypwt5XHTo4CIPt09c2hFeWG0afDlyqcQh
 j3hVp92RXv9KHbA1F0h3r4Owd/9IEqg=
X-Authority-Analysis: v=2.4 cv=Xs1vqlF9 c=1 sm=1 tr=0 ts=6aea8617 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=bC-a23v3AAAA:8 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=COk6AnOGAAAA:8
 a=JfrnYn6hAAAA:8 a=LivKf3GqjHCzdL6wAqQA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22 a=FO4_E8m0qiDe52t0p3_H:22 a=TjNXssC_j7lpFel5tvFf:22
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: TnIUwtBLww4712twMUxhWIZKbR_U9H56
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfX5LRKo54xFx4I
 fRY2galpR3wYnMNl8rhQdWw9taHic8zvZuzPucbLCGY/LksVfp9BDXEuS++voMmsWtPiep2Jtn5
 VrvxpDhv/eX3hI4m87cRIw4Sf6Y3JaEfvhNtb0zAeRD8reNe9/biizFveMQuVScqvp5sL9Srfk4
 jgzDSkKSuYREfirzNYr9se0g2lCqMClqTBZkwRukNILLaM88X2RJ2gRM9hbrxG3UDa5z9vR6iiX
 HeYIyJgL1P/PqwiARYD6jX+sQ14HqzpRASwHbJAXFIeBzxczvuBAq7AbI39zI/9tx37GTDX4Qx0
 BZMKi5nQpZxFbbkLyfTsxwgJpJIot/y1S72PcJY9ppt6nCddQMnU0tqZME4454uZDTQWAYCRJM+
 r4GDY/G0Vw/gJLIo+NNpmLcOxsiLZHQGdTNZLdU4TBOinU1XBIfcRJMXhZadstafeNghovWrGLe
 ytNk6S17GuJJQiH/oQA==
X-Proofpoint-GUID: TnIUwtBLww4712twMUxhWIZKbR_U9H56
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 clxscore=1011 suspectscore=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040004

Add the Wi-Fi 8 REO command handling needed by the QCN9625 datapath.
The series introduces the REO command and status descriptors, high
priority REO command ring support, common command context handling, REO
status processing, 1K queue statistics parsing, batched command sends,
REO queue descriptor helpers, qaddr cache clear support and RX TID REO
operation wiring.

The last patch fixes REO TID setup on Wi-Fi 8 global-peer-ID devices by
using the host-allocated dp_peer id instead of the invalid link peer id
when programming REO queue state.

The latest dependency postings found in local mail for this stack are:

Depends-on: [PATCH ath-next v4 00/12] wifi: ath12k: ng: refactor DP and HAL for multi-gen arch-ops
Message-ID: <20261103163435.2682252-1-praneesh.p@oss.qualcomm.com>
Depends-on: [PATCH ath-next v3 00/10] wifi: ath12k: ng: Add QCN9625 Wi-Fi 8 HAL register and descriptor definitions
Message-ID: <20261030120743.2687216-1-praneesh.p@oss.qualcomm.com>
Depends-on: [PATCH 0/4] wifi: ath12k: ng: Add SAM support for QCN9625
Message-ID: <20260921090656.1575082-1-aishwarya.r@oss.qualcomm.com>

Signed-off-by: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
---
Changes in v3:
- Update the cover letter dependency references to the latest versions
  found in local mail: multi-gen arch-ops v4 and QCN9625 HAL/register
  definitions v3.
- Clean up the global-peer-ID fix by keeping only the wiphy-locked
  dp_peer accessor needed by the series.
- Make the dp_peer accessor typed and local to ath12k, and drop the
  unused RCU accessor/export churn from the last patch.
- Link to v2: https://patch.msgid.link/20261021-reo-cmd-b4-posting-v2-0-e8e3f482bfc9@oss.qualcomm.com

Changes in v2:
- Use a lock-held helper for Wi-Fi 8 REO command queueing.
- Document all-or-nothing SRNG pointer rollback for batched REO commands.
- Use the shared Wi-Fi 8 REO queue-address LUT for qref updates.
- Link to v1: https://patch.msgid.link/20260923-reo-cmd-b4-posting-v1-0-74935135a2de@oss.qualcomm.com

To: Jeff Johnson <jjohnson@kernel.org>
To: Ripan Deuri <quic_rdeuri@quicinc.com>
To: Pavankumar Nandeshwar <quic_pnandesh@quicinc.com>
To: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Cc: ath12k@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

---
Pradeep Kumar Chitrapu (13):
      wifi: ath12k: ng: add REO command and status support
      wifi: ath12k: ng: add high-priority REO command ring
      wifi: ath12k: ng: allocate REO command context before submission
      wifi: ath12k: ng: refactor REO command framework for extensibility
      wifi: ath12k: ng: log successful RX TID queue updates
      wifi: ath12k: ng: parse 1K REO queue statistics
      wifi: ath12k: ng: process REO status ring
      wifi: ath12k: ng: add batched REO command sends
      wifi: ath12k: ng: add REO queue descriptor helpers
      wifi: ath12k: ng: add REO qaddr cache clear support
      wifi: ath12k: ng: add RX TID REO helpers
      wifi: ath12k: ng: wire RX TID REO operations
      wifi: ath12k: ng: use global dp peer id for REO TID setup

 drivers/net/wireless/ath/ath12k/core.h             |   2 +
 drivers/net/wireless/ath/ath12k/dp.c               |  10 +-
 drivers/net/wireless/ath/ath12k/dp.h               |  15 +-
 drivers/net/wireless/ath/ath12k/dp_cmn.h           |   6 +
 drivers/net/wireless/ath/ath12k/dp_peer.c          |  14 +
 drivers/net/wireless/ath/ath12k/dp_peer.h          |   4 +-
 drivers/net/wireless/ath/ath12k/dp_rx.c            | 138 +++-
 drivers/net/wireless/ath/ath12k/dp_rx.h            |  20 +-
 drivers/net/wireless/ath/ath12k/hal.h              | 103 +++
 drivers/net/wireless/ath/ath12k/mac.c              |  15 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c      |  63 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h      |   4 +-
 drivers/net/wireless/ath/ath12k/wifi7/hal.h        |  94 +--
 drivers/net/wireless/ath/ath12k/wifi8/dp.c         |  28 +
 drivers/net/wireless/ath/ath12k/wifi8/dp.h         |   1 +
 drivers/net/wireless/ath/ath12k/wifi8/dp_peer.c    |  16 +-
 drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c      | 643 +++++++++++++++-
 drivers/net/wireless/ath/ath12k/wifi8/dp_rx.h      |  57 ++
 drivers/net/wireless/ath/ath12k/wifi8/hal.c        |  16 +-
 drivers/net/wireless/ath/ath12k/wifi8/hal.h        |   3 +
 drivers/net/wireless/ath/ath12k/wifi8/hal_desc.h   | 377 +++++++++-
 .../net/wireless/ath/ath12k/wifi8/hal_qcn9625.c    |   1 +
 drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c     | 813 +++++++++++++++++++++
 drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h     | 103 ++-
 drivers/net/wireless/ath/ath12k/wifi8/hal_tx.h     |   9 +
 drivers/net/wireless/ath/ath12k/wifi8/hw.c         |   1 +
 26 files changed, 2347 insertions(+), 209 deletions(-)
---
base-commit: a2fa01354eb39e673f3f09e6c1cec39f82f0f9ae
change-id: 20260923-reo-cmd-b4-posting-af227314a3b5
prerequisite-patch-id: 49882cc69530a316a86f617b0b8649c3e753fc39
prerequisite-patch-id: 6fe238c82896b9f8b39fa0f09e32fb72d82ea6e1
prerequisite-patch-id: f09a16b2b6b388cb3290a14d86f4fbe370929680
prerequisite-patch-id: f7fab6336752c5a6e2e45221157c05a2845b1057

Best regards,
--  
Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>

