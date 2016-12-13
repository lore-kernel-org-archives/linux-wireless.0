Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50474 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933726AbcLMQJQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 11:09:16 -0500
Message-ID: <1481645351.20412.34.camel@sipsolutions.net> (sfid-20161213_171012_140266_DC3F2D22)
Subject: Re: [PATCH 2/4] cfg80211: Add new NL80211_CMD_SET_BTCOEX_PRIORITY
 to support BTCOEX
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhchelvam@codeaurora.org>
Cc: c_traja@qti.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Date: Tue, 13 Dec 2016 17:09:11 +0100
In-Reply-To: <5e5e8971c96293a81e7cb37bcdfbd593@codeaurora.org>
References: <1478610932-21954-1-git-send-email-c_traja@qti.qualcomm.com>
         <1478610932-21954-3-git-send-email-c_traja@qti.qualcomm.com>
         <1480949353.31788.27.camel@sipsolutions.net>
         <5e5e8971c96293a81e7cb37bcdfbd593@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > >  /**
> > > + * wiphy_btcoex_support_flags
> > > + *	This enum has the driver supported frame types for
> > > BTCOEX.
> > > + * @WIPHY_WLAN_BE_PREFERRED - Supports Best Effort frame for
> > > BTCOEX
> > > + * @WIPHY_WLAN_BK_PREFERRED - supports Background frame for
> > > BTCOEX
> > > + * @WIPHY_WLAN_VI_PREFERRED - supports Video frame for BTCOEX
> > > + * @WIPHY_WLAN_VO_PREFERRED - supports Voice frame for BTCOEX
> > > + * @WIPHY_WLAN_BEACON_PREFERRED - supports Beacon frame for
> > > BTCOEX
> > > + * @WIPHY_WLAN_MGMT_PREFERRED - supports Management frames for
> > > BTCOEX.
> > > + */
> > 
> > That's not making much sense to me?
> > 
> 
> is it fine to have as WIPHY_BTCOEX_BE_PREFERRED ?

It's not really clear to me what you intend to do this - if it's really
support flags then you really should name those better.

> > > +/**
> > > + * enum wiphy_btcoex_priority - BTCOEX priority level
> > > + *	This enum defines priority level for BTCOEX
> > > + * WIPHY_WLAN_PREFERRED_LOW - low priority frames over BT
> > > traffic
> > > + * WIPHY_WLAN_PREFERRED_HIGH - high priority frames over BT
> > > traffic
> > > + */
> > > +
> > > +enum wiphy_btcoex_priority {
> > > +	WIPHY_WLAN_PREFERRED_LOW = false,
> > > +	WIPHY_WLAN_PREFERRED_HIGH = true,
> > > +};
> > 
> > That false/true seems just strange.
> > 
> 
> I will just use as a enum without assigning false/true.

What do you even need this enum for though?

> > > +enum nl80211_btcoex_priority {
> > > +	__NL80211_WLAN_PREFERRED_INVALID,
> > > +	NL80211_WLAN_BE_PREFERRED,
> > > +	NL80211_WLAN_BK_PREFERRED,
> > > +	NL80211_WLAN_VI_PREFERRED,
> > > +	NL80211_WLAN_VO_PREFERRED,
> > > +	NL80211_WLAN_BEACON_PREFERRED,
> > > +	NL80211_WLAN_MGMT_PREFERRED,
> > > +	__NL80211_WLAN_PREFERRED_LAST,
> > > +	NL80211_WLAN_PREFERRED_MAX =
> > > +			__NL80211_WLAN_PREFERRED_LAST - 1,
> > > +};
> > 
> > Wouldn't a bitmap be easier?
> > 
> since this is to distinguish between different btcoex priorities and
> we 
> are not going to do any manipulations on these parameters.
> It is just used as flag attribute.

But why the (parsing) complexity, when a single bitmap would do?

johannes
