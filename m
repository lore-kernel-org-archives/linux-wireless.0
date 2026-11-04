Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=84.42.129.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793790984;
	b=Mvjz5H+xTfCRuvyfC2obBEB/XAuFKRD/tipqEYXZOZccwBJ6jIQMLDtX7hHQCUkWSps0
	 j0eAM6G8cO0KBIGfpu2WUNEtcKIwOpFgsSUBvXjDOzbGWE8IF3nFJqW9GA1J9GGWLxOEr
	 VTXPbulY8M5p2p561OajuzHNR8Tn+FncK0UHzZXl/GcqoFevMrK1+rvl20Fq2pTSYgHdu
	 mYvqktIGGq7ixFMhKobpcR8L3Qe1fYr41MDHJIp0qtyqnF4iSrVgoyxcFBiedXf96ggR1
	 mtsNJOYEAtn1050YVRxyKyibYxB/JunzVs2hx1CD3K2addxwFx6f4Kx+MgvSNXQZsGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793790984;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=vWwRvdhui2BuRbjKZxwRjdDIoXbJBDtn2jl2veq8E7Q=;
	b=p2e5P6ZbcqqlfSnPb2K59Ah8wC/4FRKgGrqT8PV4y1ubzQ/HfpD86szuEJSu//3Tj3kf
	 ApQdUL5jAcQf6MPaf0tbTNY48L1k0qjpfjf5MQSHLQBXgPTJ/iQCZjnLeF4e/9oOTdYaQ
	 Ke2Ksg2n6q6Y1JEiIE3s8rkPoFf2LAGiC2by532NRjqpDzKdFEeEzJ6B2DQUmJ1lzPGWI
	 7ymwCd9sahuNuwMJbojuP4t0eJ8q+oEorch5Zd2Y4LNW45xXli3da2PxQ6XHbolGo5JK2
	 LF+v2Hkvj6/GeQOpbYoqIaV1YbK9odhPH2THSSAUSEomJK2Qzld2BlIdVv0pzIUvR4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ixit.cz;
	spf=pass smtp.mailfrom=ixit.cz;
	dkim=pass header.d=ixit.cz header.i=@ixit.cz header.a=rsa-sha256 header.s=dkim header.b=zitckMYB;
	arc=none smtp.remote-ip=84.42.129.46
Received: from ixit.cz (ixit.cz [84.42.129.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3713606A31B;
	Wed,  4 Nov 2026 11:16:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3713606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ixit.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ixit.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ixit.cz header.i=@ixit.cz header.a=rsa-sha256 header.s=dkim header.b=zitckMYB
Received: from [IPV6:2a02:21b4:885b:5e00:44b7:d675:5e82:f620] (unknown [IPv6:2a02:21b4:885b:5e00:44b7:d675:5e82:f620])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ixit.cz (Postfix) with ESMTPSA id 9CFCB53401E5;
	Wed, 04 Nov 2026 12:16:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
	t=1793790975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vWwRvdhui2BuRbjKZxwRjdDIoXbJBDtn2jl2veq8E7Q=;
	b=zitckMYB2YR7JjxOSJr8rmJZd2DIdHaPrr7CPcdOPGghcFNw55QGnHKzvgXxqloaf5/UDw
	tqRxJeGX+i7AX7Pec3gQapHWlZOnALAbgyXm45631GkkLuyEBHgmXHl601z8OqNwm7G7wq
	gJIIZe4XUEj51j2/tGQBeLKzgdBOOCQ=
Message-ID: <39f54b47-e21d-41e9-b7a3-12f121517f8d@ixit.cz>
Date: Wed, 4 Nov 2026 12:16:11 +0100
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
 Fabricio Akio <fabricioakio@gmail.com>,
 Aleksei Kharlamov <aleksei.kharlamov@gmx.de>,
 Conn O'Griofa <connogriofa@gmail.com>,
 phone-devel <phone-devel@vger.kernel.org>
References: <20261016-ath10k-series-v1-send-v1-0-c847697b3558@nagashi.ma>
 <20261016-ath10k-series-v1-send-v1-1-c847697b3558@nagashi.ma>
 <CAFEp6-2xY_gM=FRUp3R30TZ-NgT=-eYnyz_BPE0vxEenv+202w@mail.gmail.com>
 <CACB3TCKq--tdL6j+uGR_dxGdy-gHxQhY8p0h6xxqi_4Fd3VEOQ@mail.gmail.com>
Content-Language: en-US, cs-CZ
From: David Heidelberg <david@ixit.cz>
Autocrypt: addr=david@ixit.cz; keydata=
 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
In-Reply-To: <CACB3TCKq--tdL6j+uGR_dxGdy-gHxQhY8p0h6xxqi_4Fd3VEOQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/11/2026 23:51, Nagashima, Shunsuke wrote:
> Hi Loic,
> 
> On Mon, Nov 2, 2026 at 12:56 PM Loic Poulain wrote:
>> So why not updating firmware-5.bin file instead?
>>
>> There is a tool available here:
>> https://github.com/qca/qca-swiss-army-knife.git
> 
> Thank you for the suggestion and for the pointer to ath10k-fwencoder.
> 
> I had tried that first. On my comma four, a local firmware-5.bin with
> the mfp-support bit set gave the same result as this patch: the
> protected Deauth carried a live PN, and the next association was not
> rejected. It is also the file I used for the overnight PMF runs in the
> notes of patch 3.
> 
> I went for a driver change instead for two reasons:
> 
>   - I was not sure whether it was fine to change a firmware file that
>     Qualcomm provides.
>   - Other devices seemed to have the same problem. No WCN3990
>     firmware-5.bin in linux-firmware sets the bit, including the newest
>     one (shikra), and Aleksei (WCN3988) and Conn (QCA9377) reported the
>     same issue in this thread.
> 
> So I'll drop this patch and send a firmware-5.bin update to
> linux-firmware instead. Patches 2 and 3 do not depend on this one.
> Should the update change the shared WCN3990/hw1.0/firmware-5.bin, or
> add a file for one board?

ath10k-fwencoder --modify --features=wowlan,mgmt-tx-by-ref,non-bmi,mfp-support 
firmware-5.bin

for the OnePlus 6 (oneplus,enchilada) issue "speed not exceeding 10Mbit issue" 
on the WPA3 enabled router for too.

David

> 
> Aleksei, Conn: a firmware file update only helps devices that load that
> file. If you have time, could you make the same change to the
> firmware-N.bin your device loads, test it, and send it to
> linux-firmware?
> 
> I worked through this with Claude (AI). English is hard for me, so AI
> helped write the English. I ran all the device tests myself on my comma
> four.
> 
> Thanks,
> Shunsuke Nagashima <shunsuke@nagashi.ma>

