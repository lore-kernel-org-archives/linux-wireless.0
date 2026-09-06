Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DC521770B
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 14:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788705040; cv=none; b=FJt7kJGl9K26tHumXREt76X0NT3g6qrq4LUJ74IXDZa7vdedgmNWGelVZV7xIx6UKdmNKqGe0CJzfoPDg0rmr9HfW79U82jQHxkApTfDPTPo8hYAVRIPweH4g514dfSam8choLrTEiJN6LE85+Ro5dsFYuLlf3iFy/fsRgomtjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788705040; c=relaxed/simple;
	bh=4f9/sp1cBbVINT19hHyDctAY/aNbol4Z5lm+5a64jqk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ovkHyRuttUBaqEVc8XtbD0IfAIjl2EiEfX63Du9IOPCBOIe2aWYvxvmNJhgDFd+788VUj05jMUr+9BUlS/Q0nGIU2DXRtFjPJC0288Yaj5gzfBO2fV9LMJRCQ5ZFI/wwfd6bpTFE7Prte7Jp/hb0uZCR7XTRwiufzGJ+aw9DpWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LAWuw/Ns; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LAWuw/Ns"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-495590dde14so36819685e9.0
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 07:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788705037; x=1789309837; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6ddua5FSUFEI7sF7Asi4G3vNLkrnHxrArFpGlrW6iGY=;
        b=LAWuw/NstkAG4+vY7J3jS1Tw2ghnVPBG0uMP0kO28Vi/KvvKeG2QdGDkOK9CG1uWkE
         iwL9Zv1TYI0UOrjGJRNWWXj+mXIMZYQF77urYEt3j42ttMOYx7QIwKjSq7ig9z3kOoK7
         yjEjo0IDYd63aH7g7Ha9h68Ice2FpPa/cPBhvubJ6xPjg9zm6YDPwS3n3hvCIma5IPRF
         G2PXx+Bqnq6mLATHvyxKfsAtOWMZld9stQPWuaMAnHkYE01A0ZxcjmIMl9+IDFFkH1O2
         2XznV399/Sl5x0qh0be/AkGO2FocomQ24nVqOTBCEFU81uRsSF2wIdtjOV2QQudMpwjs
         hSmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788705037; x=1789309837;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6ddua5FSUFEI7sF7Asi4G3vNLkrnHxrArFpGlrW6iGY=;
        b=eVKpJ2hhMMgzMkEFKURPAYAWELQDPDterdcWuwuQeuvxgFT0HmawOsIfSrKy8sdsB/
         NEcYQq1pVLQmoAs0aBMUbqpNnHNPt1GmO7kTne5SAEi8d6IcvK79jr5wazs+4A3K/JZp
         HmJEUNVdMocyZpwMTrJFkwhJfT80J3D5cqmcrGqGVa3sBrF15asBFUHixbnbr+0/JWXA
         gxhot+Rc3WzAC+GhDVKG6rn2gi14gFO87Q1jWBswwBdolaOYUTNoTE0MutfDNhnXMTp4
         prIsG0Bjt8CB5bjnUMFAq0xChdwim1uIPXfe0NGteHhCL/JXARSZVjbw4vvr0o2x9PJE
         jUsw==
X-Forwarded-Encrypted: i=1; AKwUvByyzPnvqdqRlr3NWB8NPlHSD5pal/PfuEjpVOD/Wd0tnm7T7d2ZYZg13jWLdTlXsCY081J49+FFy00Gif6KUA==@vger.kernel.org
X-Gm-Message-State: AFuF++nTo7LtDyQjE34N/EOIiZLQ9nzr/I5FMDZBLRtVsN7t+P4dsBVM
	1hUifI3BW36XMIU6OB9vu8M+Xt7FyFOy8d50fANlK6IzdTj9apphmoG3
X-Gm-Gg: AYBFou3edF8A3VupivJvAjm6fIokYMoUWG/2seLKcVCnvnk1PqLDDd2Oz2gmSDRrW40
	Z4Wi1P2oaH72pmZ0UmeS7A/VDNTL1O4rphIVCx5eqx42lvcsekPQpfjo6d2lFyMDUQQPcGCuQDN
	pDfXRUTrVNHiBG9DebsZjShowgRVPpVqMphC9ruyPq+2l5LTAE9+KRQCuHCPIOFOyjBF9Z+zAtq
	w5N7SsqPe5Y9frvyUoUrRbdlVLGebweM0qfI594IkmZIiHs2wDFlEOXiCs4EdFfarEAyZ6OtmQ6
	eM3hZ2UW9HU1mHCmi99J1l6pv3KPQmNA90TXHLjamMbpbcXDK7aNE+BODpxHltsqUUyFhQZSdEm
	4Swkn6iYtO43lWxrINt2m1FSPW46m01/sk9VtA8oDI4nrIL0/inKWT9/5pDuwgksCjVoop5pkKD
	CkzMXS5Uy35ss4Np5G4spFKqHBxbts6d8M1vT2KS+Px75K0FgbxhK5lBMcanMCTPfMjl1okdnJN
	1VUTeQldWsEfNdqFtuJrm7nNS7wsIBIFL7NgtszL3y26ZoOnmNIA4++tEnzN72PkEw=
X-Received: by 2002:a05:600c:4e51:b0:49c:ff8d:b548 with SMTP id 5b1f17b1804b1-49cff8db5demr274727975e9.11.1788705036753;
        Sun, 06 Sep 2026 07:30:36 -0700 (PDT)
Received: from shift.daheim (p200300d5ff3cee0050f496fffe46beef.dip0.t-ipconnect.de. [2003:d5:ff3c:ee00:50f4:96ff:fe46:beef])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d07a23e85sm116603625e9.5.2026.09.06.07.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 07:30:35 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by shift with esmtp (Exim 4.100)
	(envelope-from <chunkeey@gmail.com>)
	id 1x3DtC-00000000F3y-3OoL;
	Sun, 06 Sep 2026 16:30:34 +0200
Message-ID: <4af25b16-937f-4abd-80ed-78e9df243e95@gmail.com>
Date: Sun, 6 Sep 2026 16:30:34 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] p54: validate firmware descriptor RX range
To: Heyang Tan <thy15333007817@163.com>, linux-wireless@vger.kernel.org
Cc: chunkeey@googlemail.com
References: <20260906133444.946-1-thy15333007817@163.com>
Content-Language: en-US
From: Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20260906133444.946-1-thy15333007817@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/6/26 3:34 PM, Heyang Tan wrote:
> The BR_CODE_DESCR parser reads fields through rx_keycache_size without
> checking that the record contains those fields. The record length is
> measured in 32-bit words, so the fields accessed by the parser require at
> least five words.
> 
> It also subtracts the RX offset from rx_end without checking the result.
> Reject descriptors that are too short, underflow the offset, or produce an
> empty RX range before updating the driver state.
> 
> Signed-off-by: Heyang Tan <thy15333007817@163.com>

Sure. Can you please add, if this is/was assisted by an AI?
https://docs.kernel.org/process/coding-assistants.html

Please give me some time (like a week). I can this run on real hardware
with real firmware. I just need to dig up a PC which still has pci.

> ---
>   drivers/net/wireless/intersil/p54/fwio.c | 23 ++++++++++++++++++++---
>   1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/intersil/p54/fwio.c b/drivers/net/wireless/intersil/p54/fwio.c
> index a3d9053f0..5d82e0a43 100644
> --- a/drivers/net/wireless/intersil/p54/fwio.c
> +++ b/drivers/net/wireless/intersil/p54/fwio.c
> @@ -79,9 +79,26 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
>   		case BR_CODE_DESCR: {
>   			struct bootrec_desc *desc =
>   				(struct bootrec_desc *)bootrec->data;
> -			priv->rx_start = le32_to_cpu(desc->rx_start);
> -			/* FIXME add sanity checking */
> -			priv->rx_end = le32_to_cpu(desc->rx_end) - 0x3500;
> +			u32 rx_start, rx_end;
> +
> +			if (len < DIV_ROUND_UP(offsetofend(struct bootrec_desc,
> +							   rx_keycache_size),
> +						       sizeof(*bootrec->data))) {
> +				wiphy_err(priv->hw->wiphy,
> +					  "firmware descriptor is too short\n");
> +				return -EINVAL;
> +			}
> +
> +			rx_start = le32_to_cpu(desc->rx_start);
> +			rx_end = le32_to_cpu(desc->rx_end);
> +			if (rx_end < 0x3500 || rx_end - 0x3500 <= rx_start) {
> +				wiphy_err(priv->hw->wiphy,
> +					  "firmware descriptor has invalid RX range\n");
> +				return -EINVAL;
> +			}
> +
> +			priv->rx_start = rx_start;
> +			priv->rx_end = rx_end - 0x3500;
>   			priv->headroom = desc->headroom;
>   			priv->tailroom = desc->tailroom;
>   			priv->privacy_caps = desc->privacy_caps;

