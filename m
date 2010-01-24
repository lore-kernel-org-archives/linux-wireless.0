Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.getmail.no ([84.208.15.66]:52793 "EHLO
	get-mta-out02.get.basefarm.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752831Ab0AXWMS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 17:12:18 -0500
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Received: from smtp.getmail.no ([10.5.16.4]) by get-mta-out02.get.basefarm.net
 (Sun Java(tm) System Messaging Server 7.0-0.04 64bit (built Jun 20 2008))
 with ESMTP id <0KWR007NHS8DH150@get-mta-out02.get.basefarm.net> for
 linux-wireless@vger.kernel.org; Sun, 24 Jan 2010 22:12:13 +0100 (MET)
Received: from [192.168.1.10] ([84.208.235.192])
 by get-mta-in01.get.basefarm.net
 (Sun Java(tm) System Messaging Server 7.0-0.04 64bit (built Jun 20 2008))
 with ESMTPA id <0KWR00HN9S8BA800@get-mta-in01.get.basefarm.net> for
 linux-wireless@vger.kernel.org; Sun, 24 Jan 2010 22:12:13 +0100 (MET)
Message-id: <4B5CB7AB.7010105@bzz.no>
Date: Sun, 24 Jan 2010 22:12:11 +0100
From: "John S. Skogtvedt" <jss@bzz.no>
To: linux-wireless@vger.kernel.org
Subject: Bug: 2.6.32 ath5k, unable to connect to AP on channel 13
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

As the subject says, using ath5k on 2.6.32 I am not able to connect to
an AP on channel 13 (i.e. wpa_supplicant doesn't find the AP and thus
fails to associate). I'm in Norway, and the card is bought in Norway.

With 2.6.26 and 2.6.30, I am able to connect to the AP if I use the
cfg80211 ieee80211_regdom=EU option (necessary at least on 2.6.26).
For 2.6.32, I've tried without the option as well as ieee80211_regdom=NO.

I'm running Debian Squeeze, and the kernel version is
linux-image-2.6-686=2.6.32+23. The changelog for the kernel package is
available at:
http://packages.debian.org/changelogs/pool/main/l/linux-2.6/linux-2.6_2.6.32-5/changelog

As the AP doesn't appear when doing a scan, I didn't capture the
wpa_supplicant output.

dmesg output:
[    7.205952] cfg80211: Using static regulatory domain info
[    7.205956] cfg80211: Regulatory domain: US
[    7.206243] cfg80211: Calling CRDA for country: US
[    7.305635] ath5k 0000:01:0a.0: PCI INT A -> Link[APC1] -> GSI 16
(level, high) -> IRQ 16
[    7.305709] ath5k 0000:01:0a.0: registered as 'phy0'
[    7.887265] ath: EEPROM regdomain: 0x80d0
[    7.887267] ath: EEPROM indicates we should expect a country code
[    7.887270] ath: doing EEPROM country->regdmn map search
[    7.887272] ath: country maps to regdmn code: 0x37
[    7.887275] ath: Country alpha2 being used: DK
[    7.887277] ath: Regpair used: 0x37
[    8.288352] ath5k phy0: Atheros AR2414 chip found (MAC: 0x79, PHY: 0x45)
[    8.288607] cfg80211: Calling CRDA for country: DK

lspci:
01:0a.0 Ethernet controller: Atheros Communications Inc. Atheros
AR5001X+ Wireless Network Adapter (rev 01)
        Subsystem: D-Link System Inc D-Link AirPlus DWL-G520 Wireless
PCI Adapter(rev.B)
        Kernel driver in use: ath5k

iw list output:
Wiphy phy0
        Band 1:
                Frequencies:
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
                        * 2467 MHz [12] (disabled)
                        * 2472 MHz [13] (disabled)
                        * 2484 MHz [14] (disabled)
...


iw reg get output:
country US:
        (2402 - 2472 @ 40), (6, 27)
        (5170 - 5190 @ 40), (6, 23)
        (5190 - 5210 @ 40), (6, 23)
        (5210 - 5230 @ 40), (6, 23)
        (5230 - 5330 @ 40), (6, 23)
        (5735 - 5835 @ 40), (6, 30)

I tried "iw reg set NO" without effect.

Please let me know if you need any more information. (Also, please CC me
on replies as I'm not on the list.)

Thank you,

John.
