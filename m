Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yumi.tdiedrich.de ([85.10.210.183]:58917 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933550Ab2ERA5E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 20:57:04 -0400
Date: Fri, 18 May 2012 02:57:00 +0200
From: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	linux-wireless@vger.kernel.org
Subject: Re: rt28xx AP-mode problem with commit
 3edaf3e61fda3aa9ff8d38445bf92f2bec23bf63 "mac80211: manage AP netdev
 carrier state"
Message-ID: <20120518005700.GC22418@yumi.tdiedrich.de> (sfid-20120518_025709_493741_8EAF77BC)
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

It's with compat-wireless, as I wrote earlier.  Against 3.3.6 base
kernel.

ip_monitor_link.ok.log
|nn: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state UNKNOWN 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <BROADCAST,MULTICAST> mtu 1500 master br-lan state DOWN 
|    link/ether 1c:af:f7:49:50:56
|nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br-lan state DOWN 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state DOWN 
|    link/ether 1c:af:f7:49:50:56
|nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state DOWN 
|    link/ether 1c:af:f7:49:50:56
|nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state DOWN 
|    link/ether 1c:af:f7:49:50:56
|nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state DORMANT 
|    link/ether 1c:af:f7:49:50:56
|nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br-lan state DORMANT 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state UP 
|    link/ether 1c:af:f7:49:50:56
|nn: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br-lan state UP 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state UP 
|    link/ether 1c:af:f7:49:50:56
|Deleted nn: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state UP 
|    link/ether 1c:af:f7:49:50:56
|nn: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state UP 
|    link/ether 1c:af:f7:49:50:56
|nn: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state UP 
|    link/ether 1c:af:f7:49:50:56
|nn: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state UP 
|    link/ether 1c:af:f7:49:50:56

ip_monitor_link.borked.log
|nn: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state UNKNOWN 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DORMANT 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <BROADCAST,MULTICAST> mtu 1500 master br-lan state DOWN 
|    link/ether 1c:af:f7:49:50:56
|nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq master br-lan state DOWN 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br-lan state DOWN 
|    link/ether 1c:af:f7:49:50:56
|nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state DORMANT 
|    link/ether 1c:af:f7:49:50:56
|nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state DORMANT 
|    link/ether 1c:af:f7:49:50:56
|nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state DORMANT 
|    link/ether 1c:af:f7:49:50:56
|nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br-lan state DORMANT 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state UP 
|    link/ether 1c:af:f7:49:50:56
|nn: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br-lan state UP 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state UP 
|    link/ether 1c:af:f7:49:50:56
|Deleted nn: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state UP 
|    link/ether 1c:af:f7:49:50:56
|nn: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state UP 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN 
|    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
|nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br-lan state DOWN 
|    link/ether 1c:af:f7:49:50:56

diff:
--- ip_monitor_link.ok.log	2012-05-18 02:52:03.150741127 +0200
+++ ip_monitor_link.borked.log	2012-05-18 02:39:05.846504038 +0200
@@ -2,6 +2,8 @@
     link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
 nn: wlan0: <BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state UNKNOWN 
     link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
+nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DORMANT 
+    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
 nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN 
     link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
 nn: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN 
@@ -10,13 +12,13 @@
     link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
 nn: wlan0: <BROADCAST,MULTICAST> mtu 1500 master br-lan state DOWN 
     link/ether 1c:af:f7:49:50:56
-nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br-lan state DOWN 
+nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq master br-lan state DOWN 
     link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
-nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state DOWN 
+nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br-lan state DOWN 
     link/ether 1c:af:f7:49:50:56
-nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state DOWN 
+nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state DORMANT 
     link/ether 1c:af:f7:49:50:56
-nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state DOWN 
+nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state DORMANT 
     link/ether 1c:af:f7:49:50:56
 nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state DORMANT 
     link/ether 1c:af:f7:49:50:56
@@ -34,11 +36,9 @@
     link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
 nn: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN 
     link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
-nn: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP 
+nn: wlan0: <BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state UP 
     link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
-nn: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state UP 
-    link/ether 1c:af:f7:49:50:56
-nn: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state UP 
-    link/ether 1c:af:f7:49:50:56
-nn: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br-lan state UP 
+nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN 
+    link/ether 1c:af:f7:49:50:56 brd ff:ff:ff:ff:ff:ff
+nn: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br-lan state DOWN 
     link/ether 1c:af:f7:49:50:56

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
