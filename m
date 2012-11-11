Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:53729 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab2KKQxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 11:53:24 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>, <j@w1.fi>
Subject: Re: 60 GHz interface types (was: [PATCH v5 1/2] wireless: Driver for 60GHz card wil6210)
Date: Sun, 11 Nov 2012 18:53:20 +0200
Message-ID: <9805542.8YLh3g7mqN@lx-vladimir> (sfid-20121111_175328_285129_DEBACA2C)
In-Reply-To: <1352641337.12119.7.camel@jlt4.sipsolutions.net>
References: <1351701417-3140-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <12645035.o6OUeozobZ@lx-vladimir> <1352641337.12119.7.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, November 11, 2012 02:42:17 PM Johannes Berg wrote:
> On Sun, 2012-11-11 at 10:15 +0200, Vladimir Kondratiev wrote:
> > > 802.11ad obviously distinguishes between a regular BSS, IBSS, and the
> > > new PBSS. We also differentiate between BSS and IBSS in our interface
> > > types, so I have a feeling that maybe we should also differentiate here,
> > > and not re-use the NL80211_IFTYPE_AP/... interface types.
> > 
> > Yes, you are absolutely right. Standard says about PBSS (802.11ad draft
> > 9):
> > 
> > ---cut---
> > 
> > A PBSS can be established only by DMG STAs. Not every DMG BSS is a PBSS. A
> > DMG BSS can be a PBSS, an infrastructure BSS or an IBSS.
> 
> I actually missed this last bit and thought a DMG STA can only be in a
> PBSS, sorry.
> 
> > Right now I do not have patch for this; but yes, it need to be done. I
> > want to finish with initial driver submission first, then continue with
> > infrastructure. As you mentioned earlier (and yes, I agree), without
> > single
> > 60g driver infrastructure work have little meaning.
> 
> However in your patch submission you said "STA, PCP and monitor modes"
> are supported. Don't you mean "STA, AP and monitor" then?

Good catch.

Hardware/firmware I have implement PCP, not AP. For the client, difference 
between PCP and AP is sublte and it will not care unless it really want to say 
"this one is PCP and that one - AP". So, client kind of support both.

Because of there is no native PCP notion yet, I support PCP pretending it is 
AP.

So, it is really "PCP" for now.

> 
> Do we need/want a PCP_CLIENT mode?

Strictly say FromDS/ToDS encoding is different depending on BSS type.
It is 0/0 for PBSS since it is ad-hoc.

It is, however, only capability, like "can associate with PCP" and "can 
associate with AP". Mode of operation is the same: CLIENT.

PCP and AP are differentiated (from client side) by the "DMG Parameters field" 
that is included in beacon and other frames. It occupies same location as 1-st 
8 bits of cabability. ESS and IBSS bits from capability becomes 2-bit "BSS 
type" field, with encoding (see #8.4.1.46 DMG Parameters field)

value    BSS type     Transmitted by
3        BSS          AP
2        PBSS         PCP
1        IBSS         any non-AP and non-PCP DMG STA
0        reserved

This for now "I'm not sure"

> 
> > > It seems that then we'd also need a PBSS_P2P_CLIENT and PBSS_P2P_GO,
> > > which is a bit odd, but then again we also do that for P2P_CLIENT vs.
> > > normal managed and P2P_GO vs. AP.
> > 
> > This time - not exactly. P2P spec says that in DMG (Direct Multi-Gigabit)
> 
> > networks P2P GO is PCP. From P2P spec 1.3 draft 4 (#2.1 P2P components):
> Ok, I hadn't checked the P2P update for this yet.
> 
> > So, for P2P it is sufficient to have P2P_GO and P2P_CLIENT. In DMG, spec
> > dictates that P2P group is PBSS. P2P supplicant may deduce everything from
> > band.
> 
> Ok.
> 
> > > I'm not sure if we're ever going to see chipsets that have 60GHz and
> > > 2.4/5 GHz combined, and are not going to just register two wiphy's with
> > > the system for that, but if there was then this would certainly help
> > > with interface combinations etc.
> > 
> > Most likely, 60g chips will be accompanied with 2.4/5 GHZ ones. Spec
> > actually encourage this; it defines FST (Fast Session Transfer) mechanism
> > to bundle 60g with 2.4/5.
> 
> Right, of course. I was thinking along the lines of "what happens if the
> same wiphy (in cfg80211) supports both 2.4 (or 5) and 60 GHz". Does that
> even make sense? I don't know. But if it does make sense, is there a
> need to distinguish between 60 GHz client/AP/PCP interface types and the
> same on the low band?
> 
> Now, I'd actually think that it's more likely that even if there's a
> device that supports both 2.4/5 and 60 GHz, it'll register two wiphys
> with cfg80211, since 2.4/5 and 60 are intended to cooperate, I think, so
> it wouldn't really make sense to build hardware that can be one of 2.4,
> 5, 60 (like today's 2.4/5 GHz hardware that can't be both at the same
> time)

You think good :-) Standard provides reference model (#4.9.4 Reference model 
for multi-band operation). Briefly, there are separate MAC entities controlled 
by "multi-band" management entity; with whole mess of same/different MAC 
addresses.

I suppose we can have MAC stuff in the kernel as-is, and at least at the 
beginning try to handle multi-band entirely in the supplicant.

> 
> OTOH, maybe there would be value in being able to tell the difference
> between 2.4/5 and 60 purely on the interface types? Not sure either!
> 
> > > Even if there isn't, it could help tools like network-manager not manage
> > > the 60 GHz device (without having to add special checks), which I
> > > suspect is what you'd want? Not really sure though.
> > 
> > Yes, and I am working with Jouni for wpa_supplicant additions.
> > 
> > Sure I want 60g to be managed by the network manager as it does for other
> > devices.
> 
> Oh ok :)
> I guess that kinda means you *don't* want this to look different.
> 
> > It works well right now for PBSS client - I connect using GUI frontend as
> > provided by Ubuntu or Fedora. Actually, PBSS client is like BSS one. There
> > is some work pending to display PCP (differentiate from AP) in the scan
> > list.
> Ok so we use the same interface type for AP clients and PCP clients? I
> guess that's ok, or should we differentiate for some reason? I'm not
> familiar enough with the spec -- how close are those two?

Answered above.

> 
> > It is correct PBSS need additional work as it should allow for automatic
> > PCP selection - it is like simplified P2P. P2P need some work as well. I
> > am looking in this direction right now. For P2P, we don't have GUI right
> > now - or do I miss something here?
> 
> No, I don't think we have P2P UIs (other than Android?)
> 
> johannes
