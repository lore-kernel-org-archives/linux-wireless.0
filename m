Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:36348 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbXKAAgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2007 20:36:21 -0400
Received: by wa-out-1112.google.com with SMTP id v27so378268wah
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2007 17:36:20 -0700 (PDT)
Message-ID: <8e8340660710311736k555474f3ifd7490b5f0f7b623@mail.gmail.com> (sfid-20071101_003623_865815_569F9232)
Date: Wed, 31 Oct 2007 17:36:19 -0700
From: "Luis Carlos Cobo" <luisca@cozybit.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 4/7] o80211s: (mac80211s) basic mesh interface support
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1193832985.12078.14.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4727de06.0e578c0a.2568.ffffb079@mx.google.com>
	 <1193832985.12078.14.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

thanks for the comments. I will incorporate the suggestions I don't
discuss about below (get rid of /proc/net/mesh, ieee80211s.c, etc).

On 10/31/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> > +ieee80211s-objs = ieee80211s.o ieee80211s_stats.o ieee80211s_pathtable.o
>
> I think I'd prefer shorter filenames. Maybe mesh networking should also
> be made configurable in Kconfig?

Agreed about filename length. I would prefer not to make mesh
networking configurable, as STA, IBSS, etc modes aren't configurable
either. I prefer to avoid polluting the data path with ifdefs.

> There are mesh APs too, that is not supported yet I take it? How do you
> plan to support this when you're essentially hard-coding MESH == STA
> here and in many other places?

Mesh APs are not supported yet, but we plan to support them through a
different interface type (e.g.  ..._TYPE_MAP) or extending the AP
interface type. Mesh STAs and APs will share all the mesh-specific
stuff (peer link discovery, path discovery, etc) but they have little
in common in the data path, so I do not think it makes sense to use
the same interface type for both. Maybe I should rename ..IF_TYPE_MESH
to ..IF_TYPE_MESH_STA?

> > +static void ieee80211_mesh(struct net_device *dev,
> > +                        struct ieee80211_if_sta *ifsta)
> > +{
> > +     mod_timer(&ifsta->timer, jiffies + IEEE80211_MONITORING_INTERVAL);
> > +}
>
> ?? That needs a better name, whatever it does.

Well, doesn't really do anything yet, I can rename it to
ieee80211_mesh_housekeeping, which is the function it will perform
soon.

> > +     if (rx->sdata->type == IEEE80211_IF_TYPE_MESH) {
> > +             if (((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
> > +                  !((rx->fc & IEEE80211_FCTL_FROMDS) &&
> > +                   (rx->fc & IEEE80211_FCTL_TODS)))
>
> I'd rewrite that as ((rx->fc & (FROMDS|TODS)) == TODS) or whatever it is.

It would be ((rx->fc & (FROMDS|TODS)) == (FROMDS|TODS)). Given the
length of 'FROMDS' and 'TODS' actual macros, I would leave it as it is
or add a new definition IEEE80211_FCTL_WDS = (FROMDS|TODS) and use
that.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.
