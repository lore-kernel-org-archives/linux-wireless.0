Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:63898 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbZLPEYc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 23:24:32 -0500
Received: by yxe17 with SMTP id 17so597350yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 15 Dec 2009 20:24:31 -0800 (PST)
Subject: Re: mac80211 or ath9k? No connect to other band after resume
From: ASIC Felix <ic.felix@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1260811456.2442.422.camel@johannes.local>
References: <1260811290.2612.21.camel@darkslate>
	 <1260811456.2442.422.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 15 Dec 2009 20:24:25 -0800
Message-Id: <1260937465.12734.6.camel@darkslate>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-12-14 at 18:24 +0100, Johannes Berg wrote:
> On Mon, 2009-12-14 at 09:21 -0800, ASIC Felix wrote:
> > Hi,
> > 
> > I found a suspend/resume bug.
> > Kernel 2.6.32-wl-45997-gf02c03a master-2009-12-07
> > 
> > To reproduce:
> > - connect to 2G network (my office)
> > - pm-suspend
> > - resume (at home, wpa_supplicant.conf only has 5G home network)
> > - laptop only scans 2G, never sees 5G AP
> > - workaround: 
> >     /etc/init.d/network stop
> >     rmmod bla bla bla
> >     modprobe ath9k
> >     /etc/init.d/network start
> > - now laptop reconnects
> 
> I'd guess regulatory -- enable debugging for that please.
> 
> johannes


yep, does looke like regulatory after pm-suspend, mcgrof?
Felix


PM: Finishing wakeup.
Restarting tasks ... 
hub 5-0:1.0: over-current change on port 3
done.
hub 5-0:1.0: over-current change on port 4
hub 2-0:1.0: over-current change on port 1
hub 2-0:1.0: over-current change on port 2
usb 3-2: reset full speed USB device using uhci_hcd and address 3
cfg80211: Calling CRDA for country: US
cfg80211: Current regulatory domain intersected: 
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
tg3 0000:02:00.0: PME# disabled
ath9k: Two wiphys trying to scan at the same time

] /etc/init.d/network stop
] rmmod blbalba; modprobe ath9k
] /etc/init.d/network start

tg3 0000:02:00.0: PME# enabled
ath9k 0000:04:02.0: PCI INT A disabled
ath9k: Driver unloaded
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
    (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
ath9k 0000:04:02.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
ath: EEPROM regdomain: 0x0
ath: EEPROM indicates default country code should be used
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x3a
ath: Country alpha2 being used: US
ath: Regpair used: 0x3a
phy0: Selected rate control algorithm 'ath9k_rate_control'
cfg80211: Calling CRDA for country: US
Registered led device: ath9k-phy0::radio
Registered led device: ath9k-phy0::assoc
Registered led device: ath9k-phy0::tx
Registered led device: ath9k-phy0::rx
phy0: Atheros AR9280 Rev:2 mem=0xfad00000, irq=21
cfg80211: Regulatory domain changed to country: US
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
    (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
    (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
tg3 0000:02:00.0: PME# disabled
cfg80211: Found new beacon on frequency: 5180 MHz (Ch 36) on phy0
wlan0: direct probe to AP 00:24:01:45:51:41 (try 1)
wlan0: direct probe responded
wlan0: authenticate with AP 00:24:01:45:51:41 (try 1)
wlan0: authenticated
wlan0: associate with AP 00:24:01:45:51:41 (try 1)
wlan0: RX AssocResp from 00:24:01:45:51:41 (capab=0x111 status=0 aid=2)
wlan0: associated
martian source 255.255.255.255 from 192.168.10.1, on dev wlan0
ll header: ff:ff:ff:ff:ff:ff:00:24:01:45:51:3f:08:00
martian source 255.255.255.255 from 192.168.10.1, on dev wlan0
ll header: ff:ff:ff:ff:ff:ff:00:24:01:45:51:3f:08:00
martian source 255.255.255.255 from 192.168.10.1, on dev wlan0
ll header: ff:ff:ff:ff:ff:ff:00:24:01:45:51:3f:08:00


