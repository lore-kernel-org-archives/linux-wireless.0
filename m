Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:30693 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbaIVR2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2014 13:28:55 -0400
Message-ID: <54205C54.2000309@broadcom.com> (sfid-20140922_192857_979457_F1513989)
Date: Mon, 22 Sep 2014 19:28:52 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Bruno De Paoli <bruno.depaoli@bluetreesystems.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: WL1271 SDIO timeouts after device reset
References: <2781c4a7695f4e358ca736d4d424249c@AM3PR02MB0568.eurprd02.prod.outlook.com>
In-Reply-To: <2781c4a7695f4e358ca736d4d424249c@AM3PR02MB0568.eurprd02.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/22/14 17:19, Bruno De Paoli wrote:
> Hi,
>
> We have a custom iMX53 based platform running Android Gingerbread, Linux kernel 2.6.35 with a TiWi-BLE Wlan/Bluetooth device using the SDIO interface for WLAN. This uses a TI WL1271 WLAN device. We are using a Freescale BSP and the Wl12xx NLCP driver from the TI website.
> I'm using a specific function for power on/off operations as opposed to using a fixed voltage regulator. This sets and clears the WL_EN signal on the device.
>
> I get the following problem when I try and bring up the interface, either through the Android GUI or manually (as shown below) - I get timeouts on the SDIO interface.

I think the problem is that the MMC stack is totally unaware of what is 
happening when you toggle the WL_EN line. So unless the device reset 
results in card detect interrupt, you are lost.

Regards,
Arend

> # insmod /system/etc/wifi/wl12xx_sdio.ko
> wl1271_init
> wl12xx: loaded
> # ifconfig wlan0 up
>
> ------------[ cut here ]------------
> WARNING: at /home/wlan/compat-wireless/drivers/net/wireless/wl12xx/sdio.c:126 wl12xx_sdio_raw_write+0xac/0xe8 [wl12xx_sdio]()
> Modules linked in: wl12xx_sdio wl12xx mac80211 cfg80211 compat
> [<8003e578>] (unwind_backtrace+0x0/0xf0) from [<80068e78>] (warn_slowpath_common+0x4c/0x64)
> [<80068e78>] (warn_slowpath_common+0x4c/0x64) from [<80068ea8>] (warn_slowpath_null+0x18/0x1c)
> [<80068ea8>] (warn_slowpath_null+0x18/0x1c) from [<7f0e0264>] (wl12xx_sdio_raw_write+0xac/0xe8 [wl12xx_sdio])
> [<7f0e0264>] (wl12xx_sdio_raw_write+0xac/0xe8 [wl12xx_sdio]) from [<7f0aecb4>] (wl1271_set_partition+0xe8/0x3dc [wl12xx])
> [<7f0aecb4>] (wl1271_set_partition+0xe8/0x3dc [wl12xx]) from [<7f0a678c>] (wl12xx_set_power_on+0x70/0x138 [wl12xx])
> [<7f0a678c>] (wl12xx_set_power_on+0x70/0x138 [wl12xx]) from [<7f0a999c>] (wl12xx_chip_wakeup+0x10/0x2b8 [wl12xx])
> [<7f0a999c>] (wl12xx_chip_wakeup+0x10/0x2b8 [wl12xx]) from [<7f0a9f5c>] (wl1271_op_add_interface+0x318/0x574 [wl12xx])
> [<7f0a9f5c>] (wl1271_op_add_interface+0x318/0x574 [wl12xx]) from [<7f0581c8>] (ieee80211_do_open+0x2e0/0x6c0 [mac80211])
> [<7f0581c8>] (ieee80211_do_open+0x2e0/0x6c0 [mac80211]) from [<80371bb8>] (__dev_open+0xa0/0xf0)
> [<80371bb8>] (__dev_open+0xa0/0xf0) from [<8036f4f8>] (__dev_change_flags+0x8c/0x110)
> [<8036f4f8>] (__dev_change_flags+0x8c/0x110) from [<80371ae4>] (dev_change_flags+0x10/0x44)
> [<80371ae4>] (dev_change_flags+0x10/0x44) from [<803c793c>] (devinet_ioctl+0x3ac/0x77c)
> [<803c793c>] (devinet_ioctl+0x3ac/0x77c) from [<80361058>] (sock_ioctl+0x1f4/0x244)
> [<80361058>] (sock_ioctl+0x1f4/0x244) from [<800da3f0>] (vfs_ioctl+0x2c/0xac)
> [<800da3f0>] (vfs_ioctl+0x2c/0xac) from [<800daaa4>] (do_vfs_ioctl+0x540/0x5a0)
> [<800daaa4>] (do_vfs_ioctl+0x540/0x5a0) from [<800dab50>] (sys_ioctl+0x4c/0x6c)
> [<800dab50>] (sys_ioctl+0x4c/0x6c) from [<80039f80>] (ret_fast_syscall+0x0/0x30)
> ---[ end trace d11e244f1c07d7cf ]---
> wl1271_sdio mmc1:0001:2: sdio write failed (-110)
> ------------[ cut here ]------------
> WARNING: at /home/wlan/compat-wireless/drivers/net/wireless/wl12xx/sdio.c:126 wl12xx_sdio_raw_write+0xac/0xe8 [wl12xx_sdio]()
> Modules linked in: wl12xx_sdio wl12xx mac80211 cfg80211 compat
> [<8003e578>] (unwind_backtrace+0x0/0xf0) from [<80068e78>] (warn_slowpath_common+0x4c/0x64)
> [<80068e78>] (warn_slowpath_common+0x4c/0x64) from [<80068ea8>] (warn_slowpath_null+0x18/0x1c)
> [<80068ea8>] (warn_slowpath_null+0x18/0x1c) from [<7f0e0264>] (wl12xx_sdio_raw_write+0xac/0xe8 [wl12xx_sdio])
> [<7f0e0264>] (wl12xx_sdio_raw_write+0xac/0xe8 [wl12xx_sdio]) from [<7f0aecb4>] (wl1271_set_partition+0xe8/0x3dc [wl12xx])
> [<7f0aecb4>] (wl1271_set_partition+0xe8/0x3dc [wl12xx]) from [<7f0a678c>] (wl12xx_set_power_on+0x70/0x138 [wl12xx])
> [<7f0a678c>] (wl12xx_set_power_on+0x70/0x138 [wl12xx]) from [<7f0a999c>] (wl12xx_chip_wakeup+0x10/0x2b8 [wl12xx])
> [<7f0a999c>] (wl12xx_chip_wakeup+0x10/0x2b8 [wl12xx]) from [<7f0a9f5c>] (wl1271_op_add_interface+0x318/0x574 [wl12xx])
> [<7f0a9f5c>] (wl1271_op_add_interface+0x318/0x574 [wl12xx]) from [<7f0581c8>] (ieee80211_do_open+0x2e0/0x6c0 [mac80211])
> [<7f0581c8>] (ieee80211_do_open+0x2e0/0x6c0 [mac80211]) from [<80371bb8>] (__dev_open+0xa0/0xf0)
> [<80371bb8>] (__dev_open+0xa0/0xf0) from [<8036f4f8>] (__dev_change_flags+0x8c/0x110)
> [<8036f4f8>] (__dev_change_flags+0x8c/0x110) from [<80371ae4>] (dev_change_flags+0x10/0x44)
> [<80371ae4>] (dev_change_flags+0x10/0x44) from [<803c793c>] (devinet_ioctl+0x3ac/0x77c)
> [<803c793c>] (devinet_ioctl+0x3ac/0x77c) from [<80361058>] (sock_ioctl+0x1f4/0x244)
> [<80361058>] (sock_ioctl+0x1f4/0x244) from [<800da3f0>] (vfs_ioctl+0x2c/0xac)
> [<800da3f0>] (vfs_ioctl+0x2c/0xac) from [<800daaa4>] (do_vfs_ioctl+0x540/0x5a0)
> [<800daaa4>] (do_vfs_ioctl+0x540/0x5a0) from [<800dab50>] (sys_ioctl+0x4c/0x6c)
> [<800dab50>] (sys_ioctl+0x4c/0x6c) from [<80039f80>] (ret_fast_syscall+0x0/0x30)
> ---[ end trace d11e244f1c07d7d0 ]---
> wl1271_sdio mmc1:0001:2: sdio write failed (-110)
> ------------[ cut here ]------------
> WARNING: at /home/wlan/compat-wireless/drivers/net/wireless/wl12xx/sdio.c:126 wl12xx_sdio_raw_write+0xac/0xe8 [wl12xx_sdio]()
> Modules linked in: wl12xx_sdio wl12xx mac80211 cfg80211 compat
> [<8003e578>] (unwind_backtrace+0x0/0xf0) from [<80068e78>] (warn_slowpath_common+0x4c/0x64)
> [<80068e78>] (warn_slowpath_common+0x4c/0x64) from [<80068ea8>] (warn_slowpath_null+0x18/0x1c)
> [<80068ea8>] (warn_slowpath_null+0x18/0x1c) from [<7f0e0264>] (wl12xx_sdio_raw_write+0xac/0xe8 [wl12xx_sdio])
> [<7f0e0264>] (wl12xx_sdio_raw_write+0xac/0xe8 [wl12xx_sdio]) from [<7f0aecb4>] (wl1271_set_partition+0xe8/0x3dc [wl12xx])
> [<7f0aecb4>] (wl1271_set_partition+0xe8/0x3dc [wl12xx]) from [<7f0a678c>] (wl12xx_set_power_on+0x70/0x138 [wl12xx])
> [<7f0a678c>] (wl12xx_set_power_on+0x70/0x138 [wl12xx]) from [<7f0a999c>] (wl12xx_chip_wakeup+0x10/0x2b8 [wl12xx])
> [<7f0a999c>] (wl12xx_chip_wakeup+0x10/0x2b8 [wl12xx]) from [<7f0a9f5c>] (wl1271_op_add_interface+0x318/0x574 [wl12xx])
> [<7f0a9f5c>] (wl1271_op_add_interface+0x318/0x574 [wl12xx]) from [<7f0581c8>] (ieee80211_do_open+0x2e0/0x6c0 [mac80211])
> [<7f0581c8>] (ieee80211_do_open+0x2e0/0x6c0 [mac80211]) from [<80371bb8>] (__dev_open+0xa0/0xf0)
> [<80371bb8>] (__dev_open+0xa0/0xf0) from [<8036f4f8>] (__dev_change_flags+0x8c/0x110)
> [<8036f4f8>] (__dev_change_flags+0x8c/0x110) from [<80371ae4>] (dev_change_flags+0x10/0x44)
> [<80371ae4>] (dev_change_flags+0x10/0x44) from [<803c793c>] (devinet_ioctl+0x3ac/0x77c)
> [<803c793c>] (devinet_ioctl+0x3ac/0x77c) from [<80361058>] (sock_ioctl+0x1f4/0x244)
> [<80361058>] (sock_ioctl+0x1f4/0x244) from [<800da3f0>] (vfs_ioctl+0x2c/0xac)
> [<800da3f0>] (vfs_ioctl+0x2c/0xac) from [<800daaa4>] (do_vfs_ioctl+0x540/0x5a0)
> [<800daaa4>] (do_vfs_ioctl+0x540/0x5a0) from [<800dab50>] (sys_ioctl+0x4c/0x6c)
> [<800dab50>] (sys_ioctl+0x4c/0x6c) from [<80039f80>] (ret_fast_syscall+0x0/0x30)
> ---[ end trace d11e244f1c07d7d1 ]---
> wl1271_sdio mmc1:0001:2: sdio write failed (-110)
> wl12xx: ERROR firmware boot failed despite 3 retries
> error: SIOCSIFFLAGS (Invalid argument)
>
> I removed the manipulation of the WL_EN signal in the power control function and the WL_EN was simply set at the beginning. The interface came up correctly the first time. When the WL_EN power manipulation is put back we get the problem shown above. It looks like this is caused by a second reset of the device due to WL_EN toggling that occurs when the interface is enabled/disabled. It appears that after this reset the WL1271 device is not in a correct state, the WL_EN signal is low (off) or the SDIO interface not in the correct state. I've verified that the WL_EN signal is high (on) when the interface is turned on so I don't think this is the issue.
>
> Can anyone suggest what could be happening due to the second reset or a way to debug the problem further?
>
> Thanks,
> Bruno
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

