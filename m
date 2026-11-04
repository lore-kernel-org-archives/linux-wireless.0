Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793816230;
	b=RFqeldP9l6cUJADThMFoDWbiLjc3MVpxse9/0h375o4wxtU4gF17kEHYl+E18pPHA73n
	 9t9B80xLc+i9UfkiPrmypxahLIVLLoIGmZ+4P8qGfZXq5b8LRGA/sgpXOt6mG0G4K2+Ta
	 ntXYprl4uZMFR4mq9Vu5vPUcB//BCJCXuIn8Fi31HGh4cuEC3XuKymPTcg5FMOyrjgFnA
	 fJT4TAwbn6/97Yh3ciFcZKzLuhcRBSxZzGOGYt3u7NNgzDnJp4OpbL1K0+x/PJTknEqz9
	 yYuNjmzGV3YU7wsmJ0n0L0jZgWqcSQk4diGk4tLIiKeGY/NCMcj+OOipxiWBfVS9aag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793816230;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-DetectorID-Processed;
	bh=bLtDbnN1VHE+ADoqLmLIlJzENxx+1wvCpI3fUOziHnM=;
	b=fFrIK5aWof41pE3uXs6HNOCGldpp0argeY8kQtOAjgZsO57z2XWtHoNSB/mkOKL7aj94
	 2r6lCuL0MNNCJaG7y8Iv4RumM19z/dxU/9RjwTF4s5MtuYABIzneE1byXSWeYpyIa7eRp
	 hBRA11z4pyChFLWZKIUrFon/sGIeDybfzD4+g64jI3oGdUTt+vjmQSjSISg5I5RvzABou
	 Q/aS8dUiCklJvUB7GNPJg2jNfBYNuOg1g6txyjjjysq55kaMAzv89LHSJ6ra0OlN1KfY7
	 XcG+KFZbvEyRHihqmh0yDdaK+8XYVwneg/+Yxi1JjBQyEz6GvvRrQMJcCZfuHkPEHZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=WEQCDhGV;
	arc=none smtp.remote-ip=209.85.210.227
Received: from mail-pf1-f227.google.com (mail-pf1-f227.google.com [209.85.210.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1091B606EE96
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 18:17:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1091B606EE96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=WEQCDhGV
Received: by mail-pf1-f227.google.com with SMTP id d2e1a72fcca58-8a06e79e152so647209b3a.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 10:17:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793816229; x=1794421029;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=bLtDbnN1VHE+ADoqLmLIlJzENxx+1wvCpI3fUOziHnM=;
        b=HMmhqbKp35NiGIL2ZXkQwp78HcavLGBzpnXaFa/hW2B7V6J8tqpZXl8uJA8OgSDO+Y
         HfSc7DKHRH8JsJRKxT3qPKRbT/zaQ/5g1CVAKWXhDLbHCW9VZbuOq2h1MngOdf1BOjQG
         EzOpCiHczJwqZv8eySSmXAvjvfpVouzsI3gtO9nzK1RCAzv8uscs6CqyHyVZLq0l6g70
         gljwk9C6EIzXUh1AWnjvtDmMI3GwVVVfrQsD2Ri5YZ1LDYA+KCVKNKoKEcWPFx+DYj8K
         ucLza4l1q35S54rSWwN7vPiC3OoUDIpJj8ntxCU1Bv7cNk5+cmEFFKa4+tnOU6BBDLJy
         IGlg==
X-Gm-Message-State: APuU4Z9Zfy5ky/dmt4d27rLsKaxrkX5wQRzDVgEPN+uAFY8qLDsQKtOy
	FHnaTWOSQi8ADRX8G+jWw7poOBWSoD9W6E3tzJk+ckscWQ+7DfU4Ov5wOuFiF4R48+T/Sbni5Ye
	XgjGbMShHE+rey0tm3ssryWAOkty4o+PgBPFnfQ0xKVBvSBZ7HemBrvia4nyFA9vsvTtR8QD8DM
	PwjOR6uErdXbvzYRmZF/lJZvKqUUd/DNhGvEQGyowmIGPVE+q+u3DQMWlcyQ85qXX7HlGcnmhC5
	LRcGfqzU0EUPF5pSNWCk18nwfsEfw==
X-Gm-Gg: AYBFou25OksJO0TFZ43Ilk5tB2EXp+YjADAoYB5jqYEzKeuOwz145zWhYMXqEVeBAfM
	ItgsCeW7LO0e2GB7cED08UOjQnMjAbwUJ2glGm8lsbYtSvevyrOwJre3tiuy3CB7ARj3GmIIQ3V
	BTlDaJNlFuUTco+9hfDAFNPeo/Qdd7DEkSftXDbZVdRxTKDVetUk4fBCNYuIemKIjfrCgp2v2Ji
	XvK2MP8YsHMbcq43wu96p3BnNSrq2qZKPx9rc+cwAVUt6tQWLU6RRBEg0HKeJUHgL7EjvXkHk40
	7jvOXMvHE5TBQawaIrsG4pbYBeKPFrBcBX5g9ob5YvsmGXHM291THwc/XD/K4NSyBL3e22EdgF7
	yJaLVZs+/1xyN1yWQWfniF2LTKS1ckwLTbxurDNv8yLW3PybNoUJU4CZgk4Jt+AqyK5be7SJlhC
	n+9GCVxlljxgkcWbt42FJ1FHmZKw4PN4hdA7DZgX99
X-Received: by 2002:a05:6a00:3911:b0:8a0:7ba9:93c9 with SMTP id d2e1a72fcca58-8a9be48c7camr12347983b3a.15.1793816229248;
        Wed, 04 Nov 2026 10:17:09 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-8b09013306esm49471b3a.11.2026.11.04.10.17.08
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 10:17:09 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-91c7a26f892so22606976d6.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 10:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793816228; x=1794421028; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bLtDbnN1VHE+ADoqLmLIlJzENxx+1wvCpI3fUOziHnM=;
        b=WEQCDhGVvSoBtjRM6IdqTYEvWUnggaaucvd2bkr1OLH55TZPHuzixwdtG7Y+YmHqmG
         zqWHRfz1SZP4+KbM03KO0MhWygd9MFtJnYFoO7fa3Qey/04PuipxWmRCqtZCApgbom7l
         oro9tFssPspfpfuCATiwLIO8AAKWzX3ih9jQ8=
X-Received: by 2002:a05:6214:611c:b0:91e:747c:f833 with SMTP id 6a1803df08f44-91e747cfbe9mr64275386d6.46.1793816227716;
        Wed, 04 Nov 2026 10:17:07 -0800 (PST)
X-Received: by 2002:a05:6214:611c:b0:91e:747c:f833 with SMTP id 6a1803df08f44-91e747cfbe9mr64270826d6.46.1793816222510;
        Wed, 04 Nov 2026 10:17:02 -0800 (PST)
Received: from [10.14.197.69] ([192.19.161.248])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91e7e7146a1sm25250956d6.33.2026.11.04.10.16.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 10:17:01 -0800 (PST)
Message-ID: <ab9893c9-a874-4b27-b152-02fdef49ab33@broadcom.com>
Date: Wed, 4 Nov 2026 10:16:56 -0800
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
Subject: Re: [PATCH v3 4/5] bcma: add host driver for the BCM6362 integrated
 WLAN backplane
To: Alessio Ferri <alessio.ferri@mythread.it>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
 Philipp Zabel <p.zabel@pengutronix.de>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Jonas Gorski <jonas.gorski@gmail.com>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org
References: <20261104-bcm6362-wlan-v3-0-e46562b2ac12@mythread.it>
 <20261104-bcm6362-wlan-v3-4-e46562b2ac12@mythread.it>
Content-Language: en-US
From: Florian Fainelli <florian.fainelli@broadcom.com>
Autocrypt: addr=florian.fainelli@broadcom.com; keydata=
 xsBNBFPAG8ABCAC3EO02urEwipgbUNJ1r6oI2Vr/+uE389lSEShN2PmL3MVnzhViSAtrYxeT
 M0Txqn1tOWoIc4QUl6Ggqf5KP6FoRkCrgMMTnUAINsINYXK+3OLe7HjP10h2jDRX4Ajs4Ghs
 JrZOBru6rH0YrgAhr6O5gG7NE1jhly+EsOa2MpwOiXO4DE/YKZGuVe6Bh87WqmILs9KvnNrQ
 PcycQnYKTVpqE95d4M824M5cuRB6D1GrYovCsjA9uxo22kPdOoQRAu5gBBn3AdtALFyQj9DQ
 KQuc39/i/Kt6XLZ/RsBc6qLs+p+JnEuPJngTSfWvzGjpx0nkwCMi4yBb+xk7Hki4kEslABEB
 AAHNMEZsb3JpYW4gRmFpbmVsbGkgPGZsb3JpYW4uZmFpbmVsbGlAYnJvYWRjb20uY29tPsLB
 IQQQAQgAywUCZWl41AUJI+Jo+hcKAAG/SMv+fS3xUQWa0NryPuoRGjsA3SAUAAAAAAAWAAFr
 ZXktdXNhZ2UtbWFza0BwZ3AuY29tjDAUgAAAAAAgAAdwcmVmZXJyZWQtZW1haWwtZW5jb2Rp
 bmdAcGdwLmNvbXBncG1pbWUICwkIBwMCAQoFF4AAAAAZGGxkYXA6Ly9rZXlzLmJyb2FkY29t
 Lm5ldAUbAwAAAAMWAgEFHgEAAAAEFQgJChYhBNXZKpfnkVze1+R8aIExtcQpvGagAAoJEIEx
 tcQpvGagWPEH/2l0DNr9QkTwJUxOoP9wgHfmVhqc0ZlDsBFv91I3BbhGKI5UATbipKNqG13Z
 TsBrJHcrnCqnTRS+8n9/myOF0ng2A4YT0EJnayzHugXm+hrkO5O9UEPJ8a+0553VqyoFhHqA
 zjxj8fUu1px5cbb4R9G4UAySqyeLLeqnYLCKb4+GklGSBGsLMYvLmIDNYlkhMdnnzsSUAS61
 WJYW6jjnzMwuKJ0ZHv7xZvSHyhIsFRiYiEs44kiYjbUUMcXor/uLEuTIazGrE3MahuGdjpT2
 IOjoMiTsbMc0yfhHp6G/2E769oDXMVxCCbMVpA+LUtVIQEA+8Zr6mX0Yk4nDS7OiBlvOwE0E
 U8AbwQEIAKxr71oqe+0+MYCc7WafWEcpQHFUwvYLcdBoOnmJPxDwDRpvU5LhqSPvk/yJdh9k
 4xUDQu3rm1qIW2I9Puk5n/Jz/lZsqGw8T13DKyu8eMcvaA/irm9lX9El27DPHy/0qsxmxVmU
 pu9y9S+BmaMb2CM9IuyxMWEl9ruWFS2jAWh/R8CrdnL6+zLk60R7XGzmSJqF09vYNlJ6Bdbs
 MWDXkYWWP5Ub1ZJGNJQ4qT7g8IN0qXxzLQsmz6tbgLMEHYBGx80bBF8AkdThd6SLhreCN7Uh
 IR/5NXGqotAZao2xlDpJLuOMQtoH9WVNuuxQQZHVd8if+yp6yRJ5DAmIUt5CCPcAEQEAAcLB
 gQQYAQIBKwUCU8AbwgUbDAAAAMBdIAQZAQgABgUCU8AbwQAKCRCTYAaomC8PVQ0VCACWk3n+
 obFABEp5Rg6Qvspi9kWXcwCcfZV41OIYWhXMoc57ssjCand5noZi8bKg0bxw4qsg+9cNgZ3P
 N/DFWcNKcAT3Z2/4fTnJqdJS//YcEhlr8uGs+ZWFcqAPbteFCM4dGDRruo69IrHfyyQGx16s
 CcFlrN8vD066RKevFepb/ml7eYEdN5SRALyEdQMKeCSf3mectdoECEqdF/MWpfWIYQ1hEfdm
 C2Kztm+h3Nkt9ZQLqc3wsPJZmbD9T0c9Rphfypgw/SfTf2/CHoYVkKqwUIzI59itl5Lze+R5
 wDByhWHx2Ud2R7SudmT9XK1e0x7W7a5z11Q6vrzuED5nQvkhAAoJEIExtcQpvGagugcIAJd5
 EYe6KM6Y6RvI6TvHp+QgbU5dxvjqSiSvam0Ms3QrLidCtantcGT2Wz/2PlbZqkoJxMQc40rb
 fXa4xQSvJYj0GWpadrDJUvUu3LEsunDCxdWrmbmwGRKqZraV2oG7YEddmDqOe0Xm/NxeSobc
 MIlnaE6V0U8f5zNHB7Y46yJjjYT/Ds1TJo3pvwevDWPvv6rdBeV07D9s43frUS6xYd1uFxHC
 7dZYWJjZmyUf5evr1W1gCgwLXG0PEi9n3qmz1lelQ8lSocmvxBKtMbX/OKhAfuP/iIwnTsww
 95A2SaPiQZA51NywV8OFgsN0ITl2PlZ4Tp9hHERDe6nQCsNI/Us=
In-Reply-To: <20261104-bcm6362-wlan-v3-4-e46562b2ac12@mythread.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e



On 11/3/2026 3:31 PM, Alessio Ferri wrote:
> The BCM6362 integrates a WLAN macro on a dedicated bcma backplane.
> CFE leaves the macro clock gated and in reset, the backplane is
> a big-endian peripheral, and none of the cores has a wrapper:
> gating and reset of ChipCommon and of the 802.11 core go through
> per-core control registers in a separate WLAN control block.
> 
> Add a host driver for it that:
> 
>    - maps the ChipCommon and WLAN control register blocks;
>    - enables the clock, cycles the WLAN and WLAN UBUS resets and runs the
>      macro enable sequence bcma touches the backplane;
>    - provides big-endian register and block I/O ops;
>    - emulates BCMA_IOCTL, BCMA_IOST, BCMA_RESET_CTL and BCMA_RESET_ST
>      on top of the per-core control registers. The PHY bits of
>      BCMA_IOST report what b43 needs to hear;
>    - sets the big_endian and wrapperless bus flags before scanning.
> 
> As for the PCI and generic SoC hosts, the driver is linked into
> bcma.ko and registered from bcma_modinit().
> 
> Add a MAINTAINERS entry for the driver and its binding.
> 
> The 802.11 core (rev 0x16) is handled by b43 once a SPROM is
> available; on this SoC it is not stored on the chip and has to be
> provided. In openwrt i use 6362-sprom plus fixups.
> 
> Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>

Very neat, with Philip's comment addressed:

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

