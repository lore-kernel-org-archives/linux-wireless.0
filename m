Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:34306 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760970Ab2CNMpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 08:45:49 -0400
Message-ID: <4F6092FB.6030809@mlbassoc.com> (sfid-20120314_134553_451211_764ECD58)
Date: Wed, 14 Mar 2012 06:45:47 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Luciano Coelho <coelho@ti.com>
Subject: Troubles with wl12xx
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm having some issues getting my [newly designed] board to run
with wl12xx (wl1271 on SDIO)  My kernel is 2.6.37 and I'm using
a compat-wireless snapshot from 2012-02-28

Here's what I see when I boot - looks OK:
   Compat-wireless backport release: compat-wireless-2012-02-28
   Backport based on linux-next.git next-20120228
   cfg80211: Calling CRDA to update world regulatory domain
   wl12xx: loaded

If I bring up the wlan0 interface manually, I can talk to the
device, scan for access points, etc.  All looks good.

The problem comes when I try to negotiate for an address with
WPA security.
   # ifup wlan0
   wl12xx: firmware booted (Rev 6.3.5.0.98)
   ADDRCONF(NETDEV_UP): wlan0: link is not ready
   udhcpc (v1.19.3) started
   Sending discover...
   wl12xx: down
   Sending discover...
   Sending discover...
   No lease, failing

A few seconds later, everything falls apart.  Sorry for the verbosity, but
the messages changed at the end and I wanted to make sure you saw it all.

Any ideas what causes this problem & how I can solve it?

Note: I'm using the very latest TI firmware
   commit 7ad2f977065234f48cf457c5e1f7ce4a37c2d084
   Author: Luciano Coelho <coelho@ti.com>
   Date:   Fri Feb 3 21:42:38 2012 +0200

     wl127x/wl128x firmware: update single role and PLT

     Updated the single role and PLT firmwares for both wl12xx and wl18xx.
     The new revision is now 6/7.3.5.0.96.

     Signed-off-by: Luciano Coelho <coelho@ti.com>

Here are the failure messages:

wl12xx: ERROR command complete timeout
------------[ cut here ]------------
WARNING: at /local/compat-wireless-2012-02-28/drivers/net/wireless/wl12xx/cmd.c:108 wl1271_cmd_send+0x340/0x374 [wl12xx](
)
Modules linked in: ipv6 wl12xx mac80211 cfg80211 compat wl12xx_sdio
Backtrace:
[<c004362c>] (dump_backtrace+0x0/0x110) from [<c031b5b8>] (dump_stack+0x18/0x1c)
  r7:00000000 r6:bf0a93cc r5:bf0c160b r4:0000006c
[<c031b5a0>] (dump_stack+0x0/0x1c) from [<c00675fc>] (warn_slowpath_common+0x58/0x70)
[<c00675a4>] (warn_slowpath_common+0x0/0x70) from [<c0067638>] (warn_slowpath_null+0x24/0x2c)
  r8:00000000 r7:c77a0280 r6:c6c4d9d8 r5:c6c4d720 r4:ffffff92
[<c0067614>] (warn_slowpath_null+0x0/0x2c) from [<bf0a93cc>] (wl1271_cmd_send+0x340/0x374 [wl12xx])
[<bf0a908c>] (wl1271_cmd_send+0x0/0x374 [wl12xx]) from [<bf0aba7c>] (wl12xx_cmd_role_start_ibss+0x1e4/0x23c [wl12xx])
[<bf0ab898>] (wl12xx_cmd_role_start_ibss+0x0/0x23c [wl12xx]) from [<bf0a52b4>] (wl1271_join+0x6c/0xf0 [wl12xx])
  r7:00000000 r6:c6c4d720 r5:00000000 r4:c76ac85c
[<bf0a5248>] (wl1271_join+0x0/0xf0 [wl12xx]) from [<bf0a5c80>] (wl1271_op_bss_info_changed+0x948/0xb84 [wl12xx])
  r7:00000000 r6:c6c4d720 r5:c76ac85c r4:00000000
[<bf0a5338>] (wl1271_op_bss_info_changed+0x0/0xb84 [wl12xx]) from [<bf046b38>] (ieee80211_bss_info_change_notify+0x168/0x
178 [mac80211])
[<bf0469d0>] (ieee80211_bss_info_change_notify+0x0/0x178 [mac80211]) from [<bf04fec8>] (__ieee80211_sta_join_ibss+0x528/0
x5bc [mac80211])
  r6:c6c39660 r5:c6c3965f r4:00000001
[<bf04f9a0>] (__ieee80211_sta_join_ibss+0x0/0x5bc [mac80211]) from [<bf050384>] (ieee80211_ibss_work+0x330/0x498 [mac8021
1])
[<bf050054>] (ieee80211_ibss_work+0x0/0x498 [mac80211]) from [<bf053274>] (ieee80211_iface_work+0x2a4/0x2c4 [mac80211])
[<bf052fd0>] (ieee80211_iface_work+0x0/0x2c4 [mac80211]) from [<c0079db0>] (process_one_work+0x244/0x388)
[<c0079b6c>] (process_one_work+0x0/0x388) from [<c007a9c4>] (worker_thread+0x1fc/0x400)
[<c007a7c8>] (worker_thread+0x0/0x400) from [<c007f5d0>] (kthread+0x88/0x90)
[<c007f548>] (kthread+0x0/0x90) from [<c006a960>] (do_exit+0x0/0x5d0)
  r7:00000013 r6:c006a960 r5:c007f548 r4:c7437edc
---[ end trace 497f918746a49a99 ]---
wl12xx: ERROR failed to initiate cmd role enable
wl12xx: WARNING cmd join failed -110
wl12xx: ERROR command complete timeout
------------[ cut here ]------------
WARNING: at /local/compat-wireless-2012-02-28/drivers/net/wireless/wl12xx/cmd.c:108 wl1271_cmd_send+0x340/0x374 [wl12xx](
)
Modules linked in: ipv6 wl12xx mac80211 cfg80211 compat wl12xx_sdio
Backtrace:
[<c004362c>] (dump_backtrace+0x0/0x110) from [<c031b5b8>] (dump_stack+0x18/0x1c)
  r7:00000000 r6:bf0a93cc r5:bf0c160b r4:0000006c
[<c031b5a0>] (dump_stack+0x0/0x1c) from [<c00675fc>] (warn_slowpath_common+0x58/0x70)
[<c00675a4>] (warn_slowpath_common+0x0/0x70) from [<c0067638>] (warn_slowpath_null+0x24/0x2c)
  r8:00000000 r7:c6cf8d00 r6:c6c4d9d8 r5:c6c4d720 r4:ffffff92
[<c0067614>] (warn_slowpath_null+0x0/0x2c) from [<bf0a93cc>] (wl1271_cmd_send+0x340/0x374 [wl12xx])
[<bf0a908c>] (wl1271_cmd_send+0x0/0x374 [wl12xx]) from [<bf0ab0f0>] (wl1271_cmd_configure+0x84/0xb4 [wl12xx])
[<bf0ab06c>] (wl1271_cmd_configure+0x0/0xb4 [wl12xx]) from [<bf0b0fb8>] (wl1271_acx_ac_cfg+0xd0/0x10c [wl12xx])
  r7:00000002 r6:00000007 r5:000005e0 r4:c6cf8d00
[<bf0b0ee8>] (wl1271_acx_ac_cfg+0x0/0x10c [wl12xx]) from [<bf0a3e5c>] (wl1271_op_conf_tx+0xd0/0x19c [wl12xx])
[<bf0a3d8c>] (wl1271_op_conf_tx+0x0/0x19c [wl12xx]) from [<bf062e6c>] (ieee80211_set_wmm_default+0x184/0x1c8 [mac80211])
[<bf062ce8>] (ieee80211_set_wmm_default+0x0/0x1c8 [mac80211]) from [<bf062f28>] (ieee80211_sta_def_wmm_params+0x78/0x7c [
mac80211])
[<bf062eb0>] (ieee80211_sta_def_wmm_params+0x0/0x7c [mac80211]) from [<bf04fedc>] (__ieee80211_sta_join_ibss+0x53c/0x5bc
[mac80211])
  r5:c6c3965f r4:00000001
[<bf04f9a0>] (__ieee80211_sta_join_ibss+0x0/0x5bc [mac80211]) from [<bf050384>] (ieee80211_ibss_work+0x330/0x498 [mac8021
1])
[<bf050054>] (ieee80211_ibss_work+0x0/0x498 [mac80211]) from [<bf053274>] (ieee80211_iface_work+0x2a4/0x2c4 [mac80211])
[<bf052fd0>] (ieee80211_iface_work+0x0/0x2c4 [mac80211]) from [<c0079db0>] (process_one_work+0x244/0x388)
[<c0079b6c>] (process_one_work+0x0/0x388) from [<c007a9c4>] (worker_thread+0x1fc/0x400)
[<c007a7c8>] (worker_thread+0x0/0x400) from [<c007f5d0>] (kthread+0x88/0x90)
[<c007f548>] (kthread+0x0/0x90) from [<c006a960>] (do_exit+0x0/0x5d0)
  r7:00000013 r6:c006a960 r5:c007f548 r4:c7437edc
---[ end trace 497f918746a49a9a ]---
wl12xx: WARNING CONFIGURE command NOK
wl12xx: WARNING acx ac cfg failed: -110
wl12xx: ERROR command complete timeout
------------[ cut here ]------------
WARNING: at /local/compat-wireless-2012-02-28/drivers/net/wireless/wl12xx/cmd.c:108 wl1271_cmd_send+0x340/0x374 [wl12xx](
)
Modules linked in: ipv6 wl12xx mac80211 cfg80211 compat wl12xx_sdio
Backtrace:
[<c004362c>] (dump_backtrace+0x0/0x110) from [<c031b5b8>] (dump_stack+0x18/0x1c)
  r7:00000000 r6:bf0a93cc r5:bf0c160b r4:0000006c
[<c031b5a0>] (dump_stack+0x0/0x1c) from [<c00675fc>] (warn_slowpath_common+0x58/0x70)
[<c00675a4>] (warn_slowpath_common+0x0/0x70) from [<c0067638>] (warn_slowpath_null+0x24/0x2c)
  r8:00000000 r7:c6cf8d00 r6:c6c4d9d8 r5:c6c4d720 r4:ffffff92
[<c0067614>] (warn_slowpath_null+0x0/0x2c) from [<bf0a93cc>] (wl1271_cmd_send+0x340/0x374 [wl12xx])
[<bf0a908c>] (wl1271_cmd_send+0x0/0x374 [wl12xx]) from [<bf0ab0f0>] (wl1271_cmd_configure+0x84/0xb4 [wl12xx])
[<bf0ab06c>] (wl1271_cmd_configure+0x0/0xb4 [wl12xx]) from [<bf0b0fb8>] (wl1271_acx_ac_cfg+0xd0/0x10c [wl12xx])
  r7:00000002 r6:0000000f r5:00000bc0 r4:c6cf8d00
[<bf0b0ee8>] (wl1271_acx_ac_cfg+0x0/0x10c [wl12xx]) from [<bf0a3e5c>] (wl1271_op_conf_tx+0xd0/0x19c [wl12xx])
[<bf0a3d8c>] (wl1271_op_conf_tx+0x0/0x19c [wl12xx]) from [<bf062e6c>] (ieee80211_set_wmm_default+0x184/0x1c8 [mac80211])
[<bf062ce8>] (ieee80211_set_wmm_default+0x0/0x1c8 [mac80211]) from [<bf062f28>] (ieee80211_sta_def_wmm_params+0x78/0x7c [
mac80211])
[<bf062eb0>] (ieee80211_sta_def_wmm_params+0x0/0x7c [mac80211]) from [<bf04fedc>] (__ieee80211_sta_join_ibss+0x53c/0x5bc
[mac80211])
  r5:c6c3965f r4:00000001
[<bf04f9a0>] (__ieee80211_sta_join_ibss+0x0/0x5bc [mac80211]) from [<bf050384>] (ieee80211_ibss_work+0x330/0x498 [mac8021
1])
[<bf050054>] (ieee80211_ibss_work+0x0/0x498 [mac80211]) from [<bf053274>] (ieee80211_iface_work+0x2a4/0x2c4 [mac80211])
[<bf052fd0>] (ieee80211_iface_work+0x0/0x2c4 [mac80211]) from [<c0079db0>] (process_one_work+0x244/0x388)
[<c0079b6c>] (process_one_work+0x0/0x388) from [<c007a9c4>] (worker_thread+0x1fc/0x400)
[<c007a7c8>] (worker_thread+0x0/0x400) from [<c007f5d0>] (kthread+0x88/0x90)
[<c007f548>] (kthread+0x0/0x90) from [<c006a960>] (do_exit+0x0/0x5d0)
  r7:00000013 r6:c006a960 r5:c007f548 r4:c7437edc
---[ end trace 497f918746a49a9b ]---
wl12xx: WARNING CONFIGURE command NOK
wl12xx: WARNING acx ac cfg failed: -110
wl12xx: ERROR command complete timeout
------------[ cut here ]------------
WARNING: at /local/compat-wireless-2012-02-28/drivers/net/wireless/wl12xx/cmd.c:108 wl1271_cmd_send+0x340/0x374 [wl12xx](
)
Modules linked in: ipv6 wl12xx mac80211 cfg80211 compat wl12xx_sdio
Backtrace:
[<c004362c>] (dump_backtrace+0x0/0x110) from [<c031b5b8>] (dump_stack+0x18/0x1c)
  r7:00000000 r6:bf0a93cc r5:bf0c160b r4:0000006c
[<c031b5a0>] (dump_stack+0x0/0x1c) from [<c00675fc>] (warn_slowpath_common+0x58/0x70)
[<c00675a4>] (warn_slowpath_common+0x0/0x70) from [<c0067638>] (warn_slowpath_null+0x24/0x2c)
  r8:00000000 r7:c6cf8d00 r6:c6c4d9d8 r5:c6c4d720 r4:ffffff92
[<c0067614>] (warn_slowpath_null+0x0/0x2c) from [<bf0a93cc>] (wl1271_cmd_send+0x340/0x374 [wl12xx])
[<bf0a908c>] (wl1271_cmd_send+0x0/0x374 [wl12xx]) from [<bf0ab0f0>] (wl1271_cmd_configure+0x84/0xb4 [wl12xx])
[<bf0ab06c>] (wl1271_cmd_configure+0x0/0xb4 [wl12xx]) from [<bf0b0fb8>] (wl1271_acx_ac_cfg+0xd0/0x10c [wl12xx])
  r7:00000003 r6:000003ff r5:00000000 r4:c6cf8d00
[<bf0b0ee8>] (wl1271_acx_ac_cfg+0x0/0x10c [wl12xx]) from [<bf0a3e5c>] (wl1271_op_conf_tx+0xd0/0x19c [wl12xx])
[<bf0a3d8c>] (wl1271_op_conf_tx+0x0/0x19c [wl12xx]) from [<bf062e6c>] (ieee80211_set_wmm_default+0x184/0x1c8 [mac80211])
[<bf062ce8>] (ieee80211_set_wmm_default+0x0/0x1c8 [mac80211]) from [<bf062f28>] (ieee80211_sta_def_wmm_params+0x78/0x7c [
mac80211])
[<bf062eb0>] (ieee80211_sta_def_wmm_params+0x0/0x7c [mac80211]) from [<bf04fedc>] (__ieee80211_sta_join_ibss+0x53c/0x5bc
[mac80211])
  r5:c6c3965f r4:00000001
[<bf04f9a0>] (__ieee80211_sta_join_ibss+0x0/0x5bc [mac80211]) from [<bf050384>] (ieee80211_ibss_work+0x330/0x498 [mac8021
1])
[<bf050054>] (ieee80211_ibss_work+0x0/0x498 [mac80211]) from [<bf053274>] (ieee80211_iface_work+0x2a4/0x2c4 [mac80211])
[<bf052fd0>] (ieee80211_iface_work+0x0/0x2c4 [mac80211]) from [<c0079db0>] (process_one_work+0x244/0x388)
[<c0079b6c>] (process_one_work+0x0/0x388) from [<c007a9c4>] (worker_thread+0x1fc/0x400)
[<c007a7c8>] (worker_thread+0x0/0x400) from [<c007f5d0>] (kthread+0x88/0x90)
[<c007f548>] (kthread+0x0/0x90) from [<c006a960>] (do_exit+0x0/0x5d0)
  r7:00000013 r6:c006a960 r5:c007f548 r4:c7437edc
---[ end trace 497f918746a49a9c ]---
wl12xx: WARNING CONFIGURE command NOK
wl12xx: WARNING acx ac cfg failed: -110
wl12xx: ERROR command complete timeout
------------[ cut here ]------------
WARNING: at /local/compat-wireless-2012-02-28/drivers/net/wireless/wl12xx/cmd.c:108 wl1271_cmd_send+0x340/0x374 [wl12xx](
)
Modules linked in: ipv6 wl12xx mac80211 cfg80211 compat wl12xx_sdio
Backtrace:
[<c004362c>] (dump_backtrace+0x0/0x110) from [<c031b5b8>] (dump_stack+0x18/0x1c)
  r7:00000000 r6:bf0a93cc r5:bf0c160b r4:0000006c
[<c031b5a0>] (dump_stack+0x0/0x1c) from [<c00675fc>] (warn_slowpath_common+0x58/0x70)
[<c00675a4>] (warn_slowpath_common+0x0/0x70) from [<c0067638>] (warn_slowpath_null+0x24/0x2c)
  r8:00000000 r7:c6cf8d00 r6:c6c4d9d8 r5:c6c4d720 r4:ffffff92
[<c0067614>] (warn_slowpath_null+0x0/0x2c) from [<bf0a93cc>] (wl1271_cmd_send+0x340/0x374 [wl12xx])
[<bf0a908c>] (wl1271_cmd_send+0x0/0x374 [wl12xx]) from [<bf0ab0f0>] (wl1271_cmd_configure+0x84/0xb4 [wl12xx])
[<bf0ab06c>] (wl1271_cmd_configure+0x0/0xb4 [wl12xx]) from [<bf0b0fb8>] (wl1271_acx_ac_cfg+0xd0/0x10c [wl12xx])
  r7:00000007 r6:000003ff r5:00000000 r4:c6cf8d00
[<bf0b0ee8>] (wl1271_acx_ac_cfg+0x0/0x10c [wl12xx]) from [<bf0a3e5c>] (wl1271_op_conf_tx+0xd0/0x19c [wl12xx])
[<bf0a3d8c>] (wl1271_op_conf_tx+0x0/0x19c [wl12xx]) from [<bf062e6c>] (ieee80211_set_wmm_default+0x184/0x1c8 [mac80211])
[<bf062ce8>] (ieee80211_set_wmm_default+0x0/0x1c8 [mac80211]) from [<bf062f28>] (ieee80211_sta_def_wmm_params+0x78/0x7c [
mac80211])
[<bf062eb0>] (ieee80211_sta_def_wmm_params+0x0/0x7c [mac80211]) from [<bf04fedc>] (__ieee80211_sta_join_ibss+0x53c/0x5bc
[mac80211])
  r5:c6c3965f r4:00000001
[<bf04f9a0>] (__ieee80211_sta_join_ibss+0x0/0x5bc [mac80211]) from [<bf050384>] (ieee80211_ibss_work+0x330/0x498 [mac8021
1])
[<bf050054>] (ieee80211_ibss_work+0x0/0x498 [mac80211]) from [<bf053274>] (ieee80211_iface_work+0x2a4/0x2c4 [mac80211])
[<bf052fd0>] (ieee80211_iface_work+0x0/0x2c4 [mac80211]) from [<c0079db0>] (process_one_work+0x244/0x388)
[<c0079b6c>] (process_one_work+0x0/0x388) from [<c007a9c4>] (worker_thread+0x1fc/0x400)
[<c007a7c8>] (worker_thread+0x0/0x400) from [<c007f5d0>] (kthread+0x88/0x90)
[<c007f548>] (kthread+0x0/0x90) from [<c006a960>] (do_exit+0x0/0x5d0)
  r7:00000013 r6:c006a960 r5:c007f548 r4:c7437edc
---[ end trace 497f918746a49a9d ]---
wl12xx: WARNING CONFIGURE command NOK
wl12xx: WARNING acx ac cfg failed: -110
wl12xx: ERROR watchdog interrupt received! starting recovery.
wl12xx: Reading FW panic log
wl12xx: ERROR command complete timeout
------------[ cut here ]------------
WARNING: at /local/compat-wireless-2012-02-28/drivers/net/wireless/wl12xx/cmd.c:108 wl1271_cmd_send+0x340/0x374 [wl12xx](
)
Modules linked in: ipv6 wl12xx mac80211 cfg80211 compat wl12xx_sdio
Backtrace:
[<c004362c>] (dump_backtrace+0x0/0x110) from [<c031b5b8>] (dump_stack+0x18/0x1c)
  r7:00000000 r6:bf0a93cc r5:bf0c160b r4:0000006c
[<c031b5a0>] (dump_stack+0x0/0x1c) from [<c00675fc>] (warn_slowpath_common+0x58/0x70)
[<c00675a4>] (warn_slowpath_common+0x0/0x70) from [<c0067638>] (warn_slowpath_null+0x24/0x2c)
  r8:00000000 r7:c6cf8fc0 r6:c6c4d9d8 r5:c6c4d720 r4:ffffff92
[<c0067614>] (warn_slowpath_null+0x0/0x2c) from [<bf0a93cc>] (wl1271_cmd_send+0x340/0x374 [wl12xx])
[<bf0a908c>] (wl1271_cmd_send+0x0/0x374 [wl12xx]) from [<bf0a9c38>] (wl12xx_cmd_stop_fwlog+0x80/0xb8 [wl12xx])
[<bf0a9bb8>] (wl12xx_cmd_stop_fwlog+0x0/0xb8 [wl12xx]) from [<bf0a7950>] (wl1271_recovery_work+0xbc/0x324 [wl12xx])
  r5:c763e640 r4:c6c4d720
[<bf0a7894>] (wl1271_recovery_work+0x0/0x324 [wl12xx]) from [<c0079db0>] (process_one_work+0x244/0x388)
[<c0079b6c>] (process_one_work+0x0/0x388) from [<c007a9c4>] (worker_thread+0x1fc/0x400)
[<c007a7c8>] (worker_thread+0x0/0x400) from [<c007f5d0>] (kthread+0x88/0x90)
[<c007f548>] (kthread+0x0/0x90) from [<c006a960>] (do_exit+0x0/0x5d0)
  r7:00000013 r6:c006a960 r5:c007f548 r4:c7437edc
---[ end trace 497f918746a49a9e ]---
wl12xx: ERROR failed to send stop firmware logger command
wl12xx: Hardware recovery in progress. FW ver: Rev 6.3.5.0.98 pc: 0x1c8c4
wl12xx: down
ieee80211 phy0: Hardware restart was requested
ieee80211 phy0: failed to set key (0, ff:ff:ff:ff:ff:ff) to hardware (-11)
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready


-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
