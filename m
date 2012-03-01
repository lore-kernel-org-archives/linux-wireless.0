Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:56621 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab2CALf0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 06:35:26 -0500
Message-ID: <4F4F5EFB.3020400@mlbassoc.com> (sfid-20120301_123530_177787_72DC0AF7)
Date: Thu, 01 Mar 2012 04:35:23 -0700
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Linux Wireless <linux-wireless@vger.kernel.org>
CC: Luciano Coelho <coelho@ti.com>
Subject: Re: Problems with wl1271
References: <4F4E903B.2030501@mlbassoc.com>
In-Reply-To: <4F4E903B.2030501@mlbassoc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-02-29 13:53, Gary Thomas wrote:
> I'm trying to bring up a new hardware platform which includes
> the TiWi-r02 (wl1271). Since the kernel for my target device
> (AM3874) is stuck in the dark ages, Luciano suggested that I
> try compat-wireless + iw. I've managed to build these now
> (after encountering many problems that I'll help iron out later)
> and now have the system ready to start using the device. Note:
> I'm using compat-wireless-2012-02-28 and iw-3.2
>
> The kernel modules load and initialize now, with these messages:
>
> cfg80211: Updating information on frequency 5200 MHz for a 20 MHz width channel with regulatory rule:
> cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
> cfg80211: Updating information on frequency 5210 MHz for a 20 MHz width channel with regulatory rule:
> cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
> cfg80211: Updating information on frequency 5220 MHz for a 20 MHz width channel with regulatory rule:
> cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
> cfg80211: Updating information on frequency 5230 MHz for a 20 MHz width channel with regulatory rule:
> cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
> cfg80211: Updating information on frequency 5240 MHz for a 20 MHz width channel with regulatory rule:
> cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
> cfg80211: Disabling freq 5260 MHz
> cfg80211: Disabling freq 5280 MHz
> cfg80211: Disabling freq 5300 MHz
> cfg80211: Disabling freq 5320 MHz
> cfg80211: Disabling freq 5500 MHz
> cfg80211: Disabling freq 5520 MHz
> cfg80211: Disabling freq 5540 MHz
> cfg80211: Disabling freq 5560 MHz
> cfg80211: Disabling freq 5580 MHz
> cfg80211: Disabling freq 5600 MHz
> cfg80211: Disabling freq 5620 MHz
> cfg80211: Disabling freq 5640 MHz
> cfg80211: Disabling freq 5660 MHz
> cfg80211: Disabling freq 5680 MHz
> cfg80211: Disabling freq 5700 MHz
> cfg80211: Updating information on frequency 5745 MHz for a 20 MHz width channel with regulatory rule:
> cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
> cfg80211: Updating information on frequency 5765 MHz for a 20 MHz width channel with regulatory rule:
> cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
> cfg80211: Updating information on frequency 5785 MHz for a 20 MHz width channel with regulatory rule:
> cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
> cfg80211: Updating information on frequency 5805 MHz for a 20 MHz width channel with regulatory rule:
> cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
> cfg80211: Updating information on frequency 5825 MHz for a 20 MHz width channel with regulatory rule:
> cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
>
> wl12xx: loaded
>
> When I try to bring up the device, I get this:
> # ifconfig wlan0 hw ether 2a:00:24:01:02:03
> # ifconfig wlan0 up
> wl12xx: firmware booted (Rev 6.3.5.0.98)
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
>
> If I try to scan for an access point, I get nothing:
> # iw wlan0 scan
> --- Nothing prints
> #
> I also see no additional messages in dmesg.
>
> Further checking of the device:
> # iw wlan0 list
> Wiphy phy0
> Band 1:
> Capabilities: 0x130
> HT20
> Static SM Power Save
> RX Greenfield
> RX HT20 SGI
> RX STBC 1-stream
> Max AMSDU length: 3839 bytes
> No DSSS/CCK HT40
> Maximum RX AMPDU length 8191 bytes (exponent: 0x000)
> Minimum RX AMPDU time spacing: 8 usec (0x06)
> HT TX/RX MCS rate indexes supported: 0-7
> Frequencies:
> * 2412 MHz [1] (20.0 dBm)
> * 2417 MHz [2] (20.0 dBm)
> * 2422 MHz [3] (20.0 dBm)
> * 2427 MHz [4] (20.0 dBm)
> * 2432 MHz [5] (20.0 dBm)
> * 2437 MHz [6] (20.0 dBm)
> * 2442 MHz [7] (20.0 dBm)
> * 2447 MHz [8] (20.0 dBm)
> * 2452 MHz [9] (20.0 dBm)
> * 2457 MHz [10] (20.0 dBm)
> * 2462 MHz [11] (20.0 dBm)
> * 2467 MHz [12] (20.0 dBm) (passive scanning, no IBSS)
> * 2472 MHz [13] (20.0 dBm) (passive scanning, no IBSS)
> * 2484 MHz [14] (20.0 dBm) (passive scanning, no IBSS)
> Bitrates (non-HT):
> * 1.0 Mbps
> * 2.0 Mbps (short preamble supported)
> * 5.5 Mbps (short preamble supported)
> * 11.0 Mbps (short preamble supported)
> * 6.0 Mbps
> * 9.0 Mbps
> * 12.0 Mbps
> * 18.0 Mbps
> * 24.0 Mbps
> * 36.0 Mbps
> * 48.0 Mbps
> * 54.0 Mbps
> Band 2:
> Capabilities: 0x130
> HT20
> Static SM Power Save
> RX Greenfield
> RX HT20 SGI
> RX STBC 1-stream
> Max AMSDU length: 3839 bytes
> No DSSS/CCK HT40
> Maximum RX AMPDU length 8191 bytes (exponent: 0x000)
> Minimum RX AMPDU time spacing: 8 usec (0x06)
> HT TX/RX MCS rate indexes supported: 0-7
> Frequencies:
> * 5035 MHz [7] (disabled)
> * 5040 MHz [8] (disabled)
> * 5045 MHz [9] (disabled)
> * 5055 MHz [11] (disabled)
> * 5060 MHz [12] (disabled)
> * 5080 MHz [16] (disabled)
> * 5170 MHz [34] (disabled)
> * 5180 MHz [36] (20.0 dBm) (passive scanning, no IBSS)
> * 5190 MHz [38] (20.0 dBm) (passive scanning, no IBSS)
> * 5200 MHz [40] (20.0 dBm) (passive scanning, no IBSS)
> * 5210 MHz [42] (20.0 dBm) (passive scanning, no IBSS)
> * 5220 MHz [44] (20.0 dBm) (passive scanning, no IBSS)
> * 5230 MHz [46] (20.0 dBm) (passive scanning, no IBSS)
> * 5240 MHz [48] (20.0 dBm) (passive scanning, no IBSS)
> * 5260 MHz [52] (disabled)
> * 5280 MHz [56] (disabled)
> * 5300 MHz [60] (disabled)
> * 5320 MHz [64] (disabled)
> * 5500 MHz [100] (disabled)
> * 5520 MHz [104] (disabled)
> * 5540 MHz [108] (disabled)
> * 5560 MHz [112] (disabled)
> * 5580 MHz [116] (disabled)
> * 5600 MHz [120] (disabled)
> * 5620 MHz [124] (disabled)
> * 5640 MHz [128] (disabled)
> * 5660 MHz [132] (disabled)
> * 5680 MHz [136] (disabled)
> * 5700 MHz [140] (disabled)
> * 5745 MHz [149] (20.0 dBm) (passive scanning, no IBSS)
> * 5765 MHz [153] (20.0 dBm) (passive scanning, no IBSS)
> * 5785 MHz [157] (20.0 dBm) (passive scanning, no IBSS)
> * 5805 MHz [161] (20.0 dBm) (passive scanning, no IBSS)
> * 5825 MHz [165] (20.0 dBm) (passive scanning, no IBSS)
> Bitrates (non-HT):
> * 6.0 Mbps
> * 9.0 Mbps
> * 12.0 Mbps
> * 18.0 Mbps
> * 24.0 Mbps
> * 36.0 Mbps
> * 48.0 Mbps
> * 54.0 Mbps
> max # scan SSIDs: 1
> max scan IEs length: 441 bytes
> Coverage class: 0 (up to 0m)
> Supported Ciphers:
> * WEP40 (00-0f-ac:1)
> * WEP104 (00-0f-ac:5)
> * TKIP (00-0f-ac:2)
> * CCMP (00-0f-ac:4)
> * WPI-SMS4 (00-14-72:1)
> Available Antennas: TX 0 RX 0
> Supported interface modes:
> * IBSS
> * managed
> * AP
> * AP/VLAN
> * monitor
> * P2P-client
> * P2P-GO
> software interface modes (can always be added):
> * AP/VLAN
> * monitor
> interface combinations are not supported
> Supported commands:
> * new_interface
> * set_interface
> * new_key
> * new_beacon
> * new_station
> * new_mpath
> * set_mesh_params
> * set_bss
> * authenticate
> * associate
> * deauthenticate
> * disassociate
> * join_ibss
> * join_mesh
> * remain_on_channel
> * set_tx_bitrate_mask
> * action
> * frame_wait_cancel
> * set_wiphy_netns
> * set_channel
> * set_wds_peer
> * Unknown command (75)
> * Unknown command (84)
> * Unknown command (87)
> * Unknown command (85)
> * testmode
> * connect
> * disconnect
> Supported TX frame types:
> * IBSS: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
> * managed: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
> * AP: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
> * AP/VLAN: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
> * mesh point: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
> * P2P-client: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
> * P2P-GO: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
> Supported RX frame types:
> * IBSS: 0x00d0
> * managed: 0x0040 0x00d0
> * AP: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
> * AP/VLAN: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
> * mesh point: 0x00b0 0x00c0 0x00d0
> * P2P-client: 0x0040 0x00d0
> * P2P-GO: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
> WoWLAN support:
> * wake up on anything (device continues operating normally)
> Device supports AP-side u-APSD.
>
> I don't know enough about this device to understand why it's not working.
> Perhaps the line
> Available Antennas: TX 0 RX 0
> is a clue?
>
> Any ideas what's not working & how I need to do to move forward?
>
> Thanks in advance for all the help
>

Any ideas at all?  Is there some debug info I can get to find
out what's going on?

Note: I compared the output of 'iw list' from my non-functional system
to that of a working one (OMAP4430 PandaBoard) and they are virtually
identical, even the line about the antenna...

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
