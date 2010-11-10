Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46660 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab0KJVkS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 16:40:18 -0500
Received: by iwn10 with SMTP id 10so1279759iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 13:40:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikgUi-22TRWeQYUOsMAHR47_nAxjcs-jrrrWJ=r@mail.gmail.com>
References: <AANLkTikVZT-hQvr83bTkuVENe8jPSG=LNMw5NTwUXCp1@mail.gmail.com>
 <AANLkTinT72TE_z2JW1x+pMHNys6jVEeGfkQZFAW_f+48@mail.gmail.com>
 <AANLkTikRLBYHjKzRZeo7+zuELv+tMgDKLmrmNjYL7GxU@mail.gmail.com>
 <AANLkTikx=wmDbQEz8bAsLKmjx88mQYsBjFctpntV3ex1@mail.gmail.com> <AANLkTikgUi-22TRWeQYUOsMAHR47_nAxjcs-jrrrWJ=r@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 10 Nov 2010 23:39:49 +0200
Message-ID: <AANLkTinFuksTu02dXQiTTA_G48Zo8vajpedBoc8pmzG3@mail.gmail.com>
Subject: Re: wl1271 sdio timeouts on omap3
To: Joerie de Gram <j.de.gram@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 10, 2010 at 11:24 PM, Joerie de Gram <j.de.gram@gmail.com> wrote:
> clock:          25000000 Hz
> vdd:            7 (1.65 - 1.95 V)
> bus mode:       2 (push-pull)
> chip select:    0 (don't care)
> power mode:     2 (on)
> bus width:      2 (4 bits)
> timing spec:    0 (legacy)

seems good...

> It's a samsung GT-i8320 smartphone. Supposedly assembled correctly..

heh. yeah.

> If I stop it from setting maximum clock speed, it appears to run at
> 400 KHz and subsequently it (usually) manages to bring up the
> interface. AP scans seem to complete just fine too (although they
> yield no result, which is a different problem). It's still not
> entirely stable though (bringing the interface down and back up again
> results in another timeout).

Assuming that the hw is good (and if the proprietary driver runs ok
then it is) leaves us with mmc pins misconfiguration. Are you sure the
lines are pulled up ?

> Peeking at /dev/mem with the proprietary driver running suggests it
> runs at a (usual) 24 MHz mmc clock.

Yeah. but after passing the host controller divisor, it's exactly the
same as the 25Mhz you see with the the mainline driver.

>
> Joerie
>
