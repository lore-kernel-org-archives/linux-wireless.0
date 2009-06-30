Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:36147 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbZF3WuY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 18:50:24 -0400
Received: by gxk26 with SMTP id 26so776814gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2009 15:50:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6c354a1a0906301524m389d49a9sfd812e1ea4740ff5@mail.gmail.com>
References: <6c354a1a0906301524m389d49a9sfd812e1ea4740ff5@mail.gmail.com>
Date: Tue, 30 Jun 2009 18:50:26 -0400
Message-ID: <6c354a1a0906301550g70fbd9ddkecd09fc0e98dd1ef@mail.gmail.com>
Subject: Fwd: kernel .30 BROKE ATH5K with my AR5212 atheros.
From: Jasin Colegrove <j.wholesalesupply@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---------- Forwarded message ----------
From: Jasin Colegrove <j.wholesalesupply@gmail.com>
Date: Tue, Jun 30, 2009 at 6:24 PM
Subject: kernel .30 BROKE ATH5K with my AR5212 atheros.
To: linux-wireless@vger.kernel.org


I AM NOT A SUBSCRIBER. Please reply to me directly at this e-mail
address j.wholesalesupply@gmail.com

lspci -vvvvvvvvvv

02:02.0 Ethernet controller: Atheros Communications Inc. AR5212
802.11abg NIC (rev 01)
    Subsystem: Phillips Components Device 8331
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 168 (2500ns min, 7000ns max), Cache Line Size: 32 bytes
    Interrupt: pin A routed to IRQ 11
    Region 0: Memory at c0200000 (32-bit, non-prefetchable) [size=64K]
    Capabilities: <access denied>
    Kernel driver in use: ath5k
    Kernel modules: ath5k


$ lsmod | grep ath
ath5k                 107192  0
mac80211              158652  1 ath5k
led_class               3416  2 thinkpad_acpi,ath5k
cfg80211               36524  2 ath5k,mac80211

Once I installed and ran the .30 release on my laptop my internet
connection was down. Wicd reported that the ping failed because it did
not recieve a response from the access point.  So I started checking
things out, I have no wpa/wep security. I have no mac filtering. If I
try using a static IP to the router, the manual method of ifconfig
192.168.1.4; route add default gw 192.168.1.1 works, but I can not
ping anything outside of my localhost. Pinging the gateway fails,
pinging other computers on the network fails. If I try dhcp, it
timesout waiting for an ip and same thing, no ping outside of
localhost, as expected.

Then I decided to see if it the card was working, So I tried to iwlist
wlan0 scan, it returned the expected results. It see's the multiple
AP's in my area. The card seems fine.

That got me to thinking, maybe I should downgrade the kernel and see
if it works, as soon as i rebooted into .29 kernel release the
authentication to the AP went through and i could ping the gw, other
networked computers etc.

There is clearly a problem with the .30 release of ath5k module using
the atheros chipset AR5212. I would be glad to offer up as much
information as I can, but I don't have the slightest on how to debug
this issue? Any help on that issue is much appreciated. Where can I
file the appropriate bug and what information do I need to post from a
technical standpoint. I am rather competent with linux and the command
line so if i can be of some use researching this bug please let me
know what I can do to help

I am also using the ath9k module on my desktop pc with an atheros
AR5008 and the .30 kernel release and everything works as expected.
this problem seems specific to the ath5k module.
