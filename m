Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:24795 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341Ab2CWTkx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 15:40:53 -0400
Message-ID: <4F6CD1BC.4040703@hartkopp.net> (sfid-20120323_204058_682500_ABE4B884)
Date: Fri, 23 Mar 2012 20:40:44 +0100
From: Oliver Hartkopp <socketcan@hartkopp.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	David Spinadel <david.spinadel@intel.com>
CC: linux-wireless@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: 3.4-merge: iwlwifi needs more than 1 minute to connect
References: <20120316180428.GD2563@tuxdriver.com>
In-Reply-To: <20120316180428.GD2563@tuxdriver.com>
Content-Type: multipart/mixed;
 boundary="------------070108080107080607020304"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070108080107080607020304
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi all,

i'm using the *very* latest 3.4-merge tree from Linus and my Wifi now needs
more than one minute to connect to my access point.


The working kernel (3.4-merge from March 20th) - this is a pre net-next merge

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.3.0-01180-ged378a5-dirty (hartko@vwagwolkf484) (gcc version 4.6.3 (Debian 4.6.3-1) ) #12 SMP Tue Mar 20 20:29:23 CET 2012
(..)
[    7.924146] cfg80211: Calling CRDA to update world regulatory domain
(..)
[    8.103207] cfg80211: World regulatory domain updated:
[    8.105716] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    8.107984] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.110813] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    8.110842] Bluetooth: Core ver 2.16
[    8.111541] NET: Registered protocol family 31
[    8.111544] Bluetooth: HCI device and connection manager initialized
[    8.111943] usb 2-1.8: new full-speed USB device number 5 using ehci_hcd
[    8.112143] Bluetooth: HCI socket layer initialized
[    8.112147] Bluetooth: L2CAP socket layer initialized
[    8.112149] Bluetooth: SCO socket layer initialized
[    8.128247] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    8.130529] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.132966] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.135647] usbcore: registered new interface driver btusb
[    8.139318] HDMI status: Codec=3 Pin=4 Presence_Detect=0 ELD_Valid=0
[    8.142145] HDMI status: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=0
[    8.145226] HDMI status: Codec=3 Pin=6 Presence_Detect=0 ELD_Valid=0
[    8.147521] input: HDA Intel HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    8.150128] input: HDA Intel HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    8.152548] input: HDA Intel HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    8.155170] input: HDA Intel Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    8.155619] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[    8.155621] Copyright(c) 2003-2011 Intel Corporation
[    8.155869] iwlwifi 0000:02:00.0: pci_resource_len = 0x00002000
[    8.155872] iwlwifi 0000:02:00.0: pci_resource_base = fca60000
[    8.155875] iwlwifi 0000:02:00.0: HW Revision ID = 0x35
[    8.156323] iwlwifi 0000:02:00.0: irq 44 for MSI/MSI-X
[    8.156515] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUG disabled
[    8.156517] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[    8.156520] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[    8.156522] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[    8.156524] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_P2P disabled
[    8.156553] iwlwifi 0000:02:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74
[    8.156826] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[    8.172595] iwlwifi 0000:02:00.0: device EEPROM VER=0x43a, CALIB=0x6
[    8.172597] iwlwifi 0000:02:00.0: Device SKU: 0x1F0
[    8.172629] iwlwifi 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[    8.190096] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    8.192657] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[    8.193646] iwlwifi 0000:02:00.0: loaded firmware version 9.221.4.1 build 25532
[    8.193907] Registered led device: phy0-led
[    8.197691] input: HDA Intel Dock Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[    8.203554] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
(..)
[   11.319886] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   11.330198] iwlwifi 0000:02:00.0: Radio type=0x1-0x3-0x1
[   11.468171] fuse init (API version 7.18)
[   11.573628] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   11.582809] iwlwifi 0000:02:00.0: Radio type=0x1-0x3-0x1
[   11.697919] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   11.998244] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[   12.053243] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[   12.053876] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   14.168257] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input17
[   14.609428] Bluetooth: RFCOMM TTY layer initialized
[   14.609439] Bluetooth: RFCOMM socket layer initialized
[   14.609441] Bluetooth: RFCOMM ver 1.11
[   14.612296] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   14.707784] vcan: Virtual CAN interface driver
[   14.952322] wlan0: authenticate with bc:05:43:94:1a:da (try 1)
[   14.954595] wlan0: authenticated
[   14.955125] wlan0: waiting for beacon from bc:05:43:94:1a:da
[   15.025641] wlan0: beacon received
[   15.051860] wlan0: associate with bc:05:43:94:1a:da (try 1)
[   15.055534] wlan0: RX AssocResp from bc:05:43:94:1a:da (capab=0x431 status=0 aid=4)
[   15.055537] wlan0: associated
[   15.055554] wlan0: moving STA bc:05:43:94:1a:da to state 1
[   15.055555] wlan0: moving STA bc:05:43:94:1a:da to state 2
[   15.055557] wlan0: moving STA bc:05:43:94:1a:da to state 3
[   15.066966] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   25.282260] wlan0: no IPv6 routers present
[   72.850897] netlink: 12 bytes leftover after parsing attributes.
[   72.850908] netlink: 12 bytes leftover after parsing attributes.
[   72.850988] netlink: 12 bytes leftover after parsing attributes.


The broken kernel (3.4-merge from March 23th) - after net-next merge

[    0.000000] Linux version 3.3.0-merge-06154-g934e18b (hartko@vwagwolkf484) (gcc version 4.6.3 (Debian 4.6.3-1) ) #16 SMP Fri Mar 23 19:22:26 CET 2012
(..)
[    8.315220] cfg80211: Calling CRDA to update world regulatory domain
(..)
[    8.398762] cfg80211: World regulatory domain updated:
[    8.398764] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    8.398767] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.398769] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    8.398771] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    8.398772] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.398774] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
(..)
[    8.497252] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[    8.501333] Copyright(c) 2003-2012 Intel Corporation
[    8.504974] iwlwifi 0000:02:00.0: pci_resource_len = 0x00002000
(..)
[    8.527810] iwlwifi 0000:02:00.0: pci_resource_base = fbe5c000
[    8.529982] iwlwifi 0000:02:00.0: HW Revision ID = 0x35
[    8.532399] iwlwifi 0000:02:00.0: irq 44 for MSI/MSI-X
(..)
[    8.552892] iwlwifi 0000:02:00.0: loaded firmware version 9.221.4.1 build 25532
[    8.553272] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUG disabled
[    8.553275] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[    8.553278] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[    8.553280] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[    8.553283] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_P2P disabled
[    8.553287] iwlwifi 0000:02:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74
[    8.553529] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[    8.569704] iwlwifi 0000:02:00.0: device EEPROM VER=0x43a, CALIB=0x6
[    8.569707] iwlwifi 0000:02:00.0: Device SKU: 0x1F0
[    8.569708] iwlwifi 0000:02:00.0: Valid Tx ant: 0x6, Valid Rx ant: 0x6
[    8.569725] iwlwifi 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[    8.569854] Registered led device: phy0-led
[    8.579345] HDMI status: Codec=3 Pin=6 Presence_Detect=0 ELD_Valid=0
[    8.581421] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
(..)
[   11.667627] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   11.678479] iwlwifi 0000:02:00.0: Radio type=0x1-0x3-0x1
[   11.919033] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   11.927719] iwlwifi 0000:02:00.0: Radio type=0x1-0x3-0x1
[   12.047628] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   12.355487] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[   12.410326] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[   12.410821] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   14.271780] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input17
[   14.715648] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   14.715968] Bluetooth: RFCOMM TTY layer initialized
[   14.715973] Bluetooth: RFCOMM socket layer initialized
[   14.715975] Bluetooth: RFCOMM ver 1.11
[   14.802525] vcan: Virtual CAN interface driver
[   16.288562] wlan0: authenticate with bc:05:43:94:1a:da
[   16.299644] wlan0: send auth to bc:05:43:94:1a:da (try 1/3)
[   16.302060] wlan0: authenticated
[   16.302492] wlan0: waiting for beacon from bc:05:43:94:1a:da
[   16.432398] iwlwifi 0000:02:00.0: ACTIVATE a non DRIVER active station id 0 addr bc:05:43:94:1a:da
[   29.434897] wlan0: authenticate with bc:05:43:94:1a:da
[   29.445634] wlan0: send auth to bc:05:43:94:1a:da (try 1/3)
[   29.448168] wlan0: authenticated
[   29.448229] wlan0: waiting for beacon from bc:05:43:94:1a:da
[   29.473633] iwlwifi 0000:02:00.0: ACTIVATE a non DRIVER active station id 0 addr bc:05:43:94:1a:da
[   42.586339] wlan0: authenticate with bc:05:43:94:1a:da
[   42.596819] wlan0: send auth to bc:05:43:94:1a:da (try 1/3)
[   42.598960] wlan0: authenticated
[   42.599021] wlan0: waiting for beacon from bc:05:43:94:1a:da
[   42.635000] iwlwifi 0000:02:00.0: ACTIVATE a non DRIVER active station id 0 addr bc:05:43:94:1a:da
[   55.773770] wlan0: authenticate with bc:05:43:94:1a:da
[   55.784316] wlan0: send auth to bc:05:43:94:1a:da (try 1/3)
[   55.786758] wlan0: authenticated
[   55.787407] wlan0: associate with bc:05:43:94:1a:da (try 1/3)
[   55.791114] wlan0: RX AssocResp from bc:05:43:94:1a:da (capab=0x431 status=0 aid=4)
[   55.791121] wlan0: associated
[   55.801305] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   66.672641] wlan0: no IPv6 routers present
[   73.059911] netlink: 12 bytes leftover after parsing attributes.
[   73.059924] netlink: 12 bytes leftover after parsing attributes.
[   73.060020] netlink: 12 bytes leftover after parsing attributes.



Patches are welcome ;-)

Regards,
Oliver


--------------070108080107080607020304
Content-Type: text/plain;
 name="iwlwifi-3.3.cut"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="iwlwifi-3.3.cut"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.3.0-01180-ged378a5-dirty (hartko@vwagwolkf484) (gcc version 4.6.3 (Debian 4.6.3-1) ) #12 SMP Tue Mar 20 20:29:23 CET 2012
(..)
[    7.924146] cfg80211: Calling CRDA to update world regulatory domain
(..)
[    8.103207] cfg80211: World regulatory domain updated:
[    8.105716] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    8.107984] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.110813] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    8.110842] Bluetooth: Core ver 2.16
[    8.111541] NET: Registered protocol family 31
[    8.111544] Bluetooth: HCI device and connection manager initialized
[    8.111943] usb 2-1.8: new full-speed USB device number 5 using ehci_hcd
[    8.112143] Bluetooth: HCI socket layer initialized
[    8.112147] Bluetooth: L2CAP socket layer initialized
[    8.112149] Bluetooth: SCO socket layer initialized
[    8.128247] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    8.130529] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.132966] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.135647] usbcore: registered new interface driver btusb
[    8.139318] HDMI status: Codec=3 Pin=4 Presence_Detect=0 ELD_Valid=0
[    8.142145] HDMI status: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=0
[    8.145226] HDMI status: Codec=3 Pin=6 Presence_Detect=0 ELD_Valid=0
[    8.147521] input: HDA Intel HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    8.150128] input: HDA Intel HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    8.152548] input: HDA Intel HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    8.155170] input: HDA Intel Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    8.155619] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[    8.155621] Copyright(c) 2003-2011 Intel Corporation
[    8.155869] iwlwifi 0000:02:00.0: pci_resource_len = 0x00002000
[    8.155872] iwlwifi 0000:02:00.0: pci_resource_base = fca60000
[    8.155875] iwlwifi 0000:02:00.0: HW Revision ID = 0x35
[    8.156323] iwlwifi 0000:02:00.0: irq 44 for MSI/MSI-X
[    8.156515] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUG disabled
[    8.156517] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[    8.156520] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[    8.156522] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[    8.156524] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_P2P disabled
[    8.156553] iwlwifi 0000:02:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74
[    8.156826] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[    8.172595] iwlwifi 0000:02:00.0: device EEPROM VER=0x43a, CALIB=0x6
[    8.172597] iwlwifi 0000:02:00.0: Device SKU: 0x1F0
[    8.172629] iwlwifi 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[    8.190096] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    8.192657] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[    8.193646] iwlwifi 0000:02:00.0: loaded firmware version 9.221.4.1 build 25532
[    8.193907] Registered led device: phy0-led
[    8.197691] input: HDA Intel Dock Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[    8.203554] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
(..)
[   11.319886] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   11.330198] iwlwifi 0000:02:00.0: Radio type=0x1-0x3-0x1
[   11.468171] fuse init (API version 7.18)
[   11.573628] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   11.582809] iwlwifi 0000:02:00.0: Radio type=0x1-0x3-0x1
[   11.697919] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   11.998244] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[   12.053243] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[   12.053876] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   14.168257] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input17
[   14.609428] Bluetooth: RFCOMM TTY layer initialized
[   14.609439] Bluetooth: RFCOMM socket layer initialized
[   14.609441] Bluetooth: RFCOMM ver 1.11
[   14.612296] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   14.707784] vcan: Virtual CAN interface driver
[   14.952322] wlan0: authenticate with bc:05:43:94:1a:da (try 1)
[   14.954595] wlan0: authenticated
[   14.955125] wlan0: waiting for beacon from bc:05:43:94:1a:da
[   15.025641] wlan0: beacon received
[   15.051860] wlan0: associate with bc:05:43:94:1a:da (try 1)
[   15.055534] wlan0: RX AssocResp from bc:05:43:94:1a:da (capab=0x431 status=0 aid=4)
[   15.055537] wlan0: associated
[   15.055554] wlan0: moving STA bc:05:43:94:1a:da to state 1
[   15.055555] wlan0: moving STA bc:05:43:94:1a:da to state 2
[   15.055557] wlan0: moving STA bc:05:43:94:1a:da to state 3
[   15.066966] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   25.282260] wlan0: no IPv6 routers present
[   72.850897] netlink: 12 bytes leftover after parsing attributes.
[   72.850908] netlink: 12 bytes leftover after parsing attributes.
[   72.850988] netlink: 12 bytes leftover after parsing attributes.

--------------070108080107080607020304
Content-Type: text/plain;
 name="iwlwifi-3.3-merge.cut"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="iwlwifi-3.3-merge.cut"

[    0.000000] Linux version 3.3.0-merge-06154-g934e18b (hartko@vwagwolkf484) (gcc version 4.6.3 (Debian 4.6.3-1) ) #16 SMP Fri Mar 23 19:22:26 CET 2012
(..)
[    8.315220] cfg80211: Calling CRDA to update world regulatory domain
(..)
[    8.398762] cfg80211: World regulatory domain updated:
[    8.398764] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    8.398767] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.398769] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    8.398771] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    8.398772] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.398774] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
(..)
[    8.497252] Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[    8.501333] Copyright(c) 2003-2012 Intel Corporation
[    8.504974] iwlwifi 0000:02:00.0: pci_resource_len = 0x00002000
(..)
[    8.527810] iwlwifi 0000:02:00.0: pci_resource_base = fbe5c000
[    8.529982] iwlwifi 0000:02:00.0: HW Revision ID = 0x35
[    8.532399] iwlwifi 0000:02:00.0: irq 44 for MSI/MSI-X
(..)
[    8.552892] iwlwifi 0000:02:00.0: loaded firmware version 9.221.4.1 build 25532
[    8.553272] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUG disabled
[    8.553275] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[    8.553278] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[    8.553280] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[    8.553283] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_P2P disabled
[    8.553287] iwlwifi 0000:02:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74
[    8.553529] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[    8.569704] iwlwifi 0000:02:00.0: device EEPROM VER=0x43a, CALIB=0x6
[    8.569707] iwlwifi 0000:02:00.0: Device SKU: 0x1F0
[    8.569708] iwlwifi 0000:02:00.0: Valid Tx ant: 0x6, Valid Rx ant: 0x6
[    8.569725] iwlwifi 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[    8.569854] Registered led device: phy0-led
[    8.579345] HDMI status: Codec=3 Pin=6 Presence_Detect=0 ELD_Valid=0
[    8.581421] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
(..)
[   11.667627] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   11.678479] iwlwifi 0000:02:00.0: Radio type=0x1-0x3-0x1
[   11.919033] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   11.927719] iwlwifi 0000:02:00.0: Radio type=0x1-0x3-0x1
[   12.047628] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   12.355487] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[   12.410326] e1000e 0000:00:19.0: irq 42 for MSI/MSI-X
[   12.410821] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   14.271780] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input17
[   14.715648] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   14.715968] Bluetooth: RFCOMM TTY layer initialized
[   14.715973] Bluetooth: RFCOMM socket layer initialized
[   14.715975] Bluetooth: RFCOMM ver 1.11
[   14.802525] vcan: Virtual CAN interface driver
[   16.288562] wlan0: authenticate with bc:05:43:94:1a:da
[   16.299644] wlan0: send auth to bc:05:43:94:1a:da (try 1/3)
[   16.302060] wlan0: authenticated
[   16.302492] wlan0: waiting for beacon from bc:05:43:94:1a:da
[   16.432398] iwlwifi 0000:02:00.0: ACTIVATE a non DRIVER active station id 0 addr bc:05:43:94:1a:da
[   29.434897] wlan0: authenticate with bc:05:43:94:1a:da
[   29.445634] wlan0: send auth to bc:05:43:94:1a:da (try 1/3)
[   29.448168] wlan0: authenticated
[   29.448229] wlan0: waiting for beacon from bc:05:43:94:1a:da
[   29.473633] iwlwifi 0000:02:00.0: ACTIVATE a non DRIVER active station id 0 addr bc:05:43:94:1a:da
[   42.586339] wlan0: authenticate with bc:05:43:94:1a:da
[   42.596819] wlan0: send auth to bc:05:43:94:1a:da (try 1/3)
[   42.598960] wlan0: authenticated
[   42.599021] wlan0: waiting for beacon from bc:05:43:94:1a:da
[   42.635000] iwlwifi 0000:02:00.0: ACTIVATE a non DRIVER active station id 0 addr bc:05:43:94:1a:da
[   55.773770] wlan0: authenticate with bc:05:43:94:1a:da
[   55.784316] wlan0: send auth to bc:05:43:94:1a:da (try 1/3)
[   55.786758] wlan0: authenticated
[   55.787407] wlan0: associate with bc:05:43:94:1a:da (try 1/3)
[   55.791114] wlan0: RX AssocResp from bc:05:43:94:1a:da (capab=0x431 status=0 aid=4)
[   55.791121] wlan0: associated
[   55.801305] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   66.672641] wlan0: no IPv6 routers present
[   73.059911] netlink: 12 bytes leftover after parsing attributes.
[   73.059924] netlink: 12 bytes leftover after parsing attributes.
[   73.060020] netlink: 12 bytes leftover after parsing attributes.

--------------070108080107080607020304--
