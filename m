Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:55013 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbXKVI17 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 03:27:59 -0500
Received: by nf-out-0910.google.com with SMTP id g13so2374551nfb
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2007 00:27:57 -0800 (PST)
Message-ID: <c85cb4470711220027vd75153fl4335279b9f96d3e5@mail.gmail.com> (sfid-20071122_082803_325849_8E89ED09)
Date: Thu, 22 Nov 2007 10:27:56 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: restructuring data Rx handlers
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <1195661640.12000.52.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11956348193070-git-send-email-ron.rindjunsky@intel.com>
	 <1195661640.12000.52.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > +static ieee80211_txrx_result
> > +ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
> > +{
> > +     struct net_device *dev = rx->dev;
> > +     struct ieee80211_local *local = rx->local;
> > +     u16 fc;
> > +     int err;
> > +     struct sk_buff *skb, *skb2;
> > +     struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> > +
> > +     fc = rx->fc;
> > +     if (unlikely((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA))
> > +             return TXRX_CONTINUE;
> > +
> > +     err = ieee80211_data_to_8023(rx);
> > +     if (unlikely(err))
> > +             return TXRX_DROP;
> > +
> > +     if ((ieee80211_drop_802_1x_pae(rx, sizeof(struct ethhdr))) ||
> > +         (ieee80211_drop_unencrypted(rx, sizeof(struct ethhdr))))
> > +             return TXRX_DROP;
>
> I like this.
>
> > +     skb = rx->skb;
> > +     skb->dev = dev;
> >       skb2 = NULL;
> >
> >       dev->stats.rx_packets++;
>
> Ok so the stuff that comes after this until the ned of the function is
> responsible for delivering the packet. Maybe that should be split out
> from the function too into something like ieee80211_deliver_skb()? In
> the A-MSDU code you've had to basically copy all this code into the loop
> as far as I can tell, something which I'd like to avoid very much.

I agree, it will be more readable that way. i'll do the needed changes.

>
> johannes
>
>
