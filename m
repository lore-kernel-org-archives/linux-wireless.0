Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214242;
	b=eeJspYKauZu61nKpPh8yJzdfB/zl8faYK2/tCcdCjYrI8jbVh4Xioae187zi0SYihoKx
	 nwIaQ4mlHR+/TlcYBY3PG/+euF6OiJDgvZ6XaEPMXWmln6sHfBNgSlfBix0GroQo3COp5
	 JlroBacG6YlE63SLeqg0EMR6JfT+APcv/smF3fqSRbPtqx2saFY8TbBZdEbU6HjNLoV0l
	 uArQnb0659tVbA+cKqJ/Is2EvCpgvQu4H7sBBcr8RoOp6J1musQbQj46RIEi0dA/qnnkt
	 BL3eXDxweZvgTJBNP/63ixxfhppUt3Nu/ktvK7uIT7zdItqevvs/iwAABSOPqnyukgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214242;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=O9/B5lF6u9GNtEi9e232diGEwQ+Oj3apNpXMoqj8NjY=;
	b=Qm2STb4LOdMHYlOovZKHCDr3MAhfSD0ppasflznGiMIxd6YZVqgM0gHIZnWTKQTaPyqY
	 IOW8fGwv+Fh1kWdGLqtl4xb5vGqfD5el1mC6MIwg4sKy2ZIfRKBkD9SF6nSrWWw/AiF8H
	 SZHBICqkvW0YgV4CjzbxaD1E/jbuU2/O9EbIlYAeeM3hbqrFvWItZ67tGhI8f3OW3lf/k
	 c8iQcHFsFn4hZK5ODgVCKurLr7tSrE7eeLurjBU8AMdi3a5+8Rk4X5xPcKpsQ7Cidxy/D
	 NZUwfJWCjpyAQuOhpwccGB2VjT7nAa6SQRIOfF96b9qGtOXnVR9mvh9eJUsSa5WXhjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QlGZSSwR;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E6060A263E
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 19:04:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65E6060A263E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QlGZSSwR
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a2d6d01ecbso9427395e9.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793214241; x=1793819041; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O9/B5lF6u9GNtEi9e232diGEwQ+Oj3apNpXMoqj8NjY=;
        b=QlGZSSwRN9Ir0wj1Yu6CVDKeAPqhbpY0J/iZ2PGJYz4DwcmoxDJ54Jp/74TitKPMKb
         kNy6ln+VKEk4wZaIKNF3x7MU8LpJ5G9aXWX6dLKIzRyx3XjDVFR9nESTO1ctd2We2vre
         z1pVvdqgFXk4k9K82PO/6wYHC9XpQIB2nkqOWDSpm/ZT8E0TTLmmLAS1iCLK0Bt/mGui
         jgz87eCjjHl3soAbI8Mje16UWh9Vw3tdosUbiJnSMuaFpx1clioe8Q6Dddwsn4/hZm17
         ZDJYBNbPqXzpGPVh4CjLolquj+lzHI2WpaYsgOf9XTg0OvvyZ8cxxgLHMxHP5V7o+NJ/
         277A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793214241; x=1793819041;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O9/B5lF6u9GNtEi9e232diGEwQ+Oj3apNpXMoqj8NjY=;
        b=c1g9CMkyo07BUXR7cny3l/8x7kj7ylzIKFQKqvBvT7E24gZFtbgD93aFaI1pYVSDyd
         3j1d1NuQIIv4AUi/Lp7dfKYr/JNUDVB/YXXHP0Qj971zOxwRGDXwA6X2pel/xlsO7sPt
         dDQDyQYfC8Fr3H3/aBPfVGj9lolmc2mcRkT7mbWkjyl/Z3rcxD18UNn29r99RxH68Hrg
         MWKj8WLVVucBaVcuQv1VeRoRJllQdzKK+a9MKslOkFPvJcBazHut6XD/NAMHPRWDKHZo
         Iopc0jEZBtb/WegfJLJb0bvqx+INAf6bJs5U3higAlIzUR0UDEwlbh6lqe6nxBi5t/gf
         V2tg==
X-Forwarded-Encrypted: i=1; AKwUvBzhYFfN41D3SAl+tTVEasXc4mNVm5AYiwioKaSGFjmidIkJG70r072CjFDX2xFAT4Cv0wr0B/4ymRNwLsY3ow==@vger.kernel.org
X-Gm-Message-State: AFq9FYJMbrpcWwnWz89IzWOrQ6Kyb0PftE+jQk3Bv0nDVXbUoHUZI7Wf
	P2rpzLrhxiUYCOmEhOXZBBK9s41xvS7+wwi5Dm7APuAydg2XCGS7txVj5K/6Pg==
X-Gm-Gg: AYBFou0K79/zyIi0firYq1AmTbLORnHuiP1p4wkUdpMSCKG93c79OjPOjQxMW1tsQEm
	dmNo6SQW8cTVxd7+6rERBDvl5nt7E85PHCaDQEA2y9UEGra1jLY+Kh8WDvRrr2kqcyzuZDb6MFP
	7VwfFrZLnxBN56qj25zTZ9pxx1YYHBN+jGaH0w34RGOnF8wcLMOP7USHBu2hfD//W3l5mz1gUDr
	4/e2jVTbJKeLhZd6bO8MRlQQ+tcjYidCgm2cVBUdIPY1LI+birl15W2reJbX2glSyJoQsmbdblw
	yATE3Kw0NeOD7G1k8Gw4Y9xNe9ZMn8P2UF2nnMtiXAztEXTPyEVmrgacH1tEONn/bp9SrylN20p
	Yn/hTW+WWb1D0BRx7WPyQk/5meh7RpTmHObk9+6mY58hN1cZ2Moi6DzcZGSqAzT67lznRpPdyAV
	KhW2p95+zTY27ViQuLk4AJsEFcVMfjV+r2L1NOTd0zwHYD4YbLmBWMVIJQ7rwil1H6F5lYov/U4
	rNNlxFqnA7XXg6pghv8iez5fkalPUzQomzbabJFCNJ4MqBr8qHjXpQSDT4LJyyWM76uBtbS6mUl
	8NMx7PmqYJwO+DJ99Q8YhthHZU15bFx3HBLlO976T5hC5mYTDpGvrXlhwsECXn9jAVGgpEYS6nS
	AD9bgWBNtVvwz5ucy6sJ+9Y28JqiWmszGMIW+92Op1i8hf1v2lZ3y0Lo=
X-Received: by 2002:a05:600c:8b38:b0:4a3:5a91:5f61 with SMTP id 5b1f17b1804b1-4a966c4062fmr75242105e9.14.1793214240486;
        Wed, 28 Oct 2026 12:04:00 -0700 (PDT)
Received: from shift.daheim (p200300d5ff07190050f496fffe46beef.dip0.t-ipconnect.de. [2003:d5:ff07:1900:50f4:96ff:fe46:beef])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a9ead8aa0fsm18317935e9.4.2026.10.28.12.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 12:03:59 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by shift.daheim with esmtp (Exim 4.100.1)
	(envelope-from <chunkeey@gmail.com>)
	id 1xM8wG-000000014l8-30th;
	Wed, 28 Oct 2026 20:03:58 +0100
Message-ID: <5cecf4d8-d16d-4004-aaba-6a2c7c77ea10@gmail.com>
Date: Wed, 28 Oct 2026 20:03:58 +0100
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
Subject: Re: [PATCH v2 wireless 3/3] wifi: p54: replace open-coded IE search
 with cfg80211_find_ie()
To: Tristan Madani <tristmd@gmail.com>,
 Johannes Berg <johannes@sipsolutions.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, Kees Cook <kees@kernel.org>,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 tristan@talencesecurity.com
References: <20261026223222.2093813-1-tristan@talencesecurity.com>
Content-Language: de-DE
From: Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20261026223222.2093813-1-tristan@talencesecurity.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/26/26 11:32 PM, Tristan Madani wrote:
> Replace the hand-rolled p54_find_ie() with cfg80211_find_ie() at both
> call sites.  The old function had a buggy short-frame guard
> (sizeof(mgmt) compares against pointer size, not struct size) and
> open-coded the IE iteration that cfg80211_find_ie() already provides
> correctly.
> 
> Add a pre-subtraction length guard at both call sites to prevent an
> unsigned underflow when computing the IE area length from a truncated
> beacon frame.
> 
> In p54_beacon_format_ie_tim() the returned pointer is cast to non-const
> u8 * because the caller modifies the buffer via memmove(); this matches
> existing in-tree precedent (ath10k, wlcore, cw1200, nxpwifi).

Acked-by: Christian Lamparter <chunkeey@gmail.com>

> 
> Fixes: e5ea92a7528d ("p54: AP & Ad-hoc testing")
> Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
> ---
>   drivers/net/wireless/intersil/p54/lmac.h |  3 ---
>   drivers/net/wireless/intersil/p54/main.c | 30 ++++++------------------
>   drivers/net/wireless/intersil/p54/txrx.c | 12 +++++++---
>   3 files changed, 16 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/net/wireless/intersil/p54/lmac.h b/drivers/net/wireless/intersil/p54/lmac.h
> index 8adde6ba35ab8..d9cbffb74a265 100644
> --- a/drivers/net/wireless/intersil/p54/lmac.h
> +++ b/drivers/net/wireless/intersil/p54/lmac.h
> @@ -553,7 +553,4 @@ int p54_download_eeprom(struct p54_common *priv, void *buf,
>   			u16 offset, u16 len);
>   struct p54_rssi_db_entry *p54_rssi_find(struct p54_common *p, const u16 freq);
>   
> -/* utility */
> -u8 *p54_find_ie(struct sk_buff *skb, u8 ie);
> -
>   #endif /* LMAC_H */
> diff --git a/drivers/net/wireless/intersil/p54/main.c b/drivers/net/wireless/intersil/p54/main.c
> index 57a62108cbc35..30f235d470bb4 100644
> --- a/drivers/net/wireless/intersil/p54/main.c
> +++ b/drivers/net/wireless/intersil/p54/main.c
> @@ -100,12 +78,18 @@ static int p54_beacon_format_ie_tim(struct sk_buff *skb)
>   	 * The dummy TIM MUST be at the end of the beacon frame,
>   	 * because it'll be overwritten!
>   	 */
> +	struct ieee80211_mgmt *mgmt = (void *)skb->data;
> +	size_t ie_start = offsetof(struct ieee80211_mgmt, u.beacon.variable);
>   	u8 *tim;
>   	u8 dtim_len;
>   	u8 dtim_period;
>   	u8 *next;
>   
> -	tim = p54_find_ie(skb, WLAN_EID_TIM);
> +	if (skb->len < ie_start)
> +		return 0;
> +
> +	tim = (u8 *)cfg80211_find_ie(WLAN_EID_TIM, mgmt->u.beacon.variable,
> +				    skb->len - ie_start);

casting (const u8*) to (u8 *). Oh well... If the checkers are fine with it.
Then sure.


>   	if (!tim)
>   		return 0;
>   
