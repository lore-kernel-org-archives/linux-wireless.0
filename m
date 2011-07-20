Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45378 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab1GTIaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 04:30:16 -0400
Received: by iyb12 with SMTP id 12so4802390iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2011 01:30:15 -0700 (PDT)
Message-ID: <4E269214.9050308@lwfinger.net> (sfid-20110720_103020_606184_C4DE4B47)
Date: Wed, 20 Jul 2011 03:30:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Pavel Roskin <proski@gnu.org>, b43-dev@lists.infradead.org
Subject: Re: [PATCH 1/3] b43: replace DMA translation workarounds with just
 a one, commented
References: <1311113542-2540-1-git-send-email-zajec5@gmail.com>	<1311113542-2540-2-git-send-email-zajec5@gmail.com>	<20110720011509.504022f8@maggie> <CACna6rwMe9-dHANpDLko5yy5wu521YTGXmqBr1JYh18tYt+Z4A@mail.gmail.com>
In-Reply-To: <CACna6rwMe9-dHANpDLko5yy5wu521YTGXmqBr1JYh18tYt+Z4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/20/2011 01:16 AM, Rafał Miłecki wrote:
> W dniu 20 lipca 2011 01:15 użytkownik Michael Büsch<m@bues.ch>  napisał:
>> On Wed, 20 Jul 2011 00:12:20 +0200
>> Rafał Miłecki<zajec5@gmail.com>  wrote:
>>> +              * be fixed on ssb side, but requires testing with b43,
>>> +              * b43legacy and b44. */
>>
>> No it doesn't. b44 and b43legacy don't use 64bit DMA.
>> Just fix it in ssb, please.
>
> They (drivers) don't, but what if we start giving them routing for
> 64-bit DMA? AFAIU they treat 64-bit DMA as 32-bit one (according to
> specs: "If 64 Bit isn't an option, Silicon Backplane and PCI-E buses
> can use 32 bit DMA.").
>
> Won't they start using 64-bit DMA in the 32-bit way but with 64-bit
> routing bits?

The BCM4311 was the first device that supported 64-bit DMA. I had the first of 
those, and I got to debug the 64-bit stuff that had been written by Michael, but 
there had been no hardware for testing. All earlier devices were restricted to 
32-bit paths.

Larry
