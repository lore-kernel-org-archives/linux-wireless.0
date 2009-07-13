Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:64506 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbZGMHCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 03:02:52 -0400
Received: by fxm18 with SMTP id 18so1993750fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2009 00:02:50 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: iwl3945 dropping from network
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 13 Jul 2009 10:02:48 +0300
Message-ID: <87r5wl5alj.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Good morning,

during the weekend I have noticed that my iwl3945 is dropping from
network and wpa_supplicant can't connect to the network anymore, only
'wpa_action wlan0 stop' (which essentially quits wpa_supplicant) and
'ifup wlan0' (which starts wpa_supplicant, debian is weird here) makes
it work again. I think I'm seeing similar behaviour also when I resume.

I'm using debian unstable on Lenovo x60s with wpa_supplicant 0.6.9-3, so
the old wext interface is used. wpa_supplicant isn't updated since May
which points that this a problem in the wireless-testing kernel.

Here's one log from a situation when the connection suddenly dropped:

[201075.582192] phy0: device now idle
[201076.828989] phy0: device no longer idle - in use
[201076.828997] wlan0: direct probe to AP 00:12:17:e7:98:de (try 1)
[201076.831575] wlan0 direct probe responded
[201076.831580] wlan0: authenticate with AP 00:12:17:e7:98:de (try 1)
[201076.833491] wlan0: authenticated
[201077.028069] wlan0: associate with AP 00:12:17:e7:98:de (try 1)
[201077.030283] wlan0: RX AssocResp from 00:12:17:e7:98:de (capab=0x411
status=0 aid=2)
[201077.030289] wlan0: associated
[201077.030296] phy0: Allocated STA 00:12:17:e7:98:de
[201077.030303] phy0: Inserted STA 00:12:17:e7:98:de
[201077.032506] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[208063.200059] No probe response from AP 00:12:17:e7:98:de after 200ms,
disconnecting.
[208063.200081] phy0: device now idle
[208063.200092] phy0: Removed STA 00:12:17:e7:98:de
[208063.212054] phy0: Destroyed STA 00:12:17:e7:98:de
[208063.312201] phy0: device no longer idle - scanning
[208063.466419] phy0: device now idle
[208063.598042] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[208063.598069] phy0: device no longer idle - in use
[208063.598077] wlan0: direct probe to AP 00:12:17:e7:98:de (try 1)
[208063.599984] wlan0 direct probe responded
[208063.599990] wlan0: authenticate with AP 00:12:17:e7:98:de (try 1)
[208063.601910] wlan0: authenticated
[208063.800044] wlan0: associate with AP 00:12:17:e7:98:de (try 1)
[208063.802201] wlan0: RX AssocResp from 00:12:17:e7:98:de (capab=0x411
status=0 aid=2)
[208063.802207] wlan0: associated
[208063.802214] phy0: Allocated STA 00:12:17:e7:98:de
[208063.802221] phy0: Inserted STA 00:12:17:e7:98:de
[208063.804275] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[208066.200048] No probe response from AP 00:12:17:e7:98:de after 200ms,
disconnecting.
[208066.200073] phy0: device now idle
[208066.200083] phy0: Removed STA 00:12:17:e7:98:de
[208066.212060] phy0: Destroyed STA 00:12:17:e7:98:de
[208066.312311] phy0: device no longer idle - scanning
[208068.903824] phy0: device now idle
[208073.908401] phy0: device no longer idle - scanning
[208076.517689] phy0: device now idle
[208081.519682] phy0: device no longer idle - scanning
[208084.106036] phy0: device now idle
[208089.107114] phy0: device no longer idle - scanning
[208091.693636] phy0: device now idle
[208096.699172] phy0: device no longer idle - scanning
[208099.285510] phy0: device now idle
[208104.291055] phy0: device no longer idle - scanning
[208106.900124] phy0: device now idle
[208111.904403] phy0: device no longer idle - scanning
[208114.513533] phy0: device now idle
[208119.519072] phy0: device no longer idle - scanning
[208122.106209] phy0: device now idle

-- 
Kalle Valo
