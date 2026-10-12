Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446084A9D66
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 15:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791820629; cv=none; b=npQjrlY/BDOQperH2KCyKnWQ+wNhGMKYAZD2Aij8eFb3jLN85/bNQ7s1ckig+0Av1m+ju1g7xpwPDrGt5v+84TzjPxPX+oXdPgTrIW78Eg5bF7UviRgJt9Jjv2tEXr6xXAQUwgdrhu2eYp8YxsafT8lf7zfcya716zw51e163Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791820629; c=relaxed/simple;
	bh=hgK6iHhdKFem6UFEboTc1tGVcd7hm7BGSzUtO+61aOM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=a/gb+GJpnKeIoxQBSnPYEzS1zkGr8QMVVLDWG5i8w6wON1Qn9qjlBgM+qsIbQN/6oRsQYWxYWF8SMGv0qVVQAIbgv28U2Q2fTw7t+CDNWQlvx1FzNW+C37NqZS0kHrHuq6pPO1og2/AjIomExFjSaJeCmTAmEB3gEvNuwmxX2ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=k61Izvj0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hR4ztKJ0; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="k61Izvj0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hR4ztKJ0"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CFf3Ia3163338
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 15:57:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xAdX75WRt1z0l9J+6glmJ42BYc183LpaLtY137AuQhY=; b=k61Izvj09J1i+SqK
	8HOyPyrhPWM5o48Xpp6VeHi1PN1kYW5jrd0j+Jkikj6pN32BBLCcAaT28WenGhpv
	x0xr9UvGcaQesmhxzHOo9bD+hWqAjJqOAjoPJFkN+E1XvfPw0AjopP2Lih5l1O+m
	o+g76c78MrXjaQq7X4K7ap6iIL21bjJ7nZtDLfIx8LF4XU6e/UVAw5uhuwNHLRM2
	8ISjJNCceqoWLDqgZr22Vio9NZuJG+CLfKSRDG7Si4ENxvye0oHL5c8vCvVUshC4
	N60mgs+dUv7Nesz4+tZBOE8oE/FYAmCLjjBPktR/52wEEqGCYNo73tDU2r4/n4Fz
	JDrxnA==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h8sd1trhh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 15:57:07 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3515266f6eeso3855936eec.0
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 08:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791820626; x=1792425426; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xAdX75WRt1z0l9J+6glmJ42BYc183LpaLtY137AuQhY=;
        b=hR4ztKJ0gKdfczhDhR5sogI67YlU4V/6P6iktyfBxXPZcqgXKfqenL0HRmLtyDdT9B
         vP2pRUVxt/OweAYeg+UVU6InLQHurrPg/zt2+LkOQywUxrp71t9yadULwlkvGERbqGY4
         Bnt6QbSk2fJfcZRH91Rq+XPR/F/aRoGDED//GaEhodwGJ/UhkVJjqNTj2Lm9bqbYOP4j
         KIfGMM9M2F77B25nKghnLKKJ6Tc88hEKx+G1YWTJrmK0cVWn2OA2Nrby0JMpkUOG0a0p
         SQbAn9r0pR1KYNslfcc7quP9DDbVhdOBI5MSDtaKKR+AMTE1wPBmN7i0yuFM4OU/438I
         zxaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791820626; x=1792425426;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xAdX75WRt1z0l9J+6glmJ42BYc183LpaLtY137AuQhY=;
        b=SHoIzQJFlQjmIcoysN87enY9+PB1Bsn6qm3SjDOJb/VJtZdAI6c6cn2y28G9aTRvTc
         /QwomNYv3gOoziWwWHXLxBdZ5A+pKK1Lb17e1Yi3Ma2RjoFgVRoUSyYvfJ0N9MN3Ja3z
         HgW+A7xYZMRpXb30xA+Xjnp3jXUtlMBCAKk7ryr6d48DYAWCoRliQrG+tggQybPPnW5p
         rxOm+mtvX81AemDeVUCsCX/IAsSxtvKpcerEXYzX2T6nPsgUe+CB1hvCbiKCwM0G+mo0
         U5lU0Ej37H1b/Z3l/il+pJfPPrX71cUPNdg05HITBTcJW/UyRbIWEVvt10eA20ghfRRR
         tM0A==
X-Forwarded-Encrypted: i=1; AKwUvBxYZkBBVrUkw4VBQhXRYfQG/jsy+mlApG+XmYEY1wmeIVr8w5YaRbWDvhha/8+J2bCnPAkNjA93mwXxE9V9PQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIThYa+jkUv1LPPW4hDQ+swXhSqAFrdoThdpANUhnhvsQkq3vH+
	4dm1HQhVrdK9/0AX0VZTk1QlV6/gTw/0hU8EnIQseqZe4nJ2rEhfuDQZU5IY1UM3SNPkotrUT4j
	UZpdy0hjfqEUdBChxB/+5GGFZUfog08oYGm3+63wJsyKzUwn35BviEa5T2CPc6BzhH1UcaA==
X-Gm-Gg: AYBFou1m1UP7dfdbplMX6yrd4N+ElKEyJCZalmputJn5tpjoADmKU+ACJbTgfAElvqn
	IVkGE0IVDDN8esnNbAhmQ7cdMUKTMA3peGd81qOjpwsznxzaeBQvbmwSZjvGsPtTzBJyN3lG7bx
	ZfZPb3GaQSSkd/T4bxWJKGwB/KCtc1FzkzE9JYxhaIlybrJDhBwldXtuxnTuQVNhT7sypMGvBMk
	fZKL2teyk/OP5vPPBa1LbPYkld2tsdThRpmP6l0YJdGFFTM7ENnl/EkU3Sfz77+Im0kavHFNORB
	L6ZT5D104qtitYA9Bit1EaoM3F9A5s9XsWo3q+lHdYJPqlKfhupDG7nBNFM0q4tvRIXkhN3A9+H
	C6mQj9d4JMThF9cQqbdnDolfRL5iBiw6HYOsXkWauD8k=
X-Received: by 2002:a05:7301:4546:b0:343:ff9f:26f3 with SMTP id 5a478bee46e88-3537e033fd4mr12292595eec.9.1791820626124;
        Mon, 12 Oct 2026 08:57:06 -0700 (PDT)
X-Received: by 2002:a05:7301:4546:b0:343:ff9f:26f3 with SMTP id 5a478bee46e88-3537e033fd4mr12292555eec.9.1791820625436;
        Mon, 12 Oct 2026 08:57:05 -0700 (PDT)
Received: from [192.168.11.106] ([124.123.80.135])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-353814b556esm39386183eec.18.2026.10.12.08.56.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2026 08:57:05 -0700 (PDT)
Message-ID: <193ecf72-5e41-4106-9cd7-8ba287642148@oss.qualcomm.com>
Date: Mon, 12 Oct 2026 21:26:56 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] wifi: ath: avoid IDR mutation while iterating
To: Jiale Yao <yaojiale02@163.com>, Jeff Johnson <jjohnson@kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Michal Kazior
 <michal.kazior@tieto.com>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Bhagavathi Perumal S <bperumal@codeaurora.org>,
        Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
        Govindaraj Saminathan <quic_gsamin@quicinc.com>,
        Sriram R <quic_srirrama@quicinc.com>,
        Carl Huang <quic_cjhuang@quicinc.com>,
        Vasanthakumar Thiagarajan <quic_vthiagar@quicinc.com>,
        Wen Gong <quic_wgong@quicinc.com>,
        Ramya Gnanasekar <quic_rgnanase@quicinc.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org
References: <20261003092104.520135-1-yaojiale02@163.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261003092104.520135-1-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: rkRjsvB9zK9fAhaxkxB6cd-eFW2a5aT5
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA2MyBTYWx0ZWRfXzi5DGocIdpDX
 FnC6ma3a9NnSaC6bn11LKhtRmNu8aKf5rLIHFkOphqzXVNqB2Jrd4n1uIjObnSb48xOXtjWOZHT
 zUQs9p3tMZ27S6zLJtM8ZSyMX902N4g=
X-Authority-Analysis: v=2.4 cv=QtHLTlyd c=1 sm=1 tr=0 ts=6acd0353 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=kllYWVK2JqQtNyhMtAlpJw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=2dOy96dDxX5ttOVY4VAA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-GUID: rkRjsvB9zK9fAhaxkxB6cd-eFW2a5aT5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA2MyBTYWx0ZWRfX1H6mrDzLcdW2
 EvZcZSSEsxJz7TvI/Be0WwgZgEzEWniqIvCu/LCnpSPytVJIYJUCnopqe5Iyldn2CjRU2EH/cN1
 U7p5rLTfv6c7jdrQpHtgYHlKv32f/ZbiNH6NAIUn0E0imVzQ5602wtDedX8H23wOns5Njkwc1vh
 CQuK1OZ0wDDvpApl2O6n99TUzXrpoRU9K/E8QcnyAHofay3TG+g4sJHNP6l5LNHMXpTi34kcV14
 WNZBa65Dq6Gw9UyZhD3usmJkXCxp05HqNXAfCJ/m3gNXa1L/KcdirJ1d1LPwUFY+jw1Pgj5gQrx
 CjQ6tn7KkbvHQA0a5cC7MuKbUegF0ADqBT6+AbJvNu2m5bvcSGJlKCRosHI3WNnHxTuNM25OT+k
 PtiA2dDjTSa7NK3vMvmW+jK3pejYxFuMRnuI/1yW9MxtilEG5f00qmH2mMkvvLs1oqDPT5EZayY
 pRSmFjb+GVCcd6gjdtg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_05,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 impostorscore=0 phishscore=0 adultscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610120063

On 10/3/2026 2:50 PM, Jiale Yao wrote:
> The ath10k, ath11k, and ath12k cleanup paths walk an IDR while removing
> the current entry. idr_for_each() retains radix-tree iterator state across
> the callback, so that removal can invalidate the walk.
> 
> Use idr_for_each_entry() in each cleanup path. It performs a fresh
> idr_get_next() lookup for every iteration, allowing the current entry to
> be removed safely before its skb is released. Keeping the existing locked
> removal helpers also ensures that a concurrent TX completion cannot find
> an IDR entry which points to an already freed skb.
> 
> Changes in v2:
> - Rework the ath11k and ath12k pending management TX cleanup patches to
>    remove each IDR entry before freeing its skb, as pointed out by
>    Rameshkumar and Jeff.
> - Use idr_for_each_entry() for the pending cleanup callers instead of
>    leaving freed skb pointers in the IDR until idr_destroy().
> 
> Jiale Yao (5):
>    wifi: ath10k: avoid IDR mutation during TX cleanup
>    wifi: ath11k: avoid IDR mutation during pending mgmt TX cleanup
>    wifi: ath11k: avoid IDR mutation during vif mgmt TX cleanup
>    wifi: ath12k: avoid IDR mutation during pending mgmt TX cleanup
>    wifi: ath12k: avoid IDR mutation during vif mgmt TX cleanup
> 
>   drivers/net/wireless/ath/ath10k/htt_tx.c |  7 ++++-
>   drivers/net/wireless/ath/ath11k/core.c   |  3 +--
>   drivers/net/wireless/ath/ath11k/mac.c    | 33 ++++++++++++------------
>   drivers/net/wireless/ath/ath11k/mac.h    |  2 +-
>   drivers/net/wireless/ath/ath12k/core.c   |  3 +--
>   drivers/net/wireless/ath/ath12k/mac.c    | 33 ++++++++++++------------
>   drivers/net/wireless/ath/ath12k/mac.h    |  2 +-
>   7 files changed, 44 insertions(+), 39 deletions(-)
> 

Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
