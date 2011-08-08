Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50164 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1HHJWX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 05:22:23 -0400
Subject: Re: [PATCH] nl80211: Indicate driver-based offchannel TX on
 mgmt_tx_cancel_wait
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20110808091030.GA4749@jouni.qca.qualcomm.com>
References: <20110808091030.GA4749@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 11:22:15 +0200
Message-ID: <1312795335.4372.13.camel@jlt3.sipsolutions.net> (sfid-20110808_112226_584732_711A60F8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-08 at 12:10 +0300, Jouni Malinen wrote:
> Drivers that support frame transmission with mgmt_tx() may not support
> driver-based offchannel TX. Use mgmt_tx_cancel_wait instead of mgmt_tx
> when figuring out whether to indicate support for this with
> NL80211_ATTR_OFFCHANNEL_TX_OK.

Seems fine to me, I guess the driver in question isn't in the tree yet
so no need for Cc: stable?

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
> ---
>  net/wireless/nl80211.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index ec8444e..ca76977 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -871,8 +871,7 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
>  		NLA_PUT_U32(msg, NL80211_ATTR_MAX_REMAIN_ON_CHANNEL_DURATION,
>  			    dev->wiphy.max_remain_on_channel_duration);
>  
> -	/* for now at least assume all drivers have it */
> -	if (dev->ops->mgmt_tx)
> +	if (dev->ops->mgmt_tx_cancel_wait)
>  		NLA_PUT_FLAG(msg, NL80211_ATTR_OFFCHANNEL_TX_OK);
>  
>  	if (mgmt_stypes) {
> -- 
> 1.7.4.1
> 
> 


