Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:32905 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab1JUWCc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 18:02:32 -0400
Received: by qyk27 with SMTP id 27so4346952qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2011 15:02:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ5hJZSm4P5Vpzmi6yfF3vy2XAMKH9kE-Kv=FfDLVX9DwQC4Aw@mail.gmail.com>
References: <CAJ5hJZSm4P5Vpzmi6yfF3vy2XAMKH9kE-Kv=FfDLVX9DwQC4Aw@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 22 Oct 2011 00:02:11 +0200
Message-ID: <CA+XFjiq6EJNczcotbk3R5YQXa-iY_2FY8KK4UN69XxSTm8LtoQ@mail.gmail.com> (sfid-20111022_000241_407613_8304DCDA)
Subject: Re: Setting negative value in dBm for power output (txpower)
To: =?ISO-8859-2?Q?Patryk_=AF=F3=B3towski?=
	<patryk.zoltowski@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/10/21 Patryk Żółtowski <patryk.zoltowski@gmail.com>:
> I'm doing a research and I'm wondering if it's possible to hack
> wireless drivers to allow setting  txpower to smaller value than 1mW
> (e.g. 0.1mW = -10dBM, or even 0.01mW). I've checked source code and in
> net/mac80211/cfg.c there is the following check:
>
>  if (mbm < 0 || (mbm % 100))
>                     return -EOPNOTSUPP;

The "mbm % 100" part is even weirder; why do we even use millibels if
we only allow whole-decibel values?

>
> and in  e.g. in drivers/net/wireless/iwlwifi/iwl-4965.h  also the min
> power output is limited by this define:
>
>  IWL_TX_POWER_TARGET_POWER_MIN       (0)
>
> Is it possible to modify source to allow negative power output in dBm
> that would work? Or is it physical limitation from the hardware? I'm
> doing just a research using Intel Corporation PRO/Wireless 4965 AG
> card  and right now I don't require to support other hardware. Is
> there any way to check minimum power output capability by given
> wireless card? I'm not proficient with driver hacking so any hint
> where to start (which file to look up, references) would be helpful.
>
> Thanks,
> Patryk
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
