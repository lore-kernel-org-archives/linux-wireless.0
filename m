Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from connotech.com ([76.10.176.241]:45846 "EHLO mail.connotech.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbaCETPg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 14:15:36 -0500
Message-ID: <531777F8.5060506@connotech.com> (sfid-20140305_201541_919379_AF337D57)
Date: Wed, 05 Mar 2014 19:16:08 +0000
From: Thierry Moreau <thierry.moreau@connotech.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: rtlwifi (rtl8192ce) consistently reports EBUSY error, but scanning
 works
References: <5316C602.8020504@connotech.com> <5316CE44.5060905@lwfinger.net> <5317506B.1080305@connotech.com> <53175368.50009@lwfinger.net>
In-Reply-To: <53175368.50009@lwfinger.net>
Content-Type: multipart/mixed;
 boundary="------------080304020101030604010208"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080304020101030604010208
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 03/05/14 16:40, Larry Finger wrote:
>
> Please give me the exact set of commands you use to get this problem. If
> possible, capture the console output. As I am currently running
> long-term tests of the latest version of rtl8192ce using an RTL8188CE
> (10ec:8176), it will be a perfect time to test.
>

Here is the command script, and the console log
(....sh 2>&1 | tee ....log)

Is it possible that the Shuttle system be arranged with a digital output 
enabling/inhibiting the Realtek wifi interface active participation in 
wifi protocol?

I did ask Shuttle tech support, but in any event I don't want to induce 
you to troubleshoot a specific system.

Thanks,

-- Thierry Moreau



--------------080304020101030604010208
Content-Type: text/plain; charset=us-ascii;
 name="shuttle-x36vl-rtl8192ce-ebusy.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="shuttle-x36vl-rtl8192ce-ebusy.log"

+ uname -a
Linux dodeca1er 3.14.0-rc5 #1 SMP Wed Mar 5 15:38:33 UTC 2014 x86_64 Intel(R) Atom(TM) CPU D2550 @ 1.86GHz GenuineIntel GNU/Linux
+ grep -i wifi -C 4 -n
+ dmesg
711-[    2.581616] gma500 0000:00:02.0: trying to get vblank count for disabled pipe 1
712-[    2.771178] usb 5-2: new low-speed USB device number 2 using uhci_hcd
713-[    2.832203] fbcon: psbdrmfb (fb0) is primary device
714-[    2.832262] rtl8192ce:_rtl92ce_read_chip_version():<0-0> Chip Version ID: B_CUT_88C
715:[    2.844335] rtl8192ce: Using firmware rtlwifi/rtl8192cfwU_B.bin
716-[    2.939453] usb 5-2: New USB device found, idVendor=045e, idProduct=0780
717-[    2.939458] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
718-[    2.939462] usb 5-2: Product: Comfort Curve Keyboard 3000
719-[    2.939465] usb 5-2: Manufacturer: Microsoft
--
725-[    3.287718] gma500 0000:00:02.0: fb0: psbdrmfb frame buffer device
726-[    3.287723] gma500 0000:00:02.0: registered panic notifier
727-[    3.287820] [drm] Initialized gma500 1.0.0 2011-06-06 for 0000:00:02.0 on minor 0
728-[    3.396518] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
729:[    3.397145] rtlwifi: wireless switch is on
730-[    5.834746] Adding 16777212k swap on /dev/sda6.  Priority:42 extents:1 across:16777212k 
731-[    5.859658] Adding 16777212k swap on /dev/sda7.  Priority:52 extents:1 across:16777212k 
732-[    5.883344] Adding 16777212k swap on /dev/sda8.  Priority:62 extents:1 across:16777212k 
733-[    6.872268] gzip (166) used greatest stack depth: 3864 bytes left
+ lsmod
Module                  Size  Used by
rtl8192ce              71392  0 
gma500_gfx            139440  1 
rtl_pci                24810  1 rtl8192ce
rtlwifi                70066  2 rtl_pci,rtl8192ce
rtl8192c_common        53859  1 rtl8192ce
drm_kms_helper         28143  1 gma500_gfx
+ cat
+ iwconfig
eth0      no wireless extensions.

lo        no wireless extensions.

sit0      no wireless extensions.

wlan1     IEEE 802.11bgn  ESSID:off/any  
          Mode:Managed  Access Point: Not-Associated   Tx-Power=0 dBm   
          Retry short limit:7   RTS thr=2347 B   Fragment thr:off
          Encryption key:off
          Power Management:on
          
+ cat
+ iw dev wlan1 info
Interface wlan1
	ifindex 4
	wdev 0x1
	addr 64:5a:04:aa:f8:16
	type managed
	wiphy 0
+ cat
+ iw dev wlan1 set channel 2
command failed: Device or resource busy (-16)
+ cat
+ iw dev wlan1 scan
command failed: Network is down (-100)
+ cat
+ ip link set up wlan1
+ cat
+ iw dev wlan1 scan
BSS d8:6c:e9:29:e5:75(on wlan1)
	TSF: 1358921377410 usec (15d, 17:28:41)
	freq: 2412
	beacon interval: 100 TUs
	capability: ESS Privacy ShortSlotTime APSD (0x0c11)
	signal: -74.00 dBm
	last seen: 929 ms ago
	SSID: BELL417
	Supported rates: 1.0* 2.0* 5.5* 11.0* 9.0 18.0 36.0 54.0 
	DS Parameter set: channel 1
	ERP: Barker_Preamble_Mode
	Extended supported rates: 6.0 12.0 24.0 48.0 
	HT capabilities:
		Capabilities: 0x106e
			HT20/HT40
			SM Power Save disabled
			RX HT20 SGI
			RX HT40 SGI
			No RX STBC
			Max AMSDU length: 3839 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 32767 bytes (exponent: 0x002)
		Minimum RX AMPDU time spacing: 4 usec (0x05)
		HT RX MCS rate indexes supported: 0-23, 32
		HT TX MCS rate indexes are undefined
	HT operation:
		 * primary channel: 1
		 * secondary channel offset: above
		 * STA channel width: any
		 * RIFS: 0
		 * HT protection: nonmember
		 * non-GF present: 0
		 * OBSS non-GF present: 0
		 * dual beacon: 0
		 * dual CTS protection: 0
		 * STBC beacon: 0
		 * L-SIG TXOP Prot: 0
		 * PCO active: 0
		 * PCO phase: 0
	Secondary Channel Offset: no secondary (0)
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: 1-PTKSA-RC 1-GTKSA-RC (0x0000)
	WMM:	 * Parameter version 1
		 * u-APSD
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
	BSS Load:
		 * station count: 0
		 * channel utilisation: 11/255
		 * available admission capacity: 31250 [*32us]
	Overlapping BSS scan params:
		 * passive dwell: 20 TUs
		 * active dwell: 10 TUs
		 * channel width trigger scan interval: 300 s
		 * scan passive total per channel: 200 TUs
		 * scan active total per channel: 20 TUs
		 * BSS width channel transition delay factor: 5
		 * OBSS Scan Activity Threshold: 0.25 %
	Extended capabilities: HT Information Exchange Supported
	Country: CA	Environment: Indoor/Outdoor
		Channels [1 - 11] @ 16 dBm
	WPS:	 * Version: 1.0
		 * Wi-Fi Protected Setup State: 2 (Configured)
		 * Response Type: 3 (AP)
		 * UUID: 28802880-2880-1880-a880-d86ce929e575
		 * Manufacturer: Ralink Technology, Corp.
		 * Model: Ralink Wireless Access Point
		 * Model Number: RT2860
		 * Serial Number: 12345678
		 * Primary Device Type: 6-0050f204-1
		 * Device name: RalinkAPS
		 * Config methods: Label, PBC
		 * RF Bands: 0x1
+ cat
+ iwlist wlan1 scanning
wlan1     Scan completed :
          Cell 01 - Address: D8:6C:E9:29:E5:75
                    Channel:1
                    Frequency:2.412 GHz (Channel 1)
                    Quality=30/70  Signal level=-80 dBm  
                    Encryption key:on
                    ESSID:"BELL417"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 9 Mb/s
                              18 Mb/s; 36 Mb/s; 54 Mb/s
                    Bit Rates:6 Mb/s; 12 Mb/s; 24 Mb/s; 48 Mb/s
                    Mode:Master
                    Extra:tsf=0000013c6606a682
                    Extra: Last beacon: 987ms ago
                    IE: Unknown: 000742454C4C343137
                    IE: Unknown: 010882848B961224486C
                    IE: Unknown: 030101
                    IE: Unknown: 2A0104
                    IE: Unknown: 32040C183060
                    IE: Unknown: 2D1A6E1016FFFFFF0001000000000000000000000000030000000000
                    IE: Unknown: 3D1601050100000000000000000000000000000000000000
                    IE: Unknown: 3E0100
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : CCMP
                        Pairwise Ciphers (1) : CCMP
                        Authentication Suites (1) : PSK
                    IE: Unknown: DD180050F2020101800003A4000027A4000042435E0062322F00
                    IE: Unknown: 0B0500000B127A
                    IE: Unknown: 4A0E14000A002C01C800140005001900
                    IE: Unknown: 7F0101
                    IE: Unknown: DD07000C4300000000
                    IE: Unknown: 0706434120010B10
                    IE: Unknown: DD9D0050F204104A0001101044000102103B000103104700102880288028801880A880D86CE929E5751021001852616C696E6B20546563686E6F6C6F67792C20436F72702E1023001C52616C696E6B20576972656C6573732041636365737320506F696E74102400065254323836301042000831323334353637381054000800060050F20400011011000952616C696E6B415053100800020084103C000101

+ cat
+ iwconfig wlan1 channel 2
Error for wireless request "Set Frequency" (8B04) :
    SET failed on device wlan1 ; Device or resource busy.
+ cat
+ ip link set down wlan1
+ cat
+ iw dev wlan1 interface add wlan2 type managed
+ cat
+ iwconfig
eth0      no wireless extensions.

lo        no wireless extensions.

sit0      no wireless extensions.

wlan1     IEEE 802.11bgn  ESSID:off/any  
          Mode:Managed  Frequency:2.417 GHz  Access Point: Not-Associated   
          Tx-Power=20 dBm   
          Retry short limit:7   RTS thr=2347 B   Fragment thr:off
          Encryption key:off
          Power Management:off
          
rename5   IEEE 802.11bgn  ESSID:off/any  
          Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm   
          Retry short limit:7   RTS thr=2347 B   Fragment thr:off
          Encryption key:off
          Power Management:on
          
+ cat
+ iw dev rename5 set channel 2
command failed: Device or resource busy (-16)
+ cat

--------------080304020101030604010208
Content-Type: application/x-sh;
 name="shuttle-x36vl-rtl8192ce-ebusy.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="shuttle-x36vl-rtl8192ce-ebusy.sh"

#!/bin/bash
set -x
uname -a
dmesg | grep -i wifi -C 4 -n
lsmod
cat >>/dev/null
iwconfig
cat >>/dev/null
iw dev wlan1 info
cat >>/dev/null
iw dev wlan1 set channel 2
cat >>/dev/null
iw dev wlan1 scan
cat >>/dev/null
ip link set up wlan1
cat >>/dev/null
iw dev wlan1 scan
cat >>/dev/null
iwlist wlan1 scanning
cat >>/dev/null
iwconfig wlan1 channel 2
cat >>/dev/null
ip link set down wlan1
cat >>/dev/null
iw dev wlan1 interface add wlan2 type managed
cat >>/dev/null
iwconfig
cat >>/dev/null
iw dev rename5 set channel 2
cat >>/dev/null

--------------080304020101030604010208--
