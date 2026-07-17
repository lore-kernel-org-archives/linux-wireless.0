Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBAF2F5313
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 17:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784308121; cv=none; b=UbV0j9jLZ0afkQO4OVATt0oC740IqQbRUeWmbBKzbMxeLI/ycaSRBaygzrQ6bef4vCyLN9zPM1EhXXxdHgOy7WQai4AcFUZ1npC9HVaXl06Z0rOwNL47dSrqhkhF72YEpr8IugONDTASFm5zVoXh3UyW/2ll3a0Rc3ZzaGagLAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784308121; c=relaxed/simple;
	bh=v9rwAemXOjJTrviJF/bhq++m8F7SpFsDGXfJ0ogZaz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lqt43f50yJr3FNlmIOrHyx+uv37h3TyqcC6G/QN+soukPmqztrSa8FYJr4fGkD9WVqFW2gDJ+rTBj1sowYKOzFR1FJ8U+d4yYQH7s/CuNWmKo32puJOgU7pRtPt4UDISTcQ0e9ZoNvs+9uVpnzC6ZLdxGn+W8zcV2p8hXQiN6Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WedKg/rm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MN8MP1r7; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WedKg/rm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MN8MP1r7"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HGo86n2245237
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 17:08:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	as3BzJOlBKPvMbzvYeL9WCvkFBQI6sOqi8ZlzCtZ3cw=; b=WedKg/rmLwpUri+Q
	XUEOxKQJXB8qmqreY5FSdEKcVqF8suGCye0K9URodZHGqEmgFxf1gKPjFzGlEoJa
	RBpMVn/DvaA/UTGXOLunm+alkCGlAcda1CjE9lGrcrNLxyRuuJNsjDbEBq5Cjv94
	xcy/cNnmNwNKVTmAJntJiOrj41l5wd9OaSZ9NfBS90SR1h3G37nHo80hQ+q10WQx
	fn0RUBlyoCxVi2pW4RMr0amBMlo8w2Auf3YR1bENULUIgof1KwkPrm6OQrkyYDHd
	A02oN8Wdfd1DVZ8nGTundh8jOhYD8RUpETTMIv44i85smz7Dl7C5uyWbSuTtQvwm
	RVcUyg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fff9pafhs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 17:08:37 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e095fd889so9347552a91.2
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 10:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784308117; x=1784912917; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=as3BzJOlBKPvMbzvYeL9WCvkFBQI6sOqi8ZlzCtZ3cw=;
        b=MN8MP1r7kv3FZCYs+DEgQfl39OVgRfujazrcfw2Tcse2pkgVfReSr+c/E5RTUaUqwX
         VZgifGklWeEV8IFThDQL4F1KIUDhT3wIajXPpC/nW4lDhVMjCtnMwjvpTVJyjzapTJkp
         AFJ6YiSuv4VFOPQ88fc0Za+lEAGTuTGL4hAO/wKkDUlBk5zMcIWEldqQ4pAD0kjdSqKi
         iCVUti3cNuOvQW2R3PrLkkqfrTw+dkoguwKoFAcPcjRCL01FjHHjaX/OhX6dFF5cn3QR
         DkVGswv0AkGJ+8suTJ64xzKlvLDJuWOWS/oc8Xx8OWz0w4nNVD9gnH3E45w4ExbBhSyz
         miUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784308117; x=1784912917;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=as3BzJOlBKPvMbzvYeL9WCvkFBQI6sOqi8ZlzCtZ3cw=;
        b=les0OhH/mZy62KAmH0aoVoY/1dizYEnYKdl37OWe8b0fMLEMxCJTbip9nFArnOg3Ay
         pbXnGnuHHdZZDhyI2BBHmvAziGMlb3wa8QtJUlVFIJn8p9f75yRz09wHvVRuLC78Ooxx
         z7Znyb11cE9XhMl7Dj9OeT2hbJL0/gd5zn108wR23aQFeIu2HDprbSZLfa39GLN3ZuxC
         RbMXhh1x5ifTviDWZY8l1sWO6jRse55o7rF074NRydKfRNvx346hYOwOfxzsG5zQ4nku
         Oe20nHrScbipRt12aN3JfXwEhlzFEdESGRk3Y42iJ/26cLjOegckvk4aWzliDXNea7Yy
         c+OQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrl3KD1anPDimFXwSzQhCaX6Lts1y5Iq2mNyZSZFd5wf0FpE9n/jZ4JYGUNELAt+jp2Yvj7z+vCcJhJK293Zg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxjHqg24T7UlBLsFTNY4/p2qILvAY77uRe5pp0Ejd5I5gWrDebz
	WnXkjTYgdQtmz4ccQ64KyBIG3BQlftSrhWI0AOm2VQh775g6U3oHTLNVaz1V8q/4eUTg6/5DBBI
	kwxfwgvLc9HYSZhEer2nfBOmdQNSWkTSbJKcSVybqsZiJVD25Y3polTp5rGy8oOV9IY7oww==
X-Gm-Gg: AfdE7cmT59l1pFtV5/PnnKgreJNKjluWmtYw6ZBGrhSx/QB2+/AXgwVgfy6xzl4E2MY
	4rE++3q9EdLsDk7ZYWl9PVGUp+ZTsYgt1lRh6DNHkooLtaX+ozXBpWJKvCW0XXKG0CbTvTqmYI9
	1ZCZpWcAJHWI9KS9rh1T3S/ejUw8hMM/1khLxTcU5ZGFKBN3jeHYX8pMGSE1EDZCJmHERrDrI1J
	Qh2Xm549FYn9Nk/7GZMKlZVShd9yOY3Qv3o4jdiAfjWc9iMDhySvxjuAWvX3t/8AVyzcijuTLr/
	pYcL6fTCELICyWaYNjz/kGwSH6w8l/3M//AhCOCJ+LX9USp2dEd8pZNhbNlzb7i9bT5Gpq/mrgw
	Ds2sROQN88lbLhL3y2fQ5AUSb4og+qraqIv/nyjeVZ5bBIRn9tV2tQL7NUQ==
X-Received: by 2002:a17:90b:3942:b0:37f:9ce1:cda8 with SMTP id 98e67ed59e1d1-38e4b59469cmr3604170a91.30.1784308116600;
        Fri, 17 Jul 2026 10:08:36 -0700 (PDT)
X-Received: by 2002:a17:90b:3942:b0:37f:9ce1:cda8 with SMTP id 98e67ed59e1d1-38e4b59469cmr3604119a91.30.1784308115921;
        Fri, 17 Jul 2026 10:08:35 -0700 (PDT)
Received: from [192.168.1.11] (15.sub-75-218-246.myvzw.com. [75.218.246.15])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a210571sm8941834eec.31.2026.07.17.10.08.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2026 10:08:35 -0700 (PDT)
Message-ID: <9d7093ab-dd98-441b-9ccc-ee0b7fad7923@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 10:08:34 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: cfg80211: Constify struct cfg80211_ops
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-wireless@vger.kernel.org
References: <5aace954b6ef5c42017b83a1bffb859618e9498a.1784013180.git.christophe.jaillet@wanadoo.fr>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <5aace954b6ef5c42017b83a1bffb859618e9498a.1784013180.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: jQVrkom_kKdXZ6I4B0Si-1txEm8eICxP
X-Proofpoint-ORIG-GUID: jQVrkom_kKdXZ6I4B0Si-1txEm8eICxP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE3NSBTYWx0ZWRfX59NpZ9w4hfgC
 I7F3sqA/pqqJgat5TBrY9pEnW03os1K23bgwqbGZC0Tc/QEPNKU+Riu5ZwkMyoCgk+HxHrZ0S1F
 Vlt9PtpH7J5crR/A9GCPv0FnA8PDgueSQGMiprk18KI9bqg/Ty90HI70tpGUsFsBtkf0ixUcthW
 24v+/NVO5TpcnXKpllbvpiSUrGEscqzu5crlDcN8XAsp+6/3/AnyzmOoHvsBeM49CN5jbiCz+qX
 6bhcO9WoFacuQotXNOwm98NUIKInigxubbcoM2NP6XqlTaFbr8PkcFteNcuPuIL5RiVooOPdt/p
 wle++xWuxyEjNch/I2vpIHIENnIxJRq/uOjuLlLP9uHD8fjPqWixpDqJD2ZspU3YGfEWOLiIBXC
 s0AGdK1wT0Sj8y8wLJXjQn5Wk7dUXEgFxxFp0xB2E9rqSZ4dKZ8aYP/1dIG7Bh915cRSVb5EVwm
 /utzN9jxg/ob9gcjwBw==
X-Authority-Analysis: v=2.4 cv=TaqmcxQh c=1 sm=1 tr=0 ts=6a5a6195 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=6VQYfvmiyQ8t40WkS/mQdw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=NKF_ESviEq-D5M3B6qQA:9 a=QEXdDO2ut3YA:10 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE3NSBTYWx0ZWRfX4UKghyPZ5nnh
 cvu5ZTfL4cCfcgczis+4VQ0c8PbHhIqMgLjvqh7pXT/WIyOAexlqaRAEBQ9DWoB1BgzHGn8DJw1
 54x7HKYtXbhAjXCVU3BTmERMc15FscE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_05,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 adultscore=0 spamscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170175

On 7/14/2026 12:14 AM, Christophe JAILLET wrote:

subject tags should be wifi: ath6kl:

I can fix this when I take the patch if there are no other comments

> 'struct cfg80211_ops' is not modified in this driver.
> 
> Constifying this structure moves some data to a read-only section, so
> increases overall security, especially when the structure holds some
> function pointers.
> 
> On a x86_64, with allmodconfig, as an example:
> Before:
> ======
>    text	   data	    bss	    dec	    hex	filename
>  143726	  34579	    192	 178497	  2b941	drivers/net/wireless/ath/ath6kl/cfg80211.o
> 
> After:
> =====
>    text	   data	    bss	    dec	    hex	filename
>  144814	  33491	    192	 178497	  2b941	drivers/net/wireless/ath/ath6kl/cfg80211.o
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Compile tested only.
> ---
>  drivers/net/wireless/ath/ath6kl/cfg80211.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> index cc0f2c45fc3a..ecde91159b54 100644
> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> @@ -3437,7 +3437,7 @@ ath6kl_mgmt_stypes[NUM_NL80211_IFTYPES] = {
>  	},
>  };
>  
> -static struct cfg80211_ops ath6kl_cfg80211_ops = {
> +static const struct cfg80211_ops ath6kl_cfg80211_ops = {
>  	.add_virtual_intf = ath6kl_cfg80211_add_iface,
>  	.del_virtual_intf = ath6kl_cfg80211_del_iface,
>  	.change_virtual_intf = ath6kl_cfg80211_change_iface,

