Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757929AbaKTUf1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 15:35:27 -0500
Date: Thu, 20 Nov 2014 21:35:25 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] cfg80211: leave invalid channels on regdomain
	change
Message-ID: <20141120203525.GP24486@wotan.suse.de> (sfid-20141120_213544_633693_4A91930E)
References: <1415895219-19848-1-git-send-email-arik@wizery.com> <20141113224556.GD24486@wotan.suse.de> <CA+XVXffuKE2heFPWmVWGre8cL3VZX5U63_Rru9uXKiqbpz5xYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+XVXffuKE2heFPWmVWGre8cL3VZX5U63_Rru9uXKiqbpz5xYA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 16, 2014 at 01:00:16PM +0200, Arik Nemtsov wrote:
> On Fri, Nov 14, 2014 at 12:45 AM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> >> + * @REGULATORY_ENFORCE_CHANNELS: the regulatory core will make sure all
> >> + *   interfaces on this wiphy reside on allowed channels. Upon a regdomain
> >> + *   change, the interfaces are given a grace period to disconnect or move
> >> + *   to an allowed channels. Interfaces on forbidden channels are forcibly
> >> + *   disconnected.
> >
> > I don't like this name, it would seem folks not using this don't
> > get to enforce channels, and that's not right, this is a feature,
> > and in fact I am not sure why this is being implemented as optional
> > rather than a standard feature. Care to explain the reasoning there?
> 
> This is a big change in behavior. It can hurt certification tests etc.
> I believe a chip vendor should opt-in for this change. Otherwise we
> risk bad user experience.

It really should only kick you off of channels you are not allowed to use,
I welcome this change and think it is important as a standard feature.
Please rename to REGULATORY_IGNORE_STALE_KICKOFF and make the behaviour
change to ignore the kick off rather than opt-in. We take measures to
operate properly regulatory and this change helps in that direction, we
want opt-in features to let folks that know what they are doing ingore
certain fatures.

> >> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> >> index 7449a8c..6459ddd 100644
> >> --- a/net/wireless/reg.c
> >> +++ b/net/wireless/reg.c
> >> @@ -56,6 +56,7 @@
> >>  #include <net/cfg80211.h>
> >>  #include "core.h"
> >>  #include "reg.h"
> >> +#include "rdev-ops.h"
> >>  #include "regdb.h"
> >>  #include "nl80211.h"
> >>
> >> @@ -66,6 +67,12 @@
> >>  #define REG_DBG_PRINT(args...)
> >>  #endif
> >>
> >> +/*
> >> + * Grace period we give before making sure all current interfaces reside on
> >> + * channels allowed by the current regulatory domain.
> >> + */
> >> +#define REG_ENFORCE_GRACE_MS 60000
> >> +
> >>  /**
> >>   * enum reg_request_treatment - regulatory request treatment
> >>   *
> >> @@ -210,6 +217,9 @@ struct reg_beacon {
> >>       struct ieee80211_channel chan;
> >>  };
> >>
> >> +static void reg_check_chans_work(struct work_struct *work);
> >> +static DECLARE_DELAYED_WORK(reg_check_chans, reg_check_chans_work);
> >> +
> >>  static void reg_todo(struct work_struct *work);
> >>  static DECLARE_WORK(reg_work, reg_todo);
> >>
> >> @@ -1518,6 +1528,90 @@ static void reg_call_notifier(struct wiphy *wiphy,
> >>               wiphy->reg_notifier(wiphy, request);
> >>  }
> >>
> >> +static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
> >> +{
> >> +     struct ieee80211_channel *ch;
> >> +     struct cfg80211_chan_def chandef;
> >> +     struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
> >> +     bool ret = true;
> >> +
> >> +     wdev_lock(wdev);
> >> +
> >> +     if (!wdev->netdev || !netif_running(wdev->netdev))
> >> +             goto out;
> >> +
> >> +     switch (wdev->iftype) {
> >> +     case NL80211_IFTYPE_AP:
> >> +     case NL80211_IFTYPE_P2P_GO:
> >> +             if (!wdev->beacon_interval)
> >> +                     goto out;
> >> +
> >> +             ret = cfg80211_reg_can_beacon(wiphy,
> >> +                                           &wdev->chandef, wdev->iftype);
> >> +             break;
> >> +     case NL80211_IFTYPE_STATION:
> >> +     case NL80211_IFTYPE_P2P_CLIENT:
> >> +             if (!wdev->current_bss ||
> >> +                 !wdev->current_bss->pub.channel)
> >> +                     goto out;
> >> +
> >> +             ch = wdev->current_bss->pub.channel;
> >> +             if (rdev->ops->get_channel &&
> >> +                 !rdev_get_channel(rdev, wdev, &chandef))
> >> +                     ret = cfg80211_chandef_usable(wiphy, &chandef,
> >> +                                                   IEEE80211_CHAN_DISABLED);
> >> +             else
> >> +                     ret = !(ch->flags & IEEE80211_CHAN_DISABLED);
> >> +             break;
> >> +     default:
> >> +             /* others not implemented for now */
> >> +             pr_info("Regulatory channel check not implemented for mode %d\n",
> >> +                     wdev->iftype);
> >
> > I feel you are being lazy here, come on, think of it and address it.
> > It can't be that hard. In fact cfg80211_leave() already deals with
> > all the logic to leave properly for all types of interfaces, you
> > just have to come up with the logic to know things should kick
> > the device off. Its not that hard.
> 
> I don't want to add modes I cannot test with HW I have. I think that's
> irresponsible, especially when the side-effects are disconnections.
> I can add IBSS as well with the HW I have, but that's about it.

I'd like to see IBSS and Mesh considered and addressed.

  Luis
