Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:39288 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758717Ab3CDUul (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 15:50:41 -0500
Received: by mail-we0-f171.google.com with SMTP id u54so5082875wey.16
        for <linux-wireless@vger.kernel.org>; Mon, 04 Mar 2013 12:50:40 -0800 (PST)
Date: Mon, 4 Mar 2013 21:51:40 +0100
From: john <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Karl Beldan <karl.beldan@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH v2 2/2] mac80211: fix the check for mcs rates masking
Message-ID: <20130304205140.GB8819@gobelin> (sfid-20130304_215046_191822_EF8532C7)
References: <1362421635-28008-1-git-send-email-karl.beldan@gmail.com>
 <1362421635-28008-2-git-send-email-karl.beldan@gmail.com>
 <1362427980.21028.43.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1362427980.21028.43.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 04, 2013 at 09:13:00PM +0100, Johannes Berg wrote:
> On Mon, 2013-03-04 at 19:27 +0100, Karl Beldan wrote:
> > From: Karl Beldan <karl.beldan@rivierawaves.com>
> > 
> > Currently the mcs bitrates mask rate_idx_mcs_mask is only applied when
> > the pre-ht bitrates mask rate_idx_mask of the same band differs from the
> > default mask.
> > Fix it by comparing the rate_idx_mcs_mask with the driver ht caps.
> > 
> > Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> > ---
> >  net/mac80211/rate.c |   10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
> > index c1e5f25..28f1936 100644
> > --- a/net/mac80211/rate.c
> > +++ b/net/mac80211/rate.c
> > @@ -455,13 +455,15 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
> >  	ref->ops->get_rate(ref->priv, ista, priv_sta, txrc);
> >  
> >  	/*
> > -	 * Try to enforce the rateidx mask the user wanted. skip this if the
> > -	 * default mask (allow all rates) is used to save some processing for
> > -	 * the common case.
> > +	 * Try to enforce the rateidx masks the user wanted. Skip this if mask
> > +	 * is the default mask (allow all rates) and mcs_mask does not differ
> > +	 * from the driver ht caps to save some processing for the common case.
> >  	 */
> >  	mask = &txrc->rate_idx_mask;
> >  	mcs_mask = txrc->rate_idx_mcs_mask;
> > -	if (*mask != (1 << txrc->sband->n_bitrates) - 1) {
> > +	if (*mask != (1 << txrc->sband->n_bitrates) - 1 ||
> > +		memcmp(txrc->sband->ht_cap.mcs.rx_mask, txrc->rate_idx_mcs_mask,
> > +		       sizeof(txrc->rate_idx_mcs_mask))) {
> 
> Please fix the indentation, the memcmp should be indented to just after
> the opening parenthesis of "if ("
> 
Yes, sorry.
 
Karl
