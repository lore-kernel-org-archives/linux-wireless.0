Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:52650 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab0FOJrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 05:47:15 -0400
Subject: Re: [RFC PATCH] nl80211/cfg80211/mac80211: Add support for setting
 transmit power
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1276594195.3648.54.camel@jlt3.sipsolutions.net>
References: <1276593453-27818-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1276594195.3648.54.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jun 2010 12:46:50 +0300
Message-ID: <1276595210.5277.41838.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-15 at 11:29 +0200, ext Johannes Berg wrote:
> On Tue, 2010-06-15 at 12:17 +0300, Juuso Oikarinen wrote:
> 
> > + * @NL80211_CMD_SET_TX_POWER: Set the used transmit power level (using
> > + *	%NL80211_ATTR_TX_POWER_SETTING and %NL80211_ATTR_TX_POWER_LEVEL).
> 
> We have a lot of such settings (RTS threshold, coverage class, ...) done
> with SET_WIPHY, shouldn't this also be done there?

Ok, I will look into that.

> > +	/*
> > +	 * Though the nl80211 supports negative mBm values, the interface
> > +	 * below it does not, for now.
> > +	 */
> > +	if (mbm < 0) {
> > +		err = -EOPNOTSUPP;
> > +		goto out;
> > +	}
> > +
> > +	rtnl_lock();
> > +
> > +	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
> > +	if (err)
> > +		goto unlock_rdev;
> > +
> > +	wdev = dev->ieee80211_ptr;
> > +
> > +	if (!rdev->ops->set_tx_power) {
> > +		return -EOPNOTSUPP;
> > +		goto unlock_rdev;
> > +	}
> > +
> > +	err = rdev->ops->set_tx_power(wdev->wiphy, type, MBM_TO_DBM(mbm));
> 
> I think the API mismatch should be handled in mac80211 rather than
> cfg80211, that goes for both the negative values (actually, shouldn't
> that be non-positive for mac80211?) and mBm vs. dBm -- and mac80211
> should probably reject fractional dBm values for now.

Ok. If I adjust the cfg80211 ops function for this, I'll need to see
about full-mac drivers also implementing the function besides the
mac80211. I'll look into it.

-Juuso

> johannes
> 


