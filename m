Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E1134A794
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 01:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787104247; cv=none; b=szh2rYTpehaqXR2UyFEwdgwte0e4kmJO5rdueUhCOFAnl52IVsxLVVBUC+G79Omst4Ir9HFg1AWR+KZPbpTPmSCV8gLWxeQcSAVY0yOUfcXRPw3VaZO1rJwR1I5dhJwWXNNCMF0gd1Q8liVlXRMJcFeOqptXrWsGd/ivrsPJqe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787104247; c=relaxed/simple;
	bh=pT8P5jQD5hCdnFw7bbcrY3787tTT/uIqbzpCuSOxcq0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GJiFVvuyZVaniGByzrbWR6Gnmqor6eM1yUrDMxmZ7vrYCVG+V2No7nkUciu6Y4A3gMQ1AxHQRkXjOiNe62bzAEFTgQlTSO5tv1aCVEAmJrwdPmoJYN48U7Uxd4JUxBK2fPUi4d7bFB7VpuF3StU44KDvYevFGhFVtyoVtROsSrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WXIqqhus; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TSiNBzHy; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WXIqqhus";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TSiNBzHy"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67INl9qF1563614
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 01:50:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ty45rSCduvncTI3R+4xQH3a4ms0gZDBpX8wGB7Z8aYQ=; b=WXIqqhus/M8hg0SX
	p63atbjJrywGVM5wNzBIegXnhZGmD9eCdtIY4XZow1Tr3e052TKxD21rbTehjTWb
	uerYjWxqcK6gpWOmMItbhAaSi/RHOshWTsIsoe0bdMMfHseN864zRNnZC3h+Y5Qv
	XVi+A1msJ9KOnfZhWLRzsPmId37suZ/yzfcJi51d36Y+RXmendUFFaCnlOX37/L9
	eqQFFAPD4ppJ0bgK453XM44e1+eWVf6j3Y6R1FbH1A08tMFWRQaf29JL3Dk/fEeN
	PR6+Ih1MPu08VWTw+WgfD7wxAcyWReOeO0aWjAZ3ARk83YTcHAA0KH43nY3SfjV3
	tcBOlQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g4yfk8sf6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 01:50:45 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e8fee6af3so660584a91.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 18:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787104244; x=1787709044; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ty45rSCduvncTI3R+4xQH3a4ms0gZDBpX8wGB7Z8aYQ=;
        b=TSiNBzHyzLvqFehZ3HapteCJstPIPJfIHyuqwICmr0/4EdPkb4TxqtA813BGK+Z8eZ
         hf09urFfaT0dS3Ju87Y4qlNiAj6HZjdsiFCeAVGkGAYAnyIqyZV+axSo6CkJPS7hzuo/
         4SlDf6SYpCSsDElO/Ba46IAy/4jOskgPj8UCp67dydFnXRpX3exLIlSgD9gJhdfV7nPd
         Nw/Y7IQn7tJzMQzvH+saL94ZawmziYbIRz2/6HJlCqBlM17xXcPWtuZoKaxpxKiqNj79
         gRIynXFTTqzMg/TmLpkB16iF5kN2SHsyO39DOqVs5PF5o/PJsln6cygN47ngp8fi4JQ6
         WmIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787104244; x=1787709044;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ty45rSCduvncTI3R+4xQH3a4ms0gZDBpX8wGB7Z8aYQ=;
        b=MEQ+c3Z2PcPPQzKtpFy74Fh7++uN4eblRWH7F/CIx/EkqITdZZBLjnpH0NVFWKycPs
         z9e72SyHFGusK8XsgEn/mSrnnEnabIbglH6hdvIe/N2tYsvhGpvrFEshMY0H3dXM++Pr
         LVs/uSCfwMCrTntjjT6zWiqzPssA8ShJ0peO2ilOQm3C+0JipnsJ+b/hUwTpPwfqx8mO
         LFM6GETXjRwQ323Xw4ee6GtKJSrr/CCFrvDHXnOIsK8Rmf1xp98OxeV/CpZJ4VJ719Df
         6MVhNneBvjCBxQ1PWkcLL6k6zo3jE23RvtFn7Ftn0zbNOGSLQGDmLQQGpm+bwTDmBMVH
         Rllg==
X-Forwarded-Encrypted: i=1; AHgh+RoreQzDIYVQSfa786sT68pMh5ypTeX4rQfyDHCcD5IeUo+3I4jHrnzAd+UZY5Qn3gs4nZ5YXYi6GyOBtIOWqQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJlUOs5eQS2Crs7xXI1Yi1CGMbnkKFv7FiMrJBnHfi/PyK1Gjy
	UtST9H5EC303ujjF5VGmj5Ltde2/CTe9C2ld7iGYPwaTPjLXJtE27xmSojq2NVYihi3E1Il+/bO
	IunODvQIikHtb0aWNV7nGem8xyn/UCAjNYW1BUQr1v51FF81SrIo+OWLQR6tnLW0Omii3tg==
X-Gm-Gg: AR+sD10wG8vPDpDvz3BUB8KaObAKD8SkgNNLnxS3bZ2j/beB/dKODEo7XgAz96eHVFp
	Chxai6bNUXHtaoEYurt2V6XOs1G0JhJwhGbAGVhjd0bE+6rs2iFZAv+jJNTwqJMYgJPWGFSjrGv
	J/CVJcLKkNXPlwgf/3SxBbengDLm+FROSmH2frXHOdqvwEjZvPoeiTpG/V1ay/Lkh6P+WEtDwmk
	5DerIBSV8CgmxRuiXcsd2N0fBzEntwB+JMcRcsNKkmmXRbWb69wEXnH5sCJUgHtuuS78ZLqtkoS
	Z+7nLly1M+2Fm+T3yx1IXsAz4kaVnz+z+UCUhdEoSH3Si7Stj1kZsVrHBja8lA1W8Kdkyd3+vIM
	I0f6vpZN0uKllIysfQzkaeO4v3a2RN/BM3A5sl8GCL4p5ACo8tsajCmDwgCQ/y4xpAg98qFrxXg
	==
X-Received: by 2002:a17:90b:50c5:b0:366:10f1:3d91 with SMTP id 98e67ed59e1d1-3958125af57mr2184252a91.1.1787104244256;
        Tue, 18 Aug 2026 18:50:44 -0700 (PDT)
X-Received: by 2002:a17:90b:50c5:b0:366:10f1:3d91 with SMTP id 98e67ed59e1d1-3958125af57mr2184144a91.1.1787104243724;
        Tue, 18 Aug 2026 18:50:43 -0700 (PDT)
Received: from [10.133.33.152] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fb17f48sm764718a91.2.2026.08.18.18.50.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2026 18:50:43 -0700 (PDT)
Message-ID: <f4f1e338-1206-46a1-bbfd-79fb768dc382@oss.qualcomm.com>
Date: Wed, 19 Aug 2026 09:50:39 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: wmi: Complete regulatory update
 for dropped events
To: Konrad Dybcio <konradybcio@kernel.org>,
        Jeff Johnson
 <jjohnson@kernel.org>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
References: <20260818-topic-wifi_reg_fix-v1-1-18c7c289e528@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260818-topic-wifi_reg_fix-v1-1-18c7c289e528@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=PoGjqQM3 c=1 sm=1 tr=0 ts=6a850bf5 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=-e__KoK9oonTYIwy9uwA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDAxMSBTYWx0ZWRfX8dgNMW6XpNJ3
 ZDjjGzFGpLQET815A82HnS8VMvB4FLgFo33nwhjVzYacwN61Y9s4KrsxPHvaem5WtlSGy0ebu78
 HW7x/ve/cJzepZHs5poTuyl+UcfAoh26H++5Tkpzr5zfWQv81Qk8rlc7QJlHnyEU4uSwS71D8Su
 FAKpyrjY7R/r3GPra8WVr8+C6zCx1QNMilTgBllTCTMVtsUi0jxA53dhVrZHmxkhn4TQVgLrhB4
 6G2hjkMPgLGQX7OTVazjFwgIJrXc9GbsTTCyM2YWC+A8p5y5jCzS7Rpnh/m0i/0290lh/VO6fek
 lMv0KKwXGBLGyuHk5rcmuQFHB0g51Gl9DPyIiDZcKVln8vVAyK5MgqPT+r4Bh72cKaJuFj6w/zK
 QLp8hvVQWUiy5YRU0JhwZ8RrONn7aa1mMMOLiShiN2iY1fnUBdcmAL+aPthc3iNnenuOYcUxSNI
 yDE/RHeIt/xM2NicWuQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDAxMSBTYWx0ZWRfXxyUkGvS/IBpz
 yX5PRurUXf3VPu/0YfqbyesStgOYhgswz70jBkF7HOAIP1kpuPvCbHNwgeP47Os6hulpmCRALpu
 4B2flBL2g3B2xPHyQ0Pge7SvviqL30Q=
X-Proofpoint-GUID: VXZeq65lsNI6JZ9KtlodzCOHB9yuma5j
X-Proofpoint-ORIG-GUID: VXZeq65lsNI6JZ9KtlodzCOHB9yuma5j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-18_05,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 bulkscore=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608190011



On 8/18/2026 10:57 PM, Konrad Dybcio wrote:
> From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> 
> If ath12k_reg_validate_reg_info() returns STATUS_FALLBACK/DROP (which
> are not fatal), the code then jumps to mem_free with pdev_idx still set
> to 255, making the following completion never take place.
> 
> That then results in repeating "Timeout while waiting for regulatory
> update" messages, as observed e.g. on a Glymur-based ASUS Zenbook A16.
> 
> Fix that by updating the pdev_idx right after the actually-fatal case
> of not being able to extract the reg info data is ruled out.
> 
> Fixes: 906619a00967 ("wifi: ath12k: handle regulatory hints during mac registration")
> Suggested-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
> Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath12k/wmi.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
> index d5160af60e00..4ac78ba6c790 100644
> --- a/drivers/net/wireless/ath/ath12k/wmi.c
> +++ b/drivers/net/wireless/ath/ath12k/wmi.c
> @@ -6975,6 +6975,8 @@ static int ath12k_reg_chan_list_event(struct ath12k_base *ab, struct sk_buff *sk
>  		goto mem_free;
>  	}
>  
> +	pdev_idx = reg_info->phy_id;
> +
>  	ret = ath12k_reg_validate_reg_info(ab, reg_info);
>  	if (ret == ATH12K_REG_STATUS_FALLBACK) {
>  		ath12k_warn(ab, "failed to validate reg info %d\n", ret);
> @@ -6991,7 +6993,6 @@ static int ath12k_reg_chan_list_event(struct ath12k_base *ab, struct sk_buff *sk
>  	}
>  
>  	/* free old reg_info if it exist */
> -	pdev_idx = reg_info->phy_id;
>  	if (ab->reg_info[pdev_idx]) {
>  		ath12k_reg_reset_reg_info(ab->reg_info[pdev_idx]);
>  		kfree(ab->reg_info[pdev_idx]);
> 
> ---
> base-commit: e6664f2b33db9b6811eb4cec109f06cb2b4f458d
> change-id: 20260818-topic-wifi_reg_fix-a20c9256c5fd
> 
> Best regards,
> --  
> Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> 

there is a similar patch [1] as part of a series [2]:

[1]
https://lore.kernel.org/all/20260729-ath12k-regd-wait-timeout-v1-1-504aa6e7e93c@oss.qualcomm.com/
[2]
https://lore.kernel.org/all/20260729-ath12k-regd-wait-timeout-v1-0-504aa6e7e93c@oss.qualcomm.com/


