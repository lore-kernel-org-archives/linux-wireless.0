Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:15818 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbXKZH0u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 02:26:50 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 regression: doesn't associate automatically
Date: Mon, 26 Nov 2007 08:27:31 +0100
Cc: Will Dyson <will.dyson@gmail.com>, linux-wireless@vger.kernel.org
References: <200711220912.10452.hs4233@mail.mn-solutions.de> <8e6f94720711241439x27c1a48dxe3f3698043fb05a8@mail.gmail.com> <1195988035.4149.218.camel@johannes.berg>
In-Reply-To: <1195988035.4149.218.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200711260827.31368.hs4233@mail.mn-solutions.de> (sfid-20071126_072654_896351_F534446D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Simply triggering a scan won't trigger association either
> though, will it? So we'd have to manipulate the mlme state
> machine too. I don't like it much but I guess we don't have
> too much choice.

In my case, an "iwlist eth1 scan" triggers a scan, and also 
always an association. Well, always = three times :-)


Also, there might be some race here. When I turned on my laptop 
and inserted the b43 card freshly, I *DID* get an association 
with my standard Debian script. After

$ pccarcctl eject
$ rmmod b43
$ rmmod ssb
$ pccardctl insert

I needed to trigger a scan.


It might also be the case that in this case the card was by 
change on the frequency of the AP (2.437 MHz).
