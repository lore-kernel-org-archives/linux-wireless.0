Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:49307 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933287AbaDJHWB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 03:22:01 -0400
Received: by mail-pd0-f182.google.com with SMTP id y10so3529017pdj.13
        for <linux-wireless@vger.kernel.org>; Thu, 10 Apr 2014 00:22:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGm1_kuVg=Y1kHB=QMwv7gU42=zL=z3MPQ+Xck=zLV_NysVbXw@mail.gmail.com>
References: <CAGm1_ktNAyqWhkTPycA-yKz9iXgqGvx3unjB7JHQpmiKFnFXuA@mail.gmail.com>
 <1396988949.4418.46.camel@dubbel> <CAGm1_ksFRCUNi1DPfmv=+8bBqiWxLSm6EeSYjhfVwR7oiAWBkw@mail.gmail.com>
 <1397035298.4418.60.camel@dubbel> <CAGm1_ktMWV0m1-gUTe8bQT1=f9HseBKCJn22bvPAgxynpeaQLg@mail.gmail.com>
 <1397044175.4418.66.camel@dubbel> <CA+XVXfcig5u1cQ8thxwO4B5_u=69x7FpdmORxMR4dFvpig_CZQ@mail.gmail.com>
 <1397047312.4418.68.camel@dubbel> <CA+XVXfcB7Uu9F2OHffOUy8mfUofMc38LS0GnShx7t0NADNckpg@mail.gmail.com>
 <CAGm1_kvwCoUT+EYTQy8bMda5fjnTz2seD25DP7Q1hfHyXtO5fw@mail.gmail.com>
 <CA+XVXfcpRZjQ1DV3Bf7O73fhu0XHYPwPFgWG-F2+=Fs7en58iQ@mail.gmail.com> <CAGm1_kuVg=Y1kHB=QMwv7gU42=zL=z3MPQ+Xck=zLV_NysVbXw@mail.gmail.com>
From: Yegor Yefremov <yegorslists@googlemail.com>
Date: Thu, 10 Apr 2014 09:21:41 +0200
Message-ID: <CAGm1_kttUTzc0aw54R=fFd5K1tvGiv_NmRTAVV-z+5gV0ojCCw@mail.gmail.com> (sfid-20140410_092207_562076_2911BC92)
Subject: Re: wl1271: tx stuck in firmware
To: Arik Nemtsov <arik@wizery.com>
Cc: Luca Coelho <luca@coelho.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	kaloz@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 9, 2014 at 5:28 PM, Yegor Yefremov
<yegorslists@googlemail.com> wrote:
> On Wed, Apr 9, 2014 at 3:25 PM, Arik Nemtsov <arik@wizery.com> wrote:
>> On Wed, Apr 9, 2014 at 4:20 PM, Yegor Yefremov
>> <yegorslists@googlemail.com> wrote:
>>> On Wed, Apr 9, 2014 at 3:07 PM, Arik Nemtsov <arik@wizery.com> wrote:
>>> Both changes helped a lot. At least one can make a lot of tests
>>> without a crash, though I had one
>>>
>>> # calibrator wlan0 plt tune_channel 0 1
>>> # calibrator wlan0 plt tx_tone 1 9000
>>> [  180.041505] wlcore: ERROR command complete timeout
>>
>> It's a FW error.
>> Not sure which change you tried, but if it was one of Luca's, I guess
>> the FW doesn't like it when you ignore its requests for a dummy
>> packet. Did you try my change with just disabling the re-arm?
>
> I have tried both changes. At first disabling the re-arm, it comes
> with the same crash as when I implement both changes at once.

What to do with usual fw and scanning?

# [  165.608684] YY: wl1271_scan_complete_work
[  165.614218] wlcore: Scan completed due to error.
[  165.619356] ------------[ cut here ]------------
[  165.624315] WARNING: CPU: 0 PID: 761 at
drivers/net/wireless/ti/wlcore/main.c:803
wl12xx_queue_recovery_work+0x60/0x6c()
[  165.635889] Modules linked in:
[  165.639335] CPU: 0 PID: 761 Comm: kworker/u2:2 Not tainted
3.14.0-rc4-12738-g674748b-dirty #253
[  165.648663] Workqueue: phy0 wl1271_scan_complete_work
[  165.654087] [<c00151e0>] (unwind_backtrace) from [<c0011e38>]
(show_stack+0x10/0x14)
[  165.662412] [<c0011e38>] (show_stack) from [<c05c5794>]
(dump_stack+0x7c/0x94)
[  165.670162] [<c05c5794>] (dump_stack) from [<c0040274>]
(warn_slowpath_common+0x6c/0x90)
[  165.678819] [<c0040274>] (warn_slowpath_common) from [<c0040334>]
(warn_slowpath_null+0x1c/0x24)
[  165.688213] [<c0040334>] (warn_slowpath_null) from [<c038de34>]
(wl12xx_queue_recovery_work+0x60/0x6c)
[  165.698165] [<c038de34>] (wl12xx_queue_recovery_work) from
[<c039f8d8>] (wl1271_scan_complete_work+0xf4/0x108)
[  165.708911] [<c039f8d8>] (wl1271_scan_complete_work) from
[<c0058fac>] (process_one_work+0x1ac/0x4c4)
[  165.718772] [<c0058fac>] (process_one_work) from [<c0059e40>]
(worker_thread+0x114/0x3b4)
[  165.727531] [<c0059e40>] (worker_thread) from [<c005f9fc>]
(kthread+0xcc/0xe8)
[  165.735187] [<c005f9fc>] (kthread) from [<c000e388>]
(ret_from_fork+0x14/0x2c)
[  165.742915] ---[ end trace 9c62bb183fd26be3 ]---
[  165.755662] wlcore: Hardware recovery in progress. FW ver: Rev 6.3.10.0.133
[  165.769379] wlcore: pc: 0x0, hint_sts: 0x00000020 count: 1
[  165.778031] wlcore: down
[  165.790946] ieee80211 phy0: Hardware restart was requested
[  166.337122] wlcore: firmware booted (Rev 6.3.10.0.133)
[  188.977108] YY: wl1271_scan_complete_work
[  191.333964] YY: wl1271_scan_complete_work
