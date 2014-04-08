Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:50511 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756141AbaDHU3W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 16:29:22 -0400
Message-ID: <1396988949.4418.46.camel@dubbel> (sfid-20140408_222926_906523_5341E1AF)
From: Luca Coelho <luca@coelho.fi>
To: Yegor Yefremov <yegorslists@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 08 Apr 2014 23:29:09 +0300
In-Reply-To: <CAGm1_ktNAyqWhkTPycA-yKz9iXgqGvx3unjB7JHQpmiKFnFXuA@mail.gmail.com>
References: <CAGm1_ktNAyqWhkTPycA-yKz9iXgqGvx3unjB7JHQpmiKFnFXuA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: wl1271: tx stuck in firmware
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-04-08 at 17:28 +0200, Yegor Yefremov wrote:
> I'm using kernel 3.14.0-rc4-12738-g674748b-dirty on a am335x-evmsk as
> also on a custom board. I get following issue on both systems, when
> working with various calibrator functions:

That's not a very nice kernel, right? How am I supposed to know what the
12738 patches you have on top of 3.14.0-rc4 are? Even worse because your
tree is dirty. :(


> # calibrator wlan0 plt power_mode on
> [  252.935208] wlcore: power up
> [  253.502531] wlcore: firmware booted in PLT mode PLT_ON (PLT 6.3.10.0.133)
> # [  399.656192] wlcore: ERROR Tx stuck (in FW) for 5000 ms. Starting recovery

This sounds really strange.  The TX watchdog should not be armed in PLT
mode.

> or following error, when I start NetworkManager and wait for 5 minutes or so:
> 
> [  717.608550] wlcore: Scan completed due to error.
> [  717.613422] ------------[ cut here ]------------
> [  717.618405] WARNING: CPU: 0 PID: 940 at
> drivers/net/wireless/ti/wlcore/main.c:789
> wl12xx_queue_recovery_work+0x60/0x6c()
> [  717.629832] Modules linked in:
> [  717.633055] CPU: 0 PID: 940 Comm: kworker/u2:2 Tainted: G        W
>   3.14.0-rc4-12737-gefb78a0-dirty #214
> [  717.643264] Workqueue: phy0 wl1271_scan_complete_work
> [  717.648649] [<c00151e0>] (unwind_backtrace) from [<c0011e38>]
> (show_stack+0x10/0x14)
> [  717.656762] [<c0011e38>] (show_stack) from [<c05a1944>]
> (dump_stack+0x7c/0x94)
> [  717.664372] [<c05a1944>] (dump_stack) from [<c00402bc>]
> (warn_slowpath_common+0x6c/0x90)
> [  717.672876] [<c00402bc>] (warn_slowpath_common) from [<c004037c>]
> (warn_slowpath_null+0x1c/0x24)
> [  717.682110] [<c004037c>] (warn_slowpath_null) from [<c035be0c>]
> (wl12xx_queue_recovery_work+0x60/0x6c)
> [  717.691889] [<c035be0c>] (wl12xx_queue_recovery_work) from
> [<c036d804>] (wl1271_scan_complete_work+0xf8/0x108)
> [  717.702391] [<c036d804>] (wl1271_scan_complete_work) from
> [<c0058ff4>] (process_one_work+0x1ac/0x4c4)
> [  717.712110] [<c0058ff4>] (process_one_work) from [<c0059e88>]
> (worker_thread+0x114/0x3b4)
> [  717.720707] [<c0059e88>] (worker_thread) from [<c005fa44>]
> (kthread+0xcc/0xe8)
> [  717.728306] [<c005fa44>] (kthread) from [<c000e388>]
> (ret_from_fork+0x14/0x2c)
> [  717.735856] ---[ end trace f4d374bb2ca37664 ]---
> [  717.743587] wlcore: Hardware recovery in progress. FW ver: Rev 6.3.10.0.133
> [  717.752600] wlcore: pc: 0x0, hint_sts: 0x00000020 count: 6
> [  717.759609] wlcore: down
> [  717.764108] ieee80211 phy0: Hardware restart was requested
> [  718.250930] wlcore: firmware booted (Rev 6.3.10.0.133)
> 
> Any idea, what could be wrong?

First of all, try a clean kernel.

--
Luca.

