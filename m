Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36115 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121Ab1IGQSE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 12:18:04 -0400
Received: by gxk21 with SMTP id 21so5731172gxk.5
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2011 09:18:03 -0700 (PDT)
Message-ID: <4E67801F.6050408@lwfinger.net> (sfid-20110907_181810_630651_EC8ABA3A)
Date: Wed, 07 Sep 2011 09:30:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stefan Zwanenburg <stefanhetzwaantje@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTL8192SE and 802.11n problem
References: <4E6772B6.603@gmail.com>
In-Reply-To: <4E6772B6.603@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/07/2011 08:33 AM, Stefan Zwanenburg wrote:
> Dear Larry,
>
> First of all, I hope you don't mind me contacting you over this matter. I have a
> problem with my RTL8192SE NIC, for which I've sought help at linux-wireless
> prior to mailing you (to no avail). If you do mind, please pretend this message
> was never sent. If you, in fact, do not mind, keep on reading.
>
> I have noticed that I get rather disappointing speeds when using my wireless
> NIC. So I decided to investigate the matter. What I found out is that I simply
> cannot connect to an AP (or my AP, for I haven't had the opportunity to test it
> with another) using 802.11n. In fact, when my AP is set to 802.11n only, my NIC
> flat out refuses to connect whatsoever. When the AP is set to do both 11g and
> 11n, I get to connect (over 11g), thus resulting in a maximum bitrate of 54Mbps,
> which is not what I expected.
>
> I hope my description of the problem is coherent thus far. When asking for help
> on the linux-wireless IRC channel, I was asked to pastebin some information,
> which I'm going to copy here:
>
> output of iw dev wlan0 scan (with information not pertaining to my AP removed):
>
>     BSS 00:1e:c1:a2:01:5a (on wlan0) -- associated
>     TSF: 124096205146 usec (1d, 10:28:16)
>     freq: 2442
>     beacon interval: 100
>     capability: ESS Privacy ShortSlotTime (0x0411)
>     signal: -41.00 dBm
>     last seen: 292 ms ago
>     Information elements from Probe Response frame:
>     SSID: Perforator
>     Supported rates: 1.0* 2.0* 5.5* 11.0* 9.0 18.0 36.0 54.0
>     DS Parameter set: channel 7
>     ERP: Use_Protection Barker_Preamble_Mode
>     Extended supported rates: 6.0 12.0 24.0 48.0
>     HT capabilities:
>     Capabilities: 0x11ee
>     HT20/HT40
>     SM Power Save disabled
>     RX HT20 SGI
>     RX HT40 SGI
>     TX STBC
>     RX STBC 1-stream
>     Max AMSDU length: 3839 bytes
>     DSSS/CCK HT40
>     Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
>     Minimum RX AMPDU time spacing: 4 usec (0x05)
>     HT RX MCS rate indexes supported: 0-15, 32
>     HT TX MCS rate indexes are undefined
>     HT operation:
>     * primary channel: 7
>     * secondary channel offset: below
>     * STA channel width: any
>     * RIFS: 0
>     * HT protection: non-HT mixed
>     * non-GF present: 1
>     * OBSS non-GF present: 0
>     * dual beacon: 0
>     * dual CTS protection: 0
>     * STBC beacon: 0
>     * L-SIG TXOP Prot: 0
>     * PCO active: 0
>     * PCO phase: 0
>     RSN: * Version: 1
>     * Group cipher: CCMP
>     * Pairwise ciphers: CCMP
>     * Authentication suites: PSK
>     * Capabilities: PreAuth (0x0001)
>     Extended capabilities: HT Information Exchange Supported
>     Country: NL Environment: Indoor/Outdoor
>     Channels [1 - 13] @ 16 dBm
>
> output of iw list:
>
>     Wiphy phy0
>     Band 1:
>     Capabilities: 0x1862
>     HT20/HT40
>     Static SM Power Save
>     RX HT20 SGI
>     RX HT40 SGI
>     No RX STBC
>     Max AMSDU length: 7935 bytes
>     DSSS/CCK HT40
>     Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
>     Minimum RX AMPDU time spacing: 16 usec (0x07)
>     HT TX/RX MCS rate indexes supported: 0-15, 32
>     Frequencies:
>     * 2412 MHz [1] (20.0 dBm)
>     * 2417 MHz [2] (20.0 dBm)
>     * 2422 MHz [3] (20.0 dBm)
>     * 2427 MHz [4] (20.0 dBm)
>     * 2432 MHz [5] (20.0 dBm)
>     * 2437 MHz [6] (20.0 dBm)
>     * 2442 MHz [7] (20.0 dBm)
>     * 2447 MHz [8] (20.0 dBm)
>     * 2452 MHz [9] (20.0 dBm)
>     * 2457 MHz [10] (20.0 dBm)
>     * 2462 MHz [11] (20.0 dBm)
>     * 2467 MHz [12] (20.0 dBm)
>     * 2472 MHz [13] (20.0 dBm)
>     * 2484 MHz [14] (disabled)
>     Bitrates (non-HT):
>     * 1.0 Mbps
>     * 2.0 Mbps
>     * 5.5 Mbps
>     * 11.0 Mbps
>     * 6.0 Mbps
>     * 9.0 Mbps
>     * 12.0 Mbps
>     * 18.0 Mbps
>     * 24.0 Mbps
>     * 36.0 Mbps
>     * 48.0 Mbps
>     * 54.0 Mbps
>     max # scan SSIDs: 4
>     max scan IEs length: 2257 bytes
>     RTS threshold: 2347
>     Coverage class: 0 (up to 0m)
>     Available Antennas: TX 0 RX 0
>     Supported interface modes:
>     * IBSS
>     * managed
>     * AP
>     * AP/VLAN
>     * monitor
>     Supported commands:
>     * new_interface
>     * set_interface
>     * new_key
>     * new_beacon
>     * new_station
>     * set_bss
>     * authenticate
>     * associate
>     * deauthenticate
>     * disassociate
>     * join_ibss
>     * remain_on_channel
>     * set_tx_bitrate_mask
>     * action
>     * frame_wait_cancel
>     * set_wiphy_netns
>     * set_channel
>     * set_wds_peer
>     * connect
>     * disconnect
>     Supported TX frame types:
>     * IBSS: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080
>     0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
>     * managed: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080
>     0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
>     * AP: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090
>     0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
>     * AP/VLAN: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080
>     0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
>     * mesh point: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080
>     0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
>     * P2P-client: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080
>     0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
>     * P2P-GO: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080
>     0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
>     Supported RX frame types:
>     * IBSS: 0x00d0
>     * managed: 0x0040 0x00d0
>     * AP: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
>     * AP/VLAN: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
>     * mesh point: 0x00b0 0x00c0 0x00d0
>     * P2P-client: 0x0040 0x00d0
>     * P2P-GO: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
>
> I was told that all of this is perfectly normal, and that it would be expected
> that I do in fact get a connection over 11n. Finally, here is the output of iw
> dev wlan0 link for good measure (as I'm connected to the AP in question):
>
>     Connected to 00:1e:c1:a2:01:5a (on wlan0)
>     SSID: Perforator
>     freq: 2442
>     RX: 6135006 bytes (37340 packets)
>     TX: 564340 bytes (3644 packets)
>     signal: -37 dBm
>     tx bitrate: 54.0 MBit/s
>
> In conclusion: I hope I haven't been wasting your time, and that you may know
> why it is that I cannot get a decent connection to my AP. Furthermore, it would
> awesome if you had some sort of solution to my problem, and if you do, I'd be
> delighted to hear it! If you do not yet know what the problem may be, and you
> require more information (whatever that may be), just ask and I'll make sure you
> get the relevant information.

I do mind you contacting me directly, but only because you did not Cc the 
linux-wireless ML. I only do private trouble-shooting when I have a contract. 
For that reason, I have added that ML in the reply, and quoted your complete 
message.

I am running a vanilla kernel from the wireless-testing git tree. It reports as 
3.1-rc4. You did not say what kernel you are using, but you would get the same 
wireless code from any kernel and the latest version of compat-wireless.

The second piece of info that you missed is which RTL8192SE you have - I have 3 
varieties. I am reporting the results for the RTL8191SEvA [10ec:8171]. My tests 
use netperf to measure the TX speed against a server in my network, which has a 
wired connection to my AP. The AP (Netgear WND3300) is configured with the "Up 
to 270 Mbps at 2.4 GHz" setting, i.e. 802.11n-only. For RX tests, that server is 
used as the source and the test box is the server. The results are as follows:

TCP_MAERTS TX Test:  47.33 53.94 55.19 44.24 57.74 55.44 53.74 54.63 47.87 57.82
TCP_MAERTS RX Test:  66.02 69.79 67.70 52.15 82.56 80.30 79.43 80.98 76.26 71.34
Results: TX: max 57.82, min 44.24. Mean 52.79(4.42)
          RX: max 82.56, min 52.15. Mean 72.65(8.85)

TCP_STREAM TX Test:  71.83 80.44 72.88 26.11 40.85 58.70 58.49 58.96 59.52 59.35
TCP_STREAM RX Test:  46.41 52.64 43.85 48.44 52.15 49.66 52.81 50.61 43.18 52.93
Results: TX: max 80.44, min 26.11. Mean 58.71(14.93)
          RX: max 52.93, min 43.18. Mean 49.27(3.51)

TCP_SENDFILE TX Test: 57.86 55.94 55.21 56.13 56.70 61.71 56.85 54.68 55.04 51.30
TCP_SENDFILE RX Test: 37.82 47.51 41.61 42.88 45.37 35.11 45.09 40.11 46.48 22.86
Results: TX: max 61.71, min 51.30. Mean 56.14(2.50)
          RX: max 47.51, min 22.86. Mean 40.48(6.96)

The numbers in () are the standard deviations, which are larger than they should 
be. You can clearly see that the rates exceed those of an 802.11g link, which 
would max out at ~27 Mbps. This is confirmed by the iwconfig listing.

finger@larrylap:~> iwconfig wlan0
wlan0     IEEE 802.11bgn  ESSID:"lwfdjf-n"
           Mode:Managed  Frequency:2.422 GHz  Access Point: C0:3F:0E:BE:2B:44
           Bit Rate=135 Mb/s   Tx-Power=20 dBm
           Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
           Power Management:off
           Link Quality=70/70  Signal level=-35 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0

In short, I do not duplicate your results.

Larry
