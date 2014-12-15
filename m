Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55364 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbaLOMj0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 07:39:26 -0500
Message-ID: <1418647159.5731.6.camel@sipsolutions.net> (sfid-20141215_133931_336395_D5F09B43)
Subject: Re: [PATCH v4] mac80211: keep sending peer candidate events while
 in listen state
From: Johannes Berg <johannes@sipsolutions.net>
To: "Bob Copeland (me@bobcopeland.com)" <me@bobcopeland.com>
Cc: "Nishikawa, Kenzoh" <Kenzoh.Nishikawa@jp.sony.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	"Thomas Pedersen (thomas@noack.us)" <thomas@noack.us>
Date: Mon, 15 Dec 2014 13:39:19 +0100
In-Reply-To: <20141212164705.GA7932@localhost> (sfid-20141212_174711_807425_3B78CCAA)
References: <2EB4F5C65A3B8E4E92660930F4EF6B5B06C981@JPYOKXMS113.jp.sony.com>
	 <1418384490.2470.23.camel@sipsolutions.net>
	 <20141212164705.GA7932@localhost> (sfid-20141212_174711_807425_3B78CCAA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-12-12 at 11:47 -0500, Bob Copeland (me@bobcopeland.com)
wrote:
> On Fri, Dec 12, 2014 at 12:41:30PM +0100, Johannes Berg wrote:
> > On Fri, 2014-11-21 at 11:24 +0000, Nishikawa, Kenzoh wrote:
> > > Instead of sending peer candidate events just once, send them 
> > > as long as the peer remains in the LISTEN state in the peering 
> > > state machine, when userspace is implementing the peering manager.
> > > Userspace may silence the events from a peer by progressing 
> > > the state machine or by setting the link state to BLOCKED.
> > > 
> > > Fixes the problem that a mesh peering process won't be fired 
> > > again after the previous first peering trial fails due to 
> > > like air propagation error if the peering is managed by 
> > > user space such as wpa_supplicant.
> > > 
> > > This patch works with another patch for wpa_supplicant described 
> > > here which fires a peering process again triggered by the notice 
> > > from kernel.
> > > http://lists.shmoo.com/pipermail/hostap/2014-November/031235.html
> > 
> > Can any of the mesh folks comment on this?
> 
> I think it's fine.  It's not strictly necessary: userspace could
> run its own timers to restart peering with any unpeered candidates
> periodically, but doing it based on beacon arrival is a little better
> since it indicates the peer is still alive, and this is also exactly
> how the in-kernel MPM operates.

Great, thanks.

johannes

