Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37510 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab2KEP2d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 10:28:33 -0500
Message-ID: <1352129348.9466.23.camel@jlt4.sipsolutions.net> (sfid-20121105_162853_556663_586ABF88)
Subject: Re: [PATCH v4 5/6] nl80211/cfg80211: add ap channel switch command
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kgiori@qca.qualcomm.com" <kgiori@qca.qualcomm.com>,
	"mcgrof@frijolero.org" <mcgrof@frijolero.org>,
	"zefir.kurtisi@neratec.com" <zefir.kurtisi@neratec.com>,
	"adrian.chadd@gmail.com" <adrian.chadd@gmail.com>,
	"j@w1.fi" <j@w1.fi>, "coelho@ti.com" <coelho@ti.com>,
	"igalc@ti.com" <igalc@ti.com>,
	"adrian@freebsd.org" <adrian@freebsd.org>,
	"nbd@nbd.name" <nbd@nbd.name>,
	"simon.wunderlich@s2003.tu-chemnitz.de"
	<simon.wunderlich@s2003.tu-chemnitz.de>
Date: Mon, 05 Nov 2012 16:29:08 +0100
In-Reply-To: <50922AAF.3060605@ti.com>
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
	 <1350226137-13704-6-git-send-email-victorg@ti.com>
	 <5086371D.2080108@tieto.com> <50922AAF.3060605@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-01 at 09:54 +0200, Victor Goldenshtein wrote:

> > This however introduces a new problem. Let's suppose we have 2 APs on
> > channel 1. The device doesn't support multi-channel. We won't be able to
> > switch channel on these APs at all.
> >
> > We might want to change the channel switch to resolve around the channel
> > itself (not the interface) - so we'd be saying "move all interfaces with
> > channel X to channel Y" instead of "move interface X to channel Y".
> >
> > Or we could let the driver decide what it'll do - e.g. silently switch
> > more than one interface to a different channel (which makes sense with
> > AP/DFS I guess) and just notify cfg/userspace about it. That would
> > require us to provide a way to switch interfaces (atomically possibly)
> > between channels while keeping in sync with interface combinations though.
> >
> 
> If the driver/device supports MR only on a SC - means it doesn't 

What's MR? SC = single channel?

> supports channel switch in MR, so basically the radar detection event 
> triggers AP channel switch which fails (with this new check) and the AP 
> shut down.

But I was speaking of two interfaces on a single channel.

> Of course there are possible driver specific workarounds (as you 
> mentioned above) but these are not part of this series.

yeah but you should probably allow for some strategy of handling this?

> Just for interest's sake, what is the use case having two APs on the 
> same channel?

Umm, lots of things? P2P groups, multiple BSSIDs, ...

johannes

