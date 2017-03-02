Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47698 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754082AbdCBJAC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 04:00:02 -0500
Message-ID: <1488445144.8390.13.camel@sipsolutions.net> (sfid-20170302_100033_123178_4D38E8D4)
Subject: Re: [RFC v2 2/2] cfg80211: support 4-way handshake offloading for
 802.1X
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>
Date: Thu, 02 Mar 2017 09:59:04 +0100
In-Reply-To: <177c53b2-cd5f-97a9-26b0-b590071785cb@broadcom.com> (sfid-20170224_090819_174941_1AFAFD95)
References: <20170221123758.5339-1-johannes@sipsolutions.net>
         <20170221123758.5339-2-johannes@sipsolutions.net>
         <177c53b2-cd5f-97a9-26b0-b590071785cb@broadcom.com>
         (sfid-20170224_090819_174941_1AFAFD95)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > +	int	(*del_pmk)(struct wiphy *wiphy, struct
> > net_device *dev,
> > +			   const u8 *aa);
> 
> Minor nit, but prefer clr_pmk to clear the pmk.

Why? You don't have "the PMK" that you can clear, you have "a PMK" (for
the network) and after deleting it you don't have it anymore. You don't
have a "cleared PMK" afterwards, you just don't have any. I think the
delete makes more sense?

> > + * @NL80211_CMD_DEL_PMK: For offloaded 4-Way handshake, delete the
> > previously
> > + *	configured PMK for the authenticator address identified
> > by
> > + *	&NL80211_ATTR_MAC.
> 
> Maybe better to indicate it is for 802.1X.

I guess that makes sense.

> > +	NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X,
> 
> So do we need this flag. Is the fact that the driver implements the
> set_pmk and del_pmk (or clr_pmk) callbacks not sufficient provided
> they are listed in the "supported commands" message of wiphy dump
> (not in this patch). Which reminds me, is "supported commands" no
> longer preferred because that list does not seem complete?

It's complicated... We've kinda naturally gravitated towards extended
feature flags because they're so easy to handle now (only need to
define the bit) - and with mac80211 in the picture, relying on the
handlers only often didn't work, so it requires extra code in the CMD()
advertising - and anyway it already requires extra code there unlike
the feature flags...

So overall - while this isn't stated policy (yet?) - I think we prefer
the feature bits.

johannes
