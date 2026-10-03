Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE02E392C48
	for <linux-wireless@vger.kernel.org>; Sat,  3 Oct 2026 23:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791068840; cv=none; b=q6+qUGtJmqcTJdxxNBBh/jw5lovZfFyv0OAdXTXk6dtak/TH/57+pnMLmiZT7wyNoLCi4YF9pVIWP3TCU8Z2L427AtUHcG6q+5KbCdZz731za36nKE6E3Qbaoglr//BgxocoKSKqjJsfNS7+DvnBBrMQVhD6E/DwHhRW1D/CWNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791068840; c=relaxed/simple;
	bh=+ZP3oqRlxjLVmO+DUJ3oEqSGQUnarK8pMjoPSrpTcak=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=o7NPKVLWuLP1IKtazNJw2coumRQblDxGF+lFtzjTLIHgED9hCm+Zdxg7QSc3j8iuP0ToQXVCrjE8ij4JxVz9OgZVtZrLZY66B+t2ZISFfLKV4DQcUicTCGPI+2s6hTFDpaJCQAdK1LIkE8UhA7lbpwT8itKMDkC37COEPLosIx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lSH13pZt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SwPIOlhw; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lSH13pZt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SwPIOlhw"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 693KoafX2257342
	for <linux-wireless@vger.kernel.org>; Sat, 3 Oct 2026 23:07:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Ui0hYY9c2dDrMn8vS9nrlZOGWWpwY017RHY+Hel6dAM=; b=lSH13pZttf35mQWf
	MYIc27VMxijuPxdMaVIx80xKijECK978t9wicQaocmY9EuUTTxXNa+DjmaEHWg2z
	4/Mon90o9C6sJgl+OEf18NNtRe0DBeWKRfhXhflcw7NnUXGrSNxQPfOWtW6V898S
	d9Wf/vSiNs3eSqjDa6Gr47DD17uR6HL+6pKqQ/i9tOeNgkSFVbYx4uY1JAm6hLg1
	hRjYMkhlQpoHiGPblOaJGxXPeThAeW8UWHYabzKBqDwtgjRZOaFQ+XGW7dBeWAyo
	64Z4Hjc7gAvEFgxAajLCMVkLc85QeFKmJQjt95gxH+2yFm9qus599OpzaQpFDgz3
	tET4qA==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h2ssshy62-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2026 23:07:18 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso564749eec.1
        for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2026 16:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791068837; x=1791673637; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ui0hYY9c2dDrMn8vS9nrlZOGWWpwY017RHY+Hel6dAM=;
        b=SwPIOlhwBg2FbmpvQinN0AL7Ej5OLhpcQYrybHGq27BpbWI0iqOBb4zjwUxBe4Kmmb
         KJ921mq6DgJue20kJZgwa5lUInBki/GXu11CQnduzNM9irJO+Nw9L6Cii9sq4ee5HAke
         /jp/r/lQi/rSWicl9Mx3B20VmolP3Oek5swiCf6EASKwXIdq+c6XA0aEvfGn7gEsAK1d
         UiwdDHKnom0uj+fovV4/MFb5YsdWA/+Q2TRg8ObKlMJ/Ph/UOWEO+v7R75zpUSGqprUr
         JUHY6Jt/bXOE/40gpD60TvtJuCZEtz5Ov6pklNctzdKYjpXDWJaFTZWuK5E5hIP+vWZq
         pEdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791068837; x=1791673637;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ui0hYY9c2dDrMn8vS9nrlZOGWWpwY017RHY+Hel6dAM=;
        b=1D4whX6eb2GdPjRcbCeP39HtRMDfv8L4U43nEoAghhkCviHOuFEYmzL8AcIiQ4yOQf
         VzqlaP7yMU2zJn/gpjvYOmEp46xcpw2V06Gh0lrjBymyYJLVLnGEG8WHo7lA4UOXj/U0
         c+s5+HjOn0su6XEOwooFkx0bQnK7UcZM7Q7DscEKkrEqSd9Dv7IgcvGne9WdcdaVL562
         t70I4hAPsvMxySXIynkI7cX4pFT26n6cxVGHJcMxBOvgnLtchA/o1wqvOYxWV9Fmsbdb
         o6GS9mncBIhvEl5CCXU8X9Ajl7kUdDi8KG3a2FuSND0VY4+alctFLvdrfUT86dGQ7996
         cr1g==
X-Forwarded-Encrypted: i=1; AKwUvBzNGCFsrAU/X82zZ0yJkLmjNCFRBg0I8bDRhGAkSLeGe52I/psWughZr4TqRH85boR/EKH1hAT2kMfKdED70A==@vger.kernel.org
X-Gm-Message-State: AFq9FYL3zjGqdEsE6Uywz4WSj1/V8DBOeM4iCFYsztbfOSMdcLCGkw1F
	TYL1L+tF9EY7noCYsX0+5ZHj4TnW7mwEQeDilo0wQ/K86ttnIM46s//k3Z5o+WMd7R6ryzgEN6h
	JBO+pcMog7oJkyr3NGKY+2iEpr7yAvhb/AyI9ZRN3P3fdZf+ShV7uPXO3pyF3dcEb7sUdew==
X-Gm-Gg: AYBFou0DGh+1bKP0cTW1aK6zJRyjzOzmMXJKYWzf763naKldwFfGKXzeMtxGi4/wEoE
	BKWrcCs+oA5UznmNMYVQcmWT0znaXAWVekWI4inoa/QeYh4SkNNHZsojiTdZgGY69mwKmtLLMmG
	aTSsbVeTHsNX93wVX2fZSnqv69nd9nyPevf9Hr1bQC+X+ym0YOJGhvbTuZyijxM7cmfjvoSbvzZ
	04USSthiBaGsNrdQ1HpMEl94OGeMkjfW4GLQa3kEtNPNDpa1DSsfx/96mH+1any6FJxlJUo8oDF
	o4o/zs7XlYElLdmRT8Tb0JpkeJNKDQIKHpICWHEXgB+U6CfzUOUPQZ+2Usja1puA9c21jnZzndH
	5c0pwQIqmb26xxpFKCjZoYJHTosea0c8svP8RwAVagSYZtXcdOjhGYQswKw==
X-Received: by 2002:a05:693c:69c5:b0:34c:45da:9b5 with SMTP id 5a478bee46e88-34f150c28c4mr7992620eec.20.1791068837113;
        Sat, 03 Oct 2026 16:07:17 -0700 (PDT)
X-Received: by 2002:a05:693c:69c5:b0:34c:45da:9b5 with SMTP id 5a478bee46e88-34f150c28c4mr7992596eec.20.1791068836529;
        Sat, 03 Oct 2026 16:07:16 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-351271612e9sm25294eec.12.2026.10.03.16.07.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2026 16:07:15 -0700 (PDT)
Message-ID: <dedcc778-3459-4f08-86b2-55aac20d3e3e@oss.qualcomm.com>
Date: Sat, 3 Oct 2026 16:07:14 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] wifi: ath12k: Reserve space for a string terminator
To: Jiale Yao <yaojiale02@163.com>, Jeff Johnson <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Dan Carpenter <error27@gmail.com>, linux-wireless@vger.kernel.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260926121250.3258285-1-yaojiale02@163.com>
 <20260926121250.3258285-3-yaojiale02@163.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260926121250.3258285-3-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAzMDA5MiBTYWx0ZWRfX+Y5CNAQh5bn0
 2sMXypOIIgCD925sjO6vZBVPy1pP/YFTX8UyDop5PZ8dF/PpE1lMTPDTNWXCe0Xc8uOUyaBU1VW
 0s/pup7yht6BvpOi/thGId+4cVFi3UE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAzMDA5MiBTYWx0ZWRfX8Xl9qqbrOthT
 LwGkXjrug5QfWRFCkp9aYiW7cTKEN21eGBjnP4O6PKjOQCmFRc7cnsLM8QS0bDEQZ2FYcBnTl+2
 syvr6KQtMIEEybR9yzJhK7YYjk5tod/ZaK8beQCZxkkiscAySuT63fTdrXTCtWTuZQMxf6RbD05
 rmrToyHxT8b0ST2T38tYATi5CQ0QWO9MsyR2d/jw/Os+Zhn0FwI5CiY3/FJRMrL5ZkspfFe5pvH
 VCc0UU8QnqXGhdepzv6gOvyGFmh7tear6KfYqFpzMWpKjVdXO+Ns4kYhdKP4u+fZdRBHWPjHgWt
 d+Sisq3ljMmYx0j3Z6dDugw3NcjQ37A3jOc/9KSoFX61Mj5sFr8D4NyiO3Qf0yCe45FgFTLN0ra
 GZSPeFrRSyrc9g8F800Y+azVWcglu47NgnF8sjoUe9RP+CUz2zh1F2s5OcV06Z3c6ZxIYuPvPJr
 mxsEFhP0nfy/QyMMR1Q==
X-Proofpoint-GUID: MIlkdv5ayI0fCnKjv46rvQAX3SUCboLD
X-Authority-Analysis: v=2.4 cv=HqjjiETS c=1 sm=1 tr=0 ts=6ac18aa6 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=bC-a23v3AAAA:8 a=Byx-y9mGAAAA:8 a=JhsGp5YEgYEiw4z---oA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-ORIG-GUID: MIlkdv5ayI0fCnKjv46rvQAX3SUCboLD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-03_04,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 bulkscore=0 adultscore=0
 impostorscore=0 suspectscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610030092

On 9/26/2026 5:12 AM, Jiale Yao wrote:
> ath12k_write_htt_stats_type() accepts count == size, which fills the
> zero-initialized buffer without a terminating NUL. sscanf() then reads
> beyond the buffer.
> 
> Reject input that leaves no room for the trailing NUL.
> 
> Fixes: 8c7a5031a6b0 ("wifi: ath12k: Fix buffer overflow in debugfs")
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> ---
>  drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c b/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
> index b772181a496e..f84f1828275a 100644
> --- a/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
> +++ b/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
> @@ -6190,7 +6190,7 @@ static ssize_t ath12k_write_htt_stats_type(struct file *file,
>  	const int size = 32;
>  	int num_args;
>  
> -	if (count > size)
> +	if (count >= size)
>  		return -EINVAL;
>  
>  	char *buf __free(kfree) = kzalloc(size, GFP_KERNEL);

Documenting this was reposted as a standalone patch:
https://msgid.link/20261003095913.575108-1-yaojiale02@163.com

I'm taking that patch through the ath tree.

/jeff
