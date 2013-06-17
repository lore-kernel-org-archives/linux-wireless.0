Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51147 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab3FQOPF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 10:15:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1UoaD1-0002eA-Fd
	for linux-wireless@vger.kernel.org; Mon, 17 Jun 2013 16:15:03 +0200
Received: from ip-109-84-0-66.web.vodafone.de ([109.84.0.66])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 16:15:03 +0200
Received: from zielscheibe by ip-109-84-0-66.web.vodafone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 16:15:03 +0200
To: linux-wireless@vger.kernel.org
From: Tobias Kluge <zielscheibe@gmail.com>
Subject: rtl8192cu fail to connect with a AP
Date: Mon, 17 Jun 2013 14:06:01 +0000 (UTC)
Message-ID: <loom.20130617T154136-827@post.gmane.org> (sfid-20130617_161510_232068_9A0664B3)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've recently bought a TP-Link TL-WN8200ND USB WiFi dongle, it uses the
Realtek 8192cu chipset.
After several attempts with different kernels (starting with 3.2.6) and
compat-wireless drivers, I'm still running into the same problem. The device
can successful scan for networks in reach, but cannot connect to any of
them, regardless the encryption (tried every mode, including no encryption
at all). 

At the moment I'm using the kernel release 3.10.0-rc6 and the device is
still not recognized by the "rtl8192cu" driver module without manually
setting the device ID into the SySFS

"echo "2357 0100" > /sys/bus/usb/drivers/rtl8192cu/new_id"

here is the output of "lsusb"

Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 004: ID 2357:0100  
Bus 002 Device 003: ID 0c0b:b159 Dura Micro, Inc. (Acomdata) 
Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 005: ID 0d62:001c Darfon Electronics Corp. Benq X120 Internet
Keyboard Pro
Bus 001 Device 004: ID 09da:9090 A4 Tech Co., Ltd XL-750BK Laser Mouse
Bus 001 Device 003: ID 148f:3072 Ralink Technology, Corp. RT3072 Wireless
Adapter
Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

dmesg output when the dongle becomes active (debug level 3 for the rtl8192cu
module):
[ 1651.800376] usb 2-1.6: USB disconnect, device number 5
[ 1651.800471] ehci-pci 0000:00:1d.0: dma_pool_free ehci_qh,
dfa0d4e0/fffff4e0 (bad dma)
[ 1653.791055] usb 2-1.6: new high-speed USB device number 6 using ehci-pci
[ 1653.866948] ehci-pci 0000:00:1d.0: dma_pool_free ehci_qh,
dfa0d540/fffff540 (bad dma)
[ 1690.240437] usbcore: registered new interface driver rtl8192cu
[ 1710.493651] rtl8192cu: Chip version 0x11
[ 1710.570428] rtl8192cu: MAC address: a0:f3:c1:29:e3:95
[ 1710.570436] rtl8192cu: Board Type 0
[ 1710.570672] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
[ 1710.570677] cfg80211: Updating information on frequency 2412 MHz with
regulatory rule:
[ 1710.570679] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi,
2000 mBm)
[ 1710.570681] cfg80211: Updating information on frequency 2417 MHz with
regulatory rule:
[ 1710.570684] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi,
2000 mBm)
[ 1710.570685] cfg80211: Updating information on frequency 2422 MHz with
regulatory rule:
[ 1710.570687] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi,
2000 mBm)
[ 1710.570689] cfg80211: Updating information on frequency 2427 MHz with
regulatory rule:
[ 1710.570691] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi,
2000 mBm)
[ 1710.570693] cfg80211: Updating information on frequency 2432 MHz with
regulatory rule:
[ 1710.570695] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi,
2000 mBm)
[ 1710.570697] cfg80211: Updating information on frequency 2437 MHz with
regulatory rule:
[ 1710.570699] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi,
2000 mBm)
[ 1710.570700] cfg80211: Updating information on frequency 2442 MHz with
regulatory rule:
[ 1710.570702] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi,
2000 mBm)
[ 1710.570704] cfg80211: Updating information on frequency 2447 MHz with
regulatory rule:
[ 1710.570706] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi,
2000 mBm)
[ 1710.570708] cfg80211: Updating information on frequency 2452 MHz with
regulatory rule:
[ 1710.570710] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi,
2000 mBm)
[ 1710.570712] cfg80211: Updating information on frequency 2457 MHz with
regulatory rule:
[ 1710.570714] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi,
2000 mBm)
[ 1710.570715] cfg80211: Updating information on frequency 2462 MHz with
regulatory rule:
[ 1710.570717] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi,
2000 mBm)
[ 1710.570719] cfg80211: Disabling freq 2467 MHz as custom regd has no rule
that fits it
[ 1710.570721] cfg80211: Disabling freq 2472 MHz as custom regd has no rule
that fits it
[ 1710.570722] cfg80211: Disabling freq 2484 MHz as custom regd has no rule
that fits it
[ 1710.570752] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw.bin
[ 1710.570866] cfg80211: Ignoring regulatory request Set by core since the
driver uses its own custom regulatory domain
[ 1710.570975] ieee80211 phy3: Selected rate control algorithm 'rtl_rc'
[ 1710.571427] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1710.571430] rtlwifi: wireless switch is on
[ 1710.571675] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09


dmesg output when connecting to my unsecured AP

[ 1710.571430] rtlwifi: wireless switch is on
[ 1710.571675] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1715.459587] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1720.455801] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1725.468154] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1730.464371] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1735.476568] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1740.472816] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1745.485169] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1750.481384] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1755.493613] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1760.489829] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1765.502183] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1770.498399] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1775.510626] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1780.506967] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1785.519180] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1790.515411] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1795.527640] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1800.523981] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1805.536210] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1810.532425] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1815.544779] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1820.540994] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1825.553224] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1830.549439] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=09
[ 1833.830697] rtl8192cu:_rtl92cu_init_power_on():<0-0> Autoload Done!
[ 1833.832420] rtl8192cu: MAC auto ON okay!
[ 1833.865110] rtl8192cu: Tx queue select: 0x05
[ 1833.865120] rtl8192cu:rtl92c_set_network_type():<0-0> Set Network type to
NO LINK!
[ 1833.865832] rtl8192c_common:rtl92c_phy_set_bw_mode():<0-0> FALSE driver
sleep or unload
[ 1833.865853] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware
Version(63), Signature(0x88c1),Size(32)
[ 1834.218899] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###
[ 1834.218927] rtl8192cu:rtl92cu_set_hw_reg():<0-0> Set
HW_VAR_RETRY_LIMIT(0x00000004)
[ 1834.230312] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
[ 1834.336021] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###
[ 1834.345018] rtl8192cu:_rtl92cu_init_power_on():<0-0> Autoload Done!
[ 1834.346728] rtl8192cu: MAC auto ON okay!
[ 1834.379398] rtl8192cu: Tx queue select: 0x05
[ 1834.379407] rtl8192cu:rtl92c_set_network_type():<0-0> Set Network type to
NO LINK!
[ 1834.380137] rtl8192c_common:rtl92c_phy_set_bw_mode():<0-0> FALSE driver
sleep or unload
[ 1834.380157] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware
Version(63), Signature(0x88c1),Size(32)
[ 1834.737048] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###
[ 1834.737083] rtl8192cu:rtl92cu_set_hw_reg():<0-0> Set
HW_VAR_RETRY_LIMIT(0x00000004)
[ 1834.748491] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
[ 1835.561793] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=08
[ 1840.558008] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=08
[ 1845.570238] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=08
[ 1849.503068] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###
[ 1849.512063] rtl8192cu:_rtl92cu_init_power_on():<0-0> Autoload Done!
[ 1849.513775] rtl8192cu: MAC auto ON okay!
[ 1849.546445] rtl8192cu: Tx queue select: 0x05
[ 1849.546456] rtl8192cu:rtl92c_set_network_type():<0-0> Set Network type to
NO LINK!
[ 1849.547184] rtl8192c_common:rtl92c_phy_set_bw_mode():<0-0> FALSE driver
sleep or unload
[ 1849.547205] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware
Version(63), Signature(0x88c1),Size(32)
[ 1849.900128] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###
[ 1849.900153] rtl8192cu:rtl92cu_set_hw_reg():<0-0> Set
HW_VAR_RETRY_LIMIT(0x00000004)
[ 1849.911536] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
[ 1850.006348] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###
[ 1850.152581] rtl8192cu:_rtl92cu_init_power_on():<0-0> Autoload Done!
[ 1850.154316] rtl8192cu: MAC auto ON okay!
[ 1850.186984] rtl8192cu: Tx queue select: 0x05
[ 1850.186994] rtl8192cu:rtl92c_set_network_type():<0-0> Set Network type to
NO LINK!
[ 1850.187727] rtl8192c_common:rtl92c_phy_set_bw_mode():<0-0> FALSE driver
sleep or unload
[ 1850.187747] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware
Version(63), Signature(0x88c1),Size(32)
[ 1850.540796] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###
[ 1850.540822] rtl8192cu:rtl92cu_set_hw_reg():<0-0> Set
HW_VAR_RETRY_LIMIT(0x00000004)
[ 1850.552204] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
[ 1850.566578] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=08
[ 1852.568943] wlan1: authenticate with 92:5f:2e:57:10:3b
[ 1852.568949] wlan1: Allocated STA 92:5f:2e:57:10:3b
[ 1852.580265] rtlwifi:rtl_op_bss_info_changed():<0-0> 92:5f:2e:57:10:3b
[ 1852.580747] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###
[ 1852.580795] wlan1: Inserted STA 92:5f:2e:57:10:3b
[ 1852.580798] wlan1: direct probe to 92:5f:2e:57:10:3b (try 1/3)
[ 1852.583216] wlan1: deauthenticating from 92:5f:2e:57:10:3b by local
choice (reason=3)
[ 1852.583306] wlan1: Removed STA 92:5f:2e:57:10:3b
[ 1852.583377] rtlwifi:rtl_op_bss_info_changed():<0-0> 00:00:00:00:00:00
[ 1852.583875] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###
[ 1852.595156] wlan1: authenticate with 92:5f:2e:57:10:3b
[ 1852.595161] wlan1: Allocated STA 92:5f:2e:57:10:3b
[ 1852.606280] rtlwifi:rtl_op_bss_info_changed():<0-0> 92:5f:2e:57:10:3b
[ 1852.606769] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###
[ 1852.606810] wlan1: Inserted STA 92:5f:2e:57:10:3b
[ 1852.606813] wlan1: direct probe to 92:5f:2e:57:10:3b (try 1/3)
[ 1852.608051] wlan1: Destroyed STA 92:5f:2e:57:10:3b
[ 1852.609213] wlan1: deauthenticating from 92:5f:2e:57:10:3b by local
choice (reason=3)
[ 1852.609276] wlan1: Removed STA 92:5f:2e:57:10:3b
[ 1852.609325] rtlwifi:rtl_op_bss_info_changed():<0-0> 00:00:00:00:00:00
[ 1852.609896] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###
[ 1852.621171] wlan1: authenticate with 92:5f:2e:57:10:3b
[ 1852.621174] wlan1: Allocated STA 92:5f:2e:57:10:3b
[ 1852.632302] rtlwifi:rtl_op_bss_info_changed():<0-0> 92:5f:2e:57:10:3b
[ 1852.632790] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###
[ 1852.632824] wlan1: Inserted STA 92:5f:2e:57:10:3b
[ 1852.632827] wlan1: direct probe to 92:5f:2e:57:10:3b (try 1/3)
[ 1852.632875] wlan1: Destroyed STA 92:5f:2e:57:10:3b
[ 1852.836210] wlan1: direct probe to 92:5f:2e:57:10:3b (try 2/3)
[ 1853.040402] wlan1: direct probe to 92:5f:2e:57:10:3b (try 3/3)
[ 1853.244553] wlan1: authentication with 92:5f:2e:57:10:3b timed out
[ 1853.272625] wlan1: Removed STA 92:5f:2e:57:10:3b
[ 1853.272691] rtlwifi:rtl_op_bss_info_changed():<0-0> 00:00:00:00:00:00
[ 1853.273249] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###
[ 1853.304623] wlan1: Destroyed STA 92:5f:2e:57:10:3b
[ 1855.578807] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=08
[ 1860.575022] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=08

My other USB WLAN dongle iwth a Ralink chipset works flawless with my PC and
AP, so it seems not to be a PEBKAC problem on my side :)

Please hit me if you need more information, Thanks in advance

Tobias


