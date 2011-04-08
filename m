Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59380 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887Ab1DHOAe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 10:00:34 -0400
Received: by vxi39 with SMTP id 39so2720017vxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2011 07:00:34 -0700 (PDT)
Message-ID: <4D9F14FE.8060905@lwfinger.net>
Date: Fri, 08 Apr 2011 09:00:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Igor Plyatov <plyatov@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	George <george0505@realtek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: net/wireless/rtlwifi: problem with D-link DWA-131 USB adapter
References: <4D9F0DAE.30809@gmail.com>
In-Reply-To: <4D9F0DAE.30809@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/08/2011 08:29 AM, Igor Plyatov wrote:
> Dear developers,
>
> I was trying to use "r8712u" staging driver on my ARM platform and it works fine
> with "D-link DWA-131" USB Wi-Fi adapter.
> Then I try to use rt8192cu driver from wireless-testing GIT repository (last
> commit is 001354fa8f95219a9bf7acd60937edd5b5c02ab1).
>
> I have firmware files installed:
> root@gms:~# ls -l /lib/firmware/rtlwifi/
> -rw-r--r-- 1 root root 13540 Apr 4 14:22 rtl8192cfw.bin
> -rw-r--r-- 1 root root 16014 Apr 4 14:22 rtl8192cufw.bin
> -rw-r--r-- 1 root root 20526 Apr 4 14:22 rtl8192defw.bin
> -rw-r--r-- 1 root root 88856 Apr 4 14:22 rtl8192sefw.bin
> -rw-r--r-- 1 root root 122328 Apr 4 14:22 rtl8712u.bin
>
> Look at lsusb:
>
> Bus 001 Device 011: ID 07d1:3303 D-Link System
>
> and add an identifiers to detect D-link DWA-131 by simple patch:
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/
> index 71244a3..cf41fd7 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> @@ -296,6 +296,7 @@ static struct usb_device_id rtl8192c_usb_ids[] = {
> {RTL_USB_DEVICE(0x07aa, 0x0056, rtl92cu_hal_cfg)}, /*ATKK-Gemtek*/
> {RTL_USB_DEVICE(0x07b8, 0x8178, rtl92cu_hal_cfg)}, /*Funai -Abocom*/
> {RTL_USB_DEVICE(0x07b8, 0x8178, rtl92cu_hal_cfg)}, /*Abocom -Abocom*/
> + {RTL_USB_DEVICE(0x07d1, 0x3303, rtl92cu_hal_cfg)}, /*D-Link DWA-131*/
> {RTL_USB_DEVICE(0x2001, 0x3307, rtl92cu_hal_cfg)}, /*D-Link-Cameo*/
> {RTL_USB_DEVICE(0x2001, 0x3309, rtl92cu_hal_cfg)}, /*D-Link-Alpha*/
> {RTL_USB_DEVICE(0x2001, 0x330a, rtl92cu_hal_cfg)}, /*D-Link-Alpha*/
>
> Then, remove staging driver, OFF/On device and adapter plugged into the USB bus:
> root@gms:~# usb 1-2: new full speed USB device number 2 using at91_ohci
>
> Load the driver:
> root@gms:~# modprobe rtl8192cu
> rtl8192cu: MAC address: 9a:f4:17:03:4d:61
> rtl8192cu: Board Type 0
> rtl8192cu: rx_max_size 15360, rx_urb_num 8, in_ep 1
> usbcore: registered new interface driver rtl8192cu
>
> dmesg says:
> ...
> usb 1-2: new full speed USB device number 2 using at91_ohci
> rtl8192cu: MAC address: 9a:f4:17:03:4d:61
> rtl8192cu: Board Type 0
> rtl8192cu: rx_max_size 15360, rx_urb_num 8, in_ep 1
> ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
> usbcore: registered new interface driver rtl8192cu
> ...
>
> Then issue some commands:
> root@gms:~# iwconfig wlan0
> wlan0 IEEE 802.11bgn ESSID:off/any
> Mode:Managed Access Point: Not-Associated Tx-Power=0 dBm
> Retry long limit:7 RTS thr=2347 B Fragment thr:off
> Encryption key:off
> Power Management:on
>
> root@gms:~# iw dev wlan0 scan
> command failed: Network is down (-100)
>
> root@gms:~# iw phy
> Wiphy phy0
> Band 1:
> Capabilities: 0x1862
> HT20/HT40
> Static SM Power Save
> RX HT20 SGI
> RX HT40 SGI
> No RX STBC
> Max AMSDU length: 7935 bytes
> DSSS/CCK HT40
> Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
> Minimum RX AMPDU time spacing: 16 usec (0x07)
> HT TX/RX MCS rate indexes supported: 0-7, 32
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
> * 2467 MHz [12] (20.0 dBm)
> * 2472 MHz [13] (20.0 dBm)
> * 2484 MHz [14] (disabled)
> Bitrates (non-HT):
> * 1.0 Mbps
> * 2.0 Mbps
> * 5.5 Mbps
> * 11.0 Mbps
> * 6.0 Mbps
> * 9.0 Mbps
> * 12.0 Mbps
> * 18.0 Mbps
> * 24.0 Mbps
> * 36.0 Mbps
> * 48.0 Mbps
> * 54.0 Mbps
> max # scan SSIDs: 4
> max scan IEs length: 2257 bytes
> RTS threshold: 2347
> Coverage class: 0 (up to 0m)
> Supported interface modes:
> * IBSS
> * managed
> * monitor
> Supported commands:
> * new_interface
> * set_interface
> * new_key
> * new_beacon
> * new_station
> * set_bss
> * authenticate
> * associate
> * deauthenticate
> * disassociate
> * join_ibss
> * remain_on_channel
> * set_tx_bitrate_mask
> * action
> * Unknown command (67)
> * set_wiphy_netns
> * set_channel
> * Unknown command (66)
> * connect
> * disconnect
>
> root@gms:~# iw dev wlan0 link
> Not connected.
>
> I try to reconfigure network interfaces by next command:
> ...
> root@gms:~# /etc/init.d/networking restart
> Reconfiguring network interfaces... dhcpcd[1784]: dhcpcd not running
> ifdown: warning: no dhcp clients found and stopped
> dhcpcd[1790]: sending signal 1 to pid 1669
> dhcpcd[1790]: waiting for pid 1669 to exit
> eth0: link down
> WPA: Configuring Interface
> ...
>
> Everything stops here and nothing happened.
>
> Please, help me to resolve this issue.
>
> P.S.: Adapter does not blinks by LED at all with rtl8192cu driver.

The driver rtl8192cu is for the RTL8192CU/RTL8188CU chips. The DWA-131 contains 
an RTL8192SU chip. It cannot be driven by rtl8192cu - it will never work.

On my TODO list is the preparation of a driver named rtl8192su, but since r8712u 
works, the priority is low. I'm much more interested in getting the drivers for 
the RTL8192SE and RTL8192DE chips into the kernel. Note that rtl8192su will 
share a lot of code with rtl8192se in the same fashion that rtl8192ce and 
rtl8192cu share routines.

When I prepared the r8712u driver for staging, I did not worry about the LED, 
which is why it doesn't blink. What kind of LED action do you prefer. Some users 
only want the LED on when the interface is active and complain when it blinks. 
Others want it to blink when transmitting.

Larry
