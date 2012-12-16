Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60184 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2LPIzw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2012 03:55:52 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so7933789ieb.19
        for <linux-wireless@vger.kernel.org>; Sun, 16 Dec 2012 00:55:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355486368-14563-3-git-send-email-johannes@sipsolutions.net>
References: <1355486368-14563-1-git-send-email-johannes@sipsolutions.net>
	<1355486368-14563-3-git-send-email-johannes@sipsolutions.net>
Date: Sun, 16 Dec 2012 10:55:51 +0200
Message-ID: <CAB3XZEeGABu9B-Cd27rjrTgtArf3gvV=2KejW+MctSWyGAL4CA@mail.gmail.com> (sfid-20121216_095556_135553_3BA8D335)
Subject: Re: [PATCH 2/3] mac80211: clean up association better in suspend
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 14, 2012 at 1:59 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> When suspending, bss_info_changed() is called to
> disable beacons, but managed mode interfaces are
> simply removed (bss_info_changed() is called with
> "no change" only). This can lead to problems.
>
> To fix this and copy the BSS configuration, clear
> it during suspend and restore it on resume.
>
> Change-Id: Ie1b7f6343fe59dfbff886b9720e4c15686d7fda7
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

> @@ -121,6 +121,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
> @@ -129,14 +131,19 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
>                 case NL80211_IFTYPE_MONITOR:
>                         /* skip these */
>                         continue;
> +               case NL80211_IFTYPE_STATION:
> +                       changed = BSS_CHANGED_ASSOC;

maybe set it only if associated?
also, is there really a point in notifying BSS_CHANGED_ASSOC without
notifying CHANGED_BSSID (and maybe CHANGED_IDLE)?

> -               /* disable beaconing */
> -               ieee80211_bss_info_change_notify(sdata,
> -                       BSS_CHANGED_BEACON_ENABLED);
> +               sdata->suspend_bss_conf = sdata->vif.bss_conf;
> +               memset(&sdata->vif.bss_conf, 0, sizeof(sdata->vif.bss_conf));

it probably doesn't matter much (as you don't notify CHANGED_IDLE),
but setting vif.idle=0 is probably not your intention here.
