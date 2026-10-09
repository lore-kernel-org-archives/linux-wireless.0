Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4207F4DE707
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 11:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791546384; cv=none; b=E2+UgLuR+iHFWlneTC1IBf91oH0QEJOW6OT/1sNTOt3KO2G/HsLhrz8LX8Nxg+WniNUazpNKBHCzkx5h2D8by6kcOWm1OcLRee7OGsAmXq4klOnXX8LJ/d7htGgnOyPk1nCzUReUiqGLy1YZld5qqvfQHGTE6BXcbUfW49/vp2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791546384; c=relaxed/simple;
	bh=qfn6Chi3zQPoGrRKHUmzBsOFSj22hZyuE74D1Bo2Iiw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fDEHF688bWcjcwRvKU6MTb1x6nZfT2RyUtxPFefJqveTjYwnjAEBJmn0SDOcleHog61noN0EDmPKLKleoSuM84LXuCzQRwiL/LINwwCv6SzMO03ZtXpqlFZHTbjsjPIefw9b7XjDnjR5a+NkvT8VxibGHoLqiPPW2t04/VsIVzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=aRcxVCoV; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="aRcxVCoV"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3a4b9732d5aso3556531a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 04:46:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791546376; x=1792151176;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=BQ6/HQ3rrLrwxJjtL2d0lIbMN8Q2NnassUE+UKdIN9s=;
        b=BloqvOWhpeSXmsGZHyH7W44B+cXbqGUkfONR/iR/G+S96xvk3jarVm5Fzqy2dcQYZY
         LUDUoIO1pJt0x0k5EvvVDPDCdWrosBNDScTiVO2DYBKyTP5WSz32fy6NYemH5yI51I+S
         ffWo/313BK8Gw7GzDP4GDMe+Hp3fZ2YzCXCAZv2sRqStrCl1QaPgQwWZhkvhfGqy+cV8
         nETTAPUE9aCIAfHYzlYMMTVxbPUA75POeD1X2yO38UJl0CgkBPTEjL8Z9ksj8k+uwtjO
         WvQWo2foFGocjRJ6LmPmptExHswKJ2Z4zGQKSEOY1ZP63AKXcFMpU4qPs46qJSjCBPp6
         aF5A==
X-Gm-Message-State: AFq9FYJRjW1Dgk7STGFKKkJvE6Z5UL+XjI0TNBxr98qPE+gq+ZzU3LS4
	lv++ZrfeWeTP7Php6BH1eSDCtGj1uBx7iZufyfkTjG6UoSjOuN0uN62J12E6hBAfcoPCti+pYZQ
	dUfS+uhYoFdkpI/3oAwPtoaXplTYFwwhyPJD5zVUQnp+1ZbGHQ9JnTwaNZFOyYIyYwHvu9I9NRL
	B/DLkb8mJzNLyxO8lKOdRgSq70iqbq/QDP9MyFCk0LcvD5Gc/25krZXBiL31BnC5A+brZ+9LF/a
	nn+l3KIKshAKB9DwEg1QGqyAyAy
X-Gm-Gg: AYBFou1A4mQ1ITfn4l0HPQo4/91x2kU9vEszjIvgJBD/gZDmOkzPowhFT7M43BENrhB
	TqqJdXe22o21bgMv3diincFvNff1bNddL2VAqfrN9hEYo1jgBddRz8L2znH5EGGBl7gKAlcfLlf
	bsdat1R7ce9LXNswPC7pOI03B0b7jsxP8QdKhf4SOpVnIeOTTG+RZMxwHDIkc2KIF8E4IL9JOMY
	7ADGKRhcFy+oecT9TdDThvDyDuYKwrIedy8Gq+f0JjHaoTQzpXi4beFuYIiO1eWWyY1bNFQV0Z5
	6yUPVcNRXsfqrgrWZFM/RTiwmjtY9h06xr8EfHWYx680IiyK3EFQ2XLPOxtbcdfi3stCq2yxjCG
	Zw27bpRyK6p4kDtrIwjgnMmR2hpK7bDT4sf5PjQKMy5ZrisVhJAT3tHLxBOzhYrO/0M58dDmlwx
	EEAspOtttm0sWNxdhNDLfViTwpgPousKE/XQzyohAmOw==
X-Received: by 2002:a17:90a:d44d:b0:3ab:2737:3393 with SMTP id 98e67ed59e1d1-3ab3a9fc387mr1570607a91.40.1791546376361;
        Fri, 09 Oct 2026 04:46:16 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3ab3972fea2sm368575a91.3.2026.10.09.04.46.15
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Oct 2026 04:46:16 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-151ba226e1bso9416168c88.0
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 04:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1791546374; x=1792151174; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BQ6/HQ3rrLrwxJjtL2d0lIbMN8Q2NnassUE+UKdIN9s=;
        b=aRcxVCoV30TPCjd3pumAc//8aV2bn3Li3hv12I5s+yKPDfsdyTtnWa6GpUfijnH9Qm
         V+2xRzgJ53sAfL5VOWbWW/kXhfOrSzM3Q9cFJxxAtWCpPiz/z2hAzT+l/KmRWWLdPy85
         SEwMUXFnGrsvsg3PF+u5KjtISXbYyCx6BRCkM=
X-Received: by 2002:a05:701b:4583:20b0:151:ece6:b171 with SMTP id a92af1059eb24-16a5dcf6262mr2016594c88.14.1791546374209;
        Fri, 09 Oct 2026 04:46:14 -0700 (PDT)
X-Received: by 2002:a05:701b:4583:20b0:151:ece6:b171 with SMTP id a92af1059eb24-16a5dcf6262mr2016563c88.14.1791546373450;
        Fri, 09 Oct 2026 04:46:13 -0700 (PDT)
Received: from [192.168.178.26] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a442ac67sm9791902c88.18.2026.10.09.04.46.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 04:46:12 -0700 (PDT)
Message-ID: <448913a7-809f-4ecb-89cc-3aa3bde08c5c@broadcom.com>
Date: Fri, 9 Oct 2026 13:46:06 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: brcmfmac: avoid sleeping tx locks in netpoll
 context
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: linux-wireless@vger.kernel.org,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, stable@vger.kernel.org
References: <20260930185417.61865-1-kmehltretter@gmail.com>
 <20261004122910.1392318-1-arend.vanspriel@broadcom.com>
 <asR1TaKQJlPFqEvR@gmail.com>
 <802a092a-314a-4f77-aa1d-134b3d020069@broadcom.com>
 <asiX75kRueyFqWuO@gmail.com>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <asiX75kRueyFqWuO@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 09/10/2026 09:30, Karl Mehltretter wrote:
> On Tue, Oct 06, 2026 at 10:27:27AM +0100, Arend van Spriel wrote:
>>>
>>> Lockdep instrumentation in fcmode=1 and 2 confirmed that cleanup enters
>>> without txq_lock.
>>
>> This is an observation unrelated to the patch, right? You mentioned in the
>> patch it only covers fcmode=0, right?
>>
> 
> Yes, the cleanup observation is unrelated to the fcmode=0 fix. I
> mentioned it to explain why I kept brcmu_pktq_penq() for normal calls.
> 
> I'm looking at a separate brcmfmac FWS-path RT/netpoll fix for modes
> 1 and 2. The prototype defers IRQ-disabled transmit to the FWS worker.
> 
> Are modes 1 and 2 used or recommended on SDIO devices? That would
> help me prioritise the follow-up.
To be honest I ported the whole shenanigan to brcmfmac, but I do not 
recall any projects used the functionality in production. It is mainly 
intended for SDIO devices.

Regards,
Arend
