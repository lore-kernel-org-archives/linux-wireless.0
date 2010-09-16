Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44553 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab0IPSar (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 14:30:47 -0400
Subject: Re: [PATCH 2/2] mac80211: add p2p device type support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <AANLkTi=6KKLty-pg1O9EbGB3n9AviddL63X14z4a250Y@mail.gmail.com>
References: <20100916125821.369545798@sipsolutions.net>
	 <20100916125927.163519598@sipsolutions.net>
	 <AANLkTi=6KKLty-pg1O9EbGB3n9AviddL63X14z4a250Y@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 20:30:09 +0200
Message-ID: <1284661809.3731.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-16 at 11:22 -0700, Luis R. Rodriguez wrote:
> On Thu, Sep 16, 2010 at 5:58 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > When a driver advertises p2p device support,
> > mac80211 will handle it, but internally it will
> > rewrite the interface type to STA/AP rather than
> > P2P-STA/GO since otherwise a lot of paths need
> > to be touched that are otherwise identical. A
> > p2p boolean tells drivers whether or not a given
> > interface will be used for p2p or not.
> >
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> While at it can you add a is_beaconing_iftype() or something, that
> should reduce code and make it easier to check for these modes.

Err, it doesn't really change for drivers, since it's still AP/IBSS --
since GO is just an AP subtype internally. And anyway, I wouldn't use it
internally, so does it really belong into this patch?

johannes

