Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:22954 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab0DLJuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 05:50:04 -0400
Subject: Re: [RFC PATCH] nl80211: Add support for dynamic ps timeout
 configuration
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ylalehto Janne (Nokia-D/Tampere)" <janne.ylalehto@nokia.com>
In-Reply-To: <1271063175.3877.13.camel@jlt3.sipsolutions.net>
References: <1271059902-27788-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1271061120.3877.6.camel@jlt3.sipsolutions.net>
	 <1271062589.10120.1169.camel@wimaxnb.nmp.nokia.com>
	 <1271063175.3877.13.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Apr 2010 12:45:35 +0300
Message-ID: <1271065535.10120.1191.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-12 at 11:06 +0200, ext Johannes Berg wrote:
> On Mon, 2010-04-12 at 11:56 +0300, Juuso Oikarinen wrote:
> 
> > We could obviously do that. This patch does not prevent adding
> > functionality ;)
> 
> Well yeah but why let userspace make arbitrary decisions? :)
>
> > For desktops, obviously reduced latency is desirable, while increased
> > power consumption is not so much of an issue. For hand-held devices the
> > situation is often the opposite: in many situations we might want to
> > sacrifice some latency just to stretch the battery life that last inch
> > longer, possibly depending on the type of traffic we know we have going
> > on.
> 
> I don't think this contradicts each other. And we can also factor in the
> network_latency pm_qos value. Keep in mind that the gain from the
> timeout goes down as it increases past the beacon interval.

You're right obviously. But what we're looking for here are timeout
values less than the beacon/DTIM interval.

There are triggers for reducing the timeout, other than those mentioned
by you above. A hand-held might for example attempt to save power based
on the amount of user activity on the device in general. That's
something only user space would know about, but still is a very
important factor in deciding the dynamic ps timeout value.

Also AFAIK currently in nl80211 there is no way go to "full power-save"
i.e. disable dynamic power-save, which is something user-space might
want to do to conserve power if the hand-held is not being used.

Are you more hesitant on the concept of configuring the dynamic ps
behavior from user-space or the granularity of control here? In the
nl80211 interface the literal timeout value could be replaced by
something to indicate the level of power-saving needed, for example.

> In some sense I think it would be smarter to implement a gradual
> powersave policy where the device first still wakes up for every beacon
> and only later goes down to waking up for DTIM only (which may or may
> not be the same ...)

Yes, this is a good idea, although I still feel it does not alleviate
the need for what I tried to explain above.

-Juuso

> johannes
> 


