Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:36786 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaKEDRD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 22:17:03 -0500
Received: by mail-la0-f53.google.com with SMTP id mc6so2004986lab.26
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2014 19:17:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1414046257-22184-3-git-send-email-arik@wizery.com>
References: <1414046257-22184-1-git-send-email-arik@wizery.com> <1414046257-22184-3-git-send-email-arik@wizery.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 4 Nov 2014 19:16:42 -0800
Message-ID: <CAB=NE6VaTS+d-NJDkezN5+4b9txVrXXynMHZGxVjG08aEC2EsQ@mail.gmail.com> (sfid-20141105_041709_268068_7A4E0E72)
Subject: Re: [PATCH 2/5] cfg80211: leave invalid channels on regdomain change
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2014 at 11:37 PM, Arik Nemtsov <arik@wizery.com> wrote:
> +static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
> +{
> +       struct ieee80211_channel *ch;
> +       struct cfg80211_chan_def chandef;
> +       struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
> +       bool ret = true;
> +
> +       wdev_lock(wdev);
> +
> +       if (!wdev->netdev || !netif_running(wdev->netdev))
> +               goto out;
> +
> +       switch (wdev->iftype) {
> +       case NL80211_IFTYPE_AP:
> +       case NL80211_IFTYPE_P2P_GO:
> +               if (!wdev->beacon_interval)
> +                       goto out;
> +
> +               ret = cfg80211_reg_can_beacon(wiphy,
> +                                             &wdev->chandef, wdev->iftype);
> +               break;
> +       case NL80211_IFTYPE_STATION:
> +       case NL80211_IFTYPE_P2P_CLIENT:
> +               if (!wdev->current_bss ||
> +                   !wdev->current_bss->pub.channel)
> +                       goto out;
> +
> +               ch = wdev->current_bss->pub.channel;
> +               if (rdev->ops->get_channel &&
> +                   !rdev_get_channel(rdev, wdev, &chandef))
> +                       ret = cfg80211_chandef_usable(wiphy, &chandef,
> +                                                     IEEE80211_CHAN_DISABLED);
> +               else
> +                       ret = !(ch->flags & IEEE80211_CHAN_DISABLED);
> +               break;
> +       default:
> +               /* others not implemented for now */

Looks good to me except this of course, since its a flag that will
enable this per wiphy might as well WARN() if you really do not want
to think about this. That means that once someone does enable this on
a wiphy with the other type of interfaces they'll have to think about
this, likewise one could warn if a wiphy interface is registered with
the flag to follow this but supports a mode not handled here yet.

 Luis
