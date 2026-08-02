Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BBE3955E8
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 10:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785666328; cv=none; b=sYkNhHlMLk6rPI4i6Qv9vMaz7gQpAHiXsveCu3TxKt92E0sFugK/9zwOS2ey6apH21S59fLGbgp8jvlRFCkZCRdvkldJJJRFZ6PSsSEGvntWhccJs8BwXb812QrPTovo+gKcQuNN/R79ptl8sbgYUtBLN1LHcX1b6tH2F6/Gxzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785666328; c=relaxed/simple;
	bh=pck+pClOKblcqDWxsPRoWg8rfy6K+Grrr1EREHE3oKM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=KeiJZ8lsrGopRCtrdIk9SY3vWPxwPP2OBmLlMzfUhswjROXmaNBqlVCl9i+Ox0dijkoy3r6rJ+gmSXJDZC+tWMYWgbdAQE2pzyYEQk7/S7SCO9fCcCLK0lKl26fec8ltBgvoE19jJFxde3vNpoJCXkDVe6DT/w5jBCeqfdszBF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=hbzswvKG; arc=none smtp.client-ip=209.85.216.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hbzswvKG"
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so2211831a91.0
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 03:25:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785666319; x=1786271119;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=U30tOpuVn8qhXLPjIH2/nfOt+KCdmSRNh2hKzUS0a7U=;
        b=RikU7kXaAm5qj0izLyiz7bj5ZaQYFAQ4cRfFuD4+395xDgKDoh4Km0m/U/vVK4JbiT
         44uHGQ39tx3tZS4MlIEM7FDMFSMp7ly4Bq4AKuD6v49MWnUzPFAZDLKzZ8SSc9Tagvrf
         4GJ6u7PJ2zeMRT8K2zd6jWs4uvPeyN5yMQ7rphRyWkoRk3EaGR9xEJCParGS+8Wok/ZC
         RowkrEKAG3KyO46ZcXZYROEy0UsLa0/KeAqdfWwynRLmGRAoyQS4WwwvNNTNuc2YvSDS
         ZBI/fPBVOAWEWRGneavl0H5bFso1J3PiJFKGPFsL3shN9Y0IQMhUC3+5WVIHf3IvFxpQ
         TwKQ==
X-Gm-Message-State: AOJu0YxkzmJPbD5bTEYLDV5GW5pC4FMHCNl/BIMJYHbEKorOTpM27jqr
	eexrmY9AG7qEG7P3BU+mYCelNWuxUaV7BI5FWfHACOPxu+4FxdDHAqz0PSK/EjYXppMJZMMyemi
	Qdjy39EtJiDL08ujmOoFW8Y1yOoeLLXrXTYc0RURgTHo4ucL08ZpVgsM31ABvwdolPd0pwsSGyH
	qprCWoA3K/644Zqf1ZAz1czTwuf3k79pQMzWXJArBd0ererxVGZ7tXJe/J84ml5IAKHgvMGHI5y
	2bnB/LIgYf1bAPa/HccpVRbJZaX
X-Gm-Gg: AR+sD12Brh+A/hEhwuvg0+j9vdocoTA8d0WkOFPHeJRtDxjVAMmokk9EaG3leuB1d3g
	L3VOFP9irmSERvh4FDXNb5rOVDL4VMACD0yvLSGbiQHik7YTu60jSKGFaczwrK+2msHKasoCaa9
	NFz9oaYwnT1kR4+KJaFR8k1mV+eQ7ViJG9mMht0kJTQsuwpKst3gq0TBD+FaWjiKIjIjGniXYa0
	Ji+1NA0gUIKOVAenBOoAOiVbsLuzqcBT7YKKSjCoimpDYoZLUUHmZ8wA1UklPjutMuYuJd0TADQ
	oqQerUgVrCXw/XeyicgESFaeSXX8dftx8dO/6wOVq1NqyiYopsJ1H6lHreJ6POziRwCV4kvkGbJ
	tDt9xlKKvjXvpHOf1ZdIj9+1W/AiB7KmHhIJFLkujL5EiMJTXhWP5Wh9laoxBtKVNxMHwqxDp1T
	JM6JwCghmAtjBtvK7qQZF8Tgr782y0eDjqukcXw4E=
X-Received: by 2002:a17:90a:f94d:b0:381:5ab5:b667 with SMTP id 98e67ed59e1d1-38fbc4e518bmr5586632a91.31.1785666319028;
        Sun, 02 Aug 2026 03:25:19 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-38fb2d6001esm603013a91.2.2026.08.02.03.25.18
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Aug 2026 03:25:19 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb733fc5024so3640148a12.2
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 03:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785666317; x=1786271117; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=U30tOpuVn8qhXLPjIH2/nfOt+KCdmSRNh2hKzUS0a7U=;
        b=hbzswvKG+60l4KC5opdp+YoxTEYW/2w+jgzB2YKl0dwnEWTq6FAd3ac5bRh643U4AK
         9PFtnA32PxqeqMfTEq1Wl1+o+IiMOAV41xbyc1N9CiEVtaLE+MWPRTKXY/Hg52oEcPPs
         HzhMFxYCxBJykqXlRNp9h4N8mo0nRl0bhnx+w=
X-Received: by 2002:a05:6a21:3a4a:b0:3c4:14a3:fed4 with SMTP id adf61e73a8af0-3c92a8f5e7fmr6805475637.55.1785666316987;
        Sun, 02 Aug 2026 03:25:16 -0700 (PDT)
X-Received: by 2002:a05:6a21:3a4a:b0:3c4:14a3:fed4 with SMTP id adf61e73a8af0-3c92a8f5e7fmr6805451637.55.1785666316514;
        Sun, 02 Aug 2026 03:25:16 -0700 (PDT)
Received: from [10.229.42.78] ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fab1334cfsm22570319c88.1.2026.08.02.03.25.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2026 03:25:15 -0700 (PDT)
Message-ID: <d5b7a4a8-532f-47c7-a883-036d5cc81a90@broadcom.com>
Date: Sun, 2 Aug 2026 12:25:09 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/8] wifi: brcm80211: performance and stability fixes
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Shivesh <chanelshivesh@gmail.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org
References: <20260731160646.3812-1-chanelshivesh@gmail.com>
 <20260802101530.4028803-1-arend.vanspriel@broadcom.com>
Content-Language: en-US
In-Reply-To: <20260802101530.4028803-1-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 02/08/2026 12:15, Arend van Spriel wrote:
> On Fri, 31 Jul 2026 16:06:17 +0000, Shivesh <chanelshivesh@gmail.com> wrote:
>> This series fixes several performance bottlenecks and correctness
>> issues in both brcmfmac (PCIe/SDIO) and brcmsmac drivers.
> 
> Two blockers need to be fixed before any of this can be applied:
> 
> - 2/8: num++ was dropped from the subframe-parse loop. cnt is always 0
>    on return, so rd->seq_num += cnt - 1 underflows to 255 (u8) on every
>    successful glom receive, corrupting sequence-number tracking for all
>    subsequent packets.
> 
> - 4/8: pmksa->fils_cache_id does not exist in struct cfg80211_pmksa;
>    the correct field name is cache_id so this does not compile.
> 
> Beyond the blockers, please split the series into separate submissions:
> 1. Stability and correctness fixes (3/8, 5/8 TX-stall fix, 6/8 Fixes
>     tagged part)
> 2. Performance improvements (1/8, 2/8, 5/8, 6/8 performance parts)
> 3. New functionality and comment-only patches (4/8 PMKID_V2,7/8, 8/8)
> 
> This makes it easier dealing with fixes that should go to stable trees.
> For the stability series you can add Cc: stable@vger.kernel.org and a
> Fixes: tag in the commit message.
> 
> Regarding patch 1/8: the patch also fixes a race where a ring state
> changes RING_OPEN->RING_CLOSING while blocked causes a permanent
> netif queue stop. The fix relies on the atomic counter so keeping them
> together is fine, but this change is primarily a potential bug fix so
> rephrase the subject, e.g. "fix blocked-ring race permanently stopping queue"
> 
> Finally, some of the commit messages seem to use LLM lingo so if there
> was a coding assistent used please add an Assisted-by tag as required by
> Documentation/process/coding-assistants.rst.

Some additional remarks. Have these patches all been tested and if so 
please add reference to the platform used. Especially for the 
performance improvements it would also be good to have some profiling 
information as to how much performance gain these patches provide.

Regards,
Arend
