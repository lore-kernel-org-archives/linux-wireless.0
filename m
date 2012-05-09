Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yumi.tdiedrich.de ([85.10.210.183]:59909 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263Ab2EIV3C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 17:29:02 -0400
Date: Wed, 9 May 2012 23:28:59 +0200
From: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	linux-wireless@vger.kernel.org
Subject: Re: rt28xx AP-mode problem with commit
 3edaf3e61fda3aa9ff8d38445bf92f2bec23bf63 "mac80211: manage AP netdev
 carrier state"
Message-ID: <20120509212859.GF5472@yumi.tdiedrich.de> (sfid-20120509_232907_401388_3B88D606)
References: <20120509105719.GA24457@yumi.tdiedrich.de>
 <1336564773.4323.19.camel@jlt3.sipsolutions.net>
 <20120509121827.GD5472@yumi.tdiedrich.de>
 <20120509210448.GE5472@yumi.tdiedrich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120509210448.GE5472@yumi.tdiedrich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tobias Diedrich wrote:
> Tobias Diedrich wrote:
> > Johannes Berg wrote:
> > > On Wed, 2012-05-09 at 12:57 +0200, Tobias Diedrich wrote:
> > > 
> > > > I've bisected a problem with running rt3052-based APs on recent
> > > > OpenWRT down to this commit: 3edaf3e61fda3aa9ff8d38445bf92f2bec23bf63
> > > > "mac80211: manage AP netdev carrier state"
> > > > 
> > > > If I revert this commit (and also fix the max_power issue), AP-mode
> > > > works fine, but if I leave it in, association to the AP times out.


This seems to be the crucial hunk (and it conveniently ermoves a
check against NL80211_IFTYPE_AP), if I revert just this it works for
me:

Index: compat-wireless-2012-04-17/net/mac80211/iface.c
===================================================================
--- compat-wireless-2012-04-17.orig/net/mac80211/iface.c	2012-05-09 01:00:39.197975402 +0200
+++ compat-wireless-2012-04-17/net/mac80211/iface.c	2012-05-09 01:02:32.514918371 +0200
@@ -411,8 +407,7 @@
 		ieee80211_bss_info_change_notify(sdata, changed);
 
 		if (sdata->vif.type == NL80211_IFTYPE_STATION ||
-		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
-		    sdata->vif.type == NL80211_IFTYPE_AP)
+		    sdata->vif.type == NL80211_IFTYPE_ADHOC)
 			netif_carrier_off(dev);
 		else
 			netif_carrier_on(dev);


-- 
Tobias						PGP: http://8ef7ddba.uguu.de
