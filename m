Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7E03939A2
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 06:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792131667; cv=none; b=LMO2l1Kg2ICe0wtmdkwa+8LLXGvX2f+4JVDiqD0ga/6VokievBVtwECHNU1gzUeNfBhgWRwa7yWmIf7JN2VocHI/Q/ByEaBS8lcGhO6H2ULYxoR0VWVgZuPYmbst30HZwNb+ALNN3JGFCG7+QadrD10aq0n8xDVSk/RPkx8accI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792131667; c=relaxed/simple;
	bh=rX8NRuBZfFH8M1iXEQTRDHKkWTxUBhikSuG47XrJLss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jWT137Ee2H6aQ8ty/RJqviAanfVui9ctLO/CL0ikgFBtDsNt2V9DdMes3gLO6lQ7aMFrG/k7TQc2O3uM3pDdhLoaGja/EKTlr3acm5DJItJAIGoeVtgtJyeXtfrTiX9ZndT9Y4ibyl0is5IVhE2QHH1BVC+SQBQgPQ1sjjjHy9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cHSVDLyk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TOwsOJOA; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cHSVDLyk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TOwsOJOA"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FNChUn557566
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 06:21:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7a0GMMLbsBLkNks08KISmu7g9oBBEyBrrD5fOAJxteY=; b=cHSVDLykoJlP9wB2
	0oAp2zhEU0yAmraCrontwzwmP009/W2FJe6dMApwVIemTgRM6HiwQ/gIC7ltf1hu
	wsRlBYQZ/XnBeAVd5wD5YGeT5bz2IkI38BhUipQazO+BP1oDJb8+mFh+iQI1L8Py
	fk8Ib3jd1lYvnUA7A/K4DwWqqcabgBpQH06DeovVoBStfWZTjJfXdz7St3cs2qJ2
	fQhjfb3J1+0VIEERjyLjVNoYnYd1dCxMy77HAagERk5bgH0BD/LhYb//EPhIJmgu
	PZtGObO86mEcGl6+TpCNFMNso47huCRwxRifrP6D1VlEK1h9BK8lT7MOt8gBhfnX
	k/iDYw==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hb8a897r7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 06:21:04 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-89fb6a45c48so200632b3a.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 23:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792131664; x=1792736464; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7a0GMMLbsBLkNks08KISmu7g9oBBEyBrrD5fOAJxteY=;
        b=TOwsOJOAsoNDuR5XrEVCTS2p4/BIGZN/WvoD556EccatLHQfBnwZIrcXUzZmVRaMXm
         10CNZdeBYAmqBFz62VRAFaLsQ2ZV8JeenMWm3XWrm+Mn2sTfXACRyMfecW0VBqwVQP7a
         HgryhvS+cl7+Q9L1IAx/aq7NdXNGPZ2OGsUdrOW7U0owc+XbQSAV3DORFa7Zluvs8/JI
         NPMCym3DPhp+8+K2J1Myga0FFP64U5CYrwqrIaCE5t9mPExhVkmzNXhf13TCCk2DDHp1
         fx6q7sNp+UcxmNalWkFZos/DrFflpEqDCBkrd9lgfseIZW/Q2L/3wDFVctVPvDwdtvFm
         at7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792131664; x=1792736464;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7a0GMMLbsBLkNks08KISmu7g9oBBEyBrrD5fOAJxteY=;
        b=MOQrjeoKRxKRzFUIs/eWCfxaYxcQR7c7rxTRH/Zh5pLbZOEva6VaOn66Wr2ylUzLsz
         a427SXdeRdCPvKa0qwKUnWXDJt8b4KrlK+uLwoP0rBpqBx3OZ1g/3QU53XivtXFxuC0F
         yWjosVtXGqfVwNGfTvcH9s9PlQFo4xyVEjE/yjcfb2kC3GfMeLcZsqQ6wbAhH4lO7u59
         KNzLyNmov1vTNn6AYs0KoRudDpG1fqRdIeBamRiSxH1Ln2V5/LiDAQOospjhRJLzJv16
         G46waNtc6aIwQS0fCeQ05Hgx1JvpDkJ3Bk7m0vyCNHVk7uS47HLcdYY88o+GF3/cyRXF
         6Akg==
X-Gm-Message-State: AFq9FYK7tXPXKPJ2cInC9wPr19wn3EPj8XBoQSQDo1JNO2b7dljgX0G6
	3k7GpffbPrEv8bkFa29M1aei3kKf+8UEDe4oFGupPFJlwCD7I2q2aQZ3XBpNuPUYCotodkeSLAD
	I6OQBFo0CblPC2BdJOSpX0V+0qB8pMsUqjUOyL9hnwVKXhlZmCtOb5M4SB++2zyaRdDoI3OjU9d
	glDzZ6
X-Gm-Gg: AYBFou0t4VKI7+DIFVGl5fEQFCk/eC7w6uN/AhF9UHNAMlojO/nXjo9HszM5brM7XiA
	Xb3DtChUHlvj0+TJJCmZbDGYfrsk59WWa1OMsUPAgw5LjaIo4b1pvH+WxZApRJApAFS7o1DJQ8f
	OKULCNpdXd7A5oaRaUHHviREF/rH+T1zgSTvbrgdfYg7lKooMrVOO2OTja6Mcaa0p7vkc+B4fBy
	3iU+Ge0hWfZBvzYUUXkI9iivUl9xhqTkAjCstvc+KkoqFiS36P5zTfpmshac3pYTt5/mnw2Fc4T
	kfSjXAJeQXqLL53YJaHgw7xfMTISHyUVOkLH03uD2z9VzowmZl5+okzxHNZ+WHoyCxOP5MU/pnV
	csOiWE7QtuE7eaasO8bIKfEjVcPdFTAF7g9B3fi5qw4IO5e900f8Q6P8MS76QkDCeu/JI
X-Received: by 2002:a05:6a00:801a:b0:893:1336:4816 with SMTP id d2e1a72fcca58-897c7ec5a53mr18165149b3a.57.1792131663950;
        Thu, 15 Oct 2026 23:21:03 -0700 (PDT)
X-Received: by 2002:a05:6a00:801a:b0:893:1336:4816 with SMTP id d2e1a72fcca58-897c7ec5a53mr18165130b3a.57.1792131663430;
        Thu, 15 Oct 2026 23:21:03 -0700 (PDT)
Received: from [10.133.33.246] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f56c8a118sm610209b3a.19.2026.10.15.23.21.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2026 23:21:02 -0700 (PDT)
Message-ID: <fbc43e9b-563e-4240-ac78-5e81ddb01712@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 14:20:59 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 5/8] wifi: ath10k: check the recovery deadline on
 its own timeline
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
 <20260925-10k-sdio-crash-v1-5-14baf913df94@oss.qualcomm.com>
 <ceaf2db8-3796-40c2-830e-998af8c88b0f@oss.qualcomm.com>
Content-Language: en-US
From: Kang Yang <kang.yang@oss.qualcomm.com>
In-Reply-To: <ceaf2db8-3796-40c2-830e-998af8c88b0f@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAyNSBTYWx0ZWRfX0JuPQ+vtWvIX
 PYGEglzZaPhUqpIvaV8aVy9kwmN7L0/oTNQjXdCwBVPx/GD46raCG00SaS6n7lGVxsTjuuWIUfR
 nw92ejqW8bvUS91XWXF9Al+wihvlaBw=
X-Proofpoint-ORIG-GUID: 98WizIAwfJLkicA0gQ6zQ8bLBWaZAgDp
X-Authority-Analysis: v=2.4 cv=GJadgeNK c=1 sm=1 tr=0 ts=6ad1c250 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=sMPgGdaneUjR03wAo3sA:9 a=QEXdDO2ut3YA:10 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAyNSBTYWx0ZWRfX35jUnMguO3eg
 twdfMhhtqE0J2TOUOeQ0ljCjppzydItzxDSpqIKSjLiXEbHscXpigtz2dFS5j64u/Af6g/BDa81
 YTIiBVlVEckrtQYpO8ZPT7kJ9UPyoeWBGh8hUnjmD++WASeRr8gWx9lVx+xogjhXs00hed4uc/1
 NZ023v4pRF1gEeacv+VATnOfSI2kBPostMJdSMGu4mvjgLxVs/G5LoBlD7mmxi98JB+WQ98PUU5
 5TObxcpZifxH6UGzxo1NXkyQjMFbIzY4Vak8fkk5/7mKw5LGUFbpAwmX66QnpqqBTnKeMtYqajB
 0ccP9fo5U9M94UphwgQWwdiCJrMANaIcWk6e28h2f/H3MthWDD3zl5sfp17iw1Ejis1yMWn9JmZ
 J+MFl8rbR3pIpJxXJnMkT6D6K8otu4meHYb2ec2z84JQfsN/HF03aq04Wf5/YPQiEYCANrDwARl
 294MNoY1LiAAD0+PjNA==
X-Proofpoint-GUID: 98WizIAwfJLkicA0gQ6zQ8bLBWaZAgDp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160025



On 10/16/2026 9:07 AM, Jeff Johnson wrote:
> On 9/25/2026 5:26 AM, Kang Yang wrote:
>> @@ -8175,6 +8175,9 @@ static void ath10k_reconfig_complete(struct ieee80211_hw *hw,
>>   		atomic_set(&ar->fail_cont_count, 0);
>>   		atomic_set(&ar->pending_recovery, 0);
>>   
>> +		/* Stop the self-rearming monitor after recovery succeeds. */
>> +		cancel_delayed_work(&ar->recovery_check_work);
> 
> My review agent thinks this should be cancel_delayed_work_sync():
> Confirmed safe: ath10k_core_recovery_check_work() never acquires conf_mutex
> (neither does ath10k_core_enter_wedged()), so calling
> cancel_delayed_work_sync() from inside ath10k_reconfig_complete() which holds
> conf_mutex cannot deadlock.
> 
> The real problem with the non-_sync variant: if the work is currently running
> when cancel_delayed_work() is called (which returns 0 and does nothing), the
> work may call queue_delayed_work() to re-arm itself before checking
> pending_recovery == 0. That re-arm succeeds and the work fires again
> unnecessarily. cancel_delayed_work_sync() waits for the running instance to
> finish and prevents the spurious re-arm.


Agreed, will address this in next version.


> 
>> +
>>   		if (ar->hw_params.hw_restart_disconnect) {
>>   			list_for_each_entry(arvif, &ar->arvifs, list) {
>>   				if (arvif->is_up && arvif->vdev_type == WMI_VDEV_TYPE_STA)
>>
> 

