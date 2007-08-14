Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:36231 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144AbXHNS3Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 14:29:24 -0400
From: Chr <chunkeey@web.de>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: Recent linux-wireless git changes have broken my prism54pci card
Date: Tue, 14 Aug 2007 20:29:19 +0200
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
References: <46BFF10B.1090307@hhs.nl> <200708140025.56708.chunkeey@web.de> <46C1638C.7070704@hhs.nl>
In-Reply-To: <46C1638C.7070704@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708142029.20057.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, 14. August 2007, Hans de Goede wrote:
> >  
> > 1. Which p54 firmware do you use? (It "must" be 2.7.0.0 for pci/cardbus)
> 2.4.12.0, extracted from the window driver for my card, any later version will 
> cause the driver to fail to load with: "Error cannot read eeprom!"

uhh, that's a pity... Well, I'm thinking about to get the FW then. The problem is that I don't have the
necessary equipment "here" for debugging (I am abroad with my old laptop and a minipci prism54 card...)

Anyway, could you please verify that the firmware at 
http://daemonizer.de/prism54/prism54-fw/fw-softmac/2.4.12.0.arm is the same one you have?
Or does it "differ"? 

> 
> > 2. What's your "average" txrate and Link Signal Level / Link Quality with and without the patches.
> >    (see iwconfig)
> See attached logs
> 
Your average speed is in the very low MBit/s and your normal Link Signal Level is only about 
40/100 (~ -80 dbm! ) ?! (The equation is roughly (rssi / 2) - 100 = dbm)

Something is fishy: take a look at the "not working" scan-13-6.  Signal level is about 62/100 
(~ -69 dbm! => much better! Did you move the laptop, or is this high value really reproducible?)

> > 3. what brand/type of AP do you have? 
> A davolink DV-201AMR its an embedded Linux device using the BCM6348 chipset,

hmm, a embedded linux? do you have a ssh/telnet access to the router? Maybe the
syslogs / dmesg gives us a "hint" why it won't connect.  
(BTW: does your router really only support the weak WEP encryptions?)

> 
> > -> what does the beacon frame look like? (or: if you don't have a
> > wlan sniffer / monitor, just run: iwlist wlanX scan )
> See logs
> 
> > 4. Can you recompile the mac80211 layer with debug options and look for
> > something like ethX: STA XX:YY:ZZ:AA:BB:CC Average rate: VVV ... in your syslogs?
> 
> See logs

phy4: not handling 0x02 type control frame.
=> It's a bit strange that you got one, it's probably because of the 2.4.12.0 Firmware.

wlan0: switched to short barker preamble.
Well, that's probably the reason why your connection always "dropped".
could you please replace all "IEEE80211_RATE_CCK_2" in p54common.h
with "IEEE80211_RATE_CCK" and report back?

> 
> > 5. are they any suspicious dmesg outputs when the "network" stops/dies?
> > 
> 
> Nope.
Yep, none!


I'll see if I can post you a "debug" driver, when I'm back at home. I'm afraid it's not
possible right now...

> 
> I've attached a tarbal with logs the FC7test logs are the logs from the Fedora 
> 7 test kernel which I normally use, as that works well.
> 
> The rest is based on a F-8 test kernel which contains a wireless-dev snapshot 
> from 26 jul 2007. The dates are dates of git checkouts from prism54common.{c,h}
> the -common one has the speed changes to prism54common.h reversed, because 
> otherwise connectivity is lost as explained.
> 
k. Do you have another wifi card that can perform wifi sniffs? (just as an option)

> I hope this helps.
> 
> Regards,
> 
> Hans
> 

Thanks,
	Chr

