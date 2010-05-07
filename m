Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33541 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab0EGKdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 May 2010 06:33:32 -0400
Received: by bwz19 with SMTP id 19so484481bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 07 May 2010 03:33:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201005071148.12280.helmut.schaa@googlemail.com>
References: <201005071103.08186.helmut.schaa@googlemail.com>
	 <n2qa32f33a41005070206j5909b348r62777da0cc7d214@mail.gmail.com>
	 <201005071148.12280.helmut.schaa@googlemail.com>
Date: Fri, 7 May 2010 12:33:29 +0200
Message-ID: <u2ia32f33a41005070333m4c3b4831q2d0afa42c3669807@mail.gmail.com>
Subject: Re: [PATCHv2] rt2x00: rt2800: use correct txop value in tx descriptor
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 7, 2010 at 11:48 AM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Am Freitag 07 Mai 2010 schrieb Ivo Van Doorn:
>> Hi,
>>
>>
>> > diff --git a/drivers/net/wireless/rt2x00/rt2x00ht.c b/drivers/net/wireless/rt2x00/rt2x00ht.c
>> > index 1056c92..5a40760 100644
>> > --- a/drivers/net/wireless/rt2x00/rt2x00ht.c
>> > +++ b/drivers/net/wireless/rt2x00/rt2x00ht.c
>> > @@ -35,6 +35,7 @@ void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
>> >  {
>> >        struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
>> >        struct ieee80211_tx_rate *txrate = &tx_info->control.rates[0];
>> > +       struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)entry->skb->data;
>> >
>> >        if (tx_info->control.sta)
>> >                txdesc->mpdu_density =
>> > @@ -66,4 +67,20 @@ void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
>> >                __set_bit(ENTRY_TXD_HT_BW_40, &txdesc->flags);
>> >        if (txrate->flags & IEEE80211_TX_RC_SHORT_GI)
>> >                __set_bit(ENTRY_TXD_HT_SHORT_GI, &txdesc->flags);
>> > +
>> > +       /*
>> > +        * Determine IFS values
>> > +        * - Use TXOP_BACKOFF for management frames
>> > +        * - Use TXOP_SIFS for fragment bursts
>> > +        * - Use TXOP_HTTXOP for everything else
>> > +        *
>> > +        * Note: rt2800 devices won't use CTS protection (if used)
>> > +        * for frames not transmitted with TXOP_HTTXOP
>> > +        */
>> > +       if (ieee80211_is_mgmt(hdr->frame_control))
>> > +               txdesc->txop = TXOP_BACKOFF;
>> > +       else if (!(tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT))
>> > +               txdesc->txop = TXOP_SIFS;
>> > +       else
>> > +               txdesc->txop = TXOP_HTTXOP;
>>
>> I can't check it right now, but I am sure this function contains
>> exactly the same checks
>> for determining the correct ifs value. It would be easier to move the
>> assignment to txop
>> to the same if-statements.
>
> I guess you mean rt2x00queue_create_tx_descriptor in rt2x00queue.c, right?
> It's not exactly the same but at least the check for the first fragment are
> there already. We could also move it there. Why I've decided to put it in
> rt2x00ht.c is because it only applies to HT devices ;)
>
> If you'd prefer to have it in rt2x00queue I'm glad to resend.

Ah true this is HT stuff only. I'll look into the exact code later, and perhaps
I'll update it later. But this patch can be merged:

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
