Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44341 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab1EQMST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 08:18:19 -0400
Received: by qwk3 with SMTP id 3so206128qwk.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 05:18:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTik59ohV42QYR3JqssbJjEzxnEGyOw@mail.gmail.com>
References: <BANLkTik2Sc9aWi_cHVvLJzGv3esey=wPag@mail.gmail.com>
 <BANLkTimoju5LSrKcRe67c41mCkPU0PUOjg@mail.gmail.com> <BANLkTik59ohV42QYR3JqssbJjEzxnEGyOw@mail.gmail.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Tue, 17 May 2011 14:17:58 +0200
Message-ID: <BANLkTi=Ais3sYvyAPcDFaRmudG_FQJgEag@mail.gmail.com> (sfid-20110517_141825_034188_C69CB638)
Subject: Re: ssb: how did we get special reject bit for SSB rev 2.3?
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/5/17 Rafał Miłecki <zajec5@gmail.com>:
> W dniu 17 maja 2011 13:32 użytkownik Jonas Gorski
> <jonas.gorski@gmail.com> napisał:
>> 2011/5/17 Rafał Miłecki <zajec5@gmail.com>:
>>> Currently we are using different REJECT bit for SSB rev 2.3:
>>> #define  SSB_TMSLOW_REJECT      0x00000002 /* Reject (Standard Backplane) */
>>> #define  SSB_TMSLOW_REJECT_23   0x00000004 /* Reject (Backplane rev 2.3) */
>>>
>>> Does anyone know where did we get this from?
>>
>> Broadcom public sources define it as follows:
>> #define SBTML_REJ_MASK          0x0006          /* reject field */
>> #define SBTML_REJ               0x0002          /* reject */
>> #define SBTML_TMPREJ            0x0004          /* temporary reject,
>> for error recovery */
>>
>>>
>>> wl does never use this bit:
>>
>> It seems neither do the public ssb sources:
>> # grep -r 'SBTML_TMPREJ' shared/ | wc -l
>> 0
>> #
>
> Where did you check this? AFAIK wl has only linux_osl.c public
> available and brcmsmac does not support SSB at all. Do you find any
> references to SBTML_REJ in this "shared/*"?

This is from a bcm47xx router GPL tarball (the asus rt-n10 to be
specific), but it's also in the brcm80211 drivers:
<http://lxr.linux.no/#linux+v2.6.38/drivers/staging/brcm80211/include/sbconfig.h#L150>

and SBTML_REJ usage:
<http://lxr.linux.no/#linux+v2.6.38/drivers/staging/brcm80211/util/sbutils.c#L459>

Jonas
