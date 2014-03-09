Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:53880 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbaCIPNm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 11:13:42 -0400
Received: by mail-ie0-f176.google.com with SMTP id rd18so6279535iec.21
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2014 08:13:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394376039-9644-4-git-send-email-luciano.coelho@intel.com>
References: <1394376039-9644-1-git-send-email-luciano.coelho@intel.com>
	<1394376039-9644-4-git-send-email-luciano.coelho@intel.com>
Date: Sun, 9 Mar 2014 17:13:41 +0200
Message-ID: <CAB3XZEe+-sdGfMupP7x0fKHCfevCtZDY7UrF6rRyL3==pnZf5Q@mail.gmail.com> (sfid-20140309_161349_018284_3D59D19A)
Subject: Re: [PATCH v6 3/3] mac80211: allow reservation of a running chanctx
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michal Kazior <michal.kazior@tieto.com>, sw@simonwunderlich.de,
	andrei.otcheretianski@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 9, 2014 at 4:40 PM, Luciano Coelho <luciano.coelho@intel.com> wrote:
> With single-channel drivers, we need to be able to change a running
> chanctx if we want to use chanctx reservation.  Not all drivers may be
> able to do this, so add a flag that indicates support for it.
>
> Changing a running chanctx can also be used as an optimization in
> multi-channel drivers when the context needs to be reserved for future
> usage.
>
> Introduce IEEE80211_CHANCTX_RESERVED chanctx mode to mark a channel as
> reserved so nobody else can use it (since we know it's going to
> change).  In the future, we may allow several vifs to use the same
> reservation as long as they plan to use the chanctx on the same
> future channel.
>
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> ---
[...]

> @@ -177,7 +198,12 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
>         list_for_each_entry(ctx, &local->chanctx_list, list) {
>                 const struct cfg80211_chan_def *compat;
>
> -               if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE)
> +               /* We don't support chanctx reservation for multiple
> +                * vifs yet, so don't allow reserved chanctxs to be
> +                * reused.
> +                */
> +               if ((ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE) ||
> +                   ieee80211_chanctx_is_reserved(local, ctx))
>                         continue;
>
i'm not sure that's correct.
you might want to find a chanctx in order to use it, not only for
reservation. any reason to reject it in this case?

Eliad.
