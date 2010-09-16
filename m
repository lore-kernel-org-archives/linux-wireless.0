Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58054 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab0IPSm2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 14:42:28 -0400
Subject: Re: [PATCH 2/2] mac80211: add p2p device type support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <AANLkTikxcSXgEA-zM250AZ2v4sJk_U-gf2sjSoJ2x4ZR@mail.gmail.com>
References: <20100916125821.369545798@sipsolutions.net>
	 <20100916125927.163519598@sipsolutions.net>
	 <AANLkTi=6KKLty-pg1O9EbGB3n9AviddL63X14z4a250Y@mail.gmail.com>
	 <1284661809.3731.8.camel@jlt3.sipsolutions.net>
	 <AANLkTikxcSXgEA-zM250AZ2v4sJk_U-gf2sjSoJ2x4ZR@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 20:42:18 +0200
Message-ID: <1284662538.3731.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-16 at 11:40 -0700, Luis R. Rodriguez wrote:

> >> While at it can you add a is_beaconing_iftype() or something, that
> >> should reduce code and make it easier to check for these modes.
> >
> > Err, it doesn't really change for drivers, since it's still AP/IBSS --
> > since GO is just an AP subtype internally.
> 
> Well if the iftype is a beaconing one it used to use AP interface type
> before and now its a GO then yeah I could see this requiring changes
> in drivers. Apart from the filter stuff ath9k does have some checks
> for current operating interface type IIRC.

But nothing changes for it -- look at the patch again, I translate
P2P_GO to AP and P2P_CLIENT to STATION precisely to require fewer
changes in drivers unless they actually want to care. The only ath9k
change that is required is the one I posted (and you'll be back to the
same non-functioning state, but that's another matter).

johannes

