Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39044 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbaJTTdW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 15:33:22 -0400
Message-ID: <1413833597.32358.6.camel@jlt4.sipsolutions.net> (sfid-20141020_213324_765810_90E3409F)
Subject: Re: [PATCH v5 0/4] add VHT support to minstrel_ht
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Date: Mon, 20 Oct 2014 21:33:17 +0200
In-Reply-To: <20141020153421.GC7691@magnum.frso.rivierawaves.com> (sfid-20141020_173424_813444_3F3D6DB2)
References: <1413812762-6605-1-git-send-email-karl.beldan@gmail.com>
	 <1413816546.32358.3.camel@jlt4.sipsolutions.net>
	 <20141020151302.GB7691@magnum.frso.rivierawaves.com>
	 <20141020153421.GC7691@magnum.frso.rivierawaves.com>
	 (sfid-20141020_173424_813444_3F3D6DB2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-20 at 17:34 +0200, Karl Beldan wrote:
> > Indeed, will resending only 4/4 do ?

Sure.

> > >   CHECK   /home/johannes/sys/wireless/net/mac80211/rc80211_minstrel_ht_debugfs.c
> > > /home/johannes/sys/wireless/net/mac80211/rc80211_minstrel_ht_debugfs.c:47 minstrel_ht_stats_dump() error: testing array offset 'i' after use.
> > > /home/johannes/sys/wireless/net/mac80211/rc80211_minstrel_ht_debugfs.c:61 minstrel_ht_stats_dump() error: testing array offset 'i' after use.
> > > 
> > > Here I'm not sure, seems like it's a false positive maybe? The array
> > > seems large enough for everything that's going on here.
> > > 
> > False positive.
> > I am using CF="-Wsparse-all" and I don't get those warnings with sparse
> > 0.4.5, I'll update.
> > 
> I don't get those with smatch either .. what options are you using ?
> Thanks for the pass.

I'm using smatch git as of today (5167af76ad64) with no special
arguments. I have a script called "sparse" that does just this:

sparse-real -Wshadow "$@" || exit 100
smatch -p=kernel "$@" || exit 200

johannes

