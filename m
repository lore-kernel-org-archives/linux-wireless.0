Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40949 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab1FTR3l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 13:29:41 -0400
Subject: RE: [PATCH 2/2] mac80211: Fixing Races for skipping tailroom
 reservation
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Powar <yogeshp@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>
In-Reply-To: <7DDF37406E10F0438561DBB78326DF3902F5D190E2@SC-VEXCH1.marvell.com>
References: <20110616102138.GA24447@hertz.marvell.com>
	 <20110616102707.GB24458@hertz.marvell.com>
	 <d38dc36c1ab9a4bd819b9bcbbda181da@secure.sipsolutions.net>
	 <20110617132527.GA27436@hertz.marvell.com>
	 <1308331485.7329.2.camel@Nokia-N900-51-1>
	 <20110620143051.GA31035@hertz.marvell.com>
	 ,<1308583799.4322.9.camel@jlt3.sipsolutions.net>
	 <7DDF37406E10F0438561DBB78326DF3902F5D190E2@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Jun 2011 19:29:40 +0200
Message-ID: <1308590980.4322.19.camel@jlt3.sipsolutions.net> (sfid-20110620_192944_767498_5D0F739E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-06-20 at 09:49 -0700, Yogesh Powar wrote:
> >No, they're not, the mutex trickery seems completely pointless, and the
> >conditional (on _is_locked no less) locking is horrible.
> Ok.
> 
> Will spend some more time on exploring solutions using rcu primitives only
> (synchronize_net or something similar).
> 
> If nothing  of only-RCU is feasible then, I think, we need to resize the skb if it has
> already skipped the tailroom instead of WARN_ON. This will come in to picuture
> only during the race cases. But this wont get rid of race.

Ahrg, seriously, just analyse the situation for once. Do I really need
to do that?

There are two race cases, during transitions:
 1) need to resize -> no need to (key moved to HW)
 2) no need to resize -> need to (new key, ...)

The first is uninteresting, it's fine if the race happens and the skb is
still resized even if it didn't need to.

The second one is what's causing issues. But the race happens like this:
  - counter is 0
	- skb goes through tx start, no tailroom allocated
  - key added, counter > 0
	- key lookup while TX processing is successful

So ... how can you solve it? Clearly, the locking attempts you made were
pretty useless. But now that we understand the race, can we fix it? I
think we can, by doing something like this:

	counter++;
	/* flush packets being processed */
	synchronize_net();
	/* do whatever causes the key to be found by sw crypto */

That should be it. The only overhead is a little bit in control paths
for key settings which are delayed a bit by synchronize_net(), but who
cares, we don't change keys every packet.

Of course you need to encapsulate that code into a small function and
write comments about why it's necessary and how it works.

Was that so hard? :-)

johannes

