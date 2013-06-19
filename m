Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60831 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566Ab3FSOAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 10:00:11 -0400
Date: Wed, 19 Jun 2013 09:51:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, torvalds@linux-foundation.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] nl80211: fix attrbuf access race by allocating a
 separate one
Message-ID: <20130619135134.GA12079@tuxdriver.com> (sfid-20130619_160017_277953_C9E08A37)
References: <CA+55aFz=eG5-zh1toHxrx=4Qm4DvwyiBCU3u-6tc0-utfZ6xiA@mail.gmail.com>
 <1371628488.8349.3.camel@jlt4.sipsolutions.net>
 <1371630238.8349.6.camel@jlt4.sipsolutions.net>
 <20130619.013900.786603036908799505.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130619.013900.786603036908799505.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 19, 2013 at 01:39:00AM -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Wed, 19 Jun 2013 10:23:58 +0200
> 
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Since my commit 3713b4e364, nl80211_dump_wiphy() uses the global
> > nl80211_fam.attrbuf for parsing the incoming data. This wouldn't
> > be a problem if it only did so on the first dump iteration which
> > is locked against other commands in generic netlink, but due to
> > space constraints in cb->args (the needed state doesn't fit) I
> > decided to always parse the original message. That's racy though
> > since nl80211_fam.attrbuf could be used by some other parsing in
> > generic netlink concurrently.
> > 
> > For now, fix this by allocating a separate parse buffer (it's a
> > bit too big for the stack, currently 1448 bytes on 64-bit). For
> > -next, I'll change the code to parse into the global buffer in
> > the first round only and then allocate a smaller buffer to keep
> > the state in cb->args.
> > 
> > Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Acked-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
