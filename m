Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:27348 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbYFSLrA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 07:47:00 -0400
Received: by rv-out-0506.google.com with SMTP id k40so5116996rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jun 2008 04:46:57 -0700 (PDT)
Message-ID: <1ba2fa240806190446n4d931e6ara4db156900e59e0d@mail.gmail.com> (sfid-20080619_134706_598263_0938689F)
Date: Thu, 19 Jun 2008 14:46:57 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Broken fragmentation
Cc: "Linux Wireless" <linux-wireless@vger.kernel.org>
In-Reply-To: <1213869365.1312.48.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1ba2fa240806190220l18fe5dcdsf44fe81412a5f35d@mail.gmail.com>
	 <1213869365.1312.48.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 19, 2008 at 12:56 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-06-19 at 12:20 +0300, Tomas Winkler wrote:
>> Johannes
>> Your patch bellow has broken the fragmentation. Can you please have a
>> look at this.
>
>>           /* Setup duration field for the first fragment of the frame. Duration
>>        * for remaining fragments will be updated when they are being sent
>>        * to low-level driver in ieee80211_tx(). */
>>       dur = ieee80211_duration(tx, is_multicast_ether_addr(hdr->addr1),
>>                                (tx->flags & IEEE80211_TX_FRAGMENTED) ?
>>                                tx->extra_frag[0]->len : 0);                                 --
>> NULL pointer
>
> Oops, you're right, I missed the part where it accesses the fragments,
> the bulk of the function does txinfo updates which I didn't want to
> apply to all fragments.
>
> There is another bug too, this must come after encryption since
> encryption can add to the length of the frame. What do you think about
> the patch below? Untested so far because I have to go and wanted to get
> it out to you.
>

Now it crashes in the driver...maybe the txinfo to cb changes. Looking into it.
Tomas

> johannes
>
> ---
>  net/mac80211/tx.c |   66 ++++++++++++++++++++++++++++--------------------------
>  1 file changed, 35 insertions(+), 31 deletions(-)
>
> --- everything.orig/net/mac80211/tx.c   2008-06-19 11:25:12.000000000 +0200
> +++ everything/net/mac80211/tx.c        2008-06-19 11:53:08.000000000 +0200
> @@ -87,8 +87,8 @@ static inline void ieee80211_dump_frame(
>  }
>  #endif /* CONFIG_MAC80211_LOWTX_FRAME_DUMP */
>
> -static u16 ieee80211_duration(struct ieee80211_tx_data *tx, int group_addr,
> -                             int next_frag_len)
> +static __le16 ieee80211_duration(struct ieee80211_tx_data *tx, int group_addr,
> +                                int next_frag_len)
>  {
>        int rate, mrate, erp, dur, i;
>        struct ieee80211_rate *txrate;
> @@ -140,7 +140,7 @@ static u16 ieee80211_duration(struct iee
>
>        /* data/mgmt */
>        if (0 /* FIX: data/mgmt during CFP */)
> -               return 32768;
> +               return cpu_to_le16(32768);
>
>        if (group_addr) /* Group address as the destination - no ACK */
>                return 0;
> @@ -210,7 +210,7 @@ static u16 ieee80211_duration(struct iee
>                                tx->sdata->bss_conf.use_short_preamble);
>        }
>
> -       return dur;
> +       return cpu_to_le16(dur);
>  }
>
>  static int inline is_ieee80211_device(struct net_device *dev,
> @@ -544,7 +544,6 @@ ieee80211_tx_h_misc(struct ieee80211_tx_
>  {
>        struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
>        u16 fc = le16_to_cpu(hdr->frame_control);
> -       u16 dur;
>        struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
>        struct ieee80211_supported_band *sband;
>
> @@ -602,14 +601,6 @@ ieee80211_tx_h_misc(struct ieee80211_tx_
>                info->flags |= IEEE80211_TX_CTL_SHORT_PREAMBLE;
>        }
>
> -       /* Setup duration field for the first fragment of the frame. Duration
> -        * for remaining fragments will be updated when they are being sent
> -        * to low-level driver in ieee80211_tx(). */
> -       dur = ieee80211_duration(tx, is_multicast_ether_addr(hdr->addr1),
> -                                (tx->flags & IEEE80211_TX_FRAGMENTED) ?
> -                                tx->extra_frag[0]->len : 0);
> -       hdr->duration_id = cpu_to_le16(dur);
> -
>        if ((info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) ||
>            (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)) {
>                struct ieee80211_rate *rate;
> @@ -755,6 +746,36 @@ ieee80211_tx_h_encrypt(struct ieee80211_
>  }
>
>  static ieee80211_tx_result
> +ieee80211_tx_h_calculate_duration(struct ieee80211_tx_data *tx)
> +{
> +       struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
> +       int next_len, i;
> +       int group_addr = is_multicast_ether_addr(hdr->addr1);
> +
> +       if (!(tx->flags & IEEE80211_TX_FRAGMENTED)) {
> +               hdr->duration_id = ieee80211_duration(tx, group_addr, 0);
> +               return TX_CONTINUE;
> +       }
> +
> +       hdr->duration_id = ieee80211_duration(tx, group_addr,
> +                                             tx->extra_frag[0]->len);
> +
> +       for (i = 0; i < tx->num_extra_frag; i++) {
> +               if (i + 1 < tx->num_extra_frag) {
> +                       next_len = tx->extra_frag[i + 1]->len;
> +               } else {
> +                       next_len = 0;
> +                       tx->rate_idx = tx->last_frag_rate_idx;
> +               }
> +
> +               hdr = (struct ieee80211_hdr *)tx->extra_frag[i]->data;
> +               hdr->duration_id = ieee80211_duration(tx, 0, next_len);
> +       }
> +
> +       return TX_CONTINUE;
> +}
> +
> +static ieee80211_tx_result
>  ieee80211_tx_h_stats(struct ieee80211_tx_data *tx)
>  {
>        int i;
> @@ -788,6 +809,7 @@ static ieee80211_tx_handler ieee80211_tx
>        ieee80211_tx_h_fragment,
>        /* handlers after fragment must be aware of tx info fragmentation! */
>        ieee80211_tx_h_encrypt,
> +       ieee80211_tx_h_calculate_duration,
>        ieee80211_tx_h_stats,
>        NULL
>  };
> @@ -1139,24 +1161,6 @@ static int ieee80211_tx(struct net_devic
>                return 0;
>        }
>
> -       if (tx.extra_frag) {
> -               for (i = 0; i < tx.num_extra_frag; i++) {
> -                       int next_len, dur;
> -                       struct ieee80211_hdr *hdr =
> -                               (struct ieee80211_hdr *)
> -                               tx.extra_frag[i]->data;
> -
> -                       if (i + 1 < tx.num_extra_frag) {
> -                               next_len = tx.extra_frag[i + 1]->len;
> -                       } else {
> -                               next_len = 0;
> -                               tx.rate_idx = tx.last_frag_rate_idx;
> -                       }
> -                       dur = ieee80211_duration(&tx, 0, next_len);
> -                       hdr->duration_id = cpu_to_le16(dur);
> -               }
> -       }
> -
>  retry:
>        ret = __ieee80211_tx(local, skb, &tx);
>        if (ret) {
>
>
>
