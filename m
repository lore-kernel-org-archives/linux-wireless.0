Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn1lp0156.outbound.protection.outlook.com ([207.46.163.156]:13912
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab3IMRLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 13:11:33 -0400
From: Albert Lo <alo@airpatrolcorp.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: problems setting the channel
Date: Fri, 13 Sep 2013 17:11:28 +0000
Message-ID: <bd4dc3b2edbb45789121bddb33960aa2@CO1PR05MB345.namprd05.prod.outlook.com> (sfid-20130913_191136_591499_66171A47)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello,

Forgive the newbie question, but I'm having a hard time setting the channel.  Here is my output:

======================================
root@OpenWrt:~# iw dev wlan0 info
Interface wlan0
    ifindex 7
    wdev 0x2
    addr 04:f0:21:01:1b:91
    type AP
    wiphy 0
    channel 11 (2462 MHz) NO HT
root@OpenWrt:~# iw reg get
country US:
    (2402 - 2472 @ 40), (3, 27)
    (5170 - 5250 @ 40), (3, 17)
    (5250 - 5330 @ 40), (3, 20), DFS
    (5490 - 5600 @ 40), (3, 20), DFS
    (5650 - 5710 @ 40), (3, 20), DFS
    (5735 - 5835 @ 40), (3, 30)
root@OpenWrt:/# iw dev wlan0 set channel 10
root@OpenWrt:/# iw dev wlan0 set channel 19                                    
command failed: Invalid argument (-22) 
==================================================


Any ideas why setting channel to 10 is ok, but setting channel to 19 fails?
I do notice that my phy is split into two parts, Band1 and Band2.  

==================================================
root@OpenWrt:~# iw phy phy0 info
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
		HT TX/RX MCS rate indexes supported: 0-15
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
	Band 2:
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
		HT TX/RX MCS rate indexes supported: 0-15
		Frequencies:
			* 5180 MHz [36] (17.0 dBm)
			* 5200 MHz [40] (17.0 dBm)
			* 5220 MHz [44] (17.0 dBm)
			* 5240 MHz [48] (17.0 dBm)
			* 5260 MHz [52] (20.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5280 MHz [56] (20.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5300 MHz [60] (20.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5320 MHz [64] (20.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5500 MHz [100] (20.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5520 MHz [104] (20.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5540 MHz [108] (20.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5560 MHz [112] (20.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5580 MHz [116] (20.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5600 MHz [120] (disabled)
			* 5620 MHz [124] (disabled)
			* 5640 MHz [128] (disabled)
			* 5660 MHz [132] (20.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5680 MHz [136] (20.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5700 MHz [140] (20.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5745 MHz [149] (30.0 dBm)
			* 5765 MHz [153] (30.0 dBm)
			* 5785 MHz [157] (30.0 dBm)
			* 5805 MHz [161] (30.0 dBm)
			* 5825 MHz [165] (30.0 dBm)
		Bitrates (non-HT):
			* 6.0 Mbps
			* 9.0 Mbps
			* 12.0 Mbps
			* 18.0 Mbps
			* 24.0 Mbps
			* 36.0 Mbps
			* 48.0 Mbps
			* 54.0 Mbps
.......



Any ideas as to how I can set wlan0 to the channels in  Band2?

Best Regards,
Albert
