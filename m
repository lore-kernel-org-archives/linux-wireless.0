Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60646 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217AbbHXMh1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2015 08:37:27 -0400
Message-ID: <1440419844.3735.14.camel@sipsolutions.net> (sfid-20150824_143730_385915_220FC623)
Subject: Re: linux-only "freshness" auth problem??
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Tokarev <mjt@tls.msk.ru>, linux-wireless@vger.kernel.org
Date: Mon, 24 Aug 2015 14:37:24 +0200
In-Reply-To: <55D8352E.9040702@msgid.tls.msk.ru>
References: <55D6F0DB.5050505@msgid.tls.msk.ru>
		 (sfid-20150821_114437_353307_BC6FA2E1) <1440152186.2107.14.camel@sipsolutions.net>
	 <55D8352E.9040702@msgid.tls.msk.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > Do you see any *kernel* messages after this? I'm half expecting to see
> > that the beacon never arrives, or something like that?
> 
> The kernel log is repeated.  The next log line is again scanning start,
> since NetworkManager (or wpa_supplicant, I'm not familiar with the machinery
> involved) request scan again.

Ok, that's interesting.

> > Are the hotels running similar equipment perhaps? If rebooting the AP
> > helps then perhaps the APs aren't actually beaconing quite properly -
> > maybe you could put the card into sniffer mode (monitor mode) and
> > capture what's going on over the air for a bit after this happened?
> 
> Can you give some more specific comments please?  We just rebooted the
> AP the next time, it all started working again, and I need to install
> all the necessary tools while it is working ;)  Since I'm not familiar
> with wifi machinery, maybe you can give me specific command lines to
> run? :)

Oh, well, there's some information here:

https://wireless.wiki.kernel.org/en/users/documentation/iw

iw wlan0 set type monitor
iw wlan0 set channel X
ip link set wlan0 up
tcpdump -i wlan0 -s0 -w /tmp/dump

could capture this on another machine.

johannes
