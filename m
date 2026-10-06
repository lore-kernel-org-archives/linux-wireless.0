Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71156296BB8
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 02:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791252345; cv=none; b=CyIS7rT7Tc9JmYYn2dQyffcgIJBfo6TVI7rQjpHx/yehhfHRKwuxGo0+NJiHJhFCfYB9Or5EcSVVsLfIC9quQnqw+ofha4YsAmP00Pen9fh6VHW9hgM5g32SHKr5BTVkkofSp94pVIuVmiunonT/m0gHBqxBVEVeMd6B+lqAnAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791252345; c=relaxed/simple;
	bh=0gWMWvwo+eVO5bmetxk71XNiv5hnc78YH3YDEcsdSN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=Bl3V2hl5O7Qs/iofmJXdLJ+hhGBCpL58ZgtcKKmzhfe7ivxiTIg4ZMd8Fxa+3MZ/z3tv/BA4nZFqUXOYAv5V2sG/sV/uTMICi/KQJveqWGGEETub5RfvDXAqamG3yD/6iMXDnl1sM5IgzgsfZmGMOvlY1hGZOBgyLUdvtc7pOK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=J1IqsO3g; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PahwuBIJ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="J1IqsO3g";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PahwuBIJ"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 695KMilC2359539
	for <linux-wireless@vger.kernel.org>; Tue, 6 Oct 2026 02:05:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WNxjXpkyaL0SakgY6wB+Mhgiw6lt5SjM6SRsBvtmBUE=; b=J1IqsO3g2C6N0AMv
	iKgK7ACfmSQEdpDdDbnENbzGWHhc0nLBrrt9KdOvSAbje7QFpoD9s2kC5OhuxTFz
	NukD0yvHazO3gZDzFcsPpUxSyt/ffxf0TyHzhVdlXQITSa5dRcoOM3LucWzzXCgJ
	Ta4Q//sQsasArmQpXKlqCHXDkcrCfmM/pOFbVbo62E+1XgUDMWYm0pxXTnSih4xE
	QLZZiAXz3RqKupDQfQ+xd+pVlLd1yhM6AI5cqSjQLDOC+Ix2pSRuRwjcjVhMk5zE
	7UY2psnlKY69c4EQNZxz29tOfRCp2RmjAYI6ExVP5auIswipcntNeXrTxmwxkhe2
	dTPJGA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h4j1ns5qx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 02:05:43 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-30f1b904861so2864038eec.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 19:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791252343; x=1791857143; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:cc
         :content-language:from:references:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WNxjXpkyaL0SakgY6wB+Mhgiw6lt5SjM6SRsBvtmBUE=;
        b=PahwuBIJcrcmRegb0RUTKXftXm8UBWwJx088rqxJXmVIQLUcf0R0Xobm1tIJ3+k77/
         u7c8vb6AknE6rfqCsqvqRFBZOoe/lcPdc0KhNcmLVbpfi2upgZEyGwZ3C8ILliNCOrEb
         tnQbvlzd6r3bkCEBwZuPMRguVnLYhqdT/WzDVCjwcx1jZwggUxypAAZx6xH2c40saEQl
         z1CElrME+NpUszQ/rTpVRLcbTdu2/8EruZQDoVgiOyAIyW2v94LAS/5GduzXRlynpV/F
         B+1Fj/Orm1V9maYBUeZ3DtH7UAoIGbHkS2aJ/VxYouZY3UUYz/7aUPLFQb1IdbsqPwYD
         132Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791252343; x=1791857143;
        h=content-transfer-encoding:content-type:in-reply-to:cc
         :content-language:from:references:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WNxjXpkyaL0SakgY6wB+Mhgiw6lt5SjM6SRsBvtmBUE=;
        b=TS25Q6TJUJZPwW5/JIntx4riL6OSjh2XaPBioDGyEEuARGCRHpIsY/kJQZT9PexkRe
         SxkbtTU+CdE6TvXORrZ3WbjcrKDoCMQPCkcRaD0XZlUTyQZXF2Zu4HK9NxRxLd+cP8k4
         Z83nvKUNrFvRwBGeiBbHDAz/2y4n+TMKPJ6zB3wEztiGwjQh/dTWBCNzsfCBoDHtWipr
         Tw9SkcYEFt8klzGr43Eeq9WNH6LDRf8W6OKXj1O6nPlUVOBw6UjrHNdHs7+sn4Ss1fqD
         dqNUqcLOGyijm8Mpl+BH6X4tbPKjlut9K8+wstMsF3MD83GLhtZeq9OANVhYf50e5xo7
         Tpdw==
X-Forwarded-Encrypted: i=1; AKwUvBxGJefAAMxg/d9jXvh7PpfSFmgva9uu/K476nbp++zCZ9WP06CuRacXMMGBhPqg22KQ04nNsRZ7OobZ92V2sA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIid4gVAsaxg+EWJZmlhj4W1P5Dt1klnbQLhcK4rbZ7vJ7UA/bC
	XvScgVwfNB7FJmynyvtqNmt3Snl4FKjgADYv5XlmZQTgnxojvBblxvQvmDb274jNkOziqMB5NlX
	2YGTLV9niBJjGHkDa+rusVdseNMyH6LNitqHNFTfihl9rXk0HvA5oxRG1VYEfPtAYn6aPXA==
X-Gm-Gg: AYBFou35CIUYE4AWkoRuwREDuukWeyDNMxWmL0rHkqLL8307+w8Ilx5ZUi6/D2dBupi
	m04hZ2L7hGFH8NHuaWGKEOh4384Rb14JfA8zYmUItLJlifNsQxfeUStEIukk8jwOwPQBNz7AdCD
	ZfD1HfqE/jWFloiMr5TP4BMoXnJlYUUE1jPfW0PnltCpOlNbPzlvxw66qyHSQvc4S30u9wbBG6+
	SZ/CPvOEp9P7RfMABx1aIp0qGh9G/64UomCxeYGbSUeiTu+GBNMk0lUajrdUJWj9LEsSIbvTKDh
	veVWu9pVWh1Vcj7L6woz1fNGsmuXJIGxgkZHV9K48dMfDwEL7upYXLRJOtkpP4QEBE6RGoHmaFE
	YfkyQ0mUrdZY3LowaNQwTzTHDGp1Z2st0Tg/nXDdwVlaTlwxV1iGqG8DCig==
X-Received: by 2002:a05:693c:638f:10b0:34b:dde6:29c7 with SMTP id 5a478bee46e88-351114568a1mr11781802eec.19.1791252342343;
        Mon, 05 Oct 2026 19:05:42 -0700 (PDT)
X-Received: by 2002:a05:693c:638f:10b0:34b:dde6:29c7 with SMTP id 5a478bee46e88-351114568a1mr11781765eec.19.1791252341505;
        Mon, 05 Oct 2026 19:05:41 -0700 (PDT)
Received: from [192.168.1.20] (33.sub-75-218-193.myvzw.com. [75.218.193.33])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35146a299cdsm2360672eec.12.2026.10.05.19.05.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 19:05:40 -0700 (PDT)
Message-ID: <3db68884-f6b5-499c-9959-7eec59ba40cd@oss.qualcomm.com>
Date: Mon, 5 Oct 2026 19:05:39 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/12] wifi: AP side locking improvements
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org
References: <20261004214504.1636783-14-johannes@sipsolutions.net>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
Cc: "ath12k@lists.infradead.org" <ath12k@lists.infradead.org>
In-Reply-To: <20261004214504.1636783-14-johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA2MDAwOCBTYWx0ZWRfX5A2GM9tEBmqv
 ff8mKPrJOCbw0wlBifIdqz4rOkbVIwv82iXp5VtQIiO9trsQlBqi6DZVPSxG8NM7HT3KzjyTgYQ
 gErx0XhdaSwq6fKgAYpH1S+Dp92YQCU=
X-Proofpoint-ORIG-GUID: YPCKQ2RmKY9M1ZZ-OtmMFgnIGOc5UR9Y
X-Proofpoint-GUID: YPCKQ2RmKY9M1ZZ-OtmMFgnIGOc5UR9Y
X-Authority-Analysis: v=2.4 cv=F4fC5ahN c=1 sm=1 tr=0 ts=6ac45777 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=AnolQpdaNwb4XK4FG+QP+g==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=bb0DoZlYktw9nqMOHAQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA2MDAwOCBTYWx0ZWRfX46hEJIX3lOEI
 vSQSR5mpua/4eWPZs/BFo+QqrPcjdDPskh0Woo27xaQ2Yyu0kHvMSn+x42oIC1oJ+Rk/N2FxwNR
 S9dCRBH3Z5ftCGJFx47aVGDr7hkZSjlftPp+onxUPbNL8ak6fGzmcF8MZPnBoxgm2bgJbWbr+HF
 MpOWZZpEdeoiBKeuPlYLoRvzCV7vX6lnQYicnVp75flIKT11V+vnGvt8XKCjFmZ+AUGC/BO6EQv
 5bsbd/S/etppIwnh0tI8G8+4/5qdYL+cxZXKFs81WFZYz9+Ka8/nljkL5QrmojAez9ryh3Gzz71
 ZnuPX7E+Gs4letEmkJmDQjtho3dMfnJoWNg3ODUCJVB/SyYHYA18SKLEc6Fj3LPyfRk2fxEJ+88
 3PdW82MPTLZxaY/0Etc4SAIT08JQUSLStggSL97ewt9BPQDfsPy4jJHlzB62BD/9EOHLczf/xS6
 gZYrkmjZ6vdHNN0PhOg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_05,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 phishscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610060008

On 10/4/2026 2:40 PM, Johannes Berg wrote:
> This obviously goes on top of my (fixed) RTNL redux series.
> 
> The idea here is that wiphy mutex can be held for quite a bit
> of time (e.g. waiting for firmware), but beacon updates (e.g.
> with the critical update design I had proposed a long while
> back) and other things should be fast.
> 
> So with this not all things require wiphy mutex. These are:
> 
>  - beacon and related template updates
>    (this one needs driver opt-in),
>  - mgmt frame TX,
>  - control port TX, and
>  - peer probe.
> 
> This does make the implementation slightly more complex, but
> the added complexity is almost entirely in mac80211 (and some
> in cfg80211), unless a driver wants to opt in to unlocked
> beacon/template updates, which it has to implement itself for
> obvious reasons.
> 
> I think we probably want this even without the critical update
> design we're still debating, but I thought I'd throw this out
> here because a lot of the discussion has been focused on the
> latencies throughout the stack, and I never thought they were
> fundamental. QED ;-)
> 
> johannes

With both the redux and this series applied, I prompted my review agent:
prior to the 2 patchsets (18 patches and 12 patches) ath12k relied upon the
wiphy mutex to serialize many of the mac80211 operations. are any ath12k
object references now subject to new race conditions with this entire set of
30 patches applied?

The reply:
<LLM>
New Race: ath12k_reg_notifier vs ath12k_mac_op_start/ath12k_mac_op_stop on
ah->state

Before the series: ath12k_reg_notifier was called from
notify_self_managed_wiphys(), which ran inside reg_todo() under RTNL.
ath12k_mac_op_start() and ath12k_mac_op_stop() both assert
lockdep_assert_wiphy() at entry — and mac80211 calls them holding the wiphy
lock. The wiphy lock was acquired under RTNL (rtnl_lock() → wiphy_lock()), so
RTNL serialized the notifier against start/stop.

After the series (patch 18, 7fccd0f981b5): reg_todo() now holds cfg80211_mutex
instead of RTNL. notify_self_managed_wiphys() calls ath12k_reg_notifier()
holding only cfg80211_mutex — no wiphy lock, no RTNL.
ath12k_mac_op_start()/ath12k_mac_op_stop() hold only the wiphy lock — no
cfg80211_mutex. These two locks are disjoint.

Inside ath12k_reg_notifier(), the first thing it does is read ah->state
without holding ah->hw_mutex:

if (ah->state != ATH12K_HW_STATE_ON)   /* plain read, no hw_mutex */
    return;

ah->state is written exclusively under ah->hw_mutex (in ath12k_mac_op_start(),
ath12k_mac_op_stop(), and ath12k_mac_op_reconfig_complete()), none of which
hold cfg80211_mutex. The reg notifier (on CPU A, holding cfg80211_mutex) and
mac_op_stop (on CPU B, holding wiphy lock + hw_mutex) can now execute
concurrently. The ah->state read in the notifier and the ah->state =
ATH12K_HW_STATE_OFF write in stop share no common lock. This is a new data
race.

The same applies to the ah->regd_updated = false write further down in the
notifier and the ah->regd_updated = true write in ath12k_regd_update() (called
from a workqueue with no lock), and the ah->regd_updated read in
ath12k_regd_update() — none of these are serialized.

Before the series, RTNL acting as a global serializer masked all of this.

Pre-existing but Newly Exposed: ath12k_regd_update vs ath12k_reg_notifier on
ah->regd_updated

ath12k_regd_update() is called from ath12k_regd_update_work (a workqueue) and
reads then writes ah->regd_updated with no lock at all. ath12k_reg_notifier()
writes ah->regd_updated = false also with no lock. These two were already
concurrent before the series — workqueue items are not serialized by RTNL — so
this is not a new problem introduced by the patches. However, RTNL previously
prevented the reg notifier from being called while a mac op was running,
which reduced the window. That window is now wider.
</LLM>

So we'll probably need to address those issue.

/jeff
