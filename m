Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54281 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaJFUPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 16:15:47 -0400
Received: by mail-wg0-f42.google.com with SMTP id z12so7503662wgg.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Oct 2014 13:15:46 -0700 (PDT)
Message-ID: <5432F870.8060408@gmail.com> (sfid-20141006_221552_488704_2502E994)
Date: Mon, 06 Oct 2014 22:15:44 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	driverdev-devel@linuxdriverproject.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: RTL8188SU(r8712u) - Unable to suspend/resume
References: <54288813.60601@gmail.com>
In-Reply-To: <54288813.60601@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


$ dmesg
...
[    1.462812] usb 1-4: new high-speed USB device number 4 using ehci-pci
[    1.579359] usb 1-4: New USB device found, idVendor=0bda, idProduct=8171
[    1.579360] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.579361] usb 1-4: Product: RTL8188S WLAN Adapter 
[    1.579362] usb 1-4: Manufacturer: Manufacturer Realtek 
[    1.579363] usb 1-4: SerialNumber: 00e04c000001
[    2.026431] usb 2-3: Product: 802.11 n WLAN
[   21.295330] r8712u: module is from the staging directory, the quality is unknown, you have been warned.
[   21.296110] r8712u: Staging version
[   21.296288] r8712u: register rtl8712_netdev_ops to netdev_ops
[   21.296583] usb 1-4: r8712u: USB_SPEED_HIGH with 4 endpoints
[   21.297469] usb 1-4: r8712u: Boot from EFUSE: Autoload OK
[   21.863363] usb 1-4: r8712u: CustomerID = 0x0000
[   21.864014] usb 1-4: r8712u: MAC Address from efuse = 00:11:22:33:44:55
[   21.864622] usb 1-4: r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
[   21.865330] usbcore: registered new interface driver r8712u
[   21.980454] r8712u 1-4:1.0 wlp0s2f1u4: renamed from wlan0
[   21.997197] systemd-udevd[452]: renamed network interface wlan0 to wlp0s2f1u4
[   28.252740] r8712u 1-4:1.0 wlp0s2f1u4: 1 RCR=0x153f00e
[   28.253856] r8712u 1-4:1.0 wlp0s2f1u4: 2 RCR=0x553f00e
[   28.359221] IPv6: ADDRCONF(NETDEV_UP): wlp0s2f1u4: link is not ready
[   28.664239] IPv6: ADDRCONF(NETDEV_UP): wlp0s2f1u4: link is not ready
[   28.978248] IPv6: ADDRCONF(NETDEV_UP): wlp0s2f1u4: link is not ready
[   56.734442] IPv6: ADDRCONF(NETDEV_CHANGE): wlp0s2f1u4: link becomes ready
...


$ nmcli device 
DEVICE      TYPE      STATE      CONNECTION 
wlp0s2f1u4  wifi      connected  ap   


$ iwconfig wlp0s2f1u4 
wlp0s2f1u4  IEEE 802.11bgn  ESSID:"ap"  Nickname:"rtl_wifi"
          Mode:Managed  Frequency:2.457 GHz  Access Point: 00:11:33:55:77:99   
          Bit Rate:150 Mb/s   Sensitivity:0/0  
          Retry:off   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality=98/100  Signal level=48/100  Noise level=0/100
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0


$ systemctl suspend


$ dmesg
...
[ 6218.212944] IPv6: ADDRCONF(NETDEV_CHANGE): wlp0s2f1u4: link becomes ready
[ 6218.426509] IPv6: ADDRCONF(NETDEV_UP): wlp0s2f1u4: link is not ready
[ 6219.437930] r8712u 1-4:1.0 wlp0s2f1u4: Suspending...
[ 6219.437932] r8712u 1-4:1.0 wlp0s2f1u4: Unable to suspend
[ 6222.063982] r8712u 1-4:1.0 wlp0s2f1u4: Resuming...
[ 6222.063984] r8712u 1-4:1.0 wlp0s2f1u4: Unable to resume
[ 6222.380137] IPv6: ADDRCONF(NETDEV_UP): wlp0s2f1u4: link is not ready
[ 6222.703179] IPv6: ADDRCONF(NETDEV_UP): wlp0s2f1u4: link is not ready
[ 6222.718697] r8712u 1-4:1.0 wlp0s2f1u4: In r8711_wx_set_scan: bDriverStopped=1
[ 6246.403973] r8712u 1-4:1.0 wlp0s2f1u4: In r8711_wx_set_scan: bDriverStopped=1
[ 6269.423294] r8712u 1-4:1.0 wlp0s2f1u4: In r8711_wx_set_scan: bDriverStopped=1
[ 6302.435194] r8712u 1-4:1.0 wlp0s2f1u4: In r8711_wx_set_scan: bDriverStopped=1
...


$ nmcli radio wifi 
enabled


$ nmcli device 
DEVICE      TYPE      STATE         CONNECTION 
wlp0s2f1u4  wifi      disconnected  --         


$ iwconfig wlp0s2f1u4 
wlp0s2f1u4  unassociated  Nickname:"rtl_wifi"
          Mode:Managed  Access Point: Not-Associated   Sensitivity:0/0  
          Retry:off   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0


$ nmcli device connect wlp0s2f1u4 
Error: Device activation failed: The device has no connections available.


# modprobe -rv r8712u && modprobe -v r8712u
rmmod r8712u
insmod /lib/modules/3.17.0-1.fc21.x86_64/kernel/drivers/staging/rtl8712/r8712u.ko.xz 


$ dmesg
...
[ 6809.514301] usbcore: deregistering interface driver r8712u
[ 6809.858958] usb 1-4: reset high-speed USB device number 4 using ehci-pci
[ 6809.992458] r8712u: module is from the staging directory, the quality is unknown, you have been warned.
[ 6809.993163] r8712u: Staging version
[ 6809.993182] r8712u: register rtl8712_netdev_ops to netdev_ops
[ 6809.993187] usb 1-4: r8712u: USB_SPEED_HIGH with 4 endpoints
[ 6809.994152] usb 1-4: r8712u: Boot from EFUSE: Autoload OK
[ 6810.373993] usb 1-4: r8712u: CustomerID = 0x0000
[ 6810.374007] usb 1-4: r8712u: MAC Address from efuse = 00:11:22:33:44:55
[ 6810.374015] usb 1-4: r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
[ 6810.374824] usbcore: registered new interface driver r8712u
[ 6810.380437] r8712u 1-4:1.0 wlp0s2f1u4: renamed from wlan0
[ 6810.395219] systemd-udevd[3533]: renamed network interface wlan0 to wlp0s2f1u4
[ 6811.110320] r8712u 1-4:1.0 wlp0s2f1u4: 1 RCR=0x153f00e
[ 6811.110849] r8712u 1-4:1.0 wlp0s2f1u4: 2 RCR=0x553f00e
[ 6811.215147] IPv6: ADDRCONF(NETDEV_UP): wlp0s2f1u4: link is not ready
[ 6811.520143] IPv6: ADDRCONF(NETDEV_UP): wlp0s2f1u4: link is not ready
[ 6811.827149] IPv6: ADDRCONF(NETDEV_UP): wlp0s2f1u4: link is not ready
[ 6832.218387] IPv6: ADDRCONF(NETDEV_CHANGE): wlp0s2f1u4: link becomes ready
...


$ nmcli device 
DEVICE      TYPE      STATE      CONNECTION 
wlp0s2f1u4  wifi      connected  sunlight   


$ iwconfig wlp0s2f1u4 
wlp0s2f1u4  IEEE 802.11bgn  ESSID:"ap"  Nickname:"rtl_wifi"
          Mode:Managed  Frequency:2.457 GHz  Access Point: 00:11:33:55:77:99   
          Bit Rate:150 Mb/s   Sensitivity:0/0  
          Retry:off   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality=90/100  Signal level=47/100  Noise level=0/100
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0


poma


