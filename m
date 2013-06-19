Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:37195 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934714Ab3FSTae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 15:30:34 -0400
Received: by mail-ob0-f181.google.com with SMTP id 16so6431956obc.12
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jun 2013 12:30:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130619175850.GD4784@cmadams.net>
References: <20130619160911.GB4784@cmadams.net>
	<51C1DDEB.3090701@lwfinger.net>
	<20130619164227.GC4784@cmadams.net>
	<CACna6rzbTHnyqs5SzTuYL7r_SW3iCNh0qqbnvfsF7Wspyhp1WA@mail.gmail.com>
	<20130619175850.GD4784@cmadams.net>
Date: Wed, 19 Jun 2013 21:30:33 +0200
Message-ID: <CACna6ryFzp_g2tOGguqjvFiEcU6q8KqF4rk_BBxmS=bNRWjY7A@mail.gmail.com> (sfid-20130619_213045_084355_515AA02A)
Subject: Re: BCM4331 deauthenticates every five minutes
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	b43-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/6/19 Chris Adams <cma@cmadams.net>:
> Once upon a time, Rafał Miłecki <zajec5@gmail.com> said:
>> I don't know how/if driver can be responsible for such reconnects.
>> Over all it just TX and RX packets, right? Loosing a signal is
>> something different, that can be related to the driver's bug. But as
>> this happens every 5 minutes... I don't know.
>>
>> Did you try connecting to this AP with any other card and using
>> similar kernel? I wonder if this can be some supplicant / mac80211
>> stack issue...
>
> I just fired up my Thinkpad T510 with an Intel "Centrino Ultimate-N
> 6300" using iwlwifi, and it stays connected (does not appear to drop any
> packets).  This is also Fedora 18 x86_64 (slightly older kernel, but
> I've had the problem on the MacBook since I installed it).  There are
> other people in the office with the same MacBook hardware (but running
> OS X) that don't appear to be having any trouble either.
>
> The AP appears to be an Adtran (don't know the model).

Thanks for info/testing. I still wonder how driver's code can cause
any disconnections happening exactly every 5 minutes... Any idea
anyone?

One bug that was recently discovered and that sits in b43's code is
passive scanning. For some reason it seems b43 doesn't do passive
scanning, I didn't have time to debug that yet. I wonder if this can
affect connection stability anyhow.

Perhaps you could try performing manual scanning every ~minute? It's
really just a crazy guess, I don't have any idea why it could help.
But it's so trivial you may want to give it a try.

-- 
Rafał
