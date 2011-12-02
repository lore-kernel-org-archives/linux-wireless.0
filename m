Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932066Ab1LBSXc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 13:23:32 -0500
Message-ID: <1322850250.1883.9.camel@dcbw.foobar.com> (sfid-20111202_192336_066208_0BFDE07F)
Subject: Re: Trouble with Macbook Pro 8,2 (broadcom 4331) and latest b43
From: Dan Williams <dcbw@redhat.com>
To: AndrewL733 <AndrewL733@aol.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Date: Fri, 02 Dec 2011 12:24:10 -0600
In-Reply-To: <4ED9152F.5060104@aol.com>
References: <4ED3A6E8.4050000@aol.com>
	 <CACna6ryNkHeVXWXxFfod1-KQs8HQVv7wF-xpY5MA-Qs6fCypCg@mail.gmail.com>
	 <CACna6rzRJgfddE4jPivxBJCCZEyKSHsdRX7cE15rRxk2nhiRkA@mail.gmail.com>
	 <4ED3B33E.8020309@lwfinger.net> <4ED3FA65.7010104@aol.com>
	 <CACna6rw1gEjd_hcX=5hLHt0YwUqDaVBs7_MO50GLKeok57YtVw@mail.gmail.com>
	 <4ED51DB5.5090202@aol.com> <4ED52FBD.5030302@lwfinger.net>
	 <4ED5535E.50605@aol.com> <4ED56E02.6040601@lwfinger.net>
	 <CACna6rxEW9Bc6vZRPR=t=zfnA3RJoWO4Rd6m7SuY2+6_uoxuLg@mail.gmail.com>
	 <4ED9152F.5060104@aol.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-12-02 at 13:13 -0500, AndrewL733 wrote:
> On 11/30/2011 01:08 AM, Rafał Miłecki wrote:
> >> >  The table is found athttp://bcm-v4.sipsolutions.net/802.11/Init/Firmware.
> >> >  For my distro and most others, it is done automagically. The kernel reads
> >> >  the version of the 802.11 core and looks up the firmware using logic derived
> >> >  from this table. In the dmesg output, you will find a place where the
> >> >  versions of the various cores is printed. Using ucode13.fw is certainly not
> >> >  right for a 4331. I'm surprised that it works at all.
> > I'm quite sure it's some Mandriva... well - dumb... configuration that
> > doesn't affect driver at all.
> >
> > b43 uses ucode29_mimo for BCM4331
> Hello,
> 
> I am pleased to report that I got the 4331 chipset to work, thanks to 
> your help, Rafal.  Indeed, the correct firmware was ucode29_mimo.  
> Larry, I'm not sure how I could find that out from the table you 
> referred me to.  The table doesn't directly say which firmware goes with 
> 4331.  It implies which goes with the HT phy, but then again, there are 
> two listings for HT.
> 
> Anyway, is Mandriva supposed to have that table stored somewhere?  Do 
> they have an outdated version of the table (or should the table have 
> been built with the kernel or driver).  In my case, I installed an 
> updated kernel that is more recent than the distro, so that could be the 
> source of some of the problem.  Then again, I needed the updated kernel 
> to get DVD support on this machine.
> 
> Now I have one more problem.  I'm not sure where it the best place to 
> report this issue.
> 
> With Mandriva 2011, the distro switched from Mandriva's own 
> "drakx-net-applet" to "networkmanager".  With Network Manager, I can 
> connect to my wireless router.  However, the connection drops after a 
> few minutes and it continually tries to renew, succeeds, drops, renews, 
> succeeds, in an endless loop. I see many postings on various distro 
> forums about similar problems with Network Manager.  It seems to be that 
> when there is a scan for new Access Points, the current connection drops.
> 
> After unininstalling Network Manager, I can now get a reliable 
> connection to my office network by running
> 
> "iwconfig wlan0 essid mynetworkname", then
> "wpa_supplicant -Dwext -i wlan0 -c /etc/wpa_supplicant.conf" (to not run 
> in the background)
> "dhclient wlan0"
> 
> Now the connection is stable.  The question is, why is it unstable with 
> Network Manager?  Any ideas?  Is it related to the way Network Manager 
> is working with the 4331 chipset?  I have an identical Mandriva 2011 OS 

There have in the past been issues with the periodic scanning that NM
uses, but if there are these issues, they are purely driver bugs.  A
driver that cannot perform a scan while connected, and automatically
re-establish that connection after the scan is broken and should be
fixed.  This has not been a problem with the existing drivers, but
might be when support for a new driver or chipset is added to the
kernel.  It just takes a bit of time to work out all the bugs.

> installed on a slightly older Macbook Pro 5,1 with the Broadcom 4322 
> chipset, also using the b43 driver, and Network Manager does not cause 
> these disconnections. Is there another forum where it would be better to 
> post this question?

Given that it's a problem on 4331 and not on 4322 probably points to the
driver, and thus this is the correct place to discuss it for now.

If you see scan failures, that could be a problem, and it certainly
causes latency in connecting to the AP.  One thing to do to debug
NetworkManager is to:

1) stop NM
2) killall -TERM wpa_supplicant
3) wpa_supplicant -dddtu
4) start NM again

and then grab the supplicants debug output (there will be a lot of it)
and see what's going on with the supplicant when the connection drops,
and why it cannot be re-established automatically.

Dan

> Here are various outputs that may be relevant.  Am I stable because 
> scanning has somehow been disabled (output of wpa_supplicant says 
> "Failed to initiate AP scan").
> -------------------------
> 
> After "modprobe b43"
> 
> [  253.681728] bcma-pci-bridge 0000:03:00.0: PCI INT A disabled
> [  261.220288] bcma-pci-bridge 0000:03:00.0: PCI INT A -> GSI 17 (level, 
> low) -> IRQ 17
> [  261.220304] bcma-pci-bridge 0000:03:00.0: setting latency timer to 64
> [  261.220385] Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 
> 0x25, class 0x0)
> [  261.220413] Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 
> 0x1D, class 0x0)
> [  261.220475] Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x13, 
> class 0x0)
> [  261.220619] PMU resource config unknown for device 0x4331
> [  261.268986] Bus registered
> [  261.275824] cfg80211: Calling CRDA to update world regulatory domain
> [  261.282877] cfg80211: World regulatory domain updated:
> [  261.282880] cfg80211:     (start_freq - end_freq @ bandwidth), 
> (max_antenna_gain, max_eirp)
> [  261.282883] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), 
> (300 mBi, 2000 mBm)
> [  261.282885] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), 
> (300 mBi, 2000 mBm)
> [  261.282887] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), 
> (300 mBi, 2000 mBm)
> [  261.282889] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), 
> (300 mBi, 2000 mBm)
> [  261.282891] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), 
> (300 mBi, 2000 mBm)
> [  261.292595] b43-phy0: Broadcom 4331 WLAN found (core revision 29)
> [  261.293318] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> [  261.293635] Broadcom 43xx driver loaded [ Features: PMNLS ]
> [  291.326731] b43-phy0: Loading firmware version 666.2 (2011-02-23 
> 01:15:07)
> [  291.366628] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  291.395832] NET: Registered protocol family 17
> 
> After running "iwconfig wlan0 essid mynetworkname" wpa_supplicant 
> (output below) plus "dhclient wlan0"
> 
> [  292.520204] wlan0: authenticate with 48:5b:39:5b:67:27 (try 1)
> [  292.521879] wlan0: authenticated
> [  292.522267] wlan0: associate with 48:5b:39:5b:67:27 (try 1)
> [  292.524671] wlan0: RX AssocResp from 48:5b:39:5b:67:27 (capab=0x411 
> status=0 aid=7)
> [  292.524674] wlan0: associated
> [  292.525629] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [  302.842854] wlan0: no IPv6 routers present
> 
> 
> [root@andynewmac andy]# wpa_supplicant -Dwext -i wlan0 -c 
> /etc/wpa_supplicant.conf
> ioctl[SIOCSIWSCAN]: Device or resource busy
> Failed to initiate AP scan.
> Trying to associate with 48:5b:39:5b:67:27 (SSID='es-network2' freq=2412 
> MHz)
> Associated with 48:5b:39:5b:67:27
> WPA: Key negotiation completed with 48:5b:39:5b:67:27 [PTK=CCMP GTK=TKIP]
> CTRL-EVENT-CONNECTED - Connection to 48:5b:39:5b:67:27 completed (auth) 
> [id=1 id_str=]
> 
> Andy
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


