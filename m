Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37362 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab3FKLqU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 07:46:20 -0400
Message-ID: <1370951175.8356.17.camel@jlt4.sipsolutions.net> (sfid-20130611_134623_964503_129CBCBE)
Subject: Re: [RFC 4/5] mac80211: enforce address verification on monitors
From: Johannes Berg <johannes@sipsolutions.net>
To: Jakub =?UTF-8?Q?Kici=C5=84ski?= <moorray3@wp.pl>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	nietrywialneprzejscie@gmail.com
Date: Tue, 11 Jun 2013 13:46:15 +0200
In-Reply-To: <20130607184210.200dbb52@north>
References: <1370612179-24385-1-git-send-email-moorray3@wp.pl>
	 <1370612179-24385-5-git-send-email-moorray3@wp.pl>
	 <51B1E4F3.9020509@openwrt.org> <20130607160402.49ea16c3@north>
	 <51B1EDA8.10406@openwrt.org> <20130607184210.200dbb52@north>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-06-07 at 18:42 +0200, Jakub Kiciński wrote:

> Now I can start two hostapd on those interfaces and
> everything works just fine. 
> 
> # iw dev wlan0-1 set type monitor
> # ip link set dev wlan0-1 address 00:00:fa:22:7c:00
> # iw dev wlan0-1 set type managed
> # ip link
> 75: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP qlen 1000
>     link/ether 00:4f:6a:06:57:90 brd ff:ff:ff:ff:ff:ff
> 76: wlan0-1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP qlen 1000
>     link/ether 00:00:fa:22:7c:00 brd ff:ff:ff:ff:ff:ff
> 
> If I start hostapd on both interfaces now the one on wlan0-1
> will not work correctly (hw won't ack frames).
> 
> Also I think it's possible to change active flag on a monitor
> while it's down (check in net/mac80211/cfg.c:75 only applies
> to interfaces that are up):

I think we should "just" move ieee80211_verify_mac() into do_open().
Semantically anyway, I'm clearly handwaving a bit. But I would argue
that you can set any MAC address that you like, as long as you don't
bring the interface up, hence the verification really shouldn't be done
when you assign the address but when you bring it up.

Consider also this. Say you have this scenario:

address mask: 00:00:00:00:00:03
wlan0: 02:00:00:00:00:00
wlan1: 02:00:00:00:00:01

Now you want to change to
wlan0: 03:00:00:00:00:00
wlan1: 03:00:00:00:00:01

It seems that right now you can't do this at all, which also seems
wrong.

johannes

