Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:46724 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905AbZFMUNZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2009 16:13:25 -0400
Received: by bwz9 with SMTP id 9so2654229bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2009 13:13:26 -0700 (PDT)
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Pierre Ossman <pierre@ossman.eu>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org, san@google.com
Subject: Re: [PATCH/RFC 7/7] wl12xx: add sdio support
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
	<1244685780-28930-8-git-send-email-me@bobcopeland.com>
	<20090613132144.6c7783bc@mjolnir.ossman.eu>
	<87bposnmxi.fsf@litku.valot.fi> <1244922097.1852.4.camel@violet>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 13 Jun 2009 23:13:24 +0300
In-Reply-To: <1244922097.1852.4.camel@violet> (Marcel Holtmann's message of "Sat\, 13 Jun 2009 21\:41\:37 +0200")
Message-ID: <873aa3opsr.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcel Holtmann <marcel@holtmann.org> writes:

>> wl1251 has these lines to the host:
>> 
>> o four lines for SDIO or SPI, configured to SDIO by default
>> o power line
>> o interrupt line
>> 
>> When the power line is pulled up, the chip will power on itself.
>> Whenever the power line goes down, the chip will power off. For example,
>> the power line can be controlled with a GPIO pin from the host. But how
>> the power line is really controlled, is board specific and should be
>> handled in the board file. And here comes the set_power() function to
>> the picture. The wl1251 driver will call set_power() function every time
>> user space calls wlan interface up or down.
>> 
>> Pierre, how do you propose we should do this? I understood based on
>> discussions from linux-omap that this is a common way.
>
> actually this looks like a RFKILL hard switch to me.

I have my doubts. For example, when you turn off and on the power from
the wl1251 chip you have to reupload the firmware and boot it again,
which is slow. I have been thinking more like turning off the radios
when rfkill is enabled, which is significantly faster. But I haven't
looked at rfkill yet, and I'm not planning to do it until the dust has
settled within the next few months :)

> Why don't we just integrate it with RFKILL and this way have a common
> interface to handle all of these.

But rfkill won't solve the problem under discussion. rfkill is the
interface between wl12xx driver and higher levels, but the problem here
is the lower level interface, that is how does wl12xx driver shall
control the actual hw line. We need to have a generic way to control the
hw line so that driver works in TI's OMAP architecture, whatever Google
is using and all the other possible (embedded) combination where Linux
can run.

Because I know that my english sucks, I'll draw an architecture diagram
to show what I'm trying to say here:

---------- ------------
| rfkill | | mac80211 |
---------- ------------

-----------------------
|       wl12xx        |
-----------------------

-----------------------
|    hw power line    |
-----------------------

So rfkill is on the opposite side of wl12xx compared to the actual hw
power line.

-- 
Kalle Valo
