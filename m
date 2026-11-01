Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793561247;
	b=unov0NZaO+lqz5zPy6uspKxxFpI4nxQCoBHtRuy5YNsKz5fTj+hbIOhvLvedFZfd1Vzf
	 bLsWwMRmghxypIbNiTT3Q8XK9jBwZtyTQAl42CBvab9XBP42ii2velBvZQ3vXjOO2/9F0
	 6FN7SfjUSDLHnUXQU1S50GELZfdsvbdhN1A4ck2Kdhf0goo7BzbaOXqg5VWSACpZq2QkM
	 ZrysxUc/hv7C3lnLY9ggfazFOm9q5Zu6Zq8LXgSdZBn2F9HG0S6qtzqmqnI+rPwgawJnA
	 xXZjo8HOwOz4Nj3jRZFXzkSZ1nNZWdg2qfXRZs2flInF2ONJ75Y07lLNPmroofKkUkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793561247;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-DetectorID-Processed;
	bh=FBzaqWRuYJDOcynWW1oUqzv1XeYY64zxgMqREXlXnBE=;
	b=jK8EhtrkHtuZSlo2l5iC+NhHPJKyCx2QOh92PscfpyTXsYyTNLBBgEk/RP+G/G4zQyuA
	 zqZws0UPddsVRvz+okq91aPoR/yJgLBQDsxK2MBXwWkJKfLsC4Xe+y6KwT74djYPKWwfx
	 XktT/EK9Mqu7HCp78MX6wesRBPSh4QmMd9D8Bz5cTCu1I9Sgv2VTRNeqVHwSzNilcbAJ8
	 7pbgTMtpvHXReilynxtUJKQ/8xnbHDWXbTTcvy7RamqsBHlmgBANKALHLLOe9IUCkuYO/
	 t9O9brYgqSRXs3Lt4LI2hV2BIGPlc35kPTNt4A3c/60Sp+p7W/nWBfU3cUfYz/iUdOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=DhrvIh21;
	arc=none smtp.remote-ip=209.85.215.226
Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44214606A324
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 19:27:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44214606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=DhrvIh21
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cc7d154ec4fso989173a12.0
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 11:27:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793561246; x=1794166046;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=FBzaqWRuYJDOcynWW1oUqzv1XeYY64zxgMqREXlXnBE=;
        b=P+Za0KTwhV3WPta17UMDrwnLt9fJRGFcSaMXK+ZawN5/p4S6HUA0QrWNiGnIlKej1h
         NgHzLTyuuD/3CyKqy2aqy/l3+toR9ttktGarAPPlh8fp8RXsH7ChTWNh+nVG7A86+RPr
         rZBWKeodOZg8yzpXjYpTaTr3jVvccxJS9SAp9hDeoVS14lAj2ovwN+2pp/H5P9GvPCn4
         LUKtPIjK3hJ78q4Ka1/pD4MV5QXE3DfwJkMJ+6YSNQjv382p7m2zZbfVSaEmZ1BVQO9R
         bPNydk2eB6PNAdc/NowMoStc92MQg0IVsuN7VUxT36YZTe6MhKBYUpBkLO8+PAL6/eLM
         VScg==
X-Gm-Message-State: APuU4Z+n8d1rrJS7uJ72OFt5K9wK4BgK9ee9ee8dPCBkDRk+5vDbuOyq
	Th3dcZhs30IMhIiM7c93ySgVLc/gPMFXiWJwI2pKhVbrnVcCMO/mD7Vt5XcB3sklRVurYBbRs14
	H5Y3hXA0bYlWOYH6FdXz55ap+2WGvzpBOWkJbOPI42np+o2YmN4TtpyLq3ibgM/vP5asfwX9aa2
	2fKdcpZSLKAlBdg7HyK6TQEu4dyANQc3IgtM/U7nE/yE+P93HazQ6OT0hOfsXjTJr6JShKWmJD0
	+v5Ie0Ahj5Dz5Xjw25yMwxrXRec
X-Gm-Gg: AYBFou24JSAztK9LLX7wmSDmliYQ5LZ7lzsSMoqfBf50rnOZ3vrk7Z97FGXXWDBjGhc
	0/vh3ri6qs99z9NHk0s2/W2FPXV2cEqo3YSgjGKv0RkCsAG9vBCOHJ1K3KkT0CMgqePb9OOmmxr
	nieD/nlnt/0IKWO2Ve5fKg46+d9ucb6LfNeYDd12LGJdtobAQKM22nmdzJvl/vBUYN47Hr+GpZ1
	NSvA56ffKUQN9pJIGN0hPkFnfo7Mbf9ckZ7YP4c6vDy7BVevVsoPNHnvGVoy6tpgyhZEWNyqQX1
	vzgjd8cN3TnKZknBTuX3kLvCFtG28txfKha8hvX4TKdXYPSpgaz351Leiunq/u5CH3GOa2ELWGr
	6Z3clQNbIAGdN60F4DLsC87Uv7ML+jvSBeSaGwQInaUKip6hcRcNDg+qU+tkAa4XEb6v0bTQ9Hi
	FDY7chXloejvaKtT5eiP9EjQUyhEqsXu31ALTtrHE=
X-Received: by 2002:a17:90b:48d0:b0:3ac:80de:44e8 with SMTP id 98e67ed59e1d1-3ae8983c697mr6298013a91.43.1793561246201;
        Sun, 01 Nov 2026 11:27:26 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3ae8444ce5esm6536701a91.2.2026.11.01.11.27.25
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Nov 2026 11:27:26 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c4322d31021so114726066b.3
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 11:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793561244; x=1794166044; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FBzaqWRuYJDOcynWW1oUqzv1XeYY64zxgMqREXlXnBE=;
        b=DhrvIh21w1XzU5LgWa9mrFLSjCH/FjS5+8gKwe4Xa4Diyaen3FJnosCbGfUO+p07SW
         ijy1U2WlmTouxOa58w/1JLPLZaQi6XCay+WFJIpK3ADbMZZHVTP7o/aFW322QNLLsCut
         PzU4LFIRWv4FO1Qsoa4/m6FSNeRi8OeOtvc/c=
X-Received: by 2002:a17:907:86a4:b0:c46:9d7b:37d with SMTP id a640c23a62f3a-c4ca7a4b544mr641619366b.17.1793561244349;
        Sun, 01 Nov 2026 11:27:24 -0800 (PST)
X-Received: by 2002:a17:907:86a4:b0:c46:9d7b:37d with SMTP id a640c23a62f3a-c4ca7a4b544mr641618066b.17.1793561243910;
        Sun, 01 Nov 2026 11:27:23 -0800 (PST)
Received: from [192.168.178.26] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4cabc1920csm303460866b.5.2026.11.01.11.27.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2026 11:27:22 -0800 (PST)
Message-ID: <d78cbbd2-601a-4cf1-800f-3be57a2b7de2@broadcom.com>
Date: Sun, 1 Nov 2026 20:27:22 +0100
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
Subject: Re: [PATCH 00/13] wifi: brcmfmac: Add BCM4388 support
To: michael.reeves077@gmail.com, Pieter-Paul Giesberts
 <pieterpg@broadcom.com>, "Franky Lin (Zhenhui)" <frankyl@broadcom.com>,
 Mathy Vanhoef <vanhoefm@gmail.com>, Kalle Valo <kvalo@kernel.org>,
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, asahi@lists.linux.dev,
 Hector Martin <marcan@marcan.st>, Daniel Berlin <dberlin@dberlin.org>,
 Janne Grunau <j@jannau.net>, linux-kernel@vger.kernel.org,
 Hante Meuleman <meuleman@broadcom.com>, linux-hardening@vger.kernel.org,
 Peter Robinson <pbrobinson@gmail.com>,
 Izabela Bakollari <ibakolla@redhat.com>
References: <20260925-brcm4388-submit-v1-0-b5cbc2cde2fb@gmail.com>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20260925-brcm4388-submit-v1-0-b5cbc2cde2fb@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

+ Peter, Izabela

On 25/09/2026 15:43, Michael Reeves via B4 Relay wrote:
> The Broadcom BCM4388 chipset requires new PCIe initialization and
> firmware interfaces. Add support for these interfaces to brcmfmac to
> enable basic station operation.
> 
> This series adds:
> - Signed firmware loading and mailbox transport
> - Fixes for chip identification and firmware capability matching
> - Versioned scan and join requests, and extended PMK payloads
> - Updated event mask handling
> 
> These changes include work by Hector Martin and Daniel Berlin from Asahi
> Linux, refactored where needed for upstream inclusion.
> 
> The series provides basic station support only. 6 GHz support is planned
> for a follow-up patchset after this lands. The driver retains legacy
> interfaces for older firmware.
> 
> Tested on an Apple M3 MacBook Air (J613):
> - Device boot and network scanning
> - 5 GHz WPA2-PSK association and DHCP
> - Bidirectional TCP traffic

Finally got some time to get this series tested on my setup. The patches 
generally look good. So far no regressions observed. It would be good if 
some more people could test this series on their equipment. I will do 
some more testing and wait some days.

Regards,
Arend
