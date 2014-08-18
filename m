Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ems.wolfvision.net ([213.33.91.163]:41448 "EHLO
	ems.wolfvision.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaHRMqJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2014 08:46:09 -0400
From: Matthias Fend <Matthias.Fend@wolfvision.net>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: rt2x00: Ralink RT5572 (TL-WDN3200) sporadic damages
Date: Mon, 18 Aug 2014 12:37:44 +0000
Message-ID: <CC2A85E271C1FB479D9C17305347F69A04C60591@WOLFSERVER19.wolfvision-at.intra> (sfid-20140818_144613_876324_659C4ADE)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

While continuing stability tests after fixing the high current peaks while sending uninitialized beacons [1] we still have occasional cases where suddenly a stick stops working and is getting very hot.
In this case very hot means that the plastic molding of the dongle shows very clear deformations and the stick won't work properly anymore.
One can see continuous vendor request failed message in case when a stick stops working or when a damaged stick is inserted.

So far we always tested with our custom hardware. To rule out hardware topics we decided to build up a test farm with a more common platform.
For a test we setup 10 raspberry pi with this setup:
Kernel: https://github.com/raspberrypi/linux/tree/rpi-3.16.y
WLAN-Stick Firmware: V0.33
ap: hostapd 1.0
ap:config:
interface=wlan0
driver=nl80211
ieee80211n=1
wmm_enabled=1
ssid=MyPi1
channel=36
disassoc_low_ack=0
country_code=DE
ieee80211d=1
hw_mode=a
ht_capab=[HT40+][SHORT-GI-20][SHORT-GI-40]
wpa=2
wpa_passphrase=raspberry
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP CCMP

Within the first 48 hours three of the ten setups failed with the mentioned problems. Since the broken sticks had been replaced the test is now running since five days without further problems.
At least this test helped to figure out that this issue does not depend on our hardware.
Unfortunately this bug is really rare and currently I have absolutely no idea what is triggering this damages.
Has anybody observed similar behavior or has some helpful hints?

Thanks,
 ~Matthias

 [1] http://www.spinics.net/lists/linux-wireless/msg123423.html


