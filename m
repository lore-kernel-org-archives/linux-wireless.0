Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:58335 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab1BDRLF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 12:11:05 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PlPBW-0000zW-6a
	for linux-wireless@vger.kernel.org; Fri, 04 Feb 2011 18:11:02 +0100
Received: from san_juan-143-68.umh.es ([san_juan-143-68.umh.es])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 04 Feb 2011 18:11:02 +0100
Received: from baldo.ath9k by san_juan-143-68.umh.es with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 04 Feb 2011 18:11:02 +0100
To: linux-wireless@vger.kernel.org
From: Baldomero Coll <baldo.ath9k@gmail.com>
Subject: Re: [RFC] mac80211: support for IEEE80211N in IBSS
Date: Fri, 4 Feb 2011 17:10:44 +0000 (UTC)
Message-ID: <loom.20110204T175104-690@post.gmane.org>
References: <201101191438.01161.alexander.simon@saxnet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


1)When I join/create the HT IBSS network (iw dev wlan0 ibss join baldoHT 2412
HT20),my wireless card tries to scan and create several network with different
BSSID. [1]

This command [*] should create it.

2)And if I join/create the HT IBSS network adding fixed-freq and fixed-BSSID it
happends the same! [2].

Based on the command [*], why it tries to create new BSSIDs?

[*]
Join the IBSS cell with the given SSID, if it doesn't exist create it on the
given frequency. When fixed frequency is requested, don't join/create a cell on
a different frequency. When a fixed BSSID is requested use that BSSID and do not
adopt another cell's BSSID even if it has higher TSF and the same SSID.

[1]
Feb  4 17:47:29 uwicore-desktop kernel: [ 3618.354382] wlan0: Creating new IBSS
network, BSSID 5a:48:a7:db:3d:e5
Feb  4 17:47:30 uwicore-desktop wpa_supplicant[900]: No network configuration
found for the current AP
...
Feb  4 17:49:31 uwicore-desktop kernel: [ 3739.988024] wlan0: Trigger new scan
to find an IBSS to join
Feb  4 17:49:41 uwicore-desktop kernel: [ 3750.263484] wlan0: Creating new IBSS
network, BSSID 52:89:c5:d0:53:19
Feb  4 17:49:42 uwicore-desktop wpa_supplicant[900]: No network configuration
found for the current AP
Feb  4 17:49:44 uwicore-desktop kernel: [ 3753.000025] wlan0: Trigger new scan
to find an IBSS to join

[2]
Feb  4 17:55:17 uwicore-desktop kernel: [ 4085.420015] wlan0: Creating new IBSS
network, BSSID 11:11:11:11:11:11
Feb  4 17:55:17 uwicore-desktop wpa_supplicant[900]: No network configuration
found for the current AP
Feb  4 17:55:19 uwicore-desktop kernel: [ 4087.988026] wlan0: Trigger new scan
to find an IBSS to join
Feb  4 17:55:29 uwicore-desktop kernel: [ 4098.274430] wlan0: Creating new IBSS
network, BSSID 8a:28:f2:8f:0f:b4
Feb  4 17:55:30 uwicore-desktop wpa_supplicant[900]: No network configuration
found for the current AP
Feb  4 17:55:32 uwicore-desktop kernel: [ 4101.000037] wlan0: Trigger new scan
to find an IBSS to join
Feb  4 17:55:42 uwicore-desktop kernel: [ 4111.282690] wlan0: Creating new IBSS
network, BSSID ee:35:37:46:4c:66


Baldomero Coll

