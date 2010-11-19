Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63853 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756150Ab0KSBXz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 20:23:55 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 17:23:42 -0800
Date: Thu, 18 Nov 2010 17:23:52 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Matt Smith <Matt.Smith@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: Re: [RFC] mac80211: disable aggregatin for voice traffic
Message-ID: <20101119012352.GN3426@tux>
References: <1290129534-21785-1-git-send-email-lrodriguez@atheros.com>
 <8e66f390eb4591841e22b8f5f2188e5d@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <8e66f390eb4591841e22b8f5f2188e5d@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 18, 2010 at 05:21:24PM -0800, Johannes Berg wrote:
> On Thu, 18 Nov 2010 17:18:54 -0800, "Luis R. Rodriguez"
> <lrodriguez@atheros.com> wrote:
> > This should help with latency issues which can happen when
> > using aggregation.
> > 
> > Cc: Matt Smith <matt.smith@atheros.com>
> > Cc: Senthil Balasubramanian <senthilkumar@atheros.com>
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > ---
> > 
> > We discussed this a while ago but never to around to it.
> > 
> >  net/mac80211/tx.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> > index e694836..405ddc9 100644
> > --- a/net/mac80211/tx.c
> > +++ b/net/mac80211/tx.c
> > @@ -1225,7 +1225,8 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data
> > *sdata,
> >  		tx->sta = sta_info_get(sdata, hdr->addr1);
> >  
> >  	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control) &&
> > -	    (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)) {
> > +	    (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION) &&
> > +	    (ieee802_1d_to_ac[skb->priority] != IEEE80211_AC_VO)) {
> 
> wtf? total NACK. You're setting up an aggregation session and then not
> using it? That's totally deluded ... just don't set up the session!!

:) thanks for the kind review.

  Luis
