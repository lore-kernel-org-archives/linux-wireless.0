Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:57218 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932364AbdJ0BAE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Oct 2017 21:00:04 -0400
Received: by mail-wr0-f195.google.com with SMTP id r79so4735299wrb.13
        for <linux-wireless@vger.kernel.org>; Thu, 26 Oct 2017 18:00:03 -0700 (PDT)
From: nirinA raseliarison <nirina.raseliarison@gmail.com>
Subject: Re: rtlwifi oops
To: Larry Finger <Larry.Finger@lwfinger.net>,
        James Cameron <quozl@laptop.org>,
        linux-wireless@vger.kernel.org
References: <cf61cfda-1e32-3ec3-d558-b508c3b923b6@gmail.com>
 <20171018223320.GB641@us.netrek.org>
 <c13aa975-6339-2f5a-20bb-0a82656a2271@gmail.com>
 <fcf4b761-d7bd-7956-fa98-07fd8b2f8c3b@lwfinger.net>
 <b86480bd-49b9-f7ac-5dc5-6f6f83942727@gmail.com>
 <d65baa01-c842-0d14-5760-bbc1c754b1e6@lwfinger.net>
 <d9e6052f-cc92-813b-6cd6-9907f5bd82be@gmail.com>
Message-ID: <a1ca0a52-c033-205a-8b3e-e6879016728c@gmail.com> (sfid-20171027_030009_732332_0DB0AA9C)
Date: Fri, 27 Oct 2017 04:08:48 +0300
MIME-Version: 1.0
In-Reply-To: <d9e6052f-cc92-813b-6cd6-9907f5bd82be@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi all,
i applied the patch against 4.13.8. i still got some trouble, dmesg is 
below.
after i plugged the device, it seems to be detected and all modules loaded,
but when i tried to connect to an access point, by using wicd, it halted 
after
a while. at this point, all usb ports are broken, there was no more log 
in dmesg,
lsusb still showed the device even after being unplugged. it got even 
worse as
reboot failed.
i cannot really trace the error as right now all thing works fine.

##

[101297.211119] usb 2-1.4: new high-speed USB device number 6 using ehci-pci
[101297.290836] usb 2-1.4: New USB device found, idVendor=0bda, 
idProduct=8178
[101297.290839] usb 2-1.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[101297.290840] usb 2-1.4: Product: 802.11n WLAN Adapter
[101297.290841] usb 2-1.4: Manufacturer: Realtek
[101297.290842] usb 2-1.4: SerialNumber: 00e04c000001
[101297.841845] rtl8192cu: Chip version 0x11
[101297.973333] rtl8192cu: Board Type 0
[101297.973581] rtl_usb: rx_max_size 15360, rx_urb_num 8, in_ep 1
[101297.973621] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
[101297.973743] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[101297.973923] usbcore: registered new interface driver rtl8192cu
[101298.013513] usbcore: registered new interface driver rtl8xxxu
[101298.113014] rtl8192cu 2-1.4:1.0 wlan125: renamed from wlan0
[101298.116255] rtl8192cu 2-1.4:1.0 wlan4: renamed from wlan125
[101298.319580] usb 2-1.4: USB disconnect, device number 6
[101298.508120] usb 2-1.4: new high-speed USB device number 7 using ehci-pci
[101298.748134] usb 2-1.4: new high-speed USB device number 8 using ehci-pci
[101298.827700] usb 2-1.4: New USB device found, idVendor=0bda, 
idProduct=8178
[101298.827702] usb 2-1.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[101298.827703] usb 2-1.4: Product: 802.11n WLAN Adapter
[101298.827704] usb 2-1.4: Manufacturer: Realtek
[101298.827705] usb 2-1.4: SerialNumber: 00e04c000001
[101298.828320] rtl8192cu: Chip version 0x11
[101298.907705] rtl8192cu: Board Type 0
[101298.907945] rtl_usb: rx_max_size 15360, rx_urb_num 8, in_ep 1
[101298.907976] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
[101298.908145] ieee80211 phy1: Selected rate control algorithm 'rtl_rc'
[101298.922774] rtl8192cu 2-1.4:1.0 wlan124: renamed from wlan0
[101298.926242] rtl8192cu 2-1.4:1.0 wlan4: renamed from wlan124
[101312.904723] rtl8192cu: MAC auto ON okay!
[101312.939101] rtl8192cu: Tx queue select: 0x05
[101313.541630] IPv6: ADDRCONF(NETDEV_UP): wlan4: link is not ready
[101322.297910] rtl8192cu: MAC auto ON okay!
[101322.331036] rtl8192cu: Tx queue select: 0x05
[101322.933065] IPv6: ADDRCONF(NETDEV_UP): wlan4: link is not ready
[101323.089905] rtl8192cu: MAC auto ON okay!
[101323.122907] rtl8192cu: Tx queue select: 0x05
[101323.730181] IPv6: ADDRCONF(NETDEV_UP): wlan4: link is not ready
[101325.455267] usb 2-1.4: USB disconnect, device number 8
[101325.460166] rtl_usb: reg 0x102, usbctrl_vendorreq TimeOut! 
status:0xffffffed value=0xf90000
[101325.460168] rtl_usb: reg 0x422, usbctrl_vendorreq TimeOut! 
status:0xffffffed value=0x1000000
[101325.460171] rtl_usb: reg 0x542, usbctrl_vendorreq TimeOut! 
status:0xffffffed value=0x3fd0000
[101325.460186] rtl_usb: reg 0x102, usbctrl_vendorreq TimeOut! 
status:0xffffffed value=0xf90000
[101325.655146] usb 2-1.4: new high-speed USB device number 9 using ehci-pci
[101325.734893] usb 2-1.4: New USB device found, idVendor=0bda, 
idProduct=8178
[101325.734897] usb 2-1.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[101325.734898] usb 2-1.4: Product: 802.11n WLAN Adapter
[101325.734899] usb 2-1.4: Manufacturer: Realtek
[101325.734900] usb 2-1.4: SerialNumber: 00e04c000001
[101325.735636] rtl8192cu: Chip version 0x11
[101325.812035] rtl8192cu: Board Type 0
[101325.812394] rtl_usb: rx_max_size 15360, rx_urb_num 8, in_ep 1
[101325.812470] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
[101325.812725] ieee80211 phy2: Selected rate control algorithm 'rtl_rc'
[101325.827120] rtl8192cu 2-1.4:1.0 wlan123: renamed from wlan0
[101325.832254] rtl8192cu 2-1.4:1.0 wlan4: renamed from wlan123
[101332.879463] usb 2-1.4: USB disconnect, device number 9
[101333.072149] usb 2-1.4: new high-speed USB device number 10 using 
ehci-pci
[101333.151841] usb 2-1.4: New USB device found, idVendor=0bda, 
idProduct=8178
[101333.151843] usb 2-1.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[101333.151845] usb 2-1.4: Product: 802.11n WLAN Adapter
[101333.151846] usb 2-1.4: Manufacturer: Realtek
[101333.151847] usb 2-1.4: SerialNumber: 00e04c000001
[101333.152585] rtl8192cu: Chip version 0x11
[101333.229738] rtl8192cu: Board Type 0
[101333.229963] rtl_usb: rx_max_size 15360, rx_urb_num 8, in_ep 1
[101333.230038] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
[101333.230298] ieee80211 phy3: Selected rate control algorithm 'rtl_rc'
[101333.491111] rtl8192cu 2-1.4:1.0 wlan122: renamed from wlan0
[101333.496349] rtl8192cu 2-1.4:1.0 wlan4: renamed from wlan122
[101334.226575] rtl8192cu: MAC auto ON okay!
[101334.260084] rtl8192cu: Tx queue select: 0x05
[101334.859863] IPv6: ADDRCONF(NETDEV_UP): wlan4: link is not ready
[101335.962440] wlan4: authenticate with 16:6b:72:6d:9d:fc
[101335.986731] wlan4: send auth to 16:6b:72:6d:9d:fc (try 1/3)
[101335.990957] wlan4: authenticated
[101335.991154] wlan4: associate with 16:6b:72:6d:9d:fc (try 1/3)
[101336.001221] wlan4: RX AssocResp from 16:6b:72:6d:9d:fc (capab=0x431 
status=0 aid=1)
[101336.103329] wlan4: associated
[101336.103374] IPv6: ADDRCONF(NETDEV_CHANGE): wlan4: link becomes ready
[101340.303166] usb 2-1.4: USB disconnect, device number 10
[101340.307127] wlan4: deauthenticating from 16:6b:72:6d:9d:fc by local 
choice (Reason: 3=DEAUTH_LEAVING)
[101340.512116] usb 2-1.4: new high-speed USB device number 11 using 
ehci-pci
[101340.591917] usb 2-1.4: New USB device found, idVendor=0bda, 
idProduct=8178
[101340.591919] usb 2-1.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[101340.591920] usb 2-1.4: Product: 802.11n WLAN Adapter
[101340.591921] usb 2-1.4: Manufacturer: Realtek
[101340.591922] usb 2-1.4: SerialNumber: 00e04c000001
[101340.592659] rtl8192cu: Chip version 0x11
[101340.674039] rtl8192cu: Board Type 0
[101340.674283] rtl_usb: rx_max_size 15360, rx_urb_num 8, in_ep 1
[101340.674313] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
[101340.674430] ieee80211 phy4: Selected rate control algorithm 'rtl_rc'
[101340.684805] rtl8192cu 2-1.4:1.0 wlan121: renamed from wlan0
[101340.689245] rtl8192cu 2-1.4:1.0 wlan4: renamed from wlan121
[101340.695908] rtl8192cu: MAC auto ON okay!
[101340.735041] rtl8192cu: Tx queue select: 0x05
[101341.500551] rtl8192c_common: Polling FW ready fail! 
REG_MCUFWDL:0x00030006.
[101341.500552] rtl8192c_common: Firmware is not ready to run!
[101341.855695] IPv6: ADDRCONF(NETDEV_UP): wlan4: link is not ready
[101342.201571] rtl8192cu: 8051 reset failed!.........................
[101343.273517] rtl8192cu: MAC auto ON okay!
[101343.306265] rtl8192cu: Tx queue select: 0x05
[101343.917002] IPv6: ADDRCONF(NETDEV_UP): wlan4: link is not ready
[101347.486500] rtl8192cu: MAC auto ON okay!
[101348.239112] usb 2-1.4: USB disconnect, device number 11
[101348.240514] rtl8192cu: Tx queue select: 0x05

##

--
nirinA
