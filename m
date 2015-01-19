Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbbASVJK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 16:09:10 -0500
Message-ID: <1421701745.23826.13.camel@dcbw.local> (sfid-20150119_220914_907818_A2336B6F)
Subject: Re: [PATCH] Revert "wireless: Support of IFLA_INFO_KIND rtnl
 attribute"
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Date: Mon, 19 Jan 2015 15:09:05 -0600
In-Reply-To: <1421695324.23826.9.camel@dcbw.local>
References: <1421689943-13264-1-git-send-email-johannes@sipsolutions.net>
	 <1421695324.23826.9.camel@dcbw.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-01-19 at 13:22 -0600, Dan Williams wrote:
> On Mon, 2015-01-19 at 18:52 +0100, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > This reverts commit ba1debdfed974f25aa598c283567878657b292ee.
> > 
> > Oliver reported that it breaks network-manager, for some reason with
> > this patch NM decides that the device isn't wireless but "generic"
> > (ethernet), sees no carrier (as expected with wifi) and fails to do
> > anything else with it.
> 
> Hmm, which NM version?  NM uses either DEVTYPE (from 'uevent' in sysfs),
> the phy80211 link in sysfs, or (if enabled) WEXT to figure out whether a
> network interface with arptype=1 is WiFi or not.  I can't think of why
> IFLA_INFO_KIND would break that...  what are the userspace visible
> effects of the patch before reversion?

So with the patch, libnl will return 'wlan' from rtnl_link_get_type().
NetworkManager was relying on the fact that this would return NULL for
WiFi devices and was not falling back to alternate WiFi detection
mechanisms (sysfs, DEVTYPE, etc) when an unknown IFLA_INFO_KIND was
found.

NM 0.9.10+ have this bug.

I'll submit a patch upstream for review, which will get backported to
0.9.10 and later when approved.

Dan

> Dan
> 
> > Revert this to unbreak userspace.
> > 
> > Reported-by: Oliver Hartkopp <socketcan@hartkopp.net>
> > Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> >  net/wireless/core.c | 6 ------
> >  1 file changed, 6 deletions(-)
> > 
> > diff --git a/net/wireless/core.c b/net/wireless/core.c
> > index 456e4c38c279..3af0ecf1cc16 100644
> > --- a/net/wireless/core.c
> > +++ b/net/wireless/core.c
> > @@ -21,7 +21,6 @@
> >  #include <linux/sched.h>
> >  #include <net/genetlink.h>
> >  #include <net/cfg80211.h>
> > -#include <net/rtnetlink.h>
> >  #include "nl80211.h"
> >  #include "core.h"
> >  #include "sysfs.h"
> > @@ -964,10 +963,6 @@ void cfg80211_stop_iface(struct wiphy *wiphy, struct wireless_dev *wdev,
> >  }
> >  EXPORT_SYMBOL(cfg80211_stop_iface);
> >  
> > -static const struct rtnl_link_ops wireless_link_ops = {
> > -	.kind = "wlan",
> > -};
> > -
> >  static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
> >  					 unsigned long state, void *ptr)
> >  {
> > @@ -986,7 +981,6 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
> >  	switch (state) {
> >  	case NETDEV_POST_INIT:
> >  		SET_NETDEV_DEVTYPE(dev, &wiphy_type);
> > -		dev->rtnl_link_ops = &wireless_link_ops;
> >  		break;
> >  	case NETDEV_REGISTER:
> >  		/*
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


