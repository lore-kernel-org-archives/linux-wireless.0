Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:36993 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756325Ab0LIUuI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 15:50:08 -0500
From: "B. James Phillippe" <bryanp35@comcast.net>
Content-Type: text/plain; charset=us-ascii
Subject: Problems with ath9k on IXP400, using Linux 2.6.35.8 and compat-wireless-2010-12-07
Date: Thu, 9 Dec 2010 12:44:03 -0800
Message-Id: <D7B42E97-D08D-4D12-BCD7-6BF7486E1C21@comcast.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

I'm new to this list and a bit new to using this project; hopefully I'm not doing something obviously stupid. :)

I have an ARM-based Intel IXP400 system with more than 64MB RAM and with an Atheros AR9160 on the PCI bus (only thing on the PCI bus).  I was able to use this device with Linux 2.6.21 and an earlier driver version.  It seemed to work okay, as both client and AP.  Now I'd like to upgrade to a newer kernel and WiFi driver.  I'm having problems getting it to work correctly.

I am seeing a number of problems, perhaps related:

1.) I am seeing these warning messages:

WARNING: at /home/bp/compat-wireless-2010-12-07/drivers/net/wireless/ath/ath9k/recv.c:532 ath_stoprecv+0x84/0x94 [ath9k]()
Could not stop RX, we could be confusing the DMA engine when we start RX up

additionally, no radio I/O appears to work.

2.) iwlist wlan0 scan now reports that the Interface doesn't support scanning.  This used to work fine under the older setup.  I suspect this is a result of #1.

Here is the old configuration:

Linux-2.6.21 with CONFIG_DMABOUNCE enabled
Atheros AR9160 MAC/BB Rev:1 AR5133 RF Rev:b0: mem=0xd2940000, irq=6

ifconfig wlan0 1.2.3.4 netmask 255.255.255.0
iwlist wlan0 scan
<returns all the local SSIDs>

Here is the new configuration:

Linux-2.6.35.8 with CONFIG_DMABOUNCE enabled
Compat-wireless backport release: compat-wireless-20010-12-03
Backport based on linux-next.git next-20101207
cfg80211: Calling CRDA to update world regulatory domain
PCI: enabling device 0000:00:02.0 (0340 -> 0342)
ath: EEPROM regdomain: 0x0
ath: EEPROM indicates default country code should be used
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x3a
ath: Country alpha2 being used: US
ath: Regpair used: 0x3a
ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
cfg80211: wext will not work because kernel was compiled with CONFIG_WIRELESS_EXT=n. Tools using wext interface, like iwconfig will not work.
Registered led device: ath9k-phy0::radio
Registered led device: ath9k-phy0::assoc
Registered led device: ath9k-phy0::tx
Registered led device: ath9k-phy0::rx
ieee80211 phy0: Atheros AR9160 MAC/BB Rev:1 AR5133 RF Rev:b0 mem=0xd2660000, irq=6

ifconfig wlan0 1.2.3.4 netmask 255.255.255.0  (*)
iwlist wlan0 scan
wlan0     Interface doesn't support scanning.


(*) this results in the following warnings in the klog:

WARNING: at /home/bp/compat-wireless-2010-12-07/drivers/net/wireless/ath/ath9k/recv.c:532 ath_stoprecv+0x84/0x94 [ath9k]()
Could not stop RX, we could be confusing the DMA engine when we start RX up
[...backtrace and duplicates removed...]
ADDRCONF(NETDEV_UP): wlan0: link is not ready


I don't really understand the "wext" message; I am compiling my kernel with CONFIG_CFG80211_WEXT=y and CONFIG_WIRELESS_EXT_SYSFS=y; I don't see an option for CONFIG_WIRELESS_EXT(?)

Also fwiw, In both the new and old configuration, I am using this patch:

https://dev.openwrt.org/browser/trunk/target/linux/ixp4xx/patches-2.6.32/600-skb_avoid_dmabounce.patch

Thanks for any advice!

--
-bp