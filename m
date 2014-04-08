Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:42138 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840AbaDHP20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 11:28:26 -0400
Received: by mail-pd0-f178.google.com with SMTP id x10so1163255pdj.9
        for <linux-wireless@vger.kernel.org>; Tue, 08 Apr 2014 08:28:25 -0700 (PDT)
MIME-Version: 1.0
From: Yegor Yefremov <yegorslists@googlemail.com>
Date: Tue, 8 Apr 2014 17:28:05 +0200
Message-ID: <CAGm1_ktNAyqWhkTPycA-yKz9iXgqGvx3unjB7JHQpmiKFnFXuA@mail.gmail.com> (sfid-20140408_172830_613682_5DCA99D4)
Subject: wl1271: tx stuck in firmware
To: linux-wireless@vger.kernel.org
Cc: luca@coelho.fi
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using kernel 3.14.0-rc4-12738-g674748b-dirty on a am335x-evmsk as
also on a custom board. I get following issue on both systems, when
working with various calibrator functions:

# calibrator wlan0 plt power_mode on
[  252.935208] wlcore: power up
[  253.502531] wlcore: firmware booted in PLT mode PLT_ON (PLT 6.3.10.0.133)
# [  399.656192] wlcore: ERROR Tx stuck (in FW) for 5000 ms. Starting recovery
[  399.663410] ------------[ cut here ]------------
[  399.668606] WARNING: CPU: 0 PID: 761 at
drivers/net/wireless/ti/wlcore/main.c:789
wl12xx_queue_recovery_work+0x60/0x6c()
[  399.680181] Modules linked in:
[  399.683465] CPU: 0 PID: 761 Comm: kworker/u2:2 Not tainted
3.14.0-rc4-12738-g674748b-dirty #247
[  399.692767] Workqueue: phy0 wl12xx_tx_watchdog_work
[  399.698090] [<c00151e0>] (unwind_backtrace) from [<c0011e38>]
(show_stack+0x10/0x14)
[  399.706394] [<c0011e38>] (show_stack) from [<c05c56b0>]
(dump_stack+0x7c/0x94)
[  399.714143] [<c05c56b0>] (dump_stack) from [<c0040274>]
(warn_slowpath_common+0x6c/0x90)
[  399.722708] [<c0040274>] (warn_slowpath_common) from [<c0040334>]
(warn_slowpath_null+0x1c/0x24)
[  399.732100] [<c0040334>] (warn_slowpath_null) from [<c038de00>]
(wl12xx_queue_recovery_work+0x60/0x6c)
[  399.742043] [<c038de00>] (wl12xx_queue_recovery_work) from
[<c038df18>] (wl12xx_tx_watchdog_work+0x10c/0x140)
[  399.752623] [<c038df18>] (wl12xx_tx_watchdog_work) from
[<c0058fac>] (process_one_work+0x1ac/0x4c4)
[  399.762279] [<c0058fac>] (process_one_work) from [<c0059e40>]
(worker_thread+0x114/0x3b4)
[  399.771033] [<c0059e40>] (worker_thread) from [<c005f9fc>]
(kthread+0xcc/0xe8)
[  399.778777] [<c005f9fc>] (kthread) from [<c000e388>]
(ret_from_fork+0x14/0x2c)
[  399.786493] ---[ end trace 422890a806d48616 ]---

or following error, when I start NetworkManager and wait for 5 minutes or so:

[  717.608550] wlcore: Scan completed due to error.
[  717.613422] ------------[ cut here ]------------
[  717.618405] WARNING: CPU: 0 PID: 940 at
drivers/net/wireless/ti/wlcore/main.c:789
wl12xx_queue_recovery_work+0x60/0x6c()
[  717.629832] Modules linked in:
[  717.633055] CPU: 0 PID: 940 Comm: kworker/u2:2 Tainted: G        W
  3.14.0-rc4-12737-gefb78a0-dirty #214
[  717.643264] Workqueue: phy0 wl1271_scan_complete_work
[  717.648649] [<c00151e0>] (unwind_backtrace) from [<c0011e38>]
(show_stack+0x10/0x14)
[  717.656762] [<c0011e38>] (show_stack) from [<c05a1944>]
(dump_stack+0x7c/0x94)
[  717.664372] [<c05a1944>] (dump_stack) from [<c00402bc>]
(warn_slowpath_common+0x6c/0x90)
[  717.672876] [<c00402bc>] (warn_slowpath_common) from [<c004037c>]
(warn_slowpath_null+0x1c/0x24)
[  717.682110] [<c004037c>] (warn_slowpath_null) from [<c035be0c>]
(wl12xx_queue_recovery_work+0x60/0x6c)
[  717.691889] [<c035be0c>] (wl12xx_queue_recovery_work) from
[<c036d804>] (wl1271_scan_complete_work+0xf8/0x108)
[  717.702391] [<c036d804>] (wl1271_scan_complete_work) from
[<c0058ff4>] (process_one_work+0x1ac/0x4c4)
[  717.712110] [<c0058ff4>] (process_one_work) from [<c0059e88>]
(worker_thread+0x114/0x3b4)
[  717.720707] [<c0059e88>] (worker_thread) from [<c005fa44>]
(kthread+0xcc/0xe8)
[  717.728306] [<c005fa44>] (kthread) from [<c000e388>]
(ret_from_fork+0x14/0x2c)
[  717.735856] ---[ end trace f4d374bb2ca37664 ]---
[  717.743587] wlcore: Hardware recovery in progress. FW ver: Rev 6.3.10.0.133
[  717.752600] wlcore: pc: 0x0, hint_sts: 0x00000020 count: 6
[  717.759609] wlcore: down
[  717.764108] ieee80211 phy0: Hardware restart was requested
[  718.250930] wlcore: firmware booted (Rev 6.3.10.0.133)

Any idea, what could be wrong?

Regards,
Yegor
