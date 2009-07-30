Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52173 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752063AbZG3Vbo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 17:31:44 -0400
Message-ID: <4A72113F.8000604@gmx.de>
Date: Thu, 30 Jul 2009 23:31:43 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath5k: monitor mode needs channel change
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I currently need an extra trigger by changing the channel after
"ifconfig up" to see any output in monitor mode from ath5k, e.g.

ifconfig wlan0 down
iwconfig wlan0 mode monitor channel 1
ifconfig wlan0 up
# no output by tcpdump -n -i wlan0  in another xterm
iwconfig wlan0 channel 2
# tcpdump output starts

The second "iwconfig" call must specify a channel different to the
first one.

The above sequence without the second "iwconfig" works fine with a
RTL8187 device.

I'm running
compat-wireless-2.6: master-2009-07-26-11-g83c091c
wireless-testing: v2.6.31-rc4-29204-g6b3a8c9
on top of a 2.6.30 kernel.

The WLAN NIC is a:

02:00.0 Ethernet controller: Atheros Communications Inc. AR242x
802.11abg Wireless PCI Express Adapter (rev 01),
PCI id: 168c:001c (rev 01)

ath5k identifies it as:

ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)

It's not a big issue, but a bit annoying sometimes.

