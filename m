Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f118.google.com ([209.85.221.118]:46081 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbZDGNUT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 09:20:19 -0400
Subject: Re: attempt to scan fails (device busy) if essid/ssid was changed
 recently
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1239110010.22453.41.camel@johannes.local>
References: <1239062401.4705.23.camel@maxim-laptop>
	 (sfid-20090407_020013_939126_90578556)  <1239092296.22453.1.camel@johannes.local>
	 <1239108689.15015.3.camel@maxim-laptop>
	 (sfid-20090407_145137_740898_8D0C40FD)  <1239109001.22453.40.camel@johannes.local>
	 <1239109497.15015.12.camel@maxim-laptop>
	 (sfid-20090407_150534_375314_4DA28551)  <1239110010.22453.41.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 16:20:12 +0300
Message-Id: <1239110412.15015.23.camel@maxim-laptop> (sfid-20090407_152026_597162_E2ABA456)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-04-07 at 15:13 +0200, Johannes Berg wrote:
> On Tue, 2009-04-07 at 16:04 +0300, Maxim Levitsky wrote:
> 
> > > > > > Looking a bit deeper I discovered that each time NM disconnects from a
> > > > > > networks it sets random ssid/essid to the card (using wireless
> > > > > > extensions)
> > > > > 
> > > > > This forces a scan
> > > > > 
> > > > > > After that scan fails for some time.
> > > > > > 
> > > > > > as a NM free example you can run 
> > > > > > 
> > > > > > iwconfig wlan0 essid dummy
> > > > > > iwlist scan
> > > > > 
> > > > > and then this fails with EBUSY.
> > > > Thanks for explanation.
> > > > Since NM has its reasons to clear essid (to prevent unwanted
> > > > association), then what can be  done to prevent this (and still use
> > > > wireless extensions, since nl80211 support isn't yet mature)?
> > > 
> > > Nothing. Wext sucks, news at 11, yadda.
> > Thanks.
> > Everything understood.
> 
> Of course, we can go back to dropping the scan request, but that
> wouldn't be very nice.
> 
> Is this creating any problems?
Yep, but dropping the request won't help ether.
Problem is that wpa_supplicant will attempt to scan before association,
scan fails (it doesn't know it is already running) thus it waits 10
seconds. (I patched it to wait 2 seconds).

It happens if user first disconnects, and then reconnects to a network
(typical test I do for time it takes to connect)

Now I patched it not to clear essid on disconnect, and this helped
reduce connect times by about 2 seconds.

now it takes just 3~4 seconds to connect to open network, and ~6 seconds
to WPA2 network.

(This is with patched dhclient, I reduced its timeouts, but this is
another story.... it seems that first DHCPREQUEST never succeeds, and I
tested this with 2 cards, and few wireless networks)


Best regards,
	Maxim Levitsky

> 
> johannes

