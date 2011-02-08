Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:35802 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab1BHTIh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 14:08:37 -0500
Message-ID: <20110208210825.19692ktgddl4en40@hayate.sektori.org>
Date: Tue, 08 Feb 2011 21:08:25 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sujith <m.sujith@gmail.com>, Martin Schleier <drahemmaps@gmx.net>,
	linux-wireless@vger.kernel.org, dsd@gentoo.org,
	linville@tuxdriver.com, kune@deine-taler.de,
	linux-usb@vger.kernel.org, gregkh@suse.de
Subject: Re: Override endpoint attributes (was: RE: [PATCH] zd1211rw:
 change endpoint types of EP_REGS_OUT and EP_INT_IN from interrupt to bulk)
References: <Pine.LNX.4.44L0.1102081011030.2100-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1102081011030.2100-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Alan Stern <stern@rowland.harvard.edu>:

>>  but I know that vendor driver uses these
>> endpoints with bulk urbs and using those solve/workaround CPU usage
>> problem. Increasing interrupt interval from 1 to 255 didn't help.
>>
>> I think zd1211rw have been trying to use bulk urbs too, but
>> usb_bulk_msg() silently switches to interrupt mode. I don't know if
>> editing endpoint descriptors is right way solve this, or why CPU usage
>> is higher.
>>
>> CPU usage comes from writing beacon frame to device, this is done
>> usually every 100ms on AP-mode. On Atom writing beacon (multiple
>> usb_bulk_msg() calls) with interrupt endpoints usually takes ~20msec
>> and this is when CPU usage goes up. By changing endpoints to bulk,
>> time to write beacon drops to 0~3msec.
>
> That's part of the problem -- the driver shouldn't use usb_bulk_msg().
> Create a bunch of URBs and submit them explicitly all at once; don't
> wait for one to finish before submitting the next.  Setting the
> URB_NO_INTERRUPT flag on all but the last could also help.  This might
> use even less CPU time than you see currently.
>

I had been experimenting with making just that, bunch of URBs, not  
waiting until end. Now I tested with URB_NO_INTERRUPT on all except  
last urb and CPU usage dropped from 10% to 2%. Thanks :)

-Jussi

