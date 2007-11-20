Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:41968 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbXKTRHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 12:07:24 -0500
Received: by nf-out-0910.google.com with SMTP id g13so1812991nfb
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2007 09:07:22 -0800 (PST)
Message-ID: <c85cb4470711200907x63e03812ofce3cf900f681153@mail.gmail.com> (sfid-20071120_170727_529477_E1AF869F)
Date: Tue, 20 Nov 2007 19:07:22 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: restructuring data Rx handlers
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <1195570822.10920.50.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11954792971872-git-send-email-ron.rindjunsky@intel.com>
	 <1195503670.19479.20.camel@johannes.berg>
	 <c85cb4470711200650p3a90955aha2825676ee31c4c6@mail.gmail.com>
	 <1195570822.10920.50.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Great, so needed changes are on their way, and i will issue tomorrow
the A-MSDU patch that uses the new handlers scheme.
thanks
ron

> > > > -int ieee80211_is_eapol(const struct sk_buff *skb);
> > > > +int ieee80211_is_eapol(const struct sk_buff *skb, int hdrlen);
> > >
> > > That's just an optimisation, right?
> >
> > main reason is that ieee80211_is_eapol is called both in Tx and Rx
> > flows, so the caller is reaponsible for passing the header length
> > (802.3 in Rx and 802.11 in Tx).
>
> Right. I noticed later but forgot to remove the comment.
>
> > > Any reason you're getting rid of the MAC printk? It's a debug-only
> > > message so whatever, just curious really.
> > >
> >
> > as ieee80211_802_1x_pae is not a 802.11 specific any more, it has no knowledge
> > about the header, therefore no knowledge about mac address. I could
> > pass to it the mac address as well, but looks odd to do that only for
> > debug printing.
>
> Oh ok, right.
>
> > > > +     if (ieee80211_data_to_8023(rx) == TXRX_DROP)
> > > > +             return TXRX_DROP;
> > > > +     if (ieee80211_802_1x_pae(rx, sizeof(struct ethhdr)) == TXRX_DROP)
> > > > +             return TXRX_DROP;
> > > > +     if (ieee80211_drop_unencrypted(rx, sizeof(struct ethhdr)) == TXRX_DROP)
> > > > +             return TXRX_DROP;
> > >
> > > The sizeof() doesn't look right, shouldn't that get the hdrlen from the
> > > frame control? Ah, no, I see now, it's already converted at this point.
> > > Do we need to pass the hdrlen at all then? I think it would make sense
> > > to specify (in comments) that those functions get a converted (to 802.3
> > > framing) skb instead. And then hardcode the frame offsets/header length.
> >
> > those functions can be used now for 802.11 or 802.3 frames so caller
> > should pass header length for them
> >
> > >
> > > Also, I think the return value of those functions shouldn't be the
> > > txrx_result but rather just a bool.
> > >
> >
> > Hmmm... yes, it will probebly look better. i'll just do a slight
> > change in function's names so it will be clearer to reader.
>
> Great, thanks.
>
> > > I think it would make sense to have another function
> > > ieee80211_is_eapol_checked(tx->skb) that does the hdrlen calculation to
> > > save doing it unconditionally here for the (common) case where we're
> > > using a sta or default key.
> >
> > I agree, thanks for the remark.
> > Yet, i wouldn't like to add another function that does basically the
> > same as ieee80211_is_eapol (or sending an indication for
> > ieee80211_is_eapol about header type what will lessen its
> > flexsibility)
> > I was thinking to move ieee80211_get_hdrlen to:
> > ieee80211_is_eapol(tx->skb, ieee80211_get_hdrlen(fc))
> > this way i keep flexibility in ieee80211_is_eapol and won't calculate
> > header length unless really needed.
>
> Oh sure, that works too. I guess you could inline all of it even
> ieee80211_is_eapol(tx->skb,
>                   ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control)))
>
> But yeah, whatever, I'm not concerned about the byteswap.
>
> johannes
>
>
