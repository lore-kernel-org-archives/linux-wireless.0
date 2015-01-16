Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41240 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbbAPKuf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 05:50:35 -0500
Message-ID: <1421405432.9214.2.camel@sipsolutions.net> (sfid-20150116_115054_931944_C809D6AC)
Subject: Re: [RFC 1/2] nl80211: support per-rate/per-station statistics
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 16 Jan 2015 11:50:32 +0100
In-Reply-To: <874mrrvw3z.fsf@nemi.mork.no>
References: <1421401708-8123-1-git-send-email-johannes@sipsolutions.net>
	 <874mrrvw3z.fsf@nemi.mork.no>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-16 at 11:49 +0100, Bjørn Mork wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > +void cfg80211_report_rate_stats(struct wiphy *wiphy, struct wireless_dev *wdev,
> > +				const u8 *addr, unsigned int n_stats,
> > +				struct cfg80211_rate_stats *stats, gfp_t gfp);
> > +
> >  /* ethtool helper */
> >  void cfg80211_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info);
> >  
> > diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> > index f52797a90816..d03e3caef505 100644
> > --- a/include/uapi/linux/nl80211.h
> > +++ b/include/uapi/linux/nl80211.h
> > @@ -35,6 +35,7 @@
> >  #define NL80211_MULTICAST_GROUP_MLME		"mlme"
> >  #define NL80211_MULTICAST_GROUP_VENDOR		"vendor"
> >  #define NL80211_MULTICAST_GROUP_TESTMODE	"testmode"
> > +#define NL80211_MULTICAST_GROUP_RATESTATS	"rate-stats"
> >  
> >  /**
> >   * DOC: Station handling
> > @@ -796,6 +797,10 @@
> >   *	as an event to indicate changes for devices with wiphy-specific regdom
> >   *	management.
> >   *
> > + * @NL80211_CMD_GET_RATE_STATISTICS: This command can be used to trigger the
> 
> So in a few lines we have all these phrases describing the same feature
> in different contexts (3 of which are different even after ignoring
> casing and _/- translation):
> 
>  rate_stats
>  RATESTATS
>  rate-stats
>  RATE_STATISTICS
> 
> How about sticking to one phrase to avoid having to look these up every
> time you use them? 

Heh, that's a good point. "ratestats" is good with me - I guess that's
pretty much a consequence of working on the code for such a long
time :-)

johannes

