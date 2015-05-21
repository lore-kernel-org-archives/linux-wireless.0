Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42937 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170AbbEUHLq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 03:11:46 -0400
Message-ID: <1432192301.2343.3.camel@sipsolutions.net> (sfid-20150521_091149_710131_A9F3A71E)
Subject: Re: mac80211 drops packet with old IV after rekeying - workaround
 patch for CCMP
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Wetzel <alexander.wetzel@web.de>
Cc: "Peer, Ilan" <ilan.peer@intel.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 21 May 2015 09:11:41 +0200
In-Reply-To: <555CF4C2.7040002@web.de>
References: <CANUX_P31bbOr8WhTY5D+M7QraVqJeCdw-qxME0GWmOQtLksb9A@mail.gmail.com>
			 <1431674716.2426.2.camel@sipsolutions.net>
			 <CANUX_P0HN5z-c6M_KcnJxT1LBPDP=OC9JnsaPPRf9RcDuw4hug@mail.gmail.com>
			 <1431714949.2117.0.camel@sipsolutions.net>
			 <CANUX_P2Xf9i9P3G5LgUm0bjCMSMpQwecJ1S4qH6RuurrkuSp-A@mail.gmail.com>
			 <1431806229.2120.6.camel@sipsolutions.net> <20150517160513.GA13175@w1.fi>
			 <CANUX_P0byd4Q+1gjiBmoGqd_hESUH_YVCD6iPx0_d6aw_r3JSw@mail.gmail.com>
			 <1431890756.2129.13.camel@sipsolutions.net>
			 <CANUX_P3ODruGc2rvV2gLNLU15kEmaJMXeU_ovtaBeOQGnYotoA@mail.gmail.com>
			 <1431893157.2129.18.camel@sipsolutions.net>
			 <CANUX_P0cJc4Ww5AY7sNFL5z4EPit+ngHvX=4eFXF96K-E8p3MA@mail.gmail.com>
			 (sfid-20150517_221304_420222_D8022C07) <1431894140.2129.20.camel@sipsolutions.net>
			 <CB3B3D4774441E42AA3EA0E1BA8230A04DA98D91@HASMSX110.ger.corp.intel.com>
		 <1431961331.10489.1.camel@sipsolutions.net> <555A41EA.4090905@web.de>
	 <1431986157.10489.12.camel@sipsolutions.net> <555CF4C2.7040002@web.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-05-20 at 22:55 +0200, Alexander Wetzel wrote:
> I've verified that turning off hardware encryption on the AP and the STA
> is indeed preventing the issue.
> As soon as one of them is using the hardware encryption I can trigger
> the problem. (In my setup it seems to be mostly caused by the AP, since
> I needed sometimes as much as three rekeys to get the freeze when the AP
> was using Software and the STA hardware encryption.)

Right, I did identify cases where both sides can have issues. I'm not
surprised that the AP-side issue is more likely.

> So confident that we finally found the root of the evil I tried to write
> some code catching the races, see the attachment.
> 
> It's probably not the best fix, but the only one I could think of and
> deploy myself with the knowledge I gathered here and the last days.

Your patch breaks the security properties of this code, so we cannot use
it :-)

> What was really surprising me here is, that this is such a generic issue
> and I'm finding that in my home environment. For my understanding that
> should break many (all?) EAP Wlan's. (I'm using EAP-TLS and that did
> make the WLAN basically unusable and any sane person would have switched
> back to PSK...)

Well, I think it's a matter of probabilities.

First of all, the AP bug seems to be more likely to cause an issue, so
anyone who deployed EAP-TLS with non-broken APs is far better off than
you are. Secondly, you really can only run into this while you do
rekeying in heavy traffic, so in production environments with large
rekey intervals it doesn't matter as much again. And then I guess the
windows driver reconnects on PTK rekey request, so there you wouldn't
see it either ... as a consequence the number of affected people must be
pretty low :)

johannes

