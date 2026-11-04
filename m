Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793816154;
	b=LJYq+52jTxRKqolZ+tnBb5loSCR9PbSe6vjo/ClFKRt5+u9BOM4cLYBUvz4NmG9ws22w
	 2S8Rvt+He4vnuiCZwJtJC3UqbctwgR3SYBbXjNkpqnpsu0ZRLDY2m3ObJ0nZk7ak48jRJ
	 2rzD/eqC1Ri2wE/4MfDZGUM3i6mtf8mUSTJQyNHDtk68DzDWIChT0dsMzQ2DuP9H6CIzp
	 RjozVN6rw3i7LUMilO96vCGjn9PF0/0e5J5gLgB0coRJ07Cy4De/kB9bKVjh/8Agj4qit
	 rWKuykbIxprGfqFa8C/VrPQzgwFtCubFrqxsrCMYfcM5X8890oiQxwyRHH/xOUR2gTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793816154;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-DetectorID-Processed;
	bh=F2zJEatOU4CyFqJt2nHtTite5aLEewM7QlV0X2jkmG4=;
	b=onUHR8RZA7wsNChaXZLiyZWCM6buTmtxTicpv535SC3RX/TXsy+QVEz2IRx3yRSYxT/b
	 eONAPDOO28SW2xmvT3B8TdILuZkzdLznXutggpZvo0hYO17Tdy6f7MxxszYZJZbnd91oZ
	 tX6AfQiLqPohb0JhM/QlIV8d0NEHXhLvO7vfAWs+jCbxI7tDUyHiojhfIBrFZvRTY0F8w
	 NZ7GSDczmSvcaeXlqYnOxkdiJfizfqm82BMY+NQi3NDkld2M42ZL3d57+73d6URajqldo
	 DK4kuIqGObQ+aUAh7QKKjnJUh7VwlUX2T3lNZ5M82mk7dRampaO2SlTbNKrlZBxH9dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=b6es6Dct;
	arc=none smtp.remote-ip=209.85.222.227
Received: from mail-qk1-f227.google.com (mail-qk1-f227.google.com [209.85.222.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A8B606A335
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 18:15:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21A8B606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=b6es6Dct
Received: by mail-qk1-f227.google.com with SMTP id af79cd13be357-93a40a9a01aso260008485a.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 10:15:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793816153; x=1794420953;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=F2zJEatOU4CyFqJt2nHtTite5aLEewM7QlV0X2jkmG4=;
        b=Y98RV1m4N9a/Ukdb8wusA9H+h+KDsz8fl3b4tTkdaD/ftosiXtA8qrF4C1nWR8UPCU
         +8vpRitBP9OZVVAdZuFPE63vA7NQzbgGXGegv/arQoug0GvMcRtNkvrprwgapSzwP9R2
         bpKEYWR6e85vjsRMuXJPA6lO9MIKjCVYvMZlwUBDBRPkBU9fxwpFL1EE3x8CQ4xohh3c
         nyDMreD1l3HYNribucC3Jc5Solz0yDxVx6zldX7NfH6/8xHXR9WrKjo9CKeK9yLJv3DJ
         rMAzS4KjXDUPZl/T16kms8mcplqmRQ2MG0yeSKCPWRbTPn3HSrzyszoP49tqFNqxUrDD
         /9Aw==
X-Gm-Message-State: APuU4Z+B/Oiz+M4SbJxImoWPhOdCYclbRvLietpHx03uTRTbG8MF4YnV
	AJrs6BHka7wpvcZhIJPQXCmXguZq0KrGn18x6f4G6GYxaQKfwzwDHSh+crnV98eIsDX7Pha4Itr
	kzpNeKSIpUp4B4SmDb1iOUZIfFQqu1qbtXrrycHTYBX7YDecY3g7Jsi0gTFEhtAXcUfZZAM2rxK
	jWWUZbVDzH/Vr8SL+7l2ZNXN7q+e+hneFF2Wn0qNmkB3xeJB4ava1yJarnonu426riQ+m/F+9Gl
	RevyShwoomiw8y3U4CUQXgtcxc5BQ==
X-Gm-Gg: AYBFou0faHCVssQ2WWpg/7+LTN43qmJbri4xN7UXf7VRYK821PyDaFDucb5oF5nSExr
	sEZK2b/gH1DBQVcyP8PCByJJIIUIVeLA5FFDyfU4yiMdVvrvQbj9mNSZMvbr+L4mn/uR68KOTuf
	7vZX6QTJITnkmt5tZ2dHtUAfav23DkjdlscqbIc6SrCIXGaUxIbaP+txL3FZa+ojEGFYl2vDzZw
	SuXrfapwNrie0M0yEIqWZS2L3yi9zOP0N67iGBcGKTJuZFor4iqgOtiKsB/8QPc94cGNSlhiHgJ
	/0/lYKE/ZOPr/WtmPqrirETvq4rBDsLkxTL9n2KR/TiGK/1aBkqg7KhhROSdGwWb4Qi1VuahFDo
	hfKjomE3chdtgR6uUO4gFaR7jByYKnTTMrCB/bTmW5lHSU6tgqsVH8IdOPCZa9A/Qx3OX2pqvu7
	pHcQFVz8Qkt4CjtErm3A69jcNe+1fDDozt31yrvZl9
X-Received: by 2002:a05:620a:1722:b0:93f:3193:ac09 with SMTP id af79cd13be357-945e16aa58fmr52036885a.15.1793816152572;
        Wed, 04 Nov 2026 10:15:52 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-91e8bfeb0d7sm266906d6.20.2026.11.04.10.15.52
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 10:15:52 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1ab289bb41eso848884c88.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 10:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793816151; x=1794420951; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F2zJEatOU4CyFqJt2nHtTite5aLEewM7QlV0X2jkmG4=;
        b=b6es6DcteX6vNruteUBK4GM7TNgToJX0orGzit3jH5HXn/q5o5sIO13XmWyquFl7Bb
         9sszts31QJsXkgswXK7dnSAY6ZA2VvEHO8AfovH7k8pDHhSXCFrKQ+sRe/fbsUwZu/+J
         h5HM9uWvTs+shlzRmPAidUpBM0Z7yalELCp4w=
X-Received: by 2002:a05:7022:b881:b0:145:ac96:3917 with SMTP id a92af1059eb24-1b24f4d380fmr308744c88.21.1793816149701;
        Wed, 04 Nov 2026 10:15:49 -0800 (PST)
X-Received: by 2002:a05:7022:b881:b0:145:ac96:3917 with SMTP id a92af1059eb24-1b24f4d380fmr308704c88.21.1793816148953;
        Wed, 04 Nov 2026 10:15:48 -0800 (PST)
Received: from [10.14.197.69] ([192.19.161.248])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c30521sm10038316c88.13.2026.11.04.10.15.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 10:15:48 -0800 (PST)
Message-ID: <1113b8a2-70ce-40ea-b8bf-9a40c8116dcc@broadcom.com>
Date: Wed, 4 Nov 2026 10:15:46 -0800
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
Subject: Re: [PATCH v3 3/5] bcma: scan: accept wrapper-less cores on
 wrapper-less backplanes
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
 <20261104-bcm6362-wlan-v3-3-e46562b2ac12@mythread.it>
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
In-Reply-To: <20261104-bcm6362-wlan-v3-3-e46562b2ac12@mythread.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e



On 11/3/2026 3:30 PM, Alessio Ferri wrote:
> The scan drops every component that publishes no master or slave
> wrapper in the EROM (NMW = NSW = 0), apart from a few known cores,
> because without a wrapper bcma has no agent registers to gate and
> crash. Since usually bcma is loaded early, it ends as a loop-crash.
> 
> Some backplanes, such as the integrated WLAN of the BCM6362, have
> no wrappers on any core. ChipCommon and the 802.11 core are gated
> through a SoC-level register block owned by the host driver, whose
> aread32/awrite32 ops emulate the agent registers, and core 0x837
> needs no gating.
> 
> Add a wrapperless flag to struct bcma_bus, set by the host driver
> before bcma_init_bus(), and accept these cores without wrappers when
> it is set. Other hosts keep rejecting them.
> 
> Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

