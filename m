Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0054.outbound.protection.outlook.com ([104.47.34.54]:47040
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751529AbdFTUJw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Jun 2017 16:09:52 -0400
Date: Tue, 20 Jun 2017 23:09:17 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 5/8] qtnfmac: enable reporting the current operating
 channel
Message-ID: <20170620200915.kltxuoaxlhnvaat7@bars> (sfid-20170620_220956_644095_CC0BCF3F)
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
 <20170620195517.18373-6-sergey.matyukevich.os@quantenna.com>
 <1497988764.11421.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1497988764.11421.1.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> > +     if (sme->channel) {
> > +             /* FIXME: need to set proper nl80211_channel_type
> > value */
> > +             cfg80211_chandef_create(&chandef, sme->channel,
> > +                                     NL80211_CHAN_HT20);
> > +             /* fall-back to minimal safe chandef description */
> > +             if (!cfg80211_chandef_valid(&chandef))
> > +                     cfg80211_chandef_create(&chandef, sme-
> > >channel,
> > +                                             NL80211_CHAN_HT20);
> >
> This seems odd since you just do the same thing over again? Not that I
> could see how it would be invalid anyway.

The first call of cfg80211_chandef_create will be replaced by proper chandef
calculation based on current h/w channel settings. This piece is still in work.
NL80211_CHAN_HT20 is going to be used as a safe fallback when channel info
turns out to be inconsistent.

Regards,
Sergey
