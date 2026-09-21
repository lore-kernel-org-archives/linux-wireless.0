Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F06E44F560
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 15:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790005571; cv=none; b=kAOCQu//FFWzMM5B1VBFaOivR9KsKGs3E9smS6Oo7QagtxQdkroltmTgpKaT/0NWRggK2jy1/MsQTzVx3zZJvaKUdEoNW0hS2d63I5Rz8FrgZY5+Jrmk2P7wVNrYZPctZtzt+aDIJsHKqY8g3nBwf8jJEJEHb0BZK3BjZCFLeUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790005571; c=relaxed/simple;
	bh=hozAwRXAz+o43fGXdj/M2st2++Az6btWF3To2SDZD6M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E9oHXdf/8bpizVhC7OONcowSx4beTAtq1+TNo8Eb8KJSX6gQN4aRGotzkHyVVrTaa+SrkqgOfNpjW4LZd3xwPLgI9R4r5YOL4Q0vADU/w+VOC8cuAH8VbL27lVpMQMcGZ1uN4awDvBajp0RpfR4s10w3z9zoRm6plHxZ6T07ECo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KmJpoOrI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=INe9iHWA; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KmJpoOrI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="INe9iHWA"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LFABhc1532378
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 15:46:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Z2rkdq6m+r101RZf8sS2B+aQ3DkSsZman0AdpPZreCY=; b=KmJpoOrIevgUg22L
	/xi3Wl8Dle1fI1WGyZzxAzZ9UD5Eo8h6KV8mX0u0rsB2cNQSAPLWUo2fFTIN3hmd
	PEglLnrsQ81fnVTtNd0cRD/fnJNBOmj75uHUXihX5aYAcM5Y9K3YUBp34M3TH9Kd
	Zp3rSnUUo4ZS9hCnN98cwKs1/hxlfUesISNKdECYKNddY91ViOdULFqTk3OLCcoM
	XVMk5koQYUlckP5z3BTm7zFcW17KD3F3Y3FXsyCPrbG6lxbGk4wB94DBngreBu90
	41JfI4PyRZK8b4D1vYuj6XClydlPyFY84ZFg9vR8jfLpBNpE47ecZVt/UxEnh5+A
	Eeo6sQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gtq8bbf3u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 15:46:07 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-381250979d5so3845839a91.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 08:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790005567; x=1790610367; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z2rkdq6m+r101RZf8sS2B+aQ3DkSsZman0AdpPZreCY=;
        b=INe9iHWAQYQ8R6bt6HuDAnMsKak5pxNxh1EZiF5ZUXI6CElwPPZKciebHNx0TUi+so
         XMnFu67vb5iZ2mhXtP0CVjd0BCHtIU84V3b5hri/z8UTKfYmvHQQsP7x8TJOVOXTD0w4
         3iXuHo+B+ibD1g0HDoCF4FG0ALqfxa4+2ojFSmXmbp//q1j2fUvP26yRGZY0Q77f220f
         4U1rC86CZqBdD0QasYbrbg69Vh4LUTdrCaf1lmWTR8ouF8yMCguz7c6Uv/yLA6Eqtb+V
         uH+sv44gAZ3XNkZOFbYTl2F8YtMTkVYkze92N0jIThy+MCHVhCOo7tljCK3Il2Sfba8v
         +E/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790005567; x=1790610367;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z2rkdq6m+r101RZf8sS2B+aQ3DkSsZman0AdpPZreCY=;
        b=EDCOMBR58zJpdtITgHW4R+RHFBbax973Ml+vg80ulUiwEJOkFXkPj7l0N1nh5BR3ou
         9xYfJbdJJTCjSYAHHXrVDzNLEyl0j5FIcoYWb6N2PX0Y4grg7L1oML1bK5TnX9hfRgo0
         ZpfjhrSAg4+ChAJBfWeEC13cMy7fmysLAWhk8AsCFduxCwHdDCXN/Do9e0BduFV1xu6y
         dfhx3M5e6Qs8xI0FleHHtmbYOxKnCxzk2KCSqE1zOaWP/dN1BVVAyw10Zpk8EOPF8W2p
         rwb0MWcBMbaCFDVFtqH4b07L6MYGp+IRGUMO0hgRUyNwehkn9tv2b7mM+Lv83cqVPXQ5
         VmoQ==
X-Gm-Message-State: AFuF++kaEdY6/dxFhT5VW3f9R/BeysHN/wHJWtVUiuJNLVKSEQYvQFIb
	MEo/kY1u9ZLOombOQiNkRnG9+wey5OBU8t0nQh1S22X0kjiFAq2bjYkGGp+QuwuTRWAYIIi+Q++
	XoBq4/uOLrryGYYCYIEKcVcytgpbLfECpB0gljNGyUim05DiXQ1SCHcUToA9oEVOxRj83OA==
X-Gm-Gg: AYBFou3lQ+KM4y4zt0tvNKIfNEQaULyDxm2843Zo/yw4AjWGfsZoJR7Nmp411HU5LbK
	Tpm0abz4jbZ4+4EFSu6u2+0tlf5OWXcYLe9Q0AS/VRhT8epI/U4aUGWFQi0mZlTsvPU09T3XFN5
	JwFdzxHchcmkHf/4M1jOYro2/KTyZbExSj/HK9YKHkrbverMrUf8q62kVQcs6xff1m7Ry4sDMve
	GHVPgWigE4OpAB+prPgFu2faXA8fNk0r9tsss8fK8OBRabgIMipON9UyQ2XK5mhJ9W0R/fvyNLW
	53lhNHGjzED1A/0K3LDr7X0EQpIM+VPkKNbWhWmeTvAlwDKlE0OgQm8p7shlwSwgn2569Cf0p3e
	hFHv+4pe/DAr1R+xHDxhE2uiyJGcWtcajgNw6gPtPtg==
X-Received: by 2002:a17:90b:2dc3:b0:398:990e:1587 with SMTP id 98e67ed59e1d1-39e54ce2debmr16645655a91.9.1790005566665;
        Mon, 21 Sep 2026 08:46:06 -0700 (PDT)
X-Received: by 2002:a17:90b:2dc3:b0:398:990e:1587 with SMTP id 98e67ed59e1d1-39e54ce2debmr16645609a91.9.1790005566192;
        Mon, 21 Sep 2026 08:46:06 -0700 (PDT)
Received: from [192.168.1.4] ([106.222.222.145])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144e857fc1esm5327908c88.12.2026.09.21.08.46.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 08:46:05 -0700 (PDT)
Message-ID: <c09e2ee9-f034-46a2-b185-e37e492dfc3b@oss.qualcomm.com>
Date: Mon, 21 Sep 2026 21:16:02 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v2] wifi: mac80211: Guard FILS discovery and
 unsolicited broadcast probe response
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <20260918-fils-v2-1-44e41f714f18@oss.qualcomm.com>
 <a1a5fa095dabb37ef67137bf1fb3ce2eb7e8d84e.camel@sipsolutions.net>
Content-Language: en-US
From: Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
In-Reply-To: <a1a5fa095dabb37ef67137bf1fb3ce2eb7e8d84e.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDIzMCBTYWx0ZWRfX33L6KcUHFL9S
 +l80aizQtSWImX6oaBfA8FHRk5SRdHcL4OngwXr4zIrRDIZ7gTdwdZBDmV46I7aXY/eXwaWxiwy
 bgwkaypQmLDZOmCFKh74ddrEEhzPX1QI28ADlDKmivmuP2cZmZ5DeKr3iWJ8Blvp9BEm/MBitfi
 5ygjjjr7LzkSSPpfdKiLEphtO6SfRSNTz8vzhRUTVPLvb45DcZHJ3Fz4TS37CzAoc232VcHF3EC
 U144xg7POZQTk4rIeYXXv0ECmJ12dm6pr0qzjZFe5zKou6POQ/WOGV4/V/8pYr7rIvcJnUhwC9C
 AZ/+IgQICk5DT2L5sFOTZu/7RT7kS3XfxesdsXPIbSOu7eeM6UYvPD3j3uf97HsmFjVKZ5dE2q4
 8gtGlAcVK4u5wDF0osRhHV+9XMdiEwwb3js9ykcZGZ/a5jLRWnujuCB0IGtFi6KXA/NTz4ay8T1
 wau93+HZdlGVN6uLp/Q==
X-Proofpoint-GUID: 8oDYlV9xAgCBYuH08Z3w9EtpkGOnPKCf
X-Authority-Analysis: v=2.4 cv=T/8Z3PKQ c=1 sm=1 tr=0 ts=6ab1513f cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=UyVz4rLoAiEoU2dG2e9Ehg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=czpennn6YFGkshydcakA:9 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: 8oDYlV9xAgCBYuH08Z3w9EtpkGOnPKCf
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDIzMCBTYWx0ZWRfX24MAK8OnHXp4
 t3Zc7Vot83PHMIC67jwZFtMa6UpS8Vsx/9K+A+Ljomu+51rM8ZTnyRIx3pTgwfrZBPrA47b2vUV
 +0McaLfeI8gqEGLPPZr0yUPuTSkC1/Y=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_05,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 phishscore=0 spamscore=0 adultscore=0
 clxscore=1015 malwarescore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609210230



On 9/21/2026 2:27 PM, Johannes Berg wrote:
> On Fri, 2026-09-18 at 12:47 +0530, Manish Dharanenthiran wrote:
>>
>> Currently in user-space there is no restriction on sending this for
>> non-transmitting BSS, thus it may send these for those BSSs as well.
>> However the driver will use the config only for transmitting BSS and
>> ignore for non-transmitting BSS. Returning an error here, even if
>> user-space sets these, could be fatal because failing start_ap or
>> update_ap operation would result in failure of bringing up those BSSs.
>> Thus, ignore the config for non-transmitting BSS silently.
> 
> And honestly, it really _should_ be fatal since it really is a wront
> configuration, so that text isn't really that useful, nor the comments:
> 
>> +	/*
>> +	 * Only transmitting BSS should set this config, ignore this config for
>> +	 * non-transmitting BSS silently even if user-space sets it, as
>> +	 * returning error would result in failure of bringing up of those BSSs.
>> +	 */
>> +	if (!params->update || link_conf->nontransmitted)
> 
> Please state that currently it actually _is_ (erroneously) being set by
> hostapd and we need to keep it working.
> 
> johannes

Understood!, will modify the text and the comments in the next version.

-- 
- Manish D

