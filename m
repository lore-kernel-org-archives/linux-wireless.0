Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59163 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab1GTNQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 09:16:16 -0400
Received: by vxh35 with SMTP id 35so131393vxh.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2011 06:16:15 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 20 Jul 2011 17:16:15 +0400
Message-ID: <CAN=pzdLRaRHkg4NquUpDhEwRzq-roKQXMtMcwnr031maDSLRfw@mail.gmail.com> (sfid-20110720_151619_779532_B838DC90)
Subject: rt2x00, AP mode, 802.11n is not working properly
From: Stanislav Demakov <s.demakov@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I'm using hostapd 0.73 and 1T1R rt2x00 based wireless dongle to create
an AP. The problem is that since version
compat-wireless-2010-12-14.tar.bz2 802.11n mode is not working
properly. In this driver version and all later you've broken
something!
The point is if wmm_enabled=1 then max transfer speed slows down to
100-200 KBytes\s. Without wmm_enabled speed is ok and about 4-5
MBytes\s (my max connection rate is 65mbps).
But some wireless clients won't connect in 802.11n mode when this
option is disabled, this is why I need it.

My hostapd.conf:
interface=wlan0
driver=nl80211
ssid=Server
hw_mode=g
channel=11
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wmm_enabled=1
ieee80211n=1
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_passphrase=***
rsn_pairwise=CCMP

(Ubuntu Server 10.04, driver module is rt2800usb.)
I've tested the speed in both directions and it seems that speed from
client to AP is fine, while from AP to client is very slow.
I've build on different kernels and also tried two other dongles with
no difference. Currently I have the latest stable compat-wireless
driver and the problem is the same. And same thing for current
bleeding edge.
The last release where it wasn't broken yet is
compat-wireless-2010-12-13.tar.bz2 or stable
compat-wireless-2.6.37-4.tar.bz2. But I can't use them at all because
they have stability issues.
