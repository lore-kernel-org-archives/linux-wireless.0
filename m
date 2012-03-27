Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:44060 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab2C0OZO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 10:25:14 -0400
Message-ID: <4F71CDC7.2010207@mlbassoc.com> (sfid-20120327_162521_503560_704B1B80)
Date: Tue, 27 Mar 2012 08:25:11 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Troy Kisky <troy.kisky@boundarydevices.com>
CC: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Subject: Re: wl1271 watchdog interrupt
References: <4F6A7FD0.8090404@boundarydevices.com>
In-Reply-To: <4F6A7FD0.8090404@boundarydevices.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-03-21 19:26, Troy Kisky wrote:
> Hi all
>
> We have a new board using the wl1271. As long as I keep it busy,
> everything is fine. But once it becomes idle I get,
> "wl12xx: ERROR watchdog interrupt received! starting recovery."
>
> Has this been seen by others?

I'm getting very similar problems and my messages to this list (and the
wl12xx maintainer) are now waiting for nearly two weeks for an answer.

Can someone help with these wl12xx issues?

> I'm using compat-wireless-2012-01-26 and my kernel is based on 3.0
>
> Other relevant log messages:
> cfg80211: Calling CRDA to update world regulatory domain
> add wake up source irq 108
> wl12xx: loaded
> wl12xx: firmware booted (Rev 6.3.0.0.77)
> wlan0: authenticate with 00:12:17:31:67:e7 (try 1)
> wlan0: authenticated
> wlan0: associate with 00:12:17:31:67:e7 (try 1)
> wlan0: RX AssocResp from 00:12:17:31:67:e7 (capab=0x411 status=0 aid=3)
> wlan0: associated
> wlan0: moving STA 00:12:17:31:67:e7 to state 1
> wlan0: moving STA 00:12:17:31:67:e7 to state 2
> wlan0: moving STA 00:12:17:31:67:e7 to state 3
> wl12xx: Association completed.
>
> .......
> wl12xx: ERROR watchdog interrupt received! starting recovery.
> wl12xx: Reading FW panic log
> wl12xx: ERROR command complete timeout
> ------------[ cut here ]------------
> WARNING: at /home/tkisky/compat-wireless-2012-01-26/drivers/net/wireless/wl12xx/cmd.c:108 wl1271_cmd_send+0x378/0x3d0 [wl12xx]()
> Modules linked in: wl12xx mac80211 cfg80211 wl12xx_sdio ov5642_camera
> [<800416f8>] (unwind_backtrace+0x0/0xfc) from [<80064074>] (warn_slowpath_common+0x54/0x64)
> [<80064074>] (warn_slowpath_common+0x54/0x64) from [<800640a0>] (warn_slowpath_null+0x1c/0x24)
> [<800640a0>] (warn_slowpath_null+0x1c/0x24) from [<7f09e080>] (wl1271_cmd_send+0x378/0x3d0 [wl12xx])
> [<7f09e080>] (wl1271_cmd_send+0x378/0x3d0 [wl12xx]) from [<7f09e720>] (wl12xx_cmd_stop_fwlog+0x54/0x80 [wl12xx])
> [<7f09e720>] (wl12xx_cmd_stop_fwlog+0x54/0x80 [wl12xx]) from [<7f09ce18>] (wl1271_recovery_work+0x220/0x314 [wl12xx])
> [<7f09ce18>] (wl1271_recovery_work+0x220/0x314 [wl12xx]) from [<80079b90>] (process_one_work+0x10c/0x408)
> [<80079b90>] (process_one_work+0x10c/0x408) from [<8007a228>] (worker_thread+0x19c/0x470)
> [<8007a228>] (worker_thread+0x19c/0x470) from [<8008071c>] (kthread+0x8c/0x90)
> [<8008071c>] (kthread+0x8c/0x90) from [<8003c474>] (kernel_thread_exit+0x0/0x8)
> ---[ end trace b6d18e2d5294f64d ]---
> wl12xx: ERROR failed to send stop firmware logger command
> wl12xx: Hardware recovery in progress. FW ver: Rev 6.3.0.0.77 pc: 0x23923
> wl12xx: down
> ieee80211 phy0: Hardware restart was requested
> mmc2: Timeout waiting for hardware interrupt.
> sdhci: =========== REGISTER DUMP (mmc2)===========
> sdhci: Sys addr: 0x4a3b1ae8 | Version: 0x00000003
> sdhci: Blk size: 0x00000004 | Blk cnt: 0x00000001
> sdhci: Argument: 0x26ff8804 | Trn mode: 0x00000000
> sdhci: Present: 0xfff9820e | Host ctl: 0x000000de
> sdhci: Power: 0x0000000b | Blk gap: 0x00000000
> sdhci: Wake-up: 0x00000000 | Clock: 0x0000007f
> sdhci: Timeout: 0x00000000 | Int stat: 0x00000000
> sdhci: Int enab: 0x007f000b | Sig enab: 0x007f000b
> sdhci: AC12 err: 0x00000000 | Slot int: 0x00000003
> sdhci: Caps: 0x07f30000 | Caps_1: 0x00000007
> sdhci: Cmd: 0x0000353a | Max curr: 0x00ffffff
> sdhci: Host ctl2: 0x00000088
> sdhci: ===========================================
> wl1271_sdio mmc2:0001:2: sdio read failed (-110)
> wl1271_sdio mmc2:0001:2: sdio write failed (-84)
> mmc2: Timeout waiting for hardware interrupt.
> sdhci: =========== REGISTER DUMP (mmc2)===========
> sdhci: Sys addr: 0x4a3b1ae8 | Version: 0x00000003
> sdhci: Blk size: 0x00000004 | Blk cnt: 0x00000001
> sdhci: Argument: 0x279c6804 | Trn mode: 0x00000000
> sdhci: Present: 0xfff9820e | Host ctl: 0x000000de
> sdhci: Power: 0x0000000b | Blk gap: 0x00000000
> sdhci: Wake-up: 0x00000000 | Clock: 0x0000007f
> sdhci: Timeout: 0x00000000 | Int stat: 0x00000000
> sdhci: Int enab: 0x007f000b | Sig enab: 0x007f000b
> sdhci: AC12 err: 0x00000000 | Slot int: 0x00000003
> sdhci: Caps: 0x07f30000 | Caps_1: 0x00000007
> sdhci: Cmd: 0x0000353a | Max curr: 0x00ffffff
> sdhci: Host ctl2: 0x00000088
> sdhci: ===========================================
> wl1271_sdio mmc2:0001:2: sdio read failed (-110)
> wl12xx: ERROR chip id doesn't match after firmware boot
>
> mmc2: Timeout waiting for hardware interrupt.
> sdhci: =========== REGISTER DUMP (mmc2)===========
> sdhci: Sys addr: 0x4a3b1ae8 | Version: 0x00000003
> sdhci: Blk size: 0x00000004 | Blk cnt: 0x00000001
> sdhci: Argument: 0x24ace804 | Trn mode: 0x00000000
> sdhci: Present: 0xfff9820e | Host ctl: 0x000000de
> sdhci: Power: 0x0000000b | Blk gap: 0x00000000
> sdhci: Wake-up: 0x00000000 | Clock: 0x0000007f
> sdhci: Timeout: 0x00000000 | Int stat: 0x00000000
> sdhci: Int enab: 0x007f000b | Sig enab: 0x007f000b
> sdhci: AC12 err: 0x00000000 | Slot int: 0x00000003
> sdhci: Caps: 0x07f30000 | Caps_1: 0x00000007
> sdhci: Cmd: 0x0000353a | Max curr: 0x00ffffff
> sdhci: Host ctl2: 0x00000088
> sdhci: ===========================================
> wl1271_sdio mmc2:0001:2: sdio read failed (-110)
> wl12xx: WARNING unsupported chip id: 0x1
> mmc2: Timeout waiting for hardware interrupt.
> sdhci: =========== REGISTER DUMP (mmc2)===========
> sdhci: Sys addr: 0x4a3b1ae8 | Version: 0x00000003
> sdhci: Blk size: 0x00000004 | Blk cnt: 0x00000001
> sdhci: Argument: 0x24ace804 | Trn mode: 0x00000000
> sdhci: Present: 0xfff9820e | Host ctl: 0x000000de
> sdhci: Power: 0x0000000b | Blk gap: 0x00000000
> sdhci: Wake-up: 0x00000000 | Clock: 0x0000007f
> sdhci: Timeout: 0x00000000 | Int stat: 0x00000000
> sdhci: Int enab: 0x007f000b | Sig enab: 0x007f000b
> sdhci: AC12 err: 0x00000000 | Slot int: 0x00000003
> sdhci: Caps: 0x07f30000 | Caps_1: 0x00000007
> sdhci: Cmd: 0x0000353a | Max curr: 0x00ffffff
> sdhci: Host ctl2: 0x00000088
> sdhci: ===========================================
> wl1271_sdio mmc2:0001:2: sdio read failed (-110)
> wl12xx: WARNING unsupported chip id: 0x1
> wl12xx: ERROR firmware boot failed despite 3 retries
> ieee80211 phy0: failed to set key (0, ff:ff:ff:ff:ff:ff) to hardware (-11)
>
> ____________________________________________
> I've tried the latest compat-wireless, but it gets an error after association is completed.
>
> Here's the messages with compat-wireless-2012-03-18;
> Any tips appreciated.
> Thanks
> Troy
>
>
> *************************************************************************
>
> cfg80211: Calling CRDA to update world regulatory domain
> add wake up source irq 108
> wl12xx: loaded
> wl12xx: firmware booted (Rev 6.3.5.0.98)
> wlan0: authenticate with 00:12:17:31:67:e7
> wlan0: send auth to 00:12:17:31:67:e7 (try 1/3)
> wlan0: authenticated
> wlan0: associate with 00:12:17:31:67:e7 (try 1/3)
> wlan0: RX AssocResp from 00:12:17:31:67:e7 (capab=0x411 status=0 aid=3)
> wlan0: associated
> wl12xx: ERROR command complete timeout
> ------------[ cut here ]------------
> WARNING: at /home/tkisky/compat-wireless-2012-03-18/drivers/net/wireless/wl12xx/cmd.c:108 wl1271_cmd_send+0x378/0x3d0 [wl12xx]()
> Modules linked in: wl12xx mac80211 cfg80211 wl12xx_sdio compat ov5642_camera
> [<800416f8>] (unwind_backtrace+0x0/0xfc) from [<80064074>] (warn_slowpath_common+0x54/0x64)
> [<80064074>] (warn_slowpath_common+0x54/0x64) from [<800640a0>] (warn_slowpath_null+0x1c/0x24)
> [<800640a0>] (warn_slowpath_null+0x1c/0x24) from [<7f0aa1fc>] (wl1271_cmd_send+0x378/0x3d0 [wl12xx])
> [<7f0aa1fc>] (wl1271_cmd_send+0x378/0x3d0 [wl12xx]) from [<7f0abb3c>] (wl1271_cmd_configure+0x38/0x60 [wl12xx])
> [<7f0abb3c>] (wl1271_cmd_configure+0x38/0x60 [wl12xx]) from [<7f0b0afc>] (wl1271_acx_set_ht_capabilities+0x80/0xd4 [wl12xx])
> [<7f0b0afc>] (wl1271_acx_set_ht_capabilities+0x80/0xd4 [wl12xx]) from [<7f0a64c8>] (wl1271_op_bss_info_changed+0x7c8/0x10ec [wl12xx])
> [<7f0a64c8>] (wl1271_op_bss_info_changed+0x7c8/0x10ec [wl12xx]) from [<7f057b10>] (ieee80211_bss_info_change_notify+0xd4/0x1ac [mac80211])
> [<7f057b10>] (ieee80211_bss_info_change_notify+0xd4/0x1ac [mac80211]) from [<7f07c9d4>] (ieee80211_assoc_success+0x360/0x5cc [mac80211])
> [<7f07c9d4>] (ieee80211_assoc_success+0x360/0x5cc [mac80211]) from [<7f07cd94>] (ieee80211_rx_mgmt_assoc_resp+0x154/0x26c [mac80211])
> [<7f07cd94>] (ieee80211_rx_mgmt_assoc_resp+0x154/0x26c [mac80211]) from [<7f07d698>] (ieee80211_sta_rx_queued_mgmt+0xc0/0x518 [mac80211])
> [<7f07d698>] (ieee80211_sta_rx_queued_mgmt+0xc0/0x518 [mac80211]) from [<7f065824>] (ieee80211_iface_work+0x1c4/0x2cc [mac80211])
> [<7f065824>] (ieee80211_iface_work+0x1c4/0x2cc [mac80211]) from [<80079b90>] (process_one_work+0x10c/0x408)
> [<80079b90>] (process_one_work+0x10c/0x408) from [<8007a228>] (worker_thread+0x19c/0x470)
> [<8007a228>] (worker_thread+0x19c/0x470) from [<8008071c>] (kthread+0x8c/0x90)
> [<8008071c>] (kthread+0x8c/0x90) from [<8003c474>] (kernel_thread_exit+0x0/0x8)
> ---[ end trace 211b9f291393445e ]---
> wl12xx: WARNING CONFIGURE command NOK
> wl12xx: WARNING acx ht capabilities setting failed: -110
> wl12xx: WARNING Set ht cap false failed -110
> wl12xx: ERROR watchdog interrupt received! starting recovery.
> wl12xx: ERROR command complete timeout
> ------------[ cut here ]------------
> WARNING: at /home/tkisky/compat-wireless-2012-03-18/drivers/net/wireless/wl12xx/cmd.c:108 wl1271_cmd_send+0x378/0x3d0 [wl12xx]()
> Modules linked in: wl12xx mac80211 cfg80211 wl12xx_sdio compat ov5642_camera
> [<800416f8>] (unwind_backtrace+0x0/0xfc) from [<80064074>] (warn_slowpath_common+0x54/0x64)
> [<80064074>] (warn_slowpath_common+0x54/0x64) from [<800640a0>] (warn_slowpath_null+0x1c/0x24)
> [<800640a0>] (warn_slowpath_null+0x1c/0x24) from [<7f0aa1fc>] (wl1271_cmd_send+0x378/0x3d0 [wl12xx])
> [<7f0aa1fc>] (wl1271_cmd_send+0x378/0x3d0 [wl12xx]) from [<7f0ab1cc>] (wl12xx_cmd_set_default_wep_key+0x80/0xb0 [wl12xx])
> [<7f0ab1cc>] (wl12xx_cmd_set_default_wep_key+0x80/0xb0 [wl12xx]) from [<7f0a5180>] (wl1271_set_key+0x2ec/0x3e4 [wl12xx])
> [<7f0a5180>] (wl1271_set_key+0x2ec/0x3e4 [wl12xx]) from [<7f0a53c0>] (wl1271_op_set_key+0x148/0x2d0 [wl12xx])
> [<7f0a53c0>] (wl1271_op_set_key+0x148/0x2d0 [wl12xx]) from [<7f074de4>] (ieee80211_key_enable_hw_accel+0xd4/0x1b4 [mac80211])
> [<7f074de4>] (ieee80211_key_enable_hw_accel+0xd4/0x1b4 [mac80211]) from [<7f075350>] (ieee80211_key_link+0xa4/0x13c [mac80211])
> [<7f075350>] (ieee80211_key_link+0xa4/0x13c [mac80211]) from [<7f06c654>] (ieee80211_add_key+0xc0/0x140 [mac80211])
> [<7f06c654>] (ieee80211_add_key+0xc0/0x140 [mac80211]) from [<7f025198>] (cfg80211_upload_connect_keys+0xb0/0x654 [cfg80211])
> [<7f025198>] (cfg80211_upload_connect_keys+0xb0/0x654 [cfg80211]) from [<7f03ce98>] (__cfg80211_connect_result+0x1e8/0x330 [cfg80211])
> [<7f03ce98>] (__cfg80211_connect_result+0x1e8/0x330 [cfg80211]) from [<7f03abb0>] (cfg80211_send_rx_assoc+0x104/0x12c [cfg80211])
> [<7f03abb0>] (cfg80211_send_rx_assoc+0x104/0x12c [cfg80211]) from [<7f07d77c>] (ieee80211_sta_rx_queued_mgmt+0x1a4/0x518 [mac80211])
> [<7f07d77c>] (ieee80211_sta_rx_queued_mgmt+0x1a4/0x518 [mac80211]) from [<7f065824>] (ieee80211_iface_work+0x1c4/0x2cc [mac80211])
> [<7f065824>] (ieee80211_iface_work+0x1c4/0x2cc [mac80211]) from [<80079b90>] (process_one_work+0x10c/0x408)
> [<80079b90>] (process_one_work+0x10c/0x408) from [<8007a228>] (worker_thread+0x19c/0x470)
> [<8007a228>] (worker_thread+0x19c/0x470) from [<8008071c>] (kthread+0x8c/0x90)
> [<8008071c>] (kthread+0x8c/0x90) from [<8003c474>] (kernel_thread_exit+0x0/0x8)
> ---[ end trace 211b9f291393445f ]---
> wl12xx: WARNING cmd set_default_wep_key failed: -110
> wl12xx: ERROR Could not add or replace key
> ieee80211 phy0: failed to set key (0, ff:ff:ff:ff:ff:ff) to hardware (-110)
> wl12xx: Reading FW panic log
> wl12xx: ERROR command complete timeout
> ------------[ cut here ]------------
> WARNING: at /home/tkisky/compat-wireless-2012-03-18/drivers/net/wireless/wl12xx/cmd.c:108 wl1271_cmd_send+0x378/0x3d0 [wl12xx]()
> Modules linked in: wl12xx mac80211 cfg80211 wl12xx_sdio compat ov5642_camera
> [<800416f8>] (unwind_backtrace+0x0/0xfc) from [<80064074>] (warn_slowpath_common+0x54/0x64)
> [<80064074>] (warn_slowpath_common+0x54/0x64) from [<800640a0>] (warn_slowpath_null+0x1c/0x24)
> [<800640a0>] (warn_slowpath_null+0x1c/0x24) from [<7f0aa1fc>] (wl1271_cmd_send+0x378/0x3d0 [wl12xx])
> [<7f0aa1fc>] (wl1271_cmd_send+0x378/0x3d0 [wl12xx]) from [<7f0aa8ec>] (wl12xx_cmd_stop_fwlog+0x54/0x80 [wl12xx])
> [<7f0aa8ec>] (wl12xx_cmd_stop_fwlog+0x54/0x80 [wl12xx]) from [<7f0a8dac>] (wl1271_recovery_work+0x228/0x328 [wl12xx])
> [<7f0a8dac>] (wl1271_recovery_work+0x228/0x328 [wl12xx]) from [<80079b90>] (process_one_work+0x10c/0x408)
> [<80079b90>] (process_one_work+0x10c/0x408) from [<8007a228>] (worker_thread+0x19c/0x470)
> [<8007a228>] (worker_thread+0x19c/0x470) from [<8008071c>] (kthread+0x8c/0x90)
> [<8008071c>] (kthread+0x8c/0x90) from [<8003c474>] (kernel_thread_exit+0x0/0x8)
> ---[ end trace 211b9f2913934460 ]---
> wl12xx: ERROR failed to send stop firmware logger command
> wl12xx: Hardware recovery in progress. FW ver: Rev 6.3.5.0.98 pc: 0x9a16
> wl12xx: down
> ieee80211 phy0: Hardware restart was requested
> wl12xx: ERROR timeout waiting for the hardware to complete initialization
> wl12xx: ERROR timeout waiting for the hardware to complete initialization
> wl12xx: ERROR timeout waiting for the hardware to complete initialization
> wl12xx: ERROR firmware boot failed despite 3 retries
> ------------[ cut here ]------------
> WARNING: at /home/tkisky/compat-wireless-2012-03-18/net/mac80211/util.c:1254 ieee80211_reconfig+0x39c/0x6bc [mac80211]()
> Modules linked in: wl12xx mac80211 cfg80211 wl12xx_sdio compat ov5642_camera
> [<800416f8>] (unwind_backtrace+0x0/0xfc) from [<80064074>] (warn_slowpath_common+0x54/0x64)
> [<80064074>] (warn_slowpath_common+0x54/0x64) from [<800640a0>] (warn_slowpath_null+0x1c/0x24)
> [<800640a0>] (warn_slowpath_null+0x1c/0x24) from [<7f077f00>] (ieee80211_reconfig+0x39c/0x6bc [mac80211])
> [<7f077f00>] (ieee80211_reconfig+0x39c/0x6bc [mac80211]) from [<7f05834c>] (ieee80211_restart_work+0x68/0x84 [mac80211])
> [<7f05834c>] (ieee80211_restart_work+0x68/0x84 [mac80211]) from [<80079b90>] (process_one_work+0x10c/0x408)
> [<80079b90>] (process_one_work+0x10c/0x408) from [<8007a228>] (worker_thread+0x19c/0x470)
> [<8007a228>] (worker_thread+0x19c/0x470) from [<8008071c>] (kthread+0x8c/0x90)
> [<8008071c>] (kthread+0x8c/0x90) from [<8003c474>] (kernel_thread_exit+0x0/0x8)
> ---[ end trace 211b9f2913934461 ]---
> ------------[ cut here ]------------
> WARNING: at /home/tkisky/compat-wireless-2012-03-18/net/mac80211/util.c:1254 ieee80211_reconfig+0x39c/0x6bc [mac80211]()
> Modules linked in: wl12xx mac80211 cfg80211 wl12xx_sdio compat ov5642_camera
> [<800416f8>] (unwind_backtrace+0x0/0xfc) from [<80064074>] (warn_slowpath_common+0x54/0x64)
> [<80064074>] (warn_slowpath_common+0x54/0x64) from [<800640a0>] (warn_slowpath_null+0x1c/0x24)
> [<800640a0>] (warn_slowpath_null+0x1c/0x24) from [<7f077f00>] (ieee80211_reconfig+0x39c/0x6bc [mac80211])
> [<7f077f00>] (ieee80211_reconfig+0x39c/0x6bc [mac80211]) from [<7f05834c>] (ieee80211_restart_work+0x68/0x84 [mac80211])
> [<7f05834c>] (ieee80211_restart_work+0x68/0x84 [mac80211]) from [<80079b90>] (process_one_work+0x10c/0x408)
> [<80079b90>] (process_one_work+0x10c/0x408) from [<8007a228>] (worker_thread+0x19c/0x470)
> [<8007a228>] (worker_thread+0x19c/0x470) from [<8008071c>] (kthread+0x8c/0x90)
> [<8008071c>] (kthread+0x8c/0x90) from [<8003c474>] (kernel_thread_exit+0x0/0x8)
> ---[ end trace 211b9f2913934462 ]---
> ------------[ cut here ]------------
> WARNING: at /home/tkisky/compat-wireless-2012-03-18/net/mac80211/util.c:1254 ieee80211_reconfig+0x39c/0x6bc [mac80211]()
> Modules linked in: wl12xx mac80211 cfg80211 wl12xx_sdio compat ov5642_camera
> [<800416f8>] (unwind_backtrace+0x0/0xfc) from [<80064074>] (warn_slowpath_common+0x54/0x64)
> [<80064074>] (warn_slowpath_common+0x54/0x64) from [<800640a0>] (warn_slowpath_null+0x1c/0x24)
> [<800640a0>] (warn_slowpath_null+0x1c/0x24) from [<7f077f00>] (ieee80211_reconfig+0x39c/0x6bc [mac80211])
> [<7f077f00>] (ieee80211_reconfig+0x39c/0x6bc [mac80211]) from [<7f05834c>] (ieee80211_restart_work+0x68/0x84 [mac80211])
> [<7f05834c>] (ieee80211_restart_work+0x68/0x84 [mac80211]) from [<80079b90>] (process_one_work+0x10c/0x408)
> [<80079b90>] (process_one_work+0x10c/0x408) from [<8007a228>] (worker_thread+0x19c/0x470)
> [<8007a228>] (worker_thread+0x19c/0x470) from [<8008071c>] (kthread+0x8c/0x90)
> [<8008071c>] (kthread+0x8c/0x90) from [<8003c474>] (kernel_thread_exit+0x0/0x8)
> ---[ end trace 211b9f2913934463 ]---
> ieee80211 phy0: failed to set key (0, ff:ff:ff:ff:ff:ff) to hardware (-11)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
