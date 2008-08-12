Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:21739 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYHLJ4a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2008 05:56:30 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Pondering: how to improve mac80211 roaming ...
Date: Tue, 12 Aug 2008 11:56:22 +0200
Cc: Jouni Malinen <j@w1.fi>
References: <200808120838.52888.hs4233@mail.mn-solutions.de> <20080812082246.GD4981@jm.kir.nu>
In-Reply-To: <20080812082246.GD4981@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808121156.22639.hs4233@mail.mn-solutions.de> (sfid-20080812_115634_393701_6B5D01F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > When I know the beacon period, I could setup a timer
> > with "beacon_period + beacon_period*0.5". In the timer
> > function I could then increase a missed beacon counter and
> > act accordingly, e.g. search for APs, roam etc.
>
> Some (most?) wlan hardware designs allow this to be done in
> firmware/hardware and that would likely be more efficient way
> of determining missed beacons.

Ahh, I see. E.g. in wireless-testing, ath5k/hw.c:

        AR5K_REG_WRITE_BITS(ah, AR5K_RSSI_THR, 
AR5K_RSSI_THR_BMISS,
                        state->bs_bmiss_threshold);

However, a grep for bs_bmiss_threshold doesn't show that it
get's ever set. The whole section is also marked with #if 0 ...
#endif.




Reporting events from the driver
--------------------------------
How would a driver report beacon miss to mac80211?  A function,
incrementing some variable in some structure?  How does this
variable get decremented?

Surely it would be set to zero at association time, but maybe the
value should degrade over time (e.g. it advanced to 6 while I was
at the edge of the AP area, but then I move back into good 
coverage).

So maybe the driver calls

   void mac80211_notify_missed_beacon(struct ieee80211_hw *hw, 
u32 count)

Then mac80211 could do the increment/decrement things common for 
all
drivers. The other function:

To report a too-low SNR/RSSI, we could re-use
ieee80211_notify_mac(). We could also add a new parameter to
ieee80211_notify_mac() to that we can transport some data via it,
besides the event. This way we wouldn't need a new function
mac80211_notify_missed_beacon().



Announing capabilities
----------------------
Somehow mac80211 needs to send the thresshold to the drivers ---
or do it on it's own. So we need some kind of capability bits.

So maybe I need:

IEEE80211_HW_BEACON_MISSED
IEEE80211_HW_LOW_SIGNAL

(ath5k supports RSSI threshold, maybe other HW supports SNR
threshhold?  And do we have the usual dB vs. dBm problem here?).

We could also forget about RSSI/SNR dB/dBm and just
use "sensitity" from 0..n (e.g. 0..3), with:

0: don't try to roam
1: try to stay at current AP quite long
2: middle ground
3: roam quickly

IEEE80211_HW_SENS_THRESHOLD



If the driver doesn't support either of this, then mac80211
could do that on it's own. I'd actually try to get this
functionality working first.


> cfg80211 lacks a command for request new scans

But that is something that I currently don't want to do. A scan 
command can be quite complicated, e.g. scan active (with probe 
requests), scan passive etc etc etc. For me this is another 
problem to tackle :-)

> > For a WEP or non-encrypted environment a in-kernel-roaming
> > would be possible, this would bring a similar behavior to
> > mac80211 that common fullmac drivers exhibit. But my first
> > goal would not be in this area.
>
> That should not be limited to just WEP or plaintext. If
> mac80211 reports association even to a new BSS, wpa_supplicant
> should be able to complete WPA/IEEE 802.1X handshake with the
> new AP after that.

Ah, good to know :-)
