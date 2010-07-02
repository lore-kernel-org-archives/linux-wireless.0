Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server.heaven-czfree.net ([78.108.102.201]:49598 "EHLO
	smtp.heaven-czfree.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab0GBRam (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 13:30:42 -0400
Received: from [10.23.202.43] (unknown [10.23.202.43])
	by smtp.heaven-czfree.net (Postfix) with ESMTP id 957D5147657
	for <linux-wireless@vger.kernel.org>; Fri,  2 Jul 2010 19:30:40 +0200 (CEST)
From: "Jaroslav Fojtik" <jafojtik@seznam.cz>
To: linux-wireless@vger.kernel.org
Date: Fri, 02 Jul 2010 19:33:15 +0200
MIME-Version: 1.0
Subject: How to enable channels 12,13?
Message-ID: <4C2E22DB.13996.20C5ABD@jafojtik.seznam.cz>
Content-type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dears,

My device ignores channels 12,13, but they are allowed in our country.
Is it possible to shut down defective regdomain policy?

The proper regdomain is already set:
[    5.809776] ath5k 0000:02:0a.0: registered as 'phy1'
[    6.276736] ath: EEPROM regdomain: 0x36
.....
[    5.152196] ath5k 0000:02:08.0: registered as 'phy0'
[    5.749710] ath: EEPROM regdomain: 0x36
.....
[    6.278376] ath5k phy1: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
[    6.278440] ath5k phy1: RF5112B multiband radio found (0x36)
[    6.278539] ath5k 0000:02:0b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.278679] ath5k 0000:02:0b.0: registered as 'phy2'
[    6.745533] ath: EEPROM regdomain: 0x36
[    6.745538] ath: EEPROM indicates we should expect a direct regpair map
[    6.745547] ath: Country alpha2 being used: CZ
[    6.745553] ath: Regpair used: 0x36
[    6.745661] cfg80211: Calling CRDA for country: CZ


Strange ???

root@dvouramenna:~# iw reg get
country 00:
        (2402 - 2472 @ 40), (6, 20)
        (2457 - 2482 @ 20), (6, 20), PASSIVE-SCAN, NO-IBSS
        (2474 - 2494 @ 20), (6, 20), NO-OFDM, PASSIVE-SCAN, NO-IBSS
        (5170 - 5250 @ 40), (6, 20), PASSIVE-SCAN, NO-IBSS
        (5735 - 5835 @ 40), (6, 20), PASSIVE-SCAN, NO-IBSS

Hmmm?? What is it:

root@dvouramenna:~# iw reg set CZ
root@dvouramenna:~# iw reg get
country 00:
        (2402 - 2472 @ 40), (6, 20)
        (2457 - 2482 @ 20), (6, 20), PASSIVE-SCAN, NO-IBSS
        (2474 - 2494 @ 20), (6, 20), NO-OFDM, PASSIVE-SCAN, NO-IBSS
        (5170 - 5250 @ 40), (6, 20), PASSIVE-SCAN, NO-IBSS
        (5735 - 5835 @ 40), (6, 20), PASSIVE-SCAN, NO-IBSS


Even attempt of rewriting regdomain shows that a device has proper 
domain in EEPROM:

root@dvouramenna:~#ath_info -g 1:0 -w 0xfdee0000 regdomain 36
......................................
new GPIO CR 00000303 DO 00000001 DI 00000007
           regdomain (0x00bf) := 0x0036
WARNING: The write function may easy brick your device or
violate state regulation on frequency usage.
Proceed on your own risk!
Shall I write the above value(s)? (y/n)  y
pair 0: skipped, value already there
restoring GPIO CR 303 -> 3


But channels are somehow blocked from unknown reason.

regards
   Jara

iw list:

Wiphy phy1
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
                Bitrates (non-HT):
                        * 1.0 Mbps
                        * 2.0 Mbps (short preamble supported)
                        * 5.5 Mbps (short preamble supported)
                        * 11.0 Mbps (short preamble supported)
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        Band 2:
                Frequencies:
                        * 5180 MHz [36] (30.0 dBm)
                        * 5200 MHz [40] (30.0 dBm) (passive scanning, no IBSS)
                        * 5220 MHz [44] (30.0 dBm) (passive scanning, no IBSS)
                        * 5240 MHz [48] (30.0 dBm) (passive scanning, no IBSS)
                        * 5260 MHz [52] (30.0 dBm) (passive scanning, no IBSS, radar 
detection)
                        * 5280 MHz [56] (30.0 dBm) (passive scanning, no IBSS, radar 
detection)
                        * 5300 MHz [60] (30.0 dBm) (passive scanning, no IBSS, radar 
detection)
                        * 5320 MHz [64] (30.0 dBm) (passive scanning, no IBSS, radar 
detection)
                        * 5500 MHz [100] (disabled)
                        * 5520 MHz [104] (disabled)
                        * 5540 MHz [108] (disabled)
                        * 5560 MHz [112] (disabled)
                        * 5580 MHz [116] (disabled)
                        * 5600 MHz [120] (disabled)
                        * 5620 MHz [124] (disabled)
                        * 5640 MHz [128] (disabled)
                        * 5660 MHz [132] (disabled)
                        * 5680 MHz [136] (disabled)
                        * 5700 MHz [140] (disabled)
                        * 5745 MHz [149] (30.0 dBm) (passive scanning, no IBSS)
                        * 5765 MHz [153] (30.0 dBm) (passive scanning, no IBSS)
                        * 5785 MHz [157] (30.0 dBm) (passive scanning, no IBSS)
                        * 5805 MHz [161] (30.0 dBm) (passive scanning, no IBSS)
                        * 5825 MHz [165] (30.0 dBm) (passive scanning, no IBSS)
                Bitrates (non-HT):
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        max # scan SSIDs: 4
        Supported interface modes:
                 * IBSS
                 * managed
                 * AP
                 * AP/VLAN
                 * monitor
                 * mesh point
        Supported commands:
                 * new_interface
                 * set_interface
                 * new_key
                 * new_beacon
                 * new_station
                 * new_mpath
                 * set_mesh_params
                 * set_bss
                 * authenticate
                 * associate
                 * deauthenticate
                 * disassociate
                 * join_ibss
                 * Unknown command (55)
                 * Unknown command (57)
                 * Unknown command (59)
                 * set_wiphy_netns
                 * Unknown command (65)
                 * connect
                 * disconnect
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
                Bitrates (non-HT):
                        * 1.0 Mbps
                        * 2.0 Mbps (short preamble supported)
                        * 5.5 Mbps (short preamble supported)
                        * 11.0 Mbps (short preamble supported)
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        max # scan SSIDs: 4
        Supported interface modes:
                 * IBSS
                 * managed
                 * AP
                 * AP/VLAN
                 * monitor
                 * mesh point
        Supported commands:
                 * new_interface
                 * set_interface
                 * new_key
                 * new_beacon
                 * new_station
                 * new_mpath
                 * set_mesh_params
                 * set_bss
                 * authenticate
                 * associate
                 * deauthenticate
                 * disassociate
                 * join_ibss
                 * Unknown command (55)
                 * Unknown command (57)
                 * Unknown command (59)
                 * set_wiphy_netns
                 * Unknown command (65)
                 * connect
                 * disconnect
root@dvouramenna:~#

