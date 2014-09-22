Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-am1on0140.outbound.protection.outlook.com ([157.56.112.140]:35488
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752344AbaIVPi4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2014 11:38:56 -0400
From: Bruno De Paoli <bruno.depaoli@bluetreesystems.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: WL1271 SDIO timeouts after device reset
Date: Mon, 22 Sep 2014 15:19:29 +0000
Message-ID: <2781c4a7695f4e358ca736d4d424249c@AM3PR02MB0568.eurprd02.prod.outlook.com> (sfid-20140922_173902_074132_A5DD7540)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

We have a custom iMX53 based platform running Android Gingerbread, Linux kernel 2.6.35 with a TiWi-BLE Wlan/Bluetooth device using the SDIO interface for WLAN. This uses a TI WL1271 WLAN device. We are using a Freescale BSP and the Wl12xx NLCP driver from the TI website.
I'm using a specific function for power on/off operations as opposed to using a fixed voltage regulator. This sets and clears the WL_EN signal on the device. 

I get the following problem when I try and bring up the interface, either through the Android GUI or manually (as shown below) - I get timeouts on the SDIO interface.

# insmod /system/etc/wifi/wl12xx_sdio.ko
wl1271_init
wl12xx: loaded
# ifconfig wlan0 up

------------[ cut here ]------------
WARNING: at /home/wlan/compat-wireless/drivers/net/wireless/wl12xx/sdio.c:126 wl12xx_sdio_raw_write+0xac/0xe8 [wl12xx_sdio]()
Modules linked in: wl12xx_sdio wl12xx mac80211 cfg80211 compat
[<8003e578>] (unwind_backtrace+0x0/0xf0) from [<80068e78>] (warn_slowpath_common+0x4c/0x64)
[<80068e78>] (warn_slowpath_common+0x4c/0x64) from [<80068ea8>] (warn_slowpath_null+0x18/0x1c)
[<80068ea8>] (warn_slowpath_null+0x18/0x1c) from [<7f0e0264>] (wl12xx_sdio_raw_write+0xac/0xe8 [wl12xx_sdio])
[<7f0e0264>] (wl12xx_sdio_raw_write+0xac/0xe8 [wl12xx_sdio]) from [<7f0aecb4>] (wl1271_set_partition+0xe8/0x3dc [wl12xx])
[<7f0aecb4>] (wl1271_set_partition+0xe8/0x3dc [wl12xx]) from [<7f0a678c>] (wl12xx_set_power_on+0x70/0x138 [wl12xx])
[<7f0a678c>] (wl12xx_set_power_on+0x70/0x138 [wl12xx]) from [<7f0a999c>] (wl12xx_chip_wakeup+0x10/0x2b8 [wl12xx])
[<7f0a999c>] (wl12xx_chip_wakeup+0x10/0x2b8 [wl12xx]) from [<7f0a9f5c>] (wl1271_op_add_interface+0x318/0x574 [wl12xx])
[<7f0a9f5c>] (wl1271_op_add_interface+0x318/0x574 [wl12xx]) from [<7f0581c8>] (ieee80211_do_open+0x2e0/0x6c0 [mac80211])
[<7f0581c8>] (ieee80211_do_open+0x2e0/0x6c0 [mac80211]) from [<80371bb8>] (__dev_open+0xa0/0xf0)
[<80371bb8>] (__dev_open+0xa0/0xf0) from [<8036f4f8>] (__dev_change_flags+0x8c/0x110)
[<8036f4f8>] (__dev_change_flags+0x8c/0x110) from [<80371ae4>] (dev_change_flags+0x10/0x44)
[<80371ae4>] (dev_change_flags+0x10/0x44) from [<803c793c>] (devinet_ioctl+0x3ac/0x77c)
[<803c793c>] (devinet_ioctl+0x3ac/0x77c) from [<80361058>] (sock_ioctl+0x1f4/0x244)
[<80361058>] (sock_ioctl+0x1f4/0x244) from [<800da3f0>] (vfs_ioctl+0x2c/0xac)
[<800da3f0>] (vfs_ioctl+0x2c/0xac) from [<800daaa4>] (do_vfs_ioctl+0x540/0x5a0)
[<800daaa4>] (do_vfs_ioctl+0x540/0x5a0) from [<800dab50>] (sys_ioctl+0x4c/0x6c)
[<800dab50>] (sys_ioctl+0x4c/0x6c) from [<80039f80>] (ret_fast_syscall+0x0/0x30)
---[ end trace d11e244f1c07d7cf ]---
wl1271_sdio mmc1:0001:2: sdio write failed (-110)
------------[ cut here ]------------
WARNING: at /home/wlan/compat-wireless/drivers/net/wireless/wl12xx/sdio.c:126 wl12xx_sdio_raw_write+0xac/0xe8 [wl12xx_sdio]()
Modules linked in: wl12xx_sdio wl12xx mac80211 cfg80211 compat
[<8003e578>] (unwind_backtrace+0x0/0xf0) from [<80068e78>] (warn_slowpath_common+0x4c/0x64)
[<80068e78>] (warn_slowpath_common+0x4c/0x64) from [<80068ea8>] (warn_slowpath_null+0x18/0x1c)
[<80068ea8>] (warn_slowpath_null+0x18/0x1c) from [<7f0e0264>] (wl12xx_sdio_raw_write+0xac/0xe8 [wl12xx_sdio])
[<7f0e0264>] (wl12xx_sdio_raw_write+0xac/0xe8 [wl12xx_sdio]) from [<7f0aecb4>] (wl1271_set_partition+0xe8/0x3dc [wl12xx])
[<7f0aecb4>] (wl1271_set_partition+0xe8/0x3dc [wl12xx]) from [<7f0a678c>] (wl12xx_set_power_on+0x70/0x138 [wl12xx])
[<7f0a678c>] (wl12xx_set_power_on+0x70/0x138 [wl12xx]) from [<7f0a999c>] (wl12xx_chip_wakeup+0x10/0x2b8 [wl12xx])
[<7f0a999c>] (wl12xx_chip_wakeup+0x10/0x2b8 [wl12xx]) from [<7f0a9f5c>] (wl1271_op_add_interface+0x318/0x574 [wl12xx])
[<7f0a9f5c>] (wl1271_op_add_interface+0x318/0x574 [wl12xx]) from [<7f0581c8>] (ieee80211_do_open+0x2e0/0x6c0 [mac80211])
[<7f0581c8>] (ieee80211_do_open+0x2e0/0x6c0 [mac80211]) from [<80371bb8>] (__dev_open+0xa0/0xf0)
[<80371bb8>] (__dev_open+0xa0/0xf0) from [<8036f4f8>] (__dev_change_flags+0x8c/0x110)
[<8036f4f8>] (__dev_change_flags+0x8c/0x110) from [<80371ae4>] (dev_change_flags+0x10/0x44)
[<80371ae4>] (dev_change_flags+0x10/0x44) from [<803c793c>] (devinet_ioctl+0x3ac/0x77c)
[<803c793c>] (devinet_ioctl+0x3ac/0x77c) from [<80361058>] (sock_ioctl+0x1f4/0x244)
[<80361058>] (sock_ioctl+0x1f4/0x244) from [<800da3f0>] (vfs_ioctl+0x2c/0xac)
[<800da3f0>] (vfs_ioctl+0x2c/0xac) from [<800daaa4>] (do_vfs_ioctl+0x540/0x5a0)
[<800daaa4>] (do_vfs_ioctl+0x540/0x5a0) from [<800dab50>] (sys_ioctl+0x4c/0x6c)
[<800dab50>] (sys_ioctl+0x4c/0x6c) from [<80039f80>] (ret_fast_syscall+0x0/0x30)
---[ end trace d11e244f1c07d7d0 ]---
wl1271_sdio mmc1:0001:2: sdio write failed (-110)
------------[ cut here ]------------
WARNING: at /home/wlan/compat-wireless/drivers/net/wireless/wl12xx/sdio.c:126 wl12xx_sdio_raw_write+0xac/0xe8 [wl12xx_sdio]()
Modules linked in: wl12xx_sdio wl12xx mac80211 cfg80211 compat
[<8003e578>] (unwind_backtrace+0x0/0xf0) from [<80068e78>] (warn_slowpath_common+0x4c/0x64)
[<80068e78>] (warn_slowpath_common+0x4c/0x64) from [<80068ea8>] (warn_slowpath_null+0x18/0x1c)
[<80068ea8>] (warn_slowpath_null+0x18/0x1c) from [<7f0e0264>] (wl12xx_sdio_raw_write+0xac/0xe8 [wl12xx_sdio])
[<7f0e0264>] (wl12xx_sdio_raw_write+0xac/0xe8 [wl12xx_sdio]) from [<7f0aecb4>] (wl1271_set_partition+0xe8/0x3dc [wl12xx])
[<7f0aecb4>] (wl1271_set_partition+0xe8/0x3dc [wl12xx]) from [<7f0a678c>] (wl12xx_set_power_on+0x70/0x138 [wl12xx])
[<7f0a678c>] (wl12xx_set_power_on+0x70/0x138 [wl12xx]) from [<7f0a999c>] (wl12xx_chip_wakeup+0x10/0x2b8 [wl12xx])
[<7f0a999c>] (wl12xx_chip_wakeup+0x10/0x2b8 [wl12xx]) from [<7f0a9f5c>] (wl1271_op_add_interface+0x318/0x574 [wl12xx])
[<7f0a9f5c>] (wl1271_op_add_interface+0x318/0x574 [wl12xx]) from [<7f0581c8>] (ieee80211_do_open+0x2e0/0x6c0 [mac80211])
[<7f0581c8>] (ieee80211_do_open+0x2e0/0x6c0 [mac80211]) from [<80371bb8>] (__dev_open+0xa0/0xf0)
[<80371bb8>] (__dev_open+0xa0/0xf0) from [<8036f4f8>] (__dev_change_flags+0x8c/0x110)
[<8036f4f8>] (__dev_change_flags+0x8c/0x110) from [<80371ae4>] (dev_change_flags+0x10/0x44)
[<80371ae4>] (dev_change_flags+0x10/0x44) from [<803c793c>] (devinet_ioctl+0x3ac/0x77c)
[<803c793c>] (devinet_ioctl+0x3ac/0x77c) from [<80361058>] (sock_ioctl+0x1f4/0x244)
[<80361058>] (sock_ioctl+0x1f4/0x244) from [<800da3f0>] (vfs_ioctl+0x2c/0xac)
[<800da3f0>] (vfs_ioctl+0x2c/0xac) from [<800daaa4>] (do_vfs_ioctl+0x540/0x5a0)
[<800daaa4>] (do_vfs_ioctl+0x540/0x5a0) from [<800dab50>] (sys_ioctl+0x4c/0x6c)
[<800dab50>] (sys_ioctl+0x4c/0x6c) from [<80039f80>] (ret_fast_syscall+0x0/0x30)
---[ end trace d11e244f1c07d7d1 ]---
wl1271_sdio mmc1:0001:2: sdio write failed (-110)
wl12xx: ERROR firmware boot failed despite 3 retries
error: SIOCSIFFLAGS (Invalid argument)

I removed the manipulation of the WL_EN signal in the power control function and the WL_EN was simply set at the beginning. The interface came up correctly the first time. When the WL_EN power manipulation is put back we get the problem shown above. It looks like this is caused by a second reset of the device due to WL_EN toggling that occurs when the interface is enabled/disabled. It appears that after this reset the WL1271 device is not in a correct state, the WL_EN signal is low (off) or the SDIO interface not in the correct state. I've verified that the WL_EN signal is high (on) when the interface is turned on so I don't think this is the issue.

Can anyone suggest what could be happening due to the second reset or a way to debug the problem further?

Thanks,
Bruno

