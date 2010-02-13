Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 29.mail-out.ovh.net ([87.98.216.213]:45083 "HELO
	29.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753291Ab0BMIin (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Feb 2010 03:38:43 -0500
Message-ID: <4B76637E.8040709@free.fr>
Date: Sat, 13 Feb 2010 09:31:58 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Daniel Golle <daniel.golle@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: some ideas about pseudo_adhoc (as rtl8187 cannot do beacon generation)
References: <4B750C6E.9000208@gmail.com>
In-Reply-To: <4B750C6E.9000208@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Golle a écrit :
> hi!
> i've got an rtl8187l and want to use it in Ad-Hoc mode (actually 
> pseudo_adhoc would actually even be enough!). i researched a little 
> bit and found out that ad-hoc-, master- and mesh-mode are unsupported 
> due to the lack of beacon generation support in the mac80211 version 
> of the rtl8187 driver.
> as the softmac card probably doesn't support generating beacons in 
> firmware, does that mean we need to setup a beacon generation fork 
> repeatedly calling
> ieee80211_beacon_get
> and then sending the beacon? (very roughly, i'm guessing after reading 
> any 802.11 code for 20 minutes)
> probably a timing-critical task which needs to bypass the usual 
> buffers and such i can imagine...
TSF synchronisation is indeed critical since lots of mecanism like 
power-save, IBSS merges, ... requires a proper TSF. I don't know how 
accurate kernel timers are, but they might not match the IBSS expectation.
>
> anyway. pseudo_adhoc (i.e. ad-hoc without beacons) is a nice thing and 
> works great for use with user-space mesh-routing solutions such as 
> OLSR, batman or babel. however, i guess as pseudo_adhoc is violating 
> the standards (though it is very usefull) it might never be supported 
> by anything else than proprietary drivers made by Atheros (afaik).
>
> so. i want to use this hardware (RTL8187L) for this task (OLSR). any 
> ideas? where should i start wasting my brain-time?
Pseudo-IBSS is just like IBSS except :
- you don't send beacons
- BSSID is fixed at 00:00:00:00:00:00 (so SSID is useless .... and since 
there's no beacon anyway).

Maybe you could image an IBSS-like mode where :
- you don't send beacons (or at least don't rely on them)
- you still reply to Probe Request by Probe Response (so you can still 
scan, search for an SSID and synchronize the BSSID). However, you can 
have splits without proper handling of IBSS merges...

I would implement this latter since it's closer to the standard 802.11 
IBSS mode, which means less modifications in current and less 
interoperability problems.

>
> ot: anyone ever tried compiling the FullMAC r8187 driver (aircrack) 
> for Atheros/MIPS systems?
>
> cheers
>
> daniel
Regards,
Benoit

