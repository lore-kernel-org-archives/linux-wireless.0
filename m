Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAC73F6600
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 11:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785150198; cv=none; b=eP2wrX56dUopd0puS8LcoMWvo19EgpuUpDmZS8RV864/yVRXoOVGcBOPFg4yEN+ReTTbbzUk7s7R6WuKEzqeCJETKDLR+H53XbDdt3LAuwgwr9EFIF64G6tkc9agKyt7vJ78dA7c1Y7gvDtKPHicnCcmYkdJG8omqcs/9tpWOwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785150198; c=relaxed/simple;
	bh=d6/Bvf25CGCgs9lZIjHl0TVlUBqYcERKJNX6lqIImaA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QV978ociZAzc0Qq4xeYLeM+BDei31y61VqNXuVxLtX9auf683/M4dS2ZhmMoeDBBXuH87VAWdxxI5rgbelL3/3PQ9EZE5lSCe8en7dcNxrxyGqpnXocZx+WeWloxypCDVoqNDPMKueK9k/3DADfyMNBqb0a4xS8hCMwMni7cB5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CxVptfrZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LNFwT6pB; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CxVptfrZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LNFwT6pB"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RAM3rT3570958
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 11:03:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bjyL0Mx5mA+obZ8zFCVX1dDW0MXrzq9zNvV5dazhMBw=; b=CxVptfrZdQjtypIj
	o8sMsvorVXKB/i3gC2hOejcax2LYHU9L3KQI1N0oTvW6oCn21GQ9GJJfVDeoSmSy
	/BSAyas86Wja5ACd+E/2atlt9FYKI10JohbyyMcxTSF1rG4urxJ6bysLlv9+Yzbc
	3ll8Vm+bsNAh0VJZWeB0wTmIvupp1a8yzFn7TPmHRn726Y3OMdye2YlcENlzLjXj
	eM9YmJPARmSwaHD+qK7GNG0rTsq/6axBOq3y8+x9GNtE0JwuGGUAIHUoMOy44nnG
	t7IsoD7o0XQlec2PZ1kDgYJa/coaXT9/0eaJ3JminwBNMpuxV4LY5IPBkuKysZy6
	zYzncA==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fp30g0wdx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 11:03:16 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c85798977dcso4137603a12.0
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 04:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785150195; x=1785754995; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bjyL0Mx5mA+obZ8zFCVX1dDW0MXrzq9zNvV5dazhMBw=;
        b=LNFwT6pB+/zd3CZygRSblnJC685ZmbwZM068QajmIm3/EOb13grlWs1tyGdussq53x
         PvhNmV4pw6En992gDKkWDHVHZabfxPW9EtQuJHZRwG2+4zrqBkfNwciiLFAVR2tjXzOj
         0ny/JAu4cBO1m9sX6UovZ7ihRPRHSMST3STgRe/5+YJBP8Po9V/BG2NOv2hDebkbzx9v
         incdnTqLBKjH0s5m/SoOzme5XlMo8/xwbsQqOYjd9jBQ6SivOzulYzRzNeN/92IJ2rKI
         AuvlxjnV5Xp9sWRTVUpF2EeaUCVblSNjQVX4CyXzNHS8CsQCJVejffh7ZXXsr5S9m4QK
         R0Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785150195; x=1785754995;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bjyL0Mx5mA+obZ8zFCVX1dDW0MXrzq9zNvV5dazhMBw=;
        b=A6Bnccnb8KpDdM0lsIUO4EOLvWaKWKQRIl2zLEj0WWaGlTTWx/Acs7nwXI9WMaQaOY
         dX0lKG8CUqzJ1GF/zlsQbEl1kjQK1/fR9i9Y2DcGXYxh4iOpMvp/bS5+/5mFB0cI20UF
         P2PYDNTma7uDL/ERmc4e7wfIi5bp7b8XXNorgYoitWWI66ewDq9xY/RV1A3RdMiFdFGM
         TTCWypv1y5jOuUGQJoRupJ7+QJHkq2ALhxjb2s1Bg3kBrKafH/SBGz/wp+NDNFafpVeT
         6mwv/j58K1hP4qvviGuBB63OIcApBBx53MH04JwjzM3kYNQORfIDpcgvzq5YNbRGYuQD
         DeBw==
X-Forwarded-Encrypted: i=1; AHgh+Rr2fQdHAwprJC8ImQTU9Dvby4oRisCnTvMTHzDmPAqvIRbHob+VAJM7TjGhg90R2RSOzWmk5JCgAvDRdZ17/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyE18cgYuwdN55uSjS34jbX72WsA/01ClzrKIcSaBLR8qSNUww8
	wIOVvEkMtHOtOmg1RaSzPUigT5ztz1MTfWjjczJrP5aG8NcG9/uP/Sqd6EbCXw/mp4heZyiQJFu
	A4KVlSdMBw/zX2C9PxmccBw7PWMnHo45StOXqDwOCBCbkWzSkxy171o+qmV2zbscXH58mJYohas
	1J4Q==
X-Gm-Gg: AR+sD11Wj1PHtmTN1vfDwKSVEnJLg0D9Rzu6mM904X/c6hKta+hnEkkjOLiclhajZ1y
	wG/xbw5J1QXbYX10n0mJOEbyQ6pj1JUgJRrmgw0+3dPymoTXyCTxIeKAPMW90GJCLt3pGj2qNy1
	gX2TyiV8bvQlrLq8c68edQqj6x9VdPOG536btglZIjEV76iO63pmAzstXT9n9/UBnynrMw0cbwQ
	fVFwbnsAnO84IMQ/k77QZXd6lUqlaBBm+f+mfXtwGmj3D9c48L2LaECjy1Ee5TZ1f5odoCp+Hj9
	TpUVM+LoNj0V48h2V36vDJnGQ6C9+YgJQ3w6n7r658BrhNTAblhQndRxMdQNKHLF2fN8kY8wfTK
	ZqBcqF0IUC+1Oif6IVk5Liim3Nia1aC3hT/0C/p7l
X-Received: by 2002:a05:6a20:43ac:b0:3b3:2703:115 with SMTP id adf61e73a8af0-3c67dc41ae3mr7496095637.16.1785150195109;
        Mon, 27 Jul 2026 04:03:15 -0700 (PDT)
X-Received: by 2002:a05:6a20:43ac:b0:3b3:2703:115 with SMTP id adf61e73a8af0-3c67dc41ae3mr7496058637.16.1785150194687;
        Mon, 27 Jul 2026 04:03:14 -0700 (PDT)
Received: from [10.152.199.23] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc413766sm32063360eec.8.2026.07.27.04.03.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2026 04:03:14 -0700 (PDT)
Message-ID: <70a367c3-f520-46d7-85f3-d7470f3c16e5@oss.qualcomm.com>
Date: Mon, 27 Jul 2026 16:33:08 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] wifi: ath11k: fix resource leak on error in ext IRQ
 setup
To: ZhaoJinming <zhaojinming@uniontech.com>, jeff.johnson@oss.qualcomm.com,
        baochen.qiang@oss.qualcomm.com
Cc: ath11k@lists.infradead.org, jjohnson@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <b6903572-52cc-4c41-b9cf-5845e387c176@oss.qualcomm.com>
 <20260727065500.3827035-1-zhaojinming@uniontech.com>
From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260727065500.3827035-1-zhaojinming@uniontech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Wac8rUhX c=1 sm=1 tr=0 ts=6a673af4 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=iHwBjlyiAAAA:8 a=EUspDBNiAAAA:8 a=t70t56v2sCmPkK01i0IA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22 a=uNSKXYNwxGiU6LD0JREI:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEwOCBTYWx0ZWRfX29k27y8hlz3o
 9vImkHcoJcgLwNoNNuL3FkAOlfzGvW9qVzzjoPOAB+d99G0228VufPDMqyWgddE8tRZRr8ncnef
 2LkFV4u7ASmjn7WF9IGcVRbEOgrDSEU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEwOCBTYWx0ZWRfX6Zw9B8waA2/X
 gKC6os366oZsWPn1Yx3pNeZtoC78qKWuLIpB6GIytxgkhMGTL29ZkMGFsP82KdwfRsypuG6SEj4
 lPKOqbkoqN8quf5yoMNM+4OseZatVlrz05yJ0L1KUIvV8xjj4zj3kVzREpIP/Yo9D0s1a+Bvz0g
 zi9ByjvzFCZyfdHr13RhYBIItmA1y36UCnJoxTNt6zdZPXO2S1zKUA70ohq5+fRL2QtgQNCN72m
 XTp5HxqVw9OxjI2BfjsWnv6oLZsptUpkdzeOYkPPob0s5vcAVOlsz0FskXKXObwR7AP3YYHrQau
 lmIFwjIuHKOMC4rbgG/u3Y7qjP/LT8nzzj0M26JDwlVmvCqN3bCZosn/fkOqjNSmsz68MAC5HmP
 bzehK5jyg4lBs7Ev2Bzd+/MmL0gPRwdLNSz4883TF0qNI2HTmWwJLnBce49oFBKi++rCebY56Yh
 UaBGAd0JXWo8cEHC+tQ==
X-Proofpoint-GUID: ise-wecF4r5659x3niEO51xrCCgVCisM
X-Proofpoint-ORIG-GUID: ise-wecF4r5659x3niEO51xrCCgVCisM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 bulkscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270108

On 7/27/2026 12:25 PM, ZhaoJinming wrote:
> In ath11k_ahb_config_irq(), when a CE request_irq() fails, the function
> returns the error immediately without freeing the CE IRQs that were
> successfully registered in previous loop iterations. The probe error
> path does not call ath11k_ahb_free_irq() either, so the previously
> registered CE IRQ handlers remain attached to the interrupt lines and
> are never released.
> 
> In ath11k_ahb_config_ext_irq(), when an external request_irq() fails,
> the error is only logged and the loop continues. The function then
> returns 0 indicating success, leaving the device in a partially
> configured state where some external IRQs are not registered. This
> causes enable_irq()/disable_irq()/free_irq() to be called on
> unregistered IRQs during runtime and remove/shutdown, triggering
> WARN_ON(!desc->action), and missing interrupt handlers lead to data
> loss.
> 
> Additionally, if alloc_netdev_dummy() fails for a later IRQ group, the
> function returns -ENOMEM without freeing the ext IRQs and napi_ndev
> that were successfully set up for earlier groups.
> 
> Fix all three issues: propagate the error up to the caller and unwind
> all successfully registered IRQs and allocated resources on failure.
> Also move ab->irq_num[irq_idx] assignment after request_irq() succeeds
> in the ext IRQ path to match the CE IRQ path and avoid storing a stale
> IRQ number on failure.
> 
> Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
