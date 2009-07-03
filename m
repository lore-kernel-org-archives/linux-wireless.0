Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:9363 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750935AbZGCH0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2009 03:26:53 -0400
Message-ID: <4A4DB343.7060800@call-direct.com.au>
Date: Fri, 03 Jul 2009 17:29:07 +1000
From: Iwo Mergler <iwo@call-direct.com.au>
MIME-Version: 1.0
To: Reiner Herrmann <r_herrma@informatik.uni-kl.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: mac80211: Force beacon update?
References: <4A4DB01E.2030408@informatik.uni-kl.de>
In-Reply-To: <4A4DB01E.2030408@informatik.uni-kl.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reiner Herrmann wrote:
> Hi,
> 
> I want to attach a custom IE to beacons, but some drivers (like b43)
> are fetching their beacons via ieee80211_beacon_get() only once and
> retransmit this beacon every time.
> Some other drivers (like mac80211_hwsim, ath9k) are calling it
> before every beacon transmission.
> 
> Is there a general way to make all drivers generate new beacons instead
> of caching them or would I have to adapt them?
> If adapting drivers is the only way, do you have any suggestions on
> how to do that?

Hi Reiner

the drivers that call ieee80211_beacon_get() only once, have
hardware that transmits beacons automatically. That is, the
beacon template from ieee80211_beacon_get() is stored in the
hardware and the hardware then automatically sends that while
updating a few fields as needed.

In other words, the driver doesn't know anything about the
beacons after the initial setup, and thus can't call ieee80211_beacon_get().
No caching is involved. :-)

So to do what you want, you need to disable the automatic
beaconing and use packet injection and send your beacons
as raw frames.


Best regards,

Iwo

