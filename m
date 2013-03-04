Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:60435 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab3CDU5T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 15:57:19 -0500
Date: Mon, 4 Mar 2013 14:57:14 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marco Porsch <marco@cozybit.com>, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCHv4 2/3] mac80211: mesh power save doze scheduling
Message-ID: <20130304205714.GD20505@thinkpad-t410> (sfid-20130304_215723_086291_96E9A297)
References: <1362419675-27127-1-git-send-email-marco@cozybit.com>
 <1362419675-27127-2-git-send-email-marco@cozybit.com>
 <20130304192320.GB20505@thinkpad-t410>
 <1362428733.21028.53.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1362428733.21028.53.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 04, 2013 at 09:25:33PM +0100, Johannes Berg wrote:
> On Mon, 2013-03-04 at 13:23 -0600, Seth Forshee wrote:
> 
> > I've been looking at power save in mac80211 over the past few days with
> > an eye towards allowing multiple interface to be supported, as a result
> > of comments Johannes made at [1]. It seems like adding driver callbacks
> > for PS which are specific to the interface type is contrary to this
> > goal.
> 
> Yeah, this is a concern. I didn't really stand in the way of doing mesh
> powersave though, and it seemed that the new interface here would
> actually be somewhat suitable, since for mesh any kind of powersave code
> needs to know when to wake up/sleep. I would've liked to see less
> reliance on host timers directly in core mac80211 even for the going to
> sleep part though... basically I'm not sure for mesh just having PS
> state will cut it. For managed mode this is easy because it only needs
> to sync with a single AP, but for mesh that's a bit more complicated and
> I think the whole sync should stay in mac80211. In the general case,
> just having the TSF might not be enough, but that can be solved as
> needed.

I read about the basics of mesh PS last week but don't have a firm
enough grasp on the details to understand what all would be needed for
an implementation. From these patches it looks like at minimum the
drivers need the next TBTT. That could be incorporated into something
more generic easily enough.

It's not the end of the world if these patches go in, it will just have
to be sorted out if/when I make some progress on multi-vif PS. I wasn't
planning on trying to lift any of the current restrictions on multiple
vifs right away anyhow, so it should be manageable.

> > The basic idea that's been forming on my mind is add PS states to vifs
> > and make the managed, mesh, etc. code manipulate vif PS states rather
> > than hw states. Then a PS module would manage the hw state based on the
> > aggregate of the vif states.
> 
> Yeah, that about matches what I was thinking. But like I said above,
> while this is fairly simple for managed mode, at least as required
> today, it's clearly not as simple for mesh.

Glad to hear I'm headed down the right path :-)

I've been trying to take all modes into consideration, but I had hoped
the implementation details of mesh were something I wouldn't have to be
immediately concerned with, since as you point out all of this is easier
for managed mode.

> For managed mode, we also assume that we can send packets while the
> device is sleeping, and the device will do the right thing to wake up
> for beacons from the AP etc. For mesh, there are many more wakeup
> sources, from what I can tell.
> 
> > I don't have a lot of the details worked out yet, and my knowledge of PS
> > in mesh networks (and of mesh network operation in general) is pretty
> > rudimentary at this point. But afaict any modes which support PS define
> > the same two hw states, awake and doze. I wonder whether we should
> > instead aim for a single interface into the driver for PS that's capable
> > of supporting all interface types.
> 
> Such an interface would probably have to be the interface now defined
> for mesh, telling the device when to wake up and go to sleep? But this
> interface is rather inefficient for most chipsets...

I was thinking something along those lines as well, either the
interfaces would be similar to the ones here or the data would be
available in ieee80211_conf. Frankly I find having both the PS callback
and IEEE80211_CONF_PS confusing, but maybe if I look at the patches more
closely it will make sense.

Seth

