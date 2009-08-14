Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:37861 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbZHNVE2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 17:04:28 -0400
Received: by fxm11 with SMTP id 11so1390531fxm.39
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 14:04:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200908142300.01397.mb@bu3sch.de>
References: <4a84906b.+IYGhiNLKPSjrrR7%Larry.Finger@lwfinger.net>
	<200908142215.38112.mb@bu3sch.de> <1250283133.8137.16.camel@mj>
	<200908142300.01397.mb@bu3sch.de>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 14 Aug 2009 23:04:09 +0200
Message-ID: <69e28c910908141404q42685aebo93718a7504020c06@mail.gmail.com>
Subject: Re: [PATCH] b43: Fix sparse warnings
To: Michael Buesch <mb@bu3sch.de>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 14, 2009 at 11:00 PM, Michael Buesch<mb@bu3sch.de> wrote:
> On Friday 14 August 2009 22:52:13 Pavel Roskin wrote:
>> On Fri, 2009-08-14 at 22:15 +0200, Michael Buesch wrote:
>>
>> > > -                 b43_phy_mask(dev, 0x048A, (u16)~0x8000);
>> > > +                 b43_phy_mask(dev, 0x048A, (u16)(~0x8000 & 0xFFFF));
>> >
>
>> I would just use 0x7fff here.
>
> That does not work if 0x8000 is a #defined bit.

What about ~((u16)0x8000)? (Or maybe ~(u16)0x8000 is enough, without
the extra parentheses.)

>
> --
> Greetings, Michael.
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
