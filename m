Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 50-200-239-73-static.hfc.comcastbusiness.net ([50.200.239.73]:52181
        "EHLO pdtms03.pdt.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751581AbcIMMvz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 08:51:55 -0400
From: "Merchut, Addison" <addison.merchut@pdt.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: FW: {SOLVED }RE: Only one of two Intel Wireless 7260 PCI Cards are
 assigned a logical name (ubuntu 16.04 :: 4.7.0-040700-generic )
Date: Tue, 13 Sep 2016 12:51:53 +0000
Message-ID: <6c37c5f6b9be4808a13cc9bf33626463@pdtms03.pdt.com> (sfid-20160913_145159_172724_B6F53357)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



From: Merchut, Addison 
Sent: Tuesday, September 13, 2016 7:51 AM
To: 'linuxwifi@intel.com' <linuxwifi@intel.com>; 'linux-wireless@vger.kernel.org' <linux-wireless@vger.kernel.org>
Cc: Nudo, Al <Al.Nudo@pdt.com>; Unetich, Rich <Rich.Unetich@pdt.com>; DeCarlo, Bob <Bob.DeCarlo@pdt.com>
Subject: {SOLVED }RE: Only one of two Intel Wireless 7260 PCI Cards are assigned a logical name (ubuntu 16.04 :: 4.7.0-040700-generic )

I have solved this issue after finding this page: https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/core_release
Thank you for your documentation. It is very friendly and easy to read. 

If I may, I suggest that you please point https://wireless.wiki.kernel.org/en/users/Drivers/iwlwifi to the core_release page in some equally friendly way. 

Thanks again, and keep up the great work .

From: Merchut, Addison 
Sent: Monday, September 12, 2016 3:21 PM
To: 'linuxwifi@intel.com' <linuxwifi@intel.com>; 'linux-wireless@vger.kernel.org' <linux-wireless@vger.kernel.org>
Cc: Nudo, Al <Al.Nudo@pdt.com>; Unetich, Rich <Rich.Unetich@pdt.com>; DeCarlo, Bob <Bob.DeCarlo@pdt.com>
Subject: Only one of two Intel Wireless 7260 PCI Cards are assigned a logical name (ubuntu 16.04 :: 4.7.0-040700-generic )

I believe I have an issue with the Intel wireless 7260 pci cards on my linux desktop

I have two wireless cards on a test PC I'm working on. And while I can see both cards, only the top card (in the physical location) is actually getting assigned the logical (interface) name.

This seems to be interment (though I've only had this computer running for two days) because there has been at least one occasion that I have seen both cards assigned an interface name at the same time (via ifconfig and NM). However, when I've had to restart the computer, the names are not always assigned for the 2nd (bottom) card -this is the case most of the time. 

Attached is the dmesg for the case where I was able to get both cards to work (dm.txt) and the case where I am not able to get both cards to work (dmbad.txt)

I've switched out the cards (with other 7260 cards), move the cards to other locations, exchanged the locations of the cards, BUT only the top most device is ever assigned the an interface name.
I'm running: 4.7.0-040700-generic GNU/Linux Ubuntu 16.04.1 LTS

The two cards are the same Intel Corporation Wireless 7260:
# cat /sys/bus/pci/devices/0000\:01\:00.0/uevent 
                DRIVER=iwlwifi
                PCI_CLASS=28000
                PCI_ID=8086:08B1
                PCI_SUBSYS_ID=8086:4070
                PCI_SLOT_NAME=0000:01:00.0
                MODALIAS=pci:v00008086d000008B1sv00008086sd00004070bc02sc80i00
# cat /sys/bus/pci/devices/0000\:02\:00.0/uevent 
                DRIVER=iwlwifi
                PCI_CLASS=28000
                PCI_ID=8086:08B1
                PCI_SUBSYS_ID=8086:4070
                PCI_SLOT_NAME=0000:02:00.0
                MODALIAS=pci:v00008086d000008B1sv00008086sd00004070bc02sc80i00

Only one of the devices is getting assigned a logical name:
#sudo lshw -class network
                  ....
                  *-network               
                       description: Wireless interface
                       product: Wireless 7260
                       vendor: Intel Corporation
                       physical id: 0
                       bus info: pci@0000:01:00.0
                       logical name: wlp1s0
                       version: 73
                       serial: 7c:5c:f8:d2:6c:52
                       width: 64 bits
                       clock: 33MHz
                       capabilities: pm msi pciexpress bus_master cap_list ethernet physical wireless
                       configuration: broadcast=yes driver=iwlwifi driverversion=4.7.0-040700-generic firmware=16.242414.0 latency=0 link=no multicast=yes wireless=IEEE 802.11
                       resources: irq:32 memory:f7d00000-f7d01fff
                  *-network
                       description: Network controller
                       product: Wireless 7260
                       vendor: Intel Corporation
                       physical id: 0
                       bus info: pci@0000:02:00.0
                       version: 73
                       width: 64 bits
                       clock: 33MHz
                       capabilities: pm msi pciexpress bus_master cap_list
                       configuration: driver=iwlwifi latency=0
                       resources: irq:33 memory:f7c00000-f7c01fff



dmesg does not show that the 2nd device on bus 0000:02:00.0 has been detected by the wifi driver

{Attached as dmbad.txt}


and ifconfig only shows one device (obviously since lshw showed that only one was getting assigned a logical name)

#ifconfig 
...
                  wlp1s0    Link encap:Ethernet  HWaddr 7c:5c:f8:d2:6c:52  
                                    UP BROADCAST MULTICAST  MTU:1500  Metric:1
                                    RX packets:0 errors:0 dropped:0 overruns:0 frame:0
                                    TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
                                    collisions:0 txqueuelen:1000 
                                    RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)


#ls /lib/firmware | grep 7260
                iwlwifi-7260-10.ucode
                iwlwifi-7260-12.ucode
                iwlwifi-7260-13.ucode
                iwlwifi-7260-14.ucode
                iwlwifi-7260-16.ucode
                iwlwifi-7260-7.ucode
                iwlwifi-7260-8.ucode
                iwlwifi-7260-9.ucode

#modinfo iwlwifi
                  filename:       /lib/modules/4.7.0-040700-generic/kernel/drivers/net/wireless/intel/iwlwifi/iwlwifi.ko
                  license:        GPL
                  author:         Copyright(c) 2003- 2015 Intel Corporation <linuxwifi@intel.com>
                  description:    Intel(R) Wireless WiFi driver for Linux
                  firmware:       iwlwifi-100-5.ucode
                  firmware:       iwlwifi-1000-5.ucode
                  firmware:       iwlwifi-135-6.ucode
                  firmware:       iwlwifi-105-6.ucode
                  firmware:       iwlwifi-2030-6.ucode
                  firmware:       iwlwifi-2000-6.ucode
                  firmware:       iwlwifi-5150-2.ucode
                  firmware:       iwlwifi-5000-5.ucode
                  firmware:       iwlwifi-6000g2b-IWL6000G2B_UCODE_API_MAX.ucode
                  firmware:       iwlwifi-6000g2a-6.ucode
                  firmware:       iwlwifi-6050-5.ucode
                  firmware:       iwlwifi-6000-6.ucode
                  firmware:       iwlwifi-7265D-21.ucode
                  firmware:       iwlwifi-7265-17.ucode
                  firmware:       iwlwifi-3168-21.ucode
                  firmware:       iwlwifi-3160-17.ucode
                  firmware:       iwlwifi-7260-17.ucode
                  firmware:       iwlwifi-8265-21.ucode
                  firmware:       iwlwifi-8000C--21.ucode
                  firmware:       iwlwifi-9260-th-a0-lc-a0--21.ucode
                  firmware:       iwlwifi-9260-th-a0-jf-a0--21.ucode
                  firmware:       iwlwifi-9000-pu-a0-lc-a0--21.ucode
                  alias:          pci:v00008086d00009DF0sv*sd00002A10bc*sc*i*
                  alias:          pci:v00008086d00009DF0sv*sd00000710bc*sc*i*
                  ....
                  depends:        cfg80211
                  intree:         Y
                  vermagic:       4.7.0-040700-generic SMP mod_unload modversions 
                  parm:           swcrypto:using crypto in software (default 0 [hardware]) (int)
                  parm:           11n_disable:disable 11n functionality, bitmap: 1: full, 2: disable agg TX, 4: disable agg RX, 8 enable agg TX (uint)
                  parm:           amsdu_size:amsdu size 0:4K 1:8K 2:12K (default 0) (int)
                  parm:           fw_restart:restart firmware in case of error (default true) (bool)
                  parm:           antenna_coupling:specify antenna coupling in dB (default: 0 dB) (int)
                  parm:           nvm_file:NVM file name (charp)
                  parm:           d0i3_disable:disable d0i3 functionality (default: Y) (bool)
                  parm:           lar_disable:disable LAR functionality (default: N) (bool)
                  parm:           uapsd_disable:disable U-APSD functionality bitmap 1: BSS 2: P2P Client (default: 3) (uint)
                  parm:           bt_coex_active:enable wifi/bt co-exist (default: enable) (bool)
                  parm:           led_mode:0=system default, 1=On(RF On)/Off(RF Off), 2=blinking, 3=Off (default: 0) (int)
                  parm:           power_save:enable WiFi power management (default: disable) (bool)
                  parm:           power_level:default power save level (range from 1 - 5, default: 1) (int)
                  parm:           fw_monitor:firmware monitor - to debug FW (default: false - needs lots of memory) (bool)
                  parm:           d0i3_timeout:Timeout to D0i3 entry when idle (ms) (uint)
                  parm:           disable_11ac:Disable VHT capabilities (default: false) (bool)


Please let me know if there's anything I can do or if this is a known issue. 

Thank you.





Addison
312.620.2094
Skype: addisonpdt
PDT.com


Email secured by Check Point
