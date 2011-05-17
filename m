Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39604 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab1EQLpd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 07:45:33 -0400
Received: by qyg14 with SMTP id 14so216362qyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 04:45:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimoju5LSrKcRe67c41mCkPU0PUOjg@mail.gmail.com>
References: <BANLkTik2Sc9aWi_cHVvLJzGv3esey=wPag@mail.gmail.com>
	<BANLkTimoju5LSrKcRe67c41mCkPU0PUOjg@mail.gmail.com>
Date: Tue, 17 May 2011 13:45:31 +0200
Message-ID: <BANLkTik59ohV42QYR3JqssbJjEzxnEGyOw@mail.gmail.com> (sfid-20110517_134537_382448_7E0E78E4)
Subject: Re: ssb: how did we get special reject bit for SSB rev 2.3?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Jonas Gorski <jonas.gorski@gmail.com>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 17 maja 2011 13:32 użytkownik Jonas Gorski
<jonas.gorski@gmail.com> napisał:
> 2011/5/17 Rafał Miłecki <zajec5@gmail.com>:
>> Currently we are using different REJECT bit for SSB rev 2.3:
>> #define  SSB_TMSLOW_REJECT      0x00000002 /* Reject (Standard Backplane) */
>> #define  SSB_TMSLOW_REJECT_23   0x00000004 /* Reject (Backplane rev 2.3) */
>>
>> Does anyone know where did we get this from?
>
> Broadcom public sources define it as follows:
> #define SBTML_REJ_MASK          0x0006          /* reject field */
> #define SBTML_REJ               0x0002          /* reject */
> #define SBTML_TMPREJ            0x0004          /* temporary reject,
> for error recovery */
>
>>
>> wl does never use this bit:
>
> It seems neither do the public ssb sources:
> # grep -r 'SBTML_TMPREJ' shared/ | wc -l
> 0
> #

Where did you check this? AFAIK wl has only linux_osl.c public
available and brcmsmac does not support SSB at all. Do you find any
references to SBTML_REJ in this "shared/*"?

-- 
Rafał
