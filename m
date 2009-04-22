Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:51610 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZDVL4J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 07:56:09 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1240399028.10072.14.camel@localhost.localdomain>
References: <1239837672.11795.46.camel@violet>
	 (sfid-20090416_012123_293746_81110E23)  <1239875168.9737.10.camel@johannes.local>
	 <1240247636.5260.11.camel@localhost.localdomain>
	 <1240248008.4632.10.camel@johannes.local>
	 <1240248385.5260.15.camel@localhost.localdomain>
	 (sfid-20090420_192718_984250_38AB6869)  <1240248773.4632.13.camel@johannes.local>
	 <1240343775.3327.3.camel@localhost.localdomain>
	 <1240348792.17388.46.camel@johannes.local>
	 <1240385542.3404.5.camel@localhost.localdomain>
	 <1240391029.20308.1.camel@johannes.local>
	 <1240391541.10072.2.camel@localhost.localdomain>
	 <1240393523.21978.1.camel@johannes.local>
	 <1240399028.10072.14.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 12:53:25 +0100
Message-Id: <1240401205.3313.3.camel@localhost.localdomain> (sfid-20090422_135614_527637_EA872E8B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > > > > CTRL-EVENT-SCAN-RESULTS 
> > > > > Trying to authenticate with 00:23:ab:xx:xx:xx (SSID='Guest' freq=2412 MHz)
> > > > > Trying to associate with 00:23:ab:xx:xx:xx (SSID='Guest' freq=2412 MHz)
> > > > > Associated with 00:23:ab:xx:xx:xx
> > > > > CTRL-EVENT-CONNECTED - Connection to 00:23:ab:xx:xx:xx completed (auth) [id=2 id_str=]
> > > > > CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> > > > > l2_packet_receive - recvfrom: Network is down
> > > > > Failed to initiate AP scan.
> > > > > Failed to initiate AP scan.
> > > > > ^CCTRL-EVENT-TERMINATING - signal 2 received
> > > > > 
> > > > > So starting wpa_supplicant does its job fine, then running dhclient I
> > > > > end up in the disconnect and network down and after that scanning fails.
> > > > 
> > > > ???
> > > > 
> > > > And the below kernel message is all yo uget?
> > > 
> > > Yes, I am as puzzled as you are and can't make any sense out of it. It
> > > seems that something is going horribly wrong here somewhere. I just
> > > don't have any clue where.
> > 
> > I just don't see anything in the kernel that would ever set the
> > interface down, as indicated there.

so I have installed the latest wireless-testing kernel now.

CTRL-EVENT-SCAN-RESULTS 
Trying to authenticate with 00:1f:f3:fa:58:59 (SSID='HON Circle' freq=2452 MHz)
Trying to associate with 00:1f:f3:fa:58:59 (SSID='HON Circle' freq=2452 MHz)
Could not read SSID from driver.
WPA: No SSID info found (msg 1 of 4).
Associated with 00:1f:f3:fa:58:59
WPA: Key negotiation completed with 00:1f:f3:fa:58:59 [PTK=CCMP GTK=CCMP]
CTRL-EVENT-CONNECTED - Connection to 00:1f:f3:fa:58:59 completed (auth) [id=1 id_str=]

<starting dhclient wlan0 now>

CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
l2_packet_receive - recvfrom: Network is down
CTRL-EVENT-SCAN-RESULTS 
Trying to authenticate with 00:1f:f3:fa:58:59 (SSID='HON Circle' freq=2452 MHz)
Trying to associate with 00:1f:f3:fa:58:59 (SSID='HON Circle' freq=2452 MHz)
Associated with 00:1f:f3:fa:58:59
WPA: Key negotiation completed with 00:1f:f3:fa:58:59 [PTK=CCMP GTK=CCMP]
CTRL-EVENT-CONNECTED - Connection to 00:1f:f3:fa:58:59 completed (reauth) [id=1 id_str=]

For some reason the dhclient triggers the disconnect and I see the
network down. With this kernel it reconnects properly and then dhclient
succeeds. This is against an N-capable AirPort Express.

Regards

Marcel


