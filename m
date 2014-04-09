Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:54741 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbaDIKRS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 06:17:18 -0400
Received: by mail-pb0-f44.google.com with SMTP id rp16so2327070pbb.17
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 03:17:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1397035298.4418.60.camel@dubbel>
References: <CAGm1_ktNAyqWhkTPycA-yKz9iXgqGvx3unjB7JHQpmiKFnFXuA@mail.gmail.com>
 <1396988949.4418.46.camel@dubbel> <CAGm1_ksFRCUNi1DPfmv=+8bBqiWxLSm6EeSYjhfVwR7oiAWBkw@mail.gmail.com>
 <1397035298.4418.60.camel@dubbel>
From: Yegor Yefremov <yegorslists@googlemail.com>
Date: Wed, 9 Apr 2014 12:16:57 +0200
Message-ID: <CAGm1_ktMWV0m1-gUTe8bQT1=f9HseBKCJn22bvPAgxynpeaQLg@mail.gmail.com> (sfid-20140409_121721_982147_C8114450)
Subject: Re: wl1271: tx stuck in firmware
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, kaloz@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 9, 2014 at 11:21 AM, Luca Coelho <luca@coelho.fi> wrote:
> On Wed, 2014-04-09 at 11:14 +0200, Yegor Yefremov wrote:
>> On Tue, Apr 8, 2014 at 10:29 PM, Luca Coelho <luca@coelho.fi> wrote:
>> > On Tue, 2014-04-08 at 17:28 +0200, Yegor Yefremov wrote:
>> >> Any idea, what could be wrong?
>> >
>> > First of all, try a clean kernel.
>>
>> It is not simple to get a clean kernel. "Official" support for
>> am335x-evmsk WLAN was added first in the upcoming 3.15 kernel. I've
>> tried the merge window version (3.14.0-12041-g75ff24f-dirty) and get
>> following issue:
>>
>> # calibrator wlan0 plt power_mode on
>> wlcore: power up
>> wlcore: ERROR timeout waiting for the hardware to complete initialization
>> wlcore: ERROR timeout waiting for the hardware to complete initialization
>> wlcore: ERROR timeout waiting for the hardware to complete initialization
>> wlcore: ERROR firmware boot in PLT mode failed despite 3 retries
>> command failed: Input/output error (-5)
>
> Okay, the main question here is, did you make any changes in the
> wlcore/wl12xx code? As I said, the TX watchdog should *not* be
> initialized in PLT mode.

I made not changes to any file in drivers/net/wireless/ti/

> Maybe you could add some prints in the driver to see when the watchdog
> timer is set up? Try to add a printk in every place where
> wl12xx_rearm_tx_watchdog_locked() is called to see where it is being
> armed.

drivers/net/wireless/ti/wlcore/tx.c in wl1271_tx_allocate()

# calibrator wlan0 plt power_mode on
[   93.107215] wlcore: power up
[   93.688714] wlcore: firmware booted in PLT mode PLT_ON (PLT 6.3.10.0.133)
# [  139.232802] YY: wl1271_tx_allocate
[  144.241849] wlcore: ERROR Tx stuck (in FW) for 5000 ms. Starting recovery
[  144.249064] ------------[ cut here ]------------
[  144.254329] WARNING: CPU: 0 PID: 761 at
drivers/net/wireless/ti/wlcore/main.c:800
wl12xx_queue_recovery_work+0x60/0x68()
[  144.265917] Modules linked in:
[  144.269294] CPU: 0 PID: 761 Comm: kworker/u2:2 Not tainted
3.14.0-rc4-12739-g17534e5-dirty #248
[  144.278507] Workqueue: phy0 wl12xx_tx_watchdog_work
[  144.283836] [<c00151e0>] (unwind_backtrace) from [<c0011e38>]
(show_stack+0x10/0x14)
[  144.292156] [<c0011e38>] (show_stack) from [<c05c5778>]
(dump_stack+0x7c/0x94)
[  144.299909] [<c05c5778>] (dump_stack) from [<c0040274>]
(warn_slowpath_common+0x6c/0x90)
[  144.308474] [<c0040274>] (warn_slowpath_common) from [<c0040334>]
(warn_slowpath_null+0x1c/0x24)
[  144.317869] [<c0040334>] (warn_slowpath_null) from [<c038de34>]
(wl12xx_queue_recovery_work+0x60/0x68)
[  144.327818] [<c038de34>] (wl12xx_queue_recovery_work) from
[<c038df04>] (wl12xx_tx_watchdog_work+0xc8/0x1b8)
[  144.338383] [<c038df04>] (wl12xx_tx_watchdog_work) from
[<c0058fac>] (process_one_work+0x1ac/0x4c4)
[  144.348059] [<c0058fac>] (process_one_work) from [<c0059e40>]
(worker_thread+0x114/0x3b4)
[  144.356820] [<c0059e40>] (worker_thread) from [<c005f9fc>]
(kthread+0xcc/0xe8)
[  144.364568] [<c005f9fc>] (kthread) from [<c000e388>]
(ret_from_fork+0x14/0x2c)
[  144.372292] ---[ end trace c815a12d05c76600 ]---

Yegor
