Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out12.libero.it ([212.52.84.112]:42932 "EHLO
	cp-out12.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581AbZCaQzU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 12:55:20 -0400
From: Fabio Rossi <rossi.f@inwind.it>
To: Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH 3/3] ath5k: Add tx power calibration support
Date: Tue, 31 Mar 2009 18:54:00 +0200
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
References: <20090315202035.GC5246@makis> <200903311158.57947.rossi.f@inwind.it> <40f31dec0903310906h49cbbcc7pa12bf3a9f2799a9a@mail.gmail.com>
In-Reply-To: <40f31dec0903310906h49cbbcc7pa12bf3a9f2799a9a@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200903311854.01494.rossi.f@inwind.it> (sfid-20090331_185546_050628_CCD946B8)
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 31 March 2009, Nick Kossifidis wrote:
> 2009/3/31 Fabio Rossi <rossi.f@inwind.it>:
> > On Tuesday 31 March 2009, Nick Kossifidis wrote:
> >> > 2009/3/30 Fabio Rossi <rossi.f@inwind.it>:
> >> > I have discovered the problem. Inside ath5k_hx_txpower() it's called
> >> > ath5k_setup_channel_powertable() where the gain curves of frequency
> >> > piers are scanned (if I have understood correctly) to extract the data
> >> > for the calibration of the current channel.
> >> >
> >> > In particular, for the 5180MHz channel (the first of the A band), the
> >> > function ath5k_get_linear_pcdac_min() is called with some critical
> >> > data which generate an endless while loop.
> >> >
> >> > Here are the bad numbers passed to ath5k_get_linear_pcdac_min():
> >> > * pwrL[0] = 4
> >> > * pwrL[1] = 4
> >> > * stepL[0] = 20
> >> > * stepL[1] = 35
> >> > and with this configuration the variable 'tmp' is never decremented
> >> > inside the first while loop.
> >> >
> >> > I suppose the data comes from the EEPROM. Is there an easy way to read
> >> > the contents of the EEPROM regarding the calibration data for all the
> >> > channels?
> >> >
> >> > Fabio
> >>
> >> Nice catch ;-)
> >>
> >> It's weird that your EEPROM contains a value twice, both pwrL[0] and
> >> pwrL[1] are 4 so interpolation always returns 4 and tmp is always > 1
> >> so you have an endless loop. This is not what we expect to have on
> >> EEPROM (we are supposed to have a monotonicaly increasing curve and in
> >> your case it should be almost linear). Anyway since we have such cards
> >> we just need to put a check there and where pwrL[0] == pwrL[1], we set
> >> tmp = stepL[0] or if pwrR[0] == pwrR[1], we set tmp = stepR[0]. Try
> >> this out and see how it goes...
> >
> > Here is the full dump of the power levels inside my board EEPROM:
> >
> > channel freq 2412,
> > ath5k_get_linear_pcdac_min pwrL[0]=-119, pwrL[1]=-96, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=-119, pwrR[1]=-96,
> > stepR[0]=20, stepR[1]=35 channel freq 2417,
> > ath5k_get_linear_pcdac_min pwrL[0]=-119, pwrL[1]=-96, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=-106, pwrR[1]=-58,
> > stepR[0]=20, stepR[1]=35 channel freq 2422,
> > ath5k_get_linear_pcdac_min pwrL[0]=-119, pwrL[1]=-96, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=-106, pwrR[1]=-58,
> > stepR[0]=20, stepR[1]=35 channel freq 2427,
> > ath5k_get_linear_pcdac_min pwrL[0]=-119, pwrL[1]=-96, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=-106, pwrR[1]=-58,
> > stepR[0]=20, stepR[1]=35 channel freq 2432,
> > ath5k_get_linear_pcdac_min pwrL[0]=-119, pwrL[1]=-96, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=-106, pwrR[1]=-58,
> > stepR[0]=20, stepR[1]=35 channel freq 2437,
> > ath5k_get_linear_pcdac_min pwrL[0]=-119, pwrL[1]=-96, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=-106, pwrR[1]=-58,
> > stepR[0]=20, stepR[1]=35 channel freq 2442,
> > ath5k_get_linear_pcdac_min pwrL[0]=-119, pwrL[1]=-96, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=-106, pwrR[1]=-58,
> > stepR[0]=20, stepR[1]=35 channel freq 2447,
> > ath5k_get_linear_pcdac_min pwrL[0]=-119, pwrL[1]=-96, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=-106, pwrR[1]=-58,
> > stepR[0]=20, stepR[1]=35 channel freq 2452,
> > ath5k_get_linear_pcdac_min pwrL[0]=-119, pwrL[1]=-96, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=-106, pwrR[1]=-58,
> > stepR[0]=20, stepR[1]=35 channel freq 2457,
> > ath5k_get_linear_pcdac_min pwrL[0]=-119, pwrL[1]=-96, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=-106, pwrR[1]=-58,
> > stepR[0]=20, stepR[1]=35 channel freq 2462,
> > ath5k_get_linear_pcdac_min pwrL[0]=-119, pwrL[1]=-96, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=-106, pwrR[1]=-58,
> > stepR[0]=20, stepR[1]=35 channel freq 2467,
> > ath5k_get_linear_pcdac_min pwrL[0]=-119, pwrL[1]=-96, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=-106, pwrR[1]=-58,
> > stepR[0]=20, stepR[1]=35 channel freq 2472,
> > ath5k_get_linear_pcdac_min pwrL[0]=-119, pwrL[1]=-96, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=-106, pwrR[1]=-58,
> > stepR[0]=20, stepR[1]=35 channel freq 2484,
> > ath5k_get_linear_pcdac_min pwrL[0]=-106, pwrL[1]=-58, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=-106, pwrR[1]=-58,
> > stepR[0]=20, stepR[1]=35 channel freq 5180,
> > ath5k_get_linear_pcdac_min pwrL[0]=4, pwrL[1]=4, stepL[0]=20, stepL[1]=35
> > ath5k_get_linear_pcdac_min pwrR[0]=13, pwrR[1]=13, stepR[0]=20,
> > stepR[1]=35 channel freq 5185,
> > ath5k_get_linear_pcdac_min pwrL[0]=4, pwrL[1]=4, stepL[0]=20, stepL[1]=35
> > ath5k_get_linear_pcdac_min pwrR[0]=13, pwrR[1]=13, stepR[0]=20,
> > stepR[1]=35 channel freq 5190,
> > ath5k_get_linear_pcdac_min pwrL[0]=4, pwrL[1]=4, stepL[0]=20, stepL[1]=35
> > ath5k_get_linear_pcdac_min pwrR[0]=13, pwrR[1]=13, stepR[0]=20,
> > stepR[1]=35 channel freq 5195,
> > ath5k_get_linear_pcdac_min pwrL[0]=4, pwrL[1]=4, stepL[0]=20, stepL[1]=35
> > ath5k_get_linear_pcdac_min pwrR[0]=13, pwrR[1]=13, stepR[0]=20,
> > stepR[1]=35 channel freq 5200,
> > ath5k_get_linear_pcdac_min pwrL[0]=4, pwrL[1]=4, stepL[0]=20, stepL[1]=35
> > ath5k_get_linear_pcdac_min pwrR[0]=13, pwrR[1]=13, stepR[0]=20,
> > stepR[1]=35 channel freq 5205,
> > ath5k_get_linear_pcdac_min pwrL[0]=4, pwrL[1]=4, stepL[0]=20, stepL[1]=35
> > ath5k_get_linear_pcdac_min pwrR[0]=13, pwrR[1]=13, stepR[0]=20,
> > stepR[1]=35 channel freq 5210,
> > ath5k_get_linear_pcdac_min pwrL[0]=4, pwrL[1]=4, stepL[0]=20, stepL[1]=35
> > ath5k_get_linear_pcdac_min pwrR[0]=13, pwrR[1]=13, stepR[0]=20,
> > stepR[1]=35 channel freq 5215,
> > ath5k_get_linear_pcdac_min pwrL[0]=4, pwrL[1]=4, stepL[0]=20, stepL[1]=35
> > ath5k_get_linear_pcdac_min pwrR[0]=13, pwrR[1]=13, stepR[0]=20,
> > stepR[1]=35 channel freq 5220,
> > ath5k_get_linear_pcdac_min pwrL[0]=4, pwrL[1]=4, stepL[0]=20, stepL[1]=35
> > ath5k_get_linear_pcdac_min pwrR[0]=13, pwrR[1]=13, stepR[0]=20,
> > stepR[1]=35 channel freq 5225,
> > ath5k_get_linear_pcdac_min pwrL[0]=4, pwrL[1]=4, stepL[0]=20, stepL[1]=35
> > ath5k_get_linear_pcdac_min pwrR[0]=13, pwrR[1]=13, stepR[0]=20,
> > stepR[1]=35 channel freq 5230,
> > ath5k_get_linear_pcdac_min pwrL[0]=13, pwrL[1]=13, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=13, pwrR[1]=13,
> > stepR[0]=20, stepR[1]=35 channel freq 5235,
> > ath5k_get_linear_pcdac_min pwrL[0]=13, pwrL[1]=13, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=8, pwrR[1]=9, stepR[0]=20,
> > stepR[1]=35 channel freq 5240,
> > ath5k_get_linear_pcdac_min pwrL[0]=13, pwrL[1]=13, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=8, pwrR[1]=9, stepR[0]=20,
> > stepR[1]=35 channel freq 5745,
> > ath5k_get_linear_pcdac_min pwrL[0]=8, pwrL[1]=26, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=11, pwrR[1]=28,
> > stepR[0]=20, stepR[1]=35 channel freq 5750,
> > ath5k_get_linear_pcdac_min pwrL[0]=8, pwrL[1]=26, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=11, pwrR[1]=28,
> > stepR[0]=20, stepR[1]=35 channel freq 5755,
> > ath5k_get_linear_pcdac_min pwrL[0]=8, pwrL[1]=26, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=11, pwrR[1]=28,
> > stepR[0]=20, stepR[1]=35 channel freq 5760,
> > ath5k_get_linear_pcdac_min pwrL[0]=8, pwrL[1]=26, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=11, pwrR[1]=28,
> > stepR[0]=20, stepR[1]=35 channel freq 5765,
> > ath5k_get_linear_pcdac_min pwrL[0]=8, pwrL[1]=26, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=11, pwrR[1]=28,
> > stepR[0]=20, stepR[1]=35 channel freq 5770,
> > ath5k_get_linear_pcdac_min pwrL[0]=8, pwrL[1]=26, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=11, pwrR[1]=28,
> > stepR[0]=20, stepR[1]=35 channel freq 5775,
> > ath5k_get_linear_pcdac_min pwrL[0]=8, pwrL[1]=26, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=11, pwrR[1]=28,
> > stepR[0]=20, stepR[1]=35 channel freq 5780,
> > ath5k_get_linear_pcdac_min pwrL[0]=8, pwrL[1]=26, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=11, pwrR[1]=28,
> > stepR[0]=20, stepR[1]=35 channel freq 5785,
> > ath5k_get_linear_pcdac_min pwrL[0]=8, pwrL[1]=26, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=11, pwrR[1]=28,
> > stepR[0]=20, stepR[1]=35 channel freq 5790,
> > ath5k_get_linear_pcdac_min pwrL[0]=8, pwrL[1]=26, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=11, pwrR[1]=28,
> > stepR[0]=20, stepR[1]=35 channel freq 5795,
> > ath5k_get_linear_pcdac_min pwrL[0]=8, pwrL[1]=26, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=11, pwrR[1]=28,
> > stepR[0]=20, stepR[1]=35 channel freq 5800,
> > ath5k_get_linear_pcdac_min pwrL[0]=8, pwrL[1]=26, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=11, pwrR[1]=28,
> > stepR[0]=20, stepR[1]=35 channel freq 5805,
> > ath5k_get_linear_pcdac_min pwrL[0]=8, pwrL[1]=26, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=11, pwrR[1]=28,
> > stepR[0]=20, stepR[1]=35 channel freq 5810,
> > ath5k_get_linear_pcdac_min pwrL[0]=8, pwrL[1]=26, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=11, pwrR[1]=28,
> > stepR[0]=20, stepR[1]=35 channel freq 5815,
> > ath5k_get_linear_pcdac_min pwrL[0]=8, pwrL[1]=26, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=11, pwrR[1]=28,
> > stepR[0]=20, stepR[1]=35 channel freq 5820,
> > ath5k_get_linear_pcdac_min pwrL[0]=8, pwrL[1]=26, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=11, pwrR[1]=28,
> > stepR[0]=20, stepR[1]=35 channel freq 5825,
> > ath5k_get_linear_pcdac_min pwrL[0]=11, pwrL[1]=28, stepL[0]=20,
> > stepL[1]=35 ath5k_get_linear_pcdac_min pwrR[0]=11, pwrR[1]=28,
> > stepR[0]=20, stepR[1]=35
> >
> > As you can see the problem is related only to the frequency range
> > 5180-5240MHz. I'll post a separate patch to solve the issue, please add
> > your favourite tag.
> >
> > Fabio
>
> Any other issues after the patch ?

I have other issues regarding the "stability" of the connection getting this 
log

cfg80211: Calling CRDA to update world regulatory domain
ath5k 0000:00:0b.0: PCI INT A -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
ath5k 0000:00:0b.0: registered as 'phy0'
phy0: Selected rate control algorithm 'minstrel'
ath5k phy0: Atheros AR5212 chip found (MAC: 0x56, PHY: 0x41)
ath5k phy0: RF5112B multiband radio found (0x36)
udev: renamed network interface wlan0 to ath0
ath0: authenticate with AP 00:0c:f6:xx:xx:xx
ath0: authenticated
ath0: associate with AP 00:0c:f6:xx:xx:xx
ath0: RX AssocResp from 00:0c:f6:xx:xx:xx (capab=0x411 status=0 aid=2)
ath0: associated
phy0: Allocated STA 00:0c:f6:xx:xx:xx
phy0: Inserted STA 00:0c:f6:xx:xx:xx
ath0: switched to short slot time (BSSID=00:0c:f6:xx:xx:xx)
ath0: no probe response from AP 00:0c:f6:xx:xx:xx - disassociating
phy0: Removed STA 00:0c:f6:xx:xx:xx
phy0: Destroyed STA 00:0c:f6:xx:xx:xx

i.e. soon after the association with the AP I'm also disassociated. The 
problem is that I cannot associate anymore with the "iwconfig ath0 essid" 
command, I have to remove and load again the ath5k module. I haven't 
investigated about this problem yet but it doesn't seem strictly related to 
your tx power calibration patch.

Fabio
