Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:65120 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbYJ3NYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 09:24:00 -0400
Received: by yx-out-2324.google.com with SMTP id 8so206072yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 06:23:59 -0700 (PDT)
Message-ID: <1ba2fa240810300623o51dbd0a6p7a7bc89795dc5d35@mail.gmail.com> (sfid-20081030_142407_090756_F1C62AE8)
Date: Thu, 30 Oct 2008 15:23:58 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH for 2.6.28] mac80211: fix basic rates
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1225300446.5439.27.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1225300446.5439.27.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 29, 2008 at 7:14 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> This fixes the basic rate bitmap calculation in mac80211.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Cc: stable@kernel.org [2.6.25, 2.6.26, 2.6.27]
> ---
> Is this appropriate for stable? It's a trivial and obvious fix, and can
> throw off the duration calculation, but it's likely nobody will ever
> really notice...

You would should fail association if one of the basic rates is not
supported  by the station
Tomas

>
>  net/mac80211/mlme.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> --- everything.orig/net/mac80211/mlme.c 2008-10-29 18:08:12.000000000 +0100
> +++ everything/net/mac80211/mlme.c      2008-10-29 18:08:19.000000000 +0100
> @@ -1307,8 +1307,9 @@ static void ieee80211_rx_mgmt_assoc_resp
>                        have_higher_than_11mbit = true;
>
>                for (j = 0; j < sband->n_bitrates; j++) {
> -                       if (sband->bitrates[j].bitrate == rate)
> -                               rates |= BIT(j);
> +                       if (sband->bitrates[j].bitrate != rate)
> +                               continue;
> +                       rates |= BIT(j);
>                        if (elems.supp_rates[i] & 0x80)
>                                basic_rates |= BIT(j);
>                }
> @@ -1321,8 +1322,9 @@ static void ieee80211_rx_mgmt_assoc_resp
>                        have_higher_than_11mbit = true;
>
>                for (j = 0; j < sband->n_bitrates; j++) {
> -                       if (sband->bitrates[j].bitrate == rate)
> -                               rates |= BIT(j);
> +                       if (sband->bitrates[j].bitrate != rate)
> +                               continue;
> +                       rates |= BIT(j);
>                        if (elems.ext_supp_rates[i] & 0x80)
>                                basic_rates |= BIT(j);
>                }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
