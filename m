Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793663843;
	b=PthrGU+d7dHtKKOyGQXXeqSsI9pLeUHF7uY+DW6e3zXRnn+enwSyOV+3SA4/PJwhdR+m
	 Vjr6yqXcyEXmIE7uAoSHE6IQwv1SA9SgaZUYyUyV/eJi0CGZLRik1iNcjRtrGj8pLXCtE
	 /rjuMZWHdJmKfmAbhmthnAHp1T17kanbw4ULHD7mGwMJPOh9XcI6diLBJnfzuUdYr3j0B
	 3mh920LzoCYkMNWOnJZlJ1vK36sM4x5+NpSgV6pRsM9M97U+puf6+nE0wzqcNYXL3RIjv
	 As0Ht/7Y9Xxo4cMuJIlUg1RyNt7PDfl7+5iFAvmp7QraOFA70XHhHomeoItJrLilRBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793663843;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=XnlljRANTEs2Cr5cmk+F0MuHRIDHA5pmAW+CqIR41gU=;
	b=Xyk0i7Fo/5y7/il0Dq4DrY47AD1ODUDvr2AMPcWCHgmSXbTvfJ+k4XpuohoIZBxgLv/T
	 qLktBhydbt0Q5WPkLXUgL+tx3KOUmuYhOZMW4zhN1SAwmD4fCZmL7Uv36aOBDJ53zeZLk
	 teCzSFP8XHXdkn8cDouxkovISoVp5fv1xK7LFXIaICJrImqAs06gKQw73uplzg0p5htPX
	 o732y3hf6Ncc8Oo32ua8I+DuhMIwAMl5Rid770rBgIO3WaaTAX5f1ppeiCrfcdbzJM44A
	 j9RTl0db73Mg6KBRoW/B1x1sTKYcqho5/HibMzCz0TVLH9MQ50hV9/C3ELMqtYAypLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EDIHrHD8;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08074606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 23:57:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08074606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EDIHrHD8
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a2d6cf958bso16259855e9.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 15:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793663841; x=1794268641; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XnlljRANTEs2Cr5cmk+F0MuHRIDHA5pmAW+CqIR41gU=;
        b=EDIHrHD8r5P+JqlTOzAgbb+pOq+tVkbZ8TaiTCmYPsH5ecdgDRBm1/U7gHKriH/vup
         8cBSqjCVHM9exodNkkx0TtiIoh4t2e8H3ZszlzL3ipBCBcZ+Jyz+S8Ls8lQeAeDxPL8W
         3zVVs57H5Q0gZKuhMDc9kWvuWSfkNK5w+B7vFAv62xKrSaY2/FREC3putKdmleB56MhM
         jF1HooL6TjG3dNBfbHII69GClpdjn9nj9DvLkackjTKkuY3lheK3bnoKHZ3FwFfKBs+P
         1Bwh5T4RxzLjxCopBoa9vVe+DhlTouxKOKYy9heP68e15WpZVMuA63tW1yDW9diU30nZ
         SSug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793663841; x=1794268641;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XnlljRANTEs2Cr5cmk+F0MuHRIDHA5pmAW+CqIR41gU=;
        b=zqhF8Y80hndDVeDASAiGkYIYB9BtoEy5fjOSvbXcjgvl5hxT+CfZzIzN/uQ6qH67Gx
         Q0QpXqzRpjeo5OTDeSv+usDYs8aKBhhO0mnwJx1Ve0OkfnlpBuv7AeFa2s9LqScBbGMo
         wcQMVa6JVMnOH7jygiUVKecmru/Ea4uX1a8pnR2Mxe12MK6rLSXK71KaUBAlRulAsk+D
         QMXz63YV/HUMdUfXF6uwa1IYVsveWNwDe9G6zmLuqrTr046b//IX1NNhqPFMx5N45R1e
         x69LSS0G338aDwXuNUbYkYZFFs7jNBoUuFVXTw47timLEQbT/Y6cRrWU9v2sFw4ocem2
         SOlw==
X-Forwarded-Encrypted: i=1; AKwUvBylbWqExJsIAAysxeT8+dg+vU4B+aB3SOIyvibi85D7bw6p5qSk0iroAGK958mhHlcAmPtOYfvROydg+AB0Kg==@vger.kernel.org
X-Gm-Message-State: AFq9FYL2wLzawGeTpU8rnqgh+TSpF2+Y9h+4/yjSB2p2IMZM/XwRaLYI
	nhuHeS/ISoFYPkyXtIdYJzTAT+QMKolHfnS6yv2SIz2RjCqZ7LPwgzkt
X-Gm-Gg: AYBFou2u/Csonw8jQLuo+bL8GnR8uJbwJOjlLKoXeUTQKGbCxDWEFpVgKKNHjNEyGPf
	/ixR59bwfZXSBhJvUWOZeFCEoDcxTQ1PkmERZPIipLZthF6zqOQefI28tjxI90/nFKoKsV+P309
	CkupLBe9+b7dl1F0nFOd8sZrcIL2dECZh7EMJflyi0udWk42RS9m2qlzV7LGXmBkYRqVt5sq6+E
	x0L/pHYWqO1qL3SXxVQTpWP6HKVfBLNSnqYkCZuyZ0oF7LQ0jA8+wOuxsnoIEj0X3JaeUyrQgXY
	MBN5kCZEpHGbleIQ19NXh5z+xOqHTSh0NzhpnPs0cuirR+zCmSRqkGMH9PQC1ZbgN4WFfCkg4Xy
	iYHgTbyizADqRL4K/gwG/q7drCPcmNgCUOBlBk8G5oak94V+UByL3mRGb9EX/8yoloBJOgRkUSl
	gYnjpiCO5xYfHYgK5G186NKrC59WaODOp/g8tT0L/Qg3uj/qypgMTBmv4X3cu4/JciNpIJlOISy
	7cJlf2vElb/HlFxCYiTdQCYULj1fqt+CYAHlCKrNRk0pQjeXoEp5IDlEYpNvwHWRylORxXLxbyF
	iaghvotaR7SB7fI6JpO9oLHstOk3uHOBP3xIbZVKvIK186ryrjXs9aTcKfg0wmoAMl0X8EyT/3a
	AHg==
X-Received: by 2002:a05:600c:8b0a:b0:4a2:e0c:2b0a with SMTP id 5b1f17b1804b1-4ac1709a200mr273537485e9.16.1793663841176;
        Mon, 02 Nov 2026 15:57:21 -0800 (PST)
Received: from ?IPV6:2a02:8086:cd5:c900:c69f:4b72:77ee:5fe1? ([2a02:8086:cd5:c900:c69f:4b72:77ee:5fe1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a922c298sm15883245e9.9.2026.11.02.15.57.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 15:57:20 -0800 (PST)
Message-ID: <c45bdcae-63da-4552-9e35-59ec6a71621a@gmail.com>
Date: Mon, 2 Nov 2026 23:57:18 +0000
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
Subject: Re: [PATCH ath-next 1/3] wifi: ath10k: set the PMF peer flag on
 WCN3990
To: "Nagashima, Shunsuke" <shunsuke@nagashi.ma>,
 Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org,
 ath10k@lists.infradead.org, linux-kernel@vger.kernel.org,
 David Heidelberg <david@ixit.cz>, Fabricio Akio <fabricioakio@gmail.com>,
 Aleksei Kharlamov <aleksei.kharlamov@gmx.de>
References: <20261016-ath10k-series-v1-send-v1-0-c847697b3558@nagashi.ma>
 <20261016-ath10k-series-v1-send-v1-1-c847697b3558@nagashi.ma>
 <CAFEp6-2xY_gM=FRUp3R30TZ-NgT=-eYnyz_BPE0vxEenv+202w@mail.gmail.com>
 <CACB3TCKq--tdL6j+uGR_dxGdy-gHxQhY8p0h6xxqi_4Fd3VEOQ@mail.gmail.com>
Content-Language: en-US
From: Conn O'Griofa <connogriofa@gmail.com>
In-Reply-To: <CACB3TCKq--tdL6j+uGR_dxGdy-gHxQhY8p0h6xxqi_4Fd3VEOQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/11/2026 22:51, Nagashima, Shunsuke wrote:

> Aleksei, Conn: a firmware file update only helps devices that load that
> file. If you have time, could you make the same change to the
> firmware-N.bin your device loads, test it, and send it to
> linux-firmware?


I can confirm that the unmodified driver with a patched firmware fixes 
the issue on QCA9377 as well. I appended the mfp-support flag to the 
existing flags for both firmware variants that are relevant to my device:

./ath10k-fwencoder --modify --features=ignore-otp-result,mfp-support 
firmware-5.bin
./ath10k-fwencoder --modify 
--features=wowlan,ignore-otp-result,mfp-support firmware-6.bin

Testing each firmware individually confirms the flag is now present, and 
both firmware versions can now reach 300Mbps.

ath10k_pci 0000:02:00.0: firmware ver WLAN.TF.1.0-00002-QCATFSWPZ-5 api 
5 features ignore-otp,mfpcrc32 18db2397
ath10k_pci 0000:02:00.0: firmware ver WLAN.TF.2.1-00021-QCARMSWP-1 api 6 
features wowlan,ignore-otp,mfpcrc32 02bceae2

I would be happy to submit the modified firmware, but I am skeptical 
that it would be accepted? I'm not sure if I've ever observed 
unofficial/modified wifi firmware to ever have been accepted into 
linux-firmware (which seems completely understandable, given the risks).

Conn

