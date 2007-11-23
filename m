Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:12453 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbXKWJCe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 04:02:34 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: mac80211 regression: doesn't associate automatically
Date: Fri, 23 Nov 2007 10:03:03 +0100
Cc: Pavel Roskin <proski@gnu.org>
References: <200711220912.10452.hs4233@mail.mn-solutions.de> <200711230906.10441.hs4233@mail.mn-solutions.de> <1195806137.12961.9.camel@dv>
In-Reply-To: <1195806137.12961.9.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200711231003.03982.hs4233@mail.mn-solutions.de> (sfid-20071123_090240_993902_438F6DDA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Orinoco relies on roaming in the firmware

And wlags_h1_cs/wlags_h2_cs as well.

libertas_cs has half-baked roaming in firmware and in 
kernel-space, doesn't work very well so far.

Madwifi has code coarse code roaming in the BSD borrowed 
ieee80211 code. It roams only when it lost the association to 
the current AP. But before doing that, it went with it's rate 
down to 1 MBit/s, even when there's a better AP nearby that it 
could use with 11 MBit/s or higher.

There is code in it which is disabled via "if (0 || ...)" that 
allows for a much smoother roaming, e.g. to scan when the RSSI 
drops below a certain level. Once enabled and after tuning of 
some timeout variables, that roaming code works extremely well. 
Both in a WEP-mode without wpa_supplicant and in WPA/WPA2 mode 
with wpa_supplicant.


> wpa_supplicant gives you roaming in the userspace.

Yeah, I thought in this lines as well. I have no problem putting 
wpa_supplicant on my embedded targets. In fact, it's already 
there, it's currently just used for WPA, not for WEP. However, 
if suddenly NetworkManager would be needed for roaming, then 
from an embedded-usage point of view I wouldn't like that.

I just don't know how good it's roaming code is, e.g. can it 
start to scan for something better if the RSSI drops below some 
threshold?  Does it have a good picture of the ever changing 
situation of AP's signal strength?  This I need to find out :-)
