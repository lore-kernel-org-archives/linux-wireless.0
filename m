Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62742 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab1GQSkS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 14:40:18 -0400
Received: by gwaa18 with SMTP id a18so1060694gwa.19
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jul 2011 11:40:18 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 17 Jul 2011 12:40:18 -0600
Message-ID: <CAA9gSzHuvjUHk6DN=0HaoopAUdnaewjhemLAXqkyt6w4pfgnDA@mail.gmail.com> (sfid-20110717_204025_373769_797A62C0)
Subject: Help with Atheros AR9285 Rev:2 Fails to initialize radio UBNT AirRouter
From: Kelly Hogan <kshogan@bluemesh.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello All,

We're compiling latest openwrt trunk, and attempting to get it to run
on the UBNT AirRouter.  This is an AR9285 chipset, and all looks good
until we try to initialize the radio device and get:

ath: Unable to reset hardware; reset status -5 (freq 2412 MHz)

dmesg shows that

root@OpenWrt:/etc/config# dmesg | grep ath
ath: EEPROM regdomain: 0x0
ath: EEPROM indicates default country code should be used
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x3a
ath: Country alpha2 being used: US
ath: Regpair used: 0x3a
Registered led device: ath9k-phy0

and iw list (below) shows the device, but any attempts to bring it or
vifs up fail.   It seems that the problem is in the
calibration/initialization process, but any network attempts give the:

ath: Unable to reset hardware; reset status -5 (freq 2412 MHz)

Were new to this, but will dive in if a few pointers of where to look
would give us some initial direction.

Thanks!


root@OpenWrt:/etc/config# iw list
Wiphy phy0
        Band 1:
                Capabilities: 0x11ce
                        HT20/HT40
                        SM Power Save disabled
                        RX HT40 SGI
                        TX STBC
                        RX STBC 1-stream
                        Max AMSDU length: 3839 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                TX unequal modulation not supported
                HT TX Max spatial streams: 1
                HT TX MCS rate indexes supported may differ
                Frequencies:
                        * 2412 MHz [1] (27.0 dBm)
                        * 2417 MHz [2] (27.0 dBm)
                        * 2422 MHz [3] (27.0 dBm)
                        * 2427 MHz [4] (27.0 dBm)
                        * 2432 MHz [5] (27.0 dBm)
                        * 2437 MHz [6] (27.0 dBm)
                        * 2442 MHz [7] (27.0 dBm)
                        * 2447 MHz [8] (27.0 dBm)
                        * 2452 MHz [9] (27.0 dBm)
                        * 2457 MHz [10] (27.0 dBm)
                        * 2462 MHz [11] (27.0 dBm)
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
        max scan IEs length: 2257 bytes
        Coverage class: 0 (up to 0m)
        Available Antennas: TX 0 RX 0
        Supported interface modes:
                 * IBSS
                 * managed
                 * AP
                 * AP/VLAN
                 * WDS
                 * monitor
                 * mesh point
                 * P2P-client
                 * P2P-GO
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
                 * join_mesh
                 * remain_on_channel
                 * set_tx_bitrate_mask
                 * action
                 * frame_wait_cancel
                 * set_wiphy_netns
                 * set_channel
                 * set_wds_peer
                 * connect
                 * disconnect
        Supported TX frame types:
                 * IBSS: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050
0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
                 * managed: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050
0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
                 * AP: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050
0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
                 * AP/VLAN: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050
0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
                 * mesh point: 0x0000 0x0010 0x0020 0x0030 0x0040
0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0
0x00f0
                 * P2P-client: 0x0000 0x0010 0x0020 0x0030 0x0040
0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0
0x00f0
                 * P2P-GO: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050
0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
        Supported RX frame types:
                 * IBSS: 0x00d0
                 * managed: 0x0040 0x00d0
                 * AP: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
                 * AP/VLAN: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
                 * mesh point: 0x00b0 0x00c0 0x00d0
                 * P2P-client: 0x0040 0x00d0
                 * P2P-GO: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
