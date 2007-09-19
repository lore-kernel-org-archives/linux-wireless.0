Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:8731 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbXISOza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 10:55:30 -0400
Received: by py-out-1112.google.com with SMTP id u77so425988pyb
        for <linux-wireless@vger.kernel.org>; Wed, 19 Sep 2007 07:55:29 -0700 (PDT)
Message-ID: <40f31dec0709190755h5ea62e0cv578f2a5ed0788d80@mail.gmail.com>
Date: Wed, 19 Sep 2007 17:55:28 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: Re: AR5006 - should it work?
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <m3odg0dji3.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <m3odg0dji3.fsf@maximus.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/9/18, Krzysztof Halasa <khc@pm.waw.pl>:
> Hi,
>
> I'm trying to use AR5006* mini-PCI cards with no success - should
> I expect them to work with madwifi ath5k branch and/or
> linux/kernel/git/linville/wireless-dev.git ath5k branch on kernel.org?
>
> AR5004X seems to work fine.
>
> Don't work:
> ENGENIUS EMP-8602(+) 400 mW a/b/g AR5413 rev 1.0 and 1.1
> AR5006X PCI ID 168c:001b 168c:2063
>
> SparkLAN WMIA-166AG a/b/g AR5414A
> AR5006XS PCI ID 168c:001b 17f9:000d
>
> Testing with:
> # modprobe ath5k
> # ifconfig wlan0 up
> # iwlist wlan0 scan
>
> wlan0     No scan results
>
>

Are you sure 5413 didn't work ? (it has poor signal quality etc,
perhaps you can try getting closer to the AP -just for testing-).
Because it worked for me, i haven't tested 5414.  We know we don't
initialize single-chip radios the right way but we are working on
it...

That's the card i've tested...

---
02:09.0 Ethernet controller: Atheros Communications, Inc. AR5006X
802.11abg NIC (rev 01)
        Subsystem: Atheros Communications, Inc. EnGenius EMP-8602
(400mw) or Compex WLM54AG
        Flags: bus master, medium devsel, latency 168, IRQ 11
        Memory at ee010000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [44] Power Management version 2
---
168c:001b (rev 01) Subsystem: 168c:2063
---

Can you try ath_info tool ?
(http://madwifi.org/browser/trunk/tools/ath_info.c) it'll give us more
infos about your hardware ;-)

> madwifi.org ath5k dmesg (with 2.6.22 kernel, EMP-8602):
> ath5k: MAC revision: 5413  (0xa4)
> ath5k: PHY revision: SChip (0x63)
> ath5k: EEPROM version: 5.2
> wmaster0: Selected rate control algorithm 'simple'
>
> John's git repository (2.6.23-current, EMP-8602):
> wmaster0: Selected rate control algorithm 'simple'
> ath_pci 0000:00:0d.0: AR5212 chip found: mac 10.10 phy 6.1
>
> This is ARM-based system (Intel IXP425) but just tried with
> AMD64 (madwifi ath5k only) - results are the same.
>

ath5k branch on madwifi.org is more up-to-date we'll soon commit changes back

> AR5004X based card shows few devices in the neighbourhood, max
> signal ~ 20/127.

AR5004X series worked ok in all of my tests, i guess that if you try
with the binary HAL (madwifi driver) you'll get the same results.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
