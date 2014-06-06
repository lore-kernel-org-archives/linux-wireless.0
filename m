Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33071 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaFFFv3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 01:51:29 -0400
Received: by mail-vc0-f174.google.com with SMTP id ik5so2408309vcb.33
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2014 22:51:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401985567-27336-3-git-send-email-emmanuel.grumbach@intel.com>
References: <1401985567-27336-3-git-send-email-emmanuel.grumbach@intel.com>
Date: Fri, 6 Jun 2014 07:51:28 +0200
Message-ID: <CA+BoTQn7H7808DFhAmfBtNsO+o0CEsy3_=4QMnxU4eML7JUCQQ@mail.gmail.com> (sfid-20140606_075132_749216_9AB5F017)
Subject: Re: [PATCH 3/3] mac80211: stop only the queues assigned to the vif
 during channel switch
From: Michal Kazior <michal.kazior@tieto.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luciano.coelho@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 June 2014 18:26, Emmanuel Grumbach <emmanuel.grumbach@intel.com> wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
>
> Instead of stopping all the hardware queues during channel switch,
> which is especially bad when we have large CSA counts, stop only the
> queues that are assigned to the vif that is performing the channel
> switch.
>
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  net/mac80211/cfg.c   | 10 ++++------
>  net/mac80211/iface.c |  5 ++---
>  net/mac80211/mlme.c  | 20 ++++++++------------
>  3 files changed, 14 insertions(+), 21 deletions(-)
>
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index c6fe358..5215abb 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -1142,9 +1142,8 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
>         mutex_lock(&local->mtx);
>         sdata->vif.csa_active = false;
>         if (!ieee80211_csa_needs_block_tx(local))
> -               ieee80211_wake_queues_by_reason(&local->hw,
> -                                       IEEE80211_MAX_QUEUE_MAP,
> -                                       IEEE80211_QUEUE_STOP_REASON_CSA);
> +               ieee80211_wake_vif_queues(local, sdata,
> +                                         IEEE80211_QUEUE_STOP_REASON_CSA);
>         mutex_unlock(&local->mtx);
>
>         kfree(sdata->u.ap.next_beacon);
> @@ -3146,9 +3145,8 @@ static int __ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
>         cfg80211_ch_switch_notify(sdata->dev, &sdata->csa_chandef);
>
>         if (!ieee80211_csa_needs_block_tx(local))
> -               ieee80211_wake_queues_by_reason(&local->hw,
> -                                       IEEE80211_MAX_QUEUE_MAP,
> -                                       IEEE80211_QUEUE_STOP_REASON_CSA);
> +               ieee80211_wake_vif_queues(local, sdata,
> +                                         IEEE80211_QUEUE_STOP_REASON_CSA);

I don't think this is going to work with the upcomming multi-vif
channel switching.

The ieee80211_csa_needs_block_tx() will become false upon *last*
interface switch completion. This means preceeding interface csa
finalizations won't call ieee80211_wake_vif_queues() so you actually
end up not waking all of the queues when you finish csa.

I think this can be solved with:

 if (!ieee80211_csa_needs_block_tx(local))
   list_for_each(sdata, &local->interfaces, list)
     ieee80211_wake_vif_queues(local, sdata, REASON_CSA);

But then I guess it's just a convoluted way of saying:

 if (!ieee80211_csa_needs_block_tx(local))
   ieee80211_wake_queues_by_reason(hw, REASON_CSA);

IOW waking should remain as it was while stopping can be done per-vif.

This goes for all instances calling wake_vif_queues() in the patch.

Generally I don't think having wake_vif_queues() is a good idea. It's
really tricky. Sure, you can have a stop_vif_queues() which will
behave as you might expect (i.e. first call stops queues and
overlapping vif-queue mappings are not a concern). But
wake_vif_queues() seems to have little practical use to me without any
kind of per-queue reference counting.


Michał
