Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34306 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab2GINMe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 09:12:34 -0400
Message-ID: <1341839551.4455.47.camel@jlt3.sipsolutions.net> (sfid-20120709_151237_732331_E758E273)
Subject: Re: [PATCHv2] nl/cfg/mac80211: add set_mcast_rate API
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 09 Jul 2012 15:12:31 +0200
In-Reply-To: <1341839146.4455.40.camel@jlt3.sipsolutions.net> (sfid-20120709_150558_255063_6140ED53)
References: <1341739885-15385-1-git-send-email-ordex@autistici.org>
	 <1341791503-12542-1-git-send-email-ordex@autistici.org>
	 <1341839146.4455.40.camel@jlt3.sipsolutions.net>
	 (sfid-20120709_150558_255063_6140ED53)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-09 at 15:05 +0200, Johannes Berg wrote:
> On Mon, 2012-07-09 at 01:51 +0200, Antonio Quartulli wrote:
> 
> > +static int ieee80211_set_mcast_rate(struct wiphy *wiphy, struct net_device *dev,
> > +				    int mcast_rate[IEEE80211_NUM_BANDS])
> > +{
> > +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> > +	u32 basic_rates = sdata->vif.bss_conf.basic_rates;
> > +	int i;
> > +
> > +	/* check if the mcast_rates are also in basic_rates */
> > +	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
> > +		if (!(basic_rates & BIT(mcast_rate[i] - 1)))
> > +			return -EINVAL;
> 
> So this is kinda broken. In fact, the whole basic rate thing is broken
> it seems.
> 
> The mcast rate is per band, as it should, since you could find the same
> BSSID on a 5 GHz channel and then jump to that channel if the TSF is
> higher...
> 
> However, the basic rates aren't, which is wrong: the basic rates bitmap
> could be 1,2,6,9. If the driver is like most drivers, that translates to
> a bitmap of 0x33. But 0x33, for most drivers, if applied to the 5 GHz
> rates means 6,9,24,36. See why this is broken? A rate bitmap can't be
> siwtched around between bands and still make any sense.

Ok actually maybe it's not broken. We adopt the basic rates from the
network we join, I guess, and the original basic rates specified from
userspace are only used when we actually *create* the network?

Still though, comparing the bits for all bands against the same bitmap
like you did in the above code is just wrong :-)

Maybe we shouldn't bother at all. If we'd join another network, we might
have to downgrade the mcast rate, but then if some peer leaves or we
join another one ... it gets messy quickly.

Since all of this is probably for special cases anyway, maybe we should
just not check the mcast rate and if you set a stupid one you don't get
packets through to all peers? Could be hard to debug though ...

johannes

