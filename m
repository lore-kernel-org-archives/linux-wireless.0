Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coelho.fi ([88.198.205.34]:60441 "EHLO dedo"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752564AbaCKNlD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 09:41:03 -0400
Message-ID: <1394545241.19973.16.camel@dubbel> (sfid-20140311_144107_929104_423F3C9D)
From: Luca Coelho <luca@coelho.fi>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michal Kazior <michal.kazior@tieto.com>, sw@simonwunderlich.de,
	andrei.otcheretianski@intel.com
Date: Tue, 11 Mar 2014 15:40:41 +0200
In-Reply-To: <CAB3XZEeEM_cH=+PN-cRm884RYyka+uVsJFvQiBdWaWNmL7U1bA@mail.gmail.com>
References: <1394487103-13027-1-git-send-email-luciano.coelho@intel.com>
	 <1394487103-13027-3-git-send-email-luciano.coelho@intel.com>
	 <CAB3XZEeEM_cH=+PN-cRm884RYyka+uVsJFvQiBdWaWNmL7U1bA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v9 2/5] cfg80211/mac80211: refactor
 cfg80211_chandef_dfs_required()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-03-11 at 12:45 +0200, Eliad Peller wrote:
> On Mon, Mar 10, 2014 at 11:31 PM, Luciano Coelho
> <luciano.coelho@intel.com> wrote:
> > Some interface types don't require DFS (such as STATION, P2P_CLIENT
> > etc).  In order to centralize these decisions, make
> > cfg80211_chandef_dfs_required() take the iftype into consideration.
> >
> > Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> > ---
> [...]
> 
> >  int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
> > -                                 const struct cfg80211_chan_def *chandef)
> > +                                 const struct cfg80211_chan_def *chandef,
> > +                                 enum nl80211_iftype iftype)
> >  {
> >         int width;
> > -       int r;
> > +       int ret;
> >
> >         if (WARN_ON(!cfg80211_chandef_valid(chandef)))
> >                 return -EINVAL;
> >
> > -       width = cfg80211_chandef_get_width(chandef);
> > -       if (width < 0)
> > -               return -EINVAL;
> > +       switch (iftype) {
> > +       case NL80211_IFTYPE_ADHOC:
> > +       case NL80211_IFTYPE_AP:
> > +       case NL80211_IFTYPE_P2P_GO:
> > +       case NL80211_IFTYPE_MESH_POINT:
> > +               width = cfg80211_chandef_get_width(chandef);
> > +               if (width < 0)
> > +                       return -EINVAL;
> >
> it's a matter of style, but i think bailing out in non-relevant cases
> and taking the code out of the switch looks better (less indentation,
> etc.).

Yeah, it's a style issue and I tend to agree with you.  But I also think
it's good to have a switch where we can easily see what happens with
each interface type.

I won't change this now, but we can refactor this at a later point if it
starts getting annoying. ;)



> [...]
> 
> > +       case NL80211_IFTYPE_STATION:
> > +       case NL80211_IFTYPE_P2P_CLIENT:
> > +       case NL80211_IFTYPE_MONITOR:
> > +       case NL80211_IFTYPE_AP_VLAN:
> > +       case NL80211_IFTYPE_WDS:
> > +       case NL80211_IFTYPE_P2P_DEVICE:
> > +               break;
> > +       case NL80211_IFTYPE_UNSPECIFIED:
> > +       case NUM_NL80211_IFTYPES:
> > +               WARN_ON(1);
> > +       }
> 
> [...]
> 
> > @@ -671,7 +700,8 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
> > -       if (cfg80211_chandef_dfs_required(wiphy, chandef) > 0 &&
> > +       if (cfg80211_chandef_dfs_required(wiphy, chandef,
> > +                                         NL80211_IFTYPE_UNSPECIFIED) > 0 &&
> wouldn't this WARN_ON()?

Yep, you're right.  Previously I was calling this and I didn't really
care what was the interface type.  But Johannes asked me to change the
cfg80211_dfs_required() code to warn if unspecified was passed and I
forgot to change it here.  I'll either have to add the iftype to the
cfg80211_reg_can_beacon() function arguments (which is a bit ugly,
because it's not really needed) or I'll have to move the UNSPECIFIED to
some sort of "don't care" in the cfg80211_chandef_dfs_required()
function.


> > @@ -5796,7 +5799,8 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
> >         if (wdev->cac_started)
> >                 return -EBUSY;
> >
> > -       err = cfg80211_chandef_dfs_required(wdev->wiphy, &chandef);
> > +       err = cfg80211_chandef_dfs_required(wdev->wiphy, &chandef,
> > +                                           NL80211_IFTYPE_UNSPECIFIED);
> ditto.

Ditto. :)

--
Cheers,
Luca.

