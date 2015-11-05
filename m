Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38339 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032504AbbKENsY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 08:48:24 -0500
Received: by wmeg8 with SMTP id g8so13883206wme.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2015 05:48:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1445931520-14509-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1445931520-14509-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Thu, 5 Nov 2015 14:48:23 +0100
Message-ID: <CALhHN=o9mO9q2T0hQ9Q6JjjiFvZLoOXs8YWOW5oT6wtjgs9Fpg@mail.gmail.com> (sfid-20151105_144828_494736_63524ED1)
Subject: Re: [PATCH] mac80211: add new IEEE80211_VIF_GET_NOA_UPDATE flag
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Any comments? :)

On 27 October 2015 at 08:38, Janusz Dziedzic <janusz.dziedzic@tieto.com> wrote:
> Add new VIF flag, that will allow get NOA update
> notification when driver will request this, even
> this is not pure P2P vif (eg. STA vif).
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> ---
>  include/net/mac80211.h | 4 ++++
>  net/mac80211/mlme.c    | 6 ++++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 4ec6fed..1173c63 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1325,11 +1325,15 @@ struct ieee80211_channel_switch {
>   *     interface. This flag should be set during interface addition,
>   *     but may be set/cleared as late as authentication to an AP. It is
>   *     only valid for managed/station mode interfaces.
> + * @IEEE80211_VIF_GET_NOA_UPDATE: request to handle NOA attributes
> + *     and send P2P_PS notification to the driver if NOA changed, even
> + *     this is not pure P2P vif.
>   */
>  enum ieee80211_vif_flags {
>         IEEE80211_VIF_BEACON_FILTER             = BIT(0),
>         IEEE80211_VIF_SUPPORTS_CQM_RSSI         = BIT(1),
>         IEEE80211_VIF_SUPPORTS_UAPSD            = BIT(2),
> +       IEEE80211_VIF_GET_NOA_UPDATE            = BIT(3),
>  };
>
>  /**
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 56ef9a8..5bafd1e 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1941,7 +1941,8 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
>
>         sdata->u.mgd.flags |= IEEE80211_STA_RESET_SIGNAL_AVE;
>
> -       if (sdata->vif.p2p) {
> +       if (sdata->vif.p2p ||
> +           sdata->vif.driver_flags & IEEE80211_VIF_GET_NOA_UPDATE) {
>                 const struct cfg80211_bss_ies *ies;
>
>                 rcu_read_lock();
> @@ -3461,7 +3462,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
>                 }
>         }
>
> -       if (sdata->vif.p2p) {
> +       if (sdata->vif.p2p ||
> +           sdata->vif.driver_flags & IEEE80211_VIF_GET_NOA_UPDATE) {
>                 struct ieee80211_p2p_noa_attr noa = {};
>                 int ret;
>
> --
> 1.9.1
>
