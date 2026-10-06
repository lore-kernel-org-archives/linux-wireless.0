Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE663D88E0
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 11:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791285542; cv=none; b=C3nxH9+0PV3EuKxPVrKdH26XfY2IvfYgrARCKowwbcCSEKlzT34qGoVbgg1fzvNlV8Gq016v6s3exRC8Wflztd+YSDXPNHNzIh39X533YRD3cfN1a2o+krueBVRqIvcVdQSiQhk9hvu2B4KmJrZz4kJ/8HCtb8eS5QSpwQjmVVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791285542; c=relaxed/simple;
	bh=T9pQLHtkTws6ReeUvx+8dHa8B2SrtK8aEWmbBiNo0o4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NdAdnYFaOpoHjdcYzwtOxGvH1WGyHAQ4RwGnB9fjs/8pmC+EL9PRgWW0MH69fYTifCd/WRppmPk+rIKrZktV9uNoaQSJONB6aHyxsTVMEuSckL9Cz3ZnXiHY2l0ZvnSxRk6skOxQq+0wz1pbFEEpP2CxJt5eJQji1eiafdUOiJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LxzelV5a; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LxzelV5a"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48afcfc4bf5so2254548f8f.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 04:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791285539; x=1791890339; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lbWPBQuVRiue4AC08Y5e154S6RcmoKslymnN0Vvmfhw=;
        b=LxzelV5aud9Wnv1J9wVSZXTPhQvi7hAFXQOpvPF0YTwXFfs9ye9oI+Prou4aw++EcB
         1wqQRopugMAcPy4zlA32Cwy/kjuDnSs+MpNkPQKbJTB/MdvDRZKsmoC5Y/Q/AhTA5PQ0
         9qBMb3aWTR/M79nQVJuV3qjz8tRw4MoZ4a36NmadUR2fpLEOHgrmqXs/felXOdtZvlMG
         MivoqHKygUV8c7pZuW8K+4S8BZ5hpfPUCTgXiy1sKTGoqbxmIvda59XqlnMTSBJZ4XtF
         gKS/9fpzeeEUhHqw7aVrp2af567EwKFuR3mLe2YwDwlFHPQdM8Rk/UTUvT0c1Zh+5/yL
         nyyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791285539; x=1791890339;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lbWPBQuVRiue4AC08Y5e154S6RcmoKslymnN0Vvmfhw=;
        b=NQ1xyHDwEAnvPCseSHoGfqQbPZRH41VOc6sKxRWL/4p2q97WuZVhnvZmi57eRRnEBp
         R7RFs+lYgKM4wa8r9ESxG5lMMc0JpS+6kaoVGv4HuCl8Wx6RZYvyD6Jkehq53e611vcs
         cx14Mp8H4fFpynrZnjEWm0RAZRFJVA+2FMcGibnImJkTMGed12x9ohyjRF5h/THEMjkJ
         O8aKLyQ4hltLk5HQPEtTbJFGNlFSHMAM6Ay4M/eNFv0Qz5mC4gsj5F1uuhg39c1bxqhj
         3FPp1H2VHqxleYgfIqv0Evki1i78Ni/JRatw2G4XLkrv3Oy08CpxWDHNG0VDWzltcUvw
         aNzA==
X-Gm-Message-State: AFq9FYJ9xFbgxDQ6n8f9mveJuv1YYqgIrbSqliaW7dUOLxUaMoMSI8+J
	RV9YXrejNXOA0VwZgASo63j2xbLX+q2J3Rsla2ldvSt5IbO/2B1BF9Vd
X-Gm-Gg: AYBFou0MVzw0AkHZVYVq0omoaymXRErfPwitaPokizV6HyVrqU8KhHZm5IQosP1ceSd
	0bkkcxPEMbStAW4qNcw90I9Ogha7kWmqvGNWKWRyATpHoJgizmNH2Wk7qBo2H8vPEiILPycVFUO
	sbMx5JIXfUGP1kNdazJdDo0P48YkAydALg7KaBj6hezT2gh3F0qsiZMMOtLPP94UYGKIj9KHw5u
	xj2eL+iDQlO+zDFHOdFeFmQR3+Fxef1jp8qS6yOcmhoiLJNFCl/Jd0a+0LOQVotBHgdBEzXLx1T
	AMCD5LbLbD5mCiNFXZ/ITBwbCpY+IGbwJkTgpyTKHkozJ2wf821tcUKRtIQJvjVcD5u87bPob2L
	xjjvAMl9EaLY03VJhhMMkHEvDo22ijMPqfQFLjGDVJeVBeAA2P7GRb/bRZNn56l3yNvAUyhGCik
	94tbJCBbw1RSUzeNKmLEOrXzVp+8MbHXq0P8hpZtpAWON62742dQoyQtfYzB/8jxofFdLjGwWXh
	vQUCQ==
X-Received: by 2002:a05:6000:1a85:b0:487:490:8391 with SMTP id ffacd0b85a97d-48c6d160060mr2104906f8f.16.1791285538622;
        Tue, 06 Oct 2026 04:18:58 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c6d264fcbsm2172381f8f.47.2026.10.06.04.18.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2026 04:18:58 -0700 (PDT)
Message-ID: <3a57c874-ab57-4ca2-98a9-d5cf4fdf285b@gmail.com>
Date: Tue, 6 Oct 2026 14:18:55 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rtw-next v7 4/6] wifi: rtw88: 8723b: add the RTL8723B chip
 driver
To: Ping-Ke Shih <pkshih@realtek.com>, Luka Gejak <luka.gejak@linux.dev>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>
References: <20261002073845.31486-1-luka.gejak@linux.dev>
 <20261002073845.31486-5-luka.gejak@linux.dev>
 <aa7d919d98304ee095990735f39095ac@realtek.com>
 <DLWXWMOGZGX9.UANQJR9PZYWG@linux.dev>
 <359ea3a6857d4aba9c83876a10f7f9e8@realtek.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <359ea3a6857d4aba9c83876a10f7f9e8@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 06/10/2026 03:39, Ping-Ke Shih wrote:
> Luka Gejak <luka.gejak@linux.dev> wrote:
>> On Mon Oct 5, 2026 at 8:08 AM CEST, Ping-Ke Shih wrote:
>>> Luka Gejak <luka.gejak@linux.dev> wrote:
>> [...]
>>>> +/*
>>>> + * Shares the receive PHY status layout, the SDIO aggregation burst fields
>>>> + * and a few baseband registers with the RTL8703B; reuse that header.
>>>> + */
>>>> +#include "rtw8703b.h"
>>>
>>> Which layout you are using?
>>> Should you move the layout to rtw8723x.h ?
>>>
>>
>> The layout I reuse is the RTL8703B receive PHY status structure, struct
>> phy_status_8703b, together with the SDIO aggregation burst fields and four
>> baseband registers. 
> 
> Let's use another patch to move the struct out of rtw8703b.h, and rename
> to phy_status_8723x for example.
> 

The same struct could be used by other chips in the future, like
RTL8192EE/RTL8192EU and RTL8188FU/RTL8189FS.

