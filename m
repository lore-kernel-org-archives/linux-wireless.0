Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from a80-127-65-128.adsl.xs4all.nl ([80.127.65.128]:57172 "EHLO
	linux.wilsoft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYKVJMJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 04:12:09 -0500
Received: from hp4000.wilsoft.nl ([192.168.4.5])
	by linux.wilsoft.nl with esmtp (Exim 4.69)
	(envelope-from <listsrv@wilsoft.nl>)
	id 1L3oX4-0005El-KK
	for linux-wireless@vger.kernel.org; Sat, 22 Nov 2008 10:12:02 +0100
From: "W. van den Akker" <listsrv@wilsoft.nl>
To: linux-wireless@vger.kernel.org
Subject: Ath9k wont go in properly AP mode
Date: Sat, 22 Nov 2008 10:12:01 +0100
References: <200811220953.05558.listsrv@wilsoft.nl> <200811221007.27348.listsrv@wilsoft.nl>
In-Reply-To: <200811221007.27348.listsrv@wilsoft.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811221012.01733.listsrv@wilsoft.nl> (sfid-20081122_101215_776895_63F74EF4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

My ath9k refuses to go into AP mode.

I am using:
- a 5416 wireless card (WMP300Nv2)
- linuxkernel 2.7.27.6
- hostapd 0.6.5
- wireless-testing 11-11-2008

When I try to set the ath9k in AP with hostapd I get:
xxx:/home/xxx# hostapd -dd /etc/hostapd/hostapd.conf
Configuration file: /etc/hostapd/hostapd.conf
ctrl_interface_group=0
Opening raw packet socket for ifindex 0
BSS count 1, BSSID mask ff:ff:ff:ff:ff:ff (0 bits)
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
Failed to update rate sets in kernel module
RATE[0] rate=10 flags=0x2
RATE[1] rate=20 flags=0x2
RATE[2] rate=55 flags=0x2
RATE[3] rate=110 flags=0x2
RATE[4] rate=60 flags=0x0
RATE[5] rate=90 flags=0x0
RATE[6] rate=120 flags=0x0
RATE[7] rate=180 flags=0x0
RATE[8] rate=240 flags=0x0
RATE[9] rate=360 flags=0x0
RATE[10] rate=480 flags=0x0
RATE[11] rate=540 flags=0x0
Could not set passive scanning: Unknown error 4294967295
Flushing old station entries
Deauthenticate all stations
Mode: IEEE 802.11g  Channel: 8  Frequency: 2447 MHz
Failed to set CTS protect in kernel driver
Failed to set Short Slot Time option in kernel driver
Could not set preamble for kernel driver
ioctl[SIOCSIWFRAG]: Operation not supported
Could not set fragmentation threshold for kernel driver
wlan0: Unable to setup interface.
Flushing old station entries
Deauthenticate all stations
rmdir[ctrl_interface]: No such file or directory

iwconfig shows:
wlan0     IEEE 802.11bgn  Mode:Master  Frequency:2.447 GHz  Tx-Power=27 dBm
          Retry min limit:7   RTS thr=2347 B   Fragment thr=2346 B
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

the SSID entry is missing here.

and iw list shows:
Wiphy phy0
        Band 1:
                Frequencies:
                        * 2412 MHz
                        * 2417 MHz
                        * 2422 MHz
                        * 2427 MHz
                        * 2432 MHz
                        * 2437 MHz
                        * 2442 MHz
                        * 2447 MHz
                        * 2452 MHz
                        * 2457 MHz
                        * 2462 MHz
                Bitrates:
                        * 1.0 Mbps
                        * 2.0 Mbps
                        * 5.5 Mbps
                        * 11.0 Mbps
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        Supported interface modes:
                 * IBSS
                 * Station
                 * AP
                 * AP(VLAN)
                 * Monitor

Or am I something missing to get it work. A previous version did set the
ath9k ok as AP, however it hanged the kernel after some time.

TIA,
Willem



-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

