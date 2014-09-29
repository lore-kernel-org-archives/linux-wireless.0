Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34784 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaI2JCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 05:02:15 -0400
Received: by mail-wi0-f171.google.com with SMTP id ho1so2718730wib.4
        for <linux-wireless@vger.kernel.org>; Mon, 29 Sep 2014 02:02:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1411760105-18614-7-git-send-email-luca@coelho.fi>
References: <1411760105-18614-1-git-send-email-luca@coelho.fi>
	<1411760105-18614-7-git-send-email-luca@coelho.fi>
Date: Mon, 29 Sep 2014 11:02:13 +0200
Message-ID: <CA+BoTQmG+GJieeQevaHxoQ8xdu1_OE=SWuC5QsS=JFzP2FQtRA@mail.gmail.com> (sfid-20140929_110219_212613_A7ACA472)
Subject: Re: [PATCH 6/7] mac80211: wait for the first beacon on the new
 channel after CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 September 2014 21:35, Luca Coelho <luca@coelho.fi> wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
>
> Instead of immediately reopening the queues (in case of block_tx),
> calling the post_channel_switch operation and sending the
> notification, wait for the first beacon on the new channel.  This
> makes sure that we don't lose packets if the AP/GO is not on the new
> channel yet.
>
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
[...]

Just a few nitpicks from me:

> +static void ieee80211_chswitch_post_beacon(struct ieee80211_sub_if_data *sdata)
> +{
> +       struct ieee80211_local *local = sdata->local;
> +       struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> +       int ret;
> +
> +       sdata_assert_lock(sdata);
>

I was thinking about WARN_ON(!sdata->vif.csa_active) here. csa_active
should be set in all cases if csa_waiting_bcn is set, no?


> -       /* XXX: wait for a beacon first? */
>         if (sdata->csa_block_tx) {
>                 ieee80211_wake_vif_queues(local, sdata,
>                                           IEEE80211_QUEUE_STOP_REASON_CSA);
>                 sdata->csa_block_tx = false;
>         }
>
> +       sdata->vif.csa_active = false;
> +       ifmgd->csa_waiting_bcn = false;
> +
>         ret = drv_post_channel_switch(sdata);
>         if (ret) {
>                 sdata_info(sdata,
>                            "driver post channel switch failed, disconnecting\n");
>                 ieee80211_queue_work(&local->hw,
>                                      &ifmgd->csa_connection_drop_work);
> -               goto out;
> +               return;
>         }
>       <---- here
> -       ieee80211_sta_reset_beacon_monitor(sdata);
> -       ieee80211_sta_reset_conn_monitor(sdata);
> -
> -out:
> -       mutex_unlock(&local->chanctx_mtx);
> -       mutex_unlock(&local->mtx);
> -       sdata_unlock(sdata);
>  }

Is that an empty line I before final `}`?


Michał
