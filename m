Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B5423D7F4
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 22:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785970255; cv=none; b=TLsgrW/EMd1B8htk+g2ElL0SDQ/yZwziGhF7UgEX7HE2xmQwD6jZVSL/+/0igCjNozZAIZhuwGyIJWZ2MuX2vfOajn5SmBywbIcfE85Ta5lHhcWpYpYoy2iZ3OyQpYPL5XooXo7fmk47Lp9SUUBaTsMA8fkZL9WZLX1l6cNKcVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785970255; c=relaxed/simple;
	bh=cpdGgNTACYUQFfRV/bm+mEkjQbed0fQAHzU8XxUC2lg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Px2mTQqKoVby3hjA6ZbP+ZUpyLt3GD1hPYTHwJi8u+HAQhuHfn6ZaYYSfSH1JVouaHmaQWRIhdkqpJtjyhCb30ISAa8BeTY4v+RL5jLyjqAlga0toxX8Jjlp8GZRIeAjbwwcNZyjZxIAxvnO+0+2vEsHefTcPW2A1t+h81P1+Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cZ2pA2Rz; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JQ5QWZ3Y; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cZ2pA2Rz";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JQ5QWZ3Y"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675HRtb03275494
	for <linux-wireless@vger.kernel.org>; Wed, 5 Aug 2026 22:50:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TZFR6ZOFPA8NS1GuJH0Uda7EpAQ9ewQLN5fYauItt+8=; b=cZ2pA2RzB7mO7eCh
	iKIgGyUnkx1qVO/qmKu4JSYSwmznX3Q6qXd4/h03e9nNlw0+xf4cEyyAZEKp+R8B
	lDipyq8MXkqobCoxlLIHjj40JGFvRPE8vrYr10+axIwajg7nYz2SdrDYh6k2MRFQ
	SVDzDhkG5sPJRDgXHWNimMZy0mWsr1PTtdJiDpf9wttITYcR3DsMseOkCe2t5nG9
	qgZpIDGW7JoVYetgWNylcO3Dg6tpjz48DV0tGjt06vLz/K8gnd16awj8jAoFQv/E
	MUcyNeqyVs4heAlafi43uiWOw85OdQSoPqDwFV137sLZGb6sCrobhG5lo5PtVZqt
	rPplbw==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fv5x5jg0e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 22:50:53 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cbb92868263so1663021a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 15:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785970253; x=1786575053; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TZFR6ZOFPA8NS1GuJH0Uda7EpAQ9ewQLN5fYauItt+8=;
        b=JQ5QWZ3YRwN/6vOZ93ao5LK0vjrG7XT8y2MVFOrQR84MPiLJ3LrEERDrm4kf3+v5L6
         VoRDsq7S93KP9B8nveYBe+RSvU0X/ZtR+mlAsFI/Vq6Puqdnpe6zczNi9SLTPFZ+SZlO
         aHo/hyIXBstqRVcbExJEFz8enkj5Ftl/t51XiKsx1dSjPdHm5sN5E+HGhNxA/YFu27po
         7nd7o1s60MGzOnCIb4rLz0WPs6GNU2Y2od7rZ24l7Fgkov2BSeJth4quFH5x/oL3rX9q
         db+bpmhBjsMcroyg2Ny7xkguWFtv9h0EHQjcRYwlJwDq9lKcFIv4bJaZMawAisnqRPO8
         jVjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785970253; x=1786575053;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TZFR6ZOFPA8NS1GuJH0Uda7EpAQ9ewQLN5fYauItt+8=;
        b=tS77heO92Zg/dtJuIlv6C/KXTOGTHyp5xMwzoQAHKcGNbK1ERWSbBwSejWFfZipZ3i
         Qm9MeIfNYvoN+1gyk4LPzReV/OjMtz112OOi+4sRw7juoWuKMH0+x4iddqxfW7IJiW8X
         bYO1yPstWzAszf7oE4kGiegmpM3513e9zzmk0W6ivMXlxfyouZ+35icDeFVKpv3SkWSP
         0We2B9I8Cit+wv9DlPoBwfnTbGjCGk5C9mStI7gGBmlhZZ/A1Smor6E1x8vEgdDXlZik
         sOtRBA+FkJrA+1PPxYMSjDMWFhP1Yh3OW/k8a1tvxyjaIlk9bWochpVF1ZxOb8TDl9Gm
         b8qg==
X-Forwarded-Encrypted: i=1; AHgh+RpbdZS1C8uTKu3hkha5+lbm+SvN0iUBcjpX4fd1eAfO1D0RPzgGwSXIi+uFXTneHcpAC7pScB6o7mqdcVTJBQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxqw9qbSMTHL/FN5Qp+JbkwuxkVBPj74pTI8dzf1JS18FYXhR8S
	13XhwhqDl0attsP379mZhsbO0fVGUtpH4qMIbBAr9DJwybEKwA8izgurE+akDmDRWt0VV0yYyVu
	2I7ujuKEboWopPvWgxt3J3guzQjtEbJR8aTUhHHbg8gAGyMUQz3uxa9oXsz8KNQTz+in77Q==
X-Gm-Gg: AR+sD13+HV/PXT6bllYtY/2i3BWQe2D2o9xfTj1O0EZ64gh+U9mg63ZtOmz+AfHVsBw
	L6u+hsXnEmqpb+NB4y3i79c5xg/R8bkTdQcL/mWWneVSqVLByV7uFkxOXG+w2ugrOhEawIuY6Rn
	b52gntL+pc1lBh3ZMopUZ3fF3KdOlxDXD0ZECXDWcrXZJ1cdxqN27feS4ahf59roY6d4CUWZ0y3
	u9Y1z0qEGkUkhWm8iO1UXj7JLemT+uKISErfz7QYZz+l3NNw1oRloKmvzKuMvxLk1pV2/u21a2W
	BFGao0vyLFPCywOdaF5fY6u8+nP/RsZKElXXNK1DA3lkRDvrarZFWxjKpTZOS66uHnyWy36SWRb
	7eSep9o2LAg+BiE1PHuaaMdWI8hjS6aD6JWPftWBba9DbokFXHWfhMqxx/OU0
X-Received: by 2002:a05:6300:4045:b0:3bf:83f3:b810 with SMTP id adf61e73a8af0-3cb85ef7f63mr12697003637.29.1785970252884;
        Wed, 05 Aug 2026 15:50:52 -0700 (PDT)
X-Received: by 2002:a05:6300:4045:b0:3bf:83f3:b810 with SMTP id adf61e73a8af0-3cb85ef7f63mr12696951637.29.1785970252446;
        Wed, 05 Aug 2026 15:50:52 -0700 (PDT)
Received: from [192.168.1.20] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315867c6a29sm20071000eec.29.2026.08.05.15.50.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 15:50:51 -0700 (PDT)
Message-ID: <f2c8c83f-e2e4-4ed1-871f-f1bb1d71c057@oss.qualcomm.com>
Date: Wed, 5 Aug 2026 15:50:50 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] wifi: cfg80211: report authorized connect and roam
 events
To: Jason Huang <Jason.Huang2@infineon.com>, linux-wireless@vger.kernel.org
Cc: wlan-kernel-dev-list@infineon.com,
        Chung-Hsien Hsu <Chung-Hsien.Hsu@infineon.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
References: <20260804030450.232028-1-Jason.Huang2@infineon.com>
 <20260805110116.35884-1-Jason.Huang2@infineon.com>
 <20260805110116.35884-2-Jason.Huang2@infineon.com>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260805110116.35884-2-Jason.Huang2@infineon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDE4NiBTYWx0ZWRfX1X+39bNEE7Tj
 tTK5b9XcXnSbWkb1uMTA5RwQSunn4M8ztBl0iel7NdXeQu6FfUv+CgR4G8yvKJuJQKBRi4nqsss
 fAV+qi5zCeHRHvXgYWWwxz8Kt8tKiEqHHensqO+4yNkVlpZJBjdDjBP9jirM9tPxPEjxATYEPov
 DyOq+D/6C9gOP+XAVFD0S27h8H4edwYSUpkCFShDtRu+XR3uqdAVU/4M35DrZs4gvIMnSk77Pa2
 pLe68tRKurjIGdGvXbiDWUElF/LPNjg0W/STO6HM2L155LaXod9EZyGhdcrgG3sRB9GnD8S31SI
 39tjcueclGad6cCe4huJb0070crgHEDZGJPZ563liAly3cuiADA0Lp8KenQ93tYoWcOQNuZb4VZ
 o7Jy+Z+eAlY/hYoxEjiguqLFMoHekbRYw0nLgYMyU2FdwW+ZDBXMBDple4IELebybkOzFh+CCV3
 f8qQRHt4E4x6C/jVZCw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDE4NiBTYWx0ZWRfX9GXgXRrpgVbk
 9pP5g9gYyuIWw2LXGT2oCLeSuC4GEKC40IrOVps89bzwmGxot3OuBJbeWs7HCspKg7fkQ3YxTbt
 tIZ7pRTrRMg78jhifBthgf68HWSLxDI=
X-Proofpoint-GUID: WZcjYRz17sDGTxDq6gja4O9VdAy5L4Ou
X-Authority-Analysis: v=2.4 cv=cIbQdFeN c=1 sm=1 tr=0 ts=6a73be4d cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=bUQKSiCPAAAA:8 a=PW-KNzBFAAAA:8 a=dlxwaV8mhwWKbarLZ4QA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22 a=-fHZXUhsFbuwFN3fwQAr:22 a=84zbTXrhsdUYOv-GFPQN:22
X-Proofpoint-ORIG-GUID: WZcjYRz17sDGTxDq6gja4O9VdAy5L4Ou
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_05,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 impostorscore=0 bulkscore=0 clxscore=1015 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050186

On 8/5/2026 4:01 AM, Jason Huang wrote:
> From: Jason Huang <jason.huang2@infineon.com>
> 
> Drivers that offload the 802.1X/FT key exchange can know that
> the link is ready for data traffic when reporting a successful
> connect or roam event. Carry that state through cfg80211 and
> include NL80211_ATTR_PORT_AUTHORIZED in the corresponding nl80211
> notification when the driver provides it.
> 
> This lets userspace avoid restarting authentication state machines
> after firmware has already completed the security exchange during
> offloaded roaming.
> 
> Assisted-by: GitHub Copilot CLI:gpt-5.5
> Signed-off-by: Chung-Hsien Hsu <Chung-Hsien.Hsu@infineon.com>
> Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>

Jason,
why are the above signing off the patch if you are the author?

> Signed-off-by: Jason Huang <jason.huang2@infineon.com>
> ---
>  include/net/cfg80211.h       | 6 ++++++
>  include/uapi/linux/nl80211.h | 4 +++-
>  net/wireless/nl80211.c       | 6 +++++-
>  net/wireless/sme.c           | 2 ++
>  4 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 97c16d4ff127..7f576bb7325c 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -9103,6 +9103,8 @@ struct cfg80211_fils_resp_params {
>   * @assoc_encrypted: The driver should set this flag to indicate that the
>   *	(Re)Association Request/Response frames are transmitted encrypted over
>   *	the air.
> + * @authorized: Indicates whether the connection is ready to transport data
> + *	packets.
>   */
>  struct cfg80211_connect_resp_params {
>  	int status;
> @@ -9113,6 +9115,7 @@ struct cfg80211_connect_resp_params {
>  	struct cfg80211_fils_resp_params fils;
>  	enum nl80211_timeout_reason timeout_reason;
>  	bool assoc_encrypted;
> +	bool authorized;
>  
>  	const u8 *ap_mld_addr;
>  	u16 valid_links;
> @@ -9281,6 +9284,8 @@ cfg80211_connect_timeout(struct net_device *dev, const u8 *bssid,
>   * @links.bss: For MLO roaming, entry of new bss to which STA link got
>   *	roamed. For non-MLO roaming, links[0].bss points to entry of bss to
>   *	which STA got roamed (may be %NULL if %links.bssid is set)
> + * @authorized: Indicates whether the new connection is ready to transport data
> + *	packets.
>   */
>  struct cfg80211_roam_info {
>  	const u8 *req_ie;
> @@ -9297,6 +9302,7 @@ struct cfg80211_roam_info {
>  		struct ieee80211_channel *channel;
>  		struct cfg80211_bss *bss;
>  	} links[IEEE80211_MLD_MAX_NUM_LINKS];
> +	bool authorized;
>  };
>  
>  /**
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 020387d76412..66b4cfd8de86 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -2705,7 +2705,9 @@ enum nl80211_commands {
>   *	in %NL80211_CMD_CONNECT to indicate that for 802.1X authentication it
>   *	wants to use the supported offload of the 4-way handshake.
>   * @NL80211_ATTR_PMKR0_NAME: PMK-R0 Name for offloaded FT.
> - * @NL80211_ATTR_PORT_AUTHORIZED: (reserved)
> + * @NL80211_ATTR_PORT_AUTHORIZED: flag attribute used in %NL80211_CMD_CONNECT
> + *	or %NL80211_CMD_ROAM notifications to indicate that 802.1X
> + *	authentication was done by the driver or is not needed.

This attribute became deprecated when NL80211_CMD_PORT_AUTHORIZED was
introduced. Why are you not using that?

503c1fb98ba3 ("cfg80211/nl80211: add a port authorized event")

