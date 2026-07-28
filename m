Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01AE4322E2
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 12:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785241389; cv=none; b=qV7PGQE2saU74LI7ctF00g3vHqVE4o5/Q2pzIFWMgXpBXFzG5zIZCbM02EtocmXzRsGEg+v57OH+AdLKQb793RTSvEvol+uesSdg6C71MeeIP0HRIx6b6IfnLwmPHX1WlfEHpiEhvTvq6obxJu3wxk5orDh6BjD62683BWkCWTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785241389; c=relaxed/simple;
	bh=oTLg33/6HhkpG1YPUTms2Pq1VqfcWT7IP70s0Q9qiTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=csukaogRw/HerVIpo3soCEPbtxKck1KGuxSTg0Pv7id1UvwPi9GyP4lFDiM4bs9Ji2iQO8gVfCkdarepDrYoIJtiFOseBHlo3QIu+fN1Rw6G9pKgfgvLqBsricdnAzY1ik4WvAewwbNnV7YytFQyeZ/qzxwBJLMPs2a1fCiWJHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JZXoU65H; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PyN+84yC; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JZXoU65H";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PyN+84yC"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SBI2AQ2734861
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 12:23:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	6FFanSBczPsLjF78bY4RBzFH+P5Yq2LeBNt7fkvw74M=; b=JZXoU65HhcMKXEO2
	Gej3LaAcMBSmgaEBEgTXFPO/dyFz+r5mIRqGWafkrTdkFO+kenX7JS886h38pFvY
	cInIWYHbtTj9DmlHGRaVZpLTfhxABDc0z7lMwh6E1F5iHxLrz59VLNecbz+ON5y2
	ytwRNBGzYkaXl5jTkyknROx8Ig9oMxDuj/PW4zpJl7MHQuC5twYAvSIlxw6lr+UE
	4zMRJ5TDAhXb5DXx0+FffCIVNkbW5pLcdOvrCdl80esirHpkKLufZc5wFQl2sPcl
	Dx+2Y4Odoc0vbreJ1skDYwYvpXADaB2v0MVgEL3vuolSfmisG0EvSSk3C4xWzO5W
	zMJB1A==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fpbrsv66v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 12:23:06 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38dde0df80bso6124165a91.3
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 05:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785241386; x=1785846186; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6FFanSBczPsLjF78bY4RBzFH+P5Yq2LeBNt7fkvw74M=;
        b=PyN+84yCOx66RQXWACc0l6RpwNGnnIrvrt7kcZy4kaqq8Q0SxcnuGKyQyzb0JASVho
         jtMljJC3jpOqmnsUiOYCeEKOWIVrQNcByDnhaoA9Cr3bgFqUHi+ZoLcPtY4DkEkhJfn6
         2DZLjLns4d+5jhxf16/axuX7UAHIAUY3jovJd28yNS7TsjHsLZ8jUH9cyoe5NVdw2Kp/
         820x8t06D0RgY8j1TlepqnsGh9ri2nmKd0u8QkYVuTpkFoIYc9b9vWMEl47bvnPCxQnq
         Co6cepQJHfDd9uNmkDslif06bIjHKaSuFB174GZMrX1PvVdjEaTrimYzdjcCcwknHK6z
         aBIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785241386; x=1785846186;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6FFanSBczPsLjF78bY4RBzFH+P5Yq2LeBNt7fkvw74M=;
        b=RniXsU95dg85xJr2s1oUsNHvok1sjbi8KyJqOE3pWPYGIJf2DiglcVibRIGcKE+oGu
         kmZkS7+r53hrPX7RKBeA2KPrmaSOJyrfH9aZJQTNFv6lh+rmg7fp8wBaJxH1/TdzlFDi
         DjvoOaJr7+3mBgOijrbL66/y0OZmRjEbbFhAagmESlXPLSeDjErIeZ99kxeBfGOpbC8r
         XA0RraVoPdIX4MAcb076GAIL1e5gCEDvEU5+i2VcN9nPKbQGSgJN+Hm8QT0rtrGeeawp
         ncoLDikh7KNbpcxsC1e8KphpPtERlhSvGUYwlXOEpYBVeBv/zioMN/LmcQxgnAGviZhE
         32Mg==
X-Gm-Message-State: AOJu0Yx23GwcAjPYqOXAu1ydGrKPqlBJTD5koH7e0rOwUQcgMd1sYBkr
	elNmucIhEquNyR+3+MSvjeg93THMkOjHXyH8MxXursSeDO14Vb1YMB+pFjIoNqLV15rb+3+pKJk
	bZrEqZeGyHXGJ7BaGrVHG7fwiAAm6YfEA9Nbo8/Mqz80gbwysirXwrProCZlVSD+CiecIfg==
X-Gm-Gg: AR+sD116m60H39j+nOB2chahNwERUR3jjCbF7SBN+y48calLIoxMCSO8lCwxTKZx+9u
	VoMU8Hs6DQHW+h/+S/rz+BqPjNYZ0GxTsNipGZ305dzJ+3PS8mF3YQPeXcQlPgbl5XCtZ6sX3Vz
	T3Mm4nnUEmy2/XYeIiODJG+WIhto+zGkgS8l5hNa+n3Z955mwxvRzlVwtYcooMi7W+wlP7dYrMU
	CKmVgPtNdVEj7Zb+ea1H1++MTTX7ZpLcZJ2e95gzuwl02ayTrjJWwAhaQI6D3E2VA0qKee1WJHN
	t5lEks0y/Hw1Ivz/enO8ABNXpS0/GFnpCw7+0FSPzvdKb/EESnWd0YlGO4lpRUgrGrdvVT8bXhu
	4AI1heyoH6T8q/R4WwSIAqG34SlZm17A=
X-Received: by 2002:a17:90b:5864:b0:38e:c7b0:84ad with SMTP id 98e67ed59e1d1-38f6a1becc7mr2303000a91.0.1785241385804;
        Tue, 28 Jul 2026 05:23:05 -0700 (PDT)
X-Received: by 2002:a17:90b:5864:b0:38e:c7b0:84ad with SMTP id 98e67ed59e1d1-38f6a1becc7mr2302973a91.0.1785241385301;
        Tue, 28 Jul 2026 05:23:05 -0700 (PDT)
Received: from [192.168.0.12] ([49.207.202.171])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f641053cfsm1218175a91.3.2026.07.28.05.22.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 05:23:04 -0700 (PDT)
Message-ID: <3d740be9-282b-494d-ac2b-bacde92a051b@oss.qualcomm.com>
Date: Tue, 28 Jul 2026 17:52:45 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 5/8] wifi: ath12k: add WBM RX error drop
 statistics
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Aniruddha Mishra <aniruddha.mishra@oss.qualcomm.com>
References: <20260723125448.922361-1-pardeep.kaur@oss.qualcomm.com>
 <20260723125448.922361-6-pardeep.kaur@oss.qualcomm.com>
 <49f52ca6-d2a5-41d4-9952-794dae91e32f@oss.qualcomm.com>
Content-Language: en-US
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
In-Reply-To: <49f52ca6-d2a5-41d4-9952-794dae91e32f@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDEwOSBTYWx0ZWRfX47jrnxziPcCn
 LMgdcSGXKfJFaqAFGEOtYihcjD5a62Dwxqm0HemRobYxanvFRpRsP3js/Ur+SEzrQnWA9/Wg6MA
 1eJk1pjgpG8qWiSeJvvX2pymcAxhhrXdvWw/P3x/UOdKY4x1MMJxFGN+7SELn5FIZXFVPXRTn9B
 W+HZPW0AmdLahThRM6rbHVhReaDhGYB7e1iAXrLFlF/MbRgrOCNBpndVBB50L6/IU2LgEI5wb6Y
 LLSihMxwGBFHoOiK6Jt7Rw2YjVWk5x6Xbbh9RAGrfgvAb49lqsTP6r/QYsN3TXtqGHGxE3ckdra
 ZVE3w9CI2YnRjG+2tM9pM1gMFvQGZjSbG7eNFK+3j4Gx5R0c2kwSfGXflLvF786oCdk85BgP1YV
 9qb4rUcorYB4A/2yIQ9ab4e/FLPSaapgOm8JMcV1hl8prfvnm1MTMBLU5P9hBBOtSO3fcrPGpfn
 P0oUxekyFN/vLCjzkEw==
X-Proofpoint-ORIG-GUID: rubo3-b_bot9duby5kQVfdL_p4KKSLMv
X-Proofpoint-GUID: rubo3-b_bot9duby5kQVfdL_p4KKSLMv
X-Authority-Analysis: v=2.4 cv=ALkdLnG8 c=1 sm=1 tr=0 ts=6a689f2a cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=wDio1FLaKedB3uI5tWxtsQ==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=qMQjmZDiIxJzO8nyjRUA:9 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDEwOSBTYWx0ZWRfX4o8DTCxhEM2J
 hHPuu8qI7/gGfUZXJm4sdg0oUHPtOWF3Fjak9DxXgRrRDgn7bvgJT6QjdERC04m8JWtwps/3wd+
 D8Gr5FYppjq9XXb1NkjgjjjBqKw5V3o=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_03,2026-07-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 phishscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607280109


On 26-07-2026 21:30, Jeff Johnson wrote:
> On 7/23/2026 5:54 AM, Pardeep Kaur wrote:
>> @@ -1961,7 +1983,8 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
>>   		device_id = desc_info->device_id;
>>   		partner_dp = ath12k_dp_hw_grp_to_dp(dp_hw_grp, device_id);
>>   		if (unlikely(!partner_dp)) {
>> -			dev_kfree_skb_any(msdu);
>> +			ath12k_wifi7_dp_rx_wbm_err_free_skb(dp, msdu,
>> +							    WBM_ERR_DROP_NULL_PRTNR_DP);
>>   
>>   			/* In any case continuation bit is set
>>   			 * in the previous record, cleanup scatter_msdu_list
> My review agent flagged that between the blob above and the blob below is the
> following code that drops an skb without accounting:
>
> 		if (err_info.push_reason !=
> 		    HAL_REO_DEST_RING_PUSH_REASON_ERR_DETECTED) {
> 			dev_kfree_skb_any(msdu);
> 			continue;
> 		}
>
> Should this be counted?
This one was not handled as part of the current patch incremental patch 
will handle this
>
>> @@ -2007,7 +2030,8 @@ int ath12k_wifi7_dp_rx_process_wbm_err(struct ath12k_dp *dp,
>>   		hw_link_id = ath12k_dp_rx_get_msdu_src_link(partner_dp->hal,
>>   							    msdu_data);
>>   		if (hw_link_id >= ATH12K_GROUP_MAX_RADIO) {
>> -			dev_kfree_skb_any(msdu);
>> +			ath12k_wifi7_dp_rx_wbm_err_free_skb(dp, msdu,
>> +							    WBM_ERR_DROP_INV_HW_ID);
>>   
>>   			/* In any case continuation bit is set
>>   			 * in the previous record, cleanup scatter_msdu_list
