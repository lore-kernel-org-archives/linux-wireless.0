Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:23243 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbYKTOhm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 09:37:42 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Fwd: p54: testing AP mode: cannot switch to master mode
Date: Thu, 20 Nov 2008 15:37:18 +0100
Cc: "Stefan Steuerwald" <salsasepp@googlemail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
References: <f76a32050811190306s6a86f46dwc245200069ff8a82@mail.gmail.com> <f76a32050811200050u48bc150en34e94c7671672ae6@mail.gmail.com> <f76a32050811200544p3c647cb3t392025feef02c8f9@mail.gmail.com>
In-Reply-To: <f76a32050811200544p3c647cb3t392025feef02c8f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811201537.19047.hs4233@mail.mn-solutions.de> (sfid-20081120_153747_255308_233440C7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> The gap is filled by some "Null function" packets originating
> on the iPod (maybe it is getting impatient?). This gets me an
> application-level timeout.

Some comments about your "ipod_http_request_delayed_answer.pcap":


Clients use "null functions" to tell the AP that they're going to 
sleep --- or that they are now waking up again. You can see this 
in wireshark if you open "IEEE802.11", then "Frame Control: 
xxxx", then "Flags". Look at the flag "PWR_MGT".


While sleeping, the AP should notify the client via a bitmask in 
it's beacons that there is traffic for it. As your dump doesn't 
include the beacons from the AP, we can't see if the proper bit 
is set there.

At time 36.04 the Ipod WLAN card signals that it woke up and it 
got then it's packet at time 36.70, which isn't awfully fast 
after the wakeup, but ...


Just make a trace with beacons towards your mac80211 based AP and 
one trace towards another access points and compare the beacon.
