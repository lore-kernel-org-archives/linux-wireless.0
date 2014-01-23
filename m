Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:19835 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbaAWJtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 04:49:04 -0500
Message-ID: <52E0E586.7050806@huawei.com> (sfid-20140123_104913_779178_CDA84F1E)
Date: Thu, 23 Jan 2014 17:48:54 +0800
From: Zhao Hongjiang <zhaohongjiang@huawei.com>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
CC: <zhousiyi@huawei.com>
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
>add_network
>set_network 0 ssid "APabc" 
>set_network 0 psk "1111111" 
>enable_network 0

iw wlan0 interface add wlan1 type station 4addr on
ip link set wlan1 up
dhcpcd -ABKL wlan0 #works, can get ip
dhcpcd -ABKL wlan1 #cannot work

