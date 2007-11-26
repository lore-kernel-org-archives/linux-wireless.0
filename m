Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbXKZPim (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 10:38:42 -0500
Subject: Re: mac80211 regression: doesn't associate automatically
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>
In-Reply-To: <200711231003.03982.hs4233@mail.mn-solutions.de>
References: <200711220912.10452.hs4233@mail.mn-solutions.de>
	 <200711230906.10441.hs4233@mail.mn-solutions.de>
	 <1195806137.12961.9.camel@dv>
	 <200711231003.03982.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Mon, 26 Nov 2007 10:34:40 -0500
Message-Id: <1196091280.4202.19.camel@localhost.localdomain> (sfid-20071126_153844_888740_201FAFEB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-11-23 at 10:03 +0100, Holger Schurig wrote:
> > Orinoco relies on roaming in the firmware
> 
> And wlags_h1_cs/wlags_h2_cs as well.
> 
> libertas_cs has half-baked roaming in firmware and in 
> kernel-space, doesn't work very well so far.
> 
> Madwifi has code coarse code roaming in the BSD borrowed 
> ieee80211 code. It roams only when it lost the association to 
> the current AP. But before doing that, it went with it's rate 
> down to 1 MBit/s, even when there's a better AP nearby that it 
> could use with 11 MBit/s or higher.
> 
> There is code in it which is disabled via "if (0 || ...)" that 
> allows for a much smoother roaming, e.g. to scan when the RSSI 
> drops below a certain level. Once enabled and after tuning of 
> some timeout variables, that roaming code works extremely well. 
> Both in a WEP-mode without wpa_supplicant and in WPA/WPA2 mode 
> with wpa_supplicant.
> 
> 
> > wpa_supplicant gives you roaming in the userspace.
> 
> Yeah, I thought in this lines as well. I have no problem putting 
> wpa_supplicant on my embedded targets. In fact, it's already 
> there, it's currently just used for WPA, not for WEP. However, 
> if suddenly NetworkManager would be needed for roaming, then 
> from an embedded-usage point of view I wouldn't like that.

The problem is, roaming and choosing which AP/BSSID to connect to is
pretty complicated.  It depends on user preferences, scan results, RSSI,
and other stuff like that.  It depends on having the necessary security
information (keys, PIN, EAP certs, etc) available.  wpa_supplicant must
run as root to be able to drive the wifi device, and many of these
settings are user-specific; so there has to be some mechanism to push
those settings down to wpa_supplicant.

You could potentially use wpa_supplicant to do what you want, based on
network block priorities and turning network blocks on/off dynamically
through the control interface.  Right now, NetworkManager just pushes
_one_ network to wpa_supplicant, the network NM wants to association
with.  I can imagine further down the line pushing more of the decisions
onto wpa_supplicant.  But wpa_supplicant seems (to me) to still have
quite a few assumptions about static configuration, which is
traditionally how it's been used.  In any case, the trend with NM is
pushing more and more of the Wifi stuff down to wpa_supplicant and to
make NetworkManager be more of a policy engine that handles many
different device types, from wired to wireless to GSM/CDMA broadband
cards to Bluetooth DUN.

Dan

