Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713867;
	b=pZpIH41WZVWrKBzDtWD/aqUSj4BI28HJoZypdK/86FRsj5GhVRczovWRINavKXMmj6AT
	 vau0iPmRSKlRroIehr0IsZNuUHU1WNqpdeuNgOU6wxhpvlnN7AnU8SZtZyYkTer415a4E
	 9sQSd1+6RKwehex3wfOclHdEBxf18NiuhSWPMPGewi28gDJ6XA6N2IwyTD65yy8G2p0YC
	 cLmP3FNJPzzGU004PSnTRfiEYZQY58HN4u3eS/Z2WeuhNlEO7xM+BOLM0ygvF95E7qAt8
	 LeiUD61St5uX1wEhFE0PBwar79Z/oMepQsUcVSvx88QrpENWwPE48e/88uHbIfw4jHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713867;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=kAZHHRNJQTBE7m/Mdeu3wvd8YYTG4G1JA7sRIt/FlQI=;
	b=mYOifyCkFpdcntLQ/O3kH9U1RDzJHiPqeoE6KZYkwO6e1Vr9I4tFbt1tEOTiYRqnbFB9
	 /VyenXnIP0PO5wjJ8VMQ63uTRBalHOV/ebs6myO67BozSi2IMZO+rB9dVlxvZRV21mIde
	 YN7htVZv6RxsML088QjE+Krxu2rHMj7l++J0yQKB4iYZILY4yYIbSyMt8/nxJTfEw4YFC
	 eFN0/rFWP799eoVUtPcLZrRweBlziFKETpi+qe+zh9qwvFaNyLvcCqkOL3k9F+Ej0b85k
	 odux/xSR7CSkAMRH1MMDcgD+IauIUNqe/8NaEzYEe79FjEQpf00YcIagdyTaoiFdR+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=IY8HlU3W;
	arc=none smtp.remote-ip=209.85.215.228
Received: from mail-pg1-f228.google.com (mail-pg1-f228.google.com [209.85.215.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594606082BFC
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 13:51:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 594606082BFC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=IY8HlU3W
Received: by mail-pg1-f228.google.com with SMTP id 41be03b00d2f7-cc4c02ddd62so2146965a12.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:51:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713867; x=1794318667;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=kAZHHRNJQTBE7m/Mdeu3wvd8YYTG4G1JA7sRIt/FlQI=;
        b=WFRLNl3C5SUb8X9sb2Hb3Ji+t4tv7KwyQl/P7XzYp2gLpkQZ+Da6ZU30ygcn3PTNkS
         Cp1E0yO+2k7ECSbRo8ryC4EcqQ2uKqpcW8ixtlbHNKnv9I+ZIQ+Wn9GI8MMyVHc/Pi9q
         mdl2H18ooR/i5vKIP/3nYUfRvFyr0m1GURZrmVwXq00EtmzdRSq/P9lZRrtelK4CxFQW
         WW2csdcL1EYsd4k7CWlOhGX5HInLyHWlERZwZmgLM/p1EWSpIOCkfUVHI8xIiylOxfe3
         H5tBRv26oSk/hO9K4NjmyJ4Giownhi9UPGD55cKAPDBIg0v3tH+aRj58WET0im3zR44H
         5M2g==
X-Forwarded-Encrypted: i=1; AKwUvBy9tblJkSum92pqPWTSnRIejQ2mk2dHM3h/ePun6Q+j6LJ0gHeXO0e4ZVybY2XmNJhychZ2XgNmnyYdStm89A==@vger.kernel.org
X-Gm-Message-State: APuU4Z98H4fpbAnjrTyZYZZsrqiPUEaGIKS/fUus4O4eaOUjc8QD1o+/
	f6yZZP0HY/agJbbygiCLjqhJdRm+saTC7Cl+06t+vYF0GIbf/sJzf6RFgem9WjrVd8wZm7mAx4p
	BKBl9glcqlDkQBHUBYUGKKpk7iWmRLVTck7KnUmio4yKM6ckiz4ZUBqI5+7XBBLcdKqPvpmHHCS
	dvSi6i6YeyObIfDZBh29PPZSGfMmHtbtxp1qFPunyrJYiqSFf/RX0u6RKXhbQ4Zmo/YuchDhdNu
	PtnFio0F1kzqjpOjKVkit8Aww==
X-Gm-Gg: AYBFou3GxWf6WO9ge8jaK8XhXDqF6/ohvkUDi0+BK7xwHC34vgfUPhhZ5oXvYkk3SYV
	ywJUyr3X+tsJOeXR3a3dxyH4Qzkh5qQCSBnx580a4BlErpSl/xIIoQu8zaWc4Dnezn1cDmpK6eu
	uQMZa3nT8uboVD4nSYdfRjRsaxVDVj8PrXmlKul/Nw7Asle+SkKGwCm1bkLb8OEDhBRKnPb/htt
	QBq9wNcWLcp12ePlCHhJsNu2p6o1YDAQwuKo0exPViEBTPHkuEjY6brqfFNk34CKqzfBnLctyvV
	XFSeuSfi1GNK4SmvuKrhzAdehzsyvJ41ZoN4NRY73TyWmpNYDpWbz75nYEDmuUS7ySxz5tt67HZ
	g4dVD4+82TsH7C46gdWs4imb59TujYGq5uMvlBMq1xS9GUQKl42Ct78ZDZCqQq28GU5CyT80Cvq
	4vm0X419AORDbtBUVyP6A78IKc/5HiAkcb1f9fXiE=
X-Received: by 2002:a17:90b:35d1:b0:3ae:8410:ae6a with SMTP id 98e67ed59e1d1-3ae897ccd18mr11059239a91.22.1793713866527;
        Tue, 03 Nov 2026 05:51:06 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b07c4d7c5fsm1918927a91.0.2026.11.03.05.51.05
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2026 05:51:06 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-537548b8342so93242921cf.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793713865; x=1794318665; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kAZHHRNJQTBE7m/Mdeu3wvd8YYTG4G1JA7sRIt/FlQI=;
        b=IY8HlU3WxUDePY2105RkzMhKUipiohAFAr6U/x1iS19f5qa9jwLwhARxMrjMckEz6I
         +JEG6N89TD2IMttxY9WgdpqqBSKBgbNYGROHJCMO8JmiaePzOqkkzkac7Ib05qSGJrBZ
         DEdTMnnXr91GSBvrCeL6s5crRSOQMEycex6N8=
X-Forwarded-Encrypted: i=1; AKwUvByv8xMf6xjCXz7CR7cjtwWM7kC0Mzdwxf7/5q+rX4I/Cmr8SxBXahF2RVq3SBKqe0PdCxVwwIUIYFdfDFmxqA==@vger.kernel.org
X-Received: by 2002:ac8:5a4a:0:b0:535:84e3:ceef with SMTP id d75a77b69052e-542b781c626mr217069731cf.45.1793713865341;
        Tue, 03 Nov 2026 05:51:05 -0800 (PST)
X-Received: by 2002:ac8:5a4a:0:b0:535:84e3:ceef with SMTP id d75a77b69052e-542b781c626mr217069361cf.45.1793713864762;
        Tue, 03 Nov 2026 05:51:04 -0800 (PST)
Received: from [10.176.3.155] ([192.19.176.250])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91e77e5efc3sm870636d6.39.2026.11.03.05.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 05:51:03 -0800 (PST)
Message-ID: <533b31e4-c837-494d-a4ce-a728bfbe07b2@broadcom.com>
Date: Tue, 3 Nov 2026 14:51:00 +0100
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
To: Janne Grunau <j@jannau.net>
Cc: michael.reeves077@gmail.com, Pieter-Paul Giesberts
 <pieterpg@broadcom.com>, "Franky Lin (Zhenhui)" <frankyl@broadcom.com>,
 Mathy Vanhoef <vanhoefm@gmail.com>, Kalle Valo <kvalo@kernel.org>,
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, asahi@lists.linux.dev,
 Hector Martin <marcan@marcan.st>, Daniel Berlin <dberlin@dberlin.org>,
 linux-kernel@vger.kernel.org, Hante Meuleman <meuleman@broadcom.com>,
 linux-hardening@vger.kernel.org, Peter Robinson <pbrobinson@gmail.com>,
 Izabela Bakollari <ibakolla@redhat.com>
References: <20260925-brcm4388-submit-v1-0-b5cbc2cde2fb@gmail.com>
 <d78cbbd2-601a-4cf1-800f-3be57a2b7de2@broadcom.com>
 <20261102204627.GB770347@robin.jannau.net>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20261102204627.GB770347@robin.jannau.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 02/11/2026 21:46, Janne Grunau wrote:
> On Sun, Nov 01, 2026 at 08:27:22PM +0100, Arend van Spriel wrote:
>> + Peter, Izabela
>>
>> On 25/09/2026 15:43, Michael Reeves via B4 Relay wrote:
>>> The Broadcom BCM4388 chipset requires new PCIe initialization and
>>> firmware interfaces. Add support for these interfaces to brcmfmac to
>>> enable basic station operation.
>>>
>>> This series adds:
>>> - Signed firmware loading and mailbox transport
>>> - Fixes for chip identification and firmware capability matching
>>> - Versioned scan and join requests, and extended PMK payloads
>>> - Updated event mask handling
>>>
>>> These changes include work by Hector Martin and Daniel Berlin from Asahi
>>> Linux, refactored where needed for upstream inclusion.
>>>
>>> The series provides basic station support only. 6 GHz support is planned
>>> for a follow-up patchset after this lands. The driver retains legacy
>>> interfaces for older firmware.
>>>
>>> Tested on an Apple M3 MacBook Air (J613):
>>> - Device boot and network scanning
>>> - 5 GHz WPA2-PSK association and DHCP
>>> - Bidirectional TCP traffic
>>
>> Finally got some time to get this series tested on my setup. The patches
>> generally look good. So far no regressions observed. It would be good if
>> some more people could test this series on their equipment. I will do
>> some more testing and wait some days.
> 
> Tested series on top of v7.3 + commit 7ed5dce55fa8 ("wifi: brcmfmac: map
> msgbuf RX packet IDs bidirectional") in wireless/main with resolving the
> conflict by dropping the conflicting hunk of this series.
> 
> Tested on Mac mini (M1, BCM4378) and Macbook Pro 14-inch (M1 Max,
> BCM4387) without regressions (except for the resolved RX msgbuf
> mapping).
> 
> Tested-by: Janne Grunau <j@jannau.net>
No regressions seen on my 43664 and 43455 devices. So will process the 
patches now.

Regards,
Arend
