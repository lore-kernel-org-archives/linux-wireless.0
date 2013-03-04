Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43109 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255Ab3CDUZj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 15:25:39 -0500
Message-ID: <1362428733.21028.53.camel@jlt4.sipsolutions.net> (sfid-20130304_212544_272012_09136D73)
Subject: Re: [PATCHv4 2/3] mac80211: mesh power save doze scheduling
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Marco Porsch <marco@cozybit.com>, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org
Date: Mon, 04 Mar 2013 21:25:33 +0100
In-Reply-To: <20130304192320.GB20505@thinkpad-t410>
References: <1362419675-27127-1-git-send-email-marco@cozybit.com>
	 <1362419675-27127-2-git-send-email-marco@cozybit.com>
	 <20130304192320.GB20505@thinkpad-t410>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-04 at 13:23 -0600, Seth Forshee wrote:

> I've been looking at power save in mac80211 over the past few days with
> an eye towards allowing multiple interface to be supported, as a result
> of comments Johannes made at [1]. It seems like adding driver callbacks
> for PS which are specific to the interface type is contrary to this
> goal.

Yeah, this is a concern. I didn't really stand in the way of doing mesh
powersave though, and it seemed that the new interface here would
actually be somewhat suitable, since for mesh any kind of powersave code
needs to know when to wake up/sleep. I would've liked to see less
reliance on host timers directly in core mac80211 even for the going to
sleep part though... basically I'm not sure for mesh just having PS
state will cut it. For managed mode this is easy because it only needs
to sync with a single AP, but for mesh that's a bit more complicated and
I think the whole sync should stay in mac80211. In the general case,
just having the TSF might not be enough, but that can be solved as
needed.

> The basic idea that's been forming on my mind is add PS states to vifs
> and make the managed, mesh, etc. code manipulate vif PS states rather
> than hw states. Then a PS module would manage the hw state based on the
> aggregate of the vif states.

Yeah, that about matches what I was thinking. But like I said above,
while this is fairly simple for managed mode, at least as required
today, it's clearly not as simple for mesh.

For managed mode, we also assume that we can send packets while the
device is sleeping, and the device will do the right thing to wake up
for beacons from the AP etc. For mesh, there are many more wakeup
sources, from what I can tell.

> I don't have a lot of the details worked out yet, and my knowledge of PS
> in mesh networks (and of mesh network operation in general) is pretty
> rudimentary at this point. But afaict any modes which support PS define
> the same two hw states, awake and doze. I wonder whether we should
> instead aim for a single interface into the driver for PS that's capable
> of supporting all interface types.

Such an interface would probably have to be the interface now defined
for mesh, telling the device when to wake up and go to sleep? But this
interface is rather inefficient for most chipsets...

johannes

