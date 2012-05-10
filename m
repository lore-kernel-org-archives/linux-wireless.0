Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44248 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681Ab2EJINI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 04:13:08 -0400
Message-ID: <1336637580.4334.10.camel@jlt3.sipsolutions.net> (sfid-20120510_101318_466389_471EA70C)
Subject: Re: rt28xx AP-mode problem with commit
 3edaf3e61fda3aa9ff8d38445bf92f2bec23bf63 "mac80211: manage AP netdev
 carrier state"
From: Johannes Berg <johannes@sipsolutions.net>
To: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	linux-wireless@vger.kernel.org
Date: Thu, 10 May 2012 10:13:00 +0200
In-Reply-To: <20120509212859.GF5472@yumi.tdiedrich.de>
References: <20120509105719.GA24457@yumi.tdiedrich.de>
	 <1336564773.4323.19.camel@jlt3.sipsolutions.net>
	 <20120509121827.GD5472@yumi.tdiedrich.de>
	 <20120509210448.GE5472@yumi.tdiedrich.de>
	 <20120509212859.GF5472@yumi.tdiedrich.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-09 at 23:28 +0200, Tobias Diedrich wrote:

> This seems to be the crucial hunk (and it conveniently ermoves a
> check against NL80211_IFTYPE_AP), if I revert just this it works for
> me:
> 
> Index: compat-wireless-2012-04-17/net/mac80211/iface.c
> ===================================================================
> --- compat-wireless-2012-04-17.orig/net/mac80211/iface.c	2012-05-09 01:00:39.197975402 +0200
> +++ compat-wireless-2012-04-17/net/mac80211/iface.c	2012-05-09 01:02:32.514918371 +0200
> @@ -411,8 +407,7 @@
>  		ieee80211_bss_info_change_notify(sdata, changed);
>  
>  		if (sdata->vif.type == NL80211_IFTYPE_STATION ||
> -		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
> -		    sdata->vif.type == NL80211_IFTYPE_AP)
> +		    sdata->vif.type == NL80211_IFTYPE_ADHOC)
>  			netif_carrier_off(dev);

Well ... yeah, if you remove this change all the other changes don't
really do anything so that's not really surprising :)

johannes

