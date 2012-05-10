Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44295 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757300Ab2EJIP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 04:15:29 -0400
Message-ID: <1336637726.4334.13.camel@jlt3.sipsolutions.net> (sfid-20120510_101538_229332_FE8BA9F3)
Subject: Re: rt28xx AP-mode problem with commit
 3edaf3e61fda3aa9ff8d38445bf92f2bec23bf63 "mac80211: manage AP netdev
 carrier state"
From: Johannes Berg <johannes@sipsolutions.net>
To: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	linux-wireless@vger.kernel.org
Date: Thu, 10 May 2012 10:15:26 +0200
In-Reply-To: <20120509210448.GE5472@yumi.tdiedrich.de>
References: <20120509105719.GA24457@yumi.tdiedrich.de>
	 <1336564773.4323.19.camel@jlt3.sipsolutions.net>
	 <20120509121827.GD5472@yumi.tdiedrich.de>
	 <20120509210448.GE5472@yumi.tdiedrich.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-09 at 23:04 +0200, Tobias Diedrich wrote:

> > PKG_REV:=1f0cc27eb98f7d1af9c64d0752238184cbdb9a24

Ok.

> When associating to the AP works (3edaf3e61fda3aa9ff8d38445bf92f2bec23bf63 reverted):
> root@OpenWrt:/# ip monitor
> dev eth0.1 lladdr 00:50:5b:04:05:7e REACHABLE
> dev wlan0 lladdr a0:0b:ba:c6:9f:88 REACHABLE

Ah, well, I wanted "ip monitor" (and maybe restrict to "ip monitor
link") while you start/stop hostapd. Sorry for not being clear on that.
Also could be useful to look at it with the tcpdump thing, which is very
very strange.

I wonder if things like broadcast addresses are only added upon
netif_carrier_on() and that would reprogram filters and cause issues for
rt2x00... For that we'd need to do some more debugging inside mac80211
though.

johannes

