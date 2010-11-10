Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54254 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598Ab0KJVYv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 16:24:51 -0500
Received: by qyk12 with SMTP id 12so3502448qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 13:24:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikx=wmDbQEz8bAsLKmjx88mQYsBjFctpntV3ex1@mail.gmail.com>
References: <AANLkTikVZT-hQvr83bTkuVENe8jPSG=LNMw5NTwUXCp1@mail.gmail.com>
 <AANLkTinT72TE_z2JW1x+pMHNys6jVEeGfkQZFAW_f+48@mail.gmail.com>
 <AANLkTikRLBYHjKzRZeo7+zuELv+tMgDKLmrmNjYL7GxU@mail.gmail.com> <AANLkTikx=wmDbQEz8bAsLKmjx88mQYsBjFctpntV3ex1@mail.gmail.com>
From: Joerie de Gram <j.de.gram@gmail.com>
Date: Wed, 10 Nov 2010 22:24:30 +0100
Message-ID: <AANLkTikgUi-22TRWeQYUOsMAHR47_nAxjcs-jrrrWJ=r@mail.gmail.com>
Subject: Re: wl1271 sdio timeouts on omap3
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Nov 10, 2010 at 4:13 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Can you pls tell me what's the output of those commands (after
> bringing up the wlan interface):

clock:		25000000 Hz
vdd:		7 (1.65 - 1.95 V)
bus mode:	2 (push-pull)
chip select:	0 (don't care)
power mode:	2 (on)
bus width:	2 (4 bits)
timing spec:	0 (legacy)

> Can you say what board is it ? is it something you assembled or is it
> off-the-shelf ?

It's a samsung GT-i8320 smartphone. Supposedly assembled correctly..

> Honestly I would hook up a hw scope and sniff the SDIO lines to see
> what's going on.

Unfortunately I don't have access to a scope.

> Check out mmc_sdio_init_card() - the clock rate is increased there.

If I stop it from setting maximum clock speed, it appears to run at
400 KHz and subsequently it (usually) manages to bring up the
interface. AP scans seem to complete just fine too (although they
yield no result, which is a different problem). It's still not
entirely stable though (bringing the interface down and back up again
results in another timeout).

Peeking at /dev/mem with the proprietary driver running suggests it
runs at a (usual) 24 MHz mmc clock.

Joerie
