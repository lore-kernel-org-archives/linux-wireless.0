Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:65140 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762532AbYEIQ5T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2008 12:57:19 -0400
Received: from X61.NetworkingUnlimited.com
 (ool-43503a0c.dyn.optonline.net [67.80.58.12]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0K0M004OV1RE0PJ1@mta5.srv.hcvlny.cv.net> for
 linux-wireless@vger.kernel.org; Fri, 09 May 2008 12:57:15 -0400 (EDT)
Date: Fri, 09 May 2008 12:57:14 -0400
From: Vincent C Jones <v.jones@networkingunlimited.com>
Subject: iwl4965 - wpa_supplicant can't see 5Ghz frequencies - 2.6.26-rc1	kernel
To: linux-wireless@vger.kernel.org
Message-id: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com> (sfid-20080509_185617_216527_EAA78744)
MIME-version: 1.0
Content-type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The channel/frequency reporting by iwlwifi is incompatible with
wpa_supplicant for 5GHz (802.11A) channels. Version numbers and iwlist
versus wpa_supplicant scan results are below. Association still works if
the correct channel is specified using iwconfig, but that is
incompatible with roaming.

-- 
Dr. Vincent C. Jones, PE
Networking Unlimited, Inc.
Phone: +1 201 568-7810
V.Jones@NetworkingUnlimited.com

X61:~ # modinfo iwl4965
filename:       /lib/modules/2.6.26-rc1-test/kernel/drivers/net/wireless/iwlwifi/iwl4965.ko
license:        GPL
author:         Copyright(c) 2003-2008 Intel Corporation
version:        1.2.26ks
description:    Intel(R) Wireless WiFi Link 4965AGN driver for Linux
srcversion:     9D17B36AB629BB7D6073C31
alias:          pci:v00008086d00004230sv*sd*bc*sc*i*
alias:          pci:v00008086d00004229sv*sd*bc*sc*i*
depends:        mac80211,iwlcore,cfg80211,firmware_class
vermagic:       2.6.26-rc1-test SMP mod_unload
parm:           antenna:select antenna (1=Main, 2=Aux, default 0 [both])
(int)
parm:           disable:manually disable the radio (default 0 [radio
on]) (int)
parm:           swcrypto:using crypto in software (default 0 [hardware])
(int)
parm:           debug:debug output mask (int)
parm:           disable_hw_scan:disable hardware scanning (default 0)
(int)
parm:           queues_num:number of hw queues. (int)
parm:           qos_enable:enable all QoS functionality (int)
parm:           amsdu_size_8K:enable 8K amsdu size (int)
X61:~ # wpa_supplicant -v
wpa_supplicant v0.6.3
Copyright (c) 2003-2008, Jouni Malinen <j@w1.fi> and contributors
X61:~ # iwconfig -v
iwconfig  Wireless-Tools version 29
          Compatible with Wireless Extension v11 to v22.

Kernel    Currently compiled with Wireless Extension v22.

wlan0     Recommend Wireless Extension v21 or later,
          Currently compiled with Wireless Extension v22.

X61:~ # uname -a
Linux X61 2.6.26-rc1-test #2 SMP Fri May 9 09:00:30 EDT 2008 x86_64
x86_64 x86_64 GNU/Linux
X61:~ #  iwlist wlan0 scan
wlan0     Scan completed :
          Cell 01 - Address: 00:14:BF:96:98:BF
                    ESSID:"linksys"
                    Mode:Master
                    Frequency:2.437 GHz (Channel 6)
                    Channel:6
                    Quality=24/100  Signal level=-94 dBm  Noise
level=-127 dBm
                    Encryption key:off
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
                              24 Mb/s; 36 Mb/s; 54 Mb/s; 6 Mb/s; 9 Mb/s
                              12 Mb/s; 48 Mb/s
                    Extra:tsf=000000ae75798185
          Cell 02 - Address: 00:1E:2A:6C:93:D9
                    ESSID:"NetworkingUnlimited-G"
                    Mode:Master
                    Frequency:2.462 GHz (Channel 11)
                    Channel:11
                    Quality=38/100  Signal level=-86 dBm  Noise
level=-127 dBm
                    Encryption key:on
                    IE: WPA Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (2) : CCMP TKIP
                        Authentication Suites (1) : PSK
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (2) : CCMP TKIP
                        Authentication Suites (1) : PSK
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
                              24 Mb/s; 36 Mb/s; 54 Mb/s; 6 Mb/s; 9 Mb/s
                              12 Mb/s; 48 Mb/s
                    Extra:tsf=0000019d354e1183
          Cell 03 - Address: 00:1A:C1:8A:23:40
                    ESSID:"NetworkingUnlimited"
                    Mode:Master
                    Frequency:5.24 GHz (Channel 48)
                    Channel:48
                    Quality=100/100  Signal level=-46 dBm  Noise
level=-94 dBm
                    Encryption key:on
                    IE: WPA Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (2) : TKIP CCMP
                        Authentication Suites (1) : PSK
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (2) : TKIP CCMP
                        Authentication Suites (1) : PSK
                       Preauthentication Supported
                    Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s
                              36 Mb/s; 48 Mb/s; 54 Mb/s
                    Extra:tsf=000000dc34bf7037

X61:~ # wpa_cli -i wlan0
wpa_cli v0.6.3
Copyright (c) 2004-2008, Jouni Malinen <j@w1.fi> and contributors

This program is free software. You can distribute it and/or modify it
under the terms of the GNU General Public License version 2.

Alternatively, this software may be distributed under the terms of the
BSD license. See README and COPYING for more details.



Interactive mode

> scan
OK
<2>CTRL-EVENT-SCAN-RESULTS
> scan_results
bssid / frequency / signal level / flags / ssid
00:1a:c1:8a:23:40       0       202     [WPA-PSK-TKIP
+CCMP][WPA2-PSK-TKIP+CCMP-preauth] NetworkingUnlimited
00:1e:2a:6c:93:d9       2462    168     [WPA-PSK-TKIP
+CCMP][WPA2-PSK-TKIP+CCMP]NetworkingUnlimited-G
00:14:bf:96:98:bf       2437    167             linksys
> quit
X61:~ #  

