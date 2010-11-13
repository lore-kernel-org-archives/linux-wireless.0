Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757636Ab0KMAXc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 19:23:32 -0500
Subject: Re: Bringing up Marvell 88W8300
From: Dan Williams <dcbw@redhat.com>
To: Denis Kirjanov <kirjanov@gmail.com>
Cc: andreamrl@tiscali.it,
	linux-wireless <linux-wireless@vger.kernel.org>,
	dwmw2@infradead.org
Date: Fri, 12 Nov 2010 18:22:20 -0600
In-Reply-To: <AANLkTik+BWQdU4hhKN7yfgOdJuQXopvYr4Z59RTntqSW@mail.gmail.com>
References: <AANLkTik+BWQdU4hhKN7yfgOdJuQXopvYr4Z59RTntqSW@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1289607742.21000.23.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-08 at 19:10 +0300, Denis Kirjanov wrote:
> Hi Andrea and wireless folks!
> 
> I'm trying to bring up my WiFi card under Linux. I've found the code
> for the mac80211 (mrv8kng).
> My card is Asus Wi-Fi-Tv card (integrated tv capturing+WiFi adapter:
> 01:0f.0 Ethernet controller: Marvell Technology Group Ltd. 88W8335
> [Libertas] 802.11b/g Wireless (rev 43).

I'd been using a Netgear WG311v3 which apparently ships with v3.1.1.7
firmware for screwing around with the driver.  I've got about 3 or 4
8335 CardBus cards lying around.

> 
> My current problem is that I can't load the firmware on the chip.
> There are two files (Win drivers) on the Asus CDROM:

I played with these a long time back based on mrv8k.  I found it tricky
to find the right firmware combo.  The firmware I got from the card's
drivers worked, but the firmware I tried to extract from the official
Marvell 8335 drivers did not work.  I've still got all the stuff around
though.

> denis@denis-desktop:~/Downloads$ ls -al CB55N50.sys CB55N51.sys
> -rw-r--r-- 1 denis denis 297856 2005-04-16 13:27 CB55N50.sys
> -rw-r--r-- 1 denis denis 297856 2005-04-16 13:26 CB55N51.sys

Hmm, one file I have (MRV8335.sys) is 339968 bytes in size.  I think the
Netgear drivers were smaller though.

> The FW cutter can't find the the main FW:
> denis@denis-desktop:~/Downloads$ ./mrv8k_extract_fw CB55N51.sys
> Bootloader found at 282088
> Firmware not found

It's pretty clear where the main firmware starts if you poke around.
The extractor has a whitelist of known firmwares and yours may not be on
it.  You might need to spend a bit of time with the hex editor and find
out approximately where your firmware starts and ends, and add that to
the list.  No guarantee that it'll actually boot on the card though.

> I also tried the firmware from the *BSD (malo firmware), but also
> without success.

Yeah, this is a problem.  Not all firmware is the same; different builds
have different things turned on or off and could well be customized by
the vendor for their specific part.  It's unclear how generic the
firmwares actually are.

> Current problem that after loading the 'main' firmware the
> MRV_REG_STATUS register is not
> equal to MRV_FW_SIGNATURE.

Yup, that means the bootloader firmware either failed to load the main
firmware correctly, that the main firmware you extracted was not in the
correct format, or that the main firmware simply failed to boot.  I've
had that problem before too.

> 
> PS: Looks like that this tree no longer available
> git://git.infradead.org/mrv8k.git :/

So I've actually got a Marvell GPL-ed 8335 "duplex" driver and firmware
(ie, STA and AP mode in one firmware file) lying around.  It's the
standard Marvell net80211-based driver built for 2.6.18 or something,
but I'm happy to post it and then you could try to (1) port the existing
net80211 stuff to 2.6.3x to make sure the card + firmware actually work,
then (2) fix up mrv8k or write a new mac80211 driver once we have the
baseline from #1.

Does that sound like a plan?  I have no time for it, but I'm happy to
put the driver up somewhere that others can make use of it.  I'll
recheck the provenience of the driver but it's got MODULE_LICENSE("GPL")
and GPL headers all over, including on the firmware file.  I might have
grabbed it off the Extranet but I'll check.

Dan


