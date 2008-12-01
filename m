Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f18.google.com ([209.85.217.18]:42070 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYLATLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 14:11:50 -0500
Received: by gxk11 with SMTP id 11so71693gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 11:11:49 -0800 (PST)
Message-ID: <43e72e890812011111h53553a18x2d17c9cf267331dd@mail.gmail.com> (sfid-20081201_201155_333110_CAA04EB2)
Date: Mon, 1 Dec 2008 11:11:48 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: [RFC v3 4/4] mac80211: move dynamic_ps_timeout to hw.conf
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1227901784-5325-5-git-send-email-kalle.valo@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1227901784-5325-1-git-send-email-kalle.valo@nokia.com>
	 <1227901784-5325-5-git-send-email-kalle.valo@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 28, 2008 at 11:49 AM, Kalle Valo <kalle.valo@nokia.com> wrote:
> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
> ---
>  include/net/mac80211.h     |    1 +
>  net/mac80211/ieee80211_i.h |    1 -
>  net/mac80211/mlme.c        |    4 ++--
>  net/mac80211/tx.c          |    4 ++--
>  net/mac80211/wext.c        |    8 ++++----
>  5 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 53a0dc5..aae8991 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -560,6 +560,7 @@ struct ieee80211_conf {
>
>        u16 listen_interval;
>        bool radio_enabled;
> +       int dynamic_ps_timeout;
>
>        u8 long_frame_max_tx_count, short_frame_max_tx_count;
>
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index ab0e2df..1317c7a 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -690,7 +690,6 @@ struct ieee80211_local {
>        unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
>
>        bool powersave;
> -       int dynamic_ps_timeout;
>        struct work_struct ps_enable_work;
>        struct work_struct ps_disable_work;
>        struct timer_list dynamic_ps_timer;
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 1d3c72b..52b2239 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -747,9 +747,9 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
>        ieee80211_bss_info_change_notify(sdata, bss_info_changed);
>
>        if (local->powersave) {
> -               if (local->dynamic_ps_timeout > 0)
> +               if (local->hw.conf.dynamic_ps_timeout > 0)
>                        mod_timer(&local->dynamic_ps_timer, jiffies +
> -                                 msecs_to_jiffies(local->dynamic_ps_timeout));
> +                                 msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
>                else {
>                        conf->flags |= IEEE80211_CONF_PS;
>                        ieee80211_hw_config(local,
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 1d7ef18..12256bd 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1477,7 +1477,7 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
>        }
>
>        if (local->hw.flags & IEEE80211_HW_NO_DYNAMIC_PS &&
> -           local->dynamic_ps_timeout > 0) {
> +           local->hw.conf.dynamic_ps_timeout > 0) {
>                if (local->hw.conf.flags & IEEE80211_CONF_PS) {
>                        netif_tx_stop_all_queues(local->mdev);
>                        queue_work(local->hw.workqueue,
> @@ -1485,7 +1485,7 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
>                }
>
>                mod_timer(&local->dynamic_ps_timer, jiffies +
> -                         msecs_to_jiffies(local->dynamic_ps_timeout));
> +                         msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
>        }
>
>        nh_pos = skb_network_header(skb) - skb->data;
> diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
> index b3ee0dc..95455d0 100644
> --- a/net/mac80211/wext.c
> +++ b/net/mac80211/wext.c
> @@ -962,7 +962,7 @@ static int ieee80211_ioctl_siwpower(struct net_device *dev,
>
>        if (wrq->disabled) {
>                ps = false;
> -               local->dynamic_ps_timeout = 0;
> +               local->hw.conf.dynamic_ps_timeout = 0;
>                goto set;
>        }
>
> @@ -977,7 +977,7 @@ static int ieee80211_ioctl_siwpower(struct net_device *dev,
>        }
>
>        if (wrq->flags & IW_POWER_TIMEOUT)
> -               local->dynamic_ps_timeout = wrq->value / 1000;
> +               local->hw.conf.dynamic_ps_timeout = wrq->value / 1000;
>
>        if (ps == local->powersave)
>                return ret;
> @@ -986,9 +986,9 @@ set:
>        local->powersave = ps;
>
>        if (ifsta->flags & IEEE80211_STA_ASSOCIATED) {
> -               if (local->dynamic_ps_timeout > 0)
> +               if (conf->dynamic_ps_timeout > 0)
>                        mod_timer(&local->dynamic_ps_timer, jiffies +
> -                                 msecs_to_jiffies(local->dynamic_ps_timeout));
> +                                 msecs_to_jiffies(conf->dynamic_ps_timeout));
>                else {
>                        if (local->powersave)
>                                conf->flags |= IEEE80211_CONF_PS;

Would it be too much trouble to add this via cfg80211/nl80211 instead
or at least add both? The more we can push in that direction the
better.

  Luis
