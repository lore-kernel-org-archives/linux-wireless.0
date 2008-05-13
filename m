Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:39882 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbYEMXqb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 19:46:31 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: 4311 v2 Bail - 2.6.26-rc2
Date: Wed, 14 May 2008 01:46:06 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
References: <48294F0B.4040908@f-box.org> <1210721604.4279.40.camel@johannes.berg> <1210721764.4279.41.camel@johannes.berg>
In-Reply-To: <1210721764.4279.41.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805140146.06910.mb@bu3sch.de> (sfid-20080514_014634_896544_F70C8AB0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 14 May 2008 01:36:04 Johannes Berg wrote:
> On Wed, 2008-05-14 at 01:33 +0200, Johannes Berg wrote:
> > > Where does this "wrong buffer size" message come from, and what does it mean?
> > > 
> > > > b43-phy1 debug: Using hardware based encryption for keyidx: 1, mac: 
> > > > ff:ff:ff:ff:ff:ff
> > > > wlan0: wrong buffer size<7>wlan0: wrong buffer size<7>wlan0: wrong 
> > > > buffer size<7>wlan0: wrong buffer size
> > 
> > It comes from mac80211 when the AP is sending invalid A-MSDU frames.
> 
> Wait. If this is with b43, why the hell is it sending A-MSDU frames in
> the first place? Or maybe it's receiving totally corrupt data. A monitor
> mode trace would help.


Here's the full dmesg.
Also notice "tx_ring_AC_VO: Used slots 128/128" after about 17000 successfull
frames. Weird.

> b43-phy1: Broadcom 4311 WLAN found
> b43-phy1 debug: Found PHY: Analog 4, Type 2, Revision 9
> b43-phy1 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
> b43-phy1 debug: DebugFS (CONFIG_DEBUG_FS) not enabled in kernel config
> phy1: Selected rate control algorithm 'pid'
> Broadcom 43xx driver loaded [ Features: P, Firmware-ID: FW13 ]
> firmware: requesting b43/ucode13.fw
> firmware: requesting b43/lp0initvals13.fw
> b43-phy1: Loading firmware version 410.2160 (2007-05-26 15:32:10)
> b43-phy1 debug: Chip initialized
> b43-phy1 debug: 64-bit DMA initialized
> b43-phy1 ERROR: PHY transmission error
> b43-phy1 debug: Wireless interface started
> b43-phy1 debug: Adding Interface type 2
> wlan0: Initial auth_alg=0
> wlan0: authenticate with AP 00:90:d0:f4:18:d4
> wlan0: RX authentication from 00:90:d0:f4:18:d4 (alg=0 transaction=2
> status=0)
> wlan0: authenticated
> wlan0: associate with AP 00:90:d0:f4:18:d4
> wlan0: RX AssocResp from 00:90:d0:f4:18:d4 (capab=0x411 status=0 aid=1)
> wlan0: associated
> wlan0: switched to short barker preamble (BSSID=00:90:d0:f4:18:d4)
> b43-phy1 debug: Using hardware based encryption for keyidx: 0, mac:
> 00:90:d0:f4:18:d4
> b43-phy1 debug: Using hardware based encryption for keyidx: 1, mac:
> ff:ff:ff:ff:ff:ff
> wlan0: wrong buffer size<7>wlan0: wrong buffer size<7>wlan0: wrong
> buffer size<7>wlan0: wrong buffer size
> b43-phy1 debug: Disabling hardware based encryption for keyidx: 1, mac:
> ff:ff:ff:ff:ff:ff
> b43-phy1 debug: Removing Interface type 2
> b43-phy1 debug: Wireless interface stopped
> b43-phy1 debug: DMA-64 rx_ring: Used slots 3/64, Failed frames 0/0 =
> 0.0%, Average tries 0.00
> b43-phy1 debug: DMA-64 tx_ring_AC_BK: Used slots 0/128, Failed frames
> 0/0 = 0.0%, Average tries 0.00
> b43-phy1 debug: DMA-64 tx_ring_AC_BE: Used slots 0/128, Failed frames
> 0/0 = 0.0%, Average tries 0.00
> b43-phy1 debug: DMA-64 tx_ring_AC_VI: Used slots 0/128, Failed frames
> 0/0 = 0.0%, Average tries 0.00
> b43-phy1 debug: DMA-64 tx_ring_AC_VO: Used slots 128/128, Failed frames
> 106/17766 = 0.5%, Average tries 1
> b43-phy1 debug: DMA-64 tx_ring_mcast: Used slots 0/128, Failed frames
> 0/0 = 0.0%, Average tries 0.00
> wlan0: deauthenticate(reason=3)


-- 
Greetings Michael.
