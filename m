Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793841068;
	b=Ufnl/0BRG3VxRNqPGefQkFEga1QznnqiD9U9u+LhsB6eOtSI52+tglkFwlNvGr0Ru89P
	 /y2oMNduCCPSoA22emYU/tajfySyxfM+TuiezWdI3za1P0fht6VVtLul7iyr3IDrz5Sp2
	 KSAYtA5G6UeT9vV+6j4W2Q0/AlZyh0FV/wIGhLinRTDPe+MxZTayANdvOtd3A78qEOi4L
	 kH2td7uuSfxC8cCaMy+CN3FxysUMUV9LfAPpUCyDJxlU4zdk038RGK/VZGsx0+MBF1YRQ
	 FIr9pJlz2XqFG+P2APw6+XbzQaS6JcpOyQhlk9HRJ/2EoUDb7Dx5VJnGFzoWL5d/Skw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793841068;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=0+9YNlYKXmRrXqEDmXvMuWsb0exY+irNt51zBtdlK7Y=;
	b=XextUusOyHFy09xdMHzoS1jHP5Ik7kv7V/dwmUFlQbYnP3ccywhrsti925XRmKqGExtk
	 SyXTPPT51EWS5fSL6lymI0fz+3WLeJrEPvle4iTBEsU/Bim8CXk+TUl2zgayeuDFce+BN
	 PpQED+cERu89uCDp3nDdTQkH3N8ww8yTgu3QTqXrRPKQyJPZe09GtjEXmxdIh4TaZV7l0
	 +qknt5Ytj6C4Sr0UbaD39lAclfcVoYeQSc+LJjBreK9vO/Ofnl2fBRhPRpJXLLF8ZRmBO
	 ALUvk/rUPKFxGikTJ9R8He0FcCg7oFJn1Eeu8CTxe675rq9N5bSBa17A4k7doAuLHJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="W5D/lv1L";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=BtLtAw3g;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E16606A326
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 01:11:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45E16606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=W5D/lv1L;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=BtLtAw3g
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A50o8K33084041
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 01:11:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0+9YNlYKXmRrXqEDmXvMuWsb0exY+irNt51zBtdlK7Y=; b=W5D/lv1LWTCDzOWh
	0L/f29deMLoESFQnp2yCn5ZVcV0MlX/MEg+e52Nrz4slWpWiGd0Ux7/i3TYnNoZY
	0nJf3OXTs26avJe/rLFJPzvKK1Tqanyo9J/zwafZm3lbJ6M49KgkZgw4VmPqkzgT
	roO9cLBawiAvG9i59upiEQlPCoNKeXo9oRbCopMar2QW5DS3DwK4UFKuTqI+7he5
	k46SMFt3G9EMwsy+WJn+jcSzzI7k9uhmirobk7w/4b+3orKqo/VH1mY7vWYcAJLj
	LSeTdnI3hF12qQ9iScJTuddhc3RbTsOY8tyncbRm6DeAZUZLVYskS4YNyrCYecql
	iUqvAA==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hra5thccg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 01:11:06 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-36a3451ea93so1794966eec.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 17:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793841066; x=1794445866; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0+9YNlYKXmRrXqEDmXvMuWsb0exY+irNt51zBtdlK7Y=;
        b=BtLtAw3gPH5XHQOpwLcL7Oo921QmCKae5F4Rnn/AmJfFsqjD2c6AcC0A/VmWqpsI0k
         g20Sf1Rbxq6Kb1LhPrg1YVkL8/asObt1D3MwCqKe46MINve1tCNkB7uz20gc3T8H+vUu
         Aw5hGkNxvLgvSLPYmR3E8dLTA3oC4M26apOdVGi/8HPwRHYB3z0NNdU3ktXlxHz+I5uW
         xnXMzENLNC7TUs7EefAFEaWMsaYbPyFPnnrjZqArr3PlADdf0yjEQY4oktwBYDkRyV5o
         7F7TEv8wC8KNY2lyWDy7hm/axf3QGoFpYt5DvhkHpJav2DMIhONQg+6kwWlF9o9H1b5m
         A7KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793841066; x=1794445866;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0+9YNlYKXmRrXqEDmXvMuWsb0exY+irNt51zBtdlK7Y=;
        b=jUezJbtBegpdv0mFa+1iAy4YJYLLVCxIv2sjp89JhYIWFufZP9a3brjVI5ZsFmLca0
         1BQYBMgdPqtZM9dCeBgaAgqsDj75wHyunEi2jTCIP2Z79eLJ4KkDRq2sfjXXlfU7d6my
         DmISVEclDss5CXmP8Dr/3irIdMyUnhReuDyyhHtYP7jKvGyUDAL5ayBrEA8XyJC4quzg
         97JaxIJwlvqHTVau6ApXin66e4N1Bdu9yretWX73BaW8abOk0ALHNCCFeW/yJYP1F1H7
         n+hb6cxEuXkksysMtqhJdnfImPU8v1mY1i2DcqCrU0+4s2h6t1AaqtUvQZXd+munXZpH
         WtWA==
X-Gm-Message-State: APuU4Z91lPmzCdGouU7rNe0ufSbJZmOOqwiwV5Yhmzla8X5K0qv0E5fC
	2SCpPFJRZW1YEWOzYI9hD+0PCJEeMhBdMg38rQvrl4YfKXHXpULQojtRieT7yaEjwjheGxBZsRL
	EiyOX0rjVkDkXM5Cm1KLqoq47s6gvHgA+KDRFxbrqetQOpCEIouMCc/zZbmF3PbykF0JEijQMqa
	m+zg==
X-Gm-Gg: AYBFou0Jc8KsS9oY8/LwhmQNjd47o7DXXDhtJa1SGxJIU9x+qR0/V1dHCKIkIdo82zU
	KRbvRSR2BzvrWSnk4fhmAIZ7hpyIL8crvXh6kbQ/+ahLeiG7VYlCLctuApbEH9IYOHd0hQK/Cy5
	wJ3jDOgrrjpwYyCr8jTHdK7BXJ7Q8SJQDQPvw9vBndDFEBJeZTW+PQiPd+EzCJfH7QcBX9EWZx2
	xdSsnUex9xpRcMzajjcl/51P/h9Esoz1cNZYL+ciLJ1Px/v9dzG+7TaYIVCSudYwTLdQmY/TRog
	iDUK1evofLgq0Rg5KfI825gr51IH9Ue5z+kYWulV7iix0ABxKauoUKfuuqtDhvAUWtuP3oBmV6R
	smNLW6uuQEdKu0PTb3GwoR33gDCKT6/NZCdE06o5ngDQFphPgr5U1c6RLwUMgPcuFTSu1I6YAkv
	rN/YyEXwdC1GbAlC2TM6kdVtw1FpciYA==
X-Received: by 2002:a05:693c:895c:20b0:359:ef9:9be3 with SMTP id 5a478bee46e88-36a4236a466mr25817739eec.11.1793841065660;
        Wed, 04 Nov 2026 17:11:05 -0800 (PST)
X-Received: by 2002:a05:693c:895c:20b0:359:ef9:9be3 with SMTP id 5a478bee46e88-36a4236a466mr25817701eec.11.1793841064981;
        Wed, 04 Nov 2026 17:11:04 -0800 (PST)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36db94376b1sm4190698eec.10.2026.11.04.17.11.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 17:11:04 -0800 (PST)
Message-ID: <61e49149-5096-4440-b261-ffe2d250f6f4@oss.qualcomm.com>
Date: Wed, 4 Nov 2026 17:11:02 -0800
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
Subject: Re: pull-request: ath-current-20261102
To: linux-wireless@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Cc: ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, jjohnson@kernel.org
References: <8e38f8dc-88f9-4974-8f98-687795fb360a@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <8e38f8dc-88f9-4974-8f98-687795fb360a@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDAwNCBTYWx0ZWRfXwZfoDcNImMDZ
 f0s65/VYsAO6dRMDw88PAOmSuSSRW2YcZpPoNlntO3k+nVmYFUFu1+hlOgeWBs3OaLfpL2gLBxu
 kKbHTBoXKUk+7k4ii3urKhOr8Q0zR1Q=
X-Proofpoint-ORIG-GUID: wwgOovdEk7H6Fd_IoLPfEtX5swFVgbc0
X-Authority-Analysis: v=2.4 cv=P/6vFSAu c=1 sm=1 tr=0 ts=6aebd7aa cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=uPsaRaffaKHOGCdRA0sA:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-GUID: wwgOovdEk7H6Fd_IoLPfEtX5swFVgbc0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDAwNCBTYWx0ZWRfX29AJS4hHNqsG
 e1Zuu+EGjXYrfEEyvDc9H0GcNs77T9rhw6tP8ESHPrkbGW5S+M6062yKUyLNrbq9DdC+oCIu1iN
 HPqqL8r4VXa6ebGkgY3X942z9gd+s78WNYZfj7nTnkbEqUfaEDEpJCgWmolhzwPzbWZ3J8T/aHm
 mqKxbh8f5Waq9aI+EGBUzWw6K2ne2ulibUu541LtH0zJUYAGKa2lbrx7jiuEwR2VwG0C11aH2JA
 +PylHc8XyZgYIBHllYNfGGoS59RycTtOXsuBXlbMHfXNFBQmiXw3t63UxxpT+j/HwwWFmx0I/8S
 XoMB4PViVd0Oc84FmBIpHpnrqmNIuqa9K0Sb6/gC+fgiUdnIpdexnHRES9DOCi5C8+WbIfx4vy6
 k8mWFPVsBxwHAE05hr6xJa8c5aEWwyAbSwBj6rZ1msXXpt+nCPa9uAtTv5Wtvw/sPT5RFmcYUgi
 ZdS7+4GoQDP0G6UujfQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_01,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611050004

On 11/2/2026 7:37 AM, Jeff Johnson wrote:
> The following changes since commit 25e73f1d6868c759c8eb56cad4e411692c5341b4:
> 
>   wifi: mac80211: reinstate IEEE80211_TX_CTL_AMPDU flag in ieee80211_tx_prep_agg() (2026-10-26 12:20:45 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git tags/ath-current-20261102
> 
> for you to fetch changes up to 83d689bbe8f90ce39961bcc3a64f2ca2ec184019:
> 
>   wifi: ath12k: don't advertise EHT-MCS15 to firmware unless we support it (2026-11-02 07:16:28 -0800)
> 
> ----------------------------------------------------------------
> ath.git update for v7.4-rc2
> 
> Fix a few user-visible issues in ath9k, ath10k, and ath12k.

Johannes,
I missed the window for your wireless-2026-11-02 release. Since you have now
fast-forwarded I hope you can pick this up so that I can also fast-forward. I
have a series that depends upon a revert that went straight into Linus' tree.

/jeff

