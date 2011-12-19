Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [119.255.1.60] ([119.255.1.60]:49646 "EHLO
	mail.watchdata.com.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab1LSNEq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 08:04:46 -0500
Received: from localhost (mail.watchdata.com.cn [127.0.0.1])
	by mail.watchdata.com.cn (Postfix) with SMTP id 1648720080
	for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 20:54:07 +0800 (CST)
From: =?gb2312?B?wO641Q==?= <gang.li@watchdata.com>
To: "'Mohammed Shafi'" <shafi.wireless@gmail.com>
Cc: "'wireless'" <linux-wireless@vger.kernel.org>
Subject: RE: Question about IEEE80211_TX_CTL_NO_ACK in ath_9k
Date: Mon, 19 Dec 2011 21:03:37 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
In-Reply-To: <CAD2nsn1UO5Lz0h4DQiYr0n=W9TAyXeGYuPbvuNt9JKeGhBjB8g@mail.gmail.com>
Message-Id: <20111219125407.0CE5320069@mail.watchdata.com.cn> (sfid-20111219_140449_913749_C5392E57)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > Hi everybody!
> >
> > My wireless card is AR9280. I set the IEEE80211_TX_CTL_NO_ACK flag
before
> > send a packet, but found it no use. It still wait for an ACK. Then I
read
> > the code,
> 
> may be any of the following hacks may work ?


Sorry,  I didn't make it clear!  My 9280 is an USB card, and the send
function is ath9k_htc_tx_data, there is no corresponding flag.


> 
> @@ -1039,6 +1039,9 @@ static void ath_tx_fill_desc(struct ath_softc
> *sc, struct ath_buf *bf,
>         info.qcu = txq->axq_qnum;
> 
>         info.flags = ATH9K_TXDESC_INTREQ;
> +
> +               info.flags |= ATH9K_TXDESC_NOACK;
> +
>         if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK)
>                 info.flags |= ATH9K_TXDESC_NOACK;
>         if (tx_info->flags & IEEE80211_TX_CTL_LDPC)
> 
> (or)
> 
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index edcd1c7..0454dee 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1185,6 +1185,8 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data
> *sdata,
>         } else
>                 tx->flags |= IEEE80211_TX_UNICAST;
> 
> +               info->flags |= IEEE80211_TX_CTL_NO_ACK;
> +
>         if (!(info->flags & IEEE80211_TX_CTL_DONTFRAG)) {
>                 if (!(tx->flags & IEEE80211_TX_UNICAST) ||
>                     skb->len + FCS_LEN <= local->hw.wiphy->frag_threshold
||
> 
> 
> 
> --
> shafi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

