Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:59864 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbaCIPIZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 11:08:25 -0400
Received: by mail-ie0-f171.google.com with SMTP id ar20so6326639iec.2
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2014 08:08:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394376039-9644-3-git-send-email-luciano.coelho@intel.com>
References: <1394376039-9644-1-git-send-email-luciano.coelho@intel.com>
	<1394376039-9644-3-git-send-email-luciano.coelho@intel.com>
Date: Sun, 9 Mar 2014 17:08:24 +0200
Message-ID: <CAB3XZEd-EQ5zHKzvW_zVngGAtzRO8_Bm61yAYN6ADZVHVnby5w@mail.gmail.com> (sfid-20140309_160838_436713_31CC7135)
Subject: Re: [PATCH v6 2/3] mac80211: implement chanctx reservation
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michal Kazior <michal.kazior@tieto.com>, sw@simonwunderlich.de,
	andrei.otcheretianski@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Luca,

On Sun, Mar 9, 2014 at 4:40 PM, Luciano Coelho <luciano.coelho@intel.com> wrote:
> In order to support channel switch with multiple vifs and multiple
> contexts, we implement a concept of channel context reservation.  This
> allows us to reserve a channel context to be used later.
>
> The reservation functionality is not tied directly to channel switch
> and may be used in other situations (eg. reserving a channel context
> during IBSS join).
>
> We first check if an existing compatible context exists and if it
> does, we reserve it.  If there is no compatible context we create a
> new one and reserve it.
>
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> ---
[...]

> +int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
> +                                      u32 *changed)
> +{
[...]
> +
> +       *changed = local_changed;
> +
> +       ieee80211_recalc_chanctx_chantype(local, ctx);
> +       ieee80211_recalc_smps_chanctx(local, ctx);
> +       ieee80211_recalc_radar_chanctx(local, ctx);

any reason for not calling ieee80211_recalc_chanctx_min_def() as well?

Eliad.
