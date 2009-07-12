Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from b-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.35]:64200 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751042AbZGLUfG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2009 16:35:06 -0400
Date: Sun, 12 Jul 2009 10:34:49 -1000
From: Joel Roth <joelz@pobox.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Joel Roth <joelz@pobox.com>, linux-wireless@vger.kernel.org
Subject: Re: ath5k and Atheros AR242x - No scan results
Message-ID: <20090712203449.GA3058@sprite>
Reply-To: Joel Roth <joelz@pobox.com>
References: <20090630170916.GB5137@sprite> <20090712112340.GA3315@sprite>
 <40f31dec0907120808y45f575b6l6d83afd731e6d51@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <40f31dec0907120808y45f575b6l6d83afd731e6d51@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 12, 2009 at 06:08:19PM +0300, Nick Kossifidis wrote:
> 2009/7/12 Joel Roth <joelz@pobox.com>:
> > On Tue, Jun 30, 2009 at 07:09:16AM -1000, Joel Roth wrote:
> >> Hello all,
> >>
> >> I'd appreciate some help troubleshooting my wireless connection.
> >>
> >> I have a Toshiba Satellite L305 series laptop running Debian
> >> sid with a recent, stock Debian kernel version 2.6.29-2-486.
> >>
> >> $ lspci | grep Atheros
> >>
> >> 05:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01)
> >>
> >> I am seeking to connect to a D-Link 614+ wireless router.
> >> For initial testing, the AP is unencrypted, unsecured.
> >>
> >> My wife's G3 i-Book with AfterTheMac USB wireless adapter
> >> connected just fine, on the first try.
> >>
> >> I believe I have the modules I should have:
> >>
> >> $ lsmod | grep 80211
> >> mac80211              139680  1 ath5k
> >> cfg80211               21576  2 ath5k,mac80211
> >>
> >> My wireless network interface is present:
> >>
> >> $ iwconfig wlan0
> >>
> >> wlan0     IEEE 802.11  ESSID:""
> >>           Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
> >>           Tx-Power=0 dBm
> >>           Retry min limit:7   RTS thr:off   Fragment thr=2352 B
> >>           Link Quality:0  Signal level:0  Noise level:0
> >>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
> >>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> >>
> >> $ ifconfig wlan0
> >>
> >> wlan0     Link encap:Ethernet  HWaddr 00:21:63:82:82:40
> >>           UP BROADCAST MULTICAST  MTU:1500  Metric:1
> >>           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
> >>           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
> >>           collisions:0 txqueuelen:1000
> >>           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
> >>
> >>
> >> However, I don't find the D-Link 614+:
> >>
> >> $ iwlist wlan0 scan
> >>
> >> wlan0     No scan results
> >>
> >> And of course, dhclient fails to find a server.
> >>
> >> Am I missing something? What could I try next?
> >> I'd appreciate any pointers.
> >>
> >> Thanks.
> >
> > Okay, I'm back with a new kernel 2.6.30.1 and the latest
> > ath5k. Here are my basic diagnostics data.
> >
> > $ iwlist wlan0 scan
> >
> > wlan0     No scan results
> >
> > $ iwlist wlan0 ap
> >
> > wlan0     Interface doesn't have a list of Peers/Access-Points
> >
> > $ iwconfig wlan0
> >
> > wlan0     IEEE 802.11bg  ESSID:""
> >          Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
> >          Tx-Power=27 dBm
> >          Retry min limit:7   RTS thr:off   Fragment thr:off
> >          Power Management:off
> >          Link Quality:0  Signal level:0  Noise level:0
> >          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
> >          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> >
> > $ ifconfig wlan0
> >
> > wlan0     Link encap:Ethernet  HWaddr 00:21:63:82:82:40
> >          UP BROADCAST MULTICAST  MTU:1500  Metric:1
> >          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
> >          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
> >          collisions:0 txqueuelen:1000
> >          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
> >
> > dmesg highlights
> >
> > [    4.884157] ath5k 0000:05:00.0: enabling device (0000 -> 0002)
> > [    4.884223] ath5k 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> > [    4.884283] ath5k 0000:05:00.0: setting latency timer to 64
> > [    4.884326] ath5k 0000:05:00.0: registered as 'phy0'
> > [    6.411392] ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
> > [  337.543014] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> >
> > I compiled the kernel with debugfs support for wireless. Can someone
> > point me to helpful docs in setting this up.
> >
> > Also, is there a chance that another driver would serve me better?
> >
> > Regards,
> >
> > --
> > Joel Roth
> 
> O.K. can you try madwifi so that we can eliminate the possibility of a
> hw failure ?

My naive compile of madwifi failed; however, I was able
to boot up the factory Windows Vista.

Vista advised me to:

1) turn on the hardware wifi switch <blush>

2) use the hotkey combination to enable wifi

Then I was able to see the AP in Vista's Connect-To pane.

Rebooting under 2.6.30.1 for amd64, the driver
still doesn't find access points.

None of my hotkeys work under Linux (the toshiba_acpi
driver doesn't load), so I can't press the Fn-F8 key
combination to enable wifi. 

It may be that the wireless driver is fine, but that
I simply can't (yet) enable the hardware.

Thanks for your suggestions.

Joel


-- 
Joel Roth
