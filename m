Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ec2-54-93-35-231.eu-central-1.compute.amazonaws.com ([54.93.35.231]:49471
	"EHLO localhost" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759923AbbLCLL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 06:11:28 -0500
Received: from localhost (localhost [127.0.0.1])
	by localhost (Postfix) with ESMTP id 7F87F10332A
	for <linux-wireless@vger.kernel.org>; Thu,  3 Dec 2015 11:01:50 +0000 (UTC)
Received: from localhost ([127.0.0.1])
	by localhost (open-hotspot.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QLuErfubbUEi for <linux-wireless@vger.kernel.org>;
	Thu,  3 Dec 2015 11:01:50 +0000 (UTC)
Received: from [127.0.0.1] (dslb-084-061-032-033.084.061.pools.vodafone-ip.de [84.61.32.33])
	by localhost (Postfix) with ESMTPA id A93AA103325
	for <linux-wireless@vger.kernel.org>; Thu,  3 Dec 2015 11:01:49 +0000 (UTC)
To: linux-wireless@vger.kernel.org
From: Reiner Karlsberg <karlsberg@softart-ge.com>
Subject: iw ignores channel switch
Message-ID: <5660210D.4090303@softart-ge.com> (sfid-20151203_121928_609938_D1109D00)
Date: Thu, 3 Dec 2015 12:01:33 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am using openwrt on the following system:
root@OpenWrt:/tmp# iw --version
iw version 3.17
ieee80211 phy0: Atheros AR9340 Rev:2 mem=0xb8100000, irq=47

I want to switch between managed (station) mode and monitor mode.

So I have the follwoing scenarion:

root@OpenWrt:/tmp# iw dev
phy#1
         Interface wlan1
                 ifindex 5
                 wdev 0x100000001
                 addr 00:90:a9:ab:f8:ed
                 type managed
phy#0
         Interface wlan0
                 ifindex 21                         #steadily increasing, not re-used ?
                 wdev 0x10
                 addr 00:90:a9:ab:f8:eb
                 type managed
root@OpenWrt:/tmp# ifconfig wlan0 up
root@OpenWrt:/tmp# iw dev wlan0 connect SSID
root@OpenWrt:/tmp# udhcpc -i wlan0 --quit
udhcpc (v1.23.2) started
Sending discover...
Sending select for 192.168.20.144...
Lease of 192.168.20.144 obtained, lease time 28800
udhcpc: ifconfig wlan0 192.168.20.144 netmask 255.255.255.0 broadcast 192.168.20.255
udhcpc: setting default routers: 192.168.20.1
root@OpenWrt:/tmp# wget http://somewhere.com/something.html
Connecting to somewhere.com (xx.xx.xx.xx:80)
wget: server returned error: HTTP/1.1 500 Internal Server Error
root@OpenWrt:/tmp# iw phy phy0 interface add wmon0 type monitor
root@OpenWrt:/tmp# iw dev
phy#1
         Interface wlan1
                 ifindex 5
                 wdev 0x100000001
                 addr 00:90:a9:ab:f8:ed
                 type managed
phy#0
         Interface wmon0
                 ifindex 22
                 wdev 0x11
                 addr 00:90:a9:ab:f8:eb
                 type monitor
         Interface wlan0
                 ifindex 21
                 wdev 0x10
                 addr 00:90:a9:ab:f8:eb
                 ssid SSID
                 type managed
                 channel 7 (2442 MHz), width: 40 MHz, center1: 2452 MHz
root@OpenWrt:/tmp# ifconfig wmon0 up
root@OpenWrt:/tmp# iw dev
phy#1
         Interface wlan1
                 ifindex 5
                 wdev 0x100000001
                 addr 00:90:a9:ab:f8:ed
                 type managed
phy#0
         Interface wmon0
                 ifindex 22
                 wdev 0x11
                 addr 00:90:a9:ab:f8:eb
                 type monitor
         Interface wlan0
                 ifindex 21
                 wdev 0x10
                 addr 00:90:a9:ab:f8:eb
                 ssid SSID
                 type managed
                 channel 7 (2442 MHz), width: 40 MHz, center1: 2452 MHz
root@OpenWrt:/tmp# iw dev wlan0 del
root@OpenWrt:/tmp# iw dev
phy#1
         Interface wlan1
                 ifindex 5
                 wdev 0x100000001
                 addr 00:90:a9:ab:f8:ed
                 type managed
phy#0
         Interface wmon0
                 ifindex 22
                 wdev 0x11
                 addr 00:90:a9:ab:f8:eb
                 type monitor
                 channel 7 (2442 MHz), width: 20 MHz (no HT), center1: 2442 MHz
root@OpenWrt:/tmp# iw dev wmon0 set channel 1
root@OpenWrt:/tmp# iw dev
phy#1
         Interface wlan1
                 ifindex 5
                 wdev 0x100000001
                 addr 00:90:a9:ab:f8:ed
                 type managed
phy#0
         Interface wmon0
                 ifindex 22
                 wdev 0x11
                 addr 00:90:a9:ab:f8:eb
                 type monitor
                 channel 7 (2442 MHz), width: 20 MHz (no HT), center1: 2442 MHz

As to be seen, the modification of the channel does not generate an error, but is simply ignored.
What did I do wrong ?


Second question: The "ifindex" is always increasing, during several tests,
when unsuccessfully trying similar scenarios (different sequence of ifconfig ... up/down, iw dev ... del etc.)
Will this "ifindex" "overflow" some time,
even in case of repeated "iw phy phy0 interface add wmon0 type monitor" "iw dev wmon0 del" ?
I would have expected some kind of "reuse".

Regards
-- 
Reiner Karlsberg


-----
No virus found in this message.
Checked by AVG - www.avg.com
Version: 2014.0.4842 / Virus Database: 4447/10982 - Release Date: 11/11/15
Internal Virus Database is out of date.

