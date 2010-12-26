Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:51495 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab0LZMO7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 07:14:59 -0500
Received: by qyk12 with SMTP id 12so8774759qyk.19
        for <linux-wireless@vger.kernel.org>; Sun, 26 Dec 2010 04:14:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101226112433.31775.89617.stgit@fate.lan>
References: <20101226112404.31775.77854.stgit@fate.lan>
	<20101226112433.31775.89617.stgit@fate.lan>
Date: Sun, 26 Dec 2010 13:14:58 +0100
Message-ID: <AANLkTikFrH0P+A-tZU1hULNja4yvWkwqb22csHtrKO76@mail.gmail.com>
Subject: Re: [RFC PATCH 3/6] zd1211rw: let zd_set_beacon_interval() set
 dtim_period and add AP-beacon flag
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	zd1211-devs@lists.sourceforge.net,
	Ulrich Kunitz <kune@deine-taler.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/12/26 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>:
> -static int set_beacon_interval(struct zd_chip *chip, u32 interval)
> +static int set_beacon_interval(struct zd_chip *chip, u32 interval,
> +                              u16 dtim_period)

That gets messy. We have interval in interval, flags in interval and
period in dtim_period :|

Do you have idea what is maximum value for dtim_period? It sounds like
it should be 0xff.

Could we maybe try sth like:
u16 interval, u8 dtim_period, u8 flags? Then we would have
flags << 24 | dtim_period << 16 | interval

Or maybe to avoid problems with shifting flags (re-defining defines?),
we could use a little more messy
flags | dtim_period << 16 | interval

Or do you have better idea? Proposed one doesn't seem really clear for me.

-- 
Rafał
