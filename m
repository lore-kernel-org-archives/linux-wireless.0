Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:35047 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbbHUNZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2015 09:25:00 -0400
Received: by iodt126 with SMTP id t126so81413415iod.2
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2015 06:24:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1440158921-6612-1-git-send-email-johannes@sipsolutions.net>
References: <1440158921-6612-1-git-send-email-johannes@sipsolutions.net>
Date: Fri, 21 Aug 2015 15:24:59 +0200
Message-ID: <CAA2SeNKcNG+p_V-w29QU6VkQF==a8u2sUombBogbg6WVhAzivg@mail.gmail.com> (sfid-20150821_152511_111291_17B12C00)
Subject: Re: [PATCH] mac80211: fix VHT MCS mask array overrun
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Johannes Berg <johannes.berg@intel.com>
>
> The HT MCS mask has 9 bytes, the VHT one only has 8 streams.
> Split the loops to handle this correctly.
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/cfg.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 685ec13ed7c2..f4ed256c2d8e 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -2514,15 +2514,17 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
>                         continue;
>
>                 for (j = 0; j < IEEE80211_HT_MCS_MASK_LEN; j++) {
> -                       if (~sdata->rc_rateidx_mcs_mask[i][j])
> +                       if (~sdata->rc_rateidx_mcs_mask[i][j]) {
>                                 sdata->rc_has_mcs_mask[i] = true;
> +                               break;
> +                       }
> +               }
>
> -                       if (~sdata->rc_rateidx_vht_mcs_mask[i][j])
> +               for (j = 0; j < NL80211_VHT_NSS_MAX; j++) {
> +                       if (~sdata->rc_rateidx_vht_mcs_mask[i][j]) {
>                                 sdata->rc_has_vht_mcs_mask[i] = true;
> -
> -                       if (sdata->rc_has_mcs_mask[i] &&
> -                           sdata->rc_has_vht_mcs_mask[i])
>                                 break;
> +                       }
>                 }
>         }
>
> --
> 2.1.4
>

Acked-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>

Thanks,

Lorenzo

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
