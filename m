Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:53362 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaI2J32 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 05:29:28 -0400
Received: by mail-wi0-f175.google.com with SMTP id d1so531242wiv.14
        for <linux-wireless@vger.kernel.org>; Mon, 29 Sep 2014 02:29:27 -0700 (PDT)
Message-ID: <54292675.4090607@gmail.com> (sfid-20140929_112932_314539_29B8652A)
Date: Mon, 29 Sep 2014 11:29:25 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>,
	Joshua Roys <Joshua.Roys@gtri.gatech.edu>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Realtek WlanFAE <wlanfae@realtek.com>,
	lizhaoming <chaoming_li@realsil.com.cn>
CC: Network Manager <networkmanager-list@gnome.org>
Subject: RTL8188SU(rtl8192su) - unavailable
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


- lsusb
0bda:8171 Realtek Semiconductor Corp. RTL8188SU 802.11n WLAN Adapter


- http://wireless.kernel.org/en/users/Drivers/rtl819x#staging_drivers
...
r8712u is a USB driver for RTL8712U/RTL8192SU devices, it's going to be replaced by rtl8192su. 


- /etc/modprobe.d/blacklist-r8712u.conf 
blacklist r8712u


- http://wireless.kernel.org/en/users/Drivers/rtl819x#rtlwifi
...
rtl8192su is a USB driver for RTL8712U/RTL8192SU devices. (WIP : http://github.com/chunkeey/rtl8192su )


- modulecomb

mac80211 -             - rtl_usb -
          \           /           \
           - rtlwifi -             - rtl8192su
          /           \           /
cfg80211 -             - rtl8192s-common


- ls /usr/lib/modules/3.17.0-0.rc6.git2.1.fc22.x86_64/updates
rtl8192s-common.ko
rtl8192su.ko
rtl_usb.ko
rtlwifi.ko


- file /usr/lib/firmware/rtlwifi/rtl8192sufw.bin
/usr/lib/firmware/rtlwifi/rtl8192sufw.bin: symbolic link to `rtl8712u.bin'


- dmesg
rtlwifi: module verification failed: signature and/or  required key missing - tainting kernel
rtl8192s_common: Chip version 0x3
rtl_usb: rx_max_size 9100, rx_urb_num 8, in_ep 3
rtl8192su: Power Save off (module option)
rtl8192su: FW Power Save off (module option)
rtl8192su: Driver for Realtek RTL8192SU/RTL8191SU
Loading firmware rtlwifi/rtl8192sufw.bin
usbcore: registered new interface driver rtl8192su
ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
rtl8192su 2-1:1.0 wlp0s4f1u1: renamed from wlan0
systemd-udevd[391]: renamed network interface wlan0 to wlp0s4f1u1


- nmcli radio 
WIFI-HW  WIFI     WWAN-HW  WWAN    
enabled  enabled  enabled  enabled 


- journalctl NetworkManager(debug)
[platform/nm-platform.c:2565] log_link(): signal: link   added: 4: wlp0s4f1u1 <DOWN> mtu 1500 wifi driver 'rtl8192su' udi '/sys/devices/pci0000:00/0000:00:04.1/usb2/2-1/2-1:1.0/net/wlp0s4f1u1'
[nm-device-wifi.c:228] constructor(): (wlp0s4f1u1): kernel ifindex 4
(wlp0s4f1u1): using nl80211 for WiFi device control
(wlp0s4f1u1): driver supports Access Point (AP) mode
[devices/nm-device.c:6983] nm_device_update_hw_address(): (wlp0s4f1u1): hardware address is 00:E0:4C:81:92:E4
[nm-device-wifi.c:2623] update_initial_hw_address(): (wlp0s4f1u1): read initial MAC address 00:E0:4C:81:92:E4
[platform/nm-linux-platform.c:2099] sysctl_get(): error reading /sys/class/net/wlp0s4f1u1/phys_port_id: Failed to read from file '/sys/class/net/wlp0s4f1u1/phys_port_id': Operation not supported
[nm-manager.c:1372] manager_rfkill_update_one_type(): WiFi hw-enabled 1 sw-enabled 1
[nm-device-wifi.c:3230] set_enabled(): (wlp0s4f1u1): device now enabled
[nm-device-wifi.c:3236] set_enabled(): (enable): wlp0s4f1u1 blocked by UNMANAGED state
(wlp0s4f1u1): new 802.11 WiFi device (driver: 'rtl8192su' ifindex: 4)
(wlp0s4f1u1): exported as /org/freedesktop/NetworkManager/Devices/1
[devices/nm-device.c:5089] nm_device_set_ip4_config(): (wlp0s4f1u1): set IP4Config instance (/org/freedesktop/NetworkManager/IP4Config/0)
[devices/nm-device.c:5197] nm_device_set_ip6_config(): (wlp0s4f1u1): set IP6Config instance (/org/freedesktop/NetworkManager/IP6Config/0)
(wlp0s4f1u1): device state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
[platform/nm-linux-platform.c:2067] _log_dbg_sysctl_get_impl(): sysctl: reading '/proc/sys/net/ipv6/conf/wlp0s4f1u1/accept_ra': '1'
[platform/nm-linux-platform.c:2067] _log_dbg_sysctl_get_impl(): sysctl: reading '/proc/sys/net/ipv6/conf/wlp0s4f1u1/accept_ra_defrtr': '1'
[platform/nm-linux-platform.c:2067] _log_dbg_sysctl_get_impl(): sysctl: reading '/proc/sys/net/ipv6/conf/wlp0s4f1u1/accept_ra_pinfo': '1'
[platform/nm-linux-platform.c:2067] _log_dbg_sysctl_get_impl(): sysctl: reading '/proc/sys/net/ipv6/conf/wlp0s4f1u1/accept_ra_rtr_pref': '1'
[platform/nm-linux-platform.c:2067] _log_dbg_sysctl_get_impl(): sysctl: reading '/proc/sys/net/ipv6/conf/wlp0s4f1u1/disable_ipv6': '0'
[platform/nm-linux-platform.c:2067] _log_dbg_sysctl_get_impl(): sysctl: reading '/proc/sys/net/ipv6/conf/wlp0s4f1u1/hop_limit': '64'
[platform/nm-linux-platform.c:2067] _log_dbg_sysctl_get_impl(): sysctl: reading '/proc/sys/net/ipv6/conf/wlp0s4f1u1/use_tempaddr': '0'
[platform/nm-linux-platform.c:1967] _log_dbg_sysctl_set_impl(): sysctl: setting '/proc/sys/net/ipv6/conf/wlp0s4f1u1/disable_ipv6' to '1' (current value is '0')
[platform/nm-linux-platform.c:1967] _log_dbg_sysctl_set_impl(): sysctl: setting '/proc/sys/net/ipv6/conf/wlp0s4f1u1/accept_ra_defrtr' to '0' (current value is '1')
[platform/nm-linux-platform.c:1967] _log_dbg_sysctl_set_impl(): sysctl: setting '/proc/sys/net/ipv6/conf/wlp0s4f1u1/accept_ra_pinfo' to '0' (current value is '1')
[platform/nm-linux-platform.c:1967] _log_dbg_sysctl_set_impl(): sysctl: setting '/proc/sys/net/ipv6/conf/wlp0s4f1u1/accept_ra_rtr_pref' to '0' (current value is '1')
[platform/nm-linux-platform.c:1965] _log_dbg_sysctl_set_impl(): sysctl: setting '/proc/sys/net/ipv6/conf/wlp0s4f1u1/use_tempaddr' to '0' (current value is identical)
[devices/nm-device.c:5542] nm_device_bring_up(): (wlp0s4f1u1): bringing up device.
[platform/nm-platform.c:806] nm_platform_link_set_up(): link: setting up 'wlp0s4f1u1' (4)
[platform/nm-linux-platform.c:2356] link_change_flags(): link: change 4: flags set 'up' (1)
[platform/nm-linux-platform.c:2250] link_change(): Netlink error changing link 4:  <UP> mtu 0 (1) driver 'rtl8192su' udi '/sys/devices/pci0000:00/0000:00:04.1/usb2/2-1/2-1:1.0/net/wlp0s4f1u1': No such device
(wlp0s4f1u1): preparing device
[devices/nm-device.c:6396] nm_device_remove_pending_action(): (wlp0s4f1u1): remove_pending_action (0): 'autoconf6' not pending (expected)
[platform/nm-linux-platform.c:1965] _log_dbg_sysctl_set_impl(): sysctl: setting '/proc/sys/net/ipv6/conf/wlp0s4f1u1/disable_ipv6' to '1' (current value is identical)
[platform/nm-linux-platform.c:1967] _log_dbg_sysctl_set_impl(): sysctl: setting '/proc/sys/net/ipv6/conf/wlp0s4f1u1/accept_ra' to '0' (current value is '1')
[platform/nm-linux-platform.c:1965] _log_dbg_sysctl_set_impl(): sysctl: setting '/proc/sys/net/ipv6/conf/wlp0s4f1u1/use_tempaddr' to '0' (current value is identical)
[devices/nm-device.c:7024] nm_device_set_hw_addr(): (wlp0s4f1u1): no MAC address change needed
[devices/nm-device.c:5095] nm_device_set_ip4_config(): (wlp0s4f1u1): clear IP4Config instance (/org/freedesktop/NetworkManager/IP4Config/0)
[devices/nm-device.c:5203] nm_device_set_ip6_config(): (wlp0s4f1u1): clear IP6Config instance (/org/freedesktop/NetworkManager/IP6Config/0)
[supplicant-manager/nm-supplicant-manager.c:90] nm_supplicant_manager_iface_get(): (wlp0s4f1u1): creating new supplicant interface
[supplicant-manager/nm-supplicant-interface.c:881] interface_add(): (wlp0s4f1u1): adding interface to supplicant
[devices/nm-device.c:6342] nm_device_add_pending_action(): (wlp0s4f1u1): add_pending_action (1): 'waiting for supplicant'
[nm-manager.c:718] check_if_startup_complete(): check_if_startup_complete returns FALSE because of wlp0s4f1u1
[nm-device-wifi.c:1192] is_available(): (wlp0s4f1u1): not available because supplicant interface not ready
[devices/nm-device.c:6705] _set_state_full(): (wlp0s4f1u1): device not yet available for transition to DISCONNECTED
[nm-manager.c:718] check_if_startup_complete(): check_if_startup_complete returns FALSE because of wlp0s4f1u1
[devices/nm-device.c:6342] nm_device_add_pending_action(): (wlp0s4f1u1): add_pending_action (2): 'autoactivate'
[devices/nm-device.c:6376] nm_device_remove_pending_action(): (wlp0s4f1u1): remove_pending_action (1): 'autoactivate'
[nm-manager.c:718] check_if_startup_complete(): check_if_startup_complete returns FALSE because of wlp0s4f1u1
[supplicant-manager/nm-supplicant-interface.c:856] interface_add_cb(): (wlp0s4f1u1): error adding interface: wpa_supplicant couldn't grab this interface.
(wlp0s4f1u1): supplicant interface state: starting -> down
[devices/nm-device.c:6376] nm_device_remove_pending_action(): (wlp0s4f1u1): remove_pending_action (0): 'waiting for supplicant'
[supplicant-manager/nm-supplicant-manager.c:90] nm_supplicant_manager_iface_get(): (wlp0s4f1u1): creating new supplicant interface
[supplicant-manager/nm-supplicant-interface.c:881] interface_add(): (wlp0s4f1u1): adding interface to supplicant
[devices/nm-device.c:6342] nm_device_add_pending_action(): (wlp0s4f1u1): add_pending_action (1): 'waiting for supplicant'
[supplicant-manager/nm-supplicant-manager.c:182] get_capabilities_cb(): AP mode is supported
[supplicant-manager/nm-supplicant-manager.c:194] get_capabilities_cb(): EAP-FAST is supported
[supplicant-manager/nm-supplicant-interface.c:856] interface_add_cb(): (wlp0s4f1u1): error adding interface: wpa_supplicant couldn't grab this interface.
etc. etc.. etc...


- nmcli device
DEVICE      TYPE      STATE        CONNECTION
wlp0s4f1u1  wifi      unavailable  --


poma

