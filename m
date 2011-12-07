Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26034 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab1LGN6s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 08:58:48 -0500
Date: Wed, 7 Dec 2011 19:28:24 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] cfg80211: Define a wrapper function for reporting
 roaming
Message-ID: <20111207135822.GA12398@chvasanth-lnx> (sfid-20111207_145912_275819_DB2F6051)
References: <1323265359-1138-1-git-send-email-vthiagar@qca.qualcomm.com>
 <1323265604.3404.37.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1323265604.3404.37.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 07, 2011 at 02:46:44PM +0100, Johannes Berg wrote:
> On Wed, 2011-12-07 at 19:12 +0530, Vasanthakumar Thiagarajan wrote:
> 
> >  /**
> > + * cfg80211_roamed_bss - notify cfg80211 of roaming
> > + *
> > + * @dev: network device
> > + * @bss: entry of bss to which STA got roamed (may be %NULL)
> 
> I think you should check that it isn't, that's an implementation thing
> of __cfg80211_roamed() I think? Semantically, I don't think this should
> happen here?

This is because cfg80211_roamed() can call it with NULL as bss,
but I agree this should have been stated.

> 
> It would also be good to note that the reference to the bss is given to
> the function and it will be released by it.

Ok.

> 
> > +void cfg80211_roamed_bss(struct net_device *dev, struct cfg80211_bss *bss,
> > +			 struct ieee80211_channel *channel,
> > +			 const u8 *bssid, const u8 *req_ie, size_t req_ie_len,
> > +			 const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp)
> > +{
> >  	struct wireless_dev *wdev = dev->ieee80211_ptr;
> >  	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
> >  	struct cfg80211_event *ev;
> 
> 
> Hmm, now that I think about it more, I think the calling convention is
> really strange. Why pass the channel and bssid when the BSS struct is
> already known?
> 
> Why not make cfg80211_roamed() do the BSS lookup (which would also
> reduce the race for drivers that don't use _bss()) based on the info,
> and then call a cfg80211_roamed_bss() that doesn't get channel/bssid.

Sure, i'll change it. This looks better.

Thanks!

Vasanth
