Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37056 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab1ISTko convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 15:40:44 -0400
Received: by iaqq3 with SMTP id q3so5653654iaq.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 12:40:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110919183844.25296.65533.stgit@localhost6.localdomain6>
References: <20110919183844.25296.65533.stgit@localhost6.localdomain6>
Date: Mon, 19 Sep 2011 12:40:43 -0700
Message-ID: <CAA93jw7LnsJ-2+Js33M5JVu+Eo1920YyOiejizB9XBA04_qG_g@mail.gmail.com> (sfid-20110919_214047_895983_CCEAF2FE)
Subject: Re: [PATCH] ath6kl: pass only unicast frames for aggregation
From: Dave Taht <dave.taht@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 19, 2011 at 11:38 AM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> When pinging form ar6003 to the AP RTT was high even when power save was
> disabled:
>
> 100 packets transmitted, 97 received, 3% packet loss, time 99125ms
> rtt min/avg/max/mdev = 1.875/46.733/795.506/139.181 ms
>
> After some investigation one reason for this was that received
> multicast traffic confused the aggrecation logic and caused 400 ms
> timeouts when receiving multicast frames from AP.
>
> A simple way to fix is to pass only unicast frames for aggregation. This
> improves RTT:
>
> 100 packets transmitted, 99 received, 1% packet loss, time 99144ms
> rtt min/avg/max/mdev = 2.083/13.084/403.390/56.794 ms

I note that while the improvement above is enormous, a 403ms RTT for
a packet is the rough equivalent of a detour around all of planet Earth...
between your couch and the AP.

Can outliers of this sort be improved?

At what point are packets dropped?

>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath6kl/txrx.c |   16 +++++++++-------
>  1 files changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
> index fffd929..348c646 100644
> --- a/drivers/net/wireless/ath/ath6kl/txrx.c
> +++ b/drivers/net/wireless/ath/ath6kl/txrx.c
> @@ -1230,9 +1230,15 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
>                        ath6kl_data_tx(skb1, ar->net_dev);
>        }
>
> -       if (!aggr_process_recv_frm(ar->aggr_cntxt, tid, seq_no,
> -                                  is_amsdu, skb))
> -               ath6kl_deliver_frames_to_nw_stack(ar->net_dev, skb);
> +       datap = (struct ethhdr *) skb->data;
> +
> +       if (is_unicast_ether_addr(datap->h_dest) &&
> +           aggr_process_recv_frm(ar->aggr_cntxt, tid, seq_no,
> +                                 is_amsdu, skb))
> +               /* aggregation code will handle the skb */
> +               return;
> +
> +       ath6kl_deliver_frames_to_nw_stack(ar->net_dev, skb);
>  }
>
>  static void aggr_timeout(unsigned long arg)
> @@ -1249,10 +1255,6 @@ static void aggr_timeout(unsigned long arg)
>                if (!rxtid->aggr || !rxtid->timer_mon || rxtid->progress)
>                        continue;
>
> -               /*
> -                * FIXME: these timeouts happen quite fruently, something
> -                * line once within 60 seconds. Investigate why.
> -                */
>                stats->num_timeouts++;
>                ath6kl_dbg(ATH6KL_DBG_AGGR,
>                           "aggr timeout (st %d end %d)\n",
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Dave Täht
SKYPE: davetaht
US Tel: 1-239-829-5608
http://the-edge.blogspot.com
