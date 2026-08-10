Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6DF380FE5
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 10:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786358937; cv=none; b=Dqh0Y+NttslF8mCKnq9/8Pq4XvgpVUZF7t5uiFXpBvhNCuwl1B9CzmE9aoZgRNdpHxEb2YZrI0YRtIF7s5HaYcm+asbbIokbCdUmlGayv02R2+FW0KFj+qfhD9NkXHeADT0OEX4MAUfaeHHTFUW02Ge+5W7iPdGQFUoIYFNAsMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786358937; c=relaxed/simple;
	bh=D58LBYkIcuWO94TE8xG8H+n++odNeYUUVORE2mFnY28=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SkLP2InHGATnbpsbUxFytqEdz4nRJBewUOokFpI1UgZP9xDHM+VQRKhaNxkFDPTjuRAzeuFw9M4tAWm6JgW4kwD8dnPfjxn9u5LtVig6Gi6WWAjVpR3xKEDxWqrvUerMuiDKYdKFJ7vFmL74l6QTrjuzLeX0mHDW7YX3SsLxxYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bGQHD8oz; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EpEjGtwh; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bGQHD8oz";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EpEjGtwh"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67A9S6GE872709
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 10:48:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	i3TvPInWz3YuN8P66pTP8LjGc5w0D9OtD5LRwHcHHwI=; b=bGQHD8ozF9SOh/w4
	dX4rgBt6DU2cYkJyGusiKPaKqXAE/WyDS39Du72MnABBNcXcpgG29O4wrxR0+irT
	Au+1BEH7I//6+lVPiIRQWZMN7v7POT8LIJmr1B3IMaZN3vBdgjct6TXYL8q+13+g
	GTyFXV2VAoJ8a3o0n7TyiWq24gR3HoetFeOpfR27HsdvQCyz4WEQyJRjPa25kSys
	iV3heqt/baQUCFk353cVC3q+MJ+1QHelR2HFX6WMuAurV24F2VswXLIcfIIQ/A7z
	S7FhShvqITHdKH4qo4ZU5ETE7IG5Hhe3oQj74Hy3xK+OJ41xlxpkxqOQWQkNd/bY
	Mw+kug==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fy8v5929w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 10:48:55 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38827cee19eso2556641a91.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 03:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786358935; x=1786963735; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=i3TvPInWz3YuN8P66pTP8LjGc5w0D9OtD5LRwHcHHwI=;
        b=EpEjGtwhYzdZKYPS4Y3bn7oU78JF5fraz2OEddvV/Vb5nePeNI5GTwjBxALUPYbEUd
         9Vuke4p/DowKA0nNmsuvESvI70eBUPR4V7sWH0XSVc5epMwsmHkFeP4HchZoQBb9txf3
         itJR51tm2SBO68k03aY/RC7RexLfWxs+ugye7a4U4RBKf6kR/qDAc9quoSok5wJBmMI8
         ftk/yNVUFPCIjzw4JEIwBGK7Dx7rYp87Wd27GKwq8f+a2FDt+nP5+XTE66UGxU7VqGK+
         J66l2OSgmrvrd06IEcQg/N8nTt9nCDZ458w3tZBu5IA72WLBrIITawiGPCjVzNNlxJce
         zSug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786358935; x=1786963735;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i3TvPInWz3YuN8P66pTP8LjGc5w0D9OtD5LRwHcHHwI=;
        b=XtiS/ZqSE237baJUFE4C8rQILajV3zM9PriSw6wCr9c3xNzdziXcWJWJmKSwxwZlx9
         G2NEDigk3hhuBIBQVbeakyGK+NrGVRhk56jltjs3c8bZWwnN9jpXydKIwF5Or5JbldRA
         raRuVjKP2Nlab5qBYJdzr/aCUPrT67MhzEpmKwa20xKzUapn4mAnZXK1+EvqH8cva8Rf
         F7sukyyoQ44lkkw++NijrEF36IvfsOTSI7M+5VVajwwrZ7B8DhVDMW5937vtaC1RVssp
         cjHhyJj/NE/kd7PzoRwZwZ9jSX2u9GBn7qj5Va/D1uyct6PUBi4DkaKkkVAO2rka+oFg
         e7GQ==
X-Forwarded-Encrypted: i=1; AHgh+RpXpjbEIVQoNrabA+b+NJs1fD4KvEjtLR3OJntXOiX/B5wdrryv8UEKgs6I7PjnnVmVqSu9V46fn0Kkt44tHA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxWCFNcLTver0qJnUGW9m8FaPPqnA6q+mUG0n4JsVsklWsxl9a1
	qATNtYweicZ2GUaubbidUkHHqxt7PHV23HkuO8d9sO796q73tUzRwuDqWSJHmvoQTvWx8ebCQG8
	NIhcAGu/DQtw5WokNJneYSbov2sxwVL24WK3eD1jLJuYcGh1EImqSEVhdz0FBrs3ZsGNKngntJm
	NS/w==
X-Gm-Gg: AR+sD11CXvTJmj1QXsUWwxAR8BqVpo3uV+v7mxy+Z+MmTC0oghP5iHcrslwicDeQvBJ
	/mdbgSyDWEEIOimEYwJ9a/okFeSo9d+XVs6NCjmbLgC1G3uqtvDPKkzG386g9rnYZ9DQmsfGozC
	3Kl6AYb8bdWea6PBZXlajY9YXEmaYCnLfkS9CR3XupdLHhIrD0sOINGsoUXldElr5TR/9Eqpn6p
	g4XwqGt03GJMSJV9Pa+5g7X3+fldUuUbvs969UX46BgVN7BydKyTMXWAlMwi1N3m8R6oNeDKmfC
	TJYUen+n8OdLrr8OXr6bNVly8MEPfVxzZW88TGmJolVqSPuTVtRlSswbKDfXFa9AFvnWJjYpjcs
	L2oNcKtfCuF6Mu1ZAT2xkvFKAHaOkeX7500xc/XsL
X-Received: by 2002:a17:90b:4ad2:b0:38e:740f:9764 with SMTP id 98e67ed59e1d1-392ccab2142mr293452a91.18.1786358934700;
        Mon, 10 Aug 2026 03:48:54 -0700 (PDT)
X-Received: by 2002:a17:90b:4ad2:b0:38e:740f:9764 with SMTP id 98e67ed59e1d1-392ccab2142mr293391a91.18.1786358934218;
        Mon, 10 Aug 2026 03:48:54 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315beb87d3bsm44052076eec.14.2026.08.10.03.48.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 03:48:53 -0700 (PDT)
Message-ID: <0cad6db7-ecc9-4051-b47d-148365d43ca8@oss.qualcomm.com>
Date: Mon, 10 Aug 2026 16:18:49 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: remove unused
 ath12k_dp_rx_h_find_link_peer()
To: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>, jjohnson@kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260803010532.302038-1-miaoqing.pan@oss.qualcomm.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260803010532.302038-1-miaoqing.pan@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDA5NCBTYWx0ZWRfX0z+4/9XiKiFi
 mYSQQttR7JVqmqoY/Z5kXmFGRf87tbAgSlOVl7lO1+spaHsr4+bkP3LIFZT4zwmJh0px99+cJOz
 m5Tdsgk8TeAZibG/Rf9zCDKUKdum/BQ=
X-Authority-Analysis: v=2.4 cv=J6qaKgnS c=1 sm=1 tr=0 ts=6a79ac97 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=-fi7bus0BQzjAAfoSv0A:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: gFwPf8me5o3Y8ChOsfknsabMihQwxoZi
X-Proofpoint-ORIG-GUID: gFwPf8me5o3Y8ChOsfknsabMihQwxoZi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDA5NCBTYWx0ZWRfX4F4UrzfG3FgN
 V3gbJaqk8oor61dio1ypmidIFKQMbnB2sPKZJBhXP5ctKrcmISEyvuTELgt2cfMUQ3YrUYhnoqB
 /N8L46kHhvCITDowitk+tynUtCCwxLSvdQy+Vp8MxOigCyTipOoYzEnQtYYTOdMIOjhYOhjCUhf
 tVQ7lJD3worneDD3QZCC2QVobCz/kAGodvcpBCH2jnyWtPW6Rx2UcvSeKnyS1yGMj/O1w7BypKY
 Wzx5dRQ35ff1jAa+AehnDgg70XGU5cyVdTdA1MrDpzceHavbfZi5qBEUyukGXjG8MgWU3jnCmdO
 YTLCEwIglR3jIASfaEp+F1OfyQj0yIDEKy3UbB4jcGdb6vdT+2/u1/zyeFzZeO7lXW3hOuMeP9n
 qAA2cXT0JunEXfLhSyJ731w+pQTzkGAX8WeN4cnPd/jET8auTBkR/vdXRU9Wv1B/Bz+7l0cghPl
 CJfhq9YgntLoWnt7xdA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_02,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 clxscore=1015 adultscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608100094

On 8/3/2026 6:35 AM, Miaoqing Pan wrote:
> ath12k_dp_rx_h_find_link_peer() is no longer referenced anywhere,
> remove the unused helper and its declaration to avoid dead code.
> 
> Tested-on: QCC2072 hw1.0 PCI CI_WLAN.COL.1.0.c2-00229.1-QCACOLSWPL_V1_TO_SILICON-1
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>


Guess Tested-on can removed in pending if needed so,

Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
