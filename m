Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:63446 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab0CYUdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:33:20 -0400
Received: by fxm23 with SMTP id 23so1540706fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 13:33:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20100325T020952-729@post.gmane.org>
References: <69e28c910904141733m72ce521ap8f1865bec991fff7@mail.gmail.com>
	<201003230942.15718.br1@einfach.org> <loom.20100323T162144-640@post.gmane.org>
	<201003242015.21409.br1@einfach.org> <1269459825.2631.115.camel@mj>
	<69e28c911003241326l6e747113t606f50f61eb435b4@mail.gmail.com>
	<loom.20100325T020952-729@post.gmane.org>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 25 Mar 2010 21:32:57 +0100
Message-ID: <69e28c911003251332k279cd3b8jdf8da464bf0011b4@mail.gmail.com>
Subject: Re: [Proposal]TX flags
To: Michael Stahn <m1kes@web.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 25, 2010 at 2:22 AM, Michael Stahn <m1kes@web.de> wrote:
>> > Maybe we could create a socket option that would put a _socket_ into a
>> > cooked monitor mode?  A "monitor mode socket" would accept and transmit
>> > packets with radiotap and 802.11 headers and receive the packets that
>> > the interface already receives, also with radiotap and 802.11 headers.
>> > That interface could be optimized for use with hostapd and other similar
>> > programs.  The driver could fill some data from the interface settings.
>> >
>> > The monitor mode, on the other hand, could be optimized for the
>> > "hardcore" stuff when the driver interferes as little as possible.  Then
>> > no special flags would be needed to pass the frame as is.
>> >
>> > --
>> > Regards,
>> > Pavel Roskin
>> >
>>
>> I don't think that is needed, as we already support multiple monitor
>> interfaces (including a situation where some are cooked, others are
>> raw).
>>
>
> well after all.. for everyone who's interested I made a quick fix
> considering the duration-problem. Perhaps on 2.6.34 there'll be
> a stable/standardised solution for all those tx-packet-manipulation-stuff.
> This is pretty much the same solution as on sequence-numbering..
>
> ---
>  net/mac80211/tx.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index cbe53ed..8abf015 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -969,11 +969,18 @@ ieee80211_tx_h_encrypt(struct ieee80211_tx_data *tx)
>  static ieee80211_tx_result debug_noinline
>  ieee80211_tx_h_calculate_duration(struct ieee80211_tx_data *tx)
>  {
> +       struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
>        struct sk_buff *skb = tx->skb;
>        struct ieee80211_hdr *hdr;
>        int next_len;
>        bool group_addr;
>
> +       /*
> +        * Packet injection may want to control duration time.
> +        */
> +       if (unlikely(info->control.vif->type == NL80211_IFTYPE_MONITOR))

if(unlikely(info->flags & IEEE80211_TX_CTL_INJECTED) is better. Also,
check the cooked flag!

> +               return TX_CONTINUE;
> +
>        do {
>                hdr = (void *) skb->data;
>                if (unlikely(ieee80211_is_pspoll(hdr->frame_control)))
> --
> 1.6.4.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
