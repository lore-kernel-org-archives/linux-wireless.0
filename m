Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792995777;
	b=Ub9QyEPgFBEnpmoj2jblEZ6J5zFYFEiJbhRDcN5stkj4Y8ke1XGd90oF9V9fmJ5iREuA
	 QVy6jxv6CdL7y0TRyI9oJl5/5vXkcIdpNBgsDI7HOjqKz/iAqBhbNnqTU55AueOBF45nT
	 Syh6Tpsz5WLvV+wS1wWXgqts/7EmlbaifNpX8AuyrhvZ4Pv47NLZBHgM9CcblmAm0uJoN
	 +l7Tj6W8fhIv9Z1GwqPqMI0XP7PeSdhtZ2ggm0tDILmcGVlGt4mDUeOc/tPa0FMMmgL7S
	 Y92zBVibBRMP8ulUp602qvbPx+d+XrXdzjHGNGJYlfjuryWlzpWiELsckV4TM61GHAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792995777;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=BRGzkDJlyaYo27YOEoR3qSlvLhrXH7ug7jX2UAfMTGc=;
	b=UIPOv/8m8eN9r2SHmzUwXpVbDI45g0bKNJEks2epyQ+BmLm+hnbK4N0SVgroUMnx2rCD
	 8e/ucj1t8XMj5vxw8+T00cDspaFhFbXxBrEZi05GWrK0jbLGNog8V91OxPnRKolPfdOa1
	 YwqdQvRteC9bxM5hP0vjtZWECLvomr/K5bq/c/28sdRRbJ0Pa/VB04Pn60fTAHwRma7XN
	 BQ1BWX0uOiT1HellImFtwPeZRPnuyLIGkLLN/69lOoRusMdyiMiC5I9GdnM/T5gXCpS5J
	 uJk+mLcdH0gNpxTsgPXbxRGpXhMkUlX8I6dlVAn7ipBQypESqclzC/cL6eNiGjtQ2pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Igk+3iVG;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Yjep0Xqf;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25DA606A32D
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 06:22:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B25DA606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Igk+3iVG;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Yjep0Xqf
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69Q4as1n3303642
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 06:22:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BRGzkDJlyaYo27YOEoR3qSlvLhrXH7ug7jX2UAfMTGc=; b=Igk+3iVGlbz5b6tB
	V0gA1Nrz0Jly4J1OoNE4xjoJzvyRPSUvYvWw5qqIicKvSIFMpsef8xt0gCj8xm6u
	m+3YAe/99SqF4IOPJYeMV3u2Ko1V4qRB6G2Y+eMGuU5FssFwDbDQYNrc36fCvlYc
	O0BbhCKv3duQ+abRD280UU5h5nx3fFj/1/w+yVP+P/zvM4xQI18VQikn4VPcPZGP
	nNEITFedz13srfsp0fnhIfkYyy5z5Y8hYyDCG8prtOzLpxBgNC8oL06RDGX2Qody
	DkZl0Q1IRZ6f5nDTmYLGJMLnUFa7PLP0gfiyQh+/vS/XClLzwNAIG136J9NUOcwJ
	xlMm5g==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hgkmsd4yr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 06:22:56 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-3662e7a9299so13942344eec.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 23:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792995775; x=1793600575; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BRGzkDJlyaYo27YOEoR3qSlvLhrXH7ug7jX2UAfMTGc=;
        b=Yjep0Xqf6bdTiKRuVRARy9CvCTiuRZ2d68nGzYVb6CtG4BeVFbiGQFvJ9WKUU9ekGT
         nnGSyKxquyu1S7mZnNDih2yW6IXTP7Kh6T0SHWeyx7ynpHqYBbWk9JUIRGm129+YhIAY
         LFiMHW1zLFueThJ7ANwDRsCUFW54wZlH6AGpbEe9Ga0MTKfoLKSYL/mQ/hEnyeKg0w7p
         t8n3Rbw/FbH+4BFfZ/6jc4gdCYd6aCXQNWOLxUbMmC86AbGd6UBEdn6iwvGGBjdl8dvB
         TogHWygR0R5YLouI4QlovcHdCbGcUVJKo8Y4iFmDpxhhW+7NNkJfAWz+oac6TsTDd7JZ
         WSUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792995775; x=1793600575;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BRGzkDJlyaYo27YOEoR3qSlvLhrXH7ug7jX2UAfMTGc=;
        b=n10RTnPdssGnDWGmkivdIBxCggy7S3YvcolsQoFLadg4jBWK/ucaCkVe9S6o+8RSNi
         KYWRdaUZchd5h7R95Ficp7/5vXDXmPya2oLhkUIVe7KQ9UajLmLu9ayhjycCCXIg9Q3w
         kZi906rw73W4uGusbQif8M7q4c7okOR2S7NGIa5SYKn5I//04UJZwOkTsD3Dgm6PldlC
         eo1E3xlJmSGlAGeJnaVHHYT7SWsUob9bNjt1dsEr1Wrmhik7iMvjp0UT+PkdZHGOmuvd
         Q4v/C6y5LimbSgp0ikprVQglOWWr9LPb19SaH56o5wdWvCr4HT6LSJe0pf6wlpltc8ig
         wxzw==
X-Forwarded-Encrypted: i=1; AKwUvBwSl5R6ppYWuNhz4mXgAb7XxU6JUIJOq8ztXvWM0s2fXJuvGRhe5oAJFVSUwh92thqpHXRMRpqPQ1VE9ScrbQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYJi0ixkS8Fi0Wknwvwu2XvlcimsXi81QV0+4reeNiJY+vO+9ERO
	Xm2ge3IZwbu94YKuKZVo/IctthyvChJDTU4rmCgEquKWmqy3sLM2QMwbkNSMbAGcRKyJCzTHc7Q
	BWNQ496HR1p0TWQ1m/Yw92jxBQSesk+WjlJx66KtYZzn4T04l15kSshKCUpqW8Xj2HWLdtQ==
X-Gm-Gg: AYBFou36kDPuVtQeYu3OcDPLryKJqMXFp1swpdKoib2VBqglaURfLLzLIhZc+532uQb
	LiynamJlIIMEpoNAxEF3TYkZWIWlj+//RI+Otm8gf2JYA4yKNyF8PS2fMYRwIoFFp3zdoTOVMYx
	qs/+xWrlbsZy5fr4eKP/IB48SXR1uPoacT734kAhj5PyUPOCN/VDuMRAK7ClOSYvIIXsnJtqUG2
	/pratnnwIFEQcbet9O6YJ12+K+WDw+1GwiZqIMI4zjSftTml8H9BHxZDozfqxd95lISVG6MbxxS
	Ig0zbSb6wpQw6IL8dzl0K4T+9MODyryAVcG49H0TUJzU/V3VWHsA/dUKxcuPetAeEq0dGUOjgds
	w5SV8gQxNxZHSn5L+I0xA41jqESJJssOq
X-Received: by 2002:a05:701b:2405:b0:18c:e014:6f1d with SMTP id a92af1059eb24-19929a9e465mr8204927c88.1.1792995775102;
        Sun, 25 Oct 2026 23:22:55 -0700 (PDT)
X-Received: by 2002:a05:701b:2405:b0:18c:e014:6f1d with SMTP id a92af1059eb24-19929a9e465mr8204894c88.1.1792995774577;
        Sun, 25 Oct 2026 23:22:54 -0700 (PDT)
Received: from hu-daizhuan-sha.qualcomm.com ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a2a5a515sm19719783c88.19.2026.10.25.23.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 23:22:54 -0700 (PDT)
From: Daizhuang Bai <daizhuang.bai@oss.qualcomm.com>
To: Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        Bjorn Andersson <andersson@kernel.org>,
        Chris Lew <christopher.lew@oss.qualcomm.com>,
        Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
        Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>,
        Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
        Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: Re: [PATCH v4 4/4] wifi: ath12k: Connect to the QMI server belonging to the MHI endpoint that received the packet
Date: Mon, 26 Oct 2026 11:52:20 +0530
Message-ID: <20261026062244.2875432-1-daizhuang.bai@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261022-qrtr-multi-ep-v4-4-c6fdb75fcd3e@oss.qualcomm.com>
References: <20261022-qrtr-multi-ep-v4-0-c6fdb75fcd3e@oss.qualcomm.com> <20261022-qrtr-multi-ep-v4-4-c6fdb75fcd3e@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 5K6Me0FMJfhaCWKkbxI0-x1dolq6D7un
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDAyNSBTYWx0ZWRfXw+68QgSOjTjQ
 vZCJL8tfb4R9dTCshXyG8tr4amdSLh6U0EjlTQcUoC+12kLjma9pyKVTbfhJYth9Rkq5bOU1hpy
 W9/+CG7W/E2SG2zj9oMVi1r0Wha8gYgeQ3e+6oqSmPE9rXNTsRTwRi/PYEyB0CiOOOSsr3C/Hzb
 ZS2LN1zkabbrlnSLLzGngXv+xlIyibysyxnc5u+p/Uh+RbtTN988KFTua4/UU8l4pqqx0NYDndR
 +PvwjzkgJGeuZapnvaoYt0ocstsaNgrWBaFAb5TJlmP/Nx+KhVhponwsbvne8pHlDjlLazdA8tl
 EF0s2vjkYXw+jyV6j914UKDs0W9lMT/VkxhRbQCCwv6u/A5Mm6jdgF7sO4LG9CBDGXee6EnhxFp
 xTW66xqsCTFoue7fWnVURahcQA2l/m9DVBAvHpzpVTRGY5rPdh3OV9iwkz0ttLOTbCY/2elVfLu
 WnMxZNeVCLcNCWEOU/A==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDAyNSBTYWx0ZWRfX6Xh8P/LkQfb0
 c5yHP8HmWKOM+zj/Z6czcYO/b6lPV/8hzPrsAEb0ACjAQnoKvgcqH7Z9paqEiZwVal6uF+1xq96
 ExVBuIg0x1Uqem4M+EzCb5Qk7CZuRgU=
X-Authority-Analysis: v=2.4 cv=UqX2pOwB c=1 sm=1 tr=0 ts=6adef1c0 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=zDojY5Dqmkyknr1b:21 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=nUn8ewCANHEy0S7HLBYA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-GUID: 5K6Me0FMJfhaCWKkbxI0-x1dolq6D7un
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610260025

Tested-by: Daizhuang Bai <daizhuang.bai@oss.qualcomm.com>
Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00277-QCACOLSWPL_V1_TO_SILICONZ-1

I took the entire state of the QRTR directory as of after these changes,
on top of 6.18.44 kernel, and with some trivial changes to avoid conflicts.
Then I cherry-picked the ath11k/ath12k changes, which
had no conflicts.

Before these changes, Cologne WLAN QRTR NID could conflict with CDSP QRTR NID.
After applying this series, the conflict is gone and WLAN/CDSP QRTR services
work as expected.
