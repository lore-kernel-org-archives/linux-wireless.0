Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:34516 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934064Ab2GLQAX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 12:00:23 -0400
Received: by qadb17 with SMTP id b17so3981457qad.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jul 2012 09:00:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1342106133-26954-1-git-send-email-johannes@sipsolutions.net>
References: <1342106133-26954-1-git-send-email-johannes@sipsolutions.net>
Date: Thu, 12 Jul 2012 19:00:22 +0300
Message-ID: <CAB3XZEdfVAgNH4vP6B0O36riyDokpf+UHEG-+Yqn2a1Xjpt8ow@mail.gmail.com> (sfid-20120712_180036_026881_54FCAEC4)
Subject: Re: [PATCH] cfg80211: fix set_monitor_enabled
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 12, 2012 at 6:15 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> When bringing monitor mode up with a driver using the
> mac80211 virtual monitor interface this resulted in a
> warning because cfg80211_update_iface_num() is called
> from PRE_UP, which causes it to call mac80211 and the
> low-level driver before the device is started.
>
> For the case that another interface is added and the
> monitor interface should be removed, this is correct.
> However, in the case where a monitor interface is
> added, it's not correct as the above.
>
> To fix this, we need to split up the cases and track
> whether or not "only monitor" is active so that the
> code can correctly call into the driver when things
> change.
>
> Reported-by: Mohammed Shafi <shafi.wireless@gmail.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
why not always do it only on IFACE_UP?

> @@ -893,8 +893,12 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
>         if (!err && ntype != otype && netif_running(dev)) {
> -               cfg80211_update_iface_num(rdev, ntype, 1);
> -               cfg80211_update_iface_num(rdev, otype, -1);
> +               cfg80211_update_iface_num(rdev, ntype,
> +                                         CFG80211_IFACE_DOWN);
> +               cfg80211_update_iface_num(rdev, ntype,
> +                                         CFG80211_IFACE_PRE_UP);
> +               cfg80211_update_iface_num(rdev, otype,
> +                                         CFG80211_IFACE_UP);

this sequence (down(new_type), pre_up (new_type), up(old_type))
doesn't make any sense to me :)

Eliad.
