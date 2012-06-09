Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59075 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab2FIM2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 08:28:15 -0400
Message-ID: <1339244892.5763.1.camel@jlt3.sipsolutions.net> (sfid-20120609_142850_146721_D4E76A36)
Subject: Re: [RFC v2] mac80211: follow 802.11-2007 11.5.3 Error recovery
 upon HT BA failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Sean Patrick Santos <quantheory@gmail.com>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org,
	helmut.schaa@googlemail.com, mar.kolya@gmail.com,
	Per-Erik Westerberg <per-erik.westerberg@bredband.net>,
	=?UTF-8?Q?Miko=C5=82aj?= Kuligowski <mikolaj.q@wp.pl>
Date: Sat, 09 Jun 2012 14:28:12 +0200
In-Reply-To: <201206091414.41940.chunkeey@googlemail.com> (sfid-20120609_141447_009272_4C308145)
References: <CAFR4AqbeMC23w5j5vdN+hx2pH7M0Aw2epJiBmi29ARPAFeDDQg@mail.gmail.com>
	 <201206090311.21153.chunkeey@googlemail.com>
	 <1339228767.4539.3.camel@jlt3.sipsolutions.net>
	 <201206091414.41940.chunkeey@googlemail.com>
	 (sfid-20120609_141447_009272_4C308145)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-06-09 at 14:14 +0200, Christian Lamparter wrote:

> yeah, I should. But 802.11-2012 is not yet available for
> free like the old 802.11-2007 through IEEE 802 Get. 

Hah, ok. I guess I can fix the references when I apply it.

> > > This patch was only compile-tested and the design has 
> > > some rather big problems: 
> > 
> > Maybe then we should just revert Nikolay's patch?
> (I was referring to this RFC patch and not his patch)

Oh.

> I don't think we can/should revert it, just change it
> a bit so the timeout reset is triggered by a received
> BA from the peer.

Makes sense I guess.

> > >  - The spec says we should test for BlockAcks, however
> > >    that is not feasible because it is a control frame
> > >    (so FIF_CONTROL might filter it on some hardware).
> > 
> > In some way, all devices are going to have to report these
> > frames. Maybe not as the frame itself, but as some other
> > notification, to allow cleaning up the TX queues
> > accordingly, I think? There's a BA notification in iwlwifi
> > for example.
> Alright, I guess this means that we probably need a new HW
> feature flag like:
> 	IEEE80211_HW_REPORTS_BA_NOTIFICATION
> for hardware/firmware which filter BA frames, but have a BA
> notification trap. And every other driver need to pass BA
> to the stack where a new rx handler will update the last_tx
> accordingly. 

But that notification trap would also have to call some function in the
stack, and the drivers that don't have it (or don't implement it yet)
need something more like this patch?

I haven't actually looked into the specifics yet at all, will do that on
Monday.

johannes

