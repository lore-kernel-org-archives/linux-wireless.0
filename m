Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:19902 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbYEMLfU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 07:35:20 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1214970nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2008 04:35:19 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211: Set IEEE80211_TXPD_REQ_TX_STATUS for all TX frames
Date: Tue, 13 May 2008 13:46:35 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <200805111434.19071.IvDoorn@gmail.com> <1210668171.3646.41.camel@johannes.berg>
In-Reply-To: <1210668171.3646.41.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805131346.35897.IvDoorn@gmail.com> (sfid-20080513_133532_804468_2F03AAE2)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 13 May 2008, Johannes Berg wrote:
> On Sun, 2008-05-11 at 14:34 +0200, Ivo van Doorn wrote:
> > All interfaces should set the IEEE80211_TXPD_REQ_TX_STATUS flag for all TX frames
> > which will force the master interface to set the IEEE80211_TX_CTL_REQ_TX_STATUS
> > flag. This in turn will allow drivers to check for that flag before reporting
> > the TX status to mac80211.
> > 
> > This is very usefull when frames (like beacons, RTS and CTS-to-self) should not
> > be reported back to mac80211. Later we could add more extensive checks to
> > exclude more frames from being reported, or let mac80211 decide if it wants
> > the frame for status reporting or not.
> > 
> > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> > ---
> > diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> > index f35eaea..0024892 100644
> > --- a/net/mac80211/tx.c
> > +++ b/net/mac80211/tx.c
> > @@ -1617,6 +1617,9 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
> >  	if (ethertype == ETH_P_PAE)
> >  		pkt_data->flags |= IEEE80211_TXPD_EAPOL_FRAME;
> >  
> > +	/* Interfaces should always request a status report */
> > +	pkt_data->flags |= IEEE80211_TXPD_REQ_TX_STATUS;
> > +
> 
> What about monitor interfaces/injection? Do they already set it?

No, should they?

> Other than that, looks good to me, as long as you're aware that in the
> future this might be more dynamic and don't rely on it too much for
> internal housekeeping (but you seem to be according to your changelog
> entry) :)

Well it shouldn't matter if it will become more flexible, what I am looking
for is making the flag actually mean something for drivers. ;)
We could even make it so that the mac80211 tx_status handler will ignore
the frame when the flag is set so drivers won't have to look at it at all.

Ivo
