Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792614772;
	b=ctbOfMTEYAJBbzYH2eA/EBqJKVRy1QJjJZDMI5LNTHSNZ4U8bzYRxIPtGuZGRJedx/sC
	 ryFDKYd1TSoI4+SVpznL/hU+jyQq3NHEexWg3uM703iGh9c6qj9pMoL5L9MNGRlfRZTC7
	 5AN6dA2ODPj5YTQiqCx/QQ3oXHxHkNWmIfvw8ajX5T0i8m3xGBkqbbtmoEMdbGjftaT8T
	 dZYTOtUexazGV/6sKfoVawkNIwMV1HmjPOE4X//DHGFZMG3mX0s2dmIznEeuTl5nps+m1
	 M5oue3NJY8ywg/AgVehKmxqYELo1PF0FfhuS+ACEF6E02huE+SocOnXvQZ/GN/p/ccw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792614772;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=ZDmO6koZR2spX3TN+57jLojOQePC7HhMgd3w0y6PzDA=;
	b=VL2AH05iwuiNqw18fw2sS9O3X6G2jkoTSnez5bZu5fWpOhMhe5GLI0HFg5pA5M6agph2
	 Fh7d85ceFAnm1TNy6CMupK+u+qJhkYgwMM6BUoqlg8bc7EjbRmL5ZnSJukHxZACt2ObCr
	 XQZe71thtsE152s8adAJqNMa61GcG+8fPtnC0gQjCBob6WQP/cQ35YKt7Lf1QIBD8wNr9
	 ndEzuskHCHhESr6JUS0yjsVmrjiwyS9J49GRFEySgSTFxMe7of7UNGEROhAn0T18wnYOp
	 iRShu8q31pYYh6kgHXAEdFg0ahEKOOOueLN4Uy5Z2Pr6AnYoXFmrahV0BD+yedHiVtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JtoFiC4r;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B325606A319
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 20:32:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B325606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JtoFiC4r
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48e1d0e5dafso183781f8f.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 13:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792614770; x=1793219570; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZDmO6koZR2spX3TN+57jLojOQePC7HhMgd3w0y6PzDA=;
        b=JtoFiC4rxz7ICj1ufAlkiEnTgVlBWZvVFW5moC56Y83HRVmPoFVndDj0bvmK3dQdVX
         H8Hnu/OQiX/cbBqtrw3Hrj20COT+DL4az+okoOI6gG8HPj+pO4nSJcXzrpmPYbJt1AWV
         2GwoGoF7OzD17XHsJF0XQQaVlfm+nV9zHcOGfxSS8fTYN9ncHm3m8l6G4KynFkhHVxqI
         /pn/KR2xt/WQhTynAfhSOZZDMjFUbOWDj+AdrDX1MIKL6tSHAmmjqPdY3TQmukk7rd66
         YBXRjmwFkktk4uTjCS+D9RKgQoJMxPullI10xcpbY8nuxMmpDXHBp+temO+8AZCGhLdk
         HKkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792614770; x=1793219570;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZDmO6koZR2spX3TN+57jLojOQePC7HhMgd3w0y6PzDA=;
        b=PQJ19upHRTie48zUoU4g0i/047bM3gzbmaoHh9PR1+u/Cc7sQuk7Eh1S/6etUUKQH4
         EkhSFDPF1Vhe3CfxRsacOS6OPMitG74A0neVkEWs6+w5nOFzV8/YZuw5tXVNpAsoLHfG
         m4yeZ9eCObBi/hugIwRHXGmZLFwwdbhb0gmxjM0g2yRiCR1+oifow155DK1gCkmB1Ti9
         73ZEoG/g2lbPpQjQDEzUZm0Z66TOULUyX5uYnQ5Lp1O9IjW3ZC0oRQ2Ly1gPmw4mYqG1
         lxuwz83d3X0OTvHUmHI5a+AHx1GmQ9XoydWQj1/moPKeM1gRaP4NxSDjuZWgkNx73jQH
         YLgA==
X-Forwarded-Encrypted: i=1; AKwUvBwHvP2O/wyZUe6hvvTGMLHqJe/12yQlTpJjHpJS/mjOqzt95nJTebm/iKnapH+mBajXD7mYDcAXXagUt4YPJA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLh7avC8Y97oD9fxDXmapLggZTLg3mTTYwQMb2V0Ld9AVlIgzAr
	rG05r7Z1S3lwdaiJOo0OF0aTgMb9hwHPvzt2X1N4dXIhkI8LGT0RX3oV
X-Gm-Gg: AYBFou1FwZkCVrg4M4sIH1F7gxjton4ZORV+zswbAYGvqckp+RJqfXZHzF4cuz25uCz
	itfRbFHw7zEDeUwshWc78o4eApXH5kJGAhk5hoAbWlG/d9zJLOwlvrpUZLkK8wTUAeK5MSt+tf9
	KbS3c7EMvH7VfYxwlcflu849jpZyN6Y0vUQJbVyNOVNgYNhbS9NwLhajPmin0Pwl/gCNtnMsQYK
	gYaAu0/0p62fh6LTL88UUR18m0UiFvH8Tns6kckqcZy1lgnvP0+pVd9N31FiNpKww8+TIU1g173
	uplyQ7MKjjNEFPfvmAaV6Nokc3AQh9zekEKVc1GckDw9XkltK0L6KYEFZ2RKrCme3VGX5QvpheP
	sHoLEbYnNQnmK866g9G8oKQDhG9tOn+jE1bOaVLMC0rSuA97/RMI2iUsqgeNNoHDkihuINu+G3x
	IPqpOn4hwV+RtO+s9c806ENxIqBPYxGsPR/QNKQsR7Uyd5UFDph/dQ+dvcF4JZJqXacSIFBoA9a
	aXnIn7HIZNSh5vu2/vEJXVPf5j7DP8eCrnaVeNrEZy0+nTwxJlhmamDkX1i7IA9lGQYx71zmfj5
	Wg7fmx5tKVqr5WC48G+IW6IwA+wxGw72ETYoq+iFxzgqNfA38MAdoxUxwygn
X-Received: by 2002:a05:600c:a49:b0:49f:ffa2:1c72 with SMTP id 5b1f17b1804b1-4a204b20321mr8842765e9.11.1792614770310;
        Wed, 21 Oct 2026 13:32:50 -0700 (PDT)
Received: from shift.daheim (p200300d5ff07190050f496fffe46beef.dip0.t-ipconnect.de. [2003:d5:ff07:1900:50f4:96ff:fe46:beef])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a2067b4747sm2328385e9.1.2026.10.21.13.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 13:32:48 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by shift.daheim with esmtp (Exim 4.100.1)
	(envelope-from <chunkeey@gmail.com>)
	id 1xJcws-00000001Kmd-3wFr;
	Wed, 21 Oct 2026 22:32:48 +0200
Message-ID: <6f37c00a-b949-4134-88cd-bf713f58d628@gmail.com>
Date: Wed, 21 Oct 2026 22:32:48 +0200
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
Subject: Re: [PATCH] wifi: p54: unwind failed interface additions
To: Jiale Yao <yaojiale02@163.com>, linux-wireless@vger.kernel.org,
 Johannes Berg <johannes@sipsolutions.net>
References: <20261019013105.1487978-1-yaojiale02@163.com>
Content-Language: de-DE, en-US
From: Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20261019013105.1487978-1-yaojiale02@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/19/26 3:31 AM, Jiale Yao wrote:
> p54 stores the vif and changes its operating mode before validating the
> interface type and before p54_setup_mac() can fail. Since mac80211 does
> not call remove_interface after a failed add, either path can leave the
> driver believing that an interface remains active.

hmm?

<https://docs.kernel.org/driver-api/80211/mac80211.html>

|stop
|	Called after last netdevice attached to the hardware is disabled.
|	This should turn off the hardware (at least it must turn off frame reception.)
|	>>> May be called right after add_interface if that rejects an interface <<<

so mac80211 should call drv_stop (aka. p54_stop) in ieee80211_do_open() if
p54_add_interface returns with an error code...

and p54_stop does:

priv->mode = NL80211_IFTYPE_UNSPECIFIED;

> Publish the vif only after type validation and restore the monitor state
> when MAC setup fails.
> 
> Fixes: 1ed32e4fc8cf ("mac80211: remove struct ieee80211_if_init_conf")
> Signed-off-by: Jiale Yao <yaojiale02@163.com>

priv->vif and priv->mac_addr remains set. I don't think that having priv->mac_addr
set matters. About priv->vif... Hmm, mac80211 passes it as &sdata->vif. So for the
lifetime of the associated mac80211 device this will always be the same?
(... as p54 only ever has one?)

So, even if beacon_loss traps are injected after a p54_add_interface fails, priv->vif
will be a valid pointer... didn't remember or see any other users...
hmm, it should be the same, but I don't know the mac80211 code well enough.

That said. I don't have a problem with the code. It reduces the "need to know
about mac80211 internals too" load... with that I'm struggeling too.

If you want to respin a v2 with the commit changes, you can have a:

Acked-by: Christian Lamparter <chunkeey@gmail.com>

And if not, I guess it's still fine (but not necessarily 100% correct maybe) as
is either way.

> ---
>   drivers/net/wireless/intersil/p54/main.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/intersil/p54/main.c b/drivers/net/wireless/intersil/p54/main.c
> index 57a62108cbc3..69d85efb9260 100644
> --- a/drivers/net/wireless/intersil/p54/main.c
> +++ b/drivers/net/wireless/intersil/p54/main.c
> @@ -236,8 +236,6 @@ static int p54_add_interface(struct ieee80211_hw *dev,
>   		return -EOPNOTSUPP;
>   	}
>   
> -	priv->vif = vif;
> -
>   	switch (vif->type) {
>   	case NL80211_IFTYPE_STATION:
>   	case NL80211_IFTYPE_ADHOC:
> @@ -250,8 +248,14 @@ static int p54_add_interface(struct ieee80211_hw *dev,
>   		return -EOPNOTSUPP;
>   	}
>   
> +	priv->vif = vif;
>   	memcpy(priv->mac_addr, vif->addr, ETH_ALEN);
>   	err = p54_setup_mac(priv);
> +	if (err) {
> +		priv->vif = NULL;
> +		priv->mode = NL80211_IFTYPE_MONITOR;
> +		eth_zero_addr(priv->mac_addr);
> +	}
>   	mutex_unlock(&priv->conf_mutex);
>   	return err;
>   }

