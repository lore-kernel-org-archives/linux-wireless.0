Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4072750ED
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 02:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784253680; cv=none; b=pjeUIFdQQAtK5SwTJuwnM7Z8Etke3gxocxwcDxuP1q4aiJgCXffBozDK8UEds9UEP9h7kycW1+mLsGD1C4ygCjdngNAGsYon3QLRNqT50FwWLsWy2ANhO1LS999O1Yn1gHe7gembB/10FbtnbmH3QNXmujoNYC4g+g+OQ7FyQIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784253680; c=relaxed/simple;
	bh=1u0sVrnx3dz72gO0apyK91AOKZgw5ZTW/MJUnbsDJTY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ajpkvLUGJtkvBmUhMlIu57BpJCRkw0jBRki7GZr6dEseG+zdrQIFmJbAmnmasvm36E1RoEVCoqaEv1jeKHdo4y+pq2TqiSPKavY0CFdW+F975hGLvEloMWaFAXVgt46p+XxgC5MwbvMZ2DloMDJeKxKuC8pepcfX1EwzdNP93So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=E1MOqTea; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gnPjiF/e; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="E1MOqTea";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gnPjiF/e"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GNJ9uX011434
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 02:01:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	VV3mhsSZfLZF2ip/i2sUJrLvReBLbUH7mVtGvO8APxg=; b=E1MOqTeaEa3d2rbf
	WTqTYW6ejEI2xvZIEu+9Fz60OxT5haF2o7aH6fq36g/26bjHGGTytarPjIgVho1e
	sI4iGfbXXOzmyTEVKt8PuewF9RjGKU9/PwHVPTguGtzA9IKC0beHfChFis5MUfcI
	xwHKiHB1wCY+Fl37zjNzE2YuAGzAjUkvQ50Rl3U2dY3XJVDU/binU72D0A9BZcXf
	z07zqLN+1mNFOYtTL2ovjlO5o60B5wX+TWY8bw9Vxxm9uMyK7ByAdyw3h1nWqwFg
	/E1yEyKRl0hq1+WR8VCxS2deRwggtC+c8rWpCLgx1f5iIynChTs+bWBrzuL37S20
	t1rbeA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4feuex43y6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 02:01:17 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e095fd889so7869163a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 19:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784253677; x=1784858477; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VV3mhsSZfLZF2ip/i2sUJrLvReBLbUH7mVtGvO8APxg=;
        b=gnPjiF/eInmFhV74LSXdjoXuIwFJI5s05cTv40xCVgOT7POQcObwRZ98XpUSFYj6BL
         vgKEvq6wJ5C/Vrqc4Mx4Myegm8PSCytMeqq2IMeEMVx2EoKwkJ9vBykRCZfzTPAA7CWJ
         K6QX4Rsj35qKuO2CMmG5TwnIUwfA39UlwmLr35M8RObvZwhECsIEEyzK3Erttp5FZaXr
         sXEx6tp14EGHMshxu8Yz5/W1sWJCrtUM2oRsZ6Os+0CeDj8+knkzxIF/p4WZg2TW++ME
         q82Zn33JvHx1DAehrYOtw3VYY7uOBXugSP7pTyyVmy8EuQUgZZIPXRp3Xf3RtkoP2F/m
         KFJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784253677; x=1784858477;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VV3mhsSZfLZF2ip/i2sUJrLvReBLbUH7mVtGvO8APxg=;
        b=hPTmFWwl2RucgdqieZnyugIvYvgfOwI8LgXTCjqTLaCG3BScpKYif1yo3UIq7XF+/V
         fVmQGtGq+5VqzRaUrDBil5e6tSJp7jHx+k1jiPtkO4NJEHxVNGpFwGodmApo4sbv7VQW
         IkZb0M6QIWmPKJXoSwQccDZdN6ccD7pgsAZOV5bMGZhif0Quf6lHzh2DIUmp5p02VtEX
         oTatvrJxWd7Tf1Pf+Wkg8cnPG9oGbZjGQOWOnYbYmT0s7tGfUbroWrBqNCrho4oTIotE
         7cA7aeEx2iwmuoxcfZMLgTMdRFtINwoW5fUznN0JAP6LG+5Mqum4DegY0wVO/NJ6tkJk
         qSpg==
X-Gm-Message-State: AOJu0YxQwE/lXl+7XwJRQyTMNCaWdOQf7bvZNjj1Sy5KiD9j/FV5aDX/
	EwaiqRcwmhHk5c+PpaX+eif3oY0l82uVYIs+bqp8dpunoKGuy7YZTPRiuYiSg6bvNllpFARXbnh
	OU7HmKAUwvrg707DiKgOWiPZisP6xjm4fTo5gBQUf258Z3qtMrg2nEe4RQBny5OwMVThG6g==
X-Gm-Gg: AfdE7cm2RgoD/amVmT1BBmRD6+FTWOMCsScNvThOhauSsuWUQAeFzee3l/mDqFFY2xM
	C7F19APSWV15KC4NM8f/iHKPEtsmz4NXxQcwxbMIIjD7++s1q73iWuqk97MQxL61O2KLw2rLWnc
	JzG2y/uQzAQYHXAxYpRtcp4S93N8vOdJtsDY8W2DqEHvWlOuRSoDYY5kI/0qawVML4A6Z2oBUt3
	TJBeNRNLzIS75dmLCqK/cVlZe6UwN2V/OMKczkzLDbsyJiKVPp6vZwgK41wzbv8VmcavU9BasWk
	xVVbzT5YOECfL/dD5oQQrRqD98aq8ZERWCvHMYPIgqFSnhBxtporVj+ErJUGQ62i0FB2NirgFaM
	MFtK+nWuH++SvhWZOi7uwjYyQy+o2f3pJTYq4MOitsGGEq+k7bGxTEQFNbnAwYq2ue44R/5Gl
X-Received: by 2002:a17:90b:41:b0:368:af5c:5925 with SMTP id 98e67ed59e1d1-38e4b54614cmr557506a91.23.1784253676685;
        Thu, 16 Jul 2026 19:01:16 -0700 (PDT)
X-Received: by 2002:a17:90b:41:b0:368:af5c:5925 with SMTP id 98e67ed59e1d1-38e4b54614cmr557457a91.23.1784253676203;
        Thu, 16 Jul 2026 19:01:16 -0700 (PDT)
Received: from [10.133.33.98] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e4b0e9c5fsm197848a91.10.2026.07.16.19.01.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 19:01:15 -0700 (PDT)
Message-ID: <dd40779e-a844-46d6-8189-ed9021fc9c1f@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 10:01:12 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath11k: Avoid buffer overread in
 ath11k_wmi_tlv_op_rx()
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20260716-ath11k_wmi_tlv_op_rx-overread-v1-1-0b972b3f1368@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260716-ath11k_wmi_tlv_op_rx-overread-v1-1-0b972b3f1368@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=JeeMa0KV c=1 sm=1 tr=0 ts=6a598ced cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=Lj7BFKMBFr4BX5uBSNYA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: FDmtZPYDrTTiqnaLvjAvCXhNCeQUu1go
X-Proofpoint-GUID: FDmtZPYDrTTiqnaLvjAvCXhNCeQUu1go
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDAxNSBTYWx0ZWRfX3qqPXaFtSbQq
 uN1lbSo1mMMHROfgF2h/vL0gmh29wJMxvPgM3T0M29FNpO7byoN7fMTiGjcC0YIiyo/A4GjW1ek
 GqtBHBs33OqtUXIBQ1VrZstC0R/tBS0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDAxNSBTYWx0ZWRfX36HZ+Vxwl3lv
 8U92ZPns+p08il4UhHWz/gOrvEYIYZy9Tv5V4Y0SfzpcSaUWyJUCo/iMDuk8A00REP4ibMybrQV
 0HU7iL+WhWR1ei96NxKnoy3M4a1e71FRBDaT9GKJRZFh/+PBw3KpmbcU7l2JXXM27WOoa3C4sIV
 lmB7RlmtaA/YMQp9z1Ge4jrBx/XJrF0UAnSi0+SObzauj8cM+zQCuWjqs9UEhrGXPxe9vJk098O
 Lwg/YW1mRDz8tUZ0un8Z6EUQfwLeDrswPf68UO2qLUZ0a9f9iuUPtSGFfdiZBlyica0ZJ5qg8JQ
 pp+w2mpT6lH6/vkCyTWt0nEeVHXY3dqKh4X+zqe9DwCf/2q0uTnqtdFhtVxfA9ISuRzv4jK+s1x
 IFxFvlAdHmhtsRKvf4dz3r+rQH7j6WwSJQ/S7BCcF++iL3uEBIVsxIF+QOnzWdEtZg6GkPl0Eb4
 ZNrDeXI7qoSMnpfcVUw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_08,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170015



On 7/17/2026 4:01 AM, Jeff Johnson wrote:
> Currently, in ath11k_wmi_tlv_op_rx(), the firmware buffer is read
> without first verifying that the buffer has enough data to hold a
> header. This could result in a buffer overread.
> 
> Add an upfront length check before dereferencing skb->data as a
> wmi_cmd_hdr. The check is placed before the trace_ath11k_wmi_event()
> call to preserve the existing trace semantics (tracing the full raw
> WMI event including the header), unlike the analogous ath12k fix which
> could use skb_pull_data() directly.
> 
> Compile tested only.
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Assisted-by: Claude:claude-sonnet-4-6
> Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
