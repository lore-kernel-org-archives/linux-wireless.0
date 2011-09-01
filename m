Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37992 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab1IANXB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 09:23:01 -0400
Subject: Re: [PATCH] mac80211: stop tx before doing hw config and rate
 update
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1314675711-9363-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1314675711-9363-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Sep 2011 15:22:58 +0200
Message-ID: <1314883378.4022.25.camel@jlt3.sipsolutions.net> (sfid-20110901_152305_191972_14AD52D6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-30 at 09:11 +0530, Rajkumar Manoharan wrote:
> The assumption is that during the hw config, transmission was
> already stopped by mac80211. But during channel type change,
> the mac80211 continue to transmit frames. The driver like ath9k
> does chip reset while doing channel set. This could leads to
> buffer overflow at driver side. And also after configuring the channel
> and before calling rate updation, the frames are continued to xmit
> with older rates. This patch ensures that the frames are always
> xmitted with updated rates and avoid buffer overflow.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  net/mac80211/ieee80211_i.h |    1 +
>  net/mac80211/mlme.c        |   10 ++++++++++
>  2 files changed, 11 insertions(+), 0 deletions(-)
> 

> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -232,6 +232,13 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
>  		WARN_ON(!ieee80211_set_channel_type(local, sdata, channel_type));
>  	}
>  
> +	ieee80211_stop_queues_by_reason(&sdata->local->hw,
> +			IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE);
> +
> +	/* flush out all packets */
> +	synchronize_net();
> +
> +	drv_flush(local, false);

I'm curious -- how do you run into the case where this doesn't work
correctly right now? AFAICT that can only happen on an AP that doesn't
advertise HT in its probe responses, which is a little strange?

This can't happen when the probe response has HT since with that the
enable_ht will happen during the initial connect in
ieee80211_assoc_success(), before starting the queues in
ieee80211_set_associated().

Therefore, this can only happen with the late HT-enabling in
ieee80211_rx_mgmt_beacon(). I don't even remember what kind of stupid AP
required that, but maybe we should put this workaround there, or make it
optional? There's no need to stop queues in the regular case when the
queues aren't even started yet.

Also, as we partially discussed on IRC the other day, I'm beginning to
think that we need to not just track different reasons for stopping the
device queues, but also different reasons for stopping interface queues.
This really needs to stop interface queues only, but as you pointed out
scanning also has cases where it stops interface queues which can cause
race conditions.

johannes

