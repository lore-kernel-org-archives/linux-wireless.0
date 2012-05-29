Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51741 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab2E2OVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 10:21:42 -0400
Received: by obbtb18 with SMTP id tb18so6926869obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 May 2012 07:21:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338203942-5667-14-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
	<1338203942-5667-14-git-send-email-michal.kazior@tieto.com>
Date: Tue, 29 May 2012 17:21:42 +0300
Message-ID: <CAB3XZEdxDqyOOdi90zLz6h-98NvjZL1O04oD0uaJ5-jHmv34eA@mail.gmail.com> (sfid-20120529_162146_338715_5F39A105)
Subject: Re: [RFC 13/14] cfg80211: extend combination checking to consider channels
From: Eliad Peller <eliad@wizery.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Michal,

On Mon, May 28, 2012 at 2:19 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
> cfg80211_can_change_interface will soon be used
> before .start_ap, .join_mesh, .join_ibss and .auth to
> verify whether a given interface combination is
> allowed.
>
> .connect cannot be handled since the driver scans
> and connects on its own. It is up to the driver
> then to refuse a connection (with -EBUSY for
> example).
>
> Change-Id: I334c78aa9189f24fcf8829b98b7703ddde120eec
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
[...]

> @@ -1007,7 +1007,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
>                if (rfkill_blocked(rdev->rfkill))
>                        return notifier_from_errno(-ERFKILL);
>                mutex_lock(&rdev->devlist_mtx);
> -               ret = cfg80211_can_add_interface(rdev, wdev->iftype);
> +               ret = cfg80211_can_add_interface(rdev, wdev->iftype, NULL);

you pass NULL here...

> @@ -965,9 +983,26 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
>                if (rdev->wiphy.software_iftypes & BIT(wdev_iter->iftype))
>                        continue;
>
> +               for (i = 0; i < num_max_channels; i++) {
> +                       if (!used_channels[i]) {
> +                               used_channels[i] = chan;
> +                               num_different_channels++;
> +                               break;
> +                       }
> +                       else if (used_channels[i] == chan) {
> +                               break;
> +                       }
> +               }
> +
> +               if (i == num_max_channels) {
> +                       kfree(used_channels);
> +                       return -ENOMEM;
> +               }
> +

but this code will count it as a new channel.

Eliad.
