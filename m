Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:51789 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933729Ab0J2Lne (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 07:43:34 -0400
Subject: Re: [RFC PATCH 0/2] mac80211: Possibility for driver to get AP
 probereq template
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288352136.3826.28.camel@jlt3.sipsolutions.net>
References: <1288351673-12224-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1288352136.3826.28.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Oct 2010 14:42:51 +0300
Message-ID: <1288352571.12373.4.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-29 at 13:35 +0200, ext Johannes Berg wrote:
> On Fri, 2010-10-29 at 14:27 +0300, juuso.oikarinen@nokia.com wrote:
> > From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > 
> > The wl1271 has hardware connection monitoring, i.e. the hardware chipset 
> > internally handles periodic null-funcs and probe-req transmitting in case of
> > non-acked periodic null-func or beacon loss.
> 
> I'm wondering why it wants to do probe-req instead of nullfunc? I mean,
> we're trying to make mac80211 use nullfunc+ACK instead of probereq
> +proberesp ...

The wl1271 actually uses null-funcs for the periodic stuff.

Only when the null-func fails, or it misses a specific number of
consecutive beacons, it will transmit a probe-request to the AP in a
final attempt to re-sync before indicating connection loss to the host.

The thing with the wl1271 is, that we cannot disable the probe-req. If
we don't configure a template for it, it will transmit garbage upon
losing connection with the AP.

Why it uses a probe-request as the final means to resync, I'm not sure.

-Juuso




