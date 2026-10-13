Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB3747DD6D;
	Tue, 13 Oct 2026 05:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871053; cv=none; b=JGq+JkH7HrVGLq17YR/QU4Rsz0ZMmLAP/1Gj1x09rOP5wnr83iJFj6VNvAUHvqX5ZHWZto1Ws2RfBIT/QRB8I8g+cBqXdPSA82cVfocWuNDiZcsLMUL/PQa2dVYcqqR9R6Br1oMX/BBSE1ZQiVvCDMgXWSd04Ledm/GGTMZ4cPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871053; c=relaxed/simple;
	bh=KS4enb6STeHV5slBMRaTCm4Oj31v0tzSOzjzy0TQO7Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X84aPX1O1X2BC9idYNEhrlAxxXjil46Fmjm+yn8t1UDBLFTIrCTS6UBBQ1NYRqip30Ytlf5uyrNQpdlj7DY65GtqQAsd8JTXF74J/DuJAjvNZeA6mJ1GgsN09FeyLv8K6ljTFi3HbZc5YrUhQ/iEtahVUT9FLucXZuCGO+okhgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XTqusC3I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XTqusC3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8281F000FF;
	Tue, 13 Oct 2026 05:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871051;
	bh=duWW+J+3q2G2PB4vrDlcQCQsUySglfzAQl26U9d2r8I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XTqusC3IYIZsglHNrukfA/WcC0Ucu+9Iy2XxaM8LgbGyNQ77Kdssa3kywBCO7tb2H
	 3IYqBesQnX6UwuvEmzaIyBAtc1IGfjX/MRK91YEATkmh0p+d+gGl4c/8tAmIVrtJxu
	 bnIhPM65b4MbRGfX5feA4GU4K95qsNoyD9WUsrLBsiEaxDrdtmnCMiFLDMysqFn1rw
	 wKMDCSlMiIrE3kR9+QPg28YdzYedgSvvZTnDunWx6PWrwi/UYvlsH5qJzJjDluKgaQ
	 ecxDoO/68kTeqdMjwWo/MDDJKkMx+6k7Hy0oFLjMOVLG5I5r+itawHJimN923Io+AA
	 v51QRzzTb8QJA==
Message-ID: <1bde2004-734e-42b0-9ba9-f7c085eab69b@kernel.org>
Date: Tue, 13 Oct 2026 07:57:22 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/7] dt-bindings: wireless: ieee80211: Add
 disable-rfkill property
To: =?UTF-8?Q?J=C3=A9r=C3=B4me_de_Bretagne?= <jerome.debretagne@gmail.com>
Cc: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
 Bryan O'Donoghue <bod.linux@nxsw.ie>, Bjorn Andersson
 <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Johannes Berg
 <johannes@sipsolutions.net>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Maximilian Luz <luzmaximilian@gmail.com>, Hans de Goede <hansg@kernel.org>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Jeff Johnson <jjohnson@kernel.org>, linux-arm-msm@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-wireless@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 ath12k@lists.infradead.org, Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
 Dale Whinham <daleyo@gmail.com>
References: <20251220-surface-sp11-for-next-v5-0-16065bef8ef3@gmail.com>
 <M7kfFb5fz-WB43U_xCUwgxpmBJ4TNdp4jE6yFu6HmemIcDx5tXO6H4xnW_pEQz6DMkKm-3POdB9hIdB092zhGQ==@protonmail.internalid>
 <20251220-surface-sp11-for-next-v5-2-16065bef8ef3@gmail.com>
 <e0e9e690-c56e-4b56-90f9-2af46a7feaf3@nxsw.ie>
 <20251220-fervent-mamba-of-sunshine-f680a8@quoll>
 <571681d6-67f3-47fe-9a42-dce5aca13c99@oss.qualcomm.com>
 <6a90eb12-87c7-4942-9f18-6490a91cb0b7@kernel.org>
 <CA+kEDGEBqMh8X=q54EkQNutxTpqutQ11QdkUr7bvJO8_iFy5JA@mail.gmail.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <CA+kEDGEBqMh8X=q54EkQNutxTpqutQ11QdkUr7bvJO8_iFy5JA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 12/10/2026 20:56, Jérôme de Bretagne wrote:
> Le lun. 12 oct. 2026 à 18:53, Krzysztof Kozlowski <krzk@kernel.org> a écrit :
>>
>> On 12/10/2026 18:38, Konrad Dybcio wrote:
>>> On 12/20/25 10:12 AM, Krzysztof Kozlowski wrote:
>>>> On Sat, Dec 20, 2025 at 06:04:00AM +0000, Bryan O'Donoghue wrote:
>>>>> On 20/12/2025 00:21, Jérôme de Bretagne via B4 Relay wrote:
>>>>>> From: Jérôme de Bretagne <jerome.debretagne@gmail.com>
>>>>>>
>>>>>> For some devices, Wi-Fi is entirely hard blocked by default making
>>>>>> the Wi-Fi radio unusable, except if rfkill is disabled as expected
>>>>>> on those models.
>>>
>>> [...]
>>>
>>>>> Is this really a hardware description though ?
>>>>>
>>>>> Its really more of a logical/functional description. It tells the runtime
>>>>> what todo, not what the hardware is.
>>>>>
>>>>> You could also have a list of quirks in ath12k for this or have a user-space
>>>>> utility look for the appropriate platform device string name and disable
>>>>> rfkill.
>>>>>
>>>>> I think this logic belongs in drivers/net/wireless/ath/ath12k/ triggering on
>>>>> a compat string.
>>>>
>>>> This is good point. Either this could be deducible from the compatible
>>>> or this should actually describe the hardware and whatever is there
>>>> wired/configured, not what OS should do.
>>>
>>> Sorry for digging up an old thread. The board-compatible change is now
>>
>> I don't get why exactly the board-compatible option was chosen, except
>> of course finding workaround which did not need digging out the root of
>> the problem. I suggested the compatible of this device or proper
>> hardware description.
> 
> Could someone give an example of what a "proper hardware description"
> would be in this case, to move the needle a bit? It is quite abstract for me.

qcom,wl-disable-pin-grounded
qcom,firmware-needs-hw-reset
qcom,firmware-reset-bug
qcom,mismatched-disable-polarity

etc.


Best regards,
Krzysztof
