Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from b-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.35]:52599 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752047AbZGDTYx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 15:24:53 -0400
Date: Sat, 4 Jul 2009 09:10:58 -1000
From: Joel Roth <joelz@pobox.com>
To: Joel Roth <joelz@pobox.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath5k and Atheros AR242x - No scan results
Message-ID: <20090704191058.GA27207@sprite>
Reply-To: Joel Roth <joelz@pobox.com>
References: <20090630170916.GB5137@sprite>
 <40f31dec0906301416m39e6943ewef8d9c5bc5591880@mail.gmail.com>
 <20090701072434.GB7647@sprite>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20090701072434.GB7647@sprite>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 30, 2009 at 09:24:34PM -1000, Joel Roth wrote:
> On Wed, Jul 01, 2009 at 12:16:47AM +0300, Nick Kossifidis wrote:
> > 2009/6/30 Joel Roth <joelz@pobox.com>:
> > > Hello all,
> > >
> > > I'd appreciate some help troubleshooting my wireless connection.
> > >
> > > I have a Toshiba Satellite L305 series laptop running Debian
> > > sid with a recent, stock Debian kernel version 2.6.29-2-486.
> > >
> > > $ lspci | grep Atheros
> > >
> > > 05:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01)
> > >
> > > I am seeking to connect to a D-Link 614+ wireless router.
> > > For initial testing, the AP is unencrypted, unsecured.
> > >
> > > My wife's G3 i-Book with AfterTheMac USB wireless adapter
> > > connected just fine, on the first try.
> > >
> > > I believe I have the modules I should have:
> > >
> > > $ lsmod | grep 80211
> > > mac80211              139680  1 ath5k
> > > cfg80211               21576  2 ath5k,mac80211
> > >
> > > My wireless network interface is present:
> > >
> > > $ iwconfig wlan0
> > >
> > > wlan0     IEEE 802.11  ESSID:""
> > >          Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
> > >          Tx-Power=0 dBm
> > >          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
> > >          Link Quality:0  Signal level:0  Noise level:0
> > >          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
> > >          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> > >
> > > $ ifconfig wlan0
> > >
> > > wlan0     Link encap:Ethernet  HWaddr 00:21:63:82:82:40
> > >          UP BROADCAST MULTICAST  MTU:1500  Metric:1
> > >          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
> > >          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
> > >          collisions:0 txqueuelen:1000
> > >          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
> > >
> > >
> > > However, I don't find the D-Link 614+:
> > >
> > > $ iwlist wlan0 scan
> > >
> > > wlan0     No scan results
> > >
> > > And of course, dhclient fails to find a server.
> > >
> > > Am I missing something? What could I try next?
> > > I'd appreciate any pointers.
> > >
> > > Thanks.
> > >
> > > --
> > > Joel Roth
> > 
> > Hello ;-)
> > 
> > Can you please sent the dmesg output when ath5k loads ?
> > Also do you see any messages on dmesg while scaning ?
> 
> Hi :-)
> 
> On loading the ath5k driver, dmesg reports:
> 
> [83838.020161] ath5k 0000:05:00.0: PCI INT A disabled
> [83852.364249] cfg80211: Using static regulatory domain info
> [83852.364253] cfg80211: Regulatory domain: US
> [83852.364255]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [83852.364258]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
> [83852.364261]  (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [83852.364264]  (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [83852.364266]  (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [83852.364269]  (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [83852.364271]  (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
> [83852.364274] cfg80211: Calling CRDA for country: US
> [83852.427844] ath5k 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [83852.427858] ath5k 0000:05:00.0: setting latency timer to 64
> [83852.427916] ath5k 0000:05:00.0: registered as 'phy0'
> [83852.620221] wmaster0 (ath5k): not using net_device_ops yet
> [83852.620896] phy0: Selected rate control algorithm 'minstrel'
> [83852.620913] wlan0 (ath5k): not using net_device_ops yet
> [83852.621565] ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
>  
> On attempting to scan:
> 
> [84202.916169] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> 
> Thanks!

Is there anything I can glean from these diagnostics?
I can certainly compile a more recent version of the
driver.

Anything else I might try to get this hardware working
for me? 

Regards,

-- 
Joel Roth
