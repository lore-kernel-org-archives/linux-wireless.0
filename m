Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yumi.tdiedrich.de ([85.10.210.183]:59184 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761070Ab2ERBSe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 21:18:34 -0400
Date: Fri, 18 May 2012 03:18:29 +0200
From: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	linux-wireless@vger.kernel.org
Subject: Re: rt28xx AP-mode problem with commit
 3edaf3e61fda3aa9ff8d38445bf92f2bec23bf63 "mac80211: manage AP netdev
 carrier state"
Message-ID: <20120518011829.GD22418@yumi.tdiedrich.de> (sfid-20120518_031842_360577_3AA67981)
References: <20120509105719.GA24457@yumi.tdiedrich.de>
 <1336564773.4323.19.camel@jlt3.sipsolutions.net>
 <20120509121827.GD5472@yumi.tdiedrich.de>
 <20120509210448.GE5472@yumi.tdiedrich.de>
 <1336637726.4334.13.camel@jlt3.sipsolutions.net>
 <1336638453.4334.15.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1336638453.4334.15.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2012-05-10 at 10:15 +0200, Johannes Berg wrote:
> > On Wed, 2012-05-09 at 23:04 +0200, Tobias Diedrich wrote:
> > 
> > > > PKG_REV:=1f0cc27eb98f7d1af9c64d0752238184cbdb9a24
> > 
> > Ok.
> > 
> > > When associating to the AP works (3edaf3e61fda3aa9ff8d38445bf92f2bec23bf63 reverted):
> > > root@OpenWrt:/# ip monitor
> > > dev eth0.1 lladdr 00:50:5b:04:05:7e REACHABLE
> > > dev wlan0 lladdr a0:0b:ba:c6:9f:88 REACHABLE
> > 
> > Ah, well, I wanted "ip monitor" (and maybe restrict to "ip monitor
> > link") while you start/stop hostapd. Sorry for not being clear on that.
> > Also could be useful to look at it with the tcpdump thing, which is very
> > very strange.
> > 
> > I wonder if things like broadcast addresses are only added upon
> > netif_carrier_on() and that would reprogram filters and cause issues for
> > rt2x00... For that we'd need to do some more debugging inside mac80211
> > though.
> 
> I don't see anything like that happening upon netif_carrier_on(), the
> only thing that really seems to happen is attaching and starting qdiscs,
> which shouldn't make a difference across drivers...
> 
> Is this using compat-wireless? But then, so do I right now, against 3.1
> base kernel.

One more clue:
I think this has to do with the order in which the OpenWRT wifi
script does things:

hostapd -P /var/run/wifi-phy0.pid -B /var/run/hostapd-phy0.conf
hostapd_ctrl=/var/run/hostapd-phy0/wlan0
ifconfig wlan0
ifconfig wlan0 down
ifconfig wlan0 hw ether 1c:af:f7:49:50:56 up
ifconfig wlan0 0.0.0.0
ifconfig wlan0
ifconfig br-lan
ifconfig wlan0 0.0.0.0
ifconfig wlan0 hw ether 1c:af:f7:49:50:56 up
iw dev wlan0 set txpower fixed 2000


i.e. if I restart hostapd by hand the interface comes up:

|[  791.570000] br-lan: port 2(wlan0) entered disabled state
|14: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc mq master br-lan state DOWN 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|14: wlan0: <BROADCAST,MULTICAST> mtu 1500 master br-lan state DOWN 
|    link/ether 1c:af:f7:49:50:56
|14: wlan0: <BROADCAST,MULTICAST> mtu 1500 master br-lan state DOWN 
|    link/ether 1c:af:f7:49:50:56
|14: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc mq master br-lan state DOWN 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|14: wlan0: <BROADCAST,MULTICAST> mtu 1500 master br-lan state DOWN 
|    link/ether 1c:af:f7:49:50:56
|14: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq master br-lan state DOWN 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|14: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br-lan state DOWN 
|    link/ether 1c:af:f7:49:50:56
|[  792.130000] br-lan: port 2(wlan0) entered forwarding state
|[  792.140000] br-lan: port 2(wlan0) entered forwarding state
|14: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state DORMANT 
|    link/ether 1c:af:f7:49:50:56
|14: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state DORMANT 
|    link/ether 1c:af:f7:49:50:56
|14: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state DORMANT 
|    link/ether 1c:af:f7:49:50:56
|14: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br-lan state DORMANT 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|14: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state UP 
|    link/ether 1c:af:f7:49:50:56
|14: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br-lan state UP 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff

Then I do ifconfig wlan0 down
|4: wlan0: <BROA[  829.620000] br-lan: port 2(wlan0) entered disabled state
|DCAST,MULTICAST> mtu 1500 qdisc mq master br-lan state DOWN 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|14: wlan0: <BROADCAST,MULTICAST> mtu 1500 master br-lan state DOWN 
|    link/ether 1c:af:f7:49:50:56
|14: wlan0: <BROADCAST,MULTICAST> mtu 1500 master br-lan state DOWN 
|    link/ether 1c:af:f7:49:50:56

Followed by ifconfig wlan0 up
|14: wlan0: <BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq master br-lan state UP 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|14: wlan0: <BROADCAST,MULTICAST,UP> mtu 1500 master br-lan state UP 
|    link/ether 1c:af:f7:49:50:56
|14: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br-lan state DOWN 
|    link/ether 1c:af:f7:49:50:56
|14: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq master br-lan state DOWN 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff

And it stays down with NO-CARRIER.

HTH,

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
