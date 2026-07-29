Received: from mail-yx1-f97.google.com (mail-yx1-f97.google.com [74.125.224.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634B2481FB1
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 12:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785328141; cv=none; b=hbGborbCgAVTP3TqKdZP54Deh4+UFBAx2tpNUmNWXQRiJF4ehicIQJY8El4B3BenyHB6cgrTmBZXDM1slqry7YLz02Vv7ueFE3/t7FWxnCHBxizo6Z35l/V4auYv7JYc9QSh842Rtar+J8nlDkfV91WEASep+iuLZDjin2c5umc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785328141; c=relaxed/simple;
	bh=01EyYY3pZm/ZKYc7+9auWJ86XD/LO4jAF5sdui32lI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b1en6dVlt4n++xZbuzKeupWzpM1UNbs7fAGmSdD85wyb9HCVJAiSg75uG4rS3XvnDD5lKm3q9VtNPraEIO/N2i1PuMOTqGu4OVrjnWaYMx8+EEspKP2L/nvy1zSVfS2/dsWqMfggP6dXfbGQSWXq4e+WVje6yi+csxl3YsRCsqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=a4lSGCRv; arc=none smtp.client-ip=74.125.224.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="a4lSGCRv"
Received: by mail-yx1-f97.google.com with SMTP id 956f58d0204a3-6688dfaed31so1007440d50.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 05:28:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785328131; x=1785932931;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=80XIbOpgDfahtQfRx2y5PGslIsS8+OtcUMo3OPdSsEc=;
        b=LIUcr1o26kPlMfy965PfkLUr8L5FZC8HGYp8F5lgDoXoKXffXvovapZfdFDHoAgpI+
         NX17BT2ifun1ruPxR+0mMG2dnHCS57wizdOMNJxCv+u22VSR/eWjtaJ5SrHVbeljwl8k
         huUFE5AfyUIvAvXlPS4/Ignr/KY+NeqprGuvX79AwhhBWDW4NfpfJkcy6DglU2X21KUR
         SuJiV52aogQ4u39LC7YI3TIvOhahLe7kbXxFL3aeh5GWjFHL4DiPi9JSn8ik7KIlHVbH
         EF/5CsFFD6aIJClSuE0mYQT3VCrUQStY9OPfDDk0YJUenub2bb+uZ2uj2e4afIHq8EqW
         UAeQ==
X-Gm-Message-State: AOJu0Yx49N15PTGlCtH5iUOv6a1UctsOPIyA9Wfb1CeIcCOwLCdqbweZ
	dARKXfzEs9QYeGv1i4HcQxn392sOuz9DgT5R/fUfuZJ8EdHUn3790XgNnffQKi05gZAzxxKbK8y
	lsu1IxFsbdjcu4qkH1yU1v5VMZ07xronTM/oE1A2QdLgc5jdPVyAzNy2ffv7ltKkmZXVQ/KWBLA
	68Hdg0o4ETDMqtXLqK4uoTobUgFj6aFd2j6x6/nWFvpdif0CsfJNsNr7R1e9nxwulFpWF9I07zR
	lYFdb73UTfhbQnNy16MuX4biiP8
X-Gm-Gg: AR+sD11Fsu59KGxHyivQyMmPo6qYASxgBvH4r6mHcvTxBlUxu4TEGne4CHEqaekQZLt
	a+I9wj+GdH875vFsBUazB9Cb1yzBxLdHGKea7eiqjGJqRFXm22d90A5E9GSQrtwBqn2ybc334wn
	0RLyOzRJaR4jLecRTMveDAie3nPcL4mWl4rQxwXrcmdSGi6PJnc4qsM1JkUvKL2KH4+GYQWe+EZ
	9Mwiy/5IkNYpp08gNEuTnJjMypZzzE62L0lUPSowOunVdZEZIg9RUCp9WKBj33sLSmSS1AyN5aa
	qai0XCre3UV1OBr/iqbF9ek385+B3XgP38VNU/aS60hQs4CramFL0fh+zH/FEDGYvWVplCRARMo
	/NxQ+QczRZc0hOAoe6OuMngwXxluwwvs8VUjmuq7/2yJYk6CF6EXP1aoujH+/boe5im4TNiBrbI
	oDoFQsbpBEaozWSTlFjC47j/hQr5gtY1iXdgRJEBg=
X-Received: by 2002:a05:690e:b4e:b0:668:1433:de09 with SMTP id 956f58d0204a3-6690582cddemr2916420d50.95.1785328131281;
        Wed, 29 Jul 2026 05:28:51 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-73.dlp.protect.broadcom.com. [144.49.247.73])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-669122b2e0asm205872d50.8.2026.07.29.05.28.50
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jul 2026 05:28:51 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c15deb3377eso72755766b.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 05:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785328130; x=1785932930; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=80XIbOpgDfahtQfRx2y5PGslIsS8+OtcUMo3OPdSsEc=;
        b=a4lSGCRvxaWOQD7EffhlSaJ0LvgSD5SvyHupbGgl026P4e4zD+vEJo1ssY2Lp6030k
         zxco6exJrJe/Ux3TpdU2EuDLWksK8bx76C4aWGfU8SZyabtSdVXMLy0/OmS4S0WJZZPQ
         CPmPcfBFqneTaX5tnLwWYrXKPblnLLjOdKGH0=
X-Received: by 2002:a17:906:99cb:b0:c1f:2b07:55aa with SMTP id a640c23a62f3a-c1f7218e1a2mr327886466b.45.1785328129572;
        Wed, 29 Jul 2026 05:28:49 -0700 (PDT)
X-Received: by 2002:a17:906:99cb:b0:c1f:2b07:55aa with SMTP id a640c23a62f3a-c1f7218e1a2mr327885066b.45.1785328129208;
        Wed, 29 Jul 2026 05:28:49 -0700 (PDT)
Received: from [10.176.3.215] ([192.19.176.250])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1f83fabc2fsm105876966b.50.2026.07.29.05.28.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 05:28:48 -0700 (PDT)
Message-ID: <c452116c-6215-4d62-b96b-72ae23a478e1@broadcom.com>
Date: Wed, 29 Jul 2026 14:28:48 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: brcmfmac: configure SAE PWE method for external SAE
 AP
To: Bogdan Nicolae <bogdan.nicolae@gmail.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org
References: <20260729053408.13715-1-bogdan.nicolae@gmail.com>
 <5cf57b2d-2bcc-481c-87bf-3a034d5f99be@broadcom.com>
 <CA+ORkNQntwC4k2arcngGdYB3mwsbJCkCRNTJRJ2GoRxjdGXLzA@mail.gmail.com>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <CA+ORkNQntwC4k2arcngGdYB3mwsbJCkCRNTJRJ2GoRxjdGXLzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 29/07/2026 13:48, Bogdan Nicolae wrote:
>> On Wed, Jul 29, 2026, 04:48 Arend van Spriel 
>> <arend.vanspriel@broadcom.com <mailto:arend.vanspriel@broadcom.com>> wrote:
>> 
>>     On 29/07/2026 07:34, Bogdan Nicolae wrote:
>>      > When bringing up a WPA3-SAE SoftAP with external (user space)
>>     SAE, the
>>      > driver never told the firmware which SAE Password Element (PWE)
>>     method to
>>      > accept. The firmware was observed to corrupt its heap over time
>>     due to
>>      > this omission, leading to firmware trap (data abort in heap
>>     allocator).
>>      >
>>      > Parse the beacon IEs on start_ap() and set the extsae_pwe iovar
>>      > accordingly: 2 when the RSNX IE advertises H2E, 1 when an H2E-only
>>      > membership selector is present, 0 otherwise. This matches the
>>     behaviour
>>      > of the upstream/vendor driver and only applies to SAE-capable APs
>>     when
>>      > external SAE is supported.
>> 
>>     This makes sense, but may I ask what device do you have? Suspect it
>>     is a
>>     Cypress/Infineon chip. I could not find the iovar in our (Broadcom bca)
>>     code base so I suspect it is vendor specific.
> Hi Arend,
> 
> Indeed, this is a bcm43455 as found on Raspberry Pi SoCs.
Than we should only invoke the parse function for cyw vendor.

Regards,
Arend
