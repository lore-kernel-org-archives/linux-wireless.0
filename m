Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yumi.tdiedrich.de ([85.10.210.183]:59618 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932347Ab2EIVEw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 17:04:52 -0400
Date: Wed, 9 May 2012 23:04:48 +0200
From: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	linux-wireless@vger.kernel.org
Subject: Re: rt28xx AP-mode problem with commit
 3edaf3e61fda3aa9ff8d38445bf92f2bec23bf63 "mac80211: manage AP netdev
 carrier state"
Message-ID: <20120509210448.GE5472@yumi.tdiedrich.de> (sfid-20120509_230456_194214_7AC2A5E3)
References: <20120509105719.GA24457@yumi.tdiedrich.de>
 <1336564773.4323.19.camel@jlt3.sipsolutions.net>
 <20120509121827.GD5472@yumi.tdiedrich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120509121827.GD5472@yumi.tdiedrich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tobias Diedrich wrote:
> Johannes Berg wrote:
> > On Wed, 2012-05-09 at 12:57 +0200, Tobias Diedrich wrote:
> > 
> > > I've bisected a problem with running rt3052-based APs on recent
> > > OpenWRT down to this commit: 3edaf3e61fda3aa9ff8d38445bf92f2bec23bf63
> > > "mac80211: manage AP netdev carrier state"
> > > 
> > > If I revert this commit (and also fix the max_power issue), AP-mode
> > > works fine, but if I leave it in, association to the AP times out.
> > > 
> > > (The AP-side hostapd claims WPA authentication was successful, but
> > > the client never connects)
> > > 
> > > (Note: I haven't gotten around to testing a non-rt28xx based AP yet,
> > > so I'm only assuming this affects only rt28xx, maybe it does affect
> > > other chipsets as well)
> > 
> > Works fine here, but I don't see how that patch could affect rt2x00
> > only.
> > 
> > You're going to have to give us more details about the failure, like the
> > version of hostapd at least. The output of "ip monitor" would also be
> > helpful.
> 
> The hostapd package Makefile says:
> 
> PKG_NAME:=hostapd
> PKG_VERSION:=20120428
> PKG_RELEASE:=1
> PKG_REV:=1f0cc27eb98f7d1af9c64d0752238184cbdb9a24
> 
> PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
> PKG_SOURCE_URL:=git://w1.fi/srv/git/hostap.git
> 
> Can't look at ip output right now as I'm still at work and the
> AP is switched off.

root@OpenWrt:/# hostapd -v
hostapd v2.0-devel
User space daemon for IEEE 802.11 AP management,
IEEE 802.1X/WPA/WPA2/EAP/RADIUS Authenticator
Copyright (c) 2002-2012, Jouni Malinen <j@w1.fi> and contributors


When associating to the AP works (3edaf3e61fda3aa9ff8d38445bf92f2bec23bf63 reverted):
root@OpenWrt:/# ip monitor
dev eth0.1 lladdr 00:50:5b:04:05:7e REACHABLE
dev wlan0 lladdr a0:0b:ba:c6:9f:88 REACHABLE
root@OpenWrt:/# logread
[...]
Sep  8 15:44:52 OpenWrt daemon.info hostapd: wlan0: STA
a0:0b:ba:c6:9f:88 IEEE 802.11: authenticated
Sep  8 15:44:52 OpenWrt daemon.info hostapd: wlan0: STA
a0:0b:ba:c6:9f:88 IEEE 802.11: associated (aid 1)
Sep  8 15:44:52 OpenWrt daemon.info hostapd: wlan0: STA
a0:0b:ba:c6:9f:88 WPA: pairwise key handshake completed (RSN)
[...]
[switching phone back to different working AP]
Sep  8 15:45:01 OpenWrt daemon.info hostapd: wlan0: STA
a0:0b:ba:c6:9f:88 IEEE 802.11: disassociated
Sep  8 15:45:02 OpenWrt daemon.info hostapd: wlan0: STA
a0:0b:ba:c6:9f:88 IEEE 802.11: deauthenticated due to inactivity
(timer)


When associating fails:
root@OpenWrt:/# ip monitor
dev eth0.1 lladdr 00:50:5b:04:05:7e REACHABLE
root@OpenWrt:/# logread
[...]
Sep  8 15:44:59 OpenWrt daemon.info hostapd: wlan0: STA
a0:0b:ba:c6:9f:88 IEEE 802.11: authenticated
Sep  8 15:44:59 OpenWrt daemon.info hostapd: wlan0: STA
a0:0b:ba:c6:9f:88 IEEE 802.11: associated (aid 1)
Sep  8 15:45:05 OpenWrt daemon.info hostapd: wlan0: STA
a0:0b:ba:c6:9f:88 IEEE 802.11: authenticated
Sep  8 15:45:05 OpenWrt daemon.info hostapd: wlan0: STA
a0:0b:ba:c6:9f:88 IEEE 802.11: associated (aid 1)
Sep  8 15:45:12 OpenWrt daemon.info hostapd: wlan0: STA
a0:0b:ba:c6:9f:88 IEEE 802.11: authenticated
Sep  8 15:45:12 OpenWrt daemon.info hostapd: wlan0: STA
a0:0b:ba:c6:9f:88 IEEE 802.11: associated (aid 1)
Sep  8 15:45:18 OpenWrt daemon.info hostapd: wlan0: STA
a0:0b:ba:c6:9f:88 IEEE 802.11: authenticated
Sep  8 15:45:18 OpenWrt daemon.info hostapd: wlan0: STA
a0:0b:ba:c6:9f:88 IEEE 802.11: associated (aid 1)
Sep  8 15:45:24 OpenWrt daemon.info hostapd: wlan0: STA
a0:0b:ba:c6:9f:88 IEEE 802.11: authenticated
Sep  8 15:45:24 OpenWrt daemon.info hostapd: wlan0: STA
a0:0b:ba:c6:9f:88 IEEE 802.11: associated (aid 1)
Sep  8 15:45:31 OpenWrt daemon.info hostapd: wlan0: STA
a0:0b:ba:c6:9f:88 IEEE 802.11: authenticated
Sep  8 15:45:31 OpenWrt daemon.info hostapd: wlan0: STA
a0:0b:ba:c6:9f:88 IEEE 802.11: associated (aid 1)
Sep  8 15:45:37 OpenWrt daemon.info hostapd: wlan0: STA
a0:0b:ba:c6:9f:88 IEEE 802.11: authenticated
Sep  8 15:45:37 OpenWrt daemon.info hostapd: wlan0: STA
a0:0b:ba:c6:9f:88 IEEE 802.11: associated (aid 1)
[...]
[switching phone back to different working AP]
Sep  8 15:47:40 OpenWrt daemon.info hostapd: wlan0: STA
a0:0b:ba:c6:9f:88 IEEE 802.11: disassociated
Sep  8 15:47:41 OpenWrt daemon.info hostapd: wlan0: STA
a0:0b:ba:c6:9f:88 IEEE 802.11: deauthenticated due to inactivity
(timer)
[...]



Aaand now I was trying to take traffic capture on the AP, but it
also works as long as the tcpdump is running.
Adding the monitor device by itself doesn't help, but actually
starting tcpdump does make it suddenly work (regardless of -p).

Also /usr/sbin/hostapd -dd /var/run/hostapd-phy0.conf seems to work,
while
hostapd -P /var/run/wifi-phy0.pid -B /var/run/hostapd-phy0.conf
doesn't.

Some sort of subtle timing issue maybe?

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
