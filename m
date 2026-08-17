Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21B912CDA5
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 03:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786938166; cv=none; b=qYBC1tObL1VwfgEIMb9u/hQ/lkGWW+qnvc7VeTU/kjwNLEEXcRuWOe23KYUtu35GWS4TTMciFDDaQ5Ae3op9EbQ3qW1mXGj3UKkCidpqyq56euZpdVjLXGk03k1omqGXXZWuf1ldiDiY/extI7/CdmU2O/IqcJs4nW5mG0aMWFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786938166; c=relaxed/simple;
	bh=7GYq3zTOJLbbVBMP7gDWN5K0S9C0jta2zTen0G76xqE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YjuDF+TLhOC8oBYptZIvBWEt1P2YSXm6M4oheBmBgFnX5laJDtZaAVolfW1U6Plrtk5ahXfkM/rEP0xWifoO36NFbnEqPcsGdsF01AP+7+tDF14yMPOnX2znibSXG9gH44X1StBSB930XbWvVN6OScwWJNXpg9VJR6Z5dvDhCAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BFj6od1Q; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=N4ZHiIyd; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BFj6od1Q";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="N4ZHiIyd"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67GLCQR24126798
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 03:42:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Ah5XRtJBg7LK0+vYDvxEA4jBId1EvWjW8wVD87FaXzc=; b=BFj6od1Qp4xwLMji
	BXkRrpGUMs3JwbP0RXYrzhn5xa5B/jOOzo24FFChgsNSsgu6ICqjg8ySn0ptQ9Gp
	0QE8QDBgzqZeLKVasiOomRF09+XLP/9cKKSV0DHyELQfpyW5LJf6GepCfs5aUxhf
	IX46wTeJjWgItkhIFu/rAPHEaM7pbqXNnqn/LssIvMXCGNqv8DhTVGb2wd295Jg0
	XZDTUulcwS7QyRQA3glNMmHmboZ41BvXenNTHXzUwyXLn+A5G1hODHvTbp9IMDRF
	H0TIX1/0bCmUsIDryuIX7/zVMsqL5th3kJ0akI6FaBu6XF9ChVdBGCsZqG7DOGfn
	1c5TuQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g322qapq2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 03:42:43 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cd01a14e81so41817795ad.1
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 20:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786938163; x=1787542963; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ah5XRtJBg7LK0+vYDvxEA4jBId1EvWjW8wVD87FaXzc=;
        b=N4ZHiIydakc4LSLiJR21S+Q5AG9WpWzMvyXY6gPOWAhpJtwhpOpdmctEeK4iV8CWj6
         udJbDHb/wmnFfy/v0z3yr+hOmYz+QTs/X9UKQbki73sL0X0cNB7BSuz/0sKp1TnNDAK+
         fNTUHVUL8FfJZ2mxaBORDy+p74Ce5+lRsZ2QNeyGV+iFsVgIEm9LmxJQNBpvwfC0tv+o
         3nn3reuv1wVNZnb9eiLyFtGRRvtWEHke3C4kBEn1oII8h7GkFO6hqwnGE1qIY2jZ4n9a
         DpzV0hwY2ATczoGpY+8LB89rp/dBy6G86xXFQjnsf7XmbeF+1jNf8uxZ5sdnfvBluwVu
         4fFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786938163; x=1787542963;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ah5XRtJBg7LK0+vYDvxEA4jBId1EvWjW8wVD87FaXzc=;
        b=ktzvVotPVlHfQHiD8rY3/Uu23l66PrH3ieJi9iFTZ2hlnzhdIWKqR/DoYcwsGVfztY
         iTLiWFbPaJeSfUGWjIS3lp40wOJZGHFyVhwD0qO+3wYwEx7dAwxY3haBOebgXFYZT2hs
         M09++98x9oqYdY0iQe13QXZHLDMWtfkcS3IYCBwmq/Q/rzpSmJfjn1VZXPkzCIM7gyjX
         ljjgS2I7Zng1/1B0EkRNgPjB+hDU9AkFpYS6IUiShRYG9+epHv3fS76DMIoWxHjkr1mN
         E95ElA3p9wBvCKDFi3c8rmzIRh5M4KkZlFFDTe3ky+9pzXCjWz/0aZ4Jw88NDRvQdgDx
         ijSQ==
X-Forwarded-Encrypted: i=1; AHgh+RpAq6fy3+k7Pz/85jXg8K0wjP53WYpdpgUT7cztx6HIr0BeapVnVe+iy7rUlXP7t/iPatIqeTQAjU8UJKE1Cw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwmrC2TeCgiBXBur6jQzhiaQUFRAMppp6bzLj1Jlu1UOd0jw7oi
	zkQ0OuLvltG6AftQxZLAv1SUyQ5J2ZXhJSEl3L0eh0sTP3ZzP662qLcGvKu4ARnhjoUUo9P5NQG
	/euzOBpwaqinJbs7VeveD9AnEMWdXCr41UDz9wRKOJl1Kwbh/xmOiBIfQjqpoKKtf9fcESA==
X-Gm-Gg: AR+sD13yZRyVFkG2I1XGcr8E5o8woD4lFaae/suWHsnvrQa3NWcJPnqjvhbxAn8KurT
	gaDkhVMaL0ji2jau077IXKhDZCsqUQWWOQ4NjP55cTKZAiIcJPg9IpBgLAupP40qg4d2TQd5kBN
	MoNrp5Y9yMSx9wQ9feAPecCgjJQ0uQz649Nm5s0XQ04I0BoONfacrwmGhEhMVSjl/gXeb2MQmuT
	GGkLNIatE30qNjutkJ1NYxmug7fyf7Cjp8pkKbQ3KinjlO21yp9G0mqVauW9XMR3yklGGlEyXNl
	rUVwAj9UuHIVYbtB5B3pxld+YdJlQ3blAql9Q8PysGglBce2Gisdw53kLY0JruoUu3Bmqt5aS9A
	HUumoggQMpr7G9kTfmjGjmy92h5AreovJyxy98m7KJzMdBFeYZqhZwgBtZBCLteqSUBS51CMH9w
	==
X-Received: by 2002:a17:902:c407:b0:2ca:e3f:6a4a with SMTP id d9443c01a7336-2d3b0fb28fbmr253232385ad.21.1786938163230;
        Sun, 16 Aug 2026 20:42:43 -0700 (PDT)
X-Received: by 2002:a17:902:c407:b0:2ca:e3f:6a4a with SMTP id d9443c01a7336-2d3b0fb28fbmr253231965ad.21.1786938162752;
        Sun, 16 Aug 2026 20:42:42 -0700 (PDT)
Received: from [10.133.33.152] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3aeb2a565sm28725775ad.39.2026.08.16.20.42.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2026 20:42:42 -0700 (PDT)
Message-ID: <a8343f57-d956-4e07-b260-a54107bf0f1a@oss.qualcomm.com>
Date: Mon, 17 Aug 2026 11:42:38 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath12k: fix DMA unwind for ext MSDU descriptor
 retry
To: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        P Praneesh <praneesh.p@oss.qualcomm.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260813-ext-msdu-fix-v1-1-c5e80ccd061a@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260813-ext-msdu-fix-v1-1-c5e80ccd061a@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDAyNiBTYWx0ZWRfX2+N0d5GlWdwp
 eFGWYtO8lvlP+SnxApWtwyMRikuzZo9IpHHOfKG1El9b7jgSE51cL3/pJtvfDTLykm50Nv5CPak
 v5ZhtSvzPxp0Ep1aOcUK/DODbvwlRBk=
X-Proofpoint-GUID: 4HIek5j3n0rUtsS1skYOhKDE72S9dU8k
X-Authority-Analysis: v=2.4 cv=C5PZDwP+ c=1 sm=1 tr=0 ts=6a828333 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=h9Ag4oUkknsjeQ28DOYA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDAyNiBTYWx0ZWRfX7P1VI2IDA7Ti
 4M7IXQUbn+0U1DdJi7VoF1yKRRqMYb0i1U1B2uaAVo5nGlEwWRTxT7cq0xp4cubJ77XBLobdsbG
 g4jIlrJbc0rtSzQROpjvgxxIvawLfTUQxN3FMsC9+aHlyazW34dUYxfryboq74AaM/aeE+T6OIQ
 3zy2Qg4bjt6Xri1nrMeC2xp3mes0nX5N3hDwwJQGMI9cPoSBMm4EIBsiPMw25eoK73dXnx05BgJ
 zKt5SqIExj9tfxeiwyn5HV6wWpaUzMdE7sD9cub0QxRfpjrRT0wq7u7wrh9cVNO38p7l49m+vtl
 tz0YTuYkR8zIB3RwHlgjiEZmJu32A0S5qufbt3i4S/LkuqWvhm7Tc9eTQ/EFgNqHNAwzs8yPegk
 subE179CC7DjQbz7Nu+xKHOqOQP8v7ovgs42i0aJdXZec7IE/xesODU5nMYBjmEMjkyb3f0lGwf
 q1vY6vuhdE9HPvtfkzA==
X-Proofpoint-ORIG-GUID: 4HIek5j3n0rUtsS1skYOhKDE72S9dU8k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_06,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170026



On 8/14/2026 1:39 AM, Rameshkumar Sundaram wrote:
> ath12k_wifi7_dp_tx() maps the original MSDU into ti.paddr and
> stores the address in skb_cb->paddr. When an extended MSDU descriptor
> is used, the function later maps the ext descriptor and overwrites
> ti.paddr and ti.data_len with the ext-desc DMA address and length.
> 
> If TCL ring allocation then fails, the error path first unmaps the
> ext-desc DMA address from skb_cb->paddr_ext_desc. It then falls through
> to fail_unmap_dma, which uses ti.paddr/ti.data_len for the original
> MSDU unmap. At that point ti.paddr still refers to the ext-desc
> mapping, so the ext descriptor is unmapped twice and the original MSDU
> mapping is left mapped.
> 
> Fix the original MSDU unwind to use skb_cb->paddr and skb->len instead
> of ti.paddr/ti.data_len. The ti fields cannot be used after the ext
> descriptor is mapped because they are intentionally reused for the
> buffer submitted to TCL. Also clear skb_cb->paddr_ext_desc after the
> ext-desc unmap so a TCL ring retry cannot observe stale ext-desc DMA
> state from the previous attempt.
> 
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
> 
> Fixes: 37a068fc9dc4 ("wifi: ath12k: Handle error cases during extended skb allocation")
> Signed-off-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
