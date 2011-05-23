Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62367 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab1EWL2b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 07:28:31 -0400
Received: by wya21 with SMTP id 21so4114812wya.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 04:28:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DD6E9B5.3020905@candelatech.com>
References: <4DD6E9B5.3020905@candelatech.com>
Date: Mon, 23 May 2011 16:58:30 +0530
Message-ID: <BANLkTindTMFNNpyNpNndhhGv7qWB5_haGQ@mail.gmail.com> (sfid-20110523_132841_798901_5C7D6825)
Subject: Re: ath9k 9380: All 5Ghz channels flagged as passive-scanning
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 21, 2011 at 3:52 AM, Ben Greear <greearb@candelatech.com> wrote:
> This is on 2.6.39-wl+
>
> All the 5Ghz channels are showing as passive scanning, which
> makes them unusable for APs if nothing else.

for me channels 36,40,44,48 are ok in 5ghz. used the latest
wireless-testing just brought the card up as station mode.


>
> Any idea why this is happening?

don't know, may be regulatory.

>
> On a previous boot, I had an STA associated on channel
> 40 and that was the single 5Ghz channel that didn't
> show 'passive scanning'.  I removed it's configuration
> so that it wouldn't associate and upon reboot I see
> the output below.
>
> More than happy to provide more details...
>
> [root@lec-ath9k-9380 ~]# iw phy wiphy0 info
> Wiphy wiphy0
>        Band 1:
>                Capabilities: 0x11ef
>                        RX LDPC
>                        HT20/HT40
>                        SM Power Save disabled
>                        RX HT20 SGI
>                        RX HT40 SGI
>                        TX STBC
>                        RX STBC 1-stream
>                        Max AMSDU length: 3839 bytes
>                        DSSS/CCK HT40
>                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
>                Minimum RX AMPDU time spacing: 8 usec (0x06)
>                HT TX/RX MCS rate indexes supported: 0-23
>                Frequencies:
>                        * 2412 MHz [1] (17.0 dBm)
>                        * 2417 MHz [2] (17.0 dBm)
>                        * 2422 MHz [3] (17.0 dBm)
>                        * 2427 MHz [4] (17.0 dBm)
>                        * 2432 MHz [5] (17.0 dBm)
>                        * 2437 MHz [6] (17.0 dBm)
>                        * 2442 MHz [7] (17.0 dBm)
>                        * 2447 MHz [8] (17.0 dBm)
>                        * 2452 MHz [9] (17.0 dBm)
>                        * 2457 MHz [10] (17.0 dBm)
>                        * 2462 MHz [11] (17.0 dBm)
>                        * 2467 MHz [12] (17.0 dBm) (passive scanning)
>                        * 2472 MHz [13] (17.0 dBm) (passive scanning)
>                        * 2484 MHz [14] (disabled)
>                Bitrates (non-HT):
>                        * 1.0 Mbps
>                        * 2.0 Mbps (short preamble supported)
>                        * 5.5 Mbps (short preamble supported)
>                        * 11.0 Mbps (short preamble supported)
>                        * 6.0 Mbps
>                        * 9.0 Mbps
>                        * 12.0 Mbps
>                        * 18.0 Mbps
>                        * 24.0 Mbps
>                        * 36.0 Mbps
>                        * 48.0 Mbps
>                        * 54.0 Mbps
>        Band 2:
>                Capabilities: 0x11ef
>                        RX LDPC
>                        HT20/HT40
>                        SM Power Save disabled
>                        RX HT20 SGI
>                        RX HT40 SGI
>                        TX STBC
>                        RX STBC 1-stream
>                        Max AMSDU length: 3839 bytes
>                        DSSS/CCK HT40
>                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
>                Minimum RX AMPDU time spacing: 8 usec (0x06)
>                HT TX/RX MCS rate indexes supported: 0-23
>                Frequencies:
>                        * 5180 MHz [36] (18.0 dBm) (passive scanning, no
> IBSS)
>                        * 5200 MHz [40] (18.0 dBm) (passive scanning, no
> IBSS)
>                        * 5220 MHz [44] (18.0 dBm) (passive scanning, no
> IBSS)
>                        * 5240 MHz [48] (18.0 dBm) (passive scanning, no
> IBSS)
>                        * 5260 MHz [52] (18.0 dBm) (passive scanning, no
> IBSS, radar detection)
>                        * 5280 MHz [56] (18.0 dBm) (passive scanning, no
> IBSS, radar detection)
>                        * 5300 MHz [60] (18.0 dBm) (passive scanning, no
> IBSS, radar detection)
>                        * 5320 MHz [64] (18.0 dBm) (passive scanning, no
> IBSS, radar detection)
>                        * 5500 MHz [100] (18.0 dBm) (passive scanning, no
> IBSS, radar detection)
>                        * 5520 MHz [104] (18.0 dBm) (passive scanning, no
> IBSS, radar detection)
>                        * 5540 MHz [108] (18.0 dBm) (passive scanning, no
> IBSS, radar detection)
>                        * 5560 MHz [112] (18.0 dBm) (passive scanning, no
> IBSS, radar detection)
>                        * 5580 MHz [116] (18.0 dBm) (passive scanning, no
> IBSS, radar detection)
>                        * 5600 MHz [120] (18.0 dBm) (passive scanning, no
> IBSS, radar detection)
>                        * 5620 MHz [124] (18.0 dBm) (passive scanning, no
> IBSS, radar detection)
>                        * 5640 MHz [128] (18.0 dBm) (passive scanning, no
> IBSS, radar detection)
>                        * 5660 MHz [132] (18.0 dBm) (passive scanning, no
> IBSS, radar detection)
>                        * 5680 MHz [136] (18.0 dBm) (passive scanning, no
> IBSS, radar detection)
>                        * 5700 MHz [140] (18.0 dBm) (passive scanning, no
> IBSS, radar detection)
>                        * 5745 MHz [149] (18.0 dBm) (passive scanning, no
> IBSS)
>                        * 5765 MHz [153] (18.0 dBm) (passive scanning, no
> IBSS)
>                        * 5785 MHz [157] (18.0 dBm) (passive scanning, no
> IBSS)
>                        * 5805 MHz [161] (18.0 dBm) (passive scanning, no
> IBSS)
>                        * 5825 MHz [165] (18.0 dBm) (passive scanning, no
> IBSS)
>                Bitrates (non-HT):
>                        * 6.0 Mbps
>                        * 9.0 Mbps
>                        * 12.0 Mbps
>                        * 18.0 Mbps
>                        * 24.0 Mbps
>                        * 36.0 Mbps
>                        * 48.0 Mbps
>                        * 54.0 Mbps
>        max # scan SSIDs: 4
>        max scan IEs length: 2257 bytes
>        Coverage class: 0 (up to 0m)
>        Available Antennas: TX 0 RX 0
>        Supported interface modes:
>                 * IBSS
>                 * managed
>                 * AP
>                 * AP/VLAN
>                 * WDS
>                 * monitor
>                 * mesh point
>                 * P2P-client
>                 * P2P-GO
>        Supported commands:
>                 * new_interface
>                 * set_interface
>                 * new_key
>                 * new_beacon
>                 * new_station
>                 * new_mpath
>                 * set_mesh_params
>                 * set_bss
>                 * authenticate
>                 * associate
>                 * deauthenticate
>                 * disassociate
>                 * join_ibss
>                 * join_mesh
>                 * remain_on_channel
>                 * set_tx_bitrate_mask
>                 * action
>                 * frame_wait_cancel
>                 * set_wiphy_netns
>                 * set_channel
>                 * set_wds_peer
>                 * connect
>                 * disconnect
>        Supported TX frame types:
>                 * IBSS: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060
> 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
>                 * managed: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060
> 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
>                 * AP: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060
> 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
>                 * AP/VLAN: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060
> 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
>                 * mesh point: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050
> 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
>                 * P2P-client: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050
> 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
>                 * P2P-GO: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060
> 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
>        Supported RX frame types:
>                 * IBSS: 0x00d0
>                 * managed: 0x0040 0x00d0
>                 * AP: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
>                 * AP/VLAN: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
>                 * mesh point: 0x00b0 0x00c0 0x00d0
>                 * P2P-client: 0x0040 0x00d0
>                 * P2P-GO: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi
