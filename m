Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pegasos-out.vodafone.de ([80.84.1.38]:57158 "EHLO
	pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaENSym (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 14:54:42 -0400
Date: Wed, 14 May 2014 20:54:34 +0200 (CEST)
From: Stefan =?utf-8?Q?Kr=C3=BCger?= <01727988324@vodafone.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <951999372.36146252.1400093674198.JavaMail.root@vodafone.de> (sfid-20140514_205446_392352_A806C66A)
In-Reply-To: <536FA82C.1040203@lwfinger.net>
Subject: Re: Kernel binary for RTL8192EE
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, 

i have try kernel 3.14 with you patches and i try you deb-file. 
With both kernel i have the same issue.. 

i find the Router (in this case it is a Fritz-Box router, but its the same with other routers - i tried this), but i cant connect to this.. and i dont know why.. 


here some logs, if you need more please tell me which one.. 


uname -a 
Linux wheezy 3.13.9 #3 SMP Sat May 10 10:51:00 CDT 2014 x86_64 GNU/Linux 


lsmod |grep 8192 
r8192ee 495016 0 
mac80211 626194 1 r8192ee 
cfg80211 483865 2 mac80211,r8192ee 


/etc/init.d/network-manager stop 
[ ok ] Stopping network connection manager: NetworkManager. 
root@wheezy:/home/stefan# NetworkManager --log-level=DEBUG 


dmesg |egrep 'wlan0|8192' 
[ 0.000000] PERCPU: Embedded 29 pages/cpu @ffff88021f200000 s86336 r8192 d24256 u262144 
[ 0.000000] pcpu-alloc: s86336 r8192 d24256 u262144 alloc=1*2097152 
[ 4.534056] r8192ee: module is from the staging directory, the quality is unknown, you have been warned. 
[ 4.535081] r8192ee-0:stg_rtl_pci_probe():<0-0> mem mapped space: start: 0xf2400000 len:00004000 flags:00140204, after map:0xffffc90004eb8000 
[ 4.535099] r8192ee-0:_rtl_pci_find_adapter():<0-0> Pci Bridge Vendor is found index: 0 
[ 4.535102] r8192ee-0:_rtl_pci_find_adapter():<0-0> pcidev busnumber:devnumber:funcnumber:vendor:link_ctl 2:0:0:10ec:0 
[ 4.535103] r8192ee-0:_rtl_pci_find_adapter():<0-0> pci_bridge busnumber:devnumber:funcnumber:vendor:pcie_cap:link_ctl_reg:amd 0:28:1:8086:40:43:0 
[ 4.535139] r8192ee-0:rtl92ee_read_eeprom_info():<0-0> Boot from EFUSE 
[ 4.543354] r8192ee-0:_rtl92ee_read_adapter_info():<0-0> dev_addr: 54:35:30:0e:6c:8b 
[ 4.543359] r8192ee-0:_rtl92ee_hal_customized_behavior():<0-0> RT Customized ID: 0x12 
[ 5.028045] r8192ee 0000:02:00.0: irq 46 for MSI/MSI-X 
[ 12.495196] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready 
[ 15.309062] wlan0: authenticate with bc:05:43:79:f9:47 
[ 15.325612] wlan0: direct probe to bc:05:43:79:f9:47 (try 1/3) 
[ 15.528819] wlan0: direct probe to bc:05:43:79:f9:47 (try 2/3) 
[ 15.733017] wlan0: direct probe to bc:05:43:79:f9:47 (try 3/3) 
[ 15.937246] wlan0: authentication with bc:05:43:79:f9:47 timed out 
[ 30.818085] wlan0: authenticate with bc:05:43:79:f9:47 
[ 30.834522] wlan0: direct probe to bc:05:43:79:f9:47 (try 1/3) 
[ 31.037817] wlan0: direct probe to bc:05:43:79:f9:47 (try 2/3) 
[ 31.242066] wlan0: direct probe to bc:05:43:79:f9:47 (try 3/3) 
[ 31.446289] wlan0: authentication with bc:05:43:79:f9:47 timed out 
[ 39.723989] wlan0: authenticate with bc:05:43:79:f9:47 
[ 39.740451] wlan0: direct probe to bc:05:43:79:f9:47 (try 1/3) 
[ 39.943682] wlan0: direct probe to bc:05:43:79:f9:47 (try 2/3) 
[ 40.147848] wlan0: direct probe to bc:05:43:79:f9:47 (try 3/3) 
[ 40.352083] wlan0: authentication with bc:05:43:79:f9:47 timed out 

[ 455.536392] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready 
[ 457.435757] wlan0: authenticate with bc:05:43:79:f9:47 
[ 457.451936] wlan0: direct probe to bc:05:43:79:f9:47 (try 1/3) 
[ 457.655213] wlan0: direct probe to bc:05:43:79:f9:47 (try 2/3) 
[ 457.859404] wlan0: direct probe to bc:05:43:79:f9:47 (try 3/3) 
[ 458.063663] wlan0: authentication with bc:05:43:79:f9:47 timed out 
[ 459.749891] wlan0: authenticate with bc:05:43:79:f9:47 
[ 459.766582] wlan0: direct probe to bc:05:43:79:f9:47 (try 1/3) 
[ 459.969757] wlan0: direct probe to bc:05:43:79:f9:47 (try 2/3) 
[ 460.173983] wlan0: direct probe to bc:05:43:79:f9:47 (try 3/3) 
[ 460.378161] wlan0: authentication with bc:05:43:79:f9:47 timed out 
[ 475.255128] wlan0: authenticate with bc:05:43:79:f9:47 
[ 475.271622] wlan0: direct probe to bc:05:43:79:f9:47 (try 1/3) 
[ 475.474812] wlan0: direct probe to bc:05:43:79:f9:47 (try 2/3) 
[ 475.678994] wlan0: direct probe to bc:05:43:79:f9:47 (try 3/3) 
[ 475.883266] wlan0: authentication with bc:05:43:79:f9:47 timed out 


egrep 'wlan0|8192' /var/log/syslog 
May 14 20:24:22 wheezy kernel: [ 0.000000] PERCPU: Embedded 29 pages/cpu @ffff88021f200000 s86336 r8192 d24256 u262144 
May 14 20:24:22 wheezy kernel: [ 0.000000] pcpu-alloc: s86336 r8192 d24256 u262144 alloc=1*2097152 
May 14 20:24:22 wheezy kernel: [ 4.534056] r8192ee: module is from the staging directory, the quality is unknown, you have been warned. 
May 14 20:24:22 wheezy kernel: [ 4.535081] r8192ee-0:stg_rtl_pci_probe():<0-0> mem mapped space: start: 0xf2400000 len:00004000 flags:00140204, after map:0xffffc90004eb8000 
May 14 20:24:22 wheezy kernel: [ 4.535099] r8192ee-0:_rtl_pci_find_adapter():<0-0> Pci Bridge Vendor is found index: 0 
May 14 20:24:22 wheezy kernel: [ 4.535102] r8192ee-0:_rtl_pci_find_adapter():<0-0> pcidev busnumber:devnumber:funcnumber:vendor:link_ctl 2:0:0:10ec:0 
May 14 20:24:22 wheezy kernel: [ 4.535103] r8192ee-0:_rtl_pci_find_adapter():<0-0> pci_bridge busnumber:devnumber:funcnumber:vendor:pcie_cap:link_ctl_reg:amd 0:28:1:8086:40:43:0 
May 14 20:24:22 wheezy kernel: [ 4.535139] r8192ee-0:rtl92ee_read_eeprom_info():<0-0> Boot from EFUSE 
May 14 20:24:22 wheezy kernel: [ 4.543354] r8192ee-0:_rtl92ee_read_adapter_info():<0-0> dev_addr: 54:35:30:0e:6c:8b 
May 14 20:24:22 wheezy kernel: [ 4.543359] r8192ee-0:_rtl92ee_hal_customized_behavior():<0-0> RT Customized ID: 0x12 
May 14 20:24:22 wheezy kernel: [ 5.028045] r8192ee 0000:02:00.0: irq 46 for MSI/MSI-X 
May 14 20:24:24 wheezy NetworkManager[3060]: SCPlugin-Ifupdown: devices added (path: /sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/net/wlan0, iface: wlan0) 
May 14 20:24:24 wheezy NetworkManager[3060]: SCPlugin-Ifupdown: device added (path: /sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/net/wlan0, iface: wlan0): no ifupdown configuration found. 
May 14 20:24:25 wheezy NetworkManager[3060]: <info> (wlan0): using nl80211 for WiFi device control 
May 14 20:24:25 wheezy NetworkManager[3060]: <warn> (wlan0): driver supports Access Point (AP) mode 
May 14 20:24:25 wheezy NetworkManager[3060]: <info> (wlan0): new 802.11 WiFi device (driver: 'r8192ee' ifindex: 3) 
May 14 20:24:25 wheezy NetworkManager[3060]: <info> (wlan0): exported as /org/freedesktop/NetworkManager/Devices/1 
May 14 20:24:25 wheezy NetworkManager[3060]: <info> (wlan0): now managed 
May 14 20:24:25 wheezy NetworkManager[3060]: <info> (wlan0): device state change: unmanaged -> unavailable (reason 'managed') [10 20 2] 
May 14 20:24:25 wheezy NetworkManager[3060]: <info> (wlan0): bringing up device. 
May 14 20:24:25 wheezy NetworkManager[3060]: <info> (wlan0): preparing device. 
May 14 20:24:25 wheezy NetworkManager[3060]: <info> (wlan0): deactivating device (reason 'managed') [2] 
May 14 20:24:25 wheezy kernel: [ 12.495196] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready 
May 14 20:24:26 wheezy NetworkManager[3060]: <info> (wlan0): supplicant interface state: starting -> ready 
May 14 20:24:26 wheezy NetworkManager[3060]: <info> (wlan0): device state change: unavailable -> disconnected (reason 'supplicant-available') [20 30 42] 
May 14 20:24:26 wheezy NetworkManager[3060]: <info> (wlan0): supplicant interface state: ready -> inactive 
May 14 20:24:27 wheezy NetworkManager[3060]: <info> Activation (wlan0) starting connection 'zuHause' 
May 14 20:24:27 wheezy NetworkManager[3060]: <info> (wlan0): device state change: disconnected -> prepare (reason 'none') [30 40 0] 
May 14 20:24:27 wheezy NetworkManager[3060]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) scheduled... 
May 14 20:24:27 wheezy NetworkManager[3060]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) started... 
May 14 20:24:27 wheezy NetworkManager[3060]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) scheduled... 
May 14 20:24:27 wheezy NetworkManager[3060]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) complete. 
May 14 20:24:27 wheezy NetworkManager[3060]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) starting... 
May 14 20:24:27 wheezy NetworkManager[3060]: <info> (wlan0): device state change: prepare -> config (reason 'none') [40 50 0] 
May 14 20:24:27 wheezy NetworkManager[3060]: <info> Activation (wlan0/wireless): connection 'zuHause' has security, and secrets exist. No new secrets needed. 
May 14 20:24:27 wheezy NetworkManager[3060]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) complete. 
May 14 20:24:27 wheezy NetworkManager[3060]: <info> (wlan0): supplicant interface state: inactive -> scanning 
May 14 20:24:28 wheezy kernel: [ 15.309062] wlan0: authenticate with bc:05:43:79:f9:47 
May 14 20:24:28 wheezy wpa_supplicant[3283]: wlan0: SME: Trying to authenticate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz) 
May 14 20:24:28 wheezy NetworkManager[3060]: <info> (wlan0): supplicant interface state: scanning -> authenticating 
May 14 20:24:28 wheezy kernel: [ 15.325612] wlan0: direct probe to bc:05:43:79:f9:47 (try 1/3) 
May 14 20:24:28 wheezy kernel: [ 15.528819] wlan0: direct probe to bc:05:43:79:f9:47 (try 2/3) 
May 14 20:24:29 wheezy kernel: [ 15.733017] wlan0: direct probe to bc:05:43:79:f9:47 (try 3/3) 
May 14 20:24:29 wheezy kernel: [ 15.937246] wlan0: authentication with bc:05:43:79:f9:47 timed out 
May 14 20:24:29 wheezy NetworkManager[3060]: <info> (wlan0): supplicant interface state: authenticating -> disconnected 
May 14 20:24:29 wheezy NetworkManager[3060]: <info> (wlan0): supplicant interface state: disconnected -> scanning 
May 14 20:24:44 wheezy kernel: [ 30.818085] wlan0: authenticate with bc:05:43:79:f9:47 
May 14 20:24:44 wheezy wpa_supplicant[3283]: wlan0: SME: Trying to authenticate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz) 
May 14 20:24:44 wheezy NetworkManager[3060]: <info> (wlan0): supplicant interface state: scanning -> authenticating 
May 14 20:24:44 wheezy kernel: [ 30.834522] wlan0: direct probe to bc:05:43:79:f9:47 (try 1/3) 
May 14 20:24:44 wheezy kernel: [ 31.037817] wlan0: direct probe to bc:05:43:79:f9:47 (try 2/3) 
May 14 20:24:44 wheezy kernel: [ 31.242066] wlan0: direct probe to bc:05:43:79:f9:47 (try 3/3) 
May 14 20:24:44 wheezy kernel: [ 31.446289] wlan0: authentication with bc:05:43:79:f9:47 timed out 
May 14 20:24:44 wheezy NetworkManager[3060]: <info> (wlan0): supplicant interface state: authenticating -> disconnected 
May 14 20:24:44 wheezy NetworkManager[3060]: <info> (wlan0): supplicant interface state: disconnected -> scanning 
May 14 20:24:53 wheezy wpa_supplicant[3283]: wlan0: SME: Trying to authenticate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz) 
May 14 20:24:53 wheezy kernel: [ 39.723989] wlan0: authenticate with bc:05:43:79:f9:47 
May 14 20:24:53 wheezy NetworkManager[3060]: <info> (wlan0): supplicant interface state: scanning -> authenticating 
May 14 20:24:53 wheezy kernel: [ 39.740451] wlan0: direct probe to bc:05:43:79:f9:47 (try 1/3) 
May 14 20:24:53 wheezy kernel: [ 39.943682] wlan0: direct probe to bc:05:43:79:f9:47 (try 2/3) 
May 14 20:24:53 wheezy NetworkManager[3060]: <warn> Activation (wlan0/wireless): association took too long. 
May 14 20:24:53 wheezy NetworkManager[3060]: <info> (wlan0): device state change: config -> need-auth (reason 'none') [50 60 0] 
May 14 20:24:53 wheezy NetworkManager[3060]: <warn> Activation (wlan0/wireless): asking for new secrets 
May 14 20:24:53 wheezy NetworkManager[3060]: <info> (wlan0): supplicant interface state: authenticating -> disconnected 
May 14 20:24:53 wheezy kernel: [ 40.147848] wlan0: direct probe to bc:05:43:79:f9:47 (try 3/3) 
May 14 20:24:53 wheezy kernel: [ 40.352083] wlan0: authentication with bc:05:43:79:f9:47 timed out 
May 14 20:26:53 wheezy NetworkManager[3060]: <info> (wlan0): device state change: need-auth -> failed (reason 'no-secrets') [60 120 7] 
May 14 20:26:53 wheezy NetworkManager[3060]: <warn> Activation (wlan0) failed for access point (FRITZ!Box Fon WLAN 7112) 
May 14 20:26:53 wheezy NetworkManager[3060]: <warn> Activation (wlan0) failed. 
May 14 20:26:53 wheezy NetworkManager[3060]: <info> (wlan0): device state change: failed -> disconnected (reason 'none') [120 30 0] 
May 14 20:26:53 wheezy NetworkManager[3060]: <info> (wlan0): deactivating device (reason 'none') [0] 
May 14 20:31:32 wheezy NetworkManager[3060]: <info> (wlan0): now unmanaged 
May 14 20:31:32 wheezy NetworkManager[3060]: <info> (wlan0): device state change: disconnected -> unmanaged (reason 'removed') [30 10 36] 
May 14 20:31:32 wheezy NetworkManager[3060]: <info> (wlan0): cleaning up... 
May 14 20:31:32 wheezy NetworkManager[3060]: <info> (wlan0): taking down device. 
May 14 20:31:47 wheezy NetworkManager[4773]: SCPlugin-Ifupdown: devices added (path: /sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/net/wlan0, iface: wlan0) 
May 14 20:31:47 wheezy NetworkManager[4773]: SCPlugin-Ifupdown: device added (path: /sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/net/wlan0, iface: wlan0): no ifupdown configuration found. 
May 14 20:31:47 wheezy NetworkManager[4773]: <debug> [1400092307.779457] [nm-device-wifi.c:297] constructor(): (wlan0): kernel ifindex 3 
May 14 20:31:47 wheezy NetworkManager[4773]: <info> (wlan0): using nl80211 for WiFi device control 
May 14 20:31:47 wheezy NetworkManager[4773]: <warn> (wlan0): driver supports Access Point (AP) mode 
May 14 20:31:47 wheezy NetworkManager[4773]: <debug> [1400092307.779673] [nm-device-wifi.c:2626] real_update_initial_hw_address(): (wlan0): read initial MAC address 54:35:30:0E:6C:8B 
May 14 20:31:47 wheezy NetworkManager[4773]: <debug> [1400092307.779748] [nm-device-wifi.c:3213] real_set_enabled(): (wlan0): device now enabled 
May 14 20:31:47 wheezy NetworkManager[4773]: <debug> [1400092307.779756] [nm-device-wifi.c:3219] real_set_enabled(): (enable): wlan0 blocked by UNMANAGED state 
May 14 20:31:47 wheezy NetworkManager[4773]: <info> (wlan0): new 802.11 WiFi device (driver: 'r8192ee' ifindex: 3) 
May 14 20:31:47 wheezy NetworkManager[4773]: <info> (wlan0): exported as /org/freedesktop/NetworkManager/Devices/2 
May 14 20:31:47 wheezy NetworkManager[4773]: <info> (wlan0): now managed 
May 14 20:31:47 wheezy NetworkManager[4773]: <info> (wlan0): device state change: unmanaged -> unavailable (reason 'managed') [10 20 2] 
May 14 20:31:47 wheezy NetworkManager[4773]: <info> (wlan0): bringing up device. 
May 14 20:31:48 wheezy NetworkManager[4773]: <info> (wlan0): preparing device. 
May 14 20:31:48 wheezy NetworkManager[4773]: <info> (wlan0): deactivating device (reason 'managed') [2] 
May 14 20:31:48 wheezy NetworkManager[4773]: <debug> [1400092308.443178] [nm-device-wifi.c:868] _set_hw_addr(): (wlan0): no MAC address change needed 
May 14 20:31:48 wheezy NetworkManager[4773]: <debug> [1400092308.443239] [nm-system.c:1205] nm_system_iface_flush_routes(): (wlan0): flushing routes ifindex 3 family INET (2) 
May 14 20:31:48 wheezy kernel: [ 455.536392] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready 
May 14 20:31:48 wheezy NetworkManager[4773]: <debug> [1400092308.443368] [nm-system.c:196] sync_addresses(): (wlan0): syncing addresses (family 2) 
May 14 20:31:48 wheezy NetworkManager[4773]: <debug> [1400092308.443481] [nm-supplicant-manager.c:88] nm_supplicant_manager_iface_get(): (wlan0): creating new supplicant interface 
May 14 20:31:48 wheezy NetworkManager[4773]: <debug> [1400092308.443613] [nm-supplicant-interface.c:829] interface_add(): (wlan0): adding interface to supplicant 
May 14 20:31:48 wheezy NetworkManager[4773]: <debug> [1400092308.443740] [nm-device-wifi.c:1308] real_is_available(): (wlan0): not available because supplicant interface not ready 
May 14 20:31:48 wheezy NetworkManager[4773]: <debug> [1400092308.443750] [nm-device.c:4334] nm_device_state_changed(): (wlan0): device not yet available for transition to DISCONNECTED 
May 14 20:31:48 wheezy NetworkManager[4773]: <debug> [1400092308.446310] [nm-supplicant-interface.c:658] interface_add_done(): (wlan0): interface added to supplicant 
May 14 20:31:48 wheezy NetworkManager[4773]: <info> (wlan0): supplicant interface state: starting -> ready 
May 14 20:31:48 wheezy NetworkManager[4773]: <info> (wlan0): device state change: unavailable -> disconnected (reason 'supplicant-available') [20 30 42] 
May 14 20:31:48 wheezy NetworkManager[4773]: <info> (wlan0): supplicant interface state: ready -> inactive 
May 14 20:31:49 wheezy NetworkManager[4773]: <info> Activation (wlan0) starting connection 'zuHause' 
May 14 20:31:49 wheezy NetworkManager[4773]: <info> (wlan0): device state change: disconnected -> prepare (reason 'none') [30 40 0] 
May 14 20:31:49 wheezy NetworkManager[4773]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) scheduled... 
May 14 20:31:49 wheezy NetworkManager[4773]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) started... 
May 14 20:31:49 wheezy NetworkManager[4773]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) scheduled... 
May 14 20:31:49 wheezy NetworkManager[4773]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) complete. 
May 14 20:31:49 wheezy NetworkManager[4773]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) starting... 
May 14 20:31:49 wheezy NetworkManager[4773]: <info> (wlan0): device state change: prepare -> config (reason 'none') [40 50 0] 
May 14 20:31:49 wheezy NetworkManager[4773]: <info> Activation (wlan0/wireless): connection 'zuHause' has security, and secrets exist. No new secrets needed. 
May 14 20:31:49 wheezy NetworkManager[4773]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) complete. 
May 14 20:31:49 wheezy NetworkManager[4773]: <info> (wlan0): supplicant interface state: inactive -> scanning 
May 14 20:31:50 wheezy wpa_supplicant[3283]: wlan0: SME: Trying to authenticate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz) 
May 14 20:31:50 wheezy kernel: [ 457.435757] wlan0: authenticate with bc:05:43:79:f9:47 
May 14 20:31:50 wheezy NetworkManager[4773]: <info> (wlan0): supplicant interface state: scanning -> authenticating 
May 14 20:31:50 wheezy kernel: [ 457.451936] wlan0: direct probe to bc:05:43:79:f9:47 (try 1/3) 
May 14 20:31:50 wheezy kernel: [ 457.655213] wlan0: direct probe to bc:05:43:79:f9:47 (try 2/3) 
May 14 20:31:50 wheezy kernel: [ 457.859404] wlan0: direct probe to bc:05:43:79:f9:47 (try 3/3) 
May 14 20:31:50 wheezy kernel: [ 458.063663] wlan0: authentication with bc:05:43:79:f9:47 timed out 
May 14 20:31:50 wheezy NetworkManager[4773]: <info> (wlan0): supplicant interface state: authenticating -> disconnected 
May 14 20:31:51 wheezy NetworkManager[4773]: <info> (wlan0): supplicant interface state: disconnected -> scanning 
May 14 20:31:52 wheezy wpa_supplicant[3283]: wlan0: SME: Trying to authenticate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz) 
May 14 20:31:52 wheezy kernel: [ 459.749891] wlan0: authenticate with bc:05:43:79:f9:47 
May 14 20:31:52 wheezy NetworkManager[4773]: <info> (wlan0): supplicant interface state: scanning -> authenticating 
May 14 20:31:52 wheezy kernel: [ 459.766582] wlan0: direct probe to bc:05:43:79:f9:47 (try 1/3) 
May 14 20:31:52 wheezy kernel: [ 459.969757] wlan0: direct probe to bc:05:43:79:f9:47 (try 2/3) 
May 14 20:31:53 wheezy kernel: [ 460.173983] wlan0: direct probe to bc:05:43:79:f9:47 (try 3/3) 
May 14 20:31:53 wheezy kernel: [ 460.378161] wlan0: authentication with bc:05:43:79:f9:47 timed out 
May 14 20:31:53 wheezy NetworkManager[4773]: <info> (wlan0): supplicant interface state: authenticating -> disconnected 
May 14 20:31:53 wheezy NetworkManager[4773]: <info> (wlan0): supplicant interface state: disconnected -> scanning 
May 14 20:32:08 wheezy wpa_supplicant[3283]: wlan0: SME: Trying to authenticate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz) 
May 14 20:32:08 wheezy kernel: [ 475.255128] wlan0: authenticate with bc:05:43:79:f9:47 
May 14 20:32:08 wheezy NetworkManager[4773]: <info> (wlan0): supplicant interface state: scanning -> authenticating 
May 14 20:32:08 wheezy kernel: [ 475.271622] wlan0: direct probe to bc:05:43:79:f9:47 (try 1/3) 
May 14 20:32:08 wheezy kernel: [ 475.474812] wlan0: direct probe to bc:05:43:79:f9:47 (try 2/3) 
May 14 20:32:08 wheezy kernel: [ 475.678994] wlan0: direct probe to bc:05:43:79:f9:47 (try 3/3) 
May 14 20:32:08 wheezy kernel: [ 475.883266] wlan0: authentication with bc:05:43:79:f9:47 timed out 
May 14 20:32:08 wheezy NetworkManager[4773]: <info> (wlan0): supplicant interface state: authenticating -> disconnected 
May 14 20:32:08 wheezy NetworkManager[4773]: <info> (wlan0): supplicant interface state: disconnected -> scanning 
May 14 20:32:14 wheezy NetworkManager[4773]: <warn> Activation (wlan0/wireless): association took too long. 
May 14 20:32:14 wheezy NetworkManager[4773]: <info> (wlan0): device state change: config -> need-auth (reason 'none') [50 60 0] 
May 14 20:32:14 wheezy NetworkManager[4773]: <warn> Activation (wlan0/wireless): asking for new secrets 
May 14 20:32:14 wheezy NetworkManager[4773]: <info> (wlan0): supplicant interface state: scanning -> disconnected 
May 14 20:34:14 wheezy NetworkManager[4773]: <info> (wlan0): device state change: need-auth -> failed (reason 'no-secrets') [60 120 7] 
May 14 20:34:14 wheezy NetworkManager[4773]: <warn> Activation (wlan0) failed for access point (FRITZ!Box Fon WLAN 7112) 
May 14 20:34:14 wheezy NetworkManager[4773]: <warn> Activation (wlan0) failed. 
May 14 20:34:14 wheezy NetworkManager[4773]: <debug> [1400092454.745122] [nm-device.c:4404] nm_device_queue_state(): (wlan0): queued state change to disconnected (id 141) 
May 14 20:34:14 wheezy NetworkManager[4773]: <debug> [1400092454.745268] [nm-device.c:4372] queued_set_state(): (wlan0): running queued state change to disconnected (id 141) 
May 14 20:34:14 wheezy NetworkManager[4773]: <info> (wlan0): device state change: failed -> disconnected (reason 'none') [120 30 0] 
May 14 20:34:14 wheezy NetworkManager[4773]: <info> (wlan0): deactivating device (reason 'none') [0] 
May 14 20:34:14 wheezy NetworkManager[4773]: <debug> [1400092454.745297] [nm-firewall-manager.c:157] nm_firewall_manager_remove_from_zone(): (wlan0) firewall zone remove skipped (not running) 
May 14 20:34:14 wheezy NetworkManager[4773]: <debug> [1400092454.745371] [nm-device-wifi.c:868] _set_hw_addr(): (wlan0): no MAC address change needed 
May 14 20:34:14 wheezy NetworkManager[4773]: <debug> [1400092454.745473] [nm-system.c:1205] nm_system_iface_flush_routes(): (wlan0): flushing routes ifindex 3 family INET (2) 
May 14 20:34:14 wheezy NetworkManager[4773]: <debug> [1400092454.745622] [nm-system.c:196] sync_addresses(): (wlan0): syncing addresses (family 2) 



i hope you can help me!
Thanks in advanced!

best regards
Stefan



