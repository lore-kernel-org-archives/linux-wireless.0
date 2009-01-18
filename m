Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:38330 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbZARU35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 15:29:57 -0500
Received: by ewy13 with SMTP id 13so108488ewy.18
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2009 12:29:54 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Chris Clayton <chris2553@googlemail.com>
Subject: Re: [PATCH] Fix TX rate short preamble detection
Date: Sun, 18 Jan 2009 21:29:52 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <200901182015.24298.IvDoorn@gmail.com> <c6b1100b0901181214w255355b5i9d4f098a9f96fad1@mail.gmail.com>
In-Reply-To: <c6b1100b0901181214w255355b5i9d4f098a9f96fad1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901182129.52241.IvDoorn@gmail.com> (sfid-20090118_213001_712800_8C1F5C02)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 18 January 2009, Chris Clayton wrote:
> Hi Ivo/John,
> 
> 2009/1/18 Ivo van Doorn <ivdoorn@gmail.com>:
> > Mac80211 provides 2 structures to handle bitrates, namely
> > ieee80211_rate and ieee80211_tx_rate. To determine the short preamble
> > mode for an outgoing frame, the flag IEEE80211_TX_RC_USE_SHORT_PREAMBLE
> > must be checked on ieee80211_tx_rate and not ieee80211_rate (which rt2x00 did).
> >
> > This fixes a regression which was triggered in 2.6.29-rcX as reported by Chris Clayton.
> >
> 
> I don't think the patch below will apply to 2.6.29-rc because it is
> lagging behind wireless testing and, I would guess, is likely to stay
> that way for 2.6.29 because the merge window is closed. Won't the
> final patch that was provided to me at
> http://marc.info/?l=linux-wireless&m=123229784930740&w=4 be the
> correct one? If so, could John please add:

True. but usually John wants the patch to go through wireless-testing,
which makes below patch the correct one. :)
Anyway, in this case he has the luxoury of having both versions of the patch. ;)

> Tested-By: Chris Clayton <chris2553@googlemail.com>
> 
> Cheers,
> 
> Chris
> 
> > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> >
> > ---
> > diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
> > index c1e5a05..3dab9b4 100644
> > --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> > +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> > @@ -186,10 +186,11 @@ static void rt2x00queue_create_tx_descriptor_seq(struct queue_entry *entry,
> >
> >  static void rt2x00queue_create_tx_descriptor_plcp(struct queue_entry *entry,
> >                                                  struct txentry_desc *txdesc,
> > -                                                 struct ieee80211_rate *rate)
> > +                                                 const struct rt2x00_rate *hwrate)
> >  {
> >        struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
> > -       const struct rt2x00_rate *hwrate = rt2x00_get_rate(rate->hw_value);
> > +       struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
> > +       struct ieee80211_tx_rate *txrate = &tx_info->control.rates[0];
> >        unsigned int data_length;
> >        unsigned int duration;
> >        unsigned int residual;
> > @@ -232,7 +233,7 @@ static void rt2x00queue_create_tx_descriptor_plcp(struct queue_entry *entry,
> >                 * When preamble is enabled we should set the
> >                 * preamble bit for the signal.
> >                 */
> > -               if (rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
> > +               if (txrate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
> >                        txdesc->signal |= 0x08;
> >        }
> >  }
> > @@ -326,7 +327,7 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
> >         */
> >        rt2x00crypto_create_tx_descriptor(entry, txdesc);
> >        rt2x00queue_create_tx_descriptor_seq(entry, txdesc);
> > -       rt2x00queue_create_tx_descriptor_plcp(entry, txdesc, rate);
> > +       rt2x00queue_create_tx_descriptor_plcp(entry, txdesc, hwrate);
> >  }
> >
> >  static void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
> >
> 
> 
> 


