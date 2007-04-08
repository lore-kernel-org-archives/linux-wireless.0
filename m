Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:33646 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbXDHHsR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2007 03:48:17 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1378301uga
        for <linux-wireless@vger.kernel.org>; Sun, 08 Apr 2007 00:48:16 -0700 (PDT)
Message-ID: <1ba2fa240704080048o326da895o4fa97e0f1cc0dc30@mail.gmail.com>
Date: Sun, 8 Apr 2007 10:48:16 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] mac80211: Report correct wireless statistics
Cc: "John Linville" <linville@tuxdriver.com>,
	"Michael Buesch" <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
In-Reply-To: <461877ea.cyxM3SSnr6WhYkjX%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <461877ea.cyxM3SSnr6WhYkjX%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What if rssi is in DBM i.e. negative number.

According definition it should be positive but then there is that code
in ieee80211.c

int ieee80211_register_hw(struct ieee80211_hw *hw).
...
if (local->hw.max_rssi < 0 || local->hw.max_noise < 0)

                local->wstats_flags |= IW_QUAL_DBM;



On 4/8/07, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> In mac80211 the 'qual' and 'level' values are interchanged. The patch also
> places the 'qual' value on a 0 - 100 scale and calculated using the formula
> contained in iwlib.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> John and Michael,
>
> This fix is meant for the wireless-dev and mb git trees.
>
> Larry
>
>  ieee80211_ioctl.c |   16 +++++++++++-----
>  ieee80211_sta.c   |    9 +++++++--
>  2 files changed, 18 insertions(+), 7 deletions(-)
>
> Index: wireless-mb/net/mac80211/ieee80211_sta.c
> ===================================================================
> --- wireless-mb.orig/net/mac80211/ieee80211_sta.c
> +++ wireless-mb/net/mac80211/ieee80211_sta.c
> @@ -2822,8 +2822,10 @@ ieee80211_sta_scan_result(struct net_dev
>
>         memset(&iwe, 0, sizeof(iwe));
>         iwe.cmd = IWEVQUAL;
> -       iwe.u.qual.qual = bss->signal;
> -       iwe.u.qual.level = bss->rssi;
> +       iwe.u.qual.level = bss->signal;
> +       if (unlikely(local->hw.max_rssi == 0))
> +               local->hw.max_rssi = 100;
> +       iwe.u.qual.qual = (100 * bss->rssi) / local->hw.max_rssi;
>         iwe.u.qual.noise = bss->noise;
>         iwe.u.qual.updated = local->wstats_flags;
>         current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
> Index: wireless-mb/net/mac80211/ieee80211_ioctl.c
> ===================================================================
> --- wireless-mb.orig/net/mac80211/ieee80211_ioctl.c
> +++ wireless-mb/net/mac80211/ieee80211_ioctl.c
> @@ -1593,12 +1593,12 @@ static int ieee80211_ioctl_giwrange(stru
>         range->min_frag = 256;
>         range->max_frag = 2346;
>
> -       range->max_qual.qual = local->hw.max_signal;
> -       range->max_qual.level = local->hw.max_rssi;
> +       range->max_qual.qual = 100;
> +       range->max_qual.level = local->hw.max_signal;
>         range->max_qual.noise = local->hw.max_noise;
>         range->max_qual.updated = local->wstats_flags;
>
> -       range->avg_qual.qual = local->hw.max_signal/2;
> +       range->avg_qual.qual = 50;
>         range->avg_qual.level = 0;
>         range->avg_qual.noise = 0;
>         range->avg_qual.updated = local->wstats_flags;
> @@ -3087,8 +3087,10 @@ static struct iw_statistics *ieee80211_g
>                 wstats->qual.noise = 0;
>                 wstats->qual.updated = IW_QUAL_ALL_INVALID;
>         } else {
> -               wstats->qual.level = sta->last_rssi;
> -               wstats->qual.qual = sta->last_signal;
> +               if (unlikely(local->hw.max_rssi == 0))
> +                       local->hw.max_rssi = 100;
> +               wstats->qual.qual = (100 * sta->last_rssi) / local->hw.max_rssi;
> +               wstats->qual.level = sta->last_signal;
>                 wstats->qual.noise = sta->last_noise;
>                 wstats->qual.updated = local->wstats_flags;
>                 sta_info_put(sta);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
