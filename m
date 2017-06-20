Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33880 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751131AbdFTURb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Jun 2017 16:17:31 -0400
Message-ID: <1497989849.11421.2.camel@sipsolutions.net> (sfid-20170620_221735_507113_5A3FE052)
Subject: Re: [PATCH 5/8] qtnfmac: enable reporting the current operating
 channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Date: Tue, 20 Jun 2017 22:17:29 +0200
In-Reply-To: <20170620200915.kltxuoaxlhnvaat7@bars>
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
         <20170620195517.18373-6-sergey.matyukevich.os@quantenna.com>
         <1497988764.11421.1.camel@sipsolutions.net>
         <20170620200915.kltxuoaxlhnvaat7@bars>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-06-20 at 23:09 +0300, Sergey Matyukevich wrote:
> > 
> > > +     if (sme->channel) {
> > > +             /* FIXME: need to set proper nl80211_channel_type
> > > value */
> > > +             cfg80211_chandef_create(&chandef, sme->channel,
> > > +                                     NL80211_CHAN_HT20);
> > > +             /* fall-back to minimal safe chandef description */
> > > +             if (!cfg80211_chandef_valid(&chandef))
> > > +                     cfg80211_chandef_create(&chandef, sme-
> > > > channel,
> > > 
> > > +                                             NL80211_CHAN_HT20);
> > > 
> > 
> > This seems odd since you just do the same thing over again? Not
> > that I
> > could see how it would be invalid anyway.
> 
> The first call of cfg80211_chandef_create will be replaced by proper
> chandef calculation based on current h/w channel settings. This piece
> is still in work. NL80211_CHAN_HT20 is going to be used as a safe
> fallback when channel info turns out to be inconsistent.

Yeah, ok. I guess I'd advocate doing that when the code is actually
there, but I suppose it doesn't really matter much.

johannes
