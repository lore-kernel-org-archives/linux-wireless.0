Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:3434 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYLCCJL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 21:09:11 -0500
Received: by yw-out-2324.google.com with SMTP id 9so1356225ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 18:09:10 -0800 (PST)
Message-ID: <43e72e890812021809h3bc371d0t23e1c14d79a36617@mail.gmail.com> (sfid-20081203_030915_607703_877D91D7)
Date: Tue, 2 Dec 2008 18:09:10 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Sujith <m.sujith@gmail.com>
Subject: Re: [PATCH] ath9k: Use GFP_ATOMIC when allocating private area
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@atheros.com, Luis.Rodriguez@atheros.com,
	Senthilkumar.Balasubramanian@atheros.com
In-Reply-To: <18741.59362.77483.600612@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <18741.12999.753996.233483@gargle.gargle.HOWL>
	 <43e72e890812021614i103235few3a19721c6ca1d0cc@mail.gmail.com>
	 <18741.59362.77483.600612@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 2, 2008 at 5:58 PM, Sujith <m.sujith@gmail.com> wrote:
> Luis R. Rodriguez wrote:
>> On Tue, Dec 2, 2008 at 5:06 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
>>
>> > --- a/drivers/net/wireless/ath9k/xmit.c
>> > +++ b/drivers/net/wireless/ath9k/xmit.c
>> > @@ -1787,7 +1793,12 @@ int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
>> >                return -1;
>> >        }
>> >
>> > -       ath_tx_setup_buffer(sc, bf, skb, txctl);
>> > +       ret = ath_tx_setup_buffer(sc, bf, skb, txctl);
>> > +       if (ret) {
>> > +               DPRINTF(sc, ATH_DBG_FATAL, "TX mem alloc failure\n");
>> > +               return ret;
>>
>> Hm, this doesn't add the bf back to the txq, so we'd run out of bf's
>> completely when on low memory, eventually leaving the list always
>> empty. I'll resend with that added and a few more changes.
>>
>
> Right.
>
> I think the queue has to be stopped too (ieee80211_stop_queue()),
> and resumed when memory is available again.
>
> What do you think ?

Interesting, I hadn't thought about stopping the queues, when would
they be resumed then though, or rather who? I'll a rework of this
ontop of more DMA fun, let me know what you think. I just tested this.

  Luis
