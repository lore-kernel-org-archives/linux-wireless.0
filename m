Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:39887 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab0CQGHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 02:07:50 -0400
Subject: Re: [RFC PATCHv2 0/2] mac80211: cfg80211: Roam trigger support
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1268776349.8918.9.camel@jlt3.sipsolutions.net>
References: <1268657751-1042-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1268776349.8918.9.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 08:02:52 +0200
Message-ID: <1268805772.10120.603.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-03-16 at 22:52 +0100, ext Johannes Berg wrote:
> On Mon, 2010-03-15 at 14:55 +0200, Juuso Oikarinen wrote:
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
> 
> I'm curious. How does the HW/firmware do this?

> In my testing on some hw, the beacon RSSI fluctuated wildly, so you'd
> have to set the hysteresis pretty high.

The HW/firmware can be configured with parameters related to averaging,
which will smoothen the worst of the fluctuation at least between single
frames.

Still, there is the WLAN tendency of a very steep RSSI curve, so we'll
probably end up with a relatively high hysteresis. Figuring out good
values for the config is still to-be-done.

-Juuso

> johannes
> 


