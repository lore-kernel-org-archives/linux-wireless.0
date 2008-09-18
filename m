Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:41134 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482AbYIROUA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 10:20:00 -0400
Received: from c83-252-237-76.bredband.comhem.se ([83.252.237.76]:58112 helo=tippex.mynet.homeunix.org)
	by ch-smtp02.sth.basefarm.net with esmtp (Exim 4.68)
	(envelope-from <aeriksson@fastmail.fm>)
	id 1KgKMQ-00076H-8g
	for linux-wireless@vger.kernel.org; Thu, 18 Sep 2008 16:19:59 +0200
Received: from tippex.mynet.homeunix.org (localhost [127.0.0.1])
	by tippex.mynet.homeunix.org (Postfix) with ESMTP id 0119E93CCA7
	for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 16:19:54 +0200 (CEST)
To: linux-wireless@vger.kernel.org
Subject: temorarily out of range -> no TCP?
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 18 Sep 2008 16:19:54 +0200
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080918141955.0119E93CCA7@tippex.mynet.homeunix.org> (sfid-20080918_162007_153222_33378A12)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Every so often I get sequences like this:

Sep 17 12:22:07 tippex wlan0: No ProbeResp from current AP 00:18:39:c0:5f:50 - assume out of range
Sep 17 10:25:31 tippex avahi-daemon[5117]: Withdrawing address record for 192.168.1.3 on wlan0.
Sep 17 10:25:31 tippex avahi-daemon[5117]: Leaving mDNS multicast group on interface wlan0.IPv4 with address 192.168.1.3.
Sep 17 10:25:31 tippex avahi-daemon[5117]: Interface wlan0.IPv4 no longer relevant for mDNS.
Sep 17 12:25:32 tippex wlan0: Initial auth_alg=0
Sep 17 12:25:32 tippex wlan0: authenticate with AP 00:18:39:c0:5f:50
Sep 17 12:25:32 tippex wlan0: RX authentication from 00:18:39:c0:5f:50 (alg=0 transaction=2 status=0)
Sep 17 12:25:32 tippex wlan0: authenticated
Sep 17 12:25:32 tippex wlan0: associate with AP 00:18:39:c0:5f:50
Sep 17 12:25:32 tippex wlan0: Initial auth_alg=0
Sep 17 12:25:32 tippex wlan0: authenticate with AP 00:18:39:c0:5f:50
Sep 17 12:25:32 tippex wlan0: RX authentication from 00:18:39:c0:5f:50 (alg=0 transaction=2 status=0)
Sep 17 12:25:32 tippex wlan0: authenticated
Sep 17 12:25:32 tippex wlan0: associate with AP 00:18:39:c0:5f:50
Sep 17 12:25:32 tippex wlan0: RX AssocResp from 00:18:39:c0:5f:50 (capab=0x431 status=0 aid=1)
Sep 17 12:25:32 tippex wlan0: associated
Sep 17 12:25:32 tippex wlan0: switched to short barker preamble (BSSID=00:18:39:c0:5f:50)
Sep 17 12:25:32 tippex wlan0: association frame received from 00:18:39:c0:5f:50, but not in associate state - ignored
Sep 17 10:25:33 tippex avahi-daemon[5117]: Withdrawing address record for fe80::20e:2eff:fe66:d32f on wlan0.

Even though the AP _is_ there (and other devices can talk to it ok),
the only fix is to rmmod / modprobe the driver. This is usually enough
to get the device up and running again and it can send/receive IP packets.

However, already established tcp sessions tend to never get back to life,
so your long lasting ssh sessions die.

As I have a fixed IP address for the client, I see no reason why the tcp must 
die just because the link level device is temporarily gone. IMO, it should
hang there waiting for a route to send it's packets, and a suitable route
_is_ provided when I modprobe/dhcpc the client.

Am I missing something?

/Anders 


