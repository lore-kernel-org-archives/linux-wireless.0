Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:37479 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069Ab0KSRPU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 12:15:20 -0500
Subject: Re: [PATCH V2] b43: rfkill: use HI enabled bit for all devices
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
In-Reply-To: <AANLkTimFQ9UYWKtHpjXBTS0PPJcB_vPD7kawfffY_c+-@mail.gmail.com> (sfid-20101119_180023_531984_6B3BA604)
References: <1290028477-6462-1-git-send-email-zajec5@gmail.com>
	 <AANLkTikXqg9boY1H_OPAvs7WPd6SXUt8DpykRHuRxB6E@mail.gmail.com>
	 <1290184873.23033.3.camel@maggie>
	 <AANLkTimFQ9UYWKtHpjXBTS0PPJcB_vPD7kawfffY_c+-@mail.gmail.com>
	 (sfid-20101119_180023_531984_6B3BA604)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 18:15:17 +0100
Message-ID: <1290186917.23033.8.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-11-19 at 17:59 +0100, Gábor Stefanik wrote: 
> > There's no difference.
> > (int)0 implicitly casts to false and anything else to true.
> 
> I know, just for the sake of coding style.

All of my code in b43 uses 0/1. That's just less characters to write
and is as readable as true/false (to me).
And most b43 G code existed before bool was added to the kernel. ;)

> Same as initializing
> pointers to NULL, not 0 (though AFAIK there are platforms where 0x0 is
> a valid memory address, so using NULL is more than just coding style).

No it is not. C handles the case for NULL not being zero and generates
correct code even if 0 is used. But Linux doesn't support those
platforms due to other reasons (memset(..., 0, ...) on struct
with pointers, for example).

-- 
Greetings Michael.

