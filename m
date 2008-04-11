Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mr1.bfh.ch ([147.87.250.50]:46380 "EHLO mr1.bfh.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758209AbYDKJDq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2008 05:03:46 -0400
Received: from square.bfh.ch (square.bfh.ch [147.87.224.33])
	by mr1.bfh.ch (8.13.8/8.13.8) with ESMTP id m3B8ctdC004497
	for <linux-wireless@vger.kernel.org>; Fri, 11 Apr 2008 10:39:18 +0200
Message-ID: <47FF220C.6090109@bfh.ch> (sfid-20080411_100400_540484_A11E4A8C)
Date: Fri, 11 Apr 2008 10:32:12 +0200
From: Bernhard Michael <michael.bernhard@bfh.ch>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: mac80211 does not delete beacons properly
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I'm playing around with hostapd and observed that deleting the beacon (when hostapd terminates) is not working.

Looking at the kernel code I see the reason:

In function ieee80211_del_beacon (cfg.c) the old beacon (stored in sdata->u.ap.beacon) is removed. After that ieee80211_if_config_beacon is called.

This function (ieee80211_if_config_beacon, main.c) first checks if the driver handles beacon generation itself and therefore needs to be informed. For my card (b43) this is the case. However ieee80211_beacon_get is now called which will fail because the beacon in mac80211 is already removed.

This results in a ENOMEM error message for the caller even though the beacon is 'half' removed.

I don't know how this problem could be handled properly, therefore I post just the problem description :-)

Cheers
Mike
