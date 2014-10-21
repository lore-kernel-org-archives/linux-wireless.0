Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:51994 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbaJUP1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 11:27:18 -0400
Received: by mail-wi0-f176.google.com with SMTP id hi2so10377086wib.15
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2014 08:27:12 -0700 (PDT)
Date: Tue, 21 Oct 2014 17:26:58 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH v5 0/4] add VHT support to minstrel_ht
Message-ID: <20141021152658.GA14839@magnum.frso.rivierawaves.com> (sfid-20141021_172722_489475_133C066F)
References: <1413812762-6605-1-git-send-email-karl.beldan@gmail.com>
 <1413816546.32358.3.camel@jlt4.sipsolutions.net>
 <20141020151302.GB7691@magnum.frso.rivierawaves.com>
 <20141020153421.GC7691@magnum.frso.rivierawaves.com>
 <1413833597.32358.6.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1413833597.32358.6.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 20, 2014 at 09:33:17PM +0200, Johannes Berg wrote:
> On Mon, 2014-10-20 at 17:34 +0200, Karl Beldan wrote:
> > > Indeed, will resending only 4/4 do ?
> 
> Sure.
> 
> > > >   CHECK   /home/johannes/sys/wireless/net/mac80211/rc80211_minstrel_ht_debugfs.c
> > > > /home/johannes/sys/wireless/net/mac80211/rc80211_minstrel_ht_debugfs.c:47 minstrel_ht_stats_dump() error: testing array offset 'i' after use.
> > > > /home/johannes/sys/wireless/net/mac80211/rc80211_minstrel_ht_debugfs.c:61 minstrel_ht_stats_dump() error: testing array offset 'i' after use.
> > > > 
> > > > Here I'm not sure, seems like it's a false positive maybe? The array
> > > > seems large enough for everything that's going on here.
> > > > 
> > > False positive.
> > > I am using CF="-Wsparse-all" and I don't get those warnings with sparse
> > > 0.4.5, I'll update.
> > > 
> > I don't get those with smatch either .. what options are you using ?
> > Thanks for the pass.
> 
> I'm using smatch git as of today (5167af76ad64) with no special
> arguments. I have a script called "sparse" that does just this:
> 
> sparse-real -Wshadow "$@" || exit 100
> smatch -p=kernel "$@" || exit 200
> 
I still don't know why I don't see the smatch array warnings here, I
guess I'll live with that for now.
 
Karl
