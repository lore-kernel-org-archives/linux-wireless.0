Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37E23DAAAC
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 06:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785135201; cv=none; b=jJ0hMchAAnPKnlwnTQ15h0jbv5EWg7ybv1HfpAQpnEhffbwjAm70rS19YqkIIQAT1YOasvVSCs2+pD34VYZVPFh3eIWmiMA2bUthdCPh3h/f7ZoPXoeKpRsp3BjFzMxN6pOwJnIOeC8vUuKJgiVbmLAi/ZNo+fVSqFEhzJtl+y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785135201; c=relaxed/simple;
	bh=+ThL3QcABOKoHbzhTYiCy5ToA3uvSlWePULvNPpSzbc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TgcewL6Ggm8I1utiFZuESpdzkluUwmU4axYdDJ3dDamumcdJ159m4+hhRhZh4rwfvaL2VNgoMi53MHSjquDOjkp+H/M7noGyzGfTr/KeG6mhxgtVX4uZ9UPBuFvXCoBsLP17sSdq2jXS3BUUhCrUcfMvIW9b1ZUUkA2EUgE1Ei8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SZvWEoY0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iFnDA25D; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SZvWEoY0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iFnDA25D"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66R1gVT02418264
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 06:53:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	txpZj/feUGsoKs+2MRrEmHuUespLu+N25N++HK9Ylgo=; b=SZvWEoY0+S6Xt166
	B/bhmlZ8xj7yEGsZcbaL7nf7OyVYMIpFxRVfbkpwg7576ns9Ha8HHCSYPTD1pj+Y
	gkJOlfDsO5Vq+bG1ilKe1mE7W8mrtvSJoVd7slCf/m4E4SlQlWGGLd4Cyx3HQlus
	bPgyTnik+8QR5tk0v91LpwLkstCrJz/vMTsImyG+h6/yW030kUsqHdK8q34D/Qky
	S3hE1X157Jd7eMb8oz0YPPjpOEZ5H0ayXWBT6jKaUPYrUCrLcGFhzeMoFqdtBY3b
	bYEoNRhd3MPJQEhi5WrpyAQ4DHLYcpSrbGgL1h3xRvmHGA+XRhxEsSLE0BYBFvdb
	WzpkpQ==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fmmqycwcg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 06:53:18 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8487eb67173so4131198b3a.2
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 23:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785135198; x=1785739998; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=txpZj/feUGsoKs+2MRrEmHuUespLu+N25N++HK9Ylgo=;
        b=iFnDA25DRjZpHCqUW2h77EcoH0eaqkyC4ZtI2kNV5uWRBaxMLmmD2DNQIQ8ZkHx3F4
         6115Kosr8Eq4Y2n4sP7wMLmC0m032MEwK1wtKTO1U5deTuFoGm8PtKcKEyxnmBDxVEMk
         CohR69GN04NhzyCGLC6YLoNXOwbMpDkP4MJaVk/OTuOJWEwBJ3Alss+XGPCF6Ue2iOdw
         kG4occDoJmRIW46lWuiYe7qs8jWrXaJMWBgznTqCKSo6Dx1owgz3fRDakZ7+Oznrclrf
         PVdKlohHww4hTTCj8EOVhh3iXlBaEGey9FZWOETC4yOdz5iRVOFIIcU/bkvU5PkSLge2
         K4yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785135198; x=1785739998;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=txpZj/feUGsoKs+2MRrEmHuUespLu+N25N++HK9Ylgo=;
        b=Eq3SnHrdX4h4Q+9u/MhSD/iMBNlvFzn3lXhPDY7bLf901yvKH3rMIHZySQkfQaSyrV
         8qLPma2rUE2N1esqjeWfu/YHkDh2q4/1ht8br6wkZ5RVZ+HSG1qpzgHgex11LMnW0Wuu
         VxOnGlo1c3ghc0hCUo+lXn7nDXHrBHalZpE4KISVY/71Lp+ULs4wdW2IworO5iexPGnF
         hzJ9NRIKOgO2RzFhYKk288QFGqp/ECEVgprKMERE+8ZXNPNIF85HMUhde1m5QaQGnYDp
         +yxK8M75FN+kMcc3685+9uXnodiCKiilr4SLqUNhlnnGYL7uNG5UfI7gl68JNVwTaTZE
         PKLg==
X-Gm-Message-State: AOJu0Yx+bpY+01N8kcQDWr/aVqLwqSW6KYpo6K6gclqkekiqeUsTpF5+
	8IAUP0i0zpZBdgQWl74Cq6tSzJ19aF36w3bBVhlHU4K61CepjSnSnti3J5UgYe+uFcMnLOee4xg
	XezcUuqjlp8RFdwCzt462I53M6IXwjBkfoOtMZ4n9FjQzooABGBh7LF8UaCW1LKyIOMnsFeQgJN
	CNNA==
X-Gm-Gg: AR+sD111sY120M7sK/fZN8/NlyytqZ40+EZZXmPNqJCAYofIk2ZofWq46Dv7ET1a/5Y
	HvtNxIlSew6tWT5DuxJGpBF4HDdVAi4tbcz/dUS0oiT2+cevfj9csYCwWw3kFkDsDikDGSSjJkQ
	ymWS8GdGqyGHaYiZDQQI3bxg4suzKgSQiDxhjteGijVEPtUodb9MLDK0Rq8DLVh6WmIjTIS4aV/
	1xPzmuXpB37ZHkIgUhCfGdP9B3c6WqrD7lfCSa4d4abOuwgBSw4HYE4RTVz4/viY313QssiVOl2
	1Xg0lQ1gE3YmGXqsFj8p4xLVPPBaQvHYpmrbpWJ+dUDbZdYqcDOzoTKNYOT5MaInaQY8VHjeVkj
	8m8n+9GOKWFVZaDIYAZZEgC1gpBlNfjuBrrmcFBGgBTC0YgpWdauXafyi8D7bWtIUU33tuxGTky
	LmBB2f7y7oz9odJ02WsQ==
X-Received: by 2002:a05:6a00:3027:b0:848:7443:f2de with SMTP id d2e1a72fcca58-84e5942e5aamr5631859b3a.13.1785135197766;
        Sun, 26 Jul 2026 23:53:17 -0700 (PDT)
X-Received: by 2002:a05:6a00:3027:b0:848:7443:f2de with SMTP id d2e1a72fcca58-84e5942e5aamr5631835b3a.13.1785135197190;
        Sun, 26 Jul 2026 23:53:17 -0700 (PDT)
Received: from [10.131.77.91] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e53254f1asm2601203b3a.6.2026.07.26.23.53.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 23:53:16 -0700 (PDT)
Message-ID: <0f83652a-882d-4597-b543-0f1848f314a4@oss.qualcomm.com>
Date: Mon, 27 Jul 2026 12:23:14 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v2 0/2] wifi: cfg80211/mac80211: optimize
 station info handling
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <20260430053810.2088793-1-sarika.sharma@oss.qualcomm.com>
 <f127429e45d55ff29822856c892556966589e217.camel@sipsolutions.net>
Content-Language: en-US
From: Sarika Sharma <sarika.sharma@oss.qualcomm.com>
In-Reply-To: <f127429e45d55ff29822856c892556966589e217.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: an1L0jclRAWx3QTK4cakYNXp3NG2HAb4
X-Authority-Analysis: v=2.4 cv=drbrzVg4 c=1 sm=1 tr=0 ts=6a67005e cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=C37q4EWDJmjAnIOa_IwA:9 a=QEXdDO2ut3YA:10 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: an1L0jclRAWx3QTK4cakYNXp3NG2HAb4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDA2NiBTYWx0ZWRfX5/U23CyNn8q/
 p0UZf0V7E9n0V9MieCQ7kWXF5gxJdUAig9lGUMVL8wM4MNBx4jf/wOx4U04c/YfARpmlJbJl1Vg
 SkO4Ka9lJqfEj2KL4slTTndhxKL4bPmNSkWPMSDaJl/RNzso9uZXt3pR7duQH2kyGf6ujeXUz7s
 N1Jl3EDhubY4BTIAVIvKzvvk+YIX7vkyfcor5Lid7KrmT1qs9t3bfl0FmrWqX/MKGZyritWW3q1
 26qVE3Vcc6fe/Z6GVmNd0tBGD/Of+vbJ4R7lwFMsc7C4fK5jzopdJt7ni9y4nA/Xsnuu+QoXmre
 aMitrCW8qOjUc5xzQ9QciNfZLfRuciRirvJYxvZX8/dK2WD7MhFYYbJaKu+fmc5q1MBCrWNeCzo
 xBwn9pgAZqAP1ager6VYyusrgi0s49nq7duAp6BHVc8d1P4XZc5mN8ZvCCukKyrdOm0xGi8dKw2
 B9bFOyB4oN5lZIOuh4w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDA2NiBTYWx0ZWRfX8xcnbNOarUc/
 w8MXuv740oW2tpMOkM1xFWh2yXohQiYZB4DQm557i5mQXq3mW/a4r48PnGFJqgCWcf+hMfgkmTC
 u2+0Z8Bl1jzoC1hwPnbYmEEtDNpiA00=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_01,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607270066



On 05-05-2026 15:51, Johannes Berg wrote:
> On Thu, 2026-04-30 at 11:08 +0530, Sarika Sharma wrote:
>> This series improve memory and logic efficiency in cfg80211 and
>> mac80211 during NL80211_CMD_GET_STATION. Allocate link_sinfo and
>> link tidstats objects only for valid links to reduce memory usage.
>> Avoid setting non-MLO applicable fields for MLO stations to
>> eliminate redundant operations and simplify the code path.
> 
> OK ... so taking a closer look now.
> 
> There's altogether too much going on in these patches - the first one is
> really cfg80211 only and should be tagged as such (API updates across
> consumers don't count), and I'm not sure the cfg80211_free_link_sinfo()
> refactoring is useful - but if so maybe it should be NULL checked
> inside?
> 
> The second patch *should* be mac80211 only, but magically removes also
> the cfg80211 code ... I guess I can see that's no longer needed, but it
> might better be a separate commit that explains that.
> 
> And finally, given that all of this is entirely dead code since my
> commit c3f8d13357de ("wifi: nl80211: completely disable per-link stats
> for now"), I'm not really all that interested in optimising it.
> 
> If you care so much about memory consumption then we can just delete the
> code. If you actually care about exposing the information to userspace
> (e.g. for the, entirely broken, MLO_SIGNAL_POLL in wpa_s) then you
> should really fix those issues, and maybe then figure out any memory
> issues.
> 
> johannes

Thanks for the review.

Fair point. I hadn't respun this series while the fragmentation support 
changes were still under review, as they affect the per-link station 
statistics path that this work targets.

With the fragmentation series now merged, the per-link station stats 
path is active again, making these optimizations relevant.

I'll address the comments and send a reworked version.

-- 
Sarika Sharma

