Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3EA3876DF
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 10:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789034715; cv=none; b=KhHQyineVbJ0I9wl2NU7I3fUt41t7ypE6eqhVGXl98MEiwqXXF7ody/on9S2+5LGYKjvl3hy5PVWywRsz65ey2yec7kNFX1VFwGmix3oFiHNLcEYDjygxvsTBkxqyvHbqsmIZNyhzQCSPZ+IaI5A2uL/X8jsB7LZMgyKRLF+ro8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789034715; c=relaxed/simple;
	bh=SACPxVOMiP0XUcRyX8neA8DPrvzFSsUdMd+WN5PqxCc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TnbtFqrOmBCuhQs6v8ug+1sOsY3pJAQwYhcykylxmt3cCw96dsEVGxSCVYDuA/Gm/ZjY1dYDnJ5A9VNAu8j8JhLrjMwNumNmqtU5UAW2M+Mlfg1jToM6y41Eg4UdRJYeT/eOO/+4xJY3OulT+k0nj3VLfbB1c15vduO0Pjqm7aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=S/i+bWC+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZDj14Yrp; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="S/i+bWC+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZDj14Yrp"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68A8plUF1589610
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 10:05:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	eo2RKqSNVfezaG6n1YKB/Qqwfna+mgtDJp6E6EKHINY=; b=S/i+bWC+Tjyzo9pb
	EA3CIkiXaZP6OWGzSiEZptZKpBvmci2FSK6qpC2whzZnoHotHTv2IUy5EsT/j0KH
	rfuGcXNKmV+rgfC2Qx3R8UHkFa2m6tK7Dh0c0IZRFan++RTjW+dFMGGGjo1RPyUL
	3zYc79930H5xny71mv+a9ss0LZ8DRm7S1GdeglIxjA68habqvYuTX3wWEMynqhQB
	+W8aoYVZpejhH7dR7LszBoTw2C61fEhW/gKX8ZRGzbUhB6L85wK5X6IFnPEgFsqc
	mZhptz8z2R+wyvcQy5c3ZHaxcnq3EJ7dBKTEn337IwI6gUlAIV0r5tAPVuKEAXxc
	2gNcfw==
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gkcyhb82u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 10:05:05 +0000 (GMT)
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-45e6091d8a1so4190781fac.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 03:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789034704; x=1789639504; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eo2RKqSNVfezaG6n1YKB/Qqwfna+mgtDJp6E6EKHINY=;
        b=ZDj14YrpNu1VfKePKH0Eu+cLp0xa0jIeTRu5YG3DurXhyj0epXKRIzn649DLx8QPTo
         7cX2EvXtqZGTZ7nVL46/sBhEJmxA/AN2gf4DBxPAG1g94wAajvXyj88BfYoYRb37hiFe
         1Ut04/F2MWDRad6rIg0/kyVH6jEz5qE7s9MWXWd5jATjlMtQrdcUZxmeAg3I4oVUP3hK
         du7hF2xASWEW4mThRYN7vx4QLFQDmzRxd5sxeuuinVRBlZjdl3ufsiFM2fHR0aB0BB5E
         Z/SgKZStaV1D8PKJxYCZbj6mSI0wmP6MFa9YNFpcXbh653pEufDBdIl2+i1geF6Pr8uL
         6FQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789034704; x=1789639504;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eo2RKqSNVfezaG6n1YKB/Qqwfna+mgtDJp6E6EKHINY=;
        b=FecqSObFq9GW/Z/F3NJ+1ciUnbyu9kQHdWj/mTdJDVgbgdLjRDP09AdrRW0zl3EVub
         VhZNgQgTiv7MpmTs9Qg3Sc/FJ7Aitesb34yzZNMQRg7pVJyZNCVZ+9r0Z4itwpp+HfTg
         2YfVq/A63teHcsGg0gur5O/qEL+q2D9s6MnrWFOJ+NTbIL8/d8ARhOlNDx5UBDpWLgRk
         lMyZU7I5sEMoUIyLu1PiEwbAnsS88rX0/EgGT26hi7V/T50ZyqCIxSRt84Z/uB4qOYfi
         AvdgyXpaRDgJqT0rdg2NyDwp1VKOBwUPp5YJQeIPxqFeD0KxgSMeqtqgP10HUpZKthmH
         yk3g==
X-Gm-Message-State: AFuF++mX73sPRquN2uIiJAJEZsHTJXpptwsuWg5iOoWjEeZcmHHSOh2Q
	n3jEXj05Ufwzxiw8i42blFfDAh+TVOEMex4DHwdgSIulNyY8BjzLU+WdDCSLbdOlKb1UieJWmHN
	nhz5Cn+VpcibpLcGndJGnBsyGvowmjKVuh03Gu72PrUvOr2eCagCk5fnQxk0DUtXzO1ZBtfxkIv
	Q1tw==
X-Gm-Gg: AYBFou0pgNi6lyipVy+f1Q37eudvVa0qA/QvCcjKT5Fur/rQ/GvfgYv367HqT7NK66b
	IUJuUvps6Ex1FuF/vIqzq11wY9+uNs50vbNwIDEWYstWon+40AO5sc3YNoYf3KQffToyH75tUs4
	XGqxM1s0801IwE/5kIJIBSZTPT3iSUOZMxXArN6RowdEVeBZE7EY8AfYod1PCeS4X4dRBdTv3WK
	Ciq83Mt3jTDJxjKhYo3nsDcY6M8pYXstJ42pfGeNTk/oHswF2Q8SFiE/zGVEu/Aro7JTFRAqPtc
	iuvg6eZJi/Jdn9b5dFtg7CbyhsJbyR3DNDgNOXe2kQKs9srluq6RJyKTqwSwsMnOt+eme5f97uZ
	GqBhffdcoDz/GqquJk/mvAPko2qCdHgHWHJ6iQprvEQ==
X-Received: by 2002:a05:6870:a10d:b0:475:a112:1267 with SMTP id 586e51a60fabf-475a1124a2dmr20571055fac.20.1789034704137;
        Thu, 10 Sep 2026 03:05:04 -0700 (PDT)
X-Received: by 2002:a05:6870:a10d:b0:475:a112:1267 with SMTP id 586e51a60fabf-475a1124a2dmr20571025fac.20.1789034703676;
        Thu, 10 Sep 2026 03:05:03 -0700 (PDT)
Received: from [10.152.207.30] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1435c2ae6b5sm5871301c88.1.2026.09.10.03.05.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2026 03:05:02 -0700 (PDT)
Message-ID: <b482ebd4-d8d1-4877-bac3-91dddaed7b8c@oss.qualcomm.com>
Date: Thu, 10 Sep 2026 15:34:59 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next] wifi: mac80211: Guard FILS discovery and
 unsolicited broadcast probe response
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <20260820-fils-v1-1-56df490f5bb6@oss.qualcomm.com>
 <63ab746686edee2e7919edb1cf6c5ce06e9999d0.camel@sipsolutions.net>
 <ff91a2e3-fd29-46b8-ba63-7cfe0f8c8e26@oss.qualcomm.com>
 <053ee8a223389f533a830c15146ccd1ecc631188.camel@sipsolutions.net>
Content-Language: en-US
From: Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
In-Reply-To: <053ee8a223389f533a830c15146ccd1ecc631188.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDExNSBTYWx0ZWRfXwwkyQPXQSM5/
 f41iKZ8rvnXdcRqZKQZyDj2AWvxeZTrGNMRC+TZP0WG4raHGX+L3AW3y7KLS4pIIpDLgBxGu9zF
 wfj1JFhdylPmDa8YPGTeb05YQsJrq91/75yI4UGFMlq+mfLBAlJr74At7dZG9YMs53i47LOgCqk
 UXZNurvKLb3cq4Xe7RBKrgbdV7Uz19hsBXm8295aafR8YKfT9yINpc8tzPcpPqPkHtaIs5ew6T3
 TmTDnVYbkR5+3iAgEylCTEwQadDphrnSgp++6x1zrJHkTfFzOXou1g6aEHO8CjWkr1mtWGE3PPR
 +ICR1NoNshLDWEwaLA+REPVrP9RUHSkmVW6BgZzmhOcyxuBpIb+rwbaOLi2EdObsvsOXT9O163j
 jVb54euGdot5QX/4tW5rOIvFkMZ7O0C80YY2DYN8LqiAnzDTHezVwjjbfHxgwjK8H91YF1hl5nW
 umEPPbiCLawIcSZwEPA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDExNSBTYWx0ZWRfX1H9TdIHfkrUz
 U+ryZCuJO2EUKAAPtj4o5eifB6thUfYHrESqdhQY8HkR+dWmSi8RiZLDpiB1qCY3K8BbEM+h+CJ
 WnHcEV11EW+mYiaEol5TXN3rv39EjPc=
X-Authority-Analysis: v=2.4 cv=YKgKWhGx c=1 sm=1 tr=0 ts=6aa280d1 cx=c_pps
 a=CWtnpBpaoqyeOyNyJ5EW7Q==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=v1fTYCAii-qQJu3JF0gA:9 a=QEXdDO2ut3YA:10 a=vh23qwtRXIYOdz9xvnmn:22
X-Proofpoint-ORIG-GUID: BvaS1seBApl9lPw3qFogDHPMe8Qau6kl
X-Proofpoint-GUID: BvaS1seBApl9lPw3qFogDHPMe8Qau6kl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 impostorscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100115



On 9/10/2026 1:40 PM, Johannes Berg wrote:
> On Thu, 2026-09-10 at 13:14 +0530, Manish Dharanenthiran wrote:
>>
>> On 9/4/2026 3:46 PM, Johannes Berg wrote:
>>> On Thu, 2026-08-20 at 21:37 +0530, Manish Dharanenthiran wrote:
>>>>
>>>> +++ b/net/mac80211/cfg.c
>>>> @@ -1138,7 +1138,7 @@ static int ieee80211_set_fils_discovery(struct ieee80211_sub_if_data *sdata,
>>>>    	struct fils_discovery_data *new, *old = NULL;
>>>>    	struct ieee80211_fils_discovery *fd;
>>>>    
>>>> -	if (!params->update)
>>>> +	if (!params->update || link_conf->nontransmitted)
>>>>    		return 0;
>>>
>>> So why shouldn't we just reject it?
>>>    
>>
>> Currently in user-space there is no restriction on sending this for
>> non-transmitting BSS, thus it may send this for those BSSs as well,
>> however the driver will use only for Tx BSS and ignore this config for
>> Non-Tx BSS. Returning an error here could be fatal because failing
>> start_ap or update_ap operation would result in failure of bringing up
>> those BSSs.
>>
>> We are working on the patch to update the behavior in hostap as well to
>> not set this for Non-Tx BSS, but to maintain the backward compatibility,
>> and the update from any other user-space application thus doesn't handle
>> in a similar way, we ignored the update silently and kept as no-op.
> 
> Then please document it at least in the commit message, but better also
> in a comment here.
> 
> johannes

Sure, will add a comment and send v2.

-- 
- Manish D

