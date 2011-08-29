Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47038 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab1H2PSb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 11:18:31 -0400
Subject: Re: [RFC v2] mac80211: stop tx before doing hw config and rate
 update
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1314617635-27936-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1314617635-27936-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 17:18:29 +0200
Message-ID: <1314631109.8959.20.camel@jlt3.sipsolutions.net> (sfid-20110829_171834_350554_5697A3E6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-29 at 17:03 +0530, Rajkumar Manoharan wrote:
> The assumption is that during the hw config, transmission was
> already stopped by mac80211. But during channel type change,
> the mac80211 continue to transmit frames. The driver like ath9k
> does chip reset while doing channel set. This could leads to
> buffer overflow at driver side. And also after configuring the channel
> and before doing rate updation, the frames are continued to xmit
> with older rates. This patch ensures that the frames are always
> xmitted with updated rates and avoid buffer overflow.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
> v2: Removed new stop queue reason code by netif
>  net/mac80211/mlme.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 60a6f27..a1deb33 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -232,6 +232,9 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
>  		WARN_ON(!ieee80211_set_channel_type(local, sdata, channel_type));
>  	}
>  
> +	netif_tx_stop_all_queues(sdata->dev);
> +
> +	drv_flush(local, false);

doesn't that also need synchronize_net()?

johannes

