Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34147 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1AYKmI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 05:42:08 -0500
Subject: Re: [PATCH v2 0/6] Probe-resp offloading support
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1295950241.3650.3.camel@jlt3.sipsolutions.net>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
	 <1295869283.3639.7.camel@jlt3.sipsolutions.net>
	 <AANLkTi=cSdi_i=RBtcp_aLG92S3xdMvJEMSfVdqX=qAK@mail.gmail.com>
	 <1295950241.3650.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 11:42:07 +0100
Message-ID: <1295952127.3650.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-25 at 11:10 +0100, Johannes Berg wrote:
> On Mon, 2011-01-24 at 23:21 +0200, Arik Nemtsov wrote:
> 
> > Well a wiphy flag won't do here. Probe requests may be filtered in
> > some modes (AP-mode) but needed in others (p2p?).
> > I think flexibility is a nice added bonus here. A FW can decide to
> > handle most standard probe-requests and simply not pass them up.
> > Others ("complicated" ones) it can pass up to hostapd and expect it to reply.
> > 
> > The current patches leave this policy in the hands of the driver/fw.
> 
> That is _very_ dangerous. If the user has older firmware that doesn't
> know about WSC2, how would the user know not to configure WSC2 in
> hostapd? That needs to be known to hostapd so it can verify this
> situation. For P2P, we already know whether or not P2P is supported, but
> that's rather vague in case there will ever be a revision of the P2P
> spec with say different IEs.
> 
> Additionally, a "regular AP" (not P2P, not WSC) would still want to
> reply to probe requests from WSC/P2P devices with the normal template.
> 
> IMHO it would be smarter to rework the firmware to only reply to probe
> requests if the probe response is configured. Then, if WSC, P2P, or
> similar technologies are in use on the interface, hostapd can simply
> decide to not configure the probe response and have host-based
> processing. Would that be a change you could still make?


Of course, firmware can reply to non-p2p/non-wsc2 probe requests with a
static probe response template.

The question is how much knowledge you want to put into the firmware
about those protocols. If you want to put all knowledge in there, then
at least you need to indicate to hostapd which protocols the firmware
knows not to reply to.

Also, a way to turn off this behaviour would still be good for future
protocol changes. If P2P changes in 3 years, I'm sure this firmware
won't be updated to match since you'll be a few hardware generations
ahead. Then, being able to turn off the offload completely would allow
users to take advantage of new protocols without changing hardware. Of
course, you may want to force users to buy new hardware that way -- but
in that case we *still* need the advertisement of what's possible so
users know right away that they need to buy new hardware and don't try
to configure something that just fails in strange ways.

johannes

