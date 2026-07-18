Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D219734B66F
	for <linux-wireless@vger.kernel.org>; Sat, 18 Jul 2026 11:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784375713; cv=none; b=E+DVlPdPdqDhSIO3ZDm7t4RGq2hm3a9wEQbicPXFYhQ6gE8OYaQGYCuQIuXIXuptZiAKu2LldhcmnejK2QBRllQyoakICVIEfpnsSE9DoH12/I6dXg5IyCEIykm9EQ7HFYJ0BsKvnOBYnWV/KxLxQHj0W3XqJlDMSjFRqxTKz30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784375713; c=relaxed/simple;
	bh=wWH/JneNNCFrzvvIrktJAtBFuvYyUpgDsJ01yaJiHSo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PV8QSQlNWS8qnqXrKrP9kJprwYcZqpbJ9ntLNIcd2Yl6NDTdI5MVsJ7wfwtUHEdxEFp73VgTisOBktz9fz4yQyChc94ORBYGLd2SqM7DK5zLGOw6UNDRZoLqtlZd8PZaMavW5cuLn2ZP+899tRB1IVOTCf82W6nPEhkcFruhJSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bSBkO1Xt; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bSBkO1Xt"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47c6e9a694bso4744019f8f.1
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jul 2026 04:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784375710; x=1784980510; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6SMAM6Jg8v3g+Q7U5GrJYeYdSrEr5GHNyPrzfLyMPog=;
        b=bSBkO1XthfC4v80smmgbfekqOA15BOBJxyiUIE1qEenZ2/4LTgAKd8uIfoV/RaqM2V
         qtfSaFHi1WtXDSnSrOb0aoU7oANVf+P+mUOWY/9kMsQyTcn5MOzTrfzE/a4X07hhs8Sy
         MlEHssrQmJqW/Cr1JVY6rbwju5NHwOmVVQHjJTgw2aGOUAI/0JGaBeI/rYsRRWAoAx4r
         1CbMcXH/5tXC+75dYgmENGT36HrRATtBurZlQXOL+0FMTrWXMDja4vY4jqS69NIxK/A2
         NqnYxG1uqSZVMgX9lwUQYrKiczFr1n5tnrDRbL2GFLhCsHVhjlK6Fnz/nzkbawW1xshM
         5NLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784375710; x=1784980510;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6SMAM6Jg8v3g+Q7U5GrJYeYdSrEr5GHNyPrzfLyMPog=;
        b=HaJKzVARJEn3BUjyWRkmySQwXbZVD7tTdmkP0itDeEvwfgH+xwif+CVcNIe5XXAoVr
         DutUda7boB6nENNOjsWf+9ff87TEnMn492Idure4jMpIwz3o5CY/b1wJ+GpG33tyZlFX
         VZ1KVGmRKBTCq8MslFsTsJPEXehxvgawUVT9hmHBK3ahMbGXShTvXk14kG5SGUHXWFgC
         6Pd//S463Vp0YKtsOhd0BwhlSc2ngPvUJUX1h/gBKRKOK4cFsloavk2rdLUQh+Ik5g+v
         gX6Kxs3kOFXdhaJM4pp7qBpBNuxoYTUwzOyrVgbULxqaBFlaAzUXV/2gAh6tyTXXw67v
         hVOQ==
X-Forwarded-Encrypted: i=1; AHgh+RoXw01TSgcJPOhKFJpBE3WL7Iu3nC984iWLM/FKQpcswN9MJcJ480Hpr2INAhXuyMzjIXmz/JXC1r1a4f+sxQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzOkRjVh+6SZoNAawqBnliZPIztAfRBzEI600JzkNdm4oky8I90
	vAIJb2xvjnc4xYSdHMT9WY4/Zdb+sgDAMbWDE6p/3yjBtz4l5IwxxAEg
X-Gm-Gg: AfdE7cmkCTCMVUxBVjzIea4sd3/y5TTHaS8NDNbF1IouUcTfkezTRiIMbaN0pIYk37X
	99ZPm5mH2xS+e/+nUhablfoztzff/ePlJmzoL/YjC42dTHBmKUHRjx1EeOOuCLsPCUar2FOq9sh
	duZcdhphWOPwCUytyMZSB+nJSdXEE8oB1Dt3V/Tgt2g7nnMVhc3rvHYJ8EA/5ezq1Su/oX8nfrr
	fXxAUjg4ML99HnWzdP8n4iR44hzvw0JTImyK1d+eYlbClkBcnvLEj9/HivJb3Q93pangWR1Lbz5
	raLYkDZFp1S2M5IgRmrw0fNxoC8wkMsdD2FfDy7k8wGbPvvXOQCoAxVV+8B7IR4M3jZ34DlJqFP
	EZ692dFbCUc8jqLPjRogohZbDAHDGXzbqbICepuNdlFD4Uer949Pi9kXjyakUdIVpxuA/BEQOVq
	bEJarO2SMADA==
X-Received: by 2002:a05:6000:4a19:b0:475:f100:3607 with SMTP id ffacd0b85a97d-47f623391c8mr7801229f8f.54.1784375709845;
        Sat, 18 Jul 2026 04:55:09 -0700 (PDT)
Received: from [192.168.1.50] ([79.118.68.203])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63e496afsm12682419f8f.1.2026.07.18.04.55.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2026 04:55:09 -0700 (PDT)
Message-ID: <4d8ac018-ce77-4e30-9596-bbc28d18c18f@gmail.com>
Date: Sat, 18 Jul 2026 14:55:08 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [regression] rtw89_8852be: silent RX stalls since v7.1; reverting
 bda294ed0ed0 appears to fix it
To: Armin Breiteneder <armin@breiteneder.me>,
 Ping-Ke Shih <pkshih@realtek.com>
Cc: o-Hao Huang <phhuang@realtek.com>, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <7de74e5c-3ad4-4264-a250-fcb1e66675be@breiteneder.me>
 <0f6d921f-1026-4d9a-bad5-7e5b9485c4a2@breiteneder.me>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <0f6d921f-1026-4d9a-bad5-7e5b9485c4a2@breiteneder.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 18/07/2026 01:48, Armin Breiteneder wrote:
> Hi,
> 
> I am hitting a reproducible WiFi regression with rtw89_8852be (RTL8852BE, 10ec:b852, CV:1 RFE:1, firmware 0.29.29.18) on Fedora 44.
> 
> Good: 7.0.14-201.fc44
> Bad:  7.1.3-200.fc44, and v7.1 vanilla
> 
> Reverting bda294ed0ed0 ("wifi: rtw89: Drop malformed AMPDU frames with abnormal PN") on top of v7.1 appears to fix it -- the stalls are gone.
> 
> Symptom: every few minutes the RX data path stalls silently for 1-7 minutes at a time. The radio link stays perfectly healthy -- still associated, signal unchanged (~-62 dBm), "tx failed" and "tx retries" both 0 (the AP ACKs every frame we send), "beacon loss" 0 -- and the station's rx_packets counter keeps climbing at ~23 frames/s. Yet almost nothing is delivered to the network stack. The kernel logs nothing at all. Then it recovers on its own, without re-association, and the whole backlog is delivered in one burst.
> 
> Quantified over one 54-second stall (mac80211 station counter vs. the napi_gro_receive tracepoint):
>   frames received and counted from the AP : ~1230
>   frames delivered to the network stack   :  ~211
>   frames withheld                         : ~1000
>   delivered in one interval on recovery   : +5070
> 
> Everything that does get through during the stall is broadcast/multicast only (ARP, IPv6 multicast, vendor ethertypes) -- exactly the traffic that bypasses Block-Ack reordering.
> 
> That fits the suspected commit: dropping a frame inside an A-MPDU leaves a hole in the sequence numbers, so the RX reorder buffer waits for something that never arrives, everything behind it piles up, and it is only released once a timeout fires. I have not verified this in the code beyond reading the commit, so please treat the mechanism as a hypothesis -- the revert result is the solid part.
> 
> The AP is a FRITZ!Box 4040 on channel 36 (5180 MHz, VHT80), non-DFS.
> 
> Already ruled out:
> - Powersave: disabled (NetworkManager wifi.powersave=2, confirmed via iw).
> - ASPM: disable_clkreq=y disable_aspm_l1=y disable_aspm_l1ss=y disable_ps_mode=y
>   all set and confirmed active. The stall still occurs -- note this is the
>   workaround that reportedly fixes the CachyOS case below; it does not help here.
> - Signal / range / DFS: signal constant across the stall, channel is non-DFS.
> - TX path: txf=0 and txr=0 throughout.
> - Stable patches: "git log v7.1..v7.1.3 -- net/mac80211/ drivers/net/wireless/
>   realtek/rtw89/" is empty, so this came in with the v7.1 merge window.
> 
> I could not find a way to trigger the stall on demand, so I could not bisect; the suspect was found by reading the v7.0..v7.1 commits touching the RX/AMPDU path and running a targeted revert test.
> 
> A regression with the same version boundary was reported against the CachyOS kernel: https://github.com/CachyOS/linux-cachyos/issues/921
> 
> Fedora bug: https://bugzilla.redhat.com/show_bug.cgi?id=2501974
> 
> Happy to run a debug build or test patches -- I have the affected hardware and the failure shows up within minutes of normal use, so turnaround is fast.
> 
> #regzbot introduced: bda294ed0ed0
> 
> Thanks,
> Armin
> 
> 

Hi!

This commit from 7.2 should fix it: https://github.com/torvalds/linux/commit/63ccdfac8677387dfdbd9d4336089e9823280704

It's queued for 7.1.x as well.
