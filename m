Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out06.msg.oleane.net ([62.161.7.4]:49499 "EHLO
	smtp-out06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3C0M44 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 08:56:56 -0400
Received: from smtp27.msg.oleane.net (smtp27.mail.priv [172.17.20.149])
	by smtp-out06.msg.oleane.net with ESMTP id r2R9gKWO025091
	for <linux-wireless@vger.kernel.org>; Wed, 27 Mar 2013 10:42:20 +0100
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp27.msg.oleane.net (MTA) with ESMTP id r2R9Ljri026757
	for <linux-wireless@vger.kernel.org>; Wed, 27 Mar 2013 10:21:46 +0100
Subject: The "Country" element is wrong in beacons
Date: Wed, 27 Mar 2013 10:21:45 +0100
Message-ID: <773DB8A82AB6A046AE0195C68612A3190152C35B@sbs2003.acksys.local> (sfid-20130327_135701_190454_5F8AC09D)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
From: "Jean-Pierre TOSONI" <jp.tosoni@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Cc: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

It seems to me that the Country element (7) sent in beacons (AP mode)
contains wrong information.
Following 802.11 section 8.4.2.10 it should contain the regulatory info,
but instead it contains the radio card capabilities.
I am not sure which part of the software builds this element.

I am using mac80211 / compat-wireless-2012-09-07 + atheros 9160 / UNEX
DNMA-83 + hostapd v2.0-devel.
The computer is a mpc8314 / linux 3.3 (openwrt)

The "iw reg get" command returns:
    country FR:
            (2402 - 2482 @ 40), (N/A, 20)
            (5170 - 5250 @ 40), (N/A, 20)
            (5250 - 5330 @ 40), (N/A, 20), DFS
            (5490 - 5710 @ 40), (N/A, 27), DFS

The beacons I see with Wireshark are:
    Frame 20: 196 bytes on wire (1568 bits), 196 bytes captured (1568
bits) on interface 0
    PPI version 0, 32 bytes
    IEEE 802.11 Beacon frame, Flags: ........C
    IEEE 802.11 wireless LAN management frame
        Fixed parameters (12 bytes)
        Tagged parameters (124 bytes)
            Tag: SSID parameter set: TESTSSID
            Tag: Supported Rates 54(B), [Mbit/sec]
            Tag: DS Parameter set: Current Channel: 52
            Tag: Traffic Indication Map (TIM): DTIM 0 of 0 bitmap
            Tag: Country Information: Country Code FR, Environment Any
                Tag Number: Country Information (7)
                Tag length: 22
                Code: FR
                Environment: Any (0x20)
                Country Info: First Channel Number: 36, Number of
Channels: 1, Maximum Transmit Power Level: 16 dBm
                Country Info: First Channel Number: 40, Number of
Channels: 7, Maximum Transmit Power Level: 20 dBm
                Country Info: First Channel Number: 100, Number of
Channels: 1, Maximum Transmit Power Level: 19 dBm
                Country Info: First Channel Number: 104, Number of
Channels: 4, Maximum Transmit Power Level: 23 dBm
                Country Info: First Channel Number: 120, Number of
Channels: 5, Maximum Transmit Power Level: 21 dBm
                Country Info: First Channel Number: 140, Number of
Channels: 1, Maximum Transmit Power Level: 19 dBm
                Padding: 00
            Tag: HT Capabilities (802.11n D1.10)
            Tag: HT Information (802.11n D1.10)
            Tag: Vendor Specific: Microsof: WMM/WME: Parameter Element

The "iw phy0 info |grep MHz" returns:
                        * 2412 MHz [1] (20.0 dBm)
                        * 2417 MHz [2] (20.0 dBm)
                        * 2422 MHz [3] (20.0 dBm)
                        * 2427 MHz [4] (20.0 dBm)
                        * 2432 MHz [5] (20.0 dBm)
                        * 2437 MHz [6] (20.0 dBm)
                        * 2442 MHz [7] (20.0 dBm)
                        * 2447 MHz [8] (20.0 dBm)
                        * 2452 MHz [9] (20.0 dBm)
                        * 2457 MHz [10] (20.0 dBm)
                        * 2462 MHz [11] (20.0 dBm)
                        * 2467 MHz [12] (20.0 dBm)
                        * 2472 MHz [13] (20.0 dBm)
                        * 2484 MHz [14] (disabled)
                        * 5180 MHz [36] (16.0 dBm)
                        * 5200 MHz [40] (20.0 dBm)
                        * 5220 MHz [44] (20.0 dBm)
                        * 5240 MHz [48] (20.0 dBm)
                        * 5260 MHz [52] (20.0 dBm)
                        * 5280 MHz [56] (20.0 dBm)
                        * 5300 MHz [60] (20.0 dBm)
                        * 5320 MHz [64] (20.0 dBm)
                        * 5500 MHz [100] (19.0 dBm)
                        * 5520 MHz [104] (23.0 dBm)
                        * 5540 MHz [108] (23.0 dBm)
                        * 5560 MHz [112] (23.0 dBm)
                        * 5580 MHz [116] (23.0 dBm)
                        * 5600 MHz [120] (21.0 dBm)
                        * 5620 MHz [124] (21.0 dBm)
                        * 5640 MHz [128] (21.0 dBm)
                        * 5660 MHz [132] (21.0 dBm)
                        * 5680 MHz [136] (21.0 dBm)
                        * 5700 MHz [140] (19.0 dBm)
                        * 5745 MHz [149] (disabled)
                        * 5765 MHz [153] (disabled)
                        * 5785 MHz [157] (disabled)
                        * 5805 MHz [161] (disabled)
                        * 5825 MHz [165] (disabled)
                 * short GI for 40 MHz

Jean-Pierre TOSONI | R&D dept.


