Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41493 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932602AbZHUVLl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 17:11:41 -0400
Message-ID: <4A8F0D8D.7000508@gmx.de>
Date: Fri, 21 Aug 2009 23:11:41 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: mac80211: reassociate in STA mode after AP was power-cycled
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I had a ar9170usb device in STA mode associated to an AP and power-cycled the AP - slowly enough to get the
STA disassociated. 

I wonder why the STA doesn't re-associate again to the AP once it's up again. Waited for 5+ minutes.

I see the AP in the output of "iwlist wlan1 scan" and after "ifconfig wlan1 down; ifconfig wlan1 up"
the STA associates quickly.

wireless-testing from today, v2.6.31-rc6-31653-g0dfdb6f.

Some lines from syslog, between "ifconfig wlan1 up" and powering off the AP:

Aug 21 22:55:33 nc10 kernel: [ 1854.824443] wlan1: direct probe to AP 00:30:f1:d5:2e:69 (try 1)
Aug 21 22:55:33 nc10 kernel: [ 1854.826914] wlan1 direct probe responded
Aug 21 22:55:33 nc10 kernel: [ 1854.826930] wlan1: authenticate with AP 00:30:f1:d5:2e:69 (try 1)
Aug 21 22:55:33 nc10 kernel: [ 1854.830003] wlan1: authenticated
Aug 21 22:55:33 nc10 kernel: [ 1854.837585] wlan1: associate with AP 00:30:f1:d5:2e:69 (try 1)
Aug 21 22:55:33 nc10 kernel: [ 1854.839656] wlan1: RX AssocResp from 00:30:f1:d5:2e:69 (capab=0x421 status=0 aid=5)
Aug 21 22:55:33 nc10 kernel: [ 1854.839670] wlan1: associated
Aug 21 22:55:33 nc10 kernel: [ 1854.847296] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
Aug 21 22:55:45 nc10 kernel: [ 1867.500169] No probe response from AP 00:30:f1:d5:2e:69 after 500ms, disconnecting.

Regards,
Jörg.
