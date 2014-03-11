Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:44898 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaCKKpB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 06:45:01 -0400
Received: by mail-ig0-f175.google.com with SMTP id ur14so10822475igb.2
        for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2014 03:45:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394487103-13027-3-git-send-email-luciano.coelho@intel.com>
References: <1394487103-13027-1-git-send-email-luciano.coelho@intel.com>
	<1394487103-13027-3-git-send-email-luciano.coelho@intel.com>
Date: Tue, 11 Mar 2014 12:45:01 +0200
Message-ID: <CAB3XZEeEM_cH=+PN-cRm884RYyka+uVsJFvQiBdWaWNmL7U1bA@mail.gmail.com> (sfid-20140311_114507_108935_E8A25574)
Subject: Re: [PATCH v9 2/5] cfg80211/mac80211: refactor cfg80211_chandef_dfs_required()
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michal Kazior <michal.kazior@tieto.com>, sw@simonwunderlich.de,
	andrei.otcheretianski@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 10, 2014 at 11:31 PM, Luciano Coelho
<luciano.coelho@intel.com> wrote:
> Some interface types don't require DFS (such as STATION, P2P_CLIENT
> etc).  In order to centralize these decisions, make
> cfg80211_chandef_dfs_required() take the iftype into consideration.
>
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> ---
[...]

>  int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
> -                                 const struct cfg80211_chan_def *chandef)
> +                                 const struct cfg80211_chan_def *chandef,
> +                                 enum nl80211_iftype iftype)
>  {
>         int width;
> -       int r;
> +       int ret;
>
>         if (WARN_ON(!cfg80211_chandef_valid(chandef)))
>                 return -EINVAL;
>
> -       width = cfg80211_chandef_get_width(chandef);
> -       if (width < 0)
> -               return -EINVAL;
> +       switch (iftype) {
> +       case NL80211_IFTYPE_ADHOC:
> +       case NL80211_IFTYPE_AP:
> +       case NL80211_IFTYPE_P2P_GO:
> +       case NL80211_IFTYPE_MESH_POINT:
> +               width = cfg80211_chandef_get_width(chandef);
> +               if (width < 0)
> +                       return -EINVAL;
>
it's a matter of style, but i think bailing out in non-relevant cases
and taking the code out of the switch looks better (less indentation,
etc.).

[...]

> +       case NL80211_IFTYPE_STATION:
> +       case NL80211_IFTYPE_P2P_CLIENT:
> +       case NL80211_IFTYPE_MONITOR:
> +       case NL80211_IFTYPE_AP_VLAN:
> +       case NL80211_IFTYPE_WDS:
> +       case NL80211_IFTYPE_P2P_DEVICE:
> +               break;
> +       case NL80211_IFTYPE_UNSPECIFIED:
> +       case NUM_NL80211_IFTYPES:
> +               WARN_ON(1);
> +       }

[...]

> @@ -671,7 +700,8 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
> -       if (cfg80211_chandef_dfs_required(wiphy, chandef) > 0 &&
> +       if (cfg80211_chandef_dfs_required(wiphy, chandef,
> +                                         NL80211_IFTYPE_UNSPECIFIED) > 0 &&
wouldn't this WARN_ON()?

> @@ -5796,7 +5799,8 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
>         if (wdev->cac_started)
>                 return -EBUSY;
>
> -       err = cfg80211_chandef_dfs_required(wdev->wiphy, &chandef);
> +       err = cfg80211_chandef_dfs_required(wdev->wiphy, &chandef,
> +                                           NL80211_IFTYPE_UNSPECIFIED);
ditto.

Eliad.
