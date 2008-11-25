Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n7a.bullet.mail.ac4.yahoo.com ([76.13.13.70]:38301 "HELO
	n7a.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753094AbYKYCgr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 21:36:47 -0500
Date: Mon, 24 Nov 2008 18:30:56 -0800 (PST)
From: Irwan Siajadi <dev.bahamot@yahoo.com>
Subject: Re: ath5k: can't browse at all.
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1227552872.25089.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <630929.9910.qm@web59607.mail.ac4.yahoo.com> (sfid-20081125_033651_581239_F156268D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>




--- On Mon, 11/24/08, Dan Williams <dcbw@redhat.com> wrote:

> From: Dan Williams <dcbw@redhat.com>
> Subject: Re: ath5k: can't browse at all.
> To: "Irwan Siajadi" <dev.bahamot@yahoo.com>
> Cc: linux-wireless@vger.kernel.org
> Date: Monday, November 24, 2008, 6:54 PM
> On Mon, 2008-11-24 at 09:41 -0800, Irwan Siajadi wrote:
> > The AR2425 is able to obtain IP address from the
> router, 
> > able to ping with good results, but can't browse
> at all.
> > Below are the info on my setup, if you need more info
> please let me know.
> 
> Can you traceroute to some IP, say like 4.2.2.1 or 4.2.2.2?

Trace seems to work fine. I believe this is a driver problem because I can browse normally as soon as I changed it to ndiswrapper.

Tracepath to osnews.com (using ath5k):
 1:  192.168.1.2 (192.168.1.2)                              0.225ms pmtu 1500
 1:  home.gateway (192.168.1.254)                           1.217ms asymm 101
 1:  home.gateway (192.168.1.254)                           1.181ms asymm 101
 2:  home.gateway (192.168.1.254)                           1.186ms pmtu 1492
 2:  125.167.124.1 (125.167.124.1)                        112.890ms
 3:  125.160.1.165 (125.160.1.165)                        117.249ms
 4:  no reply
 5:  203.208.191.81 (203.208.191.81)                      513.481ms asymm 12
 6:  ge-0-1-7-0.sngtp-dr2.ix.singtel.com (203.208.151.181) 648.204ms asymm 12
 7:  ge-5-0-0-0.sngtp-cr1.ix.singtel.com (203.208.151.149) 629.931ms asymm 13
 8:  so-2-0-0-0.plapx-cr2.ix.singtel.com (203.208.149.182) 827.446ms asymm 14
 9:  ge-6-0-0-0.plapx-dr2.ix.singtel.com (203.208.183.166) 770.144ms asymm 15
10:  ge6-0-128.ir1.paloalto-ca.us.xo.net (206.111.12.45)  738.330ms asymm 15
11:  te-4-0-0.rar3.sanjose-ca.us.xo.net (207.88.12.61)    758.889ms asymm 16
12:  te-3-0-0.rar3.la-ca.us.xo.net (207.88.12.62)         770.112ms asymm 20
13:  207.88.14.33.ptr.us.xo.net (207.88.14.33)            976.042ms asymm 18
14:  207.88.14.34.ptr.us.xo.net (207.88.14.34)            814.660ms asymm 19
15:  207.88.185.74.ptr.us.xo.net (207.88.185.74)          548.507ms asymm 23
16:  border3.tge3-1-bbnet1.ext1.dal.pnap.net (216.52.191.22) 392.415ms asymm 23
17:  te2-1.cer03.dal01.dallas-datacenter.com (216.52.189.30) 400.309ms asymm 20
18:  po3.dar02.dal01.dallas-datacenter.com (66.228.118.211) 405.547ms asymm 19
19:  po2.fcr02.dal01.dallas-datacenter.com (66.228.118.182) 404.016ms asymm 20
20:  osnews.com (74.86.31.159)                            406.893ms reached
     Resume: pmtu 1492 hops 20 back 44



> 
> Dan
> 
> > Driver version: compat-wireless-2008-11-24.tar.bz2.
> > Kernel: 2.6.27.4-2mnbcustom (mandriva), compiled with
> mandriva provided 
> > ..config but without any WLAN support except
> WIRELESS_EXT.
> > Access point/router is configured to use channel 1
> (2.412GHz).
> > 
> > dmesg:
> > "...
> > cfg80211: Using static regulatory domain info
> > cfg80211: Regulatory domain: JP
> >           (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> >           (2402000 KHz - 2494000 KHz @ 40000 KHz),
> (600 mBi, 2000 mBm)
> >           (5160000 KHz - 5250000 KHz @ 40000 KHz),
> (600 mBi, 2000 mBm)
> >           (5250000 KHz - 5330000 KHz @ 40000 KHz),
> (600 mBi, 2000 mBm)
> > cfg80211: Calling CRDA for country: JP
> > .....
> > ath5k 0000:05:00.0: PCI INT A -> GSI 16 (level,
> low) -> IRQ 16
> > ath5k 0000:05:00.0: setting latency timer to 64
> > ath5k 0000:05:00.0: registered as 'phy0'
> > phy0: Selected rate control algorithm
> 'minstrel'
> > ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY:
> 0x70)
> > .....
> > wlan0: authenticate with AP 00:04:ed:42:60:67
> > wlan0: authenticated
> > wlan0: associate with AP 00:04:ed:42:60:67
> > wlan0: RX AssocResp from 00:04:ed:42:60:67
> (capab=3D0x431 status=3D0 id=3D)
> > wlan0: associated
> > ....."
> > 
> > lspci:
> > "05:00.0 Ethernet controller: Atheros
> Communications Inc. AR242x 802.11abg 
> > Wireless PCI Express Adapter (rev 01)
> >           Subsystem: Device 1a3b:1026
> >           Flags: bus master, fast devsel, latency 0,
> IRQ 16
> >           Memory at feaf0000 (64-bit,
> non-prefetchable) [size=3D64K]
> >           Capabilities: [40] Power Management version
> 2
> >           Capabilities: [50] Message Signalled
> Interrupts: Mask- 64bit Queue=3D0/0 Enable-
> >           Capabilities: [60] Express Legacy Endpoint,
> MSI 00
> >           Capabilities: [90] MSI-X: Enable- Mask-
> TabSize=3D1
> >           Capabilities: [100] Advanced Error Reporting
> <?>
> >           Capabilities: [140] Virtual Channel
> <?>"
> > 
> > TIA,
> > Irwan.
> > 
> > 
> >       
> > 
> > --
> > To unsubscribe from this list: send the line
> "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at 
> http://vger.kernel.org/majordomo-info.html


      

