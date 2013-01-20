Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm18-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.148]:34208 "EHLO
	nm18-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825Ab3ATHlN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2013 02:41:13 -0500
References: <1358665969.52744.YahooMailNeo@web120006.mail.ne1.yahoo.com>
Message-ID: <1358667286.45583.YahooMailNeo@web120002.mail.ne1.yahoo.com> (sfid-20130120_084117_894197_4CDDE641)
Date: Sat, 19 Jan 2013 23:34:46 -0800 (PST)
From: Arun Koshal <akoshal@yahoo.com>
Reply-To: Arun Koshal <akoshal@yahoo.com>
Subject: Need help on Intel 3945ABG problem with Linux Mint 13
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1358665969.52744.YahooMailNeo@web120006.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Hi,

I have installed Linux Mint 13 on my lenovo 62Q laptop.

laptop arun # uname -a
Linux laptop 3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10 20:41:14 UTC 2012 i686 i686 i386 GNU/Linux


I have Intel Corporation PRO/Wireless 3945ABG WiFi adapter in my laptop.

laptop arun # lspci | grep Wireless
04:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] Network Connection (rev 02)


WiFi connectivity with the access point works fine if the distance between the laptop and the access point is 1 or 2 feets. But it does not work if the distance is more than that. I get following messages in the /var/log/syslog file when the problem occurs -

Jan 20 11:50:15 laptop NetworkManager[4793]: <info> Activation (wlan0) starting connection 'HOME'
Jan 20
11:50:15 laptop NetworkManager[4793]: <info> (wlan0): device state change: disconnected -> prepare (reason 'none') [30 40 0]
Jan 20 11:50:15 laptop NetworkManager[4793]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Jan 20 11:50:15 laptop NetworkManager[4793]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) started...
Jan 20 11:50:15 laptop NetworkManager[4793]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) scheduled...
Jan 20 11:50:15 laptop NetworkManager[4793]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) complete.
Jan 20 11:50:15 laptop NetworkManager[4793]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) starting...
Jan 20 11:50:15 laptop NetworkManager[4793]: <info> (wlan0): device state change: prepare -> config (reason 'none') [40 50 0]
Jan 20 11:50:15 laptop NetworkManager[4793]: <info> Activation
(wlan0/wireless): connection 'HOME' requires no security.  No secrets needed.
Jan 20 11:50:15 laptop NetworkManager[4793]: <info> Config: added 'ssid' value 'HOME'
Jan 20 11:50:15 laptop NetworkManager[4793]: <info> Config: added 'scan_ssid' value '1'
Jan 20 11:50:15 laptop NetworkManager[4793]: <info> Config: added 'bssid' value '00:08:5c:ec:05:a4'
Jan 20 11:50:15 laptop NetworkManager[4793]: <info> Config: added 'key_mgmt' value 'NONE'
Jan 20 11:50:15 laptop NetworkManager[4793]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) complete.
Jan 20 11:50:15 laptop NetworkManager[4793]: <info> Config: set interface ap_scan to 1
Jan 20 11:50:15 laptop NetworkManager[4793]: <info> (wlan0): supplicant interface state: disconnected -> scanning
Jan 20 11:50:18 laptop wpa_supplicant[903]: Trying to authenticate with 00:08:5c:ec:05:a4 (SSID='HOME' freq=2462 MHz)
Jan 20 11:50:18
laptop kernel: [ 3417.858666] wlan0: authenticate with 00:08:5c:ec:05:a4 (try 1)
Jan 20 11:50:18 laptop NetworkManager[4793]: <info> (wlan0): supplicant interface state: scanning -> authenticating
Jan 20 11:50:18 laptop kernel: [ 3418.056277] wlan0: authenticate with 00:08:5c:ec:05:a4 (try 2)
Jan 20 11:50:18 laptop kernel: [ 3418.256275] wlan0: authenticate with 00:08:5c:ec:05:a4 (try 3)
Jan 20 11:50:18 laptop kernel: [ 3418.456264] wlan0: authentication with 00:08:5c:ec:05:a4 timed out
Jan 20 11:50:26 laptop wpa_supplicant[903]: Trying to authenticate with 00:08:5c:ec:05:a4 (SSID='HOME' freq=2462 MHz)
Jan 20 11:50:26 laptop kernel: [ 3425.820095] wlan0: direct probe to 00:08:5c:ec:05:a4 (try 1/3)
Jan 20 11:50:26 laptop kernel: [ 3426.020271] wlan0: direct probe to 00:08:5c:ec:05:a4 (try 2/3)
Jan 20 11:50:26 laptop kernel: [ 3426.220147] wlan0: direct probe to 00:08:5c:ec:05:a4 (try 3/3)
Jan 20 11:50:26 laptop kernel:
[ 3426.420272] wlan0: direct probe to 00:08:5c:ec:05:a4 timed out
Jan 20 11:50:34 laptop wpa_supplicant[903]: Trying to authenticate with 00:08:5c:ec:05:a4 (SSID='HOME' freq=2462 MHz)
Jan 20 11:50:34 laptop kernel: [ 3433.783816] wlan0: direct probe to 00:08:5c:ec:05:a4 (try 1/3)
Jan 20 11:50:34 laptop kernel: [ 3433.980169] wlan0: direct probe to 00:08:5c:ec:05:a4 (try 2/3)
Jan 20 11:50:34 laptop kernel: [ 3434.180279] wlan0: direct probe to 00:08:5c:ec:05:a4 (try 3/3)
Jan 20 11:50:34 laptop kernel: [ 3434.380269] wlan0: direct probe to 00:08:5c:ec:05:a4 timed out
Jan 20 11:50:42 laptop wpa_supplicant[903]: Trying to authenticate with 00:08:5c:ec:05:a4 (SSID='HOME' freq=2462 MHz)
Jan 20 11:50:42 laptop kernel: [ 3441.738873] wlan0: direct probe to 00:08:5c:ec:05:a4 (try 1/3)
Jan 20 11:50:42 laptop kernel: [ 3441.936258] wlan0: direct probe to 00:08:5c:ec:05:a4 (try 2/3)
Jan 20 11:50:42 laptop kernel: [ 3442.136201] wlan0:
direct probe to 00:08:5c:ec:05:a4 (try 3/3)
Jan 20 11:50:42 laptop kernel: [ 3442.336188] wlan0: direct probe to 00:08:5c:ec:05:a4 timed out
Jan 20 11:50:50 laptop wpa_supplicant[903]: Trying to authenticate with 00:08:5c:ec:05:a4 (SSID='HOME' freq=2462 MHz)
Jan 20 11:50:50 laptop kernel: [ 3449.702884] wlan0: direct probe to 00:08:5c:ec:05:a4 (try 1/3)
Jan 20 11:50:50 laptop kernel: [ 3449.900281] wlan0: direct probe to 00:08:5c:ec:05:a4 (try 2/3)
Jan 20 11:50:50 laptop kernel: [ 3450.100270] wlan0: direct probe to 00:08:5c:ec:05:a4 (try 3/3)
Jan 20 11:50:50 laptop kernel: [ 3450.300284] wlan0: direct probe to 00:08:5c:ec:05:a4 timed out
Jan 20 11:50:58 laptop wpa_supplicant[903]: Trying to authenticate with 00:08:5c:ec:05:a4 (SSID='HOME' freq=2462 MHz)
Jan 20 11:50:58 laptop kernel: [ 3457.664135] wlan0: direct probe to 00:08:5c:ec:05:a4 (try 1/3)
Jan 20 11:50:58 laptop kernel: [ 3457.864176] wlan0: direct probe to
00:08:5c:ec:05:a4 (try 2/3)
Jan 20 11:50:58 laptop kernel: [ 3458.064167] wlan0: direct probe to 00:08:5c:ec:05:a4 (try 3/3)
Jan 20 11:50:58 laptop kernel: [ 3458.264289] wlan0: direct probe to 00:08:5c:ec:05:a4 timed out
Jan 20 11:51:06 laptop wpa_supplicant[903]: Trying to authenticate with 00:08:5c:ec:05:a4 (SSID='HOME' freq=2462 MHz)
Jan 20 11:51:06 laptop kernel: [ 3465.626854] wlan0: direct probe to 00:08:5c:ec:05:a4 (try 1/3)
Jan 20 11:51:06 laptop kernel: [ 3465.824279] wlan0: direct probe to 00:08:5c:ec:05:a4 (try 2/3)
Jan 20 11:51:06 laptop kernel: [ 3466.024081] wlan0: direct probe to 00:08:5c:ec:05:a4 (try 3/3)
Jan 20 11:51:06 laptop kernel: [ 3466.224092] wlan0: direct probe to 00:08:5c:ec:05:a4 timed out
Jan 20 11:51:13 laptop wpa_supplicant[903]: Trying to authenticate with 00:08:5c:ec:05:a4 (SSID='HOME' freq=2462 MHz)
Jan 20 11:51:13 laptop kernel: [ 3473.586889] wlan0: direct probe to 00:08:5c:ec:05:a4 (try
1/3)
Jan 20 11:51:14 laptop kernel: [ 3473.784180] wlan0: direct probe to 00:08:5c:ec:05:a4 (try 2/3)
Jan 20 11:51:14 laptop kernel: [ 3473.984267] wlan0: direct probe to 00:08:5c:ec:05:a4 (try 3/3)
Jan 20 11:51:14 laptop kernel: [ 3474.184281] wlan0: direct probe to 00:08:5c:ec:05:a4 timed out
Jan 20 11:51:16 laptop NetworkManager[4793]: <warn> Activation (wlan0/wireless): association took too long, failing activation.
Jan 20 11:51:16 laptop NetworkManager[4793]: <info> (wlan0): device state change: config -> failed (reason 'supplicant-timeout') [50 120 11]
Jan 20 11:51:16 laptop NetworkManager[4793]: <warn> Activation (wlan0) failed for access point (HOME)
Jan 20 11:51:16 laptop NetworkManager[4793]: <warn> Activation (wlan0) failed.
Jan 20 11:51:16 laptop NetworkManager[4793]: <info> (wlan0): device state change: failed -> disconnected (reason 'none') [120 30 0]
Jan 20 11:51:16 laptop
NetworkManager[4793]: <info> (wlan0): deactivating device (reason 'none') [0]
Jan 20 11:51:16 laptop NetworkManager[4793]: <info> (wlan0): supplicant interface state: authenticating -> disconnected
Jan 20 11:51:16 laptop NetworkManager[4793]: <warn> Couldn't disconnect supplicant interface: This interface is not connected.


Please note that other devices (like my android mobile) do not have this problem and these devices associate with the same access point without any problem from larger distance (10-20 meters).

When the problem occurs the laptop detects wireless network but does not associate with the access point. Scanning the network gives following output -

laptop arun # iwconfig wlan0
wlan0     IEEE 802.11abg  ESSID:off/any  
          Mode:Managed 
Frequency:2.462 GHz  Access Point: Not-Associated   
          Tx-Power=16 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off

laptop arun # iwlist wlan0 scan
wlan0     Scan completed :
          Cell 01 - Address: 00:08:5C:EC:05:A4
                    Channel:11
                    Frequency:2.462 GHz (Channel 11)
                    Quality=49/70  Signal level=-61 dBm  
                    Encryption key:off
                    ESSID:"HOME"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
                              24 Mb/s; 36 Mb/s; 54 Mb/s
                    Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 48 Mb/s
                    Mode:Master
                    Extra:tsf=00000001d85d0186
                    Extra: Last beacon: 1700ms ago
                    IE: Unknown: 0004484F4D45
                    IE: Unknown: 010882848B962430486C
                    IE: Unknown: 03010B
                    IE: Unknown: 050400010000
                    IE: Unknown: 2A0100
                    IE: Unknown: 2F0100
                    IE: Unknown: 32040C121860
                    IE: Unknown: DD060010180201F4

laptop arun # iw dev wlan0 scan
command failed: Device or resource busy (-16)
laptop arun # iw dev wlan0 scan
BSS 00:08:5c:ec:05:a4 (on wlan0)
    TSF: 7946445194 usec (0d, 02:12:26)
    freq: 2462
    beacon interval: 100
    capability: ESS ShortSlotTime (0x0401)
    signal: -59.00 dBm
    last seen: 1708 ms ago
    SSID: HOME
    Supported rates: 1.0* 2.0* 5.5* 11.0* 18.0 24.0 36.0 54.0 
    DS Parameter set: channel 11
    TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0x0 Bitmap[0] 0x0
    ERP: <no flags>
    Extended supported rates: 6.0 9.0 12.0 48.0 


Following wireless drivers are loaded on my laptop -

laptop arun # lsmod | grep iw
iwl3945                73111  0 
iwl_legacy             71134  1 iwl3945
mac80211              436455  2 iwl3945,iwl_legacy
cfg80211              178679  3 iwl3945,iwl_legacy,mac80211

It should be noted that the problem occurs even when I enable wireless security (WPA2-PSK). When I enable WiFi security, the network manager keeps on asking the password after almost every minute, even though I supply the correct password, it didn't connect. It also happens on disabling wifi security.

I did a lot of R&D on Internet but nothing worked. I installed wicd in place of network-manager but that too didn't help.

Kindly help.


Thanks and regards,
Arun          
