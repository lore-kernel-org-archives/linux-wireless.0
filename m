Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:63934 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbaBTIkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 03:40:03 -0500
Received: by mail-bk0-f47.google.com with SMTP id d7so526562bkh.6
        for <linux-wireless@vger.kernel.org>; Thu, 20 Feb 2014 00:40:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392873013-21772-7-git-send-email-luca@coelho.fi>
References: <1392873013-21772-1-git-send-email-luca@coelho.fi>
	<1392873013-21772-7-git-send-email-luca@coelho.fi>
Date: Thu, 20 Feb 2014 09:40:01 +0100
Message-ID: <CA+BoTQmKZi4oTVdcz14P-mSH+kiFMbXoAWX0E7+a4EDpjc1J0w@mail.gmail.com> (sfid-20140220_094008_430831_44693018)
Subject: Re: [PATCH v2 6/7] cfg80211/mac80211: move interface counting for
 combination check to mac80211
From: Michal Kazior <michal.kazior@tieto.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de, Bing Zhao <bzhao@marvell.com>,
	arend@broadcom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 February 2014 06:10, Luciano Coelho <luca@coelho.fi> wrote:

[...]

> @@ -520,6 +521,23 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
>         WARN_ON(sdata->dev && netif_carrier_ok(sdata->dev));
>
>         mutex_lock(&local->chanctx_mtx);
> +
> +       radar_detect_width = cfg80211_chandef_dfs_required(local->hw.wiphy,
> +                                                          chandef,
> +                                                          sdata->vif.type);
> +       if (radar_detect_width < 0) {
> +               ret = radar_detect_width;
> +               goto out;
> +       }
> +
> +       sdata->radar_required = !!(radar_detect_width);
> +
> +       ret = ieee80211_check_combinations(local->hw.wiphy, &sdata->wdev,
> +                                          chandef, IEEE80211_CHANCTX_SHARED,
> +                                          radar_detect_width);
> +       if (ret < 0)
> +               goto out;
> +

I think you forgot to change SHARED to `mode` :-)


Michał
