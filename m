Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D21D3793B3
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 13:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811849; cv=none; b=amHc0q0a4wjrl8yqeU4Grv1VjIrJDhi3uO8l19jpZLiE9UYaJDhynCFb4ZqlkNGUbeECwp0dM6MlRN1DrZ/0qTe7ZfubDZVBXR5yHouRLac/oKoxJLxBb1PAyXiU85X/DEqCq7MvNIeGjsZ9cmsAPPxbm9VbFCoiQYB7FVVcjWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811849; c=relaxed/simple;
	bh=EQFWqasI/60Po2Z8ivIv/SBmzO/3fqqWFwoXaYSFiLs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nQ6q4rCntq3wSOyZN3kHVvcVu5SPMHVt7V8p0/YAEs6KNhS6MgM2JO+6rKe2e7zFGeyzOV20BkLgUqaF0wR/Jk1V7qD1DBNBYlWWsUA7vACcXyXCrqM3603aBGtKe+pFlwaDv5nWhq8bokt97LlHM0LiZYyPdbluz5Y0aOc4hW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VR2ouf4c; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fKjDnnSV; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VR2ouf4c";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fKjDnnSV"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CC0WtO2252722
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 13:30:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vOV14bDhvBuotOkbBoK+dGZoQ3QXXV9MIM12bAdQJsc=; b=VR2ouf4cUZVIQt51
	rQ0Gk3U7np8d4hWDD9HCz81ABtp9bj6+iNzJY9G719oy62dxzwFuvWaPKuzktJbh
	8i36bQ2v2uwvFp3ydMT43bSnS3yA13MrvYlvV8VWjUp4clORHe6w2+bHFQ6KzDVJ
	1m3G904t0QMMd+5OLM3pexrr/xAndtKCxyoDMimRpRPktYgadljnVsCFT7l7iAEe
	ZNVk5GQxEOnfjpOGdqjo577p2vKhhg0Fnk+2sSDAxx26RYdYVX+xKRneN8FvoCV4
	XHEsHgKeyxsWnpVpBeMlZM/Al108UV77sLS3vo4fUn4KtNNZQ3wTtLCX5q/p+ZZC
	1a1ndg==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h8j7136gj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 13:30:46 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-35a0c25def6so2275786eec.0
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 06:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791811845; x=1792416645; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vOV14bDhvBuotOkbBoK+dGZoQ3QXXV9MIM12bAdQJsc=;
        b=fKjDnnSVPa23LuHp/wTSv+fKKf4R2ULi6yG/0M9pMxkZDYbS51qAlxt9S+Dqf54qug
         rm6kPdU9srRQJokBqOrsY4qTgkG6skJ/vwhYXeYX2GFfv7Brcg9qy/gHPosYxuwJbXxd
         qEm94NIpJXJslNUwzqwweGK+MgUKUFuaLagB6RJC/lTyjYN/mjbTIQlgypIK7msoABjm
         t5rnozBdgvYI6HFvpTge8AsjS8wx8dX60NXxFT9mLnVPjWpcqeVjYhPOE/9H9WeelU/f
         QixA3DJPkbXKWPq1mrZCVD3CcN8Jbw3uUr7sMLHhBn+X/wSR8XrauqA3QhUP3D/NXAl0
         XTTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791811845; x=1792416645;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=vOV14bDhvBuotOkbBoK+dGZoQ3QXXV9MIM12bAdQJsc=;
        b=T+A7WJ/KF79rV7s9oEV7TNsztBp58EV0HLBC2JeNUvcbup2tOYPaZ53W7j6FYnPHUC
         SrcPwTdvf6yIUU3FdzN0IiNwRsohyPPKRLo08Xh63Cijj+tnD40uB3ayn41ZCiOp81Fo
         +d367UucRHIu7X2PrMGP3EF/HIEuAQ358x5XAwZ9n6MnMKkv9+EX57vsgiIP/i6aBuZd
         hcxCjwJP5s7W4imBdAjBcxEEvs3+PohHEOZaR6ylAN53mdtVx3cPjccpyn1XMQBl9jNb
         ANPjxQAcYH8x5/EXVE7JUcR0cJpxBpeJuXGx8xnXKHEPZ7GDEf85764+VyKmingjYp2Q
         QphQ==
X-Forwarded-Encrypted: i=1; AKwUvBzAsuvZ/I1a0RdFb9RJFHKLraH9N41wenSv+EhBBS1P+ErkOeX2IsLxe3LhPOgLLiGQ1GnR+rew9ele3Jj5ZQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLBsnH9v8Q1ZjrXq1u2lQux8FdVJa104ZsKxFII/juOSzTafeEi
	vzZJqfEARFmsHhMj9oIbzPTSCNwOw5RsNWhI9SS710JN1BtjWqOG37xdDKTeQ2t6WZowKXXf90L
	HKPkMGgwQHWJKq5243vrZ/YjdHvkfx35LyY/GhknGyszWK2WM9CvLlaPZjHGdzWLqLdGM1A==
X-Gm-Gg: AYBFou2l+RMh+/2YIw49Rrl0Q/UHizIBK/43r8mvOPJ9ohK4RZnhYpMh42i+3fRM+Yl
	BVzl5qQ+/e0oZDuRn9s0YSez12URWQm1FprcCnkLgADbR0SoZ3OhHmnXeBjrXp89TKDca1FttHK
	dVni/K4NPAjOP5PfAYA1EzPevp44IY6s276iTXCYdLWZQ7SpDwpu8trb9ulRypjN3iPjAEZF17h
	+NDxNEmxa+n3uKZ6VnfibxxhXoBeF6lCHz+bY9W/P1pJ7AWwHbiVzvtCBDFCbjKliE5F7+Udhg4
	goAV9pVV/vqZy9vBmFWNTuR3O1Zi+SWqF04j7XTPe7QNo4t7CP2GqGkpwvVmJzrvFzAQ0BSCtfu
	aVgqVPPmBk1jrOswhONOJ479T9PHF70wOqq9wKbzgDkPYgBbqn4/qJeHJjCcY
X-Received: by 2002:a05:693c:80db:b0:353:5d25:1de7 with SMTP id 5a478bee46e88-3537e0abb18mr15590127eec.33.1791811844964;
        Mon, 12 Oct 2026 06:30:44 -0700 (PDT)
X-Received: by 2002:a05:693c:80db:b0:353:5d25:1de7 with SMTP id 5a478bee46e88-3537e0abb18mr15590058eec.33.1791811844129;
        Mon, 12 Oct 2026 06:30:44 -0700 (PDT)
Received: from [10.227.105.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca1b556sm44711556eec.9.2026.10.12.06.30.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2026 06:30:43 -0700 (PDT)
Message-ID: <92649385-8437-4391-a233-bdb59cc600c6@oss.qualcomm.com>
Date: Mon, 12 Oct 2026 06:30:41 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] wifi: ath: avoid IDR mutation while iterating
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jiale Yao <yaojiale02@163.com>, Jeff Johnson <jjohnson@kernel.org>,
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
 <3c6a641e-9695-4e48-a5f2-4911d0ba8048@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <3c6a641e-9695-4e48-a5f2-4911d0ba8048@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA1MyBTYWx0ZWRfX1N0fmdlIfnv4
 Le0KOywdzWWxsqGERX04uDhf5lxD/cTeGUhnQxiiI7W/kfOIdt/ahUbhgzs7irstOKy+EppFFHw
 d0XRry09qUDMmpEvQglns5iZdmkJDgs=
X-Proofpoint-GUID: pKq0IuMecJK7Ou4C0t4lCXY6pVYsidIR
X-Proofpoint-ORIG-GUID: pKq0IuMecJK7Ou4C0t4lCXY6pVYsidIR
X-Authority-Analysis: v=2.4 cv=ePGGH3p1 c=1 sm=1 tr=0 ts=6acce106 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=b8Ip5u2rk5lctkbpsk0A:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA1MyBTYWx0ZWRfX7dt+oH2pBjb1
 1+15qoz6Q1bCbP7QKq01YYTZLZ+zDaL2xXXFgSt23lgFJHwdB7ixZbwncAI58XrNeUKrqMvt8R5
 c/6JIAuW8yPLViuFsy/neArdyugqslViraDwesBZaaZkhhbh3fckJHne8zcybinbIVu5M+bTI91
 qUx/sX950mRVsfetQfj/sI17Eig1p1V5ic2Kp44UFN3FZxsahBZk3+EV2kFIiN/+FcIQxx+036s
 AQJ6mv6hlVNf0VvXRDGh2TmL0+KgQINSQAzLWOVYkvNbmzQ7zwVEfD//qPwn5H3uuffiuMy1cLR
 +r2twOiiXSIO3I8ADSMmlM6VbwD2DZI9o2ZkpcPdBdTpmDUFXYez3rMAfmfAh1Qkxw+Ghwie4y3
 RK83MMxsIble5leeogScAEL0AljPKwurUTFdx1crufm9K+xlkAB7fTAUswUdVSbJe3OenJIM7g0
 CJ3lPq01KZdlJXGRyXA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-12_04,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 impostorscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610120053

On 10/11/2026 10:52 PM, Baochen Qiang wrote:
> 
> 
> On 10/3/2026 5:20 PM, Jiale Yao wrote:
>> The ath10k, ath11k, and ath12k cleanup paths walk an IDR while removing
>> the current entry. idr_for_each() retains radix-tree iterator state across
>> the callback, so that removal can invalidate the walk.
>>
>> Use idr_for_each_entry() in each cleanup path. It performs a fresh
>> idr_get_next() lookup for every iteration, allowing the current entry to
>> be removed safely before its skb is released. Keeping the existing locked
>> removal helpers also ensures that a concurrent TX completion cannot find
>> an IDR entry which points to an already freed skb.
>>
>> Changes in v2:
>> - Rework the ath11k and ath12k pending management TX cleanup patches to
>>   remove each IDR entry before freeing its skb, as pointed out by
>>   Rameshkumar and Jeff.
>> - Use idr_for_each_entry() for the pending cleanup callers instead of
>>   leaving freed skb pointers in the IDR until idr_destroy().
>>
>> Jiale Yao (5):
>>   wifi: ath10k: avoid IDR mutation during TX cleanup
>>   wifi: ath11k: avoid IDR mutation during pending mgmt TX cleanup
>>   wifi: ath11k: avoid IDR mutation during vif mgmt TX cleanup
>>   wifi: ath12k: avoid IDR mutation during pending mgmt TX cleanup
>>   wifi: ath12k: avoid IDR mutation during vif mgmt TX cleanup
>>
>>  drivers/net/wireless/ath/ath10k/htt_tx.c |  7 ++++-
>>  drivers/net/wireless/ath/ath11k/core.c   |  3 +--
>>  drivers/net/wireless/ath/ath11k/mac.c    | 33 ++++++++++++------------
>>  drivers/net/wireless/ath/ath11k/mac.h    |  2 +-
>>  drivers/net/wireless/ath/ath12k/core.c   |  3 +--
>>  drivers/net/wireless/ath/ath12k/mac.c    | 33 ++++++++++++------------
>>  drivers/net/wireless/ath/ath12k/mac.h    |  2 +-
>>  7 files changed, 44 insertions(+), 39 deletions(-)
>>
> 
> if you want to go with current state, leaving the UAF risk in patches 2/5 and 3/5 in a
> separate future fix:
> 
> Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

Since the UAF potential is pre-existing, let's fix that separately.
So this series fixes the IDR mutation and another fixes the possible skb UAF.

/jeff
