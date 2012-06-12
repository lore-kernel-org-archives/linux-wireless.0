Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37382 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab2FLLd0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 07:33:26 -0400
Message-ID: <1339500801.4531.2.camel@jlt3.sipsolutions.net> (sfid-20120612_133329_198553_07B60033)
Subject: Re: [PATCH] mac80211: Disallow changing chan type on monitor when
 CHAN_MODE_FIXED
From: Johannes Berg <johannes@sipsolutions.net>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Tue, 12 Jun 2012 13:33:21 +0200
In-Reply-To: <4FD725FF.1030108@gmail.com> (sfid-20120612_132035_802191_87C8E8E9)
References: <1339499167-26225-1-git-send-email-pontus.fuchs@gmail.com>
	  (sfid-20120612_130639_458885_983B325C) <1339499291.4531.1.camel@jlt3.sipsolutions.net>
	 <4FD725FF.1030108@gmail.com> (sfid-20120612_132035_802191_87C8E8E9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-12 at 13:20 +0200, Pontus Fuchs wrote:
> On 2012-06-12 13:08, Johannes Berg wrote:
> > If you add a monitor interface in paralell to a normal interface
> > mac80211 will let you to change the channel type on the monitor
> > interface even if you are connected. Add an explicit check to
> > disallow this.
> > Is this against 3.5, and is it really needed there? It's a corner case
> > to start with.
> It's against wireless-next. 

Right, sorry, I was looking at the wrong code :(

> It's a real corner case indeed. With the
> wireshark toolbar I create monitors on demand for all phy's so I
> see it quite often myself. If it needs fixing is up to you to decide :)

Yeah, like we discussed, maybe it should or should not be allowed? With
the new changes Michal is doing it'll probably be disallowed anyway?

I'll apply it, but can you rediff and remove the "is_monitor" argument,
since dev == NULL is equivalent? :)

johannes

