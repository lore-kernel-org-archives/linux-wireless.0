Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from reiner-h.de ([83.151.27.91]:43330 "EHLO reiner-h.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbZE1Ieg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 04:34:36 -0400
Received: from [192.168.0.42] (88-134-42-48-dynip.superkabel.de [88.134.42.48])
	by reiner-h.de (Postfix) with ESMTP id C67A34E504
	for <linux-wireless@vger.kernel.org>; Thu, 28 May 2009 07:55:08 +0000 (UTC)
Message-ID: <4A1E448E.1030201@reiner-h.de>
Date: Thu, 28 May 2009 10:00:14 +0200
From: Reiner Herrmann <reiner@reiner-h.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: mac80211_hwsim: Problem setting up communication
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I want to use mac80211_hwsim (from kernel 2.6.30-rc6) for some testing,
but I can't get the two interfaces to communicate with each other.

I've done the following:

# hostapd -B hostapd.conf
Configuration file: hostapd.conf
Using interface wlan0 with hwaddr 02:00:00:00:00:00 and ssid 'mac80211 test'
# iwconfig wlan1 essid "mac80211 test"
# ifconfig wlan0 10.0.0.1 up
# ifconfig wlan1 10.0.0.2 up

wlan1 can successfully associate, but I can't reach any interface via
the other:

# ping -I wlan0 10.0.0.2
PING 10.0.0.2 (10.0.0.2) from 10.0.0.1 wlan0: 56(84) bytes of data.
>From 10.0.0.1 icmp_seq=1 Destination Host Unreachable
# ping -I wlan1 10.0.0.1
PING 10.0.0.1 (10.0.0.1) from 10.0.0.2 wlan1: 56(84) bytes of data.
>From 10.0.0.2 icmp_seq=1 Destination Host Unreachable

With tcpdump I can see ARP requests on both interfaces:
09:43:28.687273 ARP, Request who-has 10.0.0.2 tell 10.0.0.1, length 28

But there is no answer or other traffic.

Did I forget soemthing in the setup?


Thanks for your help.
Regards,

Reiner
