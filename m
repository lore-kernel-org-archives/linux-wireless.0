Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:60261 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbbAGO3J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 09:29:09 -0500
Received: by mail-wi0-f175.google.com with SMTP id l15so7594381wiw.8
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2015 06:29:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1420640505-16838-1-git-send-email-arik@wizery.com>
References: <1420640505-16838-1-git-send-email-arik@wizery.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 7 Jan 2015 16:28:52 +0200
Message-ID: <CA+XVXfdcG+dz04UvgE4+cmkzciO6f92jXqAuqOJyEgrOU4SFpA@mail.gmail.com> (sfid-20150107_152912_919580_AD46DD6A)
Subject: Re: [PATCH v2] mac80211: add TDLS supported channels correctly
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 7, 2015 at 4:21 PM, Arik Nemtsov <arik@wizery.com> wrote:
> The function adding the supported channels IE during a TDLS connection had
> several issues:
> 1. If the entire subband is usable, the function exitted the loop without
>    adding it
> 2. The function only checked chandef_usable, ignoring flags like RADAR
>    which would prevent TDLS off-channel communcation.
> 3. HT20 was explicitly required in the chandef, while not a requirement
>    for TDLS off-channel.
>
> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  net/mac80211/tdls.c | 26 +++++++++++++++++++++-----
>  1 file changed, 21 insertions(+), 5 deletions(-)
>
> diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
> index 55ddd77..c5c4342 100644
> --- a/net/mac80211/tdls.c
> +++ b/net/mac80211/tdls.c
> @@ -68,17 +68,24 @@ ieee80211_tdls_add_subband(struct ieee80211_sub_if_data *sdata,
>                 ch = ieee80211_get_channel(sdata->local->hw.wiphy, i);
>                 if (ch) {
>                         /* we will be active on the channel */
> -                       u32 flags = IEEE80211_CHAN_DISABLED |
> -                                   IEEE80211_CHAN_NO_IR;
>                         cfg80211_chandef_create(&chandef, ch,
> -                                               NL80211_CHAN_HT20);
> -                       if (cfg80211_chandef_usable(sdata->local->hw.wiphy,
> -                                                   &chandef, flags)) {
> +                                               NL80211_CHAN_NO_HT);
> +                       if (cfg80211_reg_can_beacon(sdata->local->hw.wiphy,
> +                                                   &chandef,
> +                                                   sdata->wdev.iftype)) {
>                                 ch_cnt++;
> +                               /*
> +                                * check if the next channel is also part of
> +                                * this allowed range */
> +                                *

argh. resending. this wasn't compiled properly :)
