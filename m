Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:49021 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750927AbaEOJzq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 05:55:46 -0400
Message-ID: <1400147737.4521.11.camel@dubbel> (sfid-20140515_115548_921028_F7792DD4)
From: Luca Coelho <luca@coelho.fi>
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"janusz.dziedzic@tieto.com" <janusz.dziedzic@tieto.com>,
	"eliad@wizery.com" <eliad@wizery.com>
Date: Thu, 15 May 2014 12:55:37 +0300
In-Reply-To: <1400147514.4521.10.camel@dubbel>
References: <1400066704-7286-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1400078561.4759.12.camel@jlt4.sipsolutions.net>
	 <CAB3XZEcixQDE7FbvJ2k3jw501BjS2_LkKG72zYok6WbmzCxq5A@mail.gmail.com>
	 (sfid-20140515_112846_166140_C2756793) <1400146757.4146.1.camel@jlt4.sipsolutions.net>
	 <1400147514.4521.10.camel@dubbel>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] cfg80211: fix start_radar_detection issue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-15 at 09:51 +0000, Coelho, Luciano wrote:
> On Thu, 2014-05-15 at 11:39 +0200, Johannes Berg wrote:
> > On Thu, 2014-05-15 at 12:28 +0300, Eliad Peller wrote:
> > > On Wed, May 14, 2014 at 5:42 PM, Johannes Berg
> > > <johannes@sipsolutions.net> wrote:
> > > > On Wed, 2014-05-14 at 13:25 +0200, Janusz Dziedzic wrote:
> > > >> After patch:
> > > >> cfg80211/mac80211: refactor cfg80211_chandef_dfs_required()
> > > >>
> > > >> start_radar_detection always fail with -EINVAL.
> > > >
> > > > Applied, thanks.
> > > >
> > > probably a bit late, but i don't really see why passing
> > > NL80211_IFTYPE_UNSPECIFIED at all, instead of the iftype?
> > 
> > I did briefly wonder about the same, but decided Luca probably knew
> > better :)
> 
> Actually I also thought the same thing, but had the impression that
> there were cases when we wouldn't have the iftype when calling this.
> But now I checked both cases where we use NL80211_IFTYPE_UNSPECIFIED and
> it seems that we really don't need it.
> 
> I'll send a patch to fix this and revert Janusz's change (unless
> Johannes wants to rebase the mac80211-next tree).

Instead of just reverting Janusz's patch, I'll make
cfg80211_chandef_dfs_required() WARN if UNSPECIFIED is passed.

--
Luca.

