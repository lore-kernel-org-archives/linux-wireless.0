Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:52072 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYLCCBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 21:01:24 -0500
Received: by ti-out-0910.google.com with SMTP id b6so2085257tic.23
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 18:01:21 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18741.59362.77483.600612@localhost.localdomain> (sfid-20081203_030130_770934_BF07EF96)
Date: Wed, 3 Dec 2008 07:28:58 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@atheros.com, Luis.Rodriguez@atheros.com,
	Senthilkumar.Balasubramanian@atheros.com
Subject: Re: [PATCH] ath9k: Use GFP_ATOMIC when allocating private area
In-Reply-To: <43e72e890812021614i103235few3a19721c6ca1d0cc@mail.gmail.com>
References: <18741.12999.753996.233483@gargle.gargle.HOWL>
	<43e72e890812021614i103235few3a19721c6ca1d0cc@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Tue, Dec 2, 2008 at 5:06 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> 
> > --- a/drivers/net/wireless/ath9k/xmit.c
> > +++ b/drivers/net/wireless/ath9k/xmit.c
> > @@ -1787,7 +1793,12 @@ int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
> >                return -1;
> >        }
> >
> > -       ath_tx_setup_buffer(sc, bf, skb, txctl);
> > +       ret = ath_tx_setup_buffer(sc, bf, skb, txctl);
> > +       if (ret) {
> > +               DPRINTF(sc, ATH_DBG_FATAL, "TX mem alloc failure\n");
> > +               return ret;
> 
> Hm, this doesn't add the bf back to the txq, so we'd run out of bf's
> completely when on low memory, eventually leaving the list always
> empty. I'll resend with that added and a few more changes.
> 

Right.

I think the queue has to be stopped too (ieee80211_stop_queue()),
and resumed when memory is available again.

What do you think ?

Sujith
