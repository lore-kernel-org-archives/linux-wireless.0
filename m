Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:46168 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZEIRGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2009 13:06:14 -0400
Subject: Re: [PATCH 2/3] mac80211: Add a timeout for frames in the RX
 reorder buffer
From: Marcel Holtmann <marcel@holtmann.org>
To: Jouni Malinen <j@w1.fi>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090509080838.GA1206@jm.kir.nu>
References: <20090505173512.349795688@atheros.com>
	 <20090505173550.273830766@atheros.com>
	 <1241709323.4903.25.camel@localhost.localdomain>
	 <1241833703.4903.83.camel@localhost.localdomain>
	 <20090509080838.GA1206@jm.kir.nu>
Content-Type: text/plain
Date: Sat, 09 May 2009 10:05:53 -0700
Message-Id: <1241888753.4903.97.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

> > > I can confirm that this used to be a regular situation between my X200
> > > and a D-Link access point.
> 
> Which D-Link model is that AP? I think I should try to get one of those
> added to me test bed.. ;-)

from the WPS information element:

	 * Version: 1.0
	 * Manufacturer: D-Link Systems
	 * Model: DIR-615
	 * Device name: Wireless N Router
	 * Config methods: Label

I bought it over a year ago in Canada. It is actually my second of these
since I fried the first one :)

> > so I finally got the debug output for you. Took only over a day :)
> 
> Thanks! Would you happen to have timing information available for these
> (e.g., from klogd)? It looks like the AP is sending out an ADDBA Request
> to update some parameters, but we currently ignore that request.
> However, at least in this particular case, our RX reorder bug head_seq
> matches with the ssn from the ADDBA Request, so I'm not sure whether
> ignoring the ADDBA contents is really causing harm here (anyway, we
> should really process these updates, too).
> 
> The timeouts on RX reorder frames look similar to what I have seen in my
> tests and the workaround was indeed trying to address that type of
> issue, so it is nice to hear that it helped in this case, too.

I don't have the timing details since my Fedora for some reason doesn't
log them to the filesystem. I have to fix that.

Also re-producing this is not as simple as you think. I have no idea
when this happens. There is no way to actually trigger it from my side.

Regards

Marcel


