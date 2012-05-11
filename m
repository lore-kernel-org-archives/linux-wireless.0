Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yumi.tdiedrich.de ([85.10.210.183]:39236 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101Ab2EKXjO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 19:39:14 -0400
Date: Sat, 12 May 2012 01:39:03 +0200
From: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	linux-wireless@vger.kernel.org
Subject: Re: rt28xx AP-mode problem with commit
 3edaf3e61fda3aa9ff8d38445bf92f2bec23bf63 "mac80211: manage AP netdev
 carrier state"
Message-ID: <20120511233903.GG5472@yumi.tdiedrich.de> (sfid-20120512_013918_060378_9C08CB2F)
References: <20120509105719.GA24457@yumi.tdiedrich.de>
 <1336564773.4323.19.camel@jlt3.sipsolutions.net>
 <20120509121827.GD5472@yumi.tdiedrich.de>
 <20120509210448.GE5472@yumi.tdiedrich.de>
 <1336637726.4334.13.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1336637726.4334.13.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2012-05-09 at 23:04 +0200, Tobias Diedrich wrote:
> 
> > > PKG_REV:=1f0cc27eb98f7d1af9c64d0752238184cbdb9a24
> 
> Ok.
> 
> > When associating to the AP works (3edaf3e61fda3aa9ff8d38445bf92f2bec23bf63 reverted):
> > root@OpenWrt:/# ip monitor
> > dev eth0.1 lladdr 00:50:5b:04:05:7e REACHABLE
> > dev wlan0 lladdr a0:0b:ba:c6:9f:88 REACHABLE
> 
> Ah, well, I wanted "ip monitor" (and maybe restrict to "ip monitor
> link") while you start/stop hostapd. Sorry for not being clear on that.
> Also could be useful to look at it with the tcpdump thing, which is very
> very strange.
> 
> I wonder if things like broadcast addresses are only added upon
> netif_carrier_on() and that would reprogram filters and cause issues for
> rt2x00... For that we'd need to do some more debugging inside mac80211
> though.

BTW I'll resume debugging next week, I'm on vacation in warsaw since
yesterday.

Cheers,

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
