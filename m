Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793764470;
	b=1oNSnRDYvUtbrFkGugnCkLQmYizIX2YUcpMNfJTr3FcNvv2ehT+sKQpkG4PA2eB8tAW/
	 /2Yer9dXP6pE1VO1YQ1s+YQwOEi+1M6jcdZ6on2FOUi0YDmh2emj+YTVK5MMLj0FElCSK
	 rynEszGvV8LfyW75aL6+hHDLcP+rDH8Bp/Ms37LOvcx9+MEnfOogzqSfSRawP6+siKK3L
	 L1aF/Ph0VoZvsVKKLFNiW3z2hqm4RM/YsyH10t2JE/5b0w5gWqOJElG5fXAgcd8W3yBjN
	 bCNHPjFZsKtZ6E9MqP/bSpMFWTu1YkkKBiOtUc6jBcxJSJuH4FgkKCrB7sAmAqtCdqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793764470;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=m7+NOH4MhWfRgcI+7jjgL3DQtg0YekoL23BYj0Hd0wY=;
	b=hlxwXve03gZ7JdVqoTYYG/jde8ThjhUzG1kj2oyTDc5dPSdKtBkG5o7jicl59qsnKNpN
	 w+PFsQYkEIyITBH0ZF+CQXDXbqAYYE9rnyrdgfCxqouwfTRcUR4vAWLpO7R6wuAjPWjgk
	 UhgTBOqmgprLtbR3zl7RNAN1I50niqNMsqI9+gHcR8Bhtqhx6tFzB9rlDD9HeOgsIcPjx
	 PsJsh0/8/MkpohEJ2gOmivWm+XZ3grIAK2yBLvxpjve6oQGEbeinVM8NVVB89K4+u5m0+
	 TELEfo3UGyz4AovJeWpXZgPc9eVWGetIE4bIg4Z+vaEpUDxJk8/e5AlFVey/WvRsbpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=C3Rba0GF;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=G5qoddeh;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB625606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 03:54:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB625606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=C3Rba0GF;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=G5qoddeh
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40RL7m222109
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 03:54:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	m7+NOH4MhWfRgcI+7jjgL3DQtg0YekoL23BYj0Hd0wY=; b=C3Rba0GF/QcKThUW
	NsBWvZ8NpJFtFRjhVZVJ1rCotJrrwS/hOToRZQSJ1l6yV2i0+JzMePOlAIjtGsK/
	Z6mlbQlwZIrQCvV33so05sb9UvNIiqIoc/JTZFGFf0HClElQ2z7RthGo5kLUJIR9
	3+0YLWBHm+dKs+Es0mzcu0icd59EI2KCHn/S+dRmaItmWDWUZu5nH1nVmgg8c6xE
	Sx9dXJxYiAAL2jcI+7KzTt0gJF2INIEZGNrdTvRvqd6pnL3Vc/bUP09N4sX+JN2b
	UQQXe2kEbtdIvTF26F7hvDGdW1AQ15S2+IqZhvzs4gIf82DFLGQVWZjPgoW6f93M
	C2ERMQ==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqjubjm53-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 03:54:28 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-89ff475a0deso369306b3a.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 19:54:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793764468; x=1794369268; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=m7+NOH4MhWfRgcI+7jjgL3DQtg0YekoL23BYj0Hd0wY=;
        b=G5qoddehTF+Y4kKbt3Awq22Ef5KHhEL0FwA9+JYDFZ0XWzq2NBeN3SZKro2Qc3dLFd
         8yz6Bs0TxvpG0rqVtWf824eaI/Shz+ixWPSG2G1QKJP1WliTgIY+VEJrdpUoYT3/QEHi
         fQ/ftdK6sXu30DZKlVSdZeyi2AiJLugshW1zSR+x+0TV5bc9UlszMxJPzcXSOAgjjfQF
         pe1IOLamOCiGuOzkUjYNYzfed3X1PhLXPHJ6dsPmpo2IhqHn+CKCE5QKMic4hfSU2btI
         hlLoqsBDKWv3wdUZmtUeMR5fwSTDqJQsFm1vFiYtypqVC/UcBTyv0oKEFVF02J+F4D9H
         cZeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793764468; x=1794369268;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m7+NOH4MhWfRgcI+7jjgL3DQtg0YekoL23BYj0Hd0wY=;
        b=bQxcgZCK6GHolls7KfhpC3Gd8X9Mk4iGA0DInnvuw/j5+6zt6Ji0XKUuwwuigj0/nK
         jsCytU5V8YJ5mLQOA/TP2Z884ex4d5Zajp1VWlbnfVnqvBMKOwZ2HO3ZDvuFRsXcwCkS
         vtzR5swoRaNJ4Oeui5qeZ69K6b9uq3QydaOZwI5+13c5ziO7iIWlVSlCN1HzL74oU/r1
         +wZV8JWHaAKJ+P3WKuY1GFGFxjDrxNhIZo0OLmruscoHKEXmKg4vz1E3kEQDffbmr/3c
         FF7aI7LdQ7+uDq08H+jJZE3zJ9cyKJ4OqRpIrYZFORnp4h9/WXaHHTxqf6y1Y0vd8OiD
         Id6w==
X-Forwarded-Encrypted: i=1; AKwUvBwyGLdDIhIKgAnTPfxvyWZFXzEV99k7a1eicZvbCEgv4GROh1/S6uoJua+FixO5uNt4Vy03wrIMkm2yM4zyFg==@vger.kernel.org
X-Gm-Message-State: APuU4Z+kfVZarEV47VUwgthhwVpw6uQ6YQwiXriBXn2AateDp6jkXE6b
	5idf/JCLjA3aG2HqGmxT0AFhj3VCNvC+DNqYMgHfZa0/X7r1qeyNxijJoVayrLe024LtB5UhaPH
	Iw/r+MVx1qAPOt5TlkSjDZ7Q3l1g9Eg2NYqMDYPKKOsNP1beTVK28bBe2FaTFu2GkXmary7USL5
	ONOQ==
X-Gm-Gg: AYBFou0DsqzAd3EZo2WxpsyrJqbnLo4FKoqveIqCpG4pfRBvV2GLHgSzKdG/4WbTJ2R
	ScZS9nDHMAgg79/IX4zC2N2r9WmL9BOlAahztaIp5r6l111yPXBzZVqExj42rKIh1OV0Ugf0fuS
	1sdIH68WJ8Wu7NbsrUccIlz6h4bWrwSHu2x5jRjmZFZw6X4dtaNvWYO5biTw5amU4Bn27A5CzAh
	iiJ70MjFZBmuHs7ejdeghh9PVQpbtUawiEOml6MAYluVBy+auzvEhP9xSda7GmUq93vxmf/k/vN
	vPsU+cSMrtRAMRtBKCTnK9LUD7alrNzzAVe+jXPqmTx7oBjp3N/GRDUk9MjIRWV3xcagLGSDckH
	9OHVyE5uoi2StbfCoYObLdNt4rMOpm05j4sKiXLJhgKzeu8au5GgbRu6WDNPDQj9U8fjQhYUswk
	g/jK8JhyNt42CzRWarSljw7+P2mH1AAFYYVfsBTbT4OMzN
X-Received: by 2002:a05:6a00:4106:b0:89c:1f2b:a73f with SMTP id d2e1a72fcca58-8a9bcff702dmr11484371b3a.17.1793764467699;
        Tue, 03 Nov 2026 19:54:27 -0800 (PST)
X-Received: by 2002:a05:6a00:4106:b0:89c:1f2b:a73f with SMTP id d2e1a72fcca58-8a9bcff702dmr11484353b3a.17.1793764467131;
        Tue, 03 Nov 2026 19:54:27 -0800 (PST)
Received: from [10.133.33.51] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b097fe108dsm325872b3a.6.2026.11.03.19.54.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 19:54:26 -0800 (PST)
Message-ID: <d613e20e-16c3-4a39-b9a6-538a8740d2d6@oss.qualcomm.com>
Date: Wed, 4 Nov 2026 11:54:23 +0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next 4/6] wifi: ath12k: register regulatory
 before wiphy
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
References: <20261022101836.148512-8-johannes@sipsolutions.net>
 <20261022101836.148512-11-johannes@sipsolutions.net>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20261022101836.148512-11-johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAxNSBTYWx0ZWRfX0ofaLLt2CRB0
 jLKUIrwNDmEhe3oWPVCtywKZ/xVj3HF4l30n/w0KaUT7OVEv38PQTGrJ5n2MSfRUUBL0th/pqPS
 OqimOeUtYp25sEOIQnrkdG1AZH1GckI=
X-Authority-Analysis: v=2.4 cv=JeUpPkKV c=1 sm=1 tr=0 ts=6aeaac74 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=QyXUC8HyAAAA:8 a=kUuURSPBNhE4Y9GrldsA:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-GUID: HW-wDgL0HtyLbEpr5SEO2ZMHo-4lBvId
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAxNSBTYWx0ZWRfXyT8xsXn3bX+h
 NtrKeZB4zMd9YIUziJCLaib3HVkitEKWilVbjBJot5o9Vy68outSUqabj9mfSxwewyUQiJqPi0M
 ytQCQ8NbkAyZrqp37zH+YRs0Wwg7TlJ75uCdF8ZB89B51w6Y+XTPK6UQ9t9WCNL2i8nPX0bP4C8
 zXaa3Qwsx6uUUiwcvYJXdWVdAOMuL+vC/ZNxDs1mbd6K7rlqdLPoaeyfBrpWjqYpf1bbrv86dAW
 wQp0sKAnu6hJZD+L/F+4abL6D7E3ReW4CYoyjNx9KWTlSf/XIofORDA0jsjUZ55jpWtoYGQ5Nl6
 ieAOvcM3ZbZB2zhbA9WJpFk3xUkffcBMtosrtBs62KW5FV6+zfOv14nVZrFc4oqYoElaIhUb+fu
 ++1BVAO/xWgmNNaVyhiyzoq0nNi9zqY3dS6rjhYV7cgsX2sAYGWW2GawZh0g0GOs1LvRbBMc9/o
 ZlzyfwscD++RaJGAOnQ==
X-Proofpoint-ORIG-GUID: HW-wDgL0HtyLbEpr5SEO2ZMHo-4lBvId
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 suspectscore=0 priorityscore=1501 bulkscore=0
 spamscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040015



On 10/22/2026 6:15 PM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This order is going to become required, since userspace
> can query the regulatory in the window between the two
> registrations.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  drivers/net/wireless/ath/ath12k/mac.c | 21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
> index 01f8c6572f65..2b52f76cff10 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -15094,6 +15094,14 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
>  	for_each_ar(ah, ar, i)
>  		complete_all(&ar->regd_update_completed);
>  
> +	for_each_ar(ah, ar, i) {
> +		ret = ath12k_regd_update(ar, true);
> +		if (ret) {
> +			ath12k_err(ar->ab, "ath12k regd update failed: %d\n", ret);
> +			goto err_cleanup_if_combs;
> +		}
> +	}
> +
>  	ret = ieee80211_register_hw(hw);
>  	if (ret) {
>  		ath12k_err(ab, "ieee80211 registration failed: %d\n", ret);
> @@ -15111,13 +15119,6 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
>  	for_each_ar(ah, ar, i) {
>  		struct ath12k_base *this_ab = ar->ab;
>  
> -		/* Apply the regd received during initialization */
> -		ret = ath12k_regd_update(ar, true);
> -		if (ret) {
> -			ath12k_err(this_ab, "ath12k regd update failed: %d\n", ret);
> -			goto err_unregister_hw;
> -		}
> -

Hmm, this might reopens the race that 906619a00967 ("wifi: ath12k: handle regulatory hints
during mac registration") fixed: With this patch there is no ath12k_regd_update() call
after wiphy registration. So when there is userspace regdomain hint sent during
registration, that hint is sent to firmware and firmware update to host with a new
regdomain, however the new regdomain is simply ignored.

I'd suggest keeping this old call (to make sure the new regdomain is handled) and
also adding the new call before wiphy registration as this patches does.
