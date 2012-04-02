Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:51001 "EHLO
	na3sys009amx257.postini.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751333Ab2DBIjI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 04:39:08 -0400
Received: by bkwj5 with SMTP id j5so2221200bkw.30
        for <linux-wireless@vger.kernel.org>; Mon, 02 Apr 2012 01:39:05 -0700 (PDT)
Message-ID: <1333355941.16990.23.camel@cumari> (sfid-20120402_103913_801161_D730198C)
Subject: Re: wl1271 watchdog interrupt
From: Luciano Coelho <coelho@ti.com>
To: Gary Thomas <gary@mlbassoc.com>
Cc: Troy Kisky <troy.kisky@boundarydevices.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 02 Apr 2012 11:39:01 +0300
In-Reply-To: <4F71CDC7.2010207@mlbassoc.com>
References: <4F6A7FD0.8090404@boundarydevices.com>
	 <4F71CDC7.2010207@mlbassoc.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, 2012-03-27 at 08:25 -0600, Gary Thomas wrote: 
> On 2012-03-21 19:26, Troy Kisky wrote:
> > Hi all
> >
> > We have a new board using the wl1271. As long as I keep it busy,
> > everything is fine. But once it becomes idle I get,
> > "wl12xx: ERROR watchdog interrupt received! starting recovery."
> >
> > Has this been seen by others?
> 
> I'm getting very similar problems and my messages to this list (and the
> wl12xx maintainer) are now waiting for nearly two weeks for an answer.
> 
> Can someone help with these wl12xx issues?

Sorry for the delay, I've been busy traveling and on vacations in the
past weeks.


> > I'm using compat-wireless-2012-01-26 and my kernel is based on 3.0
> >
> > Other relevant log messages:
> > cfg80211: Calling CRDA to update world regulatory domain
> > add wake up source irq 108
> > wl12xx: loaded
> > wl12xx: firmware booted (Rev 6.3.0.0.77)
> > wlan0: authenticate with 00:12:17:31:67:e7 (try 1)
> > wlan0: authenticated
> > wlan0: associate with 00:12:17:31:67:e7 (try 1)
> > wlan0: RX AssocResp from 00:12:17:31:67:e7 (capab=0x411 status=0 aid=3)
> > wlan0: associated
> > wlan0: moving STA 00:12:17:31:67:e7 to state 1
> > wlan0: moving STA 00:12:17:31:67:e7 to state 2
> > wlan0: moving STA 00:12:17:31:67:e7 to state 3
> > wl12xx: Association completed.
> >
> > .......
> > wl12xx: ERROR watchdog interrupt received! starting recovery.
> > wl12xx: Reading FW panic log
> > wl12xx: ERROR command complete timeout

This is a firmware bug.  Can you please take the contents
of /sys/bus/platform/drivers/wl12xx_driver/wl12xx/fwlog and send it to
us so we can take a look at what's going on?


> > ------------[ cut here ]------------
> > WARNING: at /home/tkisky/compat-wireless-2012-01-26/drivers/net/wireless/wl12xx/cmd.c:108 wl1271_cmd_send+0x378/0x3d0 [wl12xx]()
> > Modules linked in: wl12xx mac80211 cfg80211 wl12xx_sdio ov5642_camera
> > [<800416f8>] (unwind_backtrace+0x0/0xfc) from [<80064074>] (warn_slowpath_common+0x54/0x64)
> > [<80064074>] (warn_slowpath_common+0x54/0x64) from [<800640a0>] (warn_slowpath_null+0x1c/0x24)
> > [<800640a0>] (warn_slowpath_null+0x1c/0x24) from [<7f09e080>] (wl1271_cmd_send+0x378/0x3d0 [wl12xx])
> > [<7f09e080>] (wl1271_cmd_send+0x378/0x3d0 [wl12xx]) from [<7f09e720>] (wl12xx_cmd_stop_fwlog+0x54/0x80 [wl12xx])
> > [<7f09e720>] (wl12xx_cmd_stop_fwlog+0x54/0x80 [wl12xx]) from [<7f09ce18>] (wl1271_recovery_work+0x220/0x314 [wl12xx])
> > [<7f09ce18>] (wl1271_recovery_work+0x220/0x314 [wl12xx]) from [<80079b90>] (process_one_work+0x10c/0x408)
> > [<80079b90>] (process_one_work+0x10c/0x408) from [<8007a228>] (worker_thread+0x19c/0x470)
> > [<8007a228>] (worker_thread+0x19c/0x470) from [<8008071c>] (kthread+0x8c/0x90)
> > [<8008071c>] (kthread+0x8c/0x90) from [<8003c474>] (kernel_thread_exit+0x0/0x8)
> > ---[ end trace b6d18e2d5294f64d ]---
> > wl12xx: ERROR failed to send stop firmware logger command
> > wl12xx: Hardware recovery in progress. FW ver: Rev 6.3.0.0.77 pc: 0x23923

This tells us where the PC was when the crash happened.  I'll ask our
firmware team to analyze this.


-- 
Cheers,
Luca.

