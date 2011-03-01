Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47655 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab1CANHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 08:07:30 -0500
Received: by fxm17 with SMTP id 17so4768765fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 05:07:29 -0800 (PST)
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC 0/9 v2] DFS/radar state/userspace handling
Date: Tue, 1 Mar 2011 14:07:12 +0100
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	nbd@openwrt.org, dubowoj@neratec.com, zefir.kurtisi@neratec.com,
	simon.wunderlich@saxnet.de
References: <201102281740.37036.bernhard.schmidt@saxnet.de> <1298982486.6015.10.camel@jlt3.sipsolutions.net>
In-Reply-To: <1298982486.6015.10.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201103011407.13171.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, March 01, 2011 13:28:06 Johannes Berg wrote:
> On Mon, 2011-02-28 at 17:40 +0100, Bernhard Schmidt wrote:
> 
> > Implemented so far is the complete state machine, handling CAC and NOL
> > as well as starting appropriate action in hostapd. Note, this is based
> > on top of the 'dfs region support' work posted by Luis.
> 
> I'm not quite sure about all of this. First of all, you don't really
> explain the global state vs. local state but you did say that you no
> longer had global state, which clearly isn't true.

Sorry about that.. it should have read:
"..that states are *now* global and no per wiphy.."

What I mean with that is that the interference flag/reporting, as
well as the NOL is shared between all wiphys contrary to the previous
version.

> Also, what's the point in "struct radar" if there's only a single
> instance of that, which is global? I'd rather have multiple global
> variables I think -- but that might just be a matter of personal taste
> or choice.

Yeah, that 'struct radar' can be split up and moved into radar.c as
static vars.

> Finally, I think your code split is a little hard to understand. Is
> there really any point in adding the code bit by bit into both cfg80211
> and mac80211 at the same time? I'd rather see a few patches to make
> cfg80211 complete and then implement it all in mac80211.

I tried to group them by functionality and not by subsystem. But if
you prefer that I can make a large blob for cfg80211.

> Which brings me to another point -- there's no way to detect from
> userspace whether or not this is all available.

True, the only thing available right now is checking the error code
for CAC_START. I'll fix that.
 
> Finally, such details like not needing a timer -- a delayed work should
> be sufficient, etc.
> 
> johannes
> 
> 

-- 
Best regards,

Dipl.-Inf. (FH) Bernhard Schmidt (software development)

saxnet GmbH, Willy-Brandt-Ring 1, 08606 Oelsnitz
Tel. +49 (0) 3741 300 6. 100 - Fax +49 (0) 3741 300 6. 101
managing director: Steffen Dreise - county court Chemnitz - HRB 23017
http://www.saxnet.de
