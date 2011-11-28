Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65224 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab1K1QNz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 11:13:55 -0500
Received: by yenl6 with SMTP id l6so3009128yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 08:13:54 -0800 (PST)
Message-ID: <4ED3B33E.8020309@lwfinger.net> (sfid-20111128_171358_447238_2FFA8D2F)
Date: Mon, 28 Nov 2011 10:13:50 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: AndrewL733 <AndrewL733@aol.com>, linux-wireless@vger.kernel.org
Subject: Re: Trouble with Macbook Pro 8,2 (broadcom 4331) and latest b43
References: <4ED3A6E8.4050000@aol.com> <CACna6ryNkHeVXWXxFfod1-KQs8HQVv7wF-xpY5MA-Qs6fCypCg@mail.gmail.com> <CACna6rzRJgfddE4jPivxBJCCZEyKSHsdRX7cE15rRxk2nhiRkA@mail.gmail.com>
In-Reply-To: <CACna6rzRJgfddE4jPivxBJCCZEyKSHsdRX7cE15rRxk2nhiRkA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/28/2011 10:02 AM, Rafał Miłecki wrote:
> W dniu 28 listopada 2011 16:59 użytkownik Rafał Miłecki
> <zajec5@gmail.com>  napisał:
>> I can give you some hints:
>> 1) find -name "b43.ko" /lib/modules
>
> I meant
> find /lib/modules -name "b43.ko"
>
> Anyway, the problem lies in compat-wireless installation. I don't
> understand the following part:
> make[1]: *** [_emodinst_post] Error 1
>   make[1]: Leaving directory `/usr/src/devel/3.1.2-1.1-desktop'
>   make: *** [install-modules] Error 2
> (don't know where it comes from)

It appears that your system is not building rfkill. Does it help if you add the 
following lines at the bottom of config.mk in the compat-wireless directory?

CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y


Larry
