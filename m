Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46534 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab0EYLZ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 07:25:26 -0400
Subject: Re: [RFC PATCH] mac80211: Add support for hardware ARP query
 filtering
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1274779914.5277.216.camel@wimaxnb.nmp.nokia.com>
References: <1274773685-11168-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1274778802.3635.30.camel@jlt3.sipsolutions.net>
	 <1274779914.5277.216.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 May 2010 13:25:43 +0200
Message-ID: <1274786743.3635.33.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-25 at 12:31 +0300, Juuso Oikarinen wrote:

> > BTW, how will drivers deal with getting this while unassociated? If, for
> > example, I set an address before associating, you'll get it while
> > unassociated and not again when associated. Another thing to document --
> > driver needs to handle that, DHCP is not everything :)
> 
> This is actually a good point. The wl1271 driver configures the ARP
> filter immediately - associated or not - once the chipset is booted up
> (as above.) This is indeed not very generic.
> 
> I will move the set_arp_filter -thingy from _open() to when the we are
> associated. That way we get the initial IP address (if there happen to
> be any) from start when the address is actually needed. 

But then you would still get a callback way before the hardware is even
started if you set the address before ifup ... mac80211 should probably
catch that. Or does the networking stack already defer it then?

Another thing that came to mind -- how about locking? Will the callback
have to be atomic? Can you really access idev->ifa_list without any
locking at all?

> > This is obviously broken when you have multiple virtual interfaces, so
> > you either need to build a common list of IP addresses, or punt the
> > problem to the driver and give the callback an ieee80211_vif argument
> > and clearly document that the driver will have to keep track of it for
> > each interface.
> 
> Good point. I will "punt" (never heard this expression before!) 

Don't take my word for it ... I heard that once but can't find reference
to it being a correct use of the word ;)

johannes

