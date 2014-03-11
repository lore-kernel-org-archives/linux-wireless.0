Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:36278 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbaCKKkL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 06:40:11 -0400
Received: by mail-ig0-f182.google.com with SMTP id uy17so10841151igb.3
        for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2014 03:40:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394487103-13027-2-git-send-email-luciano.coelho@intel.com>
References: <1394487103-13027-1-git-send-email-luciano.coelho@intel.com>
	<1394487103-13027-2-git-send-email-luciano.coelho@intel.com>
Date: Tue, 11 Mar 2014 12:40:10 +0200
Message-ID: <CAB3XZEdhLOOT+6CYcqCMRBDBE66-EuXXkMiSLZmvedo+iZEZaA@mail.gmail.com> (sfid-20140311_114017_103389_8FE64ED3)
Subject: Re: [PATCH v9 1/5] cfg80211: refactor cfg80211_can_use_iftype_chan()
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
> Separate the code that counts the interface types and channels from
> the code that check the interface combinations.  The new function that
> checks for combinations is exported so it can be called by the
> drivers.
>
> This is done in preparation for moving the interface combinations
> checks out of cfg80211.
>
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> ---
[...]

> +int cfg80211_check_combinations(struct wiphy *wiphy,
> +                               const int num_different_channels,
> +                               const u8 radar_detect,
> +                               const int iftype_num[NUM_NL80211_IFTYPES])
> +{
> +       int i, j, iftype;
> +       int num_interfaces = 0;
> +       u32 used_iftypes = 0;
> +
> +       for (iftype = 0; iftype < NUM_NL80211_IFTYPES; iftype++) {
> +               num_interfaces += iftype_num[iftype];
> +               if (iftype_num[iftype] > 0)
> +                       used_iftypes |= BIT(iftype);
> +       }
> +
[...]

> +
> +               for (iftype = 0; iftype < NUM_NL80211_IFTYPES; iftype++) {
> +                       if (wiphy->software_iftypes & BIT(iftype))
> +                               continue;
> +                       for (j = 0; j < c->n_limits; j++) {
> +                               all_iftypes |= limits[j].types;
> +                               if (!(limits[j].types & BIT(iftype)))
> +                                       continue;
> +                               if (limits[j].max < iftype_num[iftype])
> +                                       goto cont;
> +                               limits[j].max -= iftype_num[iftype];
> +                       }
> +               }
> +
> +               if (radar_detect && !(c->radar_detect_widths & radar_detect))
> +                       goto cont;
> +
> +               /* Finally check that all iftypes that we're currently
> +                * using are actually part of this combination. If they
> +                * aren't then we can't use this combination and have
> +                * to continue to the next.
> +                */
> +               if ((all_iftypes & used_iftypes) != used_iftypes)
> +                       goto cont;
> +
if software_iftypes will be passed to this function, this check will
fail (as they exist only in used_iftypes).

Eliad.
