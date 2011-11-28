Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34957 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab1K1XIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 18:08:47 -0500
Received: by ghrr1 with SMTP id r1so5751628ghr.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 15:08:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322521654-8745-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1322521654-8745-1-git-send-email-mcgrof@qca.qualcomm.com>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Mon, 28 Nov 2011 18:08:26 -0500
Message-ID: <CAB=NE6V7viVAsZwZmR9afyXWy=hLeG=7FOBeFW+d2UUO3FA+qQ@mail.gmail.com> (sfid-20111129_000850_805061_15E4B3D0)
Subject: Re: [PATCH v4] cfg80211: Restore orig channel values upon disconnect
To: linux-wireless@vger.kernel.org
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	compat@orbit-lab.org, Paul Stewart <pstew@google.com>,
	Senthilkumar Balasubramanian <senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And this is also RFC.. not [PATCH] yet.

 Luis

On Mon, Nov 28, 2011 at 6:07 PM, Luis R. Rodriguez
<mcgrof@qca.qualcomm.com> wrote:
> From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
>
> When we restore regulatory settings the world regulatory domain
> is properly reset on cfg80211 (or user prefered regulatory domain)
> but we were never setting back channel values for drivers that use
> WIPHY_FLAG_CUSTOM_REGULATORY. Set these values up again by using
> the orig_ channel parameters.
>
> This fixes restoring custom regulatory settings upon disconnect
> events.
>
> Cc: compat@orbit-lab.org
> Cc: Paul Stewart <pstew@google.com>
> Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> Cc: Senthilkumar Balasubramanian <senthilb@qca.qualcomm.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
> ---
>
> Sorry here is my fixed patch which ammend's Rajkumar's original patch,
> I had not commited my changes to his patch.
>
>  net/wireless/reg.c |   26 ++++++++++++++++++++++++++
>  1 files changed, 26 insertions(+), 0 deletions(-)
>
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 4fe396a..504d3f1 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1780,6 +1780,26 @@ static void restore_alpha2(char *alpha2, bool reset_user)
>                REG_DBG_PRINT("Restoring regulatory settings\n");
>  }
>
> +static void restore_custom_reg_settings(struct wiphy *wiphy)
> +{
> +       struct ieee80211_supported_band *sband;
> +       enum ieee80211_band band;
> +       struct ieee80211_channel *chan;
> +       int i;
> +
> +       for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
> +               sband = wiphy->bands[band];
> +               if (!sband)
> +                       continue;
> +               for (i = 0; i < sband->n_channels; i++) {
> +                       chan = &sband->channels[i];
> +                       chan->flags = chan->orig_flags;
> +                       chan->max_antenna_gain = chan->orig_mag;
> +                       chan->max_power = chan->orig_mpwr;
> +               }
> +       }
> +}
> +
>  /*
>  * Restoring regulatory settings involves ingoring any
>  * possibly stale country IE information and user regulatory
> @@ -1801,6 +1821,7 @@ static void restore_regulatory_settings(bool reset_user)
>        struct reg_beacon *reg_beacon, *btmp;
>        struct regulatory_request *reg_request, *tmp;
>        LIST_HEAD(tmp_reg_req_list);
> +       struct cfg80211_registered_device *rdev;
>
>        mutex_lock(&cfg80211_mutex);
>        mutex_lock(&reg_mutex);
> @@ -1853,6 +1874,11 @@ static void restore_regulatory_settings(bool reset_user)
>                kfree(last_request);
>        last_request = &core_request_world;
>
> +       list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
> +               if (rdev->wiphy.flags & WIPHY_FLAG_CUSTOM_REGULATORY)
> +                       restore_custom_reg_settings(&rdev->wiphy);
> +       }
> +
>        mutex_unlock(&reg_mutex);
>        mutex_unlock(&cfg80211_mutex);
>
> --
> 1.7.4.15.g7811d
>
>
