Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56878 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab1JUEYe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 00:24:34 -0400
Received: by wyg36 with SMTP id 36so3550120wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2011 21:24:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1319135408-6370-2-git-send-email-thomas@cozybit.com>
References: <1319135408-6370-1-git-send-email-thomas@cozybit.com>
	<1319135408-6370-2-git-send-email-thomas@cozybit.com>
Date: Thu, 20 Oct 2011 21:24:33 -0700
Message-ID: <CAG6hwVMAaE1BKZczFL2-W44Jw4WaSpViC0ymvuCb2eA4n9ZmMQ@mail.gmail.com> (sfid-20111021_062446_179048_B50B7ECB)
Subject: Re: [PATCH v2 2/2] mac80211: select queue for fwded mesh frames
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 20, 2011 at 11:30 AM, Thomas Pedersen <thomas@cozybit.com> wrote:
> Set proper queue mapping and timestamp for forwarded mesh frames.
>
> Thanks to Luis Rodriguez for investigating and fixing this.
>
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
>
> ---
> v2:
>        We were already doing this for mcast frames, so don't duplicate
>        the code.
>
>  net/mac80211/rx.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index b867bd5..1408472 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1952,13 +1952,15 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
>                        info = IEEE80211_SKB_CB(fwd_skb);
>                        memset(info, 0, sizeof(*info));
>                        info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
> +                       info->control.jiffies = jiffies;
>                        info->control.vif = &rx->sdata->vif;
> +                       skb_set_queue_mapping(fwd_skb,
> +                               ieee80211_select_queue(sdata, fwd_skb));
> +                       ieee80211_set_qos_hdr(sdata, fwd_skb);
> +
>                        if (is_multicast_ether_addr(fwd_hdr->addr1)) {
>                                IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
>                                                                fwded_mcast);
> -                               skb_set_queue_mapping(fwd_skb,
> -                                       ieee80211_select_queue(sdata, fwd_skb));
> -                               ieee80211_set_qos_hdr(sdata, fwd_skb);
>                        } else {
>                                int err;
>                                /*
> --
> 1.7.5.4
>
>

John,

It seems this patch reverts part of
4777be41638cfab56c78b2a764a5f83beb6cfdd2 "mac80211: Start implementing
QoS support for mesh interfaces", and is probably the cause for some
breakage we're seeing here. Please hold off on this patch until I can
figure out what the right thing to do is.

Thanks,
Thomas
