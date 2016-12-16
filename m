Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55340 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755835AbcLPJkP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 04:40:15 -0500
Message-ID: <1481879675.27953.5.camel@sipsolutions.net> (sfid-20161216_104021_245980_55EE9993)
Subject: Re: [RFC 3/3] mac80211: Add receive path for ethernet frame format
From: Johannes Berg <johannes@sipsolutions.net>
To: "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 16 Dec 2016 10:14:35 +0100
In-Reply-To: <1481879623.27953.4.camel@sipsolutions.net>
References: <1481781608-5181-1-git-send-email-vthiagar@qti.qualcomm.com>
         <1481781608-5181-4-git-send-email-vthiagar@qti.qualcomm.com>
         <1481794695.31776.7.camel@sipsolutions.net>
         <58538DFA.1090808@qti.qualcomm.com>
         <1481879623.27953.4.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > > > +	return;
> > > > +
> > > > +mic_fail:
> > > > +	cfg80211_michael_mic_failure(sdata->dev, sta->addr,
> > > > +				     (status->flag &
> > > > RX_FLAG_MCAST)
> > > > ?
> > > > +				     NL80211_KEYTYPE_GROUP :
> > > > +				     NL80211_KEYTYPE_PAIRWISE,
> > > > +				     key ? key->conf.keyidx :
> > > > -1,
> > > > +				     NULL, GFP_ATOMIC);
> > > 
> > > Do we really want to handle that inline here? The driver probably
> > > has a different check to even set RX_FLAG_MMIC_ERROR, so we could
> > > just ask it to call cfg80211_michael_mic_failure() [or a wrapper
> > > to
> > > get sdata->dev] instead? I guess this works too though, and might
> > > be easier to understand.
> > 
> > Yeah, driver directly reporting MIC failure will be fine. I think a
> > wrapper may be required rather than mac80211 based driver directly
> > calling cfg80211 function?
> 
> It would be, because the driver can't get sdata->dev (although I
> think there's now a hidden path to do this?)

However, we can do both ways, I don't really care that much. It seems
possible though that a driver would not even report the frame, but only
the necessary info, in this case - so that we might need an out-of-band 
path for it anyway?

johannes
