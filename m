Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0111397
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 23:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789083398; cv=none; b=EGGqKd2mFHwJn0oa0kyQL6DsgRPoEkYRPb4BtxntD6pXaZaljMaBtGr3I4Yjs2RzQJdW6JC8EDPyY/m9TiYlr+9AjY9BQS93RkGVdvBINajpwZUUVAh6O4yNQg5Y0SkBj3fjljlQO0M4tne/ocqKdrLKiTeVu63o87periNkjzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789083398; c=relaxed/simple;
	bh=epgqlBySMN6w/cVjDW0RVEJKWkmkN3AgYj4lnrkHhCQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kA9QcdFFUZk/S4NAfYinPbWPCNO8IUYuhAQw5vOrEYDnzspet4ZY+08Ybthg6awPurQBcGmbBwbSviyss6zrZpsYvzx+kR41QIXsfWsWWZN35Vt0iV09grcA5CUfT2j0Zov0ZXrZxRJMWsbYyh7ds7GNbCqETqZeooxq3Ft+1Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VCwW5ekC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BGhZeYdt; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VCwW5ekC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BGhZeYdt"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68ALU3ej972552
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 23:36:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1+vvzCCj9uIOCMpmZMgB4cBfFQbtwALqKT3eGuMlqX0=; b=VCwW5ekCY6iefRfk
	3Iu3HlcrVCG3NeqQAqI5HYNLMG/AvMpzyzOQ9BSzngOEEMKO3qP41rCgJ3ZzW1QB
	6CVXG7veTJwWm+38u6NzMAVWeaqdoWN2b82jh9R0iaGKYs7YSDQHA0N1gCxK9+9D
	Kh0wdhhvh0zyhABDlEoK5l30FjfuQyyeemyobfnKX8pXZ2a6J8Sj7mYdhSnDQWtm
	+3xOrxbl8pjro79dvDCnx0kpCJnCxBqYf9UjfppjMs65x24ycWX3H6yD/3SoO9vK
	4poWOhJ50shWQ1mx2cf8YG03CaonSulaZJ+u6AvUChGzzvEJ/cVLbf7CCaX9Ss74
	XjlTog==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gksh8umg1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 23:36:30 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39d865b11b4so317843a91.3
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 16:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789083390; x=1789688190; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1+vvzCCj9uIOCMpmZMgB4cBfFQbtwALqKT3eGuMlqX0=;
        b=BGhZeYdtVFvG2Om9aqg9N6WSev/KVO+p1GK2JnJsGFYvYujTJ9D5nwGdgjMFxzC/S6
         rSIa3MmR1gCRn0uMolvZPO7gpf+UwP2/rRN5oCcF+jQ8jnedduzj1RjbiSmUn8UqweZH
         1XaYPuuEgy/oCmBplJvt8W4TFsK/Vc2Ondm6i8sFPxtC0tYgbSGv+peCxQRAg0EnEtO/
         HFiqHARyu5FqexdobOEEUO8Um9QB4nMW8nEMzgEHFVFbhbKcM3XJ/6LNjpUw3wFWv2aF
         n+BPq9TDJYMZ7tl4G+dw4N2CVVYYhy6YRLnEktzotoXZEsiYQUVracChOPAEPuApl9mE
         7YFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789083390; x=1789688190;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1+vvzCCj9uIOCMpmZMgB4cBfFQbtwALqKT3eGuMlqX0=;
        b=T0z9yxexuIMkvXhRFVyUOt+r5JCFIh+9weqfxB9a0zLCD65lHjribRehONQmsjGA1a
         sfWExop7WPc8npx/j/BVQD7+8B1XM0F4x/+iDQg0MgVJwA2HEemxWvHgl2ZsoJ3qgVk3
         bHOjB6pQbRyy6jGzxd6pA8v23HCm8fusFyYi4g9sQ7/aNSCpxkXGR1tFr1/FaMiaMXWT
         72Hb7KGiGAWbhCeh9FyCnL0rdxs5zuZ5b873+mjY8wifzNf5UK8p72HoixKxskDeco02
         puXphlW99Wlly/VOeeZOsqyz6ysdX9dWde7TOMHxXFL6X5B7hKSJtctXJO5c9I53zFzV
         5tRg==
X-Gm-Message-State: AFuF++n9B/+ebthk4sPNWi7MmCP8by11pgrkzxs8YUvfZhB1MRHKXXCV
	+iuAUHU8TiZ4fA7UKfO3FgMoruarG6wxZqJqxZj4XruawNECLHiipjGdHLQu2MRdxunducng28F
	1a51hdbll/6WT28+UISiQ7pXbEDo5SWW1VHqKRhhgPozGw1AmrmrVpXJ8u/Xv/asy7hBQlA==
X-Gm-Gg: AYBFou1J2WueIgSwbrNJ32BfK5he5HXoLFK71xBWtXR7IE7Uox/l8+W3BaWt+37X3mE
	MGQLv6BSQUQbZhomBeUg/eb59hrmLk1oXFKue65/rU/Uy8pFYLpFaCfhKnWhzf+sLsyNK8xEEEF
	/3klTH4gPTtwcTCYUkXE4OOvM63V3mgc5fwLr3Lk97hg1W/s9paugEFlChQjxFgyHdlrNQAiYxo
	OFh4cZRXVzhGb1tfMvbRpPOCs9Q3VoyB74DwzLZgaMXwdHugsgrWco5Tqn7+2ZygWjLQhttkH/s
	wbBi3fUOXx5dVwmJI2o1WBYARkxAgp9gXCbOkS9NabC8aBkndayA9dcEtpJgw6LLxpQYWkBMO93
	8xFM1uMuQUxYBrVGYqtiDw4HHt2AESa9La/cjCm1uHPuHY6iaV06PJlM=
X-Received: by 2002:a17:90b:2f44:b0:398:e86b:ce14 with SMTP id 98e67ed59e1d1-39d9c21f686mr1988976a91.20.1789083389985;
        Thu, 10 Sep 2026 16:36:29 -0700 (PDT)
X-Received: by 2002:a17:90b:2f44:b0:398:e86b:ce14 with SMTP id 98e67ed59e1d1-39d9c21f686mr1988929a91.20.1789083389498;
        Thu, 10 Sep 2026 16:36:29 -0700 (PDT)
Received: from [192.168.1.20] (163.sub-97-215-3.myvzw.com. [97.215.3.163])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143659a9a06sm1895630c88.0.2026.09.10.16.36.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2026 16:36:29 -0700 (PDT)
Message-ID: <f8563571-3ede-4f5d-9744-3d72b441a4b5@oss.qualcomm.com>
Date: Thu, 10 Sep 2026 16:36:27 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: wcn36xx: Fix potential use-after-free in TX ack
 timer teardown
To: Fan Wu <fanwu01@zju.edu.cn>, Loic Poulain
 <loic.poulain@oss.qualcomm.com>,
        wcn36xx@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Song Li <songl@zju.edu.cn>
References: <20260910020907.3353-1-fanwu01@zju.edu.cn>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260910020907.3353-1-fanwu01@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: QxzQUBZcesdXwtcBy3vtkYZUYLKLeCDN
X-Proofpoint-ORIG-GUID: QxzQUBZcesdXwtcBy3vtkYZUYLKLeCDN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDI5OCBTYWx0ZWRfXz6/rUspzdKfx
 G9mZEIbH2VHBsAqyRl9KD4+ttZi/7LE+S8OTlCdRaPSXckLKEwsCz/2rBK8fQl7E2Im1xM4DTmq
 NYZrN2Co3f/uekcYLUKYPnTtm0z/9tJIUQD9O/p7cpg1L5tpdoQURUK1djgdn1KjFALfDkcREqi
 Z0/dP6x7oWz5U/srnOjT/2KpceC/SAuUTstXaWbKexXucgkj4e11j3BTmtkNpxm+Q1lAsNM1yzu
 fBWqno7BjPFvLab/DohO11PZLKKTOUrY34CStWBbUUrZu4rZ3TULc7uj5OgoP0ErDi2Fp1lBW/N
 YgPiLcXGWMxH8au3FuUhsjv6bvZjZU4oV9SPvPAiPXo4WDGE3ngWB7D+AGMPr9iYVRyLkwBxpVl
 lZB2qpIQ4u7BJ+eGh01dnYR55XSBfLV943ULBe46W4SvvDneVYeZ98Ml7CLcTnKLeude8agr12U
 QLK5l7SFvBhMHQK535w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDI5OCBTYWx0ZWRfX639ImBQk5sMK
 A1VT5TI7/vrZCMft9KKYIdl/wfULJESx/HKeeRchQvRV049fLT7a5bTe2b1a+ob7TEFb/Xc7MRz
 3h3pssEiDftWNumjtHGjlWpnC8pnZSU=
X-Authority-Analysis: v=2.4 cv=a56lZkSF c=1 sm=1 tr=0 ts=6aa33efe cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=7QqFuFOOHQR3GLhHC5mhXA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=OIB5ShivEfEboS5j5kIA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_07,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 adultscore=0 malwarescore=0 phishscore=0 bulkscore=0 clxscore=1015
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100298

On 9/9/2026 7:09 PM, Fan Wu wrote:
> wcn36xx_dxe_deinit() tears down the TX ack timer with timer_delete(),
> which only dequeues the timer and does not wait for a callback that is
> already executing; the preceding free_irq() calls synchronize the
> interrupt handlers only. The callback, wcn36xx_dxe_tx_timer(), can
> therefore be running past the teardown and use the wcn freed along
> with the ieee80211_hw in wcn36xx_remove(): it takes wcn->dxe_lock,
> reads wcn->tx_ack_skb and passes wcn->hw to
> ieee80211_tx_status_irqsafe().
> 
> Fix this by using timer_shutdown_sync(), which waits for a running
> callback and also prevents the timer from being rearmed again. The
> timer is set up again by wcn36xx_dxe_init() on the next start, so the
> start/stop cycle is unaffected.
> 
> This issue was found by an in-house static analysis tool.
> 
> Fixes: fdf21cc37149 ("wcn36xx: Add TX ack support")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:gpt-5.6

Current guidance is to just have Assisted-by: LLM
https://docs.kernel.org/process/coding-assistants.html#attribution

No need to resend, I'll make that change when I process the patch.

/jeff
