Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:57277 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbbANOEg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 09:04:36 -0500
Received: by mail-pd0-f171.google.com with SMTP id y13so9986096pdi.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 06:04:36 -0800 (PST)
MIME-Version: 1.0
From: Yegor Yefremov <yegorslists@googlemail.com>
Date: Wed, 14 Jan 2015 15:04:15 +0100
Message-ID: <CAGm1_ksa=ZEbxVkiW7hy9FNu1=pmOmnFrriznhDJPbZiyWKx3g@mail.gmail.com> (sfid-20150114_150441_703177_F8D8DC18)
Subject: wl127x: crash while setting up ad-hoc network
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: luciano.coelho@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kernel: 3.15 - 3.19-rc4
GCC: 4.9.2
SoC: am335x
Firmware: both *.133 (linux-firmware git) and *.137 (ti-utils git)

Following commands trigger this timeout:

iw phy phy0 interface add ah0 type ibss
ifconfig ah0 up
iw dev ah0 ibss join AdHocNetworkName 2412

wlcore: loaded
random: nonblocking pool is initialized
wlcore: firmware booted (Rev 6.3.10.0.137)
ah0: Trigger new scan to find an IBSS to join
ah0: Trigger new scan to find an IBSS to join
ah0: Creating new IBSS network, BSSID 2e:cd:d0:15:11:5f
wlcore: ERROR command complete timeout
------------[ cut here ]------------
WARNING: CPU: 0 PID: 713 at drivers/net/wireless/ti/wlcore/main.c:789
wl1271_recovery_work+0x5e4/0x5f0 [wlcore]()
Modules linked in: wl12xx wlcore wlcore_sdio
CPU: 0 PID: 713 Comm: kworker/u2:2 Not tainted 3.19.0-rc4 #1
Hardware name: Generic AM33XX (Flattened Device Tree)
Workqueue: phy0 ieee80211_iface_work
[<c0015b34>] (unwind_backtrace) from [<c0012340>] (show_stack+0x10/0x14)
[<c0012340>] (show_stack) from [<c05e4da0>] (dump_stack+0x84/0x9c)
[<c05e4da0>] (dump_stack) from [<c003dd64>] (warn_slowpath_common+0x7c/0xb8)
[<c003dd64>] (warn_slowpath_common) from [<c003de3c>]
(warn_slowpath_null+0x1c/0x24)
[<c003de3c>] (warn_slowpath_null) from [<bf00c96c>]
(wl1271_recovery_work+0x5e4/0x5f0 [wlcore])
[<bf00c96c>] (wl1271_recovery_work [wlcore]) from [<bf010bd8>]
(wlcore_rate_to_idx+0x1bc/0x640 [wlcore])
[<bf010bd8>] (wlcore_rate_to_idx [wlcore]) from [<bf012464>]
(wl12xx_cmd_role_start_ibss+0x144/0x21c [wlcore])
[<bf012464>] (wl12xx_cmd_role_start_ibss [wlcore]) from [<bf00dc50>]
(wl1271_op_bss_info_changed+0xb68/0xe54 [wlcore])
[<bf00dc50>] (wl1271_op_bss_info_changed [wlcore]) from [<c0591708>]
(ieee80211_bss_info_change_notify+0xcc/0x1c4)
[<c0591708>] (ieee80211_bss_info_change_notify) from [<c059f550>]
(__ieee80211_sta_join_ibss+0x334/0x728)
[<c059f550>] (__ieee80211_sta_join_ibss) from [<c059fe7c>]
(ieee80211_sta_create_ibss+0x9c/0x128)
[<c059fe7c>] (ieee80211_sta_create_ibss) from [<c05a18c8>]
(ieee80211_ibss_work+0x3ac/0x45c)
[<c05a18c8>] (ieee80211_ibss_work) from [<c0053a68>]
(process_one_work+0x1b0/0x490)
[<c0053a68>] (process_one_work) from [<c0054550>] (worker_thread+0x34/0x4a4)
[<c0054550>] (worker_thread) from [<c00589d0>] (kthread+0xd4/0xf0)
[<c00589d0>] (kthread) from [<c000e8e8>] (ret_from_fork+0x14/0x2c)
---[ end trace 9ddbacc6663b9d62 ]---
wlcore: ERROR failed to initiate cmd role enable
wlcore: WARNING cmd join failed -110
wlcore: Hardware recovery in progress. FW ver: Rev 6.3.10.0.137
wlcore: pc: 0x1b790, hint_sts: 0x00000021 count: 1
wlcore: down
ieee80211 phy0: Hardware restart was requested
wlcore: firmware booted (Rev 6.3.10.0.137)

Any idea? I doubt, there is newer firmware though.

Regards,
Yegor
