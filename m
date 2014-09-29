Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbaI2Tqq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 15:46:46 -0400
Message-ID: <1412019981.5379.2.camel@dcbw.local> (sfid-20140929_214650_531793_88422FDA)
Subject: Re: RTL8188SU(rtl8192su) - unavailable
From: Dan Williams <dcbw@redhat.com>
To: poma <pomidorabelisima@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>,
	Joshua Roys <Joshua.Roys@gtri.gatech.edu>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Realtek WlanFAE <wlanfae@realtek.com>,
	lizhaoming <chaoming_li@realsil.com.cn>,
	Network Manager <networkmanager-list@gnome.org>
Date: Mon, 29 Sep 2014 14:46:21 -0500
In-Reply-To: <54292675.4090607@gmail.com>
References: <54292675.4090607@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-09-29 at 11:29 +0200, poma wrote:
> [platform/nm-platform.c:806] nm_platform_link_set_up(): link: setting up 'wlp0s4f1u1' (4)
> [platform/nm-linux-platform.c:2356] link_change_flags(): link: change 4: flags set 'up' (1)
> [platform/nm-linux-platform.c:2250] link_change(): Netlink error changing link 4:  <UP> mtu 0 (1) driver 'rtl8192su' udi '/sys/devices/pci0000:00/0000:00:04.1/usb2/2-1/2-1:1.0/net/wlp0s4f1u1': No such device
> (wlp0s4f1u1): preparing device

This is likely the core problem, and it's also probably the cause of the
wpa_supplicant failures too.  You can test this out without NM running
by simply doing:

ifconfig wlp0s4f1u1 up

and see if it returns an error or not.  Does it?  Does anything show up
in 'dmesg'?  If we can't get 'ifconfig up' working for the device,
clearly NM won't work either...

Dan

> [devices/nm-device.c:6396] nm_device_remove_pending_action(): (wlp0s4f1u1): remove_pending_action (0): 'autoconf6' not pending (expected)
> [platform/nm-linux-platform.c:1965] _log_dbg_sysctl_set_impl(): sysctl: setting '/proc/sys/net/ipv6/conf/wlp0s4f1u1/disable_ipv6' to '1' (current value is identical)
> [platform/nm-linux-platform.c:1967] _log_dbg_sysctl_set_impl(): sysctl: setting '/proc/sys/net/ipv6/conf/wlp0s4f1u1/accept_ra' to '0' (current value is '1')
> [platform/nm-linux-platform.c:1965] _log_dbg_sysctl_set_impl(): sysctl: setting '/proc/sys/net/ipv6/conf/wlp0s4f1u1/use_tempaddr' to '0' (current value is identical)
> [devices/nm-device.c:7024] nm_device_set_hw_addr(): (wlp0s4f1u1): no MAC address change needed
> [devices/nm-device.c:5095] nm_device_set_ip4_config(): (wlp0s4f1u1): clear IP4Config instance (/org/freedesktop/NetworkManager/IP4Config/0)
> [devices/nm-device.c:5203] nm_device_set_ip6_config(): (wlp0s4f1u1): clear IP6Config instance (/org/freedesktop/NetworkManager/IP6Config/0)
> [supplicant-manager/nm-supplicant-manager.c:90] nm_supplicant_manager_iface_get(): (wlp0s4f1u1): creating new supplicant interface
> [supplicant-manager/nm-supplicant-interface.c:881] interface_add(): (wlp0s4f1u1): adding interface to supplicant
> [devices/nm-device.c:6342] nm_device_add_pending_action(): (wlp0s4f1u1): add_pending_action (1): 'waiting for supplicant'
> [nm-manager.c:718] check_if_startup_complete(): check_if_startup_complete returns FALSE because of wlp0s4f1u1
> [nm-device-wifi.c:1192] is_available(): (wlp0s4f1u1): not available because supplicant interface not ready
> [devices/nm-device.c:6705] _set_state_full(): (wlp0s4f1u1): device not yet available for transition to DISCONNECTED
> [nm-manager.c:718] check_if_startup_complete(): check_if_startup_complete returns FALSE because of wlp0s4f1u1
> [devices/nm-device.c:6342] nm_device_add_pending_action(): (wlp0s4f1u1): add_pending_action (2): 'autoactivate'
> [devices/nm-device.c:6376] nm_device_remove_pending_action(): (wlp0s4f1u1): remove_pending_action (1): 'autoactivate'
> [nm-manager.c:718] check_if_startup_complete(): check_if_startup_complete returns FALSE because of wlp0s4f1u1
> [supplicant-manager/nm-supplicant-interface.c:856] interface_add_cb(): (wlp0s4f1u1): error adding interface: wpa_supplicant couldn't grab this interface.
> (wlp0s4f1u1): supplicant interface state: starting -> down
> [devices/nm-device.c:6376] nm_device_remove_pending_action(): (wlp0s4f1u1): remove_pending_action (0): 'waiting for supplicant'
> [supplicant-manager/nm-supplicant-manager.c:90] nm_supplicant_manager_iface_get(): (wlp0s4f1u1): creating new supplicant interface
> [supplicant-manager/nm-supplicant-interface.c:881] interface_add(): (wlp0s4f1u1): adding interface to supplicant
> [devices/nm-device.c:6342] nm_device_add_pending_action(): (wlp0s4f1u1): add_pending_action (1): 'waiting for supplicant'
> [supplicant-manager/nm-supplicant-manager.c:182] get_capabilities_cb(): AP mode is supported
> [supplicant-manager/nm-supplicant-manager.c:194] get_capabilities_cb(): EAP-FAST is supported
> [supplicant-manager/nm-supplicant-interface.c:856] interface_add_cb(): (wlp0s4f1u1): error adding interface: wpa_supplicant couldn't grab this interface.
> etc. etc.. etc...
> 
> 
> - nmcli device
> DEVICE      TYPE      STATE        CONNECTION
> wlp0s4f1u1  wifi      unavailable  --
> 
> 
> poma
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


