Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36339 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab2KLKPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 05:15:24 -0500
Message-ID: <1352715356.9525.12.camel@jlt4.sipsolutions.net> (sfid-20121112_111531_023730_9DC299A9)
Subject: Re: 60 GHz interface types (was: [PATCH v5 1/2] wireless: Driver
 for 60GHz card wil6210)
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>, j@w1.fi
Date: Mon, 12 Nov 2012 11:15:56 +0100
In-Reply-To: <9805542.8YLh3g7mqN@lx-vladimir>
References: <1351701417-3140-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <12645035.o6OUeozobZ@lx-vladimir>
	 <1352641337.12119.7.camel@jlt4.sipsolutions.net>
	 <9805542.8YLh3g7mqN@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-11-11 at 18:53 +0200, Vladimir Kondratiev wrote:

> > However in your patch submission you said "STA, PCP and monitor modes"
> > are supported. Don't you mean "STA, AP and monitor" then?
> 
> Good catch.
> 
> Hardware/firmware I have implement PCP, not AP. For the client, difference 
> between PCP and AP is sublte and it will not care unless it really want to say 
> "this one is PCP and that one - AP". So, client kind of support both.

Ok, can you elaborate on the differences between PCP and AP, and their
clients? I haven't had time to dig through the draft again :)

> Because of there is no native PCP notion yet, I support PCP pretending it is 
> AP.
> 
> So, it is really "PCP" for now.

Should it really (ab)use the AP interface type then? I'd argue we should
get this right from the start, rather than fudging it, and then maybe
having some kernel that has it wrong and userspace having to handle that
etc.?

> > 
> > Do we need/want a PCP_CLIENT mode?
> 
> Strictly say FromDS/ToDS encoding is different depending on BSS type.
> It is 0/0 for PBSS since it is ad-hoc.

Hmm, from mac80211's POV that could be an interesting distinction which
might actually somewhat be useful as an interface type? Not that I know
we'll see mac80211-based 60 GHz drivers, but still.

> It is, however, only capability, like "can associate with PCP" and "can 
> associate with AP". Mode of operation is the same: CLIENT.

Ok.

> PCP and AP are differentiated (from client side) by the "DMG Parameters field" 
> that is included in beacon and other frames. It occupies same location as 1-st 
> 8 bits of cabability. ESS and IBSS bits from capability becomes 2-bit "BSS 
> type" field, with encoding (see #8.4.1.46 DMG Parameters field)
> 
> value    BSS type     Transmitted by
> 3        BSS          AP
> 2        PBSS         PCP
> 1        IBSS         any non-AP and non-PCP DMG STA
> 0        reserved
> 
> This for now "I'm not sure"

IBSS is supported too? Fun.


> > Right, of course. I was thinking along the lines of "what happens if the
> > same wiphy (in cfg80211) supports both 2.4 (or 5) and 60 GHz". Does that
> > even make sense? I don't know. But if it does make sense, is there a
> > need to distinguish between 60 GHz client/AP/PCP interface types and the
> > same on the low band?
> > 
> > Now, I'd actually think that it's more likely that even if there's a
> > device that supports both 2.4/5 and 60 GHz, it'll register two wiphys
> > with cfg80211, since 2.4/5 and 60 are intended to cooperate, I think, so
> > it wouldn't really make sense to build hardware that can be one of 2.4,
> > 5, 60 (like today's 2.4/5 GHz hardware that can't be both at the same
> > time)
> 
> You think good :-) Standard provides reference model (#4.9.4 Reference model 
> for multi-band operation). Briefly, there are separate MAC entities controlled 
> by "multi-band" management entity; with whole mess of same/different MAC 
> addresses.

Yeah I found that too, later.

> I suppose we can have MAC stuff in the kernel as-is, and at least at the 
> beginning try to handle multi-band entirely in the supplicant.

But it does raise the question of what happens if a single device
supports both 2.4 and 60 GHz, or maybe all three of 2.4, 5 and 60 GHz.

If that would be on a single wiphy, I think we might run into issues
with re-using the interface types?

johannes

