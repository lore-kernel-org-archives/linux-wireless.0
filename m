Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39538 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750987AbdFUHJh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 03:09:37 -0400
Message-ID: <1498028959.4955.1.camel@sipsolutions.net> (sfid-20170621_090940_331939_95828741)
Subject: Re: [RFC] mac80211: support non-data TXQs
From: Johannes Berg <johannes@sipsolutions.net>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 21 Jun 2017 09:09:19 +0200
In-Reply-To: <c8637109-0292-23af-8bc6-8a7ba8e19595@quantenna.com>
References: <20170620210309.1193-1-johannes@sipsolutions.net>
         <c8637109-0292-23af-8bc6-8a7ba8e19595@quantenna.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-06-20 at 21:19 -0700, Igor Mitsyanko wrote:

> > -	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS];
> > +	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS + 1];
> 
> Isn't that a little confusing? Wouldn't it be better to have a
> separate  member for non-data txq and name it accordingly (something
> like  txq_nodata). 

We do this trick in quite a number of places, so it shouldn't really
come as a surprise.

> You have to handle it specially in most cases anyway I guess.
> With this approach you won't have to replace ARRAY_SIZE(sta->txq) by 
> IEEE80211_NUM_TIDS anywhere.

Yeah, that would indeed be a good reason - I didn't realize the
ARRAY_SIZE() when I originally wrote the patch. And yes, I do need to
treat it specially - except then if it's separate I also have to
initialize it separately, so it's a bit of a trade-off.

> [snip]
[please trim the amount of text you quote]

> > -		txqi->txq.ac = ieee80211_ac_from_tid(tid);
> > +		if (tid == IEEE80211_NUM_TIDS + 1)
> > +			txqi->txq.ac = IEEE80211_AC_VO;
> 
> Why voice, maybe commit message should mention it?

That's standard for management frames, I really didn't think that'd
need any comment?

johannes
