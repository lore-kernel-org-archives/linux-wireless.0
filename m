Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41205 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab3LPMus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 07:50:48 -0500
Message-ID: <1387198243.4665.26.camel@jlt4.sipsolutions.net> (sfid-20131216_135050_501340_C471EF04)
Subject: Re: [PATCH] mac80211_hwsim: Fix NULL pointer dereference
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Lopez <jlopex@cozybit.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org, j@w1.fi,
	danicamps81@yahoo.com
Date: Mon, 16 Dec 2013 13:50:43 +0100
In-Reply-To: <1386294806-18083-1-git-send-email-jlopex@cozybit.com> (sfid-20131206_025342_256820_98CF77E4)
References: <1386294806-18083-1-git-send-email-jlopex@cozybit.com>
	 (sfid-20131206_025342_256820_98CF77E4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-05 at 17:53 -0800, Javier Lopez wrote:
> mac80211_hwsim was crashing when receiving tx information from user
> space. Crash happens because txi->rate_driver_data[0] is pointing to a
> non valid memory address.
> 
> This code path is only used by wmediumd and wmediumd doesn't provide
> multiple channel support, so we can update txi->rate_driver_data[0]
> to point to the mac80211_hwsim_data channel information struct
> (data2->channel).
> 
> Signed-off-by: Javier Lopez <jlopex@cozybit.com>
> ---
>  drivers/net/wireless/mac80211_hwsim.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 9c0cc8d..eddf7bf 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -2013,6 +2013,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
>  	}
>  
>  	txi->status.ack_signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
> +	txi->rate_driver_data[0] = data2->channel;

It seems this overwrites status data?
 
>  	if (!(hwsim_flags & HWSIM_TX_CTL_NO_ACK) &&
>  	   (hwsim_flags & HWSIM_TX_STAT_ACK)) {
...
                if (skb->len >= 16) {
                        hdr = (struct ieee80211_hdr *) skb->data;

mac80211_hwsim_monitor_ack(txi->rate_driver_data[0],
                                                   hdr->addr2);
                }
                txi->flags |= IEEE80211_TX_STAT_ACK;
        }

Since nothing else seems to use the rate_driver_data[0] pointer, it
would be much better to just pass the channel here, no?

johannes

