Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793964993;
	b=w0FhI9V3eNOJLjYzGASuyFbS7ZfJ0bjop1LX2fA8eWkWKL01jhd1vBUryTC6boAuPwaY
	 e8WnzK8x4S0jbBWcJ5znz5PFIueEjvAzPd8/NM9+1JIKx8J3gr+ZNiz+Kne+xsuMSAvAB
	 xg300fkRF+StIVk7n422M6+VHzJQiiHERrTqJIzpwQa9gmDtEudB5r27HemOOr5wCrUyU
	 iY7eDXIB9wz9wLPCXrSxpLSuD+WlAI9yRv1EhcoBo8qsQIBVISLufI3JpwdTq1CuVlT7I
	 SEY2mEMirz8piAlHh9E6wlpl3dHaUkymXFTGb4DIg02dnZW+pApErh+gcJvDBgT1kRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793964993;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=JQ1f9Uvnwt1IC48c9Xy267I5XKiB5GMgSCCvFoXOTKM=;
	b=vBz1n0DufQnfc4LdWZglh1ZZ5j79ZJQk74PrLeHsZ+3pWPOylLyW/n5of09fUQh3456F
	 BVKm0LShqLYyg5KAfZZa8mu5suRbttrLQ/O+H7Lw5k52aoIMJeG5E+aJ7Dy1B35GDHLm6
	 Sbn3Fp/djPxCcgNDd3sHfrySwyhGKVQu8ghPEDWT5JvYKiUOKMe1/5Mue9TqnG/8l+cOT
	 KHJWn+38TkucEoBmZvLL8YT7Wyq7gmU3EbVRnbcQzsOuj7kHatcBJPtPDWyHdmmt57iiL
	 0ouvKmezhQ1wr4eyYzr1RWDZZxv448UYuU5RSppQQkHxwL4OeCv3rLoCzMxyT2CYpBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EpPMfHyo;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B31C60A6F4C
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 11:36:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B31C60A6F4C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EpPMfHyo
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a2069b9710so4488285e9.2
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2026 03:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793964991; x=1794569791; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JQ1f9Uvnwt1IC48c9Xy267I5XKiB5GMgSCCvFoXOTKM=;
        b=EpPMfHyo2EH9wXl7A7TT0MKKlEOQW7aOwrSlKAnA+dT3eS5T2YIYkekWL3DXbdwB25
         Afy8tEiSeX4IRTymyN4b4aSZmHqJ9xhj/W3sqYtzplvaHFqQzfJkjr/arNdx6g6cUmUw
         b6w/U/PBZSnyIKiO9EV/agSQNCXVH7XC2rEmuWOWjVcCTYwVZsRl2an713Zh+ZN7TJls
         ONbM1lfPVg1CmBQGOZZ4cKjmiJs6jq44QuajXC/kFuuKuyUz18i5mpyDIqga2ElkKvCS
         iu5zh2wUZFlZgAzzTxfR6ZsCKpBVjNVV3pIZz6ZRNu9oUXbWdZZgF1XhxJUoIKcoCsfl
         yW7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793964991; x=1794569791;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JQ1f9Uvnwt1IC48c9Xy267I5XKiB5GMgSCCvFoXOTKM=;
        b=oFL/Ov95qckKJtV+5VM6supVqDvACv2kyB5Odu0tOa2PLtWiUowgH1KW0vs89qyvG5
         x+vbR8SB98a0p9VNa+K933HIRPZ6JjA5vXvY0FjqTEEIBcve3ck6PZl/udMaamyl6kQD
         gicRroIkpux8FUglHA4n0662aQalpMVJ1kMd1Zkss5n035j2x84unXSDiHrup20Hy+YQ
         kv32Ev0KvKXpI3cNPw8l4/gfbxN7Mb+jl0gE2ASeOfPdhwZGHy3mFF8TMlqvgGPVB5So
         CN3zkKkkK4/1ThQYIbDRl+OJy9r303LL4a8Qugr7CL6Kt/fibZH7Dh4r82aYT484DyF7
         Dzqw==
X-Forwarded-Encrypted: i=1; AKwUvBxDSTu1G7yRCwjvvtpOwq83ytdvEBFE8vLbcJdblMRIYtEjxKHpQ5cFgS+e680AUyB6ADVH3a9nu2wyrSU/gg==@vger.kernel.org
X-Gm-Message-State: APuU4Z++Uf1tlgp1MMRMEJofvEU2u4HN85+RXTaTdQXow5slb8RVZgAu
	X6lRhDO7EtrRKORiq9IA5qbIrcCXCmgTysDu1YEWdaArSYnfDs+zcyqEwAcfLSFV
X-Gm-Gg: AYBFou2IteZbl8JMqZAnlcpkm/Isynp6cq6xKxeLpX4SePPWbLZG1NIA5QMsqkx5zdY
	wVtJU/GhFGyLQur6vycIaQI7oOTGX6IWaaen60SB/4Bn7rTpI/Un8+C3K+foarJJkAYO2rxYXk5
	DBeJwYADQZ5LQ1jndEbc3t6tqOwyqvE3OfpiKgRaZfQRtVUgmTuaSIF92WvepsgV+T5sZxCeTcN
	+ZncIVuJlA8KiYyka2HqDU+8xbATmRzQYM1vY5Xo0LA5SCjL7n9R0cM7h1Ss2nDscFkijaBSgmJ
	Ef6RlhssqUCaYnOHrBFhslQ3cOEB6er5SAI7mF5ywLkXscFzOlAHTS/yk54j6GKANZDZylx96p4
	3V9D6Myxe8JKCCZCmGm9knFsmYn9MYsQXuczndKch0U9h3i1HWE7NYh3IQJ5Pk8wzB5bf8dvvLY
	LeQHqbNDRjD2U0GYuBV040UkyIKxWtqJnPk+vHkyk0dLzMJaxzsjb33EVnX6jTEbwHfLrj4sggB
	7XiPoQYBtV8btnzaW25tTmY3yOuxONKNQIf6VITbwCDE7fvDCXf7SD63csL0CohSYNr1cuY7qIN
	xBbnGJ5ysaUxBpQSMDOUd5hYHm3Myizi4YnV
X-Received: by 2002:a05:600c:3b02:b0:4b6:267a:dd6e with SMTP id 5b1f17b1804b1-4b6ded49a38mr38919785e9.28.1793964991376;
        Fri, 06 Nov 2026 03:36:31 -0800 (PST)
Received: from [192.168.1.50] ([81.196.40.160])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b572caf48bsm146175625e9.11.2026.11.06.03.36.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 03:36:30 -0800 (PST)
Message-ID: <260010f2-ea55-42a6-b7bf-8600d9b006f8@gmail.com>
Date: Fri, 6 Nov 2026 13:36:29 +0200
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
Subject: Re: [PATCH] wifi: rtw88: extend USB TX report timeout to RTL8822BU
To: Barak Pearlmutter <barak@cs.nuim.ie>, linux-wireless@vger.kernel.org
References: <au2zcmgiO7t35EZp@port-kadr.cs.nuim.ie>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <au2zcmgiO7t35EZp@port-kadr.cs.nuim.ie>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 06/11/2026 13:01, Barak Pearlmutter wrote:
> I can confirm the "failed to get tx report from firmware" issue on an
> RTL8822BU USB adapter and provide additional context about its impact.
> 
> Device:
>   RTL88x2bu AC1200 USB WiFi adapter
>   USB ID: 0bda:b812
>   Driver: rtw88_8822bu (in-tree)
>   Firmware: version 30.20.0, H2C version 14
>   Kernel: 7.2.15+deb14-amd64 (Debian 13 / linux-image-amd64)
>   Note: this is a Debian-patched kernel; Debian-specific patches may be
>   relevant, though the rtw88 driver is unlikely to be heavily patched.
> 
> Symptoms observed:
> 
> 1. Slow-fire mode (possibly normal operation): "failed to get tx report
>    from firmware" appears roughly every 5 minutes during extended idle
>    periods.  The link remains associated but throughput degrades.
> 
> 2. Rapid-fire mode (fatal): The message appears multiple times per
>    second.  The interface deauthenticates and does not recover without a
>    USB reset of the device.
> 
> The rapid-fire mode is frequently triggered indirectly by a companion
> Realtek Bluetooth adapter (0bda:a725, RTL8761BU) on the same host
> entering its own failure loop after USB autosuspend (see separate report
> to linux-bluetooth).  When the BT device is in a 2-second USB reset
> storm, the WiFi "failed to get tx report" messages begin within seconds
> and escalate to rapid-fire within ~20 minutes.
> 
> Workarounds currently applied:
>   - USB autosuspend disabled for 0bda:b812:
>       ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda",
>         ATTRS{idProduct}=="b812", ATTR{power/autosuspend}="-1"
>   - WiFi PSM disabled on interface up:
>       ACTION=="add", SUBSYSTEM=="net", ATTRS{idVendor}=="0bda",
>         ATTRS{idProduct}=="b812", RUN+="/usr/sbin/iw dev %k set power_save off"
> 
> These reduce but do not eliminate the slow-fire messages.  Extending the
> TX report timeout as proposed in the referenced patch would address the
> root cause.
> 

That's doubtful. It would just hide or delay the messages. I think what
you are experiencing is caused by this chip's USB 3 problem:

https://lore.kernel.org/linux-wireless/b69f6496-dc12-4662-84ac-aa62d0ceac3f@gmail.com/

It will work better in a USB 2 port.

> Relevant log excerpt (slow-fire, link still up):
> 
>   kernel: rtw88_8822bu 4-5:1.0: failed to get tx report from firmware
>   [~5 minutes pass]
>   kernel: rtw88_8822bu 4-5:1.0: failed to get tx report from firmware
>   [repeat]
> 
> Relevant log excerpt (rapid-fire leading to deauth):
> 
>   kernel: rtw88_8822bu 4-5:1.0: failed to get tx report from firmware
>   kernel: rtw88_8822bu 4-5:1.0: failed to get tx report from firmware
>   kernel: rtw88_8822bu 4-5:1.0: failed to get tx report from firmware
>   kernel: rtw88_8822bu 4-5:1.0: failed to get tx report from firmware
>   kernel: wlx1cbfceb2abdb: deauthenticating from cc:2d:21:70:11:fd by local choice (Reason: 3=DEAUTH_LEAVING)
>   kernel: usb 4-5: reset SuperSpeed USB device number 3 using xhci_hcd
>   kernel: rtw88_8822bu 4-5:1.0: Firmware version 30.20.0, H2C version 14
>   [reconnects after USB reset]
> 
> Happy to test a patched kernel or provide further information.
> 

An equivalent patch made it into kernel 7.4, so you can test that if
you want.

> Barak Pearlmutter <barak@cs.nuim.ie>

