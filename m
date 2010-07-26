Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:44073 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754647Ab0GZOa6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 10:30:58 -0400
Date: Mon, 26 Jul 2010 07:30:48 -0700
From: Jouni Malinen <j@w1.fi>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	Coelho Luciano Roth <luciano.coelho@nokia.com>
Subject: Re: Hardware needs to know when EAP nego is complete
Message-ID: <20100726143047.GB7324@jm.kir.nu>
References: <1280142400.6475.33.camel@wimaxnb.nmp.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1280142400.6475.33.camel@wimaxnb.nmp.nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 26, 2010 at 02:06:40PM +0300, Juuso Oikarinen wrote:
> There are lots of timing issues involved, and there is a priority
> between WLAN an BT. To ensure BT A2DP and SCO work properly, BT needs to
> have enough priority at the expense of WLAN performance. While this
> works well enough when connected, during WLAN association and especially
> during EAP negotiation the priority needs to be more on the WLAN side to
> ensure reliability.

Could you please explain why EAP negotiation is a special case? It is
using data frames just like any other operation after it..

> So, what this all boils down to is that the wl1271 driver needs to know
> when the association, including the possible EAP negotations are fully
> complete, to be able to adjust the priority.

This sounds like a horrible hack and really, the unreliability during
EAP should likely fixed in some other way.

> Currently, there is no such information available to the driver. In fact
> this information is not available anywhere in the kernel level either
> (as the details of the EAP negotiation, needed keys etc are controlled
> in user-space), so the trigger would need to come from user-space.

That's not actually true.. At least when run with wpa_supplicant is
setting operation state to IF_OPER_UP when the full authentication
sequence (i.e., not only EAP, but also the following 4-way handshake
with EAPOL-Key frames) is done (and IF_OPER_DORMANT when not ready).
This is needed for other purposes to indicate when real data traffic can
be sent, e.g., for DHCP clients.

I don't think I would support the idea of using that information to
change the WLAN vs. BT priority without some additional data on what
exactly goes wrong during EAP negotiation, but at least the information
should already be in the kernel, so we do not need to change nl80211 for
this.

-- 
Jouni Malinen                                            PGP id EFC895FA
