Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD64430311
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 11:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785928441; cv=none; b=WXznJDOi6fVOWgBpYDKn4B22XMd2lB+1zgh8cGOqrFm9ZhosT3AYiMyp5u5Qs4jtByiQ0mDh8HwN6Us5dmDblzsc9PbN04Rr+f6SDHL2Cz0pa0lyyvCx3ef4K3El7vWCRbHumOY8C9qeYhv85rJRpZPGFOqQPNud+6aBOIZTCLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785928441; c=relaxed/simple;
	bh=q8/w4lChJ6OQzUKxOBoVKhXfcKhLZemkbuoK2F6v5u4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lb97UCiwjBEBol39Lww7kAFhXR0OFixdD9FoVlRpRx2ZCzY8LZJndQFtX+gcWfacpqAL+i3ngaTJQX9JVmz60PUKaqoSiC7Iemnd4skhhnIEZIlE1O4r5s9GLwYpZNr2juDGZgsVxwmSczU7gzXAT+QbP9dmPHoHtoROFawkrs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YwXgnKXA; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BfGZaEUG; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YwXgnKXA";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BfGZaEUG"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6758deds2669688
	for <linux-wireless@vger.kernel.org>; Wed, 5 Aug 2026 11:13:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	8LelaXGTz4XL4uLm+4h82aJhDgN13LzRGBgOFWlPLZg=; b=YwXgnKXAlAnjbYt2
	cmzHdV8r45lCfnsRC3W5z23np+q46DCNDEiCs3s0A7wnHJ0deRwHq2DDOUngXdTM
	VyXuch6kNuzHUbAYpL81yz4JoT95csry9JCuR7C+7zuL9lNxwXBiomWD/83JXYq7
	sVlqSBWMqaWv6kAVoQXecu9FyoZUIul9fu+ahzphqMqFPRyAevMOnPxp/jCFO7Fc
	R9KVPeo/UWnQaXWGuhw9CvBZFFf3Y0K6g2FHP+LcvrcIh7TTrpFBLXqSXPpnC0tM
	Nf/N9YWM78icez3QD4lSmS+T0W6zA7dEOfRyJIoUrb5RAXrJnJsul+qyDSFJ5YUh
	sJif9Q==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fum3qc9va-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 11:13:58 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c96b4f58ddcso763302a12.3
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 04:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785928437; x=1786533237; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8LelaXGTz4XL4uLm+4h82aJhDgN13LzRGBgOFWlPLZg=;
        b=BfGZaEUGK5CUJueeUoHyIjdSvyiKzI/dPC0rEtz6LdoUzs4TK5x0tjKVcJb/ggyjrC
         YGreS1tQm42qiXd8EFK1bLE+j5UxjSQja9YMgN236flfSNdHQeBUSt9cI913+xqo3W4l
         2Pm2idpG/ybbxC46lO9BDesyBgmcegSwnNf6pAMLQJVa5heT56M5CXHVh5MkQ0xnBZYq
         E46R5MaGMfLh6OzZUTAFtMBc9HvRgmTVn4JVfdXyYpklpnLp0eTqXmNQ1O6W+i9e75NG
         6tC+Ml+902PovoSSKFaTFeTXGBjR33ofXh3pI6F2jTttW377F+Q/EziNA9/Fp8Lz6+Mw
         FALg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785928437; x=1786533237;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8LelaXGTz4XL4uLm+4h82aJhDgN13LzRGBgOFWlPLZg=;
        b=cri18JCEt6G7S3sWfmp73aCJ/kq3LMiTlWLougmUfylw/471fRgLNPMnexlSBCNVMO
         N5lWWNCddkniJhZfSAYgaTS7E/hxxukLPdNhB2xqNl/m7o1vpgDqQl3LpdTCHO5WSBL0
         NAKTrWxA27wDA++ZWGi0a/5UyYWo4yo31WVoY71HahOCcnyJSZ5JnIsdjDlM/TL2yyyj
         b7ojGjtyLeeE1iTaFXficUrGaaFUXUQkFDoPcD68b8ukyghKjCRvSH+C5fGy5AMGKBSg
         8NnC2kFReh94IDPlD3cpX1DoQBOYCOiijwgcoBicEob1bNGCJdgU91PizzhyLN9gwATI
         tsMg==
X-Forwarded-Encrypted: i=1; AHgh+RqyK0NoZHonlwSiL1NHna8b5d/XTZnKRcFxi59MZr2tWhNVXKB7ltSHzvvwDZ6dh360KSEpROuW0ytN0FUPbA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzxWEBNfpXEDa07vhjZuvXgDfgFc8vpSovLbq2tOh+NAyv5xzdO
	xAqBAlPDTUeGnaWXuy3vmzIMXuLovxYORtPPhsR0KTDJFAfOFiOsGAoZJxB+tOeqTWK1uHQpYvQ
	1LZu56mwM/oZLypeWqC69koTwsYC7E6RZYUcxlpVpbpje2JcZOTAVFVNewOiBBmdUA24/Yg==
X-Gm-Gg: AR+sD12JGmVk9F1KmblTZmWL349Sd0WChxwFFsaOKn8Kwl9gtYAJVbMcbL/bw1+Mfvh
	pa+AXI9vSzWesO6/rsTK7G/sKDenxFnHt/EMhC3C+gVmojIunfwwh5z2+VU9/b679M3qLpcnOfW
	w8hBMUIlSgLm28Ne9ZDul+eBFwL3nZrxG6pHAgpGU2rrx9PkugRfEUJWk5hAfVBXBIowzjJhlZ3
	/0DHMv1/rB3Gm4ozLUYRh4OglsyNze7C1iasjLmZ9DJOqrdWX7FXsSplLj+b5tCfctg4N216GvB
	A7kuIQHK0K2G4l1obukcT1WjjMQRkn36W6HpF7vPKgmE0tbIxg150aiyOHxAmfzcK7RNKOdp16y
	qYyc4GVNGOmfRdPaOIP6lPY91FJmQyce3ZgLxhEkB
X-Received: by 2002:a05:6a20:4309:b0:3be:b0b3:3962 with SMTP id adf61e73a8af0-3cb85dee5ecmr6544783637.9.1785928437493;
        Wed, 05 Aug 2026 04:13:57 -0700 (PDT)
X-Received: by 2002:a05:6a20:4309:b0:3be:b0b3:3962 with SMTP id adf61e73a8af0-3cb85dee5ecmr6544741637.9.1785928437068;
        Wed, 05 Aug 2026 04:13:57 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31586447d52sm14481339eec.12.2026.08.05.04.13.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 04:13:56 -0700 (PDT)
Message-ID: <6c8b8587-8a7d-4e57-81c8-dbd84aa458d1@oss.qualcomm.com>
Date: Wed, 5 Aug 2026 16:43:51 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next v2 0/2] wifi: ath11k: fix SoC reboot on firmware
 crash on AHB
To: Julius Bairaktaris <julius@bairaktaris.de>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, baochen.qiang@oss.qualcomm.com,
        vasanthakumar.thiagarajan@oss.qualcomm.com
References: <20260726221908.104873-1-julius@bairaktaris.de>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260726221908.104873-1-julius@bairaktaris.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA4OSBTYWx0ZWRfX4sjR1xq1gHj+
 gvSemIWI2JWNb/jvgc6rAhrYklxmry/Q2lu1ZFz//G6btE/FRUMvyFbyCAIRFh3I1nAmwac5dIK
 B9dfwfOekkCZHRGbr39gUGAtpdzJGEhovdI22ZBaD5snMlnd51k3QjFotukc5kismjh0cgQPnMi
 dYpdXgTY0BhAkzCPSYnCv0hxisna7hKkfXX6iHyTv+OoXCQn3gIBBAImlKjpGZvoM+aaqahhFGT
 XMZR8F2NuYqyvkEWJj/M+aXNDFc3/jai5X88DuxABqnzJQbdSRiFNFyEy/lPOxbv6R1YZauUL0f
 UBigjXz9tZ7H6Ro7YIiGUgh8TDoOvi1hto5RGeyeOwMWSe1IGMGYBSaE6V8Zr/d9rwnF4csSamm
 r4ZancbIt9TiLWgzxw4xQ+IEfqLhD476oG9cwcarALmiZtowuJeAibM5J6qd2kU8UQL7lRku2Xy
 iJoOaIrfqyXinwkgWlA==
X-Proofpoint-GUID: 4GJZADl0Gwiq-aDsQitfNTDVzaHoVYvo
X-Authority-Analysis: v=2.4 cv=LsiiDHdc c=1 sm=1 tr=0 ts=6a731af6 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=hCEygx0HL4Tx5WVe8Q4A:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-ORIG-GUID: 4GJZADl0Gwiq-aDsQitfNTDVzaHoVYvo
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA4OSBTYWx0ZWRfX4wrno59HbxX/
 YeHYHIdsNulv/cey10nQu0CDkJitVQGXlIzZ7dL9sb2qXOjPue2O9B3Zx88o+Sg76FQi9F7LiCu
 TIEjZXQJM7B6kLnEhf0Ig0KchkZtRD4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_03,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050089

On 7/27/2026 3:49 AM, Julius Bairaktaris wrote:
> On IPQ8074 every firmware assert takes the whole SoC down. The DP NAPI
> keeps polling while ath11k_core_reconfigure_on_crash() frees the data
> path underneath it, and dereferences a ring the teardown has already
> cleared.
> 
> The interrupts used to be disabled at the top of that function.
> commit d455e805de70 ("wifi: ath11k: rearrange IRQ enable/disable in reset path")
> moved the disable into ath11k_core_reset(), which AHB parts never reach
> on a real firmware crash: reset_work is queued only from mhi.c and from
> the debugfs hw-restart handler. Patch 2 puts the disable back on the
> crash path. Patch 1 is a prerequisite - the CE half of the quiesce is a
> no-op on AHB today because the bus never implemented the hif ops.
> 
> Reproduced and fixed on a Xiaomi AX3600 (IPQ8074 hw2.0), with no
> out-of-tree modules loaded, using the debugfs simulate_fw_crash
> 'assert' trigger:
> 
>    before: 2/2 asserts panic in ath11k_dp_rx_process_mon_status() and
>            reboot the SoC
>    after:  3/3 asserts recover, 5 firmware boots across a single 397 s
>            uptime, no panics, both radios stay up
> 
> Note the debugfs 'hw-restart' trigger does not reproduce this, since it
> goes through ath11k_core_reset() - the one path that still disables the
> interrupts. Only a real firmware assert does.
> 
> Patch 1 is by inspection: it makes ath11k_hif_ce_irq_disable() take
> effect on AHB, which also fixes the existing call in
> ath11k_core_reset(). I have not managed to trigger a CE-side crash on
> its own, so if you would rather see that split out or dropped, say so.
> 
> Changes in v2 (no functional change, review comments from Jeff on 2/2):
> - separate the ath-specific Tested-on tag from the upstream tags with a
>    blank line
> - use the standard kernel block comment style, with /* on its own line
> 
> v1: https://lore.kernel.org/ath11k/20260725141757.1316877-1-julius@bairaktaris.de/
> 
> Julius Bairaktaris (2):
>    wifi: ath11k: implement CE interrupt enable/disable for AHB
>    wifi: ath11k: disable interrupts during firmware crash recovery
> 
>   drivers/net/wireless/ath/ath11k/ahb.c  |  9 ++++++++-
>   drivers/net/wireless/ath/ath11k/core.c | 10 ++++++++++
>   2 files changed, 18 insertions(+), 1 deletion(-)
> 


Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
