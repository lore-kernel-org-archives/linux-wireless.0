Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:6454 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaBJD5G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Feb 2014 22:57:06 -0500
Message-ID: <52F84DFD.4030602@huawei.com> (sfid-20140210_045731_887679_2CACA24D)
Date: Mon, 10 Feb 2014 11:56:45 +0800
From: Zhao Hongjiang <zhaohongjiang@huawei.com>
MIME-Version: 1.0
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <zhousiyi@huawei.com>
Subject: Get multiple ip addresses by dhcp for wireless card
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Is it possible for one station to get multiple ip addresses from AP/Wireless
router by dhcp? I had tried to add one or more virtual interface for
phy0 (wlan0, wlan1, wlan2,etc), but only wlan0 can get ip address from AP. 
the following is the steps:

/bin/wpa_supplicant -ddd -iwlan0 -Dnl80211 -c/wifi/wpa_supplicant.conf -B
/bin/wpa_cli -i wlan0 -p /wlan0
> add_network
> set_network 0 ssid "APabc" 
> set_network 0 psk "1111111" 
> enable_network 0

iw wlan0 interface add wlan1 type station 4addr on
ip link set wlan1 up
dhcpcd -ABKL wlan0 #works, can get ip
dhcpcd -ABKL wlan1 #cannot work

