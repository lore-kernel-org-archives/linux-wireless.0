Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35731 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab2KZNSb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 08:18:31 -0500
Message-ID: <1353935938.9488.32.camel@jlt4.sipsolutions.net> (sfid-20121126_141841_768326_ADAE0D0A)
Subject: Re: [PATCH 2/2] mac80211: support P2P GO powersave configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 26 Nov 2012 14:18:58 +0100
In-Reply-To: <CAB3XZEdRa2=_eq9q0Bt07SA=qasnpA6cm1r8YiLZ-qkiQAg5JA@mail.gmail.com> (sfid-20121126_135926_175728_F3459150)
References: <1353930289-2710-1-git-send-email-johannes@sipsolutions.net>
	 <1353930289-2710-3-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEdRa2=_eq9q0Bt07SA=qasnpA6cm1r8YiLZ-qkiQAg5JA@mail.gmail.com>
	 (sfid-20121126_135926_175728_F3459150)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-26 at 14:59 +0200, Eliad Peller wrote:
> On Mon, Nov 26, 2012 at 1:44 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > If the low-level driver wants to support P2P GO
> > powersave configuration, it must set the cfg80211
> > flags and mac80211 will pass the parameters to it.
> >
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> >  net/mac80211/cfg.c | 16 +++++++++++++++-
> >  1 file changed, 15 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> > index 5d30e5f..97cf615 100644
> > --- a/net/mac80211/cfg.c
> > +++ b/net/mac80211/cfg.c
> > @@ -893,7 +893,8 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
> >         u32 changed = BSS_CHANGED_BEACON_INT |
> >                       BSS_CHANGED_BEACON_ENABLED |
> >                       BSS_CHANGED_BEACON |
> > -                     BSS_CHANGED_SSID;
> > +                     BSS_CHANGED_SSID |
> > +                     BSS_CHANGED_P2P_PS;
> >         int err;
> >
> you'd probably want to add it to ieee80211_reconfig as well.

Good point. I also have some changes in the nl80211 for verification,
let me repost.

johannes

