Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4879 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbXJDXjj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2007 19:39:39 -0400
Date: Thu, 4 Oct 2007 19:02:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Daniel Drake <dsd@gentoo.org>, johannes@sipsolutions.net,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ieee80211_if_set_type: make check for master dev more
	explicit
Message-ID: <20071004230248.GN6037@tuxdriver.com> (sfid-20071005_003946_570448_60F74AB7)
References: <20071004113343.552139D502B@zog.reactivated.net> <20071004180900.GG6037@tuxdriver.com> <200710041726.11744.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200710041726.11744.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 04, 2007 at 05:26:11PM -0400, Michael Wu wrote:
> On Thursday 04 October 2007 14:09, John W. Linville wrote:
> > diff --git a/net/mac80211/ieee80211_iface.c
> > b/net/mac80211/ieee80211_iface.c index be7e77f..6607b80 100644
> > --- a/net/mac80211/ieee80211_iface.c
> > +++ b/net/mac80211/ieee80211_iface.c
> > @@ -106,7 +106,7 @@ void ieee80211_if_set_type(struct net_device *dev, int
> > type) * which already has a hard_start_xmit routine assigned
> >  	 * which must not be changed.
> >  	 */
> > -	if (!dev->hard_start_xmit)
> > +	if (dev->type != ARPHRD_IEEE80211)
> The standard way of checking for the master device is
> dev == sdata->local->mdev
> 
> wme.c doesn't quite follow this but that code needs to die anyway.
> 
> This does look nicer than the other patch.

Alright...better?

---

From: John W. Linville <linville@tuxdriver.com>
Subject: [PATCH] ieee80211_if_set_type: make check for master dev more explicit

Problem description by Daniel Drake <dsd@gentoo.org>:

"This sequence of events causes loss of connectivity:

<plug in>
<associate as normal in managed mode>
ifconfig eth7 down
iwconfig eth7 mode monitor
ifconfig eth7 up
ifconfig eth7 down
iwconfig eth7 mode managed
<associate as normal>

At this point you are associated but TX does not work. This is because
the eth7 hard_start_xmit is still ieee80211_monitor_start_xmit."

The problem is caused by ieee80211_if_set_type checking for a non-zero
hard_start_xmit pointer value in order to avoid changing that value for
master devices.  The fix is to make that check more explicitly linked to
master devices rather than simply checking if the value has been
previously set.

CC: Daniel Drake <dsd@gentoo.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/ieee80211_iface.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211_iface.c b/net/mac80211/ieee80211_iface.c
index be7e77f..43e505d 100644
--- a/net/mac80211/ieee80211_iface.c
+++ b/net/mac80211/ieee80211_iface.c
@@ -106,7 +106,7 @@ void ieee80211_if_set_type(struct net_device *dev, int type)
 	 * which already has a hard_start_xmit routine assigned
 	 * which must not be changed.
 	 */
-	if (!dev->hard_start_xmit)
+	if (dev != sdata->local->mdev)
 		dev->hard_start_xmit = ieee80211_subif_start_xmit;
 
 	/*
-- 
1.5.2.4


-- 
John W. Linville
linville@tuxdriver.com
