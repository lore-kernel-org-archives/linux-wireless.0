Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:39672 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab0CQOAm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 10:00:42 -0400
Subject: Re: [RFC PATCHv3 0/2] mac80211: cfg80211: Roam trigger support
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: "ext John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100317132236.GC2990@tuxdriver.com>
References: <1268830877-5162-1-git-send-email-juuso.oikarinen@nokia.com>
	 <20100317132236.GC2990@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 15:56:18 +0200
Message-ID: <1268834178.10120.638.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-17 at 14:22 +0100, ext John W. Linville wrote:
> On Wed, Mar 17, 2010 at 03:01:15PM +0200, Juuso Oikarinen wrote:
> > To implement good performance WLAN roaming, it is not sufficient to start
> > scanning for other available AP's only after the currently serving association
> > is lost.
> > 
> > The entity controlling the roaming will need to get indication of a
> > deteriorating WLAN connection in order to start preparing for roaming already
> > before the serving association is lost. This way, it can roam to a better AP
> > perhaps even before the serving association becomes too bad in quality.
> > 
> > These patches propose an implementation facilitating this using a simple RSSI
> > threshold and hysteresis approach.
> > 
> > These patches add a nl80211 interface for simply configuring a rssi threshold
> > and hysteresis value to facilitate very basic connection quality monitoring.
> > 
> > For the triggering, these patches currently rely on HW support, host based
> > triggering is not implemented, but could be added later if needed.
> > 
> > These patches have been tested with the wl1271 driver.
> > 
> > Thanks in advance for your comments and suggestions.
> > 
> > Juuso Oikarinen (2):
> >   cfg80211: Add connection quality monitoring support to nl80211
> >   mac80211: Add support for connection quality monitoring
> 
> Any idea what other hardware (besides libertas) supports this concept?
> Do you anticipate adding a host-based implementation to mac80211?

I'm not currently anticipating on doing a host-based implementation in
the near future for this because the driver I co-maintain does not need
it and I would not have the time to do it properly.

I'm currently aware of only libertas and wl1271 with hardware support
for this. I'm relatively sure though that there are more, as this is a
pretty basic feature, supported even by some of the most hated of
operating systems ;)

> Is RSSI really a useful enough indicator for this function?
> Will applications actually use it?

RSSI by itself is perhaps not ideal, but it's still way better than
nothing. Currently we have to wait for the connection to be lost to do
roaming - taking up a significant amount of time. A dropping RSSI does
give a hint that the AP is getting further away.

I believe there is pressure for this feature from others than just me.
Based on these patches I already received queries on this feature, so
I'm positive that wider support will emerge, also in user-space.

-Juuso



> John


