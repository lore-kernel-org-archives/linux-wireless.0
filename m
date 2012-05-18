Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39791 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932533Ab2ERRQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 13:16:33 -0400
Message-ID: <1337361387.4802.6.camel@jlt3.sipsolutions.net> (sfid-20120518_191641_106614_D561BA33)
Subject: Re: rt28xx AP-mode problem with commit
 3edaf3e61fda3aa9ff8d38445bf92f2bec23bf63 "mac80211: manage AP netdev
 carrier state"
From: Johannes Berg <johannes@sipsolutions.net>
To: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 18 May 2012 19:16:27 +0200
In-Reply-To: <20120518011829.GD22418@yumi.tdiedrich.de>
References: <20120509105719.GA24457@yumi.tdiedrich.de>
	 <1336564773.4323.19.camel@jlt3.sipsolutions.net>
	 <20120509121827.GD5472@yumi.tdiedrich.de>
	 <20120509210448.GE5472@yumi.tdiedrich.de>
	 <1336637726.4334.13.camel@jlt3.sipsolutions.net>
	 <1336638453.4334.15.camel@jlt3.sipsolutions.net>
	 <20120518011829.GD22418@yumi.tdiedrich.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[dropping openwrt list, it keeps bothering me that I should subscribe]

On Fri, 2012-05-18 at 03:18 +0200, Tobias Diedrich wrote:

> One more clue:
> I think this has to do with the order in which the OpenWRT wifi
> script does things:
> 
> hostapd -P /var/run/wifi-phy0.pid -B /var/run/hostapd-phy0.conf
> hostapd_ctrl=/var/run/hostapd-phy0/wlan0
> ifconfig wlan0
> ifconfig wlan0 down
> ifconfig wlan0 hw ether 1c:af:f7:49:50:56 up
> ifconfig wlan0 0.0.0.0
> ifconfig wlan0
> ifconfig br-lan
> ifconfig wlan0 0.0.0.0
> ifconfig wlan0 hw ether 1c:af:f7:49:50:56 up
> iw dev wlan0 set txpower fixed 2000

Wow, ok, setting the interface down while the AP is up really isn't a
valid use of it. I'm actually amazed that it ever works at all when you
do this. Either this should be done the other way around, or hostapd
needs to get some smarts about it. For example, with the start-AP
function transition, I'm not sure even *beacon* after you do this...

johannes

