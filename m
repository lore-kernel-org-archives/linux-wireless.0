Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35307 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751726AbdB1KIJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Feb 2017 05:08:09 -0500
Received: by mail-wm0-f67.google.com with SMTP id u63so1513628wmu.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2017 02:08:07 -0800 (PST)
Received: from [192.168.1.31] ([130.255.112.60])
        by smtp.googlemail.com with ESMTPSA id i82sm17668288wmf.1.2017.02.28.01.59.49
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Feb 2017 01:59:50 -0800 (PST)
Subject: Fwd: ath9 wireless problem on ar9220 and ITS-G5
References: <7c5d4c06-bbdf-ac4b-d6f5-93f59cf8cdaa@gmail.com>
To: linux-wireless@vger.kernel.org
From: "Francesco Vigolo (gmail)" <francesco.vigolo@gmail.com>
Message-ID: <942f89cc-c866-5bee-fe16-700c3edd8f2a@gmail.com> (sfid-20170228_110901_119326_7DC987BA)
Date: Tue, 28 Feb 2017 10:59:48 +0100
MIME-Version: 1.0
In-Reply-To: <7c5d4c06-bbdf-ac4b-d6f5-93f59cf8cdaa@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------49AA90711365DA59C2E3180C"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------49AA90711365DA59C2E3180C
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I'm Francesco Vigolo,

we have a project with some WiFi cards using ar9220 chipset (minipci). 
We have implemented these cards into a Linux embedded system. We are 
using Openwrt linux 4.4.0 Kernel and ath9k driver (backports-20151218). 
We are implementing an ITS-G5 system. Seems that cards are not working 
correctly higher than 8595 MHz (ch 179), while 5895 and lower channels 
are working. If I set 5900 (180) or 5905 (181) or another ch like 5915 
(183) MHz the driver stop working. We have patched drivers to allow 
these channels from the perspective of regulatory and to allow this band 
(commonn-init.c, hw.h, regd.c, db.txt). Could you please indicate us a 
linux driver version working for sure with ar9220 chipset @ higher freq 
than 5895? Hardware for sure is working. In attachment a log indicating 
the problem with the driver.Let me know if you need more informations.

Here *iw reg get *and *iw list *showing that regulatory has been patched 
correctly...

##########################

root@OpenWrt:/# iw reg get
country US: DFS-UNSET
         (2402 - 2472 @ 40), (N/A, 30), (N/A)
         (5000 - 6000 @ 160), (N/A, 30), (N/A)
         (57240 - 63720 @ 2160), (N/A, 40), (N/A)


##########################################

root@OpenWrt:/# iw list
Wiphy phy1
         max # scan SSIDs: 4
         max scan IEs length: 2261 bytes
         Retry short limit: 7
         Retry long limit: 4
         Coverage class: 0 (up to 0m)
         Device supports AP-side u-APSD.
         Device supports T-DLS.
         Available Antennas: TX 0x3 RX 0x3
         Configured Antennas: TX 0x3 RX 0x3
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
                         * 5180 MHz [36] (13.0 dBm)
                         * 5200 MHz [40] (19.0 dBm)
                         * 5220 MHz [44] (19.0 dBm)
                         * 5240 MHz [48] (19.0 dBm)
                         * 5260 MHz [52] (19.0 dBm)
                         * 5280 MHz [56] (19.0 dBm)
                         * 5300 MHz [60] (19.0 dBm)
                         * 5320 MHz [64] (20.0 dBm)
                         * 5500 MHz [100] (20.0 dBm)
                         * 5520 MHz [104] (20.0 dBm)
                         * 5540 MHz [108] (20.0 dBm)
                         * 5560 MHz [112] (20.0 dBm)
                         * 5580 MHz [116] (20.0 dBm)
                         * 5600 MHz [120] (20.0 dBm)
                         * 5620 MHz [124] (20.0 dBm)
                         * 5640 MHz [128] (20.0 dBm)
                         * 5660 MHz [132] (20.0 dBm)
                         * 5680 MHz [136] (20.0 dBm)
                         * 5700 MHz [140] (20.0 dBm)
                         * 5745 MHz [149] (20.0 dBm)
                         * 5765 MHz [153] (20.0 dBm)
                         * 5785 MHz [157] (20.0 dBm)
                         * 5805 MHz [161] (20.0 dBm)
                         * 5825 MHz [165] (20.0 dBm)
                         * 5855 MHz [171] (23.0 dBm)
                         * 5860 MHz [172] (23.0 dBm)
                         * 5865 MHz [173] (23.0 dBm)
                         * 5870 MHz [174] (23.0 dBm)
                         * 5875 MHz [175] (23.0 dBm)
                         * 5880 MHz [176] (23.0 dBm)
                         * 5885 MHz [177] (23.0 dBm)
                         * 5890 MHz [178] (23.0 dBm)
                         * 5895 MHz [179] (23.0 dBm)
                         * 5900 MHz [180] (23.0 dBm)
                         * 5905 MHz [181] (23.0 dBm)
                         * 5910 MHz [182] (23.0 dBm)
                         * 5915 MHz [183] (23.0 dBm)
                         * 5920 MHz [184] (23.0 dBm)
                         * 5925 MHz [185] (23.0 dBm)
                         * 5040 MHz [8] (23.0 dBm)
                         * 5060 MHz [12] (23.0 dBm)
                         * 5080 MHz [16] (23.0 dBm)
                         * 5100 MHz [20] (23.0 dBm)
                         * 5120 MHz [24] (23.0 dBm)
                         * 5140 MHz [28] (23.0 dBm)
                         * 5160 MHz [32] (23.0 dBm)
         valid interface combinations:
                  * #{ managed, WDS } <= 2048, #{ AP, mesh point } <= 8, #{ P2P-client, P2P-GO } <= 1, #{ IBSS } <= 1,
                    total <= 2048, #channels <= 1, STA/AP BI must match
                  * #{ IBSS, AP, mesh point } <= 1,
                    total <= 1, #channels <= 1, STA/AP BI must match, radar detect widths: { 20 MHz (no HT), 20 MHz }

         HT Capability overrides:
                  * MCS: ff ff ff ff ff ff ff ff ff ff
                  * maximum A-MSDU length
                  * supported channel width
                  * short GI for 40 MHz
                  * max A-MPDU length exponent
                  * min MPDU start spacing
Wiphy phy0
         max # scan SSIDs: 4
         max scan IEs length: 2257 bytes
         Retry short limit: 7
         Retry long limit: 4
         Coverage class: 0 (up to 0m)
         Device supports AP-side u-APSD.
         Device supports T-DLS.
         Available Antennas: TX 0x3 RX 0x3
         Configured Antennas: TX 0x3 RX 0x3
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
                         * 2412 MHz [1] (20.0 dBm)
                         * 2417 MHz [2] (23.0 dBm)
                         * 2422 MHz [3] (23.0 dBm)
                         * 2427 MHz [4] (23.0 dBm)
                         * 2432 MHz [5] (23.0 dBm)
                         * 2437 MHz [6] (23.0 dBm)
                         * 2442 MHz [7] (23.0 dBm)
                         * 2447 MHz [8] (23.0 dBm)
                         * 2452 MHz [9] (23.0 dBm)
                         * 2457 MHz [10] (23.0 dBm)
                         * 2462 MHz [11] (20.0 dBm)
                         * 2467 MHz [12] (disabled)
                         * 2472 MHz [13] (disabled)
                         * 2484 MHz [14] (disabled)
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
                         * 5180 MHz [36] (16.0 dBm)
                         * 5200 MHz [40] (16.0 dBm)
                         * 5220 MHz [44] (16.0 dBm)
                         * 5240 MHz [48] (16.0 dBm)
                         * 5260 MHz [52] (16.0 dBm)
                         * 5280 MHz [56] (16.0 dBm)
                         * 5300 MHz [60] (16.0 dBm)
                         * 5320 MHz [64] (18.0 dBm)
                         * 5500 MHz [100] (14.0 dBm)
                         * 5520 MHz [104] (21.0 dBm)
                         * 5540 MHz [108] (21.0 dBm)
                         * 5560 MHz [112] (21.0 dBm)
                         * 5580 MHz [116] (21.0 dBm)
                         * 5600 MHz [120] (21.0 dBm)
                         * 5620 MHz [124] (21.0 dBm)
                         * 5640 MHz [128] (21.0 dBm)
                         * 5660 MHz [132] (21.0 dBm)
                         * 5680 MHz [136] (21.0 dBm)
                         * 5700 MHz [140] (14.0 dBm)
                         * 5745 MHz [149] (21.0 dBm)
                         * 5765 MHz [153] (21.0 dBm)
                         * 5785 MHz [157] (21.0 dBm)
                         * 5805 MHz [161] (21.0 dBm)
                         * 5825 MHz [165] (21.0 dBm)
                         * 5855 MHz [171] (21.0 dBm)
                         * 5860 MHz [172] (21.0 dBm)
                         * 5865 MHz [173] (21.0 dBm)
                         * 5870 MHz [174] (21.0 dBm)
                         * 5875 MHz [175] (21.0 dBm)
                         * 5880 MHz [176] (21.0 dBm)
                         * 5885 MHz [177] (21.0 dBm)
                         * 5890 MHz [178] (21.0 dBm)
                         * 5895 MHz [179] (21.0 dBm)
                         * 5900 MHz [180] (21.0 dBm)
                         * 5905 MHz [181] (21.0 dBm)
                         * 5910 MHz [182] (21.0 dBm)
                         * 5915 MHz [183] (21.0 dBm)
                         * 5920 MHz [184] (21.0 dBm)
                         * 5925 MHz [185] (21.0 dBm)
                         * 5040 MHz [8] (21.0 dBm)
                         * 5060 MHz [12] (21.0 dBm)
                         * 5080 MHz [16] (21.0 dBm)
                         * 5100 MHz [20] (21.0 dBm)
                         * 5120 MHz [24] (21.0 dBm)
                         * 5140 MHz [28] (21.0 dBm)
                         * 5160 MHz [32] (21.0 dBm)
         valid interface combinations:
                  * #{ managed, WDS } <= 2048, #{ AP, mesh point } <= 8, #{ P2P-client, P2P-GO } <= 1, #{ IBSS } <= 1,
                    total <= 2048, #channels <= 1, STA/AP BI must match
                  * #{ IBSS, AP, mesh point } <= 1,
                    total <= 1, #channels <= 1, STA/AP BI must match, radar detect widths: { 20 MHz (no HT), 20 MHz }

         HT Capability overrides:
                  * MCS: ff ff ff ff ff ff ff ff ff ff
                  * maximum A-MSDU length
                  * supported channel width
                  * short GI for 40 MHz
                  * max A-MPDU length exponent
                  * min MPDU start spacing


########################################

Let me know.

thank you very much




--------------49AA90711365DA59C2E3180C
Content-Type: text/plain; charset=UTF-8;
 name="log.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="log.txt"

[  893.570000] ath: phy1: PDADC: Chain 1 | PDADC  84 Value 142 | PDADC  85 Value 142 | PDADC  86 Value 142 | PDADC  87 Value 142 |
[  893.570000] ath: phy1: PDADC (1,1000): b2d8 8e8e8e8e
[  893.570000] ath: phy1: PDADC: Chain 1 | PDADC  88 Value 142 | PDADC  89 Value 142 | PDADC  90 Value 142 | PDADC  91 Value 142 |
[  893.570000] ath: phy1: PDADC (1,1000): b2dc 8e8e8e8e
[  893.570000] ath: phy1: PDADC: Chain 1 | PDADC  92 Value 142 | PDADC  93 Value 142 | PDADC  94 Value 142 | PDADC  95 Value 142 |
[  893.570000] ath: phy1: PDADC (1,1000): b2e0 8e8e8e8e
[  893.570000] ath: phy1: PDADC: Chain 1 | PDADC  96 Value 142 | PDADC  97 Value 142 | PDADC  98 Value 142 | PDADC  99 Value 142 |
[  893.570000] ath: phy1: PDADC (1,1000): b2e4 8e8e8e8e
[  893.570000] ath: phy1: PDADC: Chain 1 | PDADC 100 Value 142 | PDADC 101 Value 142 | PDADC 102 Value 142 | PDADC 103 Value 142 |
[  893.570000] ath: phy1: PDADC (1,1000): b2e8 8e8e8e8e
[  893.570000] ath: phy1: PDADC: Chain 1 | PDADC 104 Value 142 | PDADC 105 Value 142 | PDADC 106 Value 142 | PDADC 107 Value 142 |
[  893.570000] ath: phy1: PDADC (1,1000): b2ec 8e8e8e8e
[  893.570000] ath: phy1: PDADC: Chain 1 | PDADC 108 Value 142 | PDADC 109 Value 142 | PDADC 110 Value 142 | PDADC 111 Value 142 |
[  893.570000] ath: phy1: PDADC (1,1000): b2f0 8e8e8e8e
[  893.570000] ath: phy1: PDADC: Chain 1 | PDADC 112 Value 142 | PDADC 113 Value 142 | PDADC 114 Value 142 | PDADC 115 Value 142 |
[  893.570000] ath: phy1: PDADC (1,1000): b2f4 8e8e8e8e
[  893.570000] ath: phy1: PDADC: Chain 1 | PDADC 116 Value 142 | PDADC 117 Value 142 | PDADC 118 Value 142 | PDADC 119 Value 142 |
[  893.570000] ath: phy1: PDADC (1,1000): b2f8 8e8e8e8e
[  893.570000] ath: phy1: PDADC: Chain 1 | PDADC 120 Value 142 | PDADC 121 Value 142 | PDADC 122 Value 142 | PDADC 123 Value 142 |
[  893.570000] ath: phy1: PDADC (1,1000): b2fc 8e8e8e8e
[  893.570000] ath: phy1: PDADC: Chain 1 | PDADC 124 Value 142 | PDADC 125 Value 142 | PDADC 126 Value 142 | PDADC 127 Value 142 |
[  893.570000] ath: phy1: Reset TX queue: 0
[  893.570000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.570000] ath: phy1: Reset TX queue: 1
[  893.570000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.570000] ath: phy1: Reset TX queue: 2
[  893.570000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.570000] ath: phy1: Reset TX queue: 3
[  893.570000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.570000] ath: phy1: Reset TXQ, inactive queue: 4
[  893.570000] ath: phy1: Reset TXQ, inactive queue: 5
[  893.570000] ath: phy1: Reset TXQ, inactive queue: 6
[  893.570000] ath: phy1: Reset TX queue: 7
[  893.570000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.570000] ath: phy1: Reset TX queue: 8
[  893.570000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.570000] ath: phy1: Reset TX queue: 9
[  893.570000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.570000] ath: phy1: ver 128.2 opmode 2 chan 5895 Mhz
[  893.570000] ath: phy1: ah->misc_mode 0x4
[  893.580000] ath: phy1: enabling ADC Gain Calibration
[  893.580000] ath: phy1: enabling ADC DC Calibration
[  893.580000] ath: phy1: enabling IQ Calibration
[  893.580000] ath: phy1: starting ADC Gain Calibration
[  893.580000] ath: phy1: New interrupt mask 0xd0000071
[  893.580000] ath: phy1: new IMR 0x918004b0
[  893.580000] ath: phy1: macaddr: 00:80:48:75:e8:7a, bssid: 00:00:00:00:00:00, bssidmask: ff:ff:ff:ff:ff:ff
[  893.580000] ath: phy1: Enable MIB counters
[  893.580000] ath: phy1: Restore history: opmode 2 chan 5895 Mhz is_scanning=0 ofdm:3 cck:2
[  893.580000] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[  893.580000] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[  893.580000] ath: phy1: New interrupt mask 0xd0000071
[  893.580000] ath: phy1: new IMR 0x918004b0
[  893.580000] ath: phy1: enable IER
[  893.580000] ath: phy1: AR_IMR 0x918004b0 IER 0x1
[  893.580000] ath: phy1: Attach a VIF of type: 3
[  893.580000] ath: phy1: Added interface at beacon slot: 0
[  893.580000] ath: phy1: New interrupt mask 0xd0000071
[  893.580000] ath: phy1: new IMR 0x918004b0
[  893.580000] ath: phy1: ah->misc_mode 0xc
[  893.580000] ath: phy1: macaddr: 00:80:48:75:e8:7a, bssid: 00:00:00:00:00:00, bssidmask: ff:ff:ff:ff:ff:ff
[  893.580000] ath: phy1: PDADC (0,   0): a280 03020100
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC   0 Value   0 | PDADC   1 Value   1 | PDADC   2 Value   2 | PDADC   3 Value   3 |
[  893.580000] ath: phy1: PDADC (0,   0): a284 07060504
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC   4 Value   4 | PDADC   5 Value   5 | PDADC   6 Value   6 | PDADC   7 Value   7 |
[  893.580000] ath: phy1: PDADC (0,   0): a288 0c0a0908
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  12 |
[  893.580000] ath: phy1: PDADC (0,   0): a28c 11100e0d
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC  12 Value  13 | PDADC  13 Value  14 | PDADC  14 Value  16 | PDADC  15 Value  17 |
[  893.580000] ath: phy1: PDADC (0,   0): a290 16151412
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC  16 Value  18 | PDADC  17 Value  20 | PDADC  18 Value  21 | PDADC  19 Value  22 |
[  893.580000] ath: phy1: PDADC (0,   0): a294 1f1d1a18
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC  20 Value  24 | PDADC  21 Value  26 | PDADC  22 Value  29 | PDADC  23 Value  31 |
[  893.580000] ath: phy1: PDADC (0,   0): a298 2a282522
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC  24 Value  34 | PDADC  25 Value  37 | PDADC  26 Value  40 | PDADC  27 Value  42 |
[  893.580000] ath: phy1: PDADC (0,   0): a29c 3633302d
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC  28 Value  45 | PDADC  29 Value  48 | PDADC  30 Value  51 | PDADC  31 Value  54 |
[  893.580000] ath: phy1: PDADC (0,   0): a2a0 4c46413b
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC  32 Value  59 | PDADC  33 Value  65 | PDADC  34 Value  70 | PDADC  35 Value  76 |
[  893.580000] ath: phy1: PDADC (0,   0): a2a4 625d5752
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC  36 Value  82 | PDADC  37 Value  87 | PDADC  38 Value  93 | PDADC  39 Value  98 |
[  893.580000] ath: phy1: PDADC (0,   0): a2a8 7b746e68
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC  40 Value 104 | PDADC  41 Value 110 | PDADC  42 Value 116 | PDADC  43 Value 123 |
[  893.580000] ath: phy1: PDADC (0,   0): a2ac 968f8882
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC  44 Value 130 | PDADC  45 Value 136 | PDADC  46 Value 143 | PDADC  47 Value 150 |
[  893.580000] ath: phy1: PDADC (0,   0): a2b0 332f2bab
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC  48 Value 171 | PDADC  49 Value  43 | PDADC  50 Value  47 | PDADC  51 Value  51 |
[  893.580000] ath: phy1: PDADC (0,   0): a2b4 433f3b37
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC  52 Value  55 | PDADC  53 Value  59 | PDADC  54 Value  63 | PDADC  55 Value  67 |
[  893.580000] ath: phy1: PDADC (0,   0): a2b8 59534d47
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC  56 Value  71 | PDADC  57 Value  77 | PDADC  58 Value  83 | PDADC  59 Value  89 |
[  893.580000] ath: phy1: PDADC (0,   0): a2bc 726c655f
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC  60 Value  95 | PDADC  61 Value 101 | PDADC  62 Value 108 | PDADC  63 Value 114 |
[  893.580000] ath: phy1: PDADC (0,   0): a2c0 8a847e78
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC  64 Value 120 | PDADC  65 Value 126 | PDADC  66 Value 132 | PDADC  67 Value 138 |
[  893.580000] ath: phy1: PDADC (0,   0): a2c4 9c9c9690
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC  68 Value 144 | PDADC  69 Value 150 | PDADC  70 Value 156 | PDADC  71 Value 156 |
[  893.580000] ath: phy1: PDADC (0,   0): a2c8 9c9c9c9c
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC  72 Value 156 | PDADC  73 Value 156 | PDADC  74 Value 156 | PDADC  75 Value 156 |
[  893.580000] ath: phy1: PDADC (0,   0): a2cc 9c9c9c9c
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC  76 Value 156 | PDADC  77 Value 156 | PDADC  78 Value 156 | PDADC  79 Value 156 |
[  893.580000] ath: phy1: PDADC (0,   0): a2d0 9c9c9c9c
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC  80 Value 156 | PDADC  81 Value 156 | PDADC  82 Value 156 | PDADC  83 Value 156 |
[  893.580000] ath: phy1: PDADC (0,   0): a2d4 9c9c9c9c
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC  84 Value 156 | PDADC  85 Value 156 | PDADC  86 Value 156 | PDADC  87 Value 156 |
[  893.580000] ath: phy1: PDADC (0,   0): a2d8 9c9c9c9c
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC  88 Value 156 | PDADC  89 Value 156 | PDADC  90 Value 156 | PDADC  91 Value 156 |
[  893.580000] ath: phy1: PDADC (0,   0): a2dc 9c9c9c9c
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC  92 Value 156 | PDADC  93 Value 156 | PDADC  94 Value 156 | PDADC  95 Value 156 |
[  893.580000] ath: phy1: PDADC (0,   0): a2e0 9c9c9c9c
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC  96 Value 156 | PDADC  97 Value 156 | PDADC  98 Value 156 | PDADC  99 Value 156 |
[  893.580000] ath: phy1: PDADC (0,   0): a2e4 9c9c9c9c
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC 100 Value 156 | PDADC 101 Value 156 | PDADC 102 Value 156 | PDADC 103 Value 156 |
[  893.580000] ath: phy1: PDADC (0,   0): a2e8 9c9c9c9c
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC 104 Value 156 | PDADC 105 Value 156 | PDADC 106 Value 156 | PDADC 107 Value 156 |
[  893.580000] ath: phy1: PDADC (0,   0): a2ec 9c9c9c9c
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC 108 Value 156 | PDADC 109 Value 156 | PDADC 110 Value 156 | PDADC 111 Value 156 |
[  893.580000] ath: phy1: PDADC (0,   0): a2f0 9c9c9c9c
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC 112 Value 156 | PDADC 113 Value 156 | PDADC 114 Value 156 | PDADC 115 Value 156 |
[  893.580000] ath: phy1: PDADC (0,   0): a2f4 9c9c9c9c
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC 116 Value 156 | PDADC 117 Value 156 | PDADC 118 Value 156 | PDADC 119 Value 156 |
[  893.580000] ath: phy1: PDADC (0,   0): a2f8 9c9c9c9c
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC 120 Value 156 | PDADC 121 Value 156 | PDADC 122 Value 156 | PDADC 123 Value 156 |
[  893.580000] ath: phy1: PDADC (0,   0): a2fc 9c9c9c9c
[  893.580000] ath: phy1: PDADC: Chain 0 | PDADC 124 Value 156 | PDADC 125 Value 156 | PDADC 126 Value 156 | PDADC 127 Value 156 |
[  893.580000] ath: phy1: PDADC (1,1000): b280 04030201
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC   0 Value   1 | PDADC   1 Value   2 | PDADC   2 Value   3 | PDADC   3 Value   4 |
[  893.580000] ath: phy1: PDADC (1,1000): b284 07060605
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC   4 Value   5 | PDADC   5 Value   6 | PDADC   6 Value   6 | PDADC   7 Value   7 |
[  893.580000] ath: phy1: PDADC (1,1000): b288 0b0a0908
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  11 |
[  893.580000] ath: phy1: PDADC (1,1000): b28c 0e0d0c0b
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC  12 Value  11 | PDADC  13 Value  12 | PDADC  14 Value  13 | PDADC  15 Value  14 |
[  893.580000] ath: phy1: PDADC (1,1000): b290 1311100f
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC  16 Value  15 | PDADC  17 Value  16 | PDADC  18 Value  17 | PDADC  19 Value  19 |
[  893.580000] ath: phy1: PDADC (1,1000): b294 1b191715
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC  20 Value  21 | PDADC  21 Value  23 | PDADC  22 Value  25 | PDADC  23 Value  27 |
[  893.580000] ath: phy1: PDADC (1,1000): b298 23211f1d
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC  24 Value  29 | PDADC  25 Value  31 | PDADC  26 Value  33 | PDADC  27 Value  35 |
[  893.580000] ath: phy1: PDADC (1,1000): b29c 322e2a26
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC  28 Value  38 | PDADC  29 Value  42 | PDADC  30 Value  46 | PDADC  31 Value  50 |
[  893.580000] ath: phy1: PDADC (1,1000): b2a0 423e3a36
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC  32 Value  54 | PDADC  33 Value  58 | PDADC  34 Value  62 | PDADC  35 Value  66 |
[  893.580000] ath: phy1: PDADC (1,1000): b2a4 534e4a46
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC  36 Value  70 | PDADC  37 Value  74 | PDADC  38 Value  78 | PDADC  39 Value  83 |
[  893.580000] ath: phy1: PDADC (1,1000): b2a8 746b635b
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC  40 Value  91 | PDADC  41 Value  99 | PDADC  42 Value 107 | PDADC  43 Value 116 |
[  893.580000] ath: phy1: PDADC (1,1000): b2ac 948c847c
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC  44 Value 124 | PDADC  45 Value 132 | PDADC  46 Value 140 | PDADC  47 Value 148 |
[  893.580000] ath: phy1: PDADC (1,1000): b2b0 2926239c
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC  48 Value 156 | PDADC  49 Value  35 | PDADC  50 Value  38 | PDADC  51 Value  41 |
[  893.580000] ath: phy1: PDADC (1,1000): b2b4 3834302d
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC  52 Value  45 | PDADC  53 Value  48 | PDADC  54 Value  52 | PDADC  55 Value  56 |
[  893.580000] ath: phy1: PDADC (1,1000): b2b8 4a443f3b
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC  56 Value  59 | PDADC  57 Value  63 | PDADC  58 Value  68 | PDADC  59 Value  74 |
[  893.580000] ath: phy1: PDADC (1,1000): b2bc 645d5750
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC  60 Value  80 | PDADC  61 Value  87 | PDADC  62 Value  93 | PDADC  63 Value 100 |
[  893.580000] ath: phy1: PDADC (1,1000): b2c0 8079726b
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC  64 Value 107 | PDADC  65 Value 114 | PDADC  66 Value 121 | PDADC  67 Value 128 |
[  893.580000] ath: phy1: PDADC (1,1000): b2c4 8e8e8e87
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC  68 Value 135 | PDADC  69 Value 142 | PDADC  70 Value 142 | PDADC  71 Value 142 |
[  893.580000] ath: phy1: PDADC (1,1000): b2c8 8e8e8e8e
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC  72 Value 142 | PDADC  73 Value 142 | PDADC  74 Value 142 | PDADC  75 Value 142 |
[  893.580000] ath: phy1: PDADC (1,1000): b2cc 8e8e8e8e
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC  76 Value 142 | PDADC  77 Value 142 | PDADC  78 Value 142 | PDADC  79 Value 142 |
[  893.580000] ath: phy1: PDADC (1,1000): b2d0 8e8e8e8e
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC  80 Value 142 | PDADC  81 Value 142 | PDADC  82 Value 142 | PDADC  83 Value 142 |
[  893.580000] ath: phy1: PDADC (1,1000): b2d4 8e8e8e8e
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC  84 Value 142 | PDADC  85 Value 142 | PDADC  86 Value 142 | PDADC  87 Value 142 |
[  893.580000] ath: phy1: PDADC (1,1000): b2d8 8e8e8e8e
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC  88 Value 142 | PDADC  89 Value 142 | PDADC  90 Value 142 | PDADC  91 Value 142 |
[  893.580000] ath: phy1: PDADC (1,1000): b2dc 8e8e8e8e
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC  92 Value 142 | PDADC  93 Value 142 | PDADC  94 Value 142 | PDADC  95 Value 142 |
[  893.580000] ath: phy1: PDADC (1,1000): b2e0 8e8e8e8e
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC  96 Value 142 | PDADC  97 Value 142 | PDADC  98 Value 142 | PDADC  99 Value 142 |
[  893.580000] ath: phy1: PDADC (1,1000): b2e4 8e8e8e8e
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC 100 Value 142 | PDADC 101 Value 142 | PDADC 102 Value 142 | PDADC 103 Value 142 |
[  893.580000] ath: phy1: PDADC (1,1000): b2e8 8e8e8e8e
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC 104 Value 142 | PDADC 105 Value 142 | PDADC 106 Value 142 | PDADC 107 Value 142 |
[  893.580000] ath: phy1: PDADC (1,1000): b2ec 8e8e8e8e
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC 108 Value 142 | PDADC 109 Value 142 | PDADC 110 Value 142 | PDADC 111 Value 142 |
[  893.580000] ath: phy1: PDADC (1,1000): b2f0 8e8e8e8e
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC 112 Value 142 | PDADC 113 Value 142 | PDADC 114 Value 142 | PDADC 115 Value 142 |
[  893.580000] ath: phy1: PDADC (1,1000): b2f4 8e8e8e8e
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC 116 Value 142 | PDADC 117 Value 142 | PDADC 118 Value 142 | PDADC 119 Value 142 |
[  893.580000] ath: phy1: PDADC (1,1000): b2f8 8e8e8e8e
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC 120 Value 142 | PDADC 121 Value 142 | PDADC 122 Value 142 | PDADC 123 Value 142 |
[  893.580000] ath: phy1: PDADC (1,1000): b2fc 8e8e8e8e
[  893.580000] ath: phy1: PDADC: Chain 1 | PDADC 124 Value 142 | PDADC 125 Value 142 | PDADC 126 Value 142 | PDADC 127 Value 142 |
[  893.580000] ath: phy1: Set HW RX filter: 0x4097
[  893.580000] ath: phy1: Configure tx [queue/halq] [0/3], aifs: 2, cw_min: 3, cw_max: 7, txop: 47
[  893.580000] ath: phy1: Set queue properties for: 3
[  893.580000] ath: phy1: Reset TX queue: 3
[  893.580000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.580000] ath: phy1: Configure tx [queue/halq] [1/2], aifs: 2, cw_min: 7, cw_max: 15, txop: 94
[  893.580000] ath: phy1: Set queue properties for: 2
[  893.580000] ath: phy1: Reset TX queue: 2
[  893.580000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.580000] ath: phy1: Configure tx [queue/halq] [2/1], aifs: 3, cw_min: 15, cw_max: 1023, txop: 0
[  893.580000] ath: phy1: Set queue properties for: 1
[  893.580000] ath: phy1: Reset TX queue: 1
[  893.580000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.580000] ath: phy1: Configure tx [queue/halq] [3/0], aifs: 7, cw_min: 15, cw_max: 1023, txop: 0
[  893.580000] ath: phy1: Set queue properties for: 0
[  893.580000] ath: phy1: Reset TX queue: 0
[  893.580000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.580000] ath: phy1: PowerSave disabled
[  893.580000] ath: phy1: Monitor mode is disabled
[  893.580000] ath: phy1: Set channel: 5895 MHz width: 0
[  893.580000] ath: phy1: disable IER
[  893.580000] ath: phy1: Stopping ANI
[  893.580000] ath: phy1: disable IER
[  893.580000] ath: phy1: Disable MIB counters
[  893.580000] ath: phy1: Reset to 5895 MHz, HT40: 0 fastcc: 0
[  893.580000] ath: phy1: NF did not complete in calibration window
[  893.590000] ath: phy1: PDADC (0,   0): a280 03020100
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC   0 Value   0 | PDADC   1 Value   1 | PDADC   2 Value   2 | PDADC   3 Value   3 |
[  893.590000] ath: phy1: PDADC (0,   0): a284 07060504
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC   4 Value   4 | PDADC   5 Value   5 | PDADC   6 Value   6 | PDADC   7 Value   7 |
[  893.590000] ath: phy1: PDADC (0,   0): a288 0c0a0908
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  12 |
[  893.590000] ath: phy1: PDADC (0,   0): a28c 11100e0d
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC  12 Value  13 | PDADC  13 Value  14 | PDADC  14 Value  16 | PDADC  15 Value  17 |
[  893.590000] ath: phy1: PDADC (0,   0): a290 16151412
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC  16 Value  18 | PDADC  17 Value  20 | PDADC  18 Value  21 | PDADC  19 Value  22 |
[  893.590000] ath: phy1: PDADC (0,   0): a294 1f1d1a18
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC  20 Value  24 | PDADC  21 Value  26 | PDADC  22 Value  29 | PDADC  23 Value  31 |
[  893.590000] ath: phy1: PDADC (0,   0): a298 2a282522
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC  24 Value  34 | PDADC  25 Value  37 | PDADC  26 Value  40 | PDADC  27 Value  42 |
[  893.590000] ath: phy1: PDADC (0,   0): a29c 3633302d
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC  28 Value  45 | PDADC  29 Value  48 | PDADC  30 Value  51 | PDADC  31 Value  54 |
[  893.590000] ath: phy1: PDADC (0,   0): a2a0 4c46413b
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC  32 Value  59 | PDADC  33 Value  65 | PDADC  34 Value  70 | PDADC  35 Value  76 |
[  893.590000] ath: phy1: PDADC (0,   0): a2a4 625d5752
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC  36 Value  82 | PDADC  37 Value  87 | PDADC  38 Value  93 | PDADC  39 Value  98 |
[  893.590000] ath: phy1: PDADC (0,   0): a2a8 7b746e68
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC  40 Value 104 | PDADC  41 Value 110 | PDADC  42 Value 116 | PDADC  43 Value 123 |
[  893.590000] ath: phy1: PDADC (0,   0): a2ac 968f8882
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC  44 Value 130 | PDADC  45 Value 136 | PDADC  46 Value 143 | PDADC  47 Value 150 |
[  893.590000] ath: phy1: PDADC (0,   0): a2b0 332f2bab
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC  48 Value 171 | PDADC  49 Value  43 | PDADC  50 Value  47 | PDADC  51 Value  51 |
[  893.590000] ath: phy1: PDADC (0,   0): a2b4 433f3b37
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC  52 Value  55 | PDADC  53 Value  59 | PDADC  54 Value  63 | PDADC  55 Value  67 |
[  893.590000] ath: phy1: PDADC (0,   0): a2b8 59534d47
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC  56 Value  71 | PDADC  57 Value  77 | PDADC  58 Value  83 | PDADC  59 Value  89 |
[  893.590000] ath: phy1: PDADC (0,   0): a2bc 726c655f
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC  60 Value  95 | PDADC  61 Value 101 | PDADC  62 Value 108 | PDADC  63 Value 114 |
[  893.590000] ath: phy1: PDADC (0,   0): a2c0 8a847e78
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC  64 Value 120 | PDADC  65 Value 126 | PDADC  66 Value 132 | PDADC  67 Value 138 |
[  893.590000] ath: phy1: PDADC (0,   0): a2c4 9c9c9690
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC  68 Value 144 | PDADC  69 Value 150 | PDADC  70 Value 156 | PDADC  71 Value 156 |
[  893.590000] ath: phy1: PDADC (0,   0): a2c8 9c9c9c9c
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC  72 Value 156 | PDADC  73 Value 156 | PDADC  74 Value 156 | PDADC  75 Value 156 |
[  893.590000] ath: phy1: PDADC (0,   0): a2cc 9c9c9c9c
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC  76 Value 156 | PDADC  77 Value 156 | PDADC  78 Value 156 | PDADC  79 Value 156 |
[  893.590000] ath: phy1: PDADC (0,   0): a2d0 9c9c9c9c
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC  80 Value 156 | PDADC  81 Value 156 | PDADC  82 Value 156 | PDADC  83 Value 156 |
[  893.590000] ath: phy1: PDADC (0,   0): a2d4 9c9c9c9c
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC  84 Value 156 | PDADC  85 Value 156 | PDADC  86 Value 156 | PDADC  87 Value 156 |
[  893.590000] ath: phy1: PDADC (0,   0): a2d8 9c9c9c9c
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC  88 Value 156 | PDADC  89 Value 156 | PDADC  90 Value 156 | PDADC  91 Value 156 |
[  893.590000] ath: phy1: PDADC (0,   0): a2dc 9c9c9c9c
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC  92 Value 156 | PDADC  93 Value 156 | PDADC  94 Value 156 | PDADC  95 Value 156 |
[  893.590000] ath: phy1: PDADC (0,   0): a2e0 9c9c9c9c
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC  96 Value 156 | PDADC  97 Value 156 | PDADC  98 Value 156 | PDADC  99 Value 156 |
[  893.590000] ath: phy1: PDADC (0,   0): a2e4 9c9c9c9c
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC 100 Value 156 | PDADC 101 Value 156 | PDADC 102 Value 156 | PDADC 103 Value 156 |
[  893.590000] ath: phy1: PDADC (0,   0): a2e8 9c9c9c9c
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC 104 Value 156 | PDADC 105 Value 156 | PDADC 106 Value 156 | PDADC 107 Value 156 |
[  893.590000] ath: phy1: PDADC (0,   0): a2ec 9c9c9c9c
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC 108 Value 156 | PDADC 109 Value 156 | PDADC 110 Value 156 | PDADC 111 Value 156 |
[  893.590000] ath: phy1: PDADC (0,   0): a2f0 9c9c9c9c
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC 112 Value 156 | PDADC 113 Value 156 | PDADC 114 Value 156 | PDADC 115 Value 156 |
[  893.590000] ath: phy1: PDADC (0,   0): a2f4 9c9c9c9c
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC 116 Value 156 | PDADC 117 Value 156 | PDADC 118 Value 156 | PDADC 119 Value 156 |
[  893.590000] ath: phy1: PDADC (0,   0): a2f8 9c9c9c9c
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC 120 Value 156 | PDADC 121 Value 156 | PDADC 122 Value 156 | PDADC 123 Value 156 |
[  893.590000] ath: phy1: PDADC (0,   0): a2fc 9c9c9c9c
[  893.590000] ath: phy1: PDADC: Chain 0 | PDADC 124 Value 156 | PDADC 125 Value 156 | PDADC 126 Value 156 | PDADC 127 Value 156 |
[  893.590000] ath: phy1: PDADC (1,1000): b280 04030201
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC   0 Value   1 | PDADC   1 Value   2 | PDADC   2 Value   3 | PDADC   3 Value   4 |
[  893.590000] ath: phy1: PDADC (1,1000): b284 07060605
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC   4 Value   5 | PDADC   5 Value   6 | PDADC   6 Value   6 | PDADC   7 Value   7 |
[  893.590000] ath: phy1: PDADC (1,1000): b288 0b0a0908
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  11 |
[  893.590000] ath: phy1: PDADC (1,1000): b28c 0e0d0c0b
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC  12 Value  11 | PDADC  13 Value  12 | PDADC  14 Value  13 | PDADC  15 Value  14 |
[  893.590000] ath: phy1: PDADC (1,1000): b290 1311100f
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC  16 Value  15 | PDADC  17 Value  16 | PDADC  18 Value  17 | PDADC  19 Value  19 |
[  893.590000] ath: phy1: PDADC (1,1000): b294 1b191715
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC  20 Value  21 | PDADC  21 Value  23 | PDADC  22 Value  25 | PDADC  23 Value  27 |
[  893.590000] ath: phy1: PDADC (1,1000): b298 23211f1d
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC  24 Value  29 | PDADC  25 Value  31 | PDADC  26 Value  33 | PDADC  27 Value  35 |
[  893.590000] ath: phy1: PDADC (1,1000): b29c 322e2a26
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC  28 Value  38 | PDADC  29 Value  42 | PDADC  30 Value  46 | PDADC  31 Value  50 |
[  893.590000] ath: phy1: PDADC (1,1000): b2a0 423e3a36
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC  32 Value  54 | PDADC  33 Value  58 | PDADC  34 Value  62 | PDADC  35 Value  66 |
[  893.590000] ath: phy1: PDADC (1,1000): b2a4 534e4a46
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC  36 Value  70 | PDADC  37 Value  74 | PDADC  38 Value  78 | PDADC  39 Value  83 |
[  893.590000] ath: phy1: PDADC (1,1000): b2a8 746b635b
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC  40 Value  91 | PDADC  41 Value  99 | PDADC  42 Value 107 | PDADC  43 Value 116 |
[  893.590000] ath: phy1: PDADC (1,1000): b2ac 948c847c
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC  44 Value 124 | PDADC  45 Value 132 | PDADC  46 Value 140 | PDADC  47 Value 148 |
[  893.590000] ath: phy1: PDADC (1,1000): b2b0 2926239c
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC  48 Value 156 | PDADC  49 Value  35 | PDADC  50 Value  38 | PDADC  51 Value  41 |
[  893.590000] ath: phy1: PDADC (1,1000): b2b4 3834302d
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC  52 Value  45 | PDADC  53 Value  48 | PDADC  54 Value  52 | PDADC  55 Value  56 |
[  893.590000] ath: phy1: PDADC (1,1000): b2b8 4a443f3b
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC  56 Value  59 | PDADC  57 Value  63 | PDADC  58 Value  68 | PDADC  59 Value  74 |
[  893.590000] ath: phy1: PDADC (1,1000): b2bc 645d5750
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC  60 Value  80 | PDADC  61 Value  87 | PDADC  62 Value  93 | PDADC  63 Value 100 |
[  893.590000] ath: phy1: PDADC (1,1000): b2c0 8079726b
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC  64 Value 107 | PDADC  65 Value 114 | PDADC  66 Value 121 | PDADC  67 Value 128 |
[  893.590000] ath: phy1: PDADC (1,1000): b2c4 8e8e8e87
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC  68 Value 135 | PDADC  69 Value 142 | PDADC  70 Value 142 | PDADC  71 Value 142 |
[  893.590000] ath: phy1: PDADC (1,1000): b2c8 8e8e8e8e
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC  72 Value 142 | PDADC  73 Value 142 | PDADC  74 Value 142 | PDADC  75 Value 142 |
[  893.590000] ath: phy1: PDADC (1,1000): b2cc 8e8e8e8e
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC  76 Value 142 | PDADC  77 Value 142 | PDADC  78 Value 142 | PDADC  79 Value 142 |
[  893.590000] ath: phy1: PDADC (1,1000): b2d0 8e8e8e8e
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC  80 Value 142 | PDADC  81 Value 142 | PDADC  82 Value 142 | PDADC  83 Value 142 |
[  893.590000] ath: phy1: PDADC (1,1000): b2d4 8e8e8e8e
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC  84 Value 142 | PDADC  85 Value 142 | PDADC  86 Value 142 | PDADC  87 Value 142 |
[  893.590000] ath: phy1: PDADC (1,1000): b2d8 8e8e8e8e
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC  88 Value 142 | PDADC  89 Value 142 | PDADC  90 Value 142 | PDADC  91 Value 142 |
[  893.590000] ath: phy1: PDADC (1,1000): b2dc 8e8e8e8e
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC  92 Value 142 | PDADC  93 Value 142 | PDADC  94 Value 142 | PDADC  95 Value 142 |
[  893.590000] ath: phy1: PDADC (1,1000): b2e0 8e8e8e8e
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC  96 Value 142 | PDADC  97 Value 142 | PDADC  98 Value 142 | PDADC  99 Value 142 |
[  893.590000] ath: phy1: PDADC (1,1000): b2e4 8e8e8e8e
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC 100 Value 142 | PDADC 101 Value 142 | PDADC 102 Value 142 | PDADC 103 Value 142 |
[  893.590000] ath: phy1: PDADC (1,1000): b2e8 8e8e8e8e
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC 104 Value 142 | PDADC 105 Value 142 | PDADC 106 Value 142 | PDADC 107 Value 142 |
[  893.590000] ath: phy1: PDADC (1,1000): b2ec 8e8e8e8e
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC 108 Value 142 | PDADC 109 Value 142 | PDADC 110 Value 142 | PDADC 111 Value 142 |
[  893.590000] ath: phy1: PDADC (1,1000): b2f0 8e8e8e8e
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC 112 Value 142 | PDADC 113 Value 142 | PDADC 114 Value 142 | PDADC 115 Value 142 |
[  893.590000] ath: phy1: PDADC (1,1000): b2f4 8e8e8e8e
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC 116 Value 142 | PDADC 117 Value 142 | PDADC 118 Value 142 | PDADC 119 Value 142 |
[  893.590000] ath: phy1: PDADC (1,1000): b2f8 8e8e8e8e
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC 120 Value 142 | PDADC 121 Value 142 | PDADC 122 Value 142 | PDADC 123 Value 142 |
[  893.590000] ath: phy1: PDADC (1,1000): b2fc 8e8e8e8e
[  893.590000] ath: phy1: PDADC: Chain 1 | PDADC 124 Value 142 | PDADC 125 Value 142 | PDADC 126 Value 142 | PDADC 127 Value 142 |
[  893.590000] ath: phy1: Reset TX queue: 0
[  893.590000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.590000] ath: phy1: Reset TX queue: 1
[  893.590000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.590000] ath: phy1: Reset TX queue: 2
[  893.590000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.590000] ath: phy1: Reset TX queue: 3
[  893.590000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.590000] ath: phy1: Reset TXQ, inactive queue: 4
[  893.590000] ath: phy1: Reset TXQ, inactive queue: 5
[  893.590000] ath: phy1: Reset TXQ, inactive queue: 6
[  893.590000] ath: phy1: Reset TX queue: 7
[  893.590000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.590000] ath: phy1: Reset TX queue: 8
[  893.590000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.590000] ath: phy1: Reset TX queue: 9
[  893.590000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.590000] ath: phy1: ver 128.2 opmode 3 chan 5895 Mhz
[  893.590000] ath: phy1: ah->misc_mode 0xc
[  893.590000] ath: phy1: enabling ADC Gain Calibration
[  893.590000] ath: phy1: enabling ADC DC Calibration
[  893.590000] ath: phy1: enabling IQ Calibration
[  893.590000] ath: phy1: starting ADC Gain Calibration
[  893.590000] ath: phy1: New interrupt mask 0xd0000071
[  893.590000] ath: phy1: new IMR 0x918004b0
[  893.590000] ath: phy1: macaddr: 00:80:48:75:e8:7a, bssid: 00:00:00:00:00:00, bssidmask: ff:ff:ff:ff:ff:ff
[  893.590000] ath: phy1: Enable MIB counters
[  893.590000] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[  893.590000] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[  893.590000] ath: phy1: New interrupt mask 0xd0000071
[  893.590000] ath: phy1: new IMR 0x918004b0
[  893.590000] ath: phy1: enable IER
[  893.590000] ath: phy1: AR_IMR 0x918004b0 IER 0x1
[  893.610000] ath: phy1: Set HW RX filter: 0x4097
[  893.690000] ath: phy1: Set HW RX filter: 0x4097
[  893.750000] ath: phy1: Set HW RX filter: 0x4097
[  893.780000] ath: phy1: Set HW RX filter: 0x4097
[  893.780000] ath: phy1: Detach Interface
[  893.780000] ath: phy1: Removing interface at beacon slot: 0
[  893.780000] ath: phy1: New interrupt mask 0xd0000071
[  893.780000] ath: phy1: new IMR 0x918004b0
[  893.780000] ath: phy1: ah->misc_mode 0x4
[  893.780000] ath: phy1: macaddr: 00:80:48:75:e8:7a, bssid: 00:00:00:00:00:00, bssidmask: ff:ff:ff:ff:ff:ff
[  893.780000] ath: phy1: PDADC (0,   0): a280 03020100
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC   0 Value   0 | PDADC   1 Value   1 | PDADC   2 Value   2 | PDADC   3 Value   3 |
[  893.780000] ath: phy1: PDADC (0,   0): a284 07060504
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC   4 Value   4 | PDADC   5 Value   5 | PDADC   6 Value   6 | PDADC   7 Value   7 |
[  893.780000] ath: phy1: PDADC (0,   0): a288 0c0a0908
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  12 |
[  893.780000] ath: phy1: PDADC (0,   0): a28c 11100e0d
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  12 Value  13 | PDADC  13 Value  14 | PDADC  14 Value  16 | PDADC  15 Value  17 |
[  893.780000] ath: phy1: PDADC (0,   0): a290 16151412
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  16 Value  18 | PDADC  17 Value  20 | PDADC  18 Value  21 | PDADC  19 Value  22 |
[  893.780000] ath: phy1: PDADC (0,   0): a294 1f1d1a18
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  20 Value  24 | PDADC  21 Value  26 | PDADC  22 Value  29 | PDADC  23 Value  31 |
[  893.780000] ath: phy1: PDADC (0,   0): a298 2a282522
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  24 Value  34 | PDADC  25 Value  37 | PDADC  26 Value  40 | PDADC  27 Value  42 |
[  893.780000] ath: phy1: PDADC (0,   0): a29c 3633302d
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  28 Value  45 | PDADC  29 Value  48 | PDADC  30 Value  51 | PDADC  31 Value  54 |
[  893.780000] ath: phy1: PDADC (0,   0): a2a0 4c46413b
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  32 Value  59 | PDADC  33 Value  65 | PDADC  34 Value  70 | PDADC  35 Value  76 |
[  893.780000] ath: phy1: PDADC (0,   0): a2a4 625d5752
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  36 Value  82 | PDADC  37 Value  87 | PDADC  38 Value  93 | PDADC  39 Value  98 |
[  893.780000] ath: phy1: PDADC (0,   0): a2a8 7b746e68
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  40 Value 104 | PDADC  41 Value 110 | PDADC  42 Value 116 | PDADC  43 Value 123 |
[  893.780000] ath: phy1: PDADC (0,   0): a2ac 968f8882
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  44 Value 130 | PDADC  45 Value 136 | PDADC  46 Value 143 | PDADC  47 Value 150 |
[  893.780000] ath: phy1: PDADC (0,   0): a2b0 332f2bab
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  48 Value 171 | PDADC  49 Value  43 | PDADC  50 Value  47 | PDADC  51 Value  51 |
[  893.780000] ath: phy1: PDADC (0,   0): a2b4 433f3b37
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  52 Value  55 | PDADC  53 Value  59 | PDADC  54 Value  63 | PDADC  55 Value  67 |
[  893.780000] ath: phy1: PDADC (0,   0): a2b8 59534d47
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  56 Value  71 | PDADC  57 Value  77 | PDADC  58 Value  83 | PDADC  59 Value  89 |
[  893.780000] ath: phy1: PDADC (0,   0): a2bc 726c655f
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  60 Value  95 | PDADC  61 Value 101 | PDADC  62 Value 108 | PDADC  63 Value 114 |
[  893.780000] ath: phy1: PDADC (0,   0): a2c0 8a847e78
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  64 Value 120 | PDADC  65 Value 126 | PDADC  66 Value 132 | PDADC  67 Value 138 |
[  893.780000] ath: phy1: PDADC (0,   0): a2c4 9c9c9690
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  68 Value 144 | PDADC  69 Value 150 | PDADC  70 Value 156 | PDADC  71 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2c8 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  72 Value 156 | PDADC  73 Value 156 | PDADC  74 Value 156 | PDADC  75 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2cc 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  76 Value 156 | PDADC  77 Value 156 | PDADC  78 Value 156 | PDADC  79 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2d0 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  80 Value 156 | PDADC  81 Value 156 | PDADC  82 Value 156 | PDADC  83 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2d4 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  84 Value 156 | PDADC  85 Value 156 | PDADC  86 Value 156 | PDADC  87 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2d8 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  88 Value 156 | PDADC  89 Value 156 | PDADC  90 Value 156 | PDADC  91 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2dc 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  92 Value 156 | PDADC  93 Value 156 | PDADC  94 Value 156 | PDADC  95 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2e0 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  96 Value 156 | PDADC  97 Value 156 | PDADC  98 Value 156 | PDADC  99 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2e4 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC 100 Value 156 | PDADC 101 Value 156 | PDADC 102 Value 156 | PDADC 103 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2e8 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC 104 Value 156 | PDADC 105 Value 156 | PDADC 106 Value 156 | PDADC 107 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2ec 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC 108 Value 156 | PDADC 109 Value 156 | PDADC 110 Value 156 | PDADC 111 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2f0 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC 112 Value 156 | PDADC 113 Value 156 | PDADC 114 Value 156 | PDADC 115 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2f4 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC 116 Value 156 | PDADC 117 Value 156 | PDADC 118 Value 156 | PDADC 119 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2f8 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC 120 Value 156 | PDADC 121 Value 156 | PDADC 122 Value 156 | PDADC 123 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2fc 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC 124 Value 156 | PDADC 125 Value 156 | PDADC 126 Value 156 | PDADC 127 Value 156 |
[  893.780000] ath: phy1: PDADC (1,1000): b280 04030201
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC   0 Value   1 | PDADC   1 Value   2 | PDADC   2 Value   3 | PDADC   3 Value   4 |
[  893.780000] ath: phy1: PDADC (1,1000): b284 07060605
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC   4 Value   5 | PDADC   5 Value   6 | PDADC   6 Value   6 | PDADC   7 Value   7 |
[  893.780000] ath: phy1: PDADC (1,1000): b288 0b0a0908
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  11 |
[  893.780000] ath: phy1: PDADC (1,1000): b28c 0e0d0c0b
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  12 Value  11 | PDADC  13 Value  12 | PDADC  14 Value  13 | PDADC  15 Value  14 |
[  893.780000] ath: phy1: PDADC (1,1000): b290 1311100f
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  16 Value  15 | PDADC  17 Value  16 | PDADC  18 Value  17 | PDADC  19 Value  19 |
[  893.780000] ath: phy1: PDADC (1,1000): b294 1b191715
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  20 Value  21 | PDADC  21 Value  23 | PDADC  22 Value  25 | PDADC  23 Value  27 |
[  893.780000] ath: phy1: PDADC (1,1000): b298 23211f1d
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  24 Value  29 | PDADC  25 Value  31 | PDADC  26 Value  33 | PDADC  27 Value  35 |
[  893.780000] ath: phy1: PDADC (1,1000): b29c 322e2a26
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  28 Value  38 | PDADC  29 Value  42 | PDADC  30 Value  46 | PDADC  31 Value  50 |
[  893.780000] ath: phy1: PDADC (1,1000): b2a0 423e3a36
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  32 Value  54 | PDADC  33 Value  58 | PDADC  34 Value  62 | PDADC  35 Value  66 |
[  893.780000] ath: phy1: PDADC (1,1000): b2a4 534e4a46
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  36 Value  70 | PDADC  37 Value  74 | PDADC  38 Value  78 | PDADC  39 Value  83 |
[  893.780000] ath: phy1: PDADC (1,1000): b2a8 746b635b
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  40 Value  91 | PDADC  41 Value  99 | PDADC  42 Value 107 | PDADC  43 Value 116 |
[  893.780000] ath: phy1: PDADC (1,1000): b2ac 948c847c
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  44 Value 124 | PDADC  45 Value 132 | PDADC  46 Value 140 | PDADC  47 Value 148 |
[  893.780000] ath: phy1: PDADC (1,1000): b2b0 2926239c
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  48 Value 156 | PDADC  49 Value  35 | PDADC  50 Value  38 | PDADC  51 Value  41 |
[  893.780000] ath: phy1: PDADC (1,1000): b2b4 3834302d
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  52 Value  45 | PDADC  53 Value  48 | PDADC  54 Value  52 | PDADC  55 Value  56 |
[  893.780000] ath: phy1: PDADC (1,1000): b2b8 4a443f3b
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  56 Value  59 | PDADC  57 Value  63 | PDADC  58 Value  68 | PDADC  59 Value  74 |
[  893.780000] ath: phy1: PDADC (1,1000): b2bc 645d5750
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  60 Value  80 | PDADC  61 Value  87 | PDADC  62 Value  93 | PDADC  63 Value 100 |
[  893.780000] ath: phy1: PDADC (1,1000): b2c0 8079726b
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  64 Value 107 | PDADC  65 Value 114 | PDADC  66 Value 121 | PDADC  67 Value 128 |
[  893.780000] ath: phy1: PDADC (1,1000): b2c4 8e8e8e87
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  68 Value 135 | PDADC  69 Value 142 | PDADC  70 Value 142 | PDADC  71 Value 142 |
[  893.780000] ath: phy1: PDADC (1,1000): b2c8 8e8e8e8e
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  72 Value 142 | PDADC  73 Value 142 | PDADC  74 Value 142 | PDADC  75 Value 142 |
[  893.780000] ath: phy1: PDADC (1,1000): b2cc 8e8e8e8e
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  76 Value 142 | PDADC  77 Value 142 | PDADC  78 Value 142 | PDADC  79 Value 142 |
[  893.780000] ath: phy1: PDADC (1,1000): b2d0 8e8e8e8e
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  80 Value 142 | PDADC  81 Value 142 | PDADC  82 Value 142 | PDADC  83 Value 142 |
[  893.780000] ath: phy1: PDADC (1,1000): b2d4 8e8e8e8e
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  84 Value 142 | PDADC  85 Value 142 | PDADC  86 Value 142 | PDADC  87 Value 142 |
[  893.780000] ath: phy1: PDADC (1,1000): b2d8 8e8e8e8e
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  88 Value 142 | PDADC  89 Value 142 | PDADC  90 Value 142 | PDADC  91 Value 142 |
[  893.780000] ath: phy1: PDADC (1,1000): b2dc 8e8e8e8e
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  92 Value 142 | PDADC  93 Value 142 | PDADC  94 Value 142 | PDADC  95 Value 142 |
[  893.780000] ath: phy1: PDADC (1,1000): b2e0 8e8e8e8e
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  96 Value 142 | PDADC  97 Value 142 | PDADC  98 Value 142 | PDADC  99 Value 142 |
[  893.780000] ath: phy1: PDADC (1,1000): b2e4 8e8e8e8e
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC 100 Value 142 | PDADC 101 Value 142 | PDADC 102 Value 142 | PDADC 103 Value 142 |
[  893.780000] ath: phy1: PDADC (1,1000): b2e8 8e8e8e8e
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC 104 Value 142 | PDADC 105 Value 142 | PDADC 106 Value 142 | PDADC 107 Value 142 |
[  893.780000] ath: phy1: PDADC (1,1000): b2ec 8e8e8e8e
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC 108 Value 142 | PDADC 109 Value 142 | PDADC 110 Value 142 | PDADC 111 Value 142 |
[  893.780000] ath: phy1: PDADC (1,1000): b2f0 8e8e8e8e
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC 112 Value 142 | PDADC 113 Value 142 | PDADC 114 Value 142 | PDADC 115 Value 142 |
[  893.780000] ath: phy1: PDADC (1,1000): b2f4 8e8e8e8e
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC 116 Value 142 | PDADC 117 Value 142 | PDADC 118 Value 142 | PDADC 119 Value 142 |
[  893.780000] ath: phy1: PDADC (1,1000): b2f8 8e8e8e8e
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC 120 Value 142 | PDADC 121 Value 142 | PDADC 122 Value 142 | PDADC 123 Value 142 |
[  893.780000] ath: phy1: PDADC (1,1000): b2fc 8e8e8e8e
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC 124 Value 142 | PDADC 125 Value 142 | PDADC 126 Value 142 | PDADC 127 Value 142 |
[  893.780000] ath: phy1: disable IER
[  893.780000] ath: phy1: Stopping ANI
[  893.780000] ath: phy1: disable IER
[  893.780000] ath: phy1: Disable MIB counters
[  893.780000] ath: phy1: NF calibrated [ctl] [chain 0] is -114
[  893.780000] ath: phy1: NF calibrated [ctl] [chain 1] is -116
[  893.780000] ath: phy1: PDADC (0,   0): a280 03020100
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC   0 Value   0 | PDADC   1 Value   1 | PDADC   2 Value   2 | PDADC   3 Value   3 |
[  893.780000] ath: phy1: PDADC (0,   0): a284 07060504
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC   4 Value   4 | PDADC   5 Value   5 | PDADC   6 Value   6 | PDADC   7 Value   7 |
[  893.780000] ath: phy1: PDADC (0,   0): a288 0c0a0908
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  12 |
[  893.780000] ath: phy1: PDADC (0,   0): a28c 11100e0d
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  12 Value  13 | PDADC  13 Value  14 | PDADC  14 Value  16 | PDADC  15 Value  17 |
[  893.780000] ath: phy1: PDADC (0,   0): a290 16151412
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  16 Value  18 | PDADC  17 Value  20 | PDADC  18 Value  21 | PDADC  19 Value  22 |
[  893.780000] ath: phy1: PDADC (0,   0): a294 1f1d1a18
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  20 Value  24 | PDADC  21 Value  26 | PDADC  22 Value  29 | PDADC  23 Value  31 |
[  893.780000] ath: phy1: PDADC (0,   0): a298 2a282522
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  24 Value  34 | PDADC  25 Value  37 | PDADC  26 Value  40 | PDADC  27 Value  42 |
[  893.780000] ath: phy1: PDADC (0,   0): a29c 3633302d
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  28 Value  45 | PDADC  29 Value  48 | PDADC  30 Value  51 | PDADC  31 Value  54 |
[  893.780000] ath: phy1: PDADC (0,   0): a2a0 4c46413b
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  32 Value  59 | PDADC  33 Value  65 | PDADC  34 Value  70 | PDADC  35 Value  76 |
[  893.780000] ath: phy1: PDADC (0,   0): a2a4 625d5752
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  36 Value  82 | PDADC  37 Value  87 | PDADC  38 Value  93 | PDADC  39 Value  98 |
[  893.780000] ath: phy1: PDADC (0,   0): a2a8 7b746e68
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  40 Value 104 | PDADC  41 Value 110 | PDADC  42 Value 116 | PDADC  43 Value 123 |
[  893.780000] ath: phy1: PDADC (0,   0): a2ac 968f8882
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  44 Value 130 | PDADC  45 Value 136 | PDADC  46 Value 143 | PDADC  47 Value 150 |
[  893.780000] ath: phy1: PDADC (0,   0): a2b0 332f2bab
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  48 Value 171 | PDADC  49 Value  43 | PDADC  50 Value  47 | PDADC  51 Value  51 |
[  893.780000] ath: phy1: PDADC (0,   0): a2b4 433f3b37
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  52 Value  55 | PDADC  53 Value  59 | PDADC  54 Value  63 | PDADC  55 Value  67 |
[  893.780000] ath: phy1: PDADC (0,   0): a2b8 59534d47
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  56 Value  71 | PDADC  57 Value  77 | PDADC  58 Value  83 | PDADC  59 Value  89 |
[  893.780000] ath: phy1: PDADC (0,   0): a2bc 726c655f
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  60 Value  95 | PDADC  61 Value 101 | PDADC  62 Value 108 | PDADC  63 Value 114 |
[  893.780000] ath: phy1: PDADC (0,   0): a2c0 8a847e78
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  64 Value 120 | PDADC  65 Value 126 | PDADC  66 Value 132 | PDADC  67 Value 138 |
[  893.780000] ath: phy1: PDADC (0,   0): a2c4 9c9c9690
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  68 Value 144 | PDADC  69 Value 150 | PDADC  70 Value 156 | PDADC  71 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2c8 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  72 Value 156 | PDADC  73 Value 156 | PDADC  74 Value 156 | PDADC  75 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2cc 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  76 Value 156 | PDADC  77 Value 156 | PDADC  78 Value 156 | PDADC  79 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2d0 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  80 Value 156 | PDADC  81 Value 156 | PDADC  82 Value 156 | PDADC  83 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2d4 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  84 Value 156 | PDADC  85 Value 156 | PDADC  86 Value 156 | PDADC  87 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2d8 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  88 Value 156 | PDADC  89 Value 156 | PDADC  90 Value 156 | PDADC  91 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2dc 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  92 Value 156 | PDADC  93 Value 156 | PDADC  94 Value 156 | PDADC  95 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2e0 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC  96 Value 156 | PDADC  97 Value 156 | PDADC  98 Value 156 | PDADC  99 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2e4 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC 100 Value 156 | PDADC 101 Value 156 | PDADC 102 Value 156 | PDADC 103 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2e8 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC 104 Value 156 | PDADC 105 Value 156 | PDADC 106 Value 156 | PDADC 107 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2ec 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC 108 Value 156 | PDADC 109 Value 156 | PDADC 110 Value 156 | PDADC 111 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2f0 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC 112 Value 156 | PDADC 113 Value 156 | PDADC 114 Value 156 | PDADC 115 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2f4 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC 116 Value 156 | PDADC 117 Value 156 | PDADC 118 Value 156 | PDADC 119 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2f8 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC 120 Value 156 | PDADC 121 Value 156 | PDADC 122 Value 156 | PDADC 123 Value 156 |
[  893.780000] ath: phy1: PDADC (0,   0): a2fc 9c9c9c9c
[  893.780000] ath: phy1: PDADC: Chain 0 | PDADC 124 Value 156 | PDADC 125 Value 156 | PDADC 126 Value 156 | PDADC 127 Value 156 |
[  893.780000] ath: phy1: PDADC (1,1000): b280 04030201
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC   0 Value   1 | PDADC   1 Value   2 | PDADC   2 Value   3 | PDADC   3 Value   4 |
[  893.780000] ath: phy1: PDADC (1,1000): b284 07060605
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC   4 Value   5 | PDADC   5 Value   6 | PDADC   6 Value   6 | PDADC   7 Value   7 |
[  893.780000] ath: phy1: PDADC (1,1000): b288 0b0a0908
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  11 |
[  893.780000] ath: phy1: PDADC (1,1000): b28c 0e0d0c0b
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  12 Value  11 | PDADC  13 Value  12 | PDADC  14 Value  13 | PDADC  15 Value  14 |
[  893.780000] ath: phy1: PDADC (1,1000): b290 1311100f
[  893.780000] ath: phy1: PDADC: Chain 1 | PDADC  16 Value  15 | PDADC  17 Value  16 | PDADC  18 Value  17 | PDADC  19 Value  19 |
[  893.790000] ath: phy1: PDADC (1,1000): b294 1b191715
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC  20 Value  21 | PDADC  21 Value  23 | PDADC  22 Value  25 | PDADC  23 Value  27 |
[  893.790000] ath: phy1: PDADC (1,1000): b298 23211f1d
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC  24 Value  29 | PDADC  25 Value  31 | PDADC  26 Value  33 | PDADC  27 Value  35 |
[  893.790000] ath: phy1: PDADC (1,1000): b29c 322e2a26
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC  28 Value  38 | PDADC  29 Value  42 | PDADC  30 Value  46 | PDADC  31 Value  50 |
[  893.790000] ath: phy1: PDADC (1,1000): b2a0 423e3a36
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC  32 Value  54 | PDADC  33 Value  58 | PDADC  34 Value  62 | PDADC  35 Value  66 |
[  893.790000] ath: phy1: PDADC (1,1000): b2a4 534e4a46
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC  36 Value  70 | PDADC  37 Value  74 | PDADC  38 Value  78 | PDADC  39 Value  83 |
[  893.790000] ath: phy1: PDADC (1,1000): b2a8 746b635b
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC  40 Value  91 | PDADC  41 Value  99 | PDADC  42 Value 107 | PDADC  43 Value 116 |
[  893.790000] ath: phy1: PDADC (1,1000): b2ac 948c847c
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC  44 Value 124 | PDADC  45 Value 132 | PDADC  46 Value 140 | PDADC  47 Value 148 |
[  893.790000] ath: phy1: PDADC (1,1000): b2b0 2926239c
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC  48 Value 156 | PDADC  49 Value  35 | PDADC  50 Value  38 | PDADC  51 Value  41 |
[  893.790000] ath: phy1: PDADC (1,1000): b2b4 3834302d
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC  52 Value  45 | PDADC  53 Value  48 | PDADC  54 Value  52 | PDADC  55 Value  56 |
[  893.790000] ath: phy1: PDADC (1,1000): b2b8 4a443f3b
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC  56 Value  59 | PDADC  57 Value  63 | PDADC  58 Value  68 | PDADC  59 Value  74 |
[  893.790000] ath: phy1: PDADC (1,1000): b2bc 645d5750
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC  60 Value  80 | PDADC  61 Value  87 | PDADC  62 Value  93 | PDADC  63 Value 100 |
[  893.790000] ath: phy1: PDADC (1,1000): b2c0 8079726b
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC  64 Value 107 | PDADC  65 Value 114 | PDADC  66 Value 121 | PDADC  67 Value 128 |
[  893.790000] ath: phy1: PDADC (1,1000): b2c4 8e8e8e87
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC  68 Value 135 | PDADC  69 Value 142 | PDADC  70 Value 142 | PDADC  71 Value 142 |
[  893.790000] ath: phy1: PDADC (1,1000): b2c8 8e8e8e8e
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC  72 Value 142 | PDADC  73 Value 142 | PDADC  74 Value 142 | PDADC  75 Value 142 |
[  893.790000] ath: phy1: PDADC (1,1000): b2cc 8e8e8e8e
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC  76 Value 142 | PDADC  77 Value 142 | PDADC  78 Value 142 | PDADC  79 Value 142 |
[  893.790000] ath: phy1: PDADC (1,1000): b2d0 8e8e8e8e
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC  80 Value 142 | PDADC  81 Value 142 | PDADC  82 Value 142 | PDADC  83 Value 142 |
[  893.790000] ath: phy1: PDADC (1,1000): b2d4 8e8e8e8e
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC  84 Value 142 | PDADC  85 Value 142 | PDADC  86 Value 142 | PDADC  87 Value 142 |
[  893.790000] ath: phy1: PDADC (1,1000): b2d8 8e8e8e8e
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC  88 Value 142 | PDADC  89 Value 142 | PDADC  90 Value 142 | PDADC  91 Value 142 |
[  893.790000] ath: phy1: PDADC (1,1000): b2dc 8e8e8e8e
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC  92 Value 142 | PDADC  93 Value 142 | PDADC  94 Value 142 | PDADC  95 Value 142 |
[  893.790000] ath: phy1: PDADC (1,1000): b2e0 8e8e8e8e
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC  96 Value 142 | PDADC  97 Value 142 | PDADC  98 Value 142 | PDADC  99 Value 142 |
[  893.790000] ath: phy1: PDADC (1,1000): b2e4 8e8e8e8e
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC 100 Value 142 | PDADC 101 Value 142 | PDADC 102 Value 142 | PDADC 103 Value 142 |
[  893.790000] ath: phy1: PDADC (1,1000): b2e8 8e8e8e8e
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC 104 Value 142 | PDADC 105 Value 142 | PDADC 106 Value 142 | PDADC 107 Value 142 |
[  893.790000] ath: phy1: PDADC (1,1000): b2ec 8e8e8e8e
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC 108 Value 142 | PDADC 109 Value 142 | PDADC 110 Value 142 | PDADC 111 Value 142 |
[  893.790000] ath: phy1: PDADC (1,1000): b2f0 8e8e8e8e
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC 112 Value 142 | PDADC 113 Value 142 | PDADC 114 Value 142 | PDADC 115 Value 142 |
[  893.790000] ath: phy1: PDADC (1,1000): b2f4 8e8e8e8e
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC 116 Value 142 | PDADC 117 Value 142 | PDADC 118 Value 142 | PDADC 119 Value 142 |
[  893.790000] ath: phy1: PDADC (1,1000): b2f8 8e8e8e8e
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC 120 Value 142 | PDADC 121 Value 142 | PDADC 122 Value 142 | PDADC 123 Value 142 |
[  893.790000] ath: phy1: PDADC (1,1000): b2fc 8e8e8e8e
[  893.790000] ath: phy1: PDADC: Chain 1 | PDADC 124 Value 142 | PDADC 125 Value 142 | PDADC 126 Value 142 | PDADC 127 Value 142 |
[  893.790000] ath: phy1: Reset TX queue: 0
[  893.790000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.790000] ath: phy1: Reset TX queue: 1
[  893.790000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.790000] ath: phy1: Reset TX queue: 2
[  893.790000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.790000] ath: phy1: Reset TX queue: 3
[  893.790000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.790000] ath: phy1: Reset TXQ, inactive queue: 4
[  893.790000] ath: phy1: Reset TXQ, inactive queue: 5
[  893.790000] ath: phy1: Reset TXQ, inactive queue: 6
[  893.790000] ath: phy1: Reset TX queue: 7
[  893.790000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.790000] ath: phy1: Reset TX queue: 8
[  893.790000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.790000] ath: phy1: Reset TX queue: 9
[  893.790000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  893.790000] ath: phy1: ver 128.2 opmode 2 chan 5895 Mhz
[  893.790000] ath: phy1: ah->misc_mode 0x4
[  893.790000] ath: phy1: enabling ADC Gain Calibration
[  893.790000] ath: phy1: enabling ADC DC Calibration
[  893.790000] ath: phy1: enabling IQ Calibration
[  893.790000] ath: phy1: starting ADC Gain Calibration
[  893.790000] ath: phy1: Driver halt
[  893.900000] ath: phy1: AWAKE -> FULL-SLEEP
[  904.200000] ath: phy1: FULL-SLEEP -> AWAKE
[  904.200000] ath: phy1: ah->misc_mode 0x4
[  904.300000] ath: phy1: AWAKE -> FULL-SLEEP
[  904.400000] ath: phy1: Starting driver with initial channel: 5895 MHz
[  904.400000] ath: phy1: FULL-SLEEP -> AWAKE
[  904.410000] ath: phy1: PDADC (0,   0): a280 03020100
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC   0 Value   0 | PDADC   1 Value   1 | PDADC   2 Value   2 | PDADC   3 Value   3 |
[  904.410000] ath: phy1: PDADC (0,   0): a284 07060504
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC   4 Value   4 | PDADC   5 Value   5 | PDADC   6 Value   6 | PDADC   7 Value   7 |
[  904.410000] ath: phy1: PDADC (0,   0): a288 0c0a0908
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  12 |
[  904.410000] ath: phy1: PDADC (0,   0): a28c 11100e0d
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC  12 Value  13 | PDADC  13 Value  14 | PDADC  14 Value  16 | PDADC  15 Value  17 |
[  904.410000] ath: phy1: PDADC (0,   0): a290 16151412
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC  16 Value  18 | PDADC  17 Value  20 | PDADC  18 Value  21 | PDADC  19 Value  22 |
[  904.410000] ath: phy1: PDADC (0,   0): a294 1f1d1a18
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC  20 Value  24 | PDADC  21 Value  26 | PDADC  22 Value  29 | PDADC  23 Value  31 |
[  904.410000] ath: phy1: PDADC (0,   0): a298 2a282522
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC  24 Value  34 | PDADC  25 Value  37 | PDADC  26 Value  40 | PDADC  27 Value  42 |
[  904.410000] ath: phy1: PDADC (0,   0): a29c 3633302d
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC  28 Value  45 | PDADC  29 Value  48 | PDADC  30 Value  51 | PDADC  31 Value  54 |
[  904.410000] ath: phy1: PDADC (0,   0): a2a0 4c46413b
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC  32 Value  59 | PDADC  33 Value  65 | PDADC  34 Value  70 | PDADC  35 Value  76 |
[  904.410000] ath: phy1: PDADC (0,   0): a2a4 625d5752
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC  36 Value  82 | PDADC  37 Value  87 | PDADC  38 Value  93 | PDADC  39 Value  98 |
[  904.410000] ath: phy1: PDADC (0,   0): a2a8 7b746e68
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC  40 Value 104 | PDADC  41 Value 110 | PDADC  42 Value 116 | PDADC  43 Value 123 |
[  904.410000] ath: phy1: PDADC (0,   0): a2ac 968f8882
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC  44 Value 130 | PDADC  45 Value 136 | PDADC  46 Value 143 | PDADC  47 Value 150 |
[  904.410000] ath: phy1: PDADC (0,   0): a2b0 332f2bab
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC  48 Value 171 | PDADC  49 Value  43 | PDADC  50 Value  47 | PDADC  51 Value  51 |
[  904.410000] ath: phy1: PDADC (0,   0): a2b4 433f3b37
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC  52 Value  55 | PDADC  53 Value  59 | PDADC  54 Value  63 | PDADC  55 Value  67 |
[  904.410000] ath: phy1: PDADC (0,   0): a2b8 59534d47
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC  56 Value  71 | PDADC  57 Value  77 | PDADC  58 Value  83 | PDADC  59 Value  89 |
[  904.410000] ath: phy1: PDADC (0,   0): a2bc 726c655f
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC  60 Value  95 | PDADC  61 Value 101 | PDADC  62 Value 108 | PDADC  63 Value 114 |
[  904.410000] ath: phy1: PDADC (0,   0): a2c0 8a847e78
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC  64 Value 120 | PDADC  65 Value 126 | PDADC  66 Value 132 | PDADC  67 Value 138 |
[  904.410000] ath: phy1: PDADC (0,   0): a2c4 9c9c9690
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC  68 Value 144 | PDADC  69 Value 150 | PDADC  70 Value 156 | PDADC  71 Value 156 |
[  904.410000] ath: phy1: PDADC (0,   0): a2c8 9c9c9c9c
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC  72 Value 156 | PDADC  73 Value 156 | PDADC  74 Value 156 | PDADC  75 Value 156 |
[  904.410000] ath: phy1: PDADC (0,   0): a2cc 9c9c9c9c
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC  76 Value 156 | PDADC  77 Value 156 | PDADC  78 Value 156 | PDADC  79 Value 156 |
[  904.410000] ath: phy1: PDADC (0,   0): a2d0 9c9c9c9c
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC  80 Value 156 | PDADC  81 Value 156 | PDADC  82 Value 156 | PDADC  83 Value 156 |
[  904.410000] ath: phy1: PDADC (0,   0): a2d4 9c9c9c9c
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC  84 Value 156 | PDADC  85 Value 156 | PDADC  86 Value 156 | PDADC  87 Value 156 |
[  904.410000] ath: phy1: PDADC (0,   0): a2d8 9c9c9c9c
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC  88 Value 156 | PDADC  89 Value 156 | PDADC  90 Value 156 | PDADC  91 Value 156 |
[  904.410000] ath: phy1: PDADC (0,   0): a2dc 9c9c9c9c
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC  92 Value 156 | PDADC  93 Value 156 | PDADC  94 Value 156 | PDADC  95 Value 156 |
[  904.410000] ath: phy1: PDADC (0,   0): a2e0 9c9c9c9c
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC  96 Value 156 | PDADC  97 Value 156 | PDADC  98 Value 156 | PDADC  99 Value 156 |
[  904.410000] ath: phy1: PDADC (0,   0): a2e4 9c9c9c9c
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC 100 Value 156 | PDADC 101 Value 156 | PDADC 102 Value 156 | PDADC 103 Value 156 |
[  904.410000] ath: phy1: PDADC (0,   0): a2e8 9c9c9c9c
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC 104 Value 156 | PDADC 105 Value 156 | PDADC 106 Value 156 | PDADC 107 Value 156 |
[  904.410000] ath: phy1: PDADC (0,   0): a2ec 9c9c9c9c
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC 108 Value 156 | PDADC 109 Value 156 | PDADC 110 Value 156 | PDADC 111 Value 156 |
[  904.410000] ath: phy1: PDADC (0,   0): a2f0 9c9c9c9c
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC 112 Value 156 | PDADC 113 Value 156 | PDADC 114 Value 156 | PDADC 115 Value 156 |
[  904.410000] ath: phy1: PDADC (0,   0): a2f4 9c9c9c9c
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC 116 Value 156 | PDADC 117 Value 156 | PDADC 118 Value 156 | PDADC 119 Value 156 |
[  904.410000] ath: phy1: PDADC (0,   0): a2f8 9c9c9c9c
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC 120 Value 156 | PDADC 121 Value 156 | PDADC 122 Value 156 | PDADC 123 Value 156 |
[  904.410000] ath: phy1: PDADC (0,   0): a2fc 9c9c9c9c
[  904.410000] ath: phy1: PDADC: Chain 0 | PDADC 124 Value 156 | PDADC 125 Value 156 | PDADC 126 Value 156 | PDADC 127 Value 156 |
[  904.410000] ath: phy1: PDADC (1,1000): b280 04030201
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC   0 Value   1 | PDADC   1 Value   2 | PDADC   2 Value   3 | PDADC   3 Value   4 |
[  904.410000] ath: phy1: PDADC (1,1000): b284 07060605
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC   4 Value   5 | PDADC   5 Value   6 | PDADC   6 Value   6 | PDADC   7 Value   7 |
[  904.410000] ath: phy1: PDADC (1,1000): b288 0b0a0908
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  11 |
[  904.410000] ath: phy1: PDADC (1,1000): b28c 0e0d0c0b
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC  12 Value  11 | PDADC  13 Value  12 | PDADC  14 Value  13 | PDADC  15 Value  14 |
[  904.410000] ath: phy1: PDADC (1,1000): b290 1311100f
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC  16 Value  15 | PDADC  17 Value  16 | PDADC  18 Value  17 | PDADC  19 Value  19 |
[  904.410000] ath: phy1: PDADC (1,1000): b294 1b191715
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC  20 Value  21 | PDADC  21 Value  23 | PDADC  22 Value  25 | PDADC  23 Value  27 |
[  904.410000] ath: phy1: PDADC (1,1000): b298 23211f1d
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC  24 Value  29 | PDADC  25 Value  31 | PDADC  26 Value  33 | PDADC  27 Value  35 |
[  904.410000] ath: phy1: PDADC (1,1000): b29c 322e2a26
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC  28 Value  38 | PDADC  29 Value  42 | PDADC  30 Value  46 | PDADC  31 Value  50 |
[  904.410000] ath: phy1: PDADC (1,1000): b2a0 423e3a36
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC  32 Value  54 | PDADC  33 Value  58 | PDADC  34 Value  62 | PDADC  35 Value  66 |
[  904.410000] ath: phy1: PDADC (1,1000): b2a4 534e4a46
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC  36 Value  70 | PDADC  37 Value  74 | PDADC  38 Value  78 | PDADC  39 Value  83 |
[  904.410000] ath: phy1: PDADC (1,1000): b2a8 746b635b
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC  40 Value  91 | PDADC  41 Value  99 | PDADC  42 Value 107 | PDADC  43 Value 116 |
[  904.410000] ath: phy1: PDADC (1,1000): b2ac 948c847c
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC  44 Value 124 | PDADC  45 Value 132 | PDADC  46 Value 140 | PDADC  47 Value 148 |
[  904.410000] ath: phy1: PDADC (1,1000): b2b0 2926239c
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC  48 Value 156 | PDADC  49 Value  35 | PDADC  50 Value  38 | PDADC  51 Value  41 |
[  904.410000] ath: phy1: PDADC (1,1000): b2b4 3834302d
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC  52 Value  45 | PDADC  53 Value  48 | PDADC  54 Value  52 | PDADC  55 Value  56 |
[  904.410000] ath: phy1: PDADC (1,1000): b2b8 4a443f3b
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC  56 Value  59 | PDADC  57 Value  63 | PDADC  58 Value  68 | PDADC  59 Value  74 |
[  904.410000] ath: phy1: PDADC (1,1000): b2bc 645d5750
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC  60 Value  80 | PDADC  61 Value  87 | PDADC  62 Value  93 | PDADC  63 Value 100 |
[  904.410000] ath: phy1: PDADC (1,1000): b2c0 8079726b
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC  64 Value 107 | PDADC  65 Value 114 | PDADC  66 Value 121 | PDADC  67 Value 128 |
[  904.410000] ath: phy1: PDADC (1,1000): b2c4 8e8e8e87
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC  68 Value 135 | PDADC  69 Value 142 | PDADC  70 Value 142 | PDADC  71 Value 142 |
[  904.410000] ath: phy1: PDADC (1,1000): b2c8 8e8e8e8e
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC  72 Value 142 | PDADC  73 Value 142 | PDADC  74 Value 142 | PDADC  75 Value 142 |
[  904.410000] ath: phy1: PDADC (1,1000): b2cc 8e8e8e8e
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC  76 Value 142 | PDADC  77 Value 142 | PDADC  78 Value 142 | PDADC  79 Value 142 |
[  904.410000] ath: phy1: PDADC (1,1000): b2d0 8e8e8e8e
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC  80 Value 142 | PDADC  81 Value 142 | PDADC  82 Value 142 | PDADC  83 Value 142 |
[  904.410000] ath: phy1: PDADC (1,1000): b2d4 8e8e8e8e
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC  84 Value 142 | PDADC  85 Value 142 | PDADC  86 Value 142 | PDADC  87 Value 142 |
[  904.410000] ath: phy1: PDADC (1,1000): b2d8 8e8e8e8e
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC  88 Value 142 | PDADC  89 Value 142 | PDADC  90 Value 142 | PDADC  91 Value 142 |
[  904.410000] ath: phy1: PDADC (1,1000): b2dc 8e8e8e8e
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC  92 Value 142 | PDADC  93 Value 142 | PDADC  94 Value 142 | PDADC  95 Value 142 |
[  904.410000] ath: phy1: PDADC (1,1000): b2e0 8e8e8e8e
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC  96 Value 142 | PDADC  97 Value 142 | PDADC  98 Value 142 | PDADC  99 Value 142 |
[  904.410000] ath: phy1: PDADC (1,1000): b2e4 8e8e8e8e
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC 100 Value 142 | PDADC 101 Value 142 | PDADC 102 Value 142 | PDADC 103 Value 142 |
[  904.410000] ath: phy1: PDADC (1,1000): b2e8 8e8e8e8e
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC 104 Value 142 | PDADC 105 Value 142 | PDADC 106 Value 142 | PDADC 107 Value 142 |
[  904.410000] ath: phy1: PDADC (1,1000): b2ec 8e8e8e8e
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC 108 Value 142 | PDADC 109 Value 142 | PDADC 110 Value 142 | PDADC 111 Value 142 |
[  904.410000] ath: phy1: PDADC (1,1000): b2f0 8e8e8e8e
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC 112 Value 142 | PDADC 113 Value 142 | PDADC 114 Value 142 | PDADC 115 Value 142 |
[  904.410000] ath: phy1: PDADC (1,1000): b2f4 8e8e8e8e
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC 116 Value 142 | PDADC 117 Value 142 | PDADC 118 Value 142 | PDADC 119 Value 142 |
[  904.410000] ath: phy1: PDADC (1,1000): b2f8 8e8e8e8e
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC 120 Value 142 | PDADC 121 Value 142 | PDADC 122 Value 142 | PDADC 123 Value 142 |
[  904.410000] ath: phy1: PDADC (1,1000): b2fc 8e8e8e8e
[  904.410000] ath: phy1: PDADC: Chain 1 | PDADC 124 Value 142 | PDADC 125 Value 142 | PDADC 126 Value 142 | PDADC 127 Value 142 |
[  904.410000] ath: phy1: Reset TX queue: 0
[  904.410000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.410000] ath: phy1: Reset TX queue: 1
[  904.410000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.410000] ath: phy1: Reset TX queue: 2
[  904.410000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.410000] ath: phy1: Reset TX queue: 3
[  904.410000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.410000] ath: phy1: Reset TXQ, inactive queue: 4
[  904.410000] ath: phy1: Reset TXQ, inactive queue: 5
[  904.410000] ath: phy1: Reset TXQ, inactive queue: 6
[  904.410000] ath: phy1: Reset TX queue: 7
[  904.410000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.410000] ath: phy1: Reset TX queue: 8
[  904.410000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.410000] ath: phy1: Reset TX queue: 9
[  904.410000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.410000] ath: phy1: ver 128.2 opmode 2 chan 5895 Mhz
[  904.410000] ath: phy1: ah->misc_mode 0x4
[  904.410000] ath: phy1: enabling ADC Gain Calibration
[  904.410000] ath: phy1: enabling ADC DC Calibration
[  904.410000] ath: phy1: enabling IQ Calibration
[  904.410000] ath: phy1: starting ADC Gain Calibration
[  904.410000] ath: phy1: New interrupt mask 0xd0000071
[  904.410000] ath: phy1: new IMR 0x918004b0
[  904.410000] ath: phy1: macaddr: 00:80:48:75:e8:7a, bssid: 00:00:00:00:00:00, bssidmask: ff:ff:ff:ff:ff:ff
[  904.410000] ath: phy1: Enable MIB counters
[  904.410000] ath: phy1: Restore history: opmode 2 chan 5895 Mhz is_scanning=0 ofdm:3 cck:2
[  904.410000] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[  904.410000] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[  904.410000] ath: phy1: New interrupt mask 0xd0000071
[  904.410000] ath: phy1: new IMR 0x918004b0
[  904.410000] ath: phy1: enable IER
[  904.410000] ath: phy1: AR_IMR 0x918004b0 IER 0x1
[  904.410000] ath: phy1: Attach a VIF of type: 3
[  904.410000] ath: phy1: Added interface at beacon slot: 0
[  904.410000] ath: phy1: New interrupt mask 0xd0000071
[  904.410000] ath: phy1: new IMR 0x918004b0
[  904.420000] ath: phy1: ah->misc_mode 0xc
[  904.420000] ath: phy1: macaddr: 00:80:48:75:e8:7a, bssid: 00:00:00:00:00:00, bssidmask: ff:ff:ff:ff:ff:ff
[  904.420000] ath: phy1: PDADC (0,   0): a280 03020100
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC   0 Value   0 | PDADC   1 Value   1 | PDADC   2 Value   2 | PDADC   3 Value   3 |
[  904.420000] ath: phy1: PDADC (0,   0): a284 07060504
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC   4 Value   4 | PDADC   5 Value   5 | PDADC   6 Value   6 | PDADC   7 Value   7 |
[  904.420000] ath: phy1: PDADC (0,   0): a288 0c0a0908
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  12 |
[  904.420000] ath: phy1: PDADC (0,   0): a28c 11100e0d
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  12 Value  13 | PDADC  13 Value  14 | PDADC  14 Value  16 | PDADC  15 Value  17 |
[  904.420000] ath: phy1: PDADC (0,   0): a290 16151412
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  16 Value  18 | PDADC  17 Value  20 | PDADC  18 Value  21 | PDADC  19 Value  22 |
[  904.420000] ath: phy1: PDADC (0,   0): a294 1f1d1a18
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  20 Value  24 | PDADC  21 Value  26 | PDADC  22 Value  29 | PDADC  23 Value  31 |
[  904.420000] ath: phy1: PDADC (0,   0): a298 2a282522
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  24 Value  34 | PDADC  25 Value  37 | PDADC  26 Value  40 | PDADC  27 Value  42 |
[  904.420000] ath: phy1: PDADC (0,   0): a29c 3633302d
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  28 Value  45 | PDADC  29 Value  48 | PDADC  30 Value  51 | PDADC  31 Value  54 |
[  904.420000] ath: phy1: PDADC (0,   0): a2a0 4c46413b
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  32 Value  59 | PDADC  33 Value  65 | PDADC  34 Value  70 | PDADC  35 Value  76 |
[  904.420000] ath: phy1: PDADC (0,   0): a2a4 625d5752
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  36 Value  82 | PDADC  37 Value  87 | PDADC  38 Value  93 | PDADC  39 Value  98 |
[  904.420000] ath: phy1: PDADC (0,   0): a2a8 7b746e68
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  40 Value 104 | PDADC  41 Value 110 | PDADC  42 Value 116 | PDADC  43 Value 123 |
[  904.420000] ath: phy1: PDADC (0,   0): a2ac 968f8882
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  44 Value 130 | PDADC  45 Value 136 | PDADC  46 Value 143 | PDADC  47 Value 150 |
[  904.420000] ath: phy1: PDADC (0,   0): a2b0 332f2bab
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  48 Value 171 | PDADC  49 Value  43 | PDADC  50 Value  47 | PDADC  51 Value  51 |
[  904.420000] ath: phy1: PDADC (0,   0): a2b4 433f3b37
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  52 Value  55 | PDADC  53 Value  59 | PDADC  54 Value  63 | PDADC  55 Value  67 |
[  904.420000] ath: phy1: PDADC (0,   0): a2b8 59534d47
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  56 Value  71 | PDADC  57 Value  77 | PDADC  58 Value  83 | PDADC  59 Value  89 |
[  904.420000] ath: phy1: PDADC (0,   0): a2bc 726c655f
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  60 Value  95 | PDADC  61 Value 101 | PDADC  62 Value 108 | PDADC  63 Value 114 |
[  904.420000] ath: phy1: PDADC (0,   0): a2c0 8a847e78
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  64 Value 120 | PDADC  65 Value 126 | PDADC  66 Value 132 | PDADC  67 Value 138 |
[  904.420000] ath: phy1: PDADC (0,   0): a2c4 9c9c9690
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  68 Value 144 | PDADC  69 Value 150 | PDADC  70 Value 156 | PDADC  71 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2c8 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  72 Value 156 | PDADC  73 Value 156 | PDADC  74 Value 156 | PDADC  75 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2cc 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  76 Value 156 | PDADC  77 Value 156 | PDADC  78 Value 156 | PDADC  79 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2d0 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  80 Value 156 | PDADC  81 Value 156 | PDADC  82 Value 156 | PDADC  83 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2d4 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  84 Value 156 | PDADC  85 Value 156 | PDADC  86 Value 156 | PDADC  87 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2d8 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  88 Value 156 | PDADC  89 Value 156 | PDADC  90 Value 156 | PDADC  91 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2dc 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  92 Value 156 | PDADC  93 Value 156 | PDADC  94 Value 156 | PDADC  95 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2e0 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  96 Value 156 | PDADC  97 Value 156 | PDADC  98 Value 156 | PDADC  99 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2e4 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC 100 Value 156 | PDADC 101 Value 156 | PDADC 102 Value 156 | PDADC 103 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2e8 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC 104 Value 156 | PDADC 105 Value 156 | PDADC 106 Value 156 | PDADC 107 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2ec 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC 108 Value 156 | PDADC 109 Value 156 | PDADC 110 Value 156 | PDADC 111 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2f0 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC 112 Value 156 | PDADC 113 Value 156 | PDADC 114 Value 156 | PDADC 115 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2f4 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC 116 Value 156 | PDADC 117 Value 156 | PDADC 118 Value 156 | PDADC 119 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2f8 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC 120 Value 156 | PDADC 121 Value 156 | PDADC 122 Value 156 | PDADC 123 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2fc 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC 124 Value 156 | PDADC 125 Value 156 | PDADC 126 Value 156 | PDADC 127 Value 156 |
[  904.420000] ath: phy1: PDADC (1,1000): b280 04030201
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC   0 Value   1 | PDADC   1 Value   2 | PDADC   2 Value   3 | PDADC   3 Value   4 |
[  904.420000] ath: phy1: PDADC (1,1000): b284 07060605
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC   4 Value   5 | PDADC   5 Value   6 | PDADC   6 Value   6 | PDADC   7 Value   7 |
[  904.420000] ath: phy1: PDADC (1,1000): b288 0b0a0908
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  11 |
[  904.420000] ath: phy1: PDADC (1,1000): b28c 0e0d0c0b
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC  12 Value  11 | PDADC  13 Value  12 | PDADC  14 Value  13 | PDADC  15 Value  14 |
[  904.420000] ath: phy1: PDADC (1,1000): b290 1311100f
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC  16 Value  15 | PDADC  17 Value  16 | PDADC  18 Value  17 | PDADC  19 Value  19 |
[  904.420000] ath: phy1: PDADC (1,1000): b294 1b191715
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC  20 Value  21 | PDADC  21 Value  23 | PDADC  22 Value  25 | PDADC  23 Value  27 |
[  904.420000] ath: phy1: PDADC (1,1000): b298 23211f1d
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC  24 Value  29 | PDADC  25 Value  31 | PDADC  26 Value  33 | PDADC  27 Value  35 |
[  904.420000] ath: phy1: PDADC (1,1000): b29c 322e2a26
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC  28 Value  38 | PDADC  29 Value  42 | PDADC  30 Value  46 | PDADC  31 Value  50 |
[  904.420000] ath: phy1: PDADC (1,1000): b2a0 423e3a36
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC  32 Value  54 | PDADC  33 Value  58 | PDADC  34 Value  62 | PDADC  35 Value  66 |
[  904.420000] ath: phy1: PDADC (1,1000): b2a4 534e4a46
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC  36 Value  70 | PDADC  37 Value  74 | PDADC  38 Value  78 | PDADC  39 Value  83 |
[  904.420000] ath: phy1: PDADC (1,1000): b2a8 746b635b
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC  40 Value  91 | PDADC  41 Value  99 | PDADC  42 Value 107 | PDADC  43 Value 116 |
[  904.420000] ath: phy1: PDADC (1,1000): b2ac 948c847c
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC  44 Value 124 | PDADC  45 Value 132 | PDADC  46 Value 140 | PDADC  47 Value 148 |
[  904.420000] ath: phy1: PDADC (1,1000): b2b0 2926239c
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC  48 Value 156 | PDADC  49 Value  35 | PDADC  50 Value  38 | PDADC  51 Value  41 |
[  904.420000] ath: phy1: PDADC (1,1000): b2b4 3834302d
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC  52 Value  45 | PDADC  53 Value  48 | PDADC  54 Value  52 | PDADC  55 Value  56 |
[  904.420000] ath: phy1: PDADC (1,1000): b2b8 4a443f3b
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC  56 Value  59 | PDADC  57 Value  63 | PDADC  58 Value  68 | PDADC  59 Value  74 |
[  904.420000] ath: phy1: PDADC (1,1000): b2bc 645d5750
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC  60 Value  80 | PDADC  61 Value  87 | PDADC  62 Value  93 | PDADC  63 Value 100 |
[  904.420000] ath: phy1: PDADC (1,1000): b2c0 8079726b
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC  64 Value 107 | PDADC  65 Value 114 | PDADC  66 Value 121 | PDADC  67 Value 128 |
[  904.420000] ath: phy1: PDADC (1,1000): b2c4 8e8e8e87
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC  68 Value 135 | PDADC  69 Value 142 | PDADC  70 Value 142 | PDADC  71 Value 142 |
[  904.420000] ath: phy1: PDADC (1,1000): b2c8 8e8e8e8e
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC  72 Value 142 | PDADC  73 Value 142 | PDADC  74 Value 142 | PDADC  75 Value 142 |
[  904.420000] ath: phy1: PDADC (1,1000): b2cc 8e8e8e8e
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC  76 Value 142 | PDADC  77 Value 142 | PDADC  78 Value 142 | PDADC  79 Value 142 |
[  904.420000] ath: phy1: PDADC (1,1000): b2d0 8e8e8e8e
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC  80 Value 142 | PDADC  81 Value 142 | PDADC  82 Value 142 | PDADC  83 Value 142 |
[  904.420000] ath: phy1: PDADC (1,1000): b2d4 8e8e8e8e
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC  84 Value 142 | PDADC  85 Value 142 | PDADC  86 Value 142 | PDADC  87 Value 142 |
[  904.420000] ath: phy1: PDADC (1,1000): b2d8 8e8e8e8e
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC  88 Value 142 | PDADC  89 Value 142 | PDADC  90 Value 142 | PDADC  91 Value 142 |
[  904.420000] ath: phy1: PDADC (1,1000): b2dc 8e8e8e8e
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC  92 Value 142 | PDADC  93 Value 142 | PDADC  94 Value 142 | PDADC  95 Value 142 |
[  904.420000] ath: phy1: PDADC (1,1000): b2e0 8e8e8e8e
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC  96 Value 142 | PDADC  97 Value 142 | PDADC  98 Value 142 | PDADC  99 Value 142 |
[  904.420000] ath: phy1: PDADC (1,1000): b2e4 8e8e8e8e
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC 100 Value 142 | PDADC 101 Value 142 | PDADC 102 Value 142 | PDADC 103 Value 142 |
[  904.420000] ath: phy1: PDADC (1,1000): b2e8 8e8e8e8e
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC 104 Value 142 | PDADC 105 Value 142 | PDADC 106 Value 142 | PDADC 107 Value 142 |
[  904.420000] ath: phy1: PDADC (1,1000): b2ec 8e8e8e8e
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC 108 Value 142 | PDADC 109 Value 142 | PDADC 110 Value 142 | PDADC 111 Value 142 |
[  904.420000] ath: phy1: PDADC (1,1000): b2f0 8e8e8e8e
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC 112 Value 142 | PDADC 113 Value 142 | PDADC 114 Value 142 | PDADC 115 Value 142 |
[  904.420000] ath: phy1: PDADC (1,1000): b2f4 8e8e8e8e
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC 116 Value 142 | PDADC 117 Value 142 | PDADC 118 Value 142 | PDADC 119 Value 142 |
[  904.420000] ath: phy1: PDADC (1,1000): b2f8 8e8e8e8e
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC 120 Value 142 | PDADC 121 Value 142 | PDADC 122 Value 142 | PDADC 123 Value 142 |
[  904.420000] ath: phy1: PDADC (1,1000): b2fc 8e8e8e8e
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC 124 Value 142 | PDADC 125 Value 142 | PDADC 126 Value 142 | PDADC 127 Value 142 |
[  904.420000] ath: phy1: Set HW RX filter: 0x4097
[  904.420000] ath: phy1: Configure tx [queue/halq] [0/3], aifs: 2, cw_min: 3, cw_max: 7, txop: 47
[  904.420000] ath: phy1: Set queue properties for: 3
[  904.420000] ath: phy1: Reset TX queue: 3
[  904.420000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.420000] ath: phy1: Configure tx [queue/halq] [1/2], aifs: 2, cw_min: 7, cw_max: 15, txop: 94
[  904.420000] ath: phy1: Set queue properties for: 2
[  904.420000] ath: phy1: Reset TX queue: 2
[  904.420000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.420000] ath: phy1: Configure tx [queue/halq] [2/1], aifs: 3, cw_min: 15, cw_max: 1023, txop: 0
[  904.420000] ath: phy1: Set queue properties for: 1
[  904.420000] ath: phy1: Reset TX queue: 1
[  904.420000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.420000] ath: phy1: Configure tx [queue/halq] [3/0], aifs: 7, cw_min: 15, cw_max: 1023, txop: 0
[  904.420000] ath: phy1: Set queue properties for: 0
[  904.420000] ath: phy1: Reset TX queue: 0
[  904.420000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.420000] ath: phy1: PowerSave disabled
[  904.420000] ath: phy1: Monitor mode is disabled
[  904.420000] ath: phy1: Set channel: 5895 MHz width: 0
[  904.420000] ath: phy1: disable IER
[  904.420000] ath: phy1: Stopping ANI
[  904.420000] ath: phy1: disable IER
[  904.420000] ath: phy1: Disable MIB counters
[  904.420000] ath: phy1: Reset to 5895 MHz, HT40: 0 fastcc: 0
[  904.420000] ath: phy1: NF did not complete in calibration window
[  904.420000] ath: phy1: PDADC (0,   0): a280 03020100
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC   0 Value   0 | PDADC   1 Value   1 | PDADC   2 Value   2 | PDADC   3 Value   3 |
[  904.420000] ath: phy1: PDADC (0,   0): a284 07060504
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC   4 Value   4 | PDADC   5 Value   5 | PDADC   6 Value   6 | PDADC   7 Value   7 |
[  904.420000] ath: phy1: PDADC (0,   0): a288 0c0a0908
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  12 |
[  904.420000] ath: phy1: PDADC (0,   0): a28c 11100e0d
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  12 Value  13 | PDADC  13 Value  14 | PDADC  14 Value  16 | PDADC  15 Value  17 |
[  904.420000] ath: phy1: PDADC (0,   0): a290 16151412
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  16 Value  18 | PDADC  17 Value  20 | PDADC  18 Value  21 | PDADC  19 Value  22 |
[  904.420000] ath: phy1: PDADC (0,   0): a294 1f1d1a18
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  20 Value  24 | PDADC  21 Value  26 | PDADC  22 Value  29 | PDADC  23 Value  31 |
[  904.420000] ath: phy1: PDADC (0,   0): a298 2a282522
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  24 Value  34 | PDADC  25 Value  37 | PDADC  26 Value  40 | PDADC  27 Value  42 |
[  904.420000] ath: phy1: PDADC (0,   0): a29c 3633302d
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  28 Value  45 | PDADC  29 Value  48 | PDADC  30 Value  51 | PDADC  31 Value  54 |
[  904.420000] ath: phy1: PDADC (0,   0): a2a0 4c46413b
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  32 Value  59 | PDADC  33 Value  65 | PDADC  34 Value  70 | PDADC  35 Value  76 |
[  904.420000] ath: phy1: PDADC (0,   0): a2a4 625d5752
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  36 Value  82 | PDADC  37 Value  87 | PDADC  38 Value  93 | PDADC  39 Value  98 |
[  904.420000] ath: phy1: PDADC (0,   0): a2a8 7b746e68
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  40 Value 104 | PDADC  41 Value 110 | PDADC  42 Value 116 | PDADC  43 Value 123 |
[  904.420000] ath: phy1: PDADC (0,   0): a2ac 968f8882
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  44 Value 130 | PDADC  45 Value 136 | PDADC  46 Value 143 | PDADC  47 Value 150 |
[  904.420000] ath: phy1: PDADC (0,   0): a2b0 332f2bab
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  48 Value 171 | PDADC  49 Value  43 | PDADC  50 Value  47 | PDADC  51 Value  51 |
[  904.420000] ath: phy1: PDADC (0,   0): a2b4 433f3b37
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  52 Value  55 | PDADC  53 Value  59 | PDADC  54 Value  63 | PDADC  55 Value  67 |
[  904.420000] ath: phy1: PDADC (0,   0): a2b8 59534d47
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  56 Value  71 | PDADC  57 Value  77 | PDADC  58 Value  83 | PDADC  59 Value  89 |
[  904.420000] ath: phy1: PDADC (0,   0): a2bc 726c655f
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  60 Value  95 | PDADC  61 Value 101 | PDADC  62 Value 108 | PDADC  63 Value 114 |
[  904.420000] ath: phy1: PDADC (0,   0): a2c0 8a847e78
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  64 Value 120 | PDADC  65 Value 126 | PDADC  66 Value 132 | PDADC  67 Value 138 |
[  904.420000] ath: phy1: PDADC (0,   0): a2c4 9c9c9690
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  68 Value 144 | PDADC  69 Value 150 | PDADC  70 Value 156 | PDADC  71 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2c8 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  72 Value 156 | PDADC  73 Value 156 | PDADC  74 Value 156 | PDADC  75 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2cc 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  76 Value 156 | PDADC  77 Value 156 | PDADC  78 Value 156 | PDADC  79 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2d0 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  80 Value 156 | PDADC  81 Value 156 | PDADC  82 Value 156 | PDADC  83 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2d4 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  84 Value 156 | PDADC  85 Value 156 | PDADC  86 Value 156 | PDADC  87 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2d8 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  88 Value 156 | PDADC  89 Value 156 | PDADC  90 Value 156 | PDADC  91 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2dc 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  92 Value 156 | PDADC  93 Value 156 | PDADC  94 Value 156 | PDADC  95 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2e0 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC  96 Value 156 | PDADC  97 Value 156 | PDADC  98 Value 156 | PDADC  99 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2e4 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC 100 Value 156 | PDADC 101 Value 156 | PDADC 102 Value 156 | PDADC 103 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2e8 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC 104 Value 156 | PDADC 105 Value 156 | PDADC 106 Value 156 | PDADC 107 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2ec 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC 108 Value 156 | PDADC 109 Value 156 | PDADC 110 Value 156 | PDADC 111 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2f0 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC 112 Value 156 | PDADC 113 Value 156 | PDADC 114 Value 156 | PDADC 115 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2f4 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC 116 Value 156 | PDADC 117 Value 156 | PDADC 118 Value 156 | PDADC 119 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2f8 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC 120 Value 156 | PDADC 121 Value 156 | PDADC 122 Value 156 | PDADC 123 Value 156 |
[  904.420000] ath: phy1: PDADC (0,   0): a2fc 9c9c9c9c
[  904.420000] ath: phy1: PDADC: Chain 0 | PDADC 124 Value 156 | PDADC 125 Value 156 | PDADC 126 Value 156 | PDADC 127 Value 156 |
[  904.420000] ath: phy1: PDADC (1,1000): b280 04030201
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC   0 Value   1 | PDADC   1 Value   2 | PDADC   2 Value   3 | PDADC   3 Value   4 |
[  904.420000] ath: phy1: PDADC (1,1000): b284 07060605
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC   4 Value   5 | PDADC   5 Value   6 | PDADC   6 Value   6 | PDADC   7 Value   7 |
[  904.420000] ath: phy1: PDADC (1,1000): b288 0b0a0908
[  904.420000] ath: phy1: PDADC: Chain 1 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  11 |
[  904.430000] ath: phy1: PDADC (1,1000): b28c 0e0d0c0b
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC  12 Value  11 | PDADC  13 Value  12 | PDADC  14 Value  13 | PDADC  15 Value  14 |
[  904.430000] ath: phy1: PDADC (1,1000): b290 1311100f
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC  16 Value  15 | PDADC  17 Value  16 | PDADC  18 Value  17 | PDADC  19 Value  19 |
[  904.430000] ath: phy1: PDADC (1,1000): b294 1b191715
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC  20 Value  21 | PDADC  21 Value  23 | PDADC  22 Value  25 | PDADC  23 Value  27 |
[  904.430000] ath: phy1: PDADC (1,1000): b298 23211f1d
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC  24 Value  29 | PDADC  25 Value  31 | PDADC  26 Value  33 | PDADC  27 Value  35 |
[  904.430000] ath: phy1: PDADC (1,1000): b29c 322e2a26
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC  28 Value  38 | PDADC  29 Value  42 | PDADC  30 Value  46 | PDADC  31 Value  50 |
[  904.430000] ath: phy1: PDADC (1,1000): b2a0 423e3a36
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC  32 Value  54 | PDADC  33 Value  58 | PDADC  34 Value  62 | PDADC  35 Value  66 |
[  904.430000] ath: phy1: PDADC (1,1000): b2a4 534e4a46
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC  36 Value  70 | PDADC  37 Value  74 | PDADC  38 Value  78 | PDADC  39 Value  83 |
[  904.430000] ath: phy1: PDADC (1,1000): b2a8 746b635b
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC  40 Value  91 | PDADC  41 Value  99 | PDADC  42 Value 107 | PDADC  43 Value 116 |
[  904.430000] ath: phy1: PDADC (1,1000): b2ac 948c847c
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC  44 Value 124 | PDADC  45 Value 132 | PDADC  46 Value 140 | PDADC  47 Value 148 |
[  904.430000] ath: phy1: PDADC (1,1000): b2b0 2926239c
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC  48 Value 156 | PDADC  49 Value  35 | PDADC  50 Value  38 | PDADC  51 Value  41 |
[  904.430000] ath: phy1: PDADC (1,1000): b2b4 3834302d
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC  52 Value  45 | PDADC  53 Value  48 | PDADC  54 Value  52 | PDADC  55 Value  56 |
[  904.430000] ath: phy1: PDADC (1,1000): b2b8 4a443f3b
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC  56 Value  59 | PDADC  57 Value  63 | PDADC  58 Value  68 | PDADC  59 Value  74 |
[  904.430000] ath: phy1: PDADC (1,1000): b2bc 645d5750
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC  60 Value  80 | PDADC  61 Value  87 | PDADC  62 Value  93 | PDADC  63 Value 100 |
[  904.430000] ath: phy1: PDADC (1,1000): b2c0 8079726b
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC  64 Value 107 | PDADC  65 Value 114 | PDADC  66 Value 121 | PDADC  67 Value 128 |
[  904.430000] ath: phy1: PDADC (1,1000): b2c4 8e8e8e87
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC  68 Value 135 | PDADC  69 Value 142 | PDADC  70 Value 142 | PDADC  71 Value 142 |
[  904.430000] ath: phy1: PDADC (1,1000): b2c8 8e8e8e8e
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC  72 Value 142 | PDADC  73 Value 142 | PDADC  74 Value 142 | PDADC  75 Value 142 |
[  904.430000] ath: phy1: PDADC (1,1000): b2cc 8e8e8e8e
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC  76 Value 142 | PDADC  77 Value 142 | PDADC  78 Value 142 | PDADC  79 Value 142 |
[  904.430000] ath: phy1: PDADC (1,1000): b2d0 8e8e8e8e
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC  80 Value 142 | PDADC  81 Value 142 | PDADC  82 Value 142 | PDADC  83 Value 142 |
[  904.430000] ath: phy1: PDADC (1,1000): b2d4 8e8e8e8e
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC  84 Value 142 | PDADC  85 Value 142 | PDADC  86 Value 142 | PDADC  87 Value 142 |
[  904.430000] ath: phy1: PDADC (1,1000): b2d8 8e8e8e8e
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC  88 Value 142 | PDADC  89 Value 142 | PDADC  90 Value 142 | PDADC  91 Value 142 |
[  904.430000] ath: phy1: PDADC (1,1000): b2dc 8e8e8e8e
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC  92 Value 142 | PDADC  93 Value 142 | PDADC  94 Value 142 | PDADC  95 Value 142 |
[  904.430000] ath: phy1: PDADC (1,1000): b2e0 8e8e8e8e
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC  96 Value 142 | PDADC  97 Value 142 | PDADC  98 Value 142 | PDADC  99 Value 142 |
[  904.430000] ath: phy1: PDADC (1,1000): b2e4 8e8e8e8e
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC 100 Value 142 | PDADC 101 Value 142 | PDADC 102 Value 142 | PDADC 103 Value 142 |
[  904.430000] ath: phy1: PDADC (1,1000): b2e8 8e8e8e8e
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC 104 Value 142 | PDADC 105 Value 142 | PDADC 106 Value 142 | PDADC 107 Value 142 |
[  904.430000] ath: phy1: PDADC (1,1000): b2ec 8e8e8e8e
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC 108 Value 142 | PDADC 109 Value 142 | PDADC 110 Value 142 | PDADC 111 Value 142 |
[  904.430000] ath: phy1: PDADC (1,1000): b2f0 8e8e8e8e
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC 112 Value 142 | PDADC 113 Value 142 | PDADC 114 Value 142 | PDADC 115 Value 142 |
[  904.430000] ath: phy1: PDADC (1,1000): b2f4 8e8e8e8e
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC 116 Value 142 | PDADC 117 Value 142 | PDADC 118 Value 142 | PDADC 119 Value 142 |
[  904.430000] ath: phy1: PDADC (1,1000): b2f8 8e8e8e8e
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC 120 Value 142 | PDADC 121 Value 142 | PDADC 122 Value 142 | PDADC 123 Value 142 |
[  904.430000] ath: phy1: PDADC (1,1000): b2fc 8e8e8e8e
[  904.430000] ath: phy1: PDADC: Chain 1 | PDADC 124 Value 142 | PDADC 125 Value 142 | PDADC 126 Value 142 | PDADC 127 Value 142 |
[  904.430000] ath: phy1: Reset TX queue: 0
[  904.430000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.430000] ath: phy1: Reset TX queue: 1
[  904.430000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.430000] ath: phy1: Reset TX queue: 2
[  904.430000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.430000] ath: phy1: Reset TX queue: 3
[  904.430000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.430000] ath: phy1: Reset TXQ, inactive queue: 4
[  904.430000] ath: phy1: Reset TXQ, inactive queue: 5
[  904.430000] ath: phy1: Reset TXQ, inactive queue: 6
[  904.430000] ath: phy1: Reset TX queue: 7
[  904.430000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.430000] ath: phy1: Reset TX queue: 8
[  904.430000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.430000] ath: phy1: Reset TX queue: 9
[  904.430000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.430000] ath: phy1: ver 128.2 opmode 3 chan 5895 Mhz
[  904.430000] ath: phy1: ah->misc_mode 0xc
[  904.430000] ath: phy1: enabling ADC Gain Calibration
[  904.430000] ath: phy1: enabling ADC DC Calibration
[  904.430000] ath: phy1: enabling IQ Calibration
[  904.430000] ath: phy1: starting ADC Gain Calibration
[  904.430000] ath: phy1: New interrupt mask 0xd0000071
[  904.430000] ath: phy1: new IMR 0x918004b0
[  904.430000] ath: phy1: macaddr: 00:80:48:75:e8:7a, bssid: 00:00:00:00:00:00, bssidmask: ff:ff:ff:ff:ff:ff
[  904.430000] ath: phy1: Enable MIB counters
[  904.430000] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
[  904.430000] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
[  904.430000] ath: phy1: New interrupt mask 0xd0000071
[  904.430000] ath: phy1: new IMR 0x918004b0
[  904.430000] ath: phy1: enable IER
[  904.430000] ath: phy1: AR_IMR 0x918004b0 IER 0x1
[  904.430000] ath: phy1: Set HW RX filter: 0x4097
[  904.430000] ath: phy1: Set HW RX filter: 0x4097
[  904.460000] ath: phy1: Set HW RX filter: 0x4097
[  904.470000] ath: phy1: Set HW RX filter: 0x4097
[  904.510000] ath: phy1: Set HW RX filter: 0x4097
[  904.510000] ath: phy1: Set HW RX filter: 0x4097
[  904.550000] ath: phy1: Set HW RX filter: 0x4097
[  904.550000] ath: phy1: Detach Interface
[  904.550000] ath: phy1: Removing interface at beacon slot: 0
[  904.550000] ath: phy1: New interrupt mask 0xd0000071
[  904.550000] ath: phy1: new IMR 0x918004b0
[  904.550000] ath: phy1: ah->misc_mode 0x4
[  904.550000] ath: phy1: macaddr: 00:80:48:75:e8:7a, bssid: 00:00:00:00:00:00, bssidmask: ff:ff:ff:ff:ff:ff
[  904.550000] ath: phy1: PDADC (0,   0): a280 03020100
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC   0 Value   0 | PDADC   1 Value   1 | PDADC   2 Value   2 | PDADC   3 Value   3 |
[  904.550000] ath: phy1: PDADC (0,   0): a284 07060504
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC   4 Value   4 | PDADC   5 Value   5 | PDADC   6 Value   6 | PDADC   7 Value   7 |
[  904.550000] ath: phy1: PDADC (0,   0): a288 0c0a0908
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  12 |
[  904.550000] ath: phy1: PDADC (0,   0): a28c 11100e0d
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  12 Value  13 | PDADC  13 Value  14 | PDADC  14 Value  16 | PDADC  15 Value  17 |
[  904.550000] ath: phy1: PDADC (0,   0): a290 16151412
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  16 Value  18 | PDADC  17 Value  20 | PDADC  18 Value  21 | PDADC  19 Value  22 |
[  904.550000] ath: phy1: PDADC (0,   0): a294 1f1d1a18
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  20 Value  24 | PDADC  21 Value  26 | PDADC  22 Value  29 | PDADC  23 Value  31 |
[  904.550000] ath: phy1: PDADC (0,   0): a298 2a282522
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  24 Value  34 | PDADC  25 Value  37 | PDADC  26 Value  40 | PDADC  27 Value  42 |
[  904.550000] ath: phy1: PDADC (0,   0): a29c 3633302d
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  28 Value  45 | PDADC  29 Value  48 | PDADC  30 Value  51 | PDADC  31 Value  54 |
[  904.550000] ath: phy1: PDADC (0,   0): a2a0 4c46413b
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  32 Value  59 | PDADC  33 Value  65 | PDADC  34 Value  70 | PDADC  35 Value  76 |
[  904.550000] ath: phy1: PDADC (0,   0): a2a4 625d5752
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  36 Value  82 | PDADC  37 Value  87 | PDADC  38 Value  93 | PDADC  39 Value  98 |
[  904.550000] ath: phy1: PDADC (0,   0): a2a8 7b746e68
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  40 Value 104 | PDADC  41 Value 110 | PDADC  42 Value 116 | PDADC  43 Value 123 |
[  904.550000] ath: phy1: PDADC (0,   0): a2ac 968f8882
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  44 Value 130 | PDADC  45 Value 136 | PDADC  46 Value 143 | PDADC  47 Value 150 |
[  904.550000] ath: phy1: PDADC (0,   0): a2b0 332f2bab
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  48 Value 171 | PDADC  49 Value  43 | PDADC  50 Value  47 | PDADC  51 Value  51 |
[  904.550000] ath: phy1: PDADC (0,   0): a2b4 433f3b37
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  52 Value  55 | PDADC  53 Value  59 | PDADC  54 Value  63 | PDADC  55 Value  67 |
[  904.550000] ath: phy1: PDADC (0,   0): a2b8 59534d47
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  56 Value  71 | PDADC  57 Value  77 | PDADC  58 Value  83 | PDADC  59 Value  89 |
[  904.550000] ath: phy1: PDADC (0,   0): a2bc 726c655f
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  60 Value  95 | PDADC  61 Value 101 | PDADC  62 Value 108 | PDADC  63 Value 114 |
[  904.550000] ath: phy1: PDADC (0,   0): a2c0 8a847e78
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  64 Value 120 | PDADC  65 Value 126 | PDADC  66 Value 132 | PDADC  67 Value 138 |
[  904.550000] ath: phy1: PDADC (0,   0): a2c4 9c9c9690
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  68 Value 144 | PDADC  69 Value 150 | PDADC  70 Value 156 | PDADC  71 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2c8 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  72 Value 156 | PDADC  73 Value 156 | PDADC  74 Value 156 | PDADC  75 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2cc 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  76 Value 156 | PDADC  77 Value 156 | PDADC  78 Value 156 | PDADC  79 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2d0 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  80 Value 156 | PDADC  81 Value 156 | PDADC  82 Value 156 | PDADC  83 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2d4 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  84 Value 156 | PDADC  85 Value 156 | PDADC  86 Value 156 | PDADC  87 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2d8 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  88 Value 156 | PDADC  89 Value 156 | PDADC  90 Value 156 | PDADC  91 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2dc 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  92 Value 156 | PDADC  93 Value 156 | PDADC  94 Value 156 | PDADC  95 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2e0 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  96 Value 156 | PDADC  97 Value 156 | PDADC  98 Value 156 | PDADC  99 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2e4 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC 100 Value 156 | PDADC 101 Value 156 | PDADC 102 Value 156 | PDADC 103 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2e8 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC 104 Value 156 | PDADC 105 Value 156 | PDADC 106 Value 156 | PDADC 107 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2ec 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC 108 Value 156 | PDADC 109 Value 156 | PDADC 110 Value 156 | PDADC 111 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2f0 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC 112 Value 156 | PDADC 113 Value 156 | PDADC 114 Value 156 | PDADC 115 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2f4 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC 116 Value 156 | PDADC 117 Value 156 | PDADC 118 Value 156 | PDADC 119 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2f8 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC 120 Value 156 | PDADC 121 Value 156 | PDADC 122 Value 156 | PDADC 123 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2fc 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC 124 Value 156 | PDADC 125 Value 156 | PDADC 126 Value 156 | PDADC 127 Value 156 |
[  904.550000] ath: phy1: PDADC (1,1000): b280 04030201
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC   0 Value   1 | PDADC   1 Value   2 | PDADC   2 Value   3 | PDADC   3 Value   4 |
[  904.550000] ath: phy1: PDADC (1,1000): b284 07060605
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC   4 Value   5 | PDADC   5 Value   6 | PDADC   6 Value   6 | PDADC   7 Value   7 |
[  904.550000] ath: phy1: PDADC (1,1000): b288 0b0a0908
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  11 |
[  904.550000] ath: phy1: PDADC (1,1000): b28c 0e0d0c0b
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  12 Value  11 | PDADC  13 Value  12 | PDADC  14 Value  13 | PDADC  15 Value  14 |
[  904.550000] ath: phy1: PDADC (1,1000): b290 1311100f
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  16 Value  15 | PDADC  17 Value  16 | PDADC  18 Value  17 | PDADC  19 Value  19 |
[  904.550000] ath: phy1: PDADC (1,1000): b294 1b191715
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  20 Value  21 | PDADC  21 Value  23 | PDADC  22 Value  25 | PDADC  23 Value  27 |
[  904.550000] ath: phy1: PDADC (1,1000): b298 23211f1d
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  24 Value  29 | PDADC  25 Value  31 | PDADC  26 Value  33 | PDADC  27 Value  35 |
[  904.550000] ath: phy1: PDADC (1,1000): b29c 322e2a26
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  28 Value  38 | PDADC  29 Value  42 | PDADC  30 Value  46 | PDADC  31 Value  50 |
[  904.550000] ath: phy1: PDADC (1,1000): b2a0 423e3a36
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  32 Value  54 | PDADC  33 Value  58 | PDADC  34 Value  62 | PDADC  35 Value  66 |
[  904.550000] ath: phy1: PDADC (1,1000): b2a4 534e4a46
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  36 Value  70 | PDADC  37 Value  74 | PDADC  38 Value  78 | PDADC  39 Value  83 |
[  904.550000] ath: phy1: PDADC (1,1000): b2a8 746b635b
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  40 Value  91 | PDADC  41 Value  99 | PDADC  42 Value 107 | PDADC  43 Value 116 |
[  904.550000] ath: phy1: PDADC (1,1000): b2ac 948c847c
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  44 Value 124 | PDADC  45 Value 132 | PDADC  46 Value 140 | PDADC  47 Value 148 |
[  904.550000] ath: phy1: PDADC (1,1000): b2b0 2926239c
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  48 Value 156 | PDADC  49 Value  35 | PDADC  50 Value  38 | PDADC  51 Value  41 |
[  904.550000] ath: phy1: PDADC (1,1000): b2b4 3834302d
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  52 Value  45 | PDADC  53 Value  48 | PDADC  54 Value  52 | PDADC  55 Value  56 |
[  904.550000] ath: phy1: PDADC (1,1000): b2b8 4a443f3b
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  56 Value  59 | PDADC  57 Value  63 | PDADC  58 Value  68 | PDADC  59 Value  74 |
[  904.550000] ath: phy1: PDADC (1,1000): b2bc 645d5750
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  60 Value  80 | PDADC  61 Value  87 | PDADC  62 Value  93 | PDADC  63 Value 100 |
[  904.550000] ath: phy1: PDADC (1,1000): b2c0 8079726b
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  64 Value 107 | PDADC  65 Value 114 | PDADC  66 Value 121 | PDADC  67 Value 128 |
[  904.550000] ath: phy1: PDADC (1,1000): b2c4 8e8e8e87
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  68 Value 135 | PDADC  69 Value 142 | PDADC  70 Value 142 | PDADC  71 Value 142 |
[  904.550000] ath: phy1: PDADC (1,1000): b2c8 8e8e8e8e
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  72 Value 142 | PDADC  73 Value 142 | PDADC  74 Value 142 | PDADC  75 Value 142 |
[  904.550000] ath: phy1: PDADC (1,1000): b2cc 8e8e8e8e
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  76 Value 142 | PDADC  77 Value 142 | PDADC  78 Value 142 | PDADC  79 Value 142 |
[  904.550000] ath: phy1: PDADC (1,1000): b2d0 8e8e8e8e
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  80 Value 142 | PDADC  81 Value 142 | PDADC  82 Value 142 | PDADC  83 Value 142 |
[  904.550000] ath: phy1: PDADC (1,1000): b2d4 8e8e8e8e
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  84 Value 142 | PDADC  85 Value 142 | PDADC  86 Value 142 | PDADC  87 Value 142 |
[  904.550000] ath: phy1: PDADC (1,1000): b2d8 8e8e8e8e
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  88 Value 142 | PDADC  89 Value 142 | PDADC  90 Value 142 | PDADC  91 Value 142 |
[  904.550000] ath: phy1: PDADC (1,1000): b2dc 8e8e8e8e
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  92 Value 142 | PDADC  93 Value 142 | PDADC  94 Value 142 | PDADC  95 Value 142 |
[  904.550000] ath: phy1: PDADC (1,1000): b2e0 8e8e8e8e
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  96 Value 142 | PDADC  97 Value 142 | PDADC  98 Value 142 | PDADC  99 Value 142 |
[  904.550000] ath: phy1: PDADC (1,1000): b2e4 8e8e8e8e
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC 100 Value 142 | PDADC 101 Value 142 | PDADC 102 Value 142 | PDADC 103 Value 142 |
[  904.550000] ath: phy1: PDADC (1,1000): b2e8 8e8e8e8e
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC 104 Value 142 | PDADC 105 Value 142 | PDADC 106 Value 142 | PDADC 107 Value 142 |
[  904.550000] ath: phy1: PDADC (1,1000): b2ec 8e8e8e8e
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC 108 Value 142 | PDADC 109 Value 142 | PDADC 110 Value 142 | PDADC 111 Value 142 |
[  904.550000] ath: phy1: PDADC (1,1000): b2f0 8e8e8e8e
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC 112 Value 142 | PDADC 113 Value 142 | PDADC 114 Value 142 | PDADC 115 Value 142 |
[  904.550000] ath: phy1: PDADC (1,1000): b2f4 8e8e8e8e
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC 116 Value 142 | PDADC 117 Value 142 | PDADC 118 Value 142 | PDADC 119 Value 142 |
[  904.550000] ath: phy1: PDADC (1,1000): b2f8 8e8e8e8e
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC 120 Value 142 | PDADC 121 Value 142 | PDADC 122 Value 142 | PDADC 123 Value 142 |
[  904.550000] ath: phy1: PDADC (1,1000): b2fc 8e8e8e8e
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC 124 Value 142 | PDADC 125 Value 142 | PDADC 126 Value 142 | PDADC 127 Value 142 |
[  904.550000] ath: phy1: disable IER
[  904.550000] ath: phy1: Stopping ANI
[  904.550000] ath: phy1: disable IER
[  904.550000] ath: phy1: Disable MIB counters
[  904.550000] ath: phy1: NF calibrated [ctl] [chain 0] is -114
[  904.550000] ath: phy1: NF calibrated [ctl] [chain 1] is -116
[  904.550000] ath: phy1: PDADC (0,   0): a280 03020100
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC   0 Value   0 | PDADC   1 Value   1 | PDADC   2 Value   2 | PDADC   3 Value   3 |
[  904.550000] ath: phy1: PDADC (0,   0): a284 07060504
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC   4 Value   4 | PDADC   5 Value   5 | PDADC   6 Value   6 | PDADC   7 Value   7 |
[  904.550000] ath: phy1: PDADC (0,   0): a288 0c0a0908
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  12 |
[  904.550000] ath: phy1: PDADC (0,   0): a28c 11100e0d
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  12 Value  13 | PDADC  13 Value  14 | PDADC  14 Value  16 | PDADC  15 Value  17 |
[  904.550000] ath: phy1: PDADC (0,   0): a290 16151412
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  16 Value  18 | PDADC  17 Value  20 | PDADC  18 Value  21 | PDADC  19 Value  22 |
[  904.550000] ath: phy1: PDADC (0,   0): a294 1f1d1a18
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  20 Value  24 | PDADC  21 Value  26 | PDADC  22 Value  29 | PDADC  23 Value  31 |
[  904.550000] ath: phy1: PDADC (0,   0): a298 2a282522
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  24 Value  34 | PDADC  25 Value  37 | PDADC  26 Value  40 | PDADC  27 Value  42 |
[  904.550000] ath: phy1: PDADC (0,   0): a29c 3633302d
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  28 Value  45 | PDADC  29 Value  48 | PDADC  30 Value  51 | PDADC  31 Value  54 |
[  904.550000] ath: phy1: PDADC (0,   0): a2a0 4c46413b
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  32 Value  59 | PDADC  33 Value  65 | PDADC  34 Value  70 | PDADC  35 Value  76 |
[  904.550000] ath: phy1: PDADC (0,   0): a2a4 625d5752
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  36 Value  82 | PDADC  37 Value  87 | PDADC  38 Value  93 | PDADC  39 Value  98 |
[  904.550000] ath: phy1: PDADC (0,   0): a2a8 7b746e68
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  40 Value 104 | PDADC  41 Value 110 | PDADC  42 Value 116 | PDADC  43 Value 123 |
[  904.550000] ath: phy1: PDADC (0,   0): a2ac 968f8882
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  44 Value 130 | PDADC  45 Value 136 | PDADC  46 Value 143 | PDADC  47 Value 150 |
[  904.550000] ath: phy1: PDADC (0,   0): a2b0 332f2bab
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  48 Value 171 | PDADC  49 Value  43 | PDADC  50 Value  47 | PDADC  51 Value  51 |
[  904.550000] ath: phy1: PDADC (0,   0): a2b4 433f3b37
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  52 Value  55 | PDADC  53 Value  59 | PDADC  54 Value  63 | PDADC  55 Value  67 |
[  904.550000] ath: phy1: PDADC (0,   0): a2b8 59534d47
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  56 Value  71 | PDADC  57 Value  77 | PDADC  58 Value  83 | PDADC  59 Value  89 |
[  904.550000] ath: phy1: PDADC (0,   0): a2bc 726c655f
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  60 Value  95 | PDADC  61 Value 101 | PDADC  62 Value 108 | PDADC  63 Value 114 |
[  904.550000] ath: phy1: PDADC (0,   0): a2c0 8a847e78
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  64 Value 120 | PDADC  65 Value 126 | PDADC  66 Value 132 | PDADC  67 Value 138 |
[  904.550000] ath: phy1: PDADC (0,   0): a2c4 9c9c9690
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  68 Value 144 | PDADC  69 Value 150 | PDADC  70 Value 156 | PDADC  71 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2c8 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  72 Value 156 | PDADC  73 Value 156 | PDADC  74 Value 156 | PDADC  75 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2cc 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  76 Value 156 | PDADC  77 Value 156 | PDADC  78 Value 156 | PDADC  79 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2d0 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  80 Value 156 | PDADC  81 Value 156 | PDADC  82 Value 156 | PDADC  83 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2d4 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  84 Value 156 | PDADC  85 Value 156 | PDADC  86 Value 156 | PDADC  87 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2d8 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  88 Value 156 | PDADC  89 Value 156 | PDADC  90 Value 156 | PDADC  91 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2dc 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  92 Value 156 | PDADC  93 Value 156 | PDADC  94 Value 156 | PDADC  95 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2e0 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC  96 Value 156 | PDADC  97 Value 156 | PDADC  98 Value 156 | PDADC  99 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2e4 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC 100 Value 156 | PDADC 101 Value 156 | PDADC 102 Value 156 | PDADC 103 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2e8 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC 104 Value 156 | PDADC 105 Value 156 | PDADC 106 Value 156 | PDADC 107 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2ec 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC 108 Value 156 | PDADC 109 Value 156 | PDADC 110 Value 156 | PDADC 111 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2f0 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC 112 Value 156 | PDADC 113 Value 156 | PDADC 114 Value 156 | PDADC 115 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2f4 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC 116 Value 156 | PDADC 117 Value 156 | PDADC 118 Value 156 | PDADC 119 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2f8 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC 120 Value 156 | PDADC 121 Value 156 | PDADC 122 Value 156 | PDADC 123 Value 156 |
[  904.550000] ath: phy1: PDADC (0,   0): a2fc 9c9c9c9c
[  904.550000] ath: phy1: PDADC: Chain 0 | PDADC 124 Value 156 | PDADC 125 Value 156 | PDADC 126 Value 156 | PDADC 127 Value 156 |
[  904.550000] ath: phy1: PDADC (1,1000): b280 04030201
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC   0 Value   1 | PDADC   1 Value   2 | PDADC   2 Value   3 | PDADC   3 Value   4 |
[  904.550000] ath: phy1: PDADC (1,1000): b284 07060605
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC   4 Value   5 | PDADC   5 Value   6 | PDADC   6 Value   6 | PDADC   7 Value   7 |
[  904.550000] ath: phy1: PDADC (1,1000): b288 0b0a0908
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  11 |
[  904.550000] ath: phy1: PDADC (1,1000): b28c 0e0d0c0b
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  12 Value  11 | PDADC  13 Value  12 | PDADC  14 Value  13 | PDADC  15 Value  14 |
[  904.550000] ath: phy1: PDADC (1,1000): b290 1311100f
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  16 Value  15 | PDADC  17 Value  16 | PDADC  18 Value  17 | PDADC  19 Value  19 |
[  904.550000] ath: phy1: PDADC (1,1000): b294 1b191715
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  20 Value  21 | PDADC  21 Value  23 | PDADC  22 Value  25 | PDADC  23 Value  27 |
[  904.550000] ath: phy1: PDADC (1,1000): b298 23211f1d
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  24 Value  29 | PDADC  25 Value  31 | PDADC  26 Value  33 | PDADC  27 Value  35 |
[  904.550000] ath: phy1: PDADC (1,1000): b29c 322e2a26
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  28 Value  38 | PDADC  29 Value  42 | PDADC  30 Value  46 | PDADC  31 Value  50 |
[  904.550000] ath: phy1: PDADC (1,1000): b2a0 423e3a36
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  32 Value  54 | PDADC  33 Value  58 | PDADC  34 Value  62 | PDADC  35 Value  66 |
[  904.550000] ath: phy1: PDADC (1,1000): b2a4 534e4a46
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  36 Value  70 | PDADC  37 Value  74 | PDADC  38 Value  78 | PDADC  39 Value  83 |
[  904.550000] ath: phy1: PDADC (1,1000): b2a8 746b635b
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  40 Value  91 | PDADC  41 Value  99 | PDADC  42 Value 107 | PDADC  43 Value 116 |
[  904.550000] ath: phy1: PDADC (1,1000): b2ac 948c847c
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  44 Value 124 | PDADC  45 Value 132 | PDADC  46 Value 140 | PDADC  47 Value 148 |
[  904.550000] ath: phy1: PDADC (1,1000): b2b0 2926239c
[  904.550000] ath: phy1: PDADC: Chain 1 | PDADC  48 Value 156 | PDADC  49 Value  35 | PDADC  50 Value  38 | PDADC  51 Value  41 |
[  904.560000] ath: phy1: PDADC (1,1000): b2b4 3834302d
[  904.560000] ath: phy1: PDADC: Chain 1 | PDADC  52 Value  45 | PDADC  53 Value  48 | PDADC  54 Value  52 | PDADC  55 Value  56 |
[  904.560000] ath: phy1: PDADC (1,1000): b2b8 4a443f3b
[  904.560000] ath: phy1: PDADC: Chain 1 | PDADC  56 Value  59 | PDADC  57 Value  63 | PDADC  58 Value  68 | PDADC  59 Value  74 |
[  904.560000] ath: phy1: PDADC (1,1000): b2bc 645d5750
[  904.560000] ath: phy1: PDADC: Chain 1 | PDADC  60 Value  80 | PDADC  61 Value  87 | PDADC  62 Value  93 | PDADC  63 Value 100 |
[  904.560000] ath: phy1: PDADC (1,1000): b2c0 8079726b
[  904.560000] ath: phy1: PDADC: Chain 1 | PDADC  64 Value 107 | PDADC  65 Value 114 | PDADC  66 Value 121 | PDADC  67 Value 128 |
[  904.560000] ath: phy1: PDADC (1,1000): b2c4 8e8e8e87
[  904.560000] ath: phy1: PDADC: Chain 1 | PDADC  68 Value 135 | PDADC  69 Value 142 | PDADC  70 Value 142 | PDADC  71 Value 142 |
[  904.560000] ath: phy1: PDADC (1,1000): b2c8 8e8e8e8e
[  904.560000] ath: phy1: PDADC: Chain 1 | PDADC  72 Value 142 | PDADC  73 Value 142 | PDADC  74 Value 142 | PDADC  75 Value 142 |
[  904.560000] ath: phy1: PDADC (1,1000): b2cc 8e8e8e8e
[  904.560000] ath: phy1: PDADC: Chain 1 | PDADC  76 Value 142 | PDADC  77 Value 142 | PDADC  78 Value 142 | PDADC  79 Value 142 |
[  904.560000] ath: phy1: PDADC (1,1000): b2d0 8e8e8e8e
[  904.560000] ath: phy1: PDADC: Chain 1 | PDADC  80 Value 142 | PDADC  81 Value 142 | PDADC  82 Value 142 | PDADC  83 Value 142 |
[  904.560000] ath: phy1: PDADC (1,1000): b2d4 8e8e8e8e
[  904.560000] ath: phy1: PDADC: Chain 1 | PDADC  84 Value 142 | PDADC  85 Value 142 | PDADC  86 Value 142 | PDADC  87 Value 142 |
[  904.560000] ath: phy1: PDADC (1,1000): b2d8 8e8e8e8e
[  904.560000] ath: phy1: PDADC: Chain 1 | PDADC  88 Value 142 | PDADC  89 Value 142 | PDADC  90 Value 142 | PDADC  91 Value 142 |
[  904.560000] ath: phy1: PDADC (1,1000): b2dc 8e8e8e8e
[  904.560000] ath: phy1: PDADC: Chain 1 | PDADC  92 Value 142 | PDADC  93 Value 142 | PDADC  94 Value 142 | PDADC  95 Value 142 |
[  904.560000] ath: phy1: PDADC (1,1000): b2e0 8e8e8e8e
[  904.560000] ath: phy1: PDADC: Chain 1 | PDADC  96 Value 142 | PDADC  97 Value 142 | PDADC  98 Value 142 | PDADC  99 Value 142 |
[  904.560000] ath: phy1: PDADC (1,1000): b2e4 8e8e8e8e
[  904.560000] ath: phy1: PDADC: Chain 1 | PDADC 100 Value 142 | PDADC 101 Value 142 | PDADC 102 Value 142 | PDADC 103 Value 142 |
[  904.560000] ath: phy1: PDADC (1,1000): b2e8 8e8e8e8e
[  904.560000] ath: phy1: PDADC: Chain 1 | PDADC 104 Value 142 | PDADC 105 Value 142 | PDADC 106 Value 142 | PDADC 107 Value 142 |
[  904.560000] ath: phy1: PDADC (1,1000): b2ec 8e8e8e8e
[  904.560000] ath: phy1: PDADC: Chain 1 | PDADC 108 Value 142 | PDADC 109 Value 142 | PDADC 110 Value 142 | PDADC 111 Value 142 |
[  904.560000] ath: phy1: PDADC (1,1000): b2f0 8e8e8e8e
[  904.560000] ath: phy1: PDADC: Chain 1 | PDADC 112 Value 142 | PDADC 113 Value 142 | PDADC 114 Value 142 | PDADC 115 Value 142 |
[  904.560000] ath: phy1: PDADC (1,1000): b2f4 8e8e8e8e
[  904.560000] ath: phy1: PDADC: Chain 1 | PDADC 116 Value 142 | PDADC 117 Value 142 | PDADC 118 Value 142 | PDADC 119 Value 142 |
[  904.560000] ath: phy1: PDADC (1,1000): b2f8 8e8e8e8e
[  904.560000] ath: phy1: PDADC: Chain 1 | PDADC 120 Value 142 | PDADC 121 Value 142 | PDADC 122 Value 142 | PDADC 123 Value 142 |
[  904.560000] ath: phy1: PDADC (1,1000): b2fc 8e8e8e8e
[  904.560000] ath: phy1: PDADC: Chain 1 | PDADC 124 Value 142 | PDADC 125 Value 142 | PDADC 126 Value 142 | PDADC 127 Value 142 |
[  904.560000] ath: phy1: Reset TX queue: 0
[  904.560000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.560000] ath: phy1: Reset TX queue: 1
[  904.560000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.560000] ath: phy1: Reset TX queue: 2
[  904.560000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.560000] ath: phy1: Reset TX queue: 3
[  904.560000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.560000] ath: phy1: Reset TXQ, inactive queue: 4
[  904.560000] ath: phy1: Reset TXQ, inactive queue: 5
[  904.560000] ath: phy1: Reset TXQ, inactive queue: 6
[  904.560000] ath: phy1: Reset TX queue: 7
[  904.560000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.560000] ath: phy1: Reset TX queue: 8
[  904.560000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.560000] ath: phy1: Reset TX queue: 9
[  904.560000] ath: phy1: tx ok 0x0 err 0x0 desc 0x18f eol 0x10f urn 0x0
[  904.560000] ath: phy1: ver 128.2 opmode 2 chan 5895 Mhz
[  904.560000] ath: phy1: ah->misc_mode 0x4
[  904.560000] ath: phy1: enabling ADC Gain Calibration
[  904.560000] ath: phy1: enabling ADC DC Calibration
[  904.560000] ath: phy1: enabling IQ Calibration
[  904.560000] ath: phy1: starting ADC Gain Calibration
[  904.560000] ath: phy1: Driver halt
[  904.660000] ath: phy1: AWAKE -> FULL-SLEEP


--------------49AA90711365DA59C2E3180C--
