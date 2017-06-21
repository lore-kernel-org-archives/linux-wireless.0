Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40314 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751148AbdFUIhC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 04:37:02 -0400
Message-ID: <1498034220.4955.3.camel@sipsolutions.net> (sfid-20170621_103707_748318_60DA8EBF)
Subject: Re: [RFC] mac80211: support non-data TXQs
From: Johannes Berg <johannes@sipsolutions.net>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 21 Jun 2017 10:37:00 +0200
In-Reply-To: <1498028959.4955.1.camel@sipsolutions.net> (sfid-20170621_090940_331939_95828741)
References: <20170620210309.1193-1-johannes@sipsolutions.net>
         <c8637109-0292-23af-8bc6-8a7ba8e19595@quantenna.com>
         <1498028959.4955.1.camel@sipsolutions.net>
         (sfid-20170621_090940_331939_95828741)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-06-21 at 09:09 +0200, Johannes Berg wrote:
> On Tue, 2017-06-20 at 21:19 -0700, Igor Mitsyanko wrote:
> 
> > > -	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS];
> > > +	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS + 1];
> > 
> > Isn't that a little confusing? Wouldn't it be better to have a
> > separate  member for non-data txq and name it accordingly
> > (something
> > like  txq_nodata). 
> 
> We do this trick in quite a number of places, so it shouldn't really
> come as a surprise.
> 
> > You have to handle it specially in most cases anyway I guess.
> > With this approach you won't have to replace ARRAY_SIZE(sta->txq)
> > by IEEE80211_NUM_TIDS anywhere.
> 
> Yeah, that would indeed be a good reason - I didn't realize the
> ARRAY_SIZE() when I originally wrote the patch. And yes, I do need to
> treat it specially - except then if it's separate I also have to
> initialize it separately, so it's a bit of a trade-off.

I changed my mind on changing this, the allocation, initialization and
teardown etc. just gets much more complicated with doing that, needing
special cases in quite a number of places.

johannes
