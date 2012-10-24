Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47615 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932947Ab2JXRbL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 13:31:11 -0400
Message-ID: <1351099903.10709.8.camel@jlt4.sipsolutions.net> (sfid-20121024_193120_397676_070F47A0)
Subject: Re: [PATCH 2/4] cfg80211: make TX power setting per interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 24 Oct 2012 19:31:43 +0200
In-Reply-To: <50881709.4050405@candelatech.com>
References: <1351073603-11616-1-git-send-email-johannes@sipsolutions.net>
	 <1351073603-11616-3-git-send-email-johannes@sipsolutions.net>
	 <50881709.4050405@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-24 at 09:27 -0700, Ben Greear wrote:

> > -static int ieee80211_get_tx_power(struct wiphy *wiphy, int *dbm)
> > +static int ieee80211_get_tx_power(struct wiphy *wiphy,
> > +				  struct wireless_dev *wdev,
> > +				  int *dbm)
> >   {
> >   	struct ieee80211_local *local = wiphy_priv(wiphy);
> 
> Do we really set mbm and read back dbm?

Yeah, we did nl80211 APIs in mBm and reading back is only for wext
compatibility so was dBm ... hindsight being 20/20 we should probably
never have used mBm, nothing supports it anyway.

> > @@ -1588,6 +1588,11 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
> >   		enum nl80211_tx_power_setting type;
> >   		int idx, mbm = 0;
> >
> > +		if (!wdev) {
> > +			result = -EOPNOTSUPP;
> > +			goto bad_res;
> > +		}
> 
> I guess this is the part that breaks backwards compat when trying to set wiphy?
> If it does stay like this, maybe add a WARN_ON_ONCE that tells users to fix their
> user-space?

Right. Add a user triggerable warning in code like that seems like a
really bad idea to me though. Maybe a message, that seems to have some
precedent, but I suppose nobody will really see it anyway?

johannes

