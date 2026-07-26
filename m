Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81767175A60
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 16:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785082295; cv=none; b=X9+7OCCCe7Sp/qCRAYC3Gty+nRN4KbpeRniLOSBUfM2rjOdzsH3cCqOVt2RG8yPmZ1VH/80vogJ3cVL/KEcTGg2fLiRgcNAEBf1xX8wLpTixZZB7pzFuD1Xu1Wh/jAhfxIQ5ElSaqG5cMxlhxG64Y8xud0SyoKs0sKvz6nY5G80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785082295; c=relaxed/simple;
	bh=9c0ETF/rLN9c01SpZU1pE47KJFuKxHl9YfFdWAgHuIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IqMkvi7HU4XPfRvSgvBfIkcBNOlVRQ6RwC3cQP26zByvllFc7O7elgovtJNP+Iysryn8tXNfh3HKsYa1+WfWIkJIJ+cP1+BVn7aKgtt3OZb8IYjCYNyaFsV+vdrf32pwGRWxyWqzphA+y/8Ns9xNiZkwuz8OLsY9Su50NgoTf6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UNWGoT1t; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VzsA50kO; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UNWGoT1t";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VzsA50kO"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QE3B8J993530
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 16:11:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hvwEmSyQIGww0XlGQdHEkIz81uCW1CTDp942jJRkrxI=; b=UNWGoT1tZPlHPpbE
	E4SjtJdQBE7fAKzsFWBFTnULAcqLAbcDe7TUhxMQZ2zjiHMl71dN/2xDB/ad0WpV
	8zp/622Mg32amV83Vgx2t9jOv/f7cuxGS41rv21SJ35xRSXwzuV4YS/H5pxvfjCv
	fvYPAXjrMEvj2HEcxn1grIK72URhwv+rTCQ91fkKwqGuAMEWfVVm45XerrQdWVTH
	PQy19fAzGsJs84sFizYDUe6PzjltyUkdLL1OtkWBVFq1gbmi2SLltiF9Yx+VdcX0
	Lk8gR216sHpFQoQsU6WTBjniw9oAeDw5fR0izX4lYRQN70MPqUScu7do9R5l3Vl6
	8SHKVg==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fngysrgbs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 16:11:33 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cc88e22f92so47342085ad.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 09:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785082293; x=1785687093; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hvwEmSyQIGww0XlGQdHEkIz81uCW1CTDp942jJRkrxI=;
        b=VzsA50kOIfDjNMljuArF0To4G+hcr6Yz6lV7BnFq/SCDkd2EzqgcVMNicifjQsK088
         j5CDvT2uK/YmojtW9LOlPPLckur8fCGVI1f5cxI156tW9zHgZXCiKVYZf/0vUJWReT+g
         X1qsMHan9pKcaGgZ3XYQPEQ5UwL85/gYns8AljtoxhqxPM24e6ZHCksSlFomsZ+cVE2N
         5BLc6FyFU+8lX4dKiUclb2VxljPPtD1A2geHE39hu7XN3vG7B/SLtXFDj8ScbysIwyy4
         UZ3fp8Ge3JkWxr+r5ooWzaxQc03f1lKVotuHpVsBNwICOn9Ri4VAft5gFCk0FQWLilpl
         qkNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785082293; x=1785687093;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hvwEmSyQIGww0XlGQdHEkIz81uCW1CTDp942jJRkrxI=;
        b=VOAa+07ZTkdio64wF0HR6jSzs0Msn12NG2mFZY4gF8FAxRD3eQfMEEnNfM3b5rRt8H
         R6L9e+00wJ1yxtbZcy1wIoxZNDi4F+akdYapyFpLGnud1aC8iSt8SAIq/3Da/tcLxTNS
         2wnLgozqZ2pirsGt0iy5Hw7w61p2fRlUL2O2uc3yfdw4fO4fr3qY9jA1DuOHVYPnmMJO
         Agr4k2PlvGZt4Gy9CZu2wy7URObOxxqOsAq7V9DLVFLJMNQ/Cv6f1QZZ6c4SrIPg5rSI
         aRxN56WneMKj+wHwa3WaGHwBr+LnwJgpYTois4LlNhV2SpeoLd7dblivTiVxOJu1oM/w
         8FPg==
X-Gm-Message-State: AOJu0Yz8guwdrEN6nO5NQilMTyvW0omwyGyqEQF53m0KHt8WB4T61K5U
	ihCNEFXLiq1/xnNj8mcODiVQMkW4RJLYuIoS/XqBu9POdrlVdH3spjBG5fIBVro8RzUzKbYEA3i
	N3/lPJa6Ubof5hE4giwYNUrztHwtXqBs3ZyrILr4eCba++Hz4flABxRqZrkkx5iZM0WmD+RkqlU
	/iUg==
X-Gm-Gg: AR+sD11uhHGT6XaVfRDkd26l9n7Ljfj8cHjN5KKrRv5XL+rf6jHzPZ2kkgBQccXZViz
	QMFkv+7G32qdQoyODfORsrpRKlDWhxg36vP4LTnWN3wDP7teSkQ9ule4gMiQshgo0wpzLgk8H1w
	KXrpf9A2aCVWjiIT1BRV4vPdzeRhZjiLMY0NcHdoTM+GVloVVCFyKskeh2Olx//zDybGx8ZRSY7
	Sp4me5FPiUtDvWpd+x2wD3CfR20+EdrOHf8U91fbqC5n+1jg4pWreg69dlvebNjUKTxRzOAJWJj
	hInSkJNjxTKFRd8qQROE9dGonuCw0fVCFY8+7+c0HR1rp6njlj6BlECHnPqM+9oXlkpP44dQYQH
	VMdidEvcX0QYjdsfFI619qT77Y3552Ic4p0e3+8j2JDnsCVApSjIJUunWFw==
X-Received: by 2002:a17:903:19ee:b0:2c8:2808:3ec4 with SMTP id d9443c01a7336-2cfde866afcmr49500905ad.24.1785082292995;
        Sun, 26 Jul 2026 09:11:32 -0700 (PDT)
X-Received: by 2002:a17:903:19ee:b0:2c8:2808:3ec4 with SMTP id d9443c01a7336-2cfde866afcmr49500715ad.24.1785082292605;
        Sun, 26 Jul 2026 09:11:32 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc3e127asm36386221eec.2.2026.07.26.09.11.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 09:11:32 -0700 (PDT)
Message-ID: <c455a465-254c-48e6-9183-7b67d4b76dc1@oss.qualcomm.com>
Date: Sun, 26 Jul 2026 09:11:30 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 6/8] wifi: ath12k: track per-ring RX
 sent-to-stack count
To: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
References: <20260723125448.922361-1-pardeep.kaur@oss.qualcomm.com>
 <20260723125448.922361-7-pardeep.kaur@oss.qualcomm.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260723125448.922361-7-pardeep.kaur@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDE2NCBTYWx0ZWRfX/g6u0cb7nYbK
 4IFDcEBFFFjkdy5DGvcRB/7veirTvT5jyB3slPnH4t02e/ce4SQYBBeCAAuC3YN2N8+xNfSb6Qf
 7B0sk82E0PWH3gsOHNTtEefUg/sOHnuQKJvIOK7ZggPw0nUkBn6QryzMSCSDK8M+3YVAFEumpZt
 huGB7HlbDYDcQXxjqO0SdWt6lvy+UQA1pnpvMNa2FlWbID9bK8N43FU71aYuWr0B9T8E33lRzUp
 UCBe87U9H8+6n70B9CHEFeRka4erjuvtxbpdYVkM/zJbIQF+WllIBZWZ40rTjUvfROzzry9BI4f
 Dz6+F7WlMCFtSW6i1gt/LO9uJsQO8s3IZjbc+94tZJO/I/3wlwo7ACFGdx/BjY4rbUAOJHOCj5z
 wwNtDFV2WZEEcORrNdTYr4iOEYMJQKIdcR3MU+v1bK7alvvwacyCJoBIq9I+8j0kGBfqZBIX5OT
 Qob+LVOp0y7yKYRGexw==
X-Proofpoint-GUID: vgyVBBlrqhK7tOHCwtguOxqLLVsaLUDa
X-Authority-Analysis: v=2.4 cv=DNG/JSNb c=1 sm=1 tr=0 ts=6a6631b5 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=RnYZJU0MdKe6MKTUfF0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDE2NCBTYWx0ZWRfX6y9OwFgN2SJJ
 BThHpmfwY8gAc9zH/csIUC2IVPkKq5Rhfte1TRHYvdH38thof1xMqcFtRwTJi0KSaSn6zjQmPat
 lz455QEiG8nSHzjhOZtvU6FCSd5YZsA=
X-Proofpoint-ORIG-GUID: vgyVBBlrqhK7tOHCwtguOxqLLVsaLUDa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 malwarescore=0 bulkscore=0 adultscore=0
 suspectscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607260164

On 7/23/2026 5:54 AM, Pardeep Kaur wrote:
> diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
> index b203513d63cc..33c4c89eefb5 100644
> --- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
> +++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
> @@ -651,7 +651,10 @@ ath12k_wifi7_dp_rx_process_received_packets(struct ath12k_dp *dp,
>  			dev_kfree_skb_any(msdu);
>  			continue;
>  		}
> -
> +		if (likely(ring_id < DP_REO_DST_RING_MAX))
> +			partner_dp->device_stats.sent_to_stack[ring_id]++;

My review agent had the following finding which I did not try to validate:

sent_to_stack[] is incremented on partner_dp but reo_rx[] is on dp — this
splits correlated stats across two devices' debugfs files in MLO

In a 2-device MLO group, ath12k_wifi7_dp_rx_process_received_packets()
increments partner_dp->device_stats.sent_to_stack[ring_id] (the msdu's
originating device), while ath12k_wifi7_dp_rx_process() increments
dp->device_stats.reo_rx[ring_id][device_id] (the ring owner).

Reading /sys/kernel/debug/.../device0/device_dp_stats shows reo_rx[ring0]=N
but sent_to_stack[ring0]=0; device1's file shows the reverse. The two counters
meant to track the same traffic path cannot be compared from a single file.


> +		else
> +			WARN_ON_ONCE(1);
>  		ath12k_dp_rx_deliver_msdu(dp_pdev, napi, msdu, &rx_info);
>  	}
>  

