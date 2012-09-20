Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48711 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab2ITMq3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 08:46:29 -0400
Message-ID: <1348145224.4161.27.camel@jlt4.sipsolutions.net> (sfid-20120920_144636_576845_0C1515F1)
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Eric Dumazet <edumazet@google.com>
Cc: artem.bityutskiy@linux.intel.com, linux-wireless@vger.kernel.org,
	netdev <netdev@vger.kernel.org>
Date: Thu, 20 Sep 2012 14:47:04 +0200
In-Reply-To: <CANn89iJkXrZPB14KU8xA-Dn8_n=H3J4-R60BTZFV+STF9_ASdA@mail.gmail.com> (sfid-20120920_144027_246582_81AC7F21)
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	 <1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
	 <1347631355.5263.19.camel@sauron.fi.intel.com>
	 <1347640763.5263.24.camel@sauron.fi.intel.com>
	 <1347892887.7112.9.camel@sauron.fi.intel.com>
	 <1348142775.2388.10.camel@sauron.fi.intel.com>
	 <1348144524.4161.26.camel@jlt4.sipsolutions.net>
	 <CANn89iJkXrZPB14KU8xA-Dn8_n=H3J4-R60BTZFV+STF9_ASdA@mail.gmail.com>
	 (sfid-20120920_144027_246582_81AC7F21)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-20 at 14:40 +0200, Eric Dumazet wrote:
> OK, but which netif_receive_skb(), as I count 5 occurrences in
> net/mac80211/rx.c ?

The one you modified in the other email :-)

> Instead of skb_linearize() calls
> 
> you could try several values of XXX in
> 
> pskb_may_pull(skb, XXX)
> 
> So that you make sure XXX bytes are available in skb->head, and not
> the whole frame.
> 
> One you know the limit for XXX, it might give a clue where a
> pskb_may_pull(skb, XXX) is missing.

Good idea.

johannes

