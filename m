Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55154 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754747AbcLPJPJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 04:15:09 -0500
Message-ID: <1481879623.27953.4.camel@sipsolutions.net> (sfid-20161216_101518_098951_90B6EDA3)
Subject: Re: [RFC 3/3] mac80211: Add receive path for ethernet frame format
From: Johannes Berg <johannes@sipsolutions.net>
To: "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 16 Dec 2016 10:13:43 +0100
In-Reply-To: <58538DFA.1090808@qti.qualcomm.com>
References: <1481781608-5181-1-git-send-email-vthiagar@qti.qualcomm.com>
         <1481781608-5181-4-git-send-email-vthiagar@qti.qualcomm.com>
         <1481794695.31776.7.camel@sipsolutions.net>
         <58538DFA.1090808@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Ok. So it is mainly for encap there needs to be some capability
> advertisement from driver 

Obviously, since mac80211 needs to pick the ndo struct to use.

> because for decap driver would use appropriate mac80211 Rx function
> to indicate?

That should be sufficient, no?

In fact, for RX, assuming that the relevant things are offloaded (and
we should ensure that in the RX function(s)), the driver could be
allowed to switch around as dynamically as it wants to (as long as it's
not mixing in _irqsafe calls or doing other things that might cause
reordering)

> > > +	memset(&rx, 0, sizeof(rx));
> > 
> > That seems a bit pointless?
> 
> Hmmm, is it not that all member other than the ones initialized will
> be junk and might result in crash when accessing uninitialized
> pointer member like napi?

Oh, ok. I thought it was actually all filled.

You really should support NAPI though.

> > Yeah, that's not nice - perhaps we can provide the TID out of band?
> 
> Right. This is possible with ath10k where 802.11 header is also
> available in Rx desc of the frame irrespective of the format of the
> Rx payload

We could go with that for now then. Leave a comment indicating that if
it can't be provided, we need to disable statistics for it?

> > 
> > > +	return;
> > > +
> > > +mic_fail:
> > > +	cfg80211_michael_mic_failure(sdata->dev, sta->addr,
> > > +				     (status->flag &
> > > RX_FLAG_MCAST)
> > > ?
> > > +				     NL80211_KEYTYPE_GROUP :
> > > +				     NL80211_KEYTYPE_PAIRWISE,
> > > +				     key ? key->conf.keyidx :
> > > -1,
> > > +				     NULL, GFP_ATOMIC);
> > 
> > Do we really want to handle that inline here? The driver probably
> > has a different check to even set RX_FLAG_MMIC_ERROR, so we could
> > just ask it to call cfg80211_michael_mic_failure() [or a wrapper to
> > get sdata->dev] instead? I guess this works too though, and might
> > be easier to understand.
> 
> Yeah, driver directly reporting MIC failure will be fine. I think a
> wrapper may be required rather than mac80211 based driver directly
> calling cfg80211 function?

It would be, because the driver can't get sdata->dev (although I think
there's now a hidden path to do this?)

johannes
