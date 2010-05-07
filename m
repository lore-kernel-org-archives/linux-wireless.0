Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:63397 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab0EGJGE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 May 2010 05:06:04 -0400
Received: by bwz19 with SMTP id 19so444238bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 07 May 2010 02:06:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201005071103.08186.helmut.schaa@googlemail.com>
References: <201005071103.08186.helmut.schaa@googlemail.com>
Date: Fri, 7 May 2010 11:06:01 +0200
Message-ID: <n2qa32f33a41005070206j5909b348r62777da0cc7d214@mail.gmail.com>
Subject: Re: [PATCHv2] rt2x00: rt2800: use correct txop value in tx descriptor
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


> diff --git a/drivers/net/wireless/rt2x00/rt2x00ht.c b/drivers/net/wireless/rt2x00/rt2x00ht.c
> index 1056c92..5a40760 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00ht.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00ht.c
> @@ -35,6 +35,7 @@ void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
>  {
>        struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
>        struct ieee80211_tx_rate *txrate = &tx_info->control.rates[0];
> +       struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)entry->skb->data;
>
>        if (tx_info->control.sta)
>                txdesc->mpdu_density =
> @@ -66,4 +67,20 @@ void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
>                __set_bit(ENTRY_TXD_HT_BW_40, &txdesc->flags);
>        if (txrate->flags & IEEE80211_TX_RC_SHORT_GI)
>                __set_bit(ENTRY_TXD_HT_SHORT_GI, &txdesc->flags);
> +
> +       /*
> +        * Determine IFS values
> +        * - Use TXOP_BACKOFF for management frames
> +        * - Use TXOP_SIFS for fragment bursts
> +        * - Use TXOP_HTTXOP for everything else
> +        *
> +        * Note: rt2800 devices won't use CTS protection (if used)
> +        * for frames not transmitted with TXOP_HTTXOP
> +        */
> +       if (ieee80211_is_mgmt(hdr->frame_control))
> +               txdesc->txop = TXOP_BACKOFF;
> +       else if (!(tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT))
> +               txdesc->txop = TXOP_SIFS;
> +       else
> +               txdesc->txop = TXOP_HTTXOP;

I can't check it right now, but I am sure this function contains
exactly the same checks
for determining the correct ifs value. It would be easier to move the
assignment to txop
to the same if-statements.

Ivo
