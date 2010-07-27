Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:44046 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab0G0FR5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 01:17:57 -0400
Subject: Re: Hardware needs to know when EAP nego is complete
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Jouni Malinen <j@w1.fi>
Cc: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>
In-Reply-To: <20100726143047.GB7324@jm.kir.nu>
References: <1280142400.6475.33.camel@wimaxnb.nmp.nokia.com>
	 <20100726143047.GB7324@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 08:17:22 +0300
Message-ID: <1280207842.6475.56.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-07-26 at 16:30 +0200, ext Jouni Malinen wrote:
> On Mon, Jul 26, 2010 at 02:06:40PM +0300, Juuso Oikarinen wrote:
> > There are lots of timing issues involved, and there is a priority
> > between WLAN an BT. To ensure BT A2DP and SCO work properly, BT needs to
> > have enough priority at the expense of WLAN performance. While this
> > works well enough when connected, during WLAN association and especially
> > during EAP negotiation the priority needs to be more on the WLAN side to
> > ensure reliability.
> 
> Could you please explain why EAP negotiation is a special case? It is
> using data frames just like any other operation after it..

I'm not aware of all the facts, but I believe it's more about the EAP
negotiation being more sensitive to lost frames for instance.

> > So, what this all boils down to is that the wl1271 driver needs to know
> > when the association, including the possible EAP negotations are fully
> > complete, to be able to adjust the priority.
> 
> This sounds like a horrible hack and really, the unreliability during
> EAP should likely fixed in some other way.

To be truthful, I think it's a hack all the way - also on the wl1271.
This way of WLAN-BT coexistence has proven to be a pandora's box of
problems - all these weird issues keep popping up. And this particular
issue is probably one of those, and this way around it, is probably a
last minute hack to solve the issue on the chipset vendor part.

> > Currently, there is no such information available to the driver. In fact
> > this information is not available anywhere in the kernel level either
> > (as the details of the EAP negotiation, needed keys etc are controlled
> > in user-space), so the trigger would need to come from user-space.
> 
> That's not actually true.. At least when run with wpa_supplicant is
> setting operation state to IF_OPER_UP when the full authentication
> sequence (i.e., not only EAP, but also the following 4-way handshake
> with EAPOL-Key frames) is done (and IF_OPER_DORMANT when not ready).
> This is needed for other purposes to indicate when real data traffic can
> be sent, e.g., for DHCP clients.

> I don't think I would support the idea of using that information to
> change the WLAN vs. BT priority without some additional data on what
> exactly goes wrong during EAP negotiation, but at least the information
> should already be in the kernel, so we do not need to change nl80211 for
> this.
> 

Yeah, this sounds like something that could be used for a trigger. I
will look into it.

I did not really think this proposal would be accepted. I stated out the
problem mainly to get a second opinion, and possibly ideas.

In the meanwhile, we will have to somehow make this work. I thank you
for your thoughts. :)

-Juuso

