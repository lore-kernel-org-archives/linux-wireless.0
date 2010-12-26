Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:37084 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab0LZOua (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 09:50:30 -0500
Message-ID: <20101226165023.81872js0gqshj2uo@hayate.sektori.org>
Date: Sun, 26 Dec 2010 16:50:23 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: =?utf-8?b?UmFmYcWCIA==?= =?utf-8?b?TWnFgmVja2k=?=
	<zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	zd1211-devs@lists.sourceforge.net,
	Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: [RFC PATCH 3/6] zd1211rw: let zd_set_beacon_interval() set
 dtim_period and add AP-beacon flag
References: <20101226112404.31775.77854.stgit@fate.lan>
 <20101226112433.31775.89617.stgit@fate.lan>
 <AANLkTikFrH0P+A-tZU1hULNja4yvWkwqb22csHtrKO76@mail.gmail.com>
In-Reply-To: <AANLkTikFrH0P+A-tZU1hULNja4yvWkwqb22csHtrKO76@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Rafał Miłecki <zajec5@gmail.com>:

> 2010/12/26 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>:
>> -static int set_beacon_interval(struct zd_chip *chip, u32 interval)
>> +static int set_beacon_interval(struct zd_chip *chip, u32 interval,
>> +                              u16 dtim_period)
>
> That gets messy. We have interval in interval, flags in interval and
> period in dtim_period :|
>
> Do you have idea what is maximum value for dtim_period? It sounds like
> it should be 0xff.
>
> Could we maybe try sth like:
> u16 interval, u8 dtim_period, u8 flags? Then we would have
> flags << 24 | dtim_period << 16 | interval
>
> Or maybe to avoid problems with shifting flags (re-defining defines?),
> we could use a little more messy
> flags | dtim_period << 16 | interval
>
> Or do you have better idea? Proposed one doesn't seem really clear for me.
>
Vendor driver uses u16 interval, u8 dtim_p, u8 mode and selects right  
flags based on interval. I'll something like change to that, I think  
caller shouldn't be setting hw flags here anyway.

-Jussi

