Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7E230567F
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 17:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786470292; cv=none; b=Xkl7BAU+NzAbCHsyF/kaBDaTThEYFt1NPw4H8EbWhe2zhJaTFWEPnbSA3YSa8xpMCGuQt/dq+t0p0oMWYW/id9JqgraV1rri/qHO8fT6ISaehr6SjMxLOeM/RMYKllOGuzvDbwey5wpaN7TJybb+HFkP2QZJUR3O573BMgqcEnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786470292; c=relaxed/simple;
	bh=MgJTORPddyx04tF6gAKXwd+5qCIWXX6+mRyOmToBHfo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gPn95be9Dh/Je8XKwsT7MOx+mWodvm4UTbZTx5xID048EnafdP5Fa/pqbq8OOzDhwYmAXXwxbz2iMW4OviTdlBGb22xhNuLnK+8/y4sydDnJdZ1ULimp+9NkD/0vQqGZLb93ZiM9uYUXphyHbYeG1G7gcqGmQ2yVUzuszAgxs28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f+G0b2Cb; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f+G0b2Cb"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2cc891373e0so2910445ad.2
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 10:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786470291; x=1787075091; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BKgS3imU3mLlx/24sKuKsUg+v8k9/smiKvWcmGZ0mLk=;
        b=f+G0b2Cbzt8/B2jm+/ImnWa7IsWEmzMYVkZt61KVeM6hy+rNoAawIeCw90uFJMdoGT
         FuI7ls9bLSb7oz0qQEneLhUbWKh2b4qm5+qbTjZUn7Gh/83M2iIZTuEjOOaUD0K8349v
         pJ54vnwfIAhEioFnVoDLC9OSrlB4hVa35pqZ2MkUWP5nfOxPmAwmfMrTV38udYGDTYQU
         g+EAKs6RC8E4lH94Sc3u4UdM0x8jzeHprc5NkAisQM7DipSF7coiMgN7BSSqemwPeKQG
         I4JF1ubPCjIk9BwOfExMT7wO0hGt5KkjIZ+BUiJhtK5fZHAemL2O732igqzU8UrivBIm
         Tb3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786470291; x=1787075091;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BKgS3imU3mLlx/24sKuKsUg+v8k9/smiKvWcmGZ0mLk=;
        b=Vc0zzq5+emwixlK9ewQOpoPNvv27c1ddg8DB7LDrOpN7MArKyjiWha8u73jyCEFiVN
         50qH7pBRBb8CrQS2Ai6X3ugya5kLmCCmULV4GCVJ2nFTc+zDzpHMybUSurRkyKy5wF2I
         l6J+VDIs4C+dpvIa9f0DSM3vinAl/7A1ea2wHEEaJIZfsxRCVAP/H838LmOx5AKSdGhB
         CcgAt+23LjTT+c6GMVBWSqiKzPRdPb6GEja9sYus2mDRZc8bgZapYzy61Dkqk1yGamlT
         p3VQEEPBY5Sds65w+jyGTU2TePPShQ0AilWjw38cJBbP7VUzEWg9bhZHQIkBZcsSuFyN
         uVcA==
X-Forwarded-Encrypted: i=1; AHgh+RrXXKGq7t2cwvG7KOJ9gGJvkd160uJsNw+/JnddO7oJbITTCUMCgO9Rp96n3yVf+GiYKVmx63pytMjJGNVSkA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzB5SxWcR1sYG6rSaYAmbxMQN3fz6OeAIPeSgpizbBg3n3Q4Jjr
	Tb/JJ9SbZsG9xCxi1JFpxVr0yPNyJyImPiYm8BoZ1HcXoW8tuYUsST1g
X-Gm-Gg: AR+sD11kFMSnxGcGJSQDnilLethvoiqNl2ddh0uVScoNzn5j7Eis4HD/ZJB+Pb6Qa5h
	EQvLCBxU/3RZ6Y2swyTvjcWzNIe2588UxE1nHLpHecfkgPaUnGXgmxbHNUz8Gt75liQD+bp0q5w
	W9niUbvhW69IROwL7Xp2QonyU1uA0G5wfXUVx3zABI/0Wt+CUOGgID9Cnq9sqJHc1gOe8GDJN3p
	7qqU4ACstVfad+ypEB2W8BAOYlHVKUfdQzLS2Nan+zgBlEzj+zXTlp87LOZ+6aQXg+Nrhoh9jRd
	MwZxPFk1shGu2H1WDriLU+sgSEHFz6uVtc9xz0IB1K0eCURQ/HTrjoMCWRjUknoI0SfcHFiwGZp
	wW5yX4XRUZy0ux+Jh8xHR+wOSfVS0GfD4smL/63e3aYvzuMKHW0AX9nD3HbKfhF9frZsBaXO8Fj
	NZDOfvN2OlJbZlL0V8auJNS2IIGTncUqsYZ1DoRyTx/rqwn2Vzv2DabqrceVXdliHZilaWo3Qps
	+jlrhL/ebAxxx9sNp1R/wHC
X-Received: by 2002:a17:902:fdad:b0:2cc:ae2b:b6d2 with SMTP id d9443c01a7336-2d3178d4184mr63905515ad.15.1786470290538;
        Tue, 11 Aug 2026 10:44:50 -0700 (PDT)
Received: from [10.100.120.121] ([152.193.78.90])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d315f48547sm11248295ad.36.2026.08.11.10.44.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 10:44:49 -0700 (PDT)
Message-ID: <30d659c8-f568-4903-9dc0-1a78e16229ce@gmail.com>
Date: Tue, 11 Aug 2026 10:44:47 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: mac80211: defer AP-side FT key upload until
 association
To: Andrea Covelli <andcov23@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
 linux-wireless@vger.kernel.org,
 Kavita Kavita <kavita.kavita@oss.qualcomm.com>,
 Sai Pratyusha Magam <sai.magam@oss.qualcomm.com>
References: <20260730161531.3535100-1-andcov23@gmail.com>
 <219ac494-deb2-41f7-a762-7b5e666499e3@gmail.com>
 <20260811173509.179926-1-andcov23@gmail.com>
Content-Language: en-US
From: James Prestwood <prestwoj@gmail.com>
In-Reply-To: <20260811173509.179926-1-andcov23@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrea,

On 8/11/26 10:35 AM, Andrea Covelli wrote:
> Hi James,
>
>> How does this present itself on the station when this happens? I'm
>> curious because over the years I've seen strange behavior from basically
>> all vendors of access points like:
>>
>> - Mysterious association timeouts despite good RSSI/utilization.
>> - Denied FT associations with reason code 53
>> - Successful FT roams immediately followed by a deauth with reason code
>> 6, 7, or 9.
>>
>> I know the above could be from any host of issues, but I'm mostly
>> curious what the client sees with this specific FT key upload failure.
> The common case appears to be that the station sees a successful FT roam. In
> hostapd, wpa_ft_install_ptk() simply returns if its pre-association
> wpa_auth_set_key() call fails. Since wpa_ft_install_ptk() returns void, that
> failure is not converted into an association status code. On the subsequent
> WPA_ASSOC_FT event, hostapd calls wpa_ft_install_ptk(sm, 1) and retries after
> association. If that retry succeeds, the only visible symptom is the AP-side
> nl80211 error.
>
> The OpenWrt field reports reflect both outcomes. Most occurrences were
> described as log-only, consistent with the retry succeeding. Post-patch tests
> recorded successful FT associations without the AP-side error. I did not,
> however, collect a station-side debug log or packet capture for the unpatched
> case.
>
> There is one more severe report from a three-AP mt7981 deployment. The
> reporter correlated clusters of this error with Android and iPhone connectivity
> loss. One AP log showed 14 key-addition failures, about three minutes without
> the client, and then an eventual successful association with auth_alg=ft:
>
> https://github.com/openwrt/mt76/issues/1098
>
> After applying the OpenWrt patch, the same reporter observed several days
> with no key-addition errors and normal roaming. This is useful operational
> evidence, but it still lacks a synchronized station trace, so I cannot tie
> this path to a specific status or reason code. The initial pre-association
> set_key() failure alone should not produce an association timeout or status
> 53. Of the cases you listed, a successful FT roam followed by connectivity
> loss is structurally the closest match if the post-association retry also
> fails and leaves the AP without the PTK. I cannot currently connect that to
> reason 6, 7, or 9, though; the station-visible sequence needs a capture to
> determine.
>
> A synchronized station debug log or packet capture and AP log around one of
> the cases you have seen would be very useful for determining whether it is
> this race.

I unfortunately can't get AP logs beyond what the vendor exposes (and 
they aren't useful). Another case I forgot to mention is the client will 
FT roam and immediately start dropping _ALL_ IP traffic (despite the 
802.11 layer remaining connected/stable). We've seen this with several 
vendors and actually had to create a watchdog to monitor for this 
situation and force a deauth on the client side. I wonder if this is 
closer to the issue here.

Thanks,

James

>
> Thanks,
> Andrea
