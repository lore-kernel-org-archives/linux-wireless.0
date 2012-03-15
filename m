Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26337 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161627Ab2COU6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:58:12 -0400
From: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Paul Stewart <pstew@chromium.org>
Subject: RE: [RFC 3/3] mac80211: remove queue stop on rate control update
Date: Thu, 15 Mar 2012 20:58:06 +0000
Message-ID: <8F3AF1C9F856774F8C8D67AA7EDFEC8801E3006B@aphydexd01b> (sfid-20120315_220600_442861_B95B94E0)
References: <20120315154133.312616639@sipsolutions.net>,<20120315155228.414054879@sipsolutions.net>
In-Reply-To: <20120315155228.414054879@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Johannes Berg <johannes.berg@intel.com>
>
> We currently stop the queue when changing the rate
> control between 20/40 MHz in the BSS. This seems to
> have been necessary when we actually changed the
> channel, but now that we just update the station it
> doesn't seem right any more. Remove it.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/ieee80211_i.h |    1 -
>  net/mac80211/mlme.c        |   19 -------------------
>  2 files changed, 20 deletions(-)
>
> --- a/net/mac80211/ieee80211_i.h        2012-03-15 16:39:21.000000000 +0100
> +++ b/net/mac80211/ieee80211_i.h        2012-03-15 16:39:47.000000000 +0100
> @@ -743,7 +743,6 @@ enum queue_stop_reason {
>         IEEE80211_QUEUE_STOP_REASON_AGGREGATION,
>         IEEE80211_QUEUE_STOP_REASON_SUSPEND,
>         IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
> -       IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE,
>  };
>
>  #ifdef CONFIG_MAC80211_LEDS
> --- a/net/mac80211/mlme.c       2012-03-15 16:39:21.000000000 +0100
> +++ b/net/mac80211/mlme.c       2012-03-15 16:39:57.000000000 +0100
> @@ -212,21 +212,6 @@ static u32 ieee80211_config_ht_tx(struct
>         if (sta && (!reconfig ||
>                     (disable_40 != !!(sta->sta.ht_cap.cap &
>                                         IEEE80211_HT_CAP_SUP_WIDTH_20_40)))) {
> -               if (reconfig) {
> -                       /*
> -                        * Whenever the AP announces the HT mode changed
> -                        * (e.g. 40 MHz intolerant) stop queues to avoid
> -                        * sending out frames while the rate control is
> -                        * reconfiguring.
> -                        */
> -                       ieee80211_stop_queues_by_reason(&sdata->local->hw,
> -                               IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE);
> -
> -                       /* flush out all packets */
> -                       synchronize_net();
> -
> -                       drv_flush(local, false);
> -               }

The queue stop was added to avoid sending frames while the hw reconfigure is in progress.
So that we can prevent differences b/w hw and rate control ht mode. But I doubt that hw_reconfig
removal could not affect split drivers where the rc is offloaded.
>
>                 if (disable_40)
>                         sta->sta.ht_cap.cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
> @@ -235,10 +220,6 @@ static u32 ieee80211_config_ht_tx(struct
>
>                 rate_control_rate_update(local, sband, sta,
>                                          IEEE80211_RC_HT_CHANGED);
> -
> -               if (reconfig)
> -                       ieee80211_wake_queues_by_reason(&sdata->local->hw,
> -                               IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE);
>         }
>         mutex_unlock(&local->sta_mtx);
