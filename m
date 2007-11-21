Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:54177 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbXKUTG1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 14:06:27 -0500
Date: Wed, 21 Nov 2007 11:06:02 -0800
To: Shaddy Baddah <shaddy_baddah@hotmail.com>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	David Miller <davem@davemloft.net>
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
Message-ID: <20071121190602.GB17199@bougret.hpl.hp.com> (sfid-20071121_190634_903866_4244CA6F)
Reply-To: jt@hpl.hp.com
References: <1195484582.8642.18.camel@johannes.berg> <20071119.142046.188284555.davem@davemloft.net> <1195562454.10920.6.camel@johannes.berg> <20071120.044600.47940350.davem@davemloft.net> <20071120180016.GC1480@bougret.hpl.hp.com> <20071120180601.GA2019@bougret.hpl.hp.com> <47443430.3010504@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <47443430.3010504@hotmail.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 22, 2007 at 12:35:44AM +1100, Shaddy Baddah wrote:
> Hi Jean,
> 
> Jean Tourrilhes wrote:
> >>	This is a special version of Wireless Tools with some debug
> >>code.
> >
> >	Sorry, I forgot to enable some debug. This version should do it.
> 
> I've chosen to respond directly, because I hope not to publish my MAC 
> address to the list,

	Wise move. I made sure to blank it out.

> I've run as follows:
> 
> # ./iwlist eth2 scanning 2>&1 | tee scan.log
> 
> and have attached the output.
> 
> Hope that helps,
> Shaddy

> Scan result 4096 [
{removed for privacy reasons}
00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00]

	The first thing to notice is the large number of zeros at the
end. This is the same problem as you had with the encryption key, the
lenght of the buffer is not returned properly to user space. In
theory, we should not crash on bad data, but having all this extra
junk is not helpful.
	The fix for that is the patch I sent in the other e-mail,
already included in 2.6.23.

> DBG - stream->current = 0x2c039, stream->value = (nil), stream->end = 0x2d008
> DBG - iwe->cmd = 0x8B01, iwe->len = 24
> DBG - event_type = 2, event_len = 16, pointer = 0x2c03d
> DBG - alt iwe->len = 20
>                     Protocol:IEEE 802.11bg
> DBG - stream->current = 0x2c051, stream->value = (nil), stream->end = 0x2d008
> DBG - iwe->cmd = 0x8B07, iwe->len = 12
> DBG - event_type = 4, event_len = 4, pointer = 0x2c055
> DBG - alt iwe->len = 8

	Are you certain the log really stop there ? It looks truncated
to me. As far as I can see, the parsing works properly and the
workaround kicks in properly.
	Note that there is only a single AP in your scan log. After
the protocol, you should see "mode: Master", "freq/channel" (twice),
and "encoding". After that, it should try to decode "rate" but will
most likely fail because of the extra junk (I'll look into that).

	If you have time, you can try with gdb. Here is what you would
do.
	1) edit Makefile. Go to CFLAGS, replace "-Os" with "-g".
	2) make clean ; make
	3) gdb --args iwlist eth0 scan
	4) run
	5) bt

	I'll look into that.
	Thanks a lot !

	Jean



