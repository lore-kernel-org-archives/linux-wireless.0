Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:16079 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657Ab3FGQmO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 12:42:14 -0400
Date: Fri, 7 Jun 2013 18:42:10 +0200
From: Jakub =?UTF-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	nietrywialneprzejscie@gmail.com
Subject: Re: [RFC 4/5] mac80211: enforce address verification on monitors
Message-ID: <20130607184210.200dbb52@north> (sfid-20130607_184217_839508_A51BFF6C)
In-Reply-To: <51B1EDA8.10406@openwrt.org>
References: <1370612179-24385-1-git-send-email-moorray3@wp.pl>
	<1370612179-24385-5-git-send-email-moorray3@wp.pl>
	<51B1E4F3.9020509@openwrt.org>
	<20130607160402.49ea16c3@north>
	<51B1EDA8.10406@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 07 Jun 2013 16:26:48 +0200, Felix Fietkau wrote:
>On 2013-06-07 4:04 PM, Jakub Kiciński wrote:
>> On Fri, 07 Jun 2013 15:49:39 +0200, Felix Fietkau wrote:
>>> On 2013-06-07 3:36 PM, Jakub Kicinski wrote:
>>>> From: Jakub Kicinski <kubakici@wp.pl>
>>>> 
>>>> Mac address of passive monitor have to treated
>>>> the same as address any other interface because
>>>> type of interface can be changed or monitor can
>>>> be later put into active mode.
>>> It can't. There's checks preventing that. I'd prefer to leave that part
>>> of the code as it is, the MAC address for normal monitor interfaces
>>> should be ignored completely.
>> 
>> I must have misread the code regarding active monitors then.
>> Main motivation behind this patch was the first part though
>> - user can change type of interface and once ignored address
>> of monitor now becomes address of AP, sta etc. 
> I'm pretty sure that switching from monitor to something else is also
> not supported.

Ok, let me explain what I mean to prevent by showing a command
trace - running unpatched wireless-testing and patched iw [1].

# lsmod | grep mac8
# modprobe rt2800usb
# iw dev wlan0 interface add wlan0-1 type managed
# ip link
75: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
    link/ether 00:4f:6a:06:57:90 brd ff:ff:ff:ff:ff:ff
76: wlan0-1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
    link/ether 00:4f:6a:06:57:91 brd ff:ff:ff:ff:ff:ff

Now I can start two hostapd on those interfaces and
everything works just fine. 

# iw dev wlan0-1 set type monitor
# ip link set dev wlan0-1 address 00:00:fa:22:7c:00
# iw dev wlan0-1 set type managed
# ip link
75: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP qlen 1000
    link/ether 00:4f:6a:06:57:90 brd ff:ff:ff:ff:ff:ff
76: wlan0-1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP qlen 1000
    link/ether 00:00:fa:22:7c:00 brd ff:ff:ff:ff:ff:ff

If I start hostapd on both interfaces now the one on wlan0-1
will not work correctly (hw won't ack frames).

Also I think it's possible to change active flag on a monitor
while it's down (check in net/mac80211/cfg.c:75 only applies
to interfaces that are up):

# iw dev wlan0 interface add wlan0-1 type monitor flags active
# iw dev wlan0-1 set monitor none
# iw dev wlan0-1 set monitor active
# iw dev wlan0-1 set monitor none

  -- kuba

[1] http://moorray.hopto.org/iw_active_monitors.patch
