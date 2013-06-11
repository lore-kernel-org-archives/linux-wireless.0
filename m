Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:51980 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab3FKNBe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 09:01:34 -0400
Date: Tue, 11 Jun 2013 15:01:29 +0200
From: Jakub =?UTF-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	nietrywialneprzejscie@gmail.com
Subject: Re: [RFC 4/5] mac80211: enforce address verification on monitors
Message-ID: <20130611150129.0413f67d@north> (sfid-20130611_150138_609339_F629ED2C)
In-Reply-To: <1370951175.8356.17.camel@jlt4.sipsolutions.net>
References: <1370612179-24385-1-git-send-email-moorray3@wp.pl>
	<1370612179-24385-5-git-send-email-moorray3@wp.pl>
	<51B1E4F3.9020509@openwrt.org>
	<20130607160402.49ea16c3@north>
	<51B1EDA8.10406@openwrt.org>
	<20130607184210.200dbb52@north>
	<1370951175.8356.17.camel@jlt4.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 11 Jun 2013 13:46:15 +0200, Johannes Berg wrote:
>On Fri, 2013-06-07 at 18:42 +0200, Jakub Kiciński wrote:
>
>> Now I can start two hostapd on those interfaces and
>> everything works just fine. 
>> 
>> # iw dev wlan0-1 set type monitor
>> # ip link set dev wlan0-1 address 00:00:fa:22:7c:00
>> # iw dev wlan0-1 set type managed
>> # ip link
>> 75: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP qlen 1000
>>     link/ether 00:4f:6a:06:57:90 brd ff:ff:ff:ff:ff:ff
>> 76: wlan0-1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP qlen 1000
>>     link/ether 00:00:fa:22:7c:00 brd ff:ff:ff:ff:ff:ff
>> 
>> If I start hostapd on both interfaces now the one on wlan0-1
>> will not work correctly (hw won't ack frames).
>> 
>> Also I think it's possible to change active flag on a monitor
>> while it's down (check in net/mac80211/cfg.c:75 only applies
>> to interfaces that are up):
>
> I think we should "just" move ieee80211_verify_mac() into do_open().
> Semantically anyway, I'm clearly handwaving a bit. But I would argue
> that you can set any MAC address that you like, as long as you don't
> bring the interface up, hence the verification really shouldn't be done
> when you assign the address but when you bring it up.

I've considered this initially. Two reasons that made me
think the current approach is cleaner are:
 - it's nice when user gets the error during the action that
   puts system in inconsistent state not some time later. I
   personally hate to get vague EBUSY and have to figure out
   what's wrong.
 - suppose there are two interfaces, both down with
   incompatible addresses. User adds third ifc, what address
   should we assign to it?

Besides who would care what address does passive monitor
have? ;)

> Consider also this. Say you have this scenario:
>
> address mask: 00:00:00:00:00:03
> wlan0: 02:00:00:00:00:00
> wlan1: 02:00:00:00:00:01
>
> Now you want to change to
> wlan0: 03:00:00:00:00:00
> wlan1: 03:00:00:00:00:01
>
> It seems that right now you can't do this at all, which also seems
> wrong.

Right but I believe user would understand what is the problem
here and just remove and recreate one of the interfaces. They
have to be down to change MAC addr anyway.

Obviously this change is no matter for a big discussion. I
already feel like stealing your time a bit, because only
rt2x00 cares about this stuff anyway (I think). So please
let me know if my reasoning convinces you and if not I will
be happy to rewrite this the way you suggest.

  -- kuba
