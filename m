Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0528361640
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 18:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785091448; cv=none; b=RYf6TQrNax3lY1+VlMWs52WkmFf22aJqB7cgehZbV8T05uQdTI8Yv1PgC0lelmj0+gPQNTf9X323xHd5q0gBfDOfvD8q5EO5q7gQJb4P1L8S/0J7HOMDaL7MogJRAo6Bl22NAbfaAgzQLOrmnj3Fy9I9VWjSdbKNKcdJr4gXkd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785091448; c=relaxed/simple;
	bh=y+xulUJw17QH78JAOFjQW4zFoEctJz+Os9f4taGkQnM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T7c7AornFrZudhq3dMhXZxP7URhBo6NZrvW/DD81ZCIjYRAwRN4/iCTH517l7luRc5He7lRzRMmT5tTPzvdoWkRvnD51mqvZToIMpY8f3a4W0hu5B5FnQpOyDcmKUWAWQao+zcU8IH5AlxPEgutyWRqbwTk6zjAvKhbT6GnsLrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hdJ1UvSS; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FATjwDNK; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hdJ1UvSS";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FATjwDNK"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66QH7rHQ1212999
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 18:44:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XXZUU3ezSC5J99mvDVW8COuRxpOmKWwBThMDg2OTDCk=; b=hdJ1UvSSugPo8JVR
	TL9Ay/MC3998iF7Ngk3iAtmcS9YNxbXGmAV8CIMaE3Y/Jbt0S0ZfNJqJF9nEdj8+
	1IZjXmDommTE5nq9SIm7X2L7BEDNGMmDVIuF0YJY14Ha/YUVaJtp02J/QJMp9fl2
	OdoFUxQ2T1L3KDvDjs+Ty2JmY/a0ufZkeHLnnhJXhzW1jk7tRhq1s6tEPinQKMhB
	TcrLp9P1ec3U9SFLvEpVcpYvkAI4J33EHfqegHDW4irevLTKqPXgpgkwpJuw33wG
	8Kksk4n96wSzo6Nu5CUvpxNSuCc/eRumYc51LstfxuW3kAz7GRcbQUSQt0GRnX7v
	yLaLUg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmmfgumr1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 18:44:05 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38ce7fabf76so3011403a91.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 11:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785091444; x=1785696244; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XXZUU3ezSC5J99mvDVW8COuRxpOmKWwBThMDg2OTDCk=;
        b=FATjwDNKzxXnA3IPOnZONqi1LgtEnJ+O6MpmjtDotBm2GoU8eoEMxCeX+MNMVioXaw
         2n2LMRpKdlALqDZU1kMpS+4QLR+uhGekQin2TXeJG1d+HQTa2jZ3FG7bsVHLaOaMMsME
         fVW19wWaCOuxO7XTiIEuVzAOzQayosGc4d1ApEvnkZZ34bEmkB5o1DUeudtO9nlNghtg
         efeSsg8+1XjrurQh7LqEVdRZcjqiuoliT8dWToxE2dZsIlX9pI2uyiiy9I5WxpAyCRaH
         orPaK0ogzwL/sMHXxcst0iswkSCaZp7f8vnmVBzi5WZ1TH5Plh+8o2GFRPMMC6wvSVDp
         xkKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785091444; x=1785696244;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XXZUU3ezSC5J99mvDVW8COuRxpOmKWwBThMDg2OTDCk=;
        b=B3pfCYaMmhRpOQ7uMW2lbJv+uTCrcjwoD+BJHYamjRoiHwO7eh0PdXFdV8KCnyaRmb
         RJQHjH2xkirRGcNB0yZ7PfZpg/6qAPBY/NUV4qSXuHW+aK5F1dRYO5Q/gaqJncg/W2Zx
         4kexjPVS2s7f4s4ckujLNLcrhOjnGMkBkHDRlZKDwOGK/cSx+2SLie/0BBswGnZI5mhr
         c6sA/b915Q7a+M95YbJP+08rajqPTbKZxA9WA/A31Xl5cyYRuIsPHSUwBaO2pNRUvgGB
         uWdjbjVlTqUxpM67beA3c0oL71RFunAjrtTO5R0q1TZpyxd3X8Wi+Jb1ra3UHzTwjI8L
         5uRg==
X-Forwarded-Encrypted: i=1; AHgh+RqL0vSB0QwJJCVRYqnmwPZ/zGShg9dZIknUiuMqEzqt3+dVMPc2nX6hK44aB8s3iy3Dt0w6984N0yTYQLML6Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxPjvQBVJ8l4RT3yXgGLRJyLAiq6J0/MwcZfWVnKJZvf5XD6/k1
	d9FlyAbvPzC+6RqEI4dWc5Q1jHFTp2zrzHGxfhTA5IyCNejrztnmOCjZCrO8NCFWJIo6yDBK014
	0AsInq3ir6ycRnfJehWiijeria7XTD8cjHeMAWLSRYNRGzliacZiqf0K+706hiiEnVJDHmg==
X-Gm-Gg: AR+sD13lfNQlI9AO2BD5fPNLyEHBYLsyqpn1f6QXzZH45OHZDmMXwucWQKkzPMrmWav
	c6wb42Sk57LB4+ku/V6gHDW7mUVu7SZghRY86mRnWGg1FkHCOLTF9SCCXL3GXpfYDbdRIIYTFjF
	4dz1lZoapMmt76DKPqDF+WPYciysRpl51DI2+KJ6JEQ057T4HVKI5xfZW02ElLaRvHGt8l5j6X3
	lV6Qrvoyagk6Qo4iR8u3XxYlBbAPWS/ucuUfgMvFBeOwYVxD5pDHZnhi895TtpjFlyjt4SUs91R
	VcODPNg+NHprTwXaxL68ZIzEH6+gOQoMfKQ8snYiEtjib8VScLlR5pVwC1nTYCrkxj5VMBoMYVy
	ks0NvEjJXMlbkS0RPFTHJYWkXxh/l8Sl5NbI6OyAi5tHYO/5FtnjLdrPKbw==
X-Received: by 2002:a17:90b:3bce:b0:38e:e0b:320d with SMTP id 98e67ed59e1d1-38f297812c8mr5478927a91.41.1785091444200;
        Sun, 26 Jul 2026 11:44:04 -0700 (PDT)
X-Received: by 2002:a17:90b:3bce:b0:38e:e0b:320d with SMTP id 98e67ed59e1d1-38f297812c8mr5478907a91.41.1785091443755;
        Sun, 26 Jul 2026 11:44:03 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc3e127asm37823640eec.2.2026.07.26.11.44.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 11:44:03 -0700 (PDT)
Message-ID: <a08afc30-48fd-4dd2-80b1-f793a9ac0451@oss.qualcomm.com>
Date: Sun, 26 Jul 2026 11:44:01 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath6kl: prevent assoc info length underflow
To: Doruk Tan Ozturk <doruk@0sec.ai>, linux-wireless@vger.kernel.org
Cc: tristan@talencesecurity.com, vasanthakumar.thiagarajan@oss.qualcomm.com,
        stable@vger.kernel.org
References: <20260421135009.348084-3-tristmd@gmail.com>
 <2714a585c88febf28ef49cbc39f2c14dbcc15183.1785006304.git.peak@peaktwilight.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <2714a585c88febf28ef49cbc39f2c14dbcc15183.1785006304.git.peak@peaktwilight.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 7xax5qde_uGCyul_pJweyQCmr1aMMh1B
X-Proofpoint-ORIG-GUID: 7xax5qde_uGCyul_pJweyQCmr1aMMh1B
X-Authority-Analysis: v=2.4 cv=GdYnWwXL c=1 sm=1 tr=0 ts=6a665575 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=98FGZP51sEc7qZ92nCIA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI2MDE5MCBTYWx0ZWRfX3s6vcOYq8IfL
 IjvWJ8JTAL2GzSkw8Cmiq4fTaZ9gQb6NcLQXi1s79wC7GYP4zbvNVzasdjNqFwNz/Amx2uqYBM4
 d2tWhunl3FQNRmqcfZQ643QyCAbynCU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI2MDE5MCBTYWx0ZWRfXywBjEEb5p9cL
 cnyR4/x/M9GeYZOBpSqApqr1q3W9V/a/StbwKthjz5wxYemfZJzJg3hBVe91VWsHDJ3KTL5JgSJ
 yVDEWA7SaDfBd+ks5H/aIXqX0U7P7c4G76zPBh2XjPocOf6dl+EMmYNA8RF5Z4tDKGA9hHgfvaH
 kBE+Vuw/B0PpLJFyFe8NuDmXaXEyQ6o7GgSGEeXvmNpfFgToFfXkmz0jJP8kB4ZN478bwm+coV3
 U3LtrdfDlU66l/jeB46HkIX2YbzbsJ/TkXZfCKYpfivojILM3ezE/djjzu94ES5vmVxJPAvvy9u
 WmI+PiYzMtzn9wM/FYy6bCmh/seKBVoegs16TXSgVWHdO4YF6M02a6H96uH4Qt+djXec7Fxo6ld
 x7Ar2Qh4/LuTP6uJK55CD6e6KfLP8nPiwZver0ZhzFezR91CWL7mDvg2BrvFH511+VF6XYPLCZz
 dJaDtf8cTzSuPVSOuWw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-26_05,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 spamscore=0 malwarescore=0 phishscore=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607260190

On 7/25/2026 12:05 PM, Doruk Tan Ozturk wrote:
> The WMI connect event carries association request and response lengths as
> u8. ath6kl_cfg80211_connect_event() subtracts their 4- and 6-byte fixed
> headers without a lower-bound check. A shorter frame wraps the resulting
> IE length and lets cfg80211 copy beyond assoc_info.
> 
> Clamp both lengths to their respective fixed header sizes before
> subtracting, so short frames provide no IEs.
> 
> Fixes: bdcd81707973 ("Add ath6kl cleaned up driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
> ---
>  drivers/net/wireless/ath/ath6kl/cfg80211.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> index cc0f2c45fc..62f663c0da 100644
> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> @@ -754,6 +754,11 @@ void ath6kl_cfg80211_connect_event(struct ath6kl_vif *vif, u16 channel,
>  	u8 *assoc_resp_ie = assoc_info + beacon_ie_len + assoc_req_len +
>  	    assoc_resp_ie_offset;
>  
> +	if (assoc_req_len < assoc_req_ie_offset)
> +		assoc_req_len = assoc_req_ie_offset;
> +	if (assoc_resp_len < assoc_resp_ie_offset)
> +		assoc_resp_len = assoc_resp_ie_offset;
> +
>  	assoc_req_len -= assoc_req_ie_offset;
>  	assoc_resp_len -= assoc_resp_ie_offset;
>  

The actual patch looks identical to
https://lore.kernel.org/linux-wireless/20260713213251.21161-1-doruk@0sec.ai/

Why repost with different commit text? Should I drop the former one and pick
this one up?

/jeff
