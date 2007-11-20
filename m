Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:16195 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbXKTOuL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 09:50:11 -0500
Received: by mu-out-0910.google.com with SMTP id i10so2235711mue
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2007 06:50:05 -0800 (PST)
Message-ID: <c85cb4470711200650p3a90955aha2825676ee31c4c6@mail.gmail.com> (sfid-20071120_145017_670035_AFC333F0)
Date: Tue, 20 Nov 2007 16:50:04 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: restructuring data Rx handlers
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <1195503670.19479.20.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11954792971872-git-send-email-ron.rindjunsky@intel.com>
	 <1195503670.19479.20.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > This patch restructures the Rx handlers chain by incorporating previously
> > handlers ieee80211_rx_h_802_1x_pae and ieee80211_rx_h_drop_unencrypted
> > into ieee80211_rx_h_data, already in 802.3 form. this scheme follows more
> > precisely after the IEEE802.11 data plane archituecture, and will prevent
> > code duplication to IEEE8021.11n A-MSDU handler.
>
> Nice, thanks for doing this. Few comments and questions below.
>
>
> > -int ieee80211_is_eapol(const struct sk_buff *skb);
> > +int ieee80211_is_eapol(const struct sk_buff *skb, int hdrlen);
>
> That's just an optimisation, right?

main reason is that ieee80211_is_eapol is called both in Tx and Rx
flows, so the caller is reaponsible for passing the header length
(802.3 in Rx and 802.11 in Tx).

>
> >  #ifdef CONFIG_MAC80211_DEBUG
> > -             struct ieee80211_hdr *hdr =
> > -                     (struct ieee80211_hdr *) rx->skb->data;
> > -             DECLARE_MAC_BUF(mac);
> > -             printk(KERN_DEBUG "%s: dropped frame from %s"
> > -                    " (unauthorized port)\n", rx->dev->name,
> > -                    print_mac(mac, hdr->addr2));
> > +             printk(KERN_DEBUG "%s: dropped frame "
> > +                    "(unauthorized port)\n", rx->dev->name);
>
> Any reason you're getting rid of the MAC printk? It's a debug-only
> message so whatever, just curious really.
>

as ieee80211_802_1x_pae is not a 802.11 specific any more, it has no knowledge
about the header, therefore no knowledge about mac address. I could
pass to it the mac address as well, but looks odd to do that only for
debug printing.

> > -                  (rx->sdata->eapol == 0 || !ieee80211_is_eapol(rx->skb)))) {
> > +                  (rx->sdata->eapol == 0 ||
> > +                   !ieee80211_is_eapol(rx->skb, hdrlen)))) {
>
> I guess you could make it look nicer by doing !rx->sdata->eapol || ...

no problems, will do

>
> > +     if (ieee80211_data_to_8023(rx) == TXRX_DROP)
> > +             return TXRX_DROP;
> > +     if (ieee80211_802_1x_pae(rx, sizeof(struct ethhdr)) == TXRX_DROP)
> > +             return TXRX_DROP;
> > +     if (ieee80211_drop_unencrypted(rx, sizeof(struct ethhdr)) == TXRX_DROP)
> > +             return TXRX_DROP;
>
> The sizeof() doesn't look right, shouldn't that get the hdrlen from the
> frame control? Ah, no, I see now, it's already converted at this point.
> Do we need to pass the hdrlen at all then? I think it would make sense
> to specify (in comments) that those functions get a converted (to 802.3
> framing) skb instead. And then hardcode the frame offsets/header length.

those functions can be used now for 802.11 or 802.3 frames so caller
should pass header length for them

>
> Also, I think the return value of those functions shouldn't be the
> txrx_result but rather just a bool.
>

Hmmm... yes, it will probebly look better. i'll just do a slight
change in function's names so it will be clearer to reader.

> >  static ieee80211_txrx_result
> >  ieee80211_tx_h_select_key(struct ieee80211_txrx_data *tx)
> >  {
> >       struct ieee80211_key *key;
> > +     const struct ieee80211_hdr *hdr;
> > +     u16 fc;
> > +     int hdrlen;
> > +
> > +     hdr = (const struct ieee80211_hdr *) tx->skb->data;
> > +     fc = le16_to_cpu(hdr->frame_control);
> > +     hdrlen = ieee80211_get_hdrlen(fc);
> >
> >       if (unlikely(tx->u.tx.control->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
> >               tx->key = NULL;
> > @@ -448,7 +451,7 @@ ieee80211_tx_h_select_key(struct ieee80211_txrx_data *tx)
> >       else if ((key = rcu_dereference(tx->sdata->default_key)))
> >               tx->key = key;
> >       else if (tx->sdata->drop_unencrypted &&
> > -              !(tx->sdata->eapol && ieee80211_is_eapol(tx->skb))) {
> > +              !(tx->sdata->eapol && ieee80211_is_eapol(tx->skb, hdrlen))) {
>
> I think it would make sense to have another function
> ieee80211_is_eapol_checked(tx->skb) that does the hdrlen calculation to
> save doing it unconditionally here for the (common) case where we're
> using a sta or default key.

I agree, thanks for the remark.
Yet, i wouldn't like to add another function that does basically the
same as ieee80211_is_eapol (or sending an indication for
ieee80211_is_eapol about header type what will lessen its
flexsibility)
I was thinking to move ieee80211_get_hdrlen to:
ieee80211_is_eapol(tx->skb, ieee80211_get_hdrlen(fc))
this way i keep flexibility in ieee80211_is_eapol and won't calculate
header length unless really needed.

>
> Overall, nice patch.
>
> johannes
>
>
