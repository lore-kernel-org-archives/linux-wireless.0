Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vserver.eikelenboom.it ([84.200.39.61]:37477 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaBGAh4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 19:37:56 -0500
Date: Fri, 7 Feb 2014 01:37:50 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Message-ID: <754206689.20140207013750@eikelenboom.it> (sfid-20140207_013824_406824_48DAB83F)
To: Marcel Holtmann <marcel@holtmann.org>, gianluca@sottospazio.it
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<linux-wireless@vger.kernel.org>,
	<linux-bluetooth@vger.kernel.org>, <linux-serial@vger.kernel.org>
Subject: BISECTED Re: 3.14-mw regression:  circular locking dependency (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff81ad6344>] tty_lock_nested+0x44/0xa0
In-Reply-To: <378824645.20140126114721@eikelenboom.it>
References: <378824645.20140126114721@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel / Gianluca,

Bisection points to this commit:

4a2fb3ecc7467c775b154813861f25a0ddc11aa0 is the first bad commit
commit 4a2fb3ecc7467c775b154813861f25a0ddc11aa0
Author: Gianluca Anzolin <gianluca@sottospazio.it>
Date:   Mon Jan 6 21:23:52 2014 +0100

    Bluetooth: Always wait for a connection on RFCOMM open()

    This patch fixes two regressions introduced with the recent rfcomm tty
    rework.

    The current code uses the carrier_raised() method to wait for the
    bluetooth connection when a process opens the tty.

    However processes may open the port with the O_NONBLOCK flag or set the
    CLOCAL termios flag: in these cases the open() syscall returns
    immediately without waiting for the bluetooth connection to
    complete.

    This behaviour confuses userspace which expects an established bluetooth
    connection.

    The patch restores the old behaviour by waiting for the connection in
    rfcomm_dev_activate() and removes carrier_raised() from the tty_port ops.

    As a side effect the new code also fixes the case in which the rfcomm
    tty device is created with the flag RFCOMM_REUSE_DLC: the old code
    didn't call device_move() and ModemManager skipped the detection
    probe. Now device_move() is always called inside rfcomm_dev_activate().

    Signed-off-by: Gianluca Anzolin <gianluca@sottospazio.it>
    Reported-by: Andrey Vihrov <andrey.vihrov@gmail.com>
    Reported-by: Beson Chow <blc+bluez@mail.vanade.com>
    Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

BTW perhaps time to update your tree ?
Bisection took me back to 3.12 like areas .. the risk of bisection failing of other unrelated bugs seems to increase that way



Sunday, January 26, 2014, 11:47:21 AM, you wrote:

> Hi,

> I have got a regression with a 3.14-mw kernel (last commit is 4ba9920e5e9c0e16b5ed24292d45322907bb9035)
> when a script is started that reads from serial over bluetooth, that wasn't in the 3.13 release kernel:


> Jan 26 11:36:10 serveerstertje kernel: [   72.892926]
> Jan 26 11:36:10 serveerstertje kernel: [   72.900249] ======================================================
> Jan 26 11:36:10 serveerstertje kernel: [   72.907697] [ INFO: possible circular locking dependency detected ]
> Jan 26 11:36:10 serveerstertje kernel: [   72.915214] 3.13.0-20140125-mw-pcireset+ #1 Not tainted
> Jan 26 11:36:10 serveerstertje kernel: [   72.922307] -------------------------------------------------------
> Jan 26 11:36:10 serveerstertje kernel: [   72.928315] zabbix_slimmeme/5909 is trying to acquire lock:
> Jan 26 11:36:10 serveerstertje kernel: [   72.934323]  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff81ad6344>] tty_lock_nested+0x44/0xa0
> Jan 26 11:36:10 serveerstertje kernel: [   72.940434] 
> Jan 26 11:36:10 serveerstertje kernel: [   72.940434] but task is already holding lock:
> Jan 26 11:36:10 serveerstertje kernel: [   72.952263]  (&port->mutex){+.+.+.}, at: [<ffffffff81518aa7>] tty_port_open+0x67/0xe0
> Jan 26 11:36:10 serveerstertje kernel: [   72.958292] 
> Jan 26 11:36:10 serveerstertje kernel: [   72.958292] which lock already depends on the new lock.
> Jan 26 11:36:10 serveerstertje kernel: [   72.958292] 
> Jan 26 11:36:10 serveerstertje kernel: [   72.976267] 
> Jan 26 11:36:10 serveerstertje kernel: [   72.976267] the existing dependency chain (in reverse order) is:
> Jan 26 11:36:10 serveerstertje kernel: [   72.988276] 
> Jan 26 11:36:10 serveerstertje kernel: [   72.988276] -> #1 (&port->mutex){+.+.+.}:
> Jan 26 11:36:10 serveerstertje kernel: [   73.000386]        [<ffffffff81102dfd>] lock_acquire+0xcd/0x110
> Jan 26 11:36:10 serveerstertje kernel: [   73.006526]        [<ffffffff81ad3f97>] mutex_lock_nested+0x47/0x560
> Jan 26 11:36:10 serveerstertje kernel: [   73.012612]        [<ffffffff81518aa7>] tty_port_open+0x67/0xe0
> Jan 26 11:36:10 serveerstertje kernel: [   73.018637]        [<ffffffff81aa4356>] rfcomm_tty_open+0x26/0xe0
> Jan 26 11:36:10 serveerstertje kernel: [   73.024674]        [<ffffffff8150fcea>] tty_open+0x16a/0x5c0
> Jan 26 11:36:10 serveerstertje kernel: [   73.030748]        [<ffffffff811b4013>] chrdev_open+0xa3/0x1c0
> Jan 26 11:36:10 serveerstertje kernel: [   73.036833]        [<ffffffff811ad686>] do_dentry_open.isra.16+0x246/0x2f0
> Jan 26 11:36:10 serveerstertje kernel: [   73.043001]        [<ffffffff811ad81d>] finish_open+0x1d/0x30
> Jan 26 11:36:10 serveerstertje kernel: [   73.049106]        [<ffffffff811befae>] do_last+0x7ce/0xdf0
> Jan 26 11:36:10 serveerstertje kernel: [   73.055191]        [<ffffffff811bf68d>] path_openat+0xbd/0x6b0
> Jan 26 11:36:10 serveerstertje kernel: [   73.061211]        [<ffffffff811c004e>] do_filp_open+0x3e/0xa0
> Jan 26 11:36:10 serveerstertje kernel: [   73.067177]        [<ffffffff811aeaec>] do_sys_open+0x13c/0x230
> Jan 26 11:36:10 serveerstertje kernel: [   73.073141]        [<ffffffff811aebfd>] SyS_open+0x1d/0x20
> Jan 26 11:36:10 serveerstertje kernel: [   73.079047]        [<ffffffff81ad6f39>] system_call_fastpath+0x16/0x1b
> Jan 26 11:36:10 serveerstertje kernel: [   73.084962] 
> Jan 26 11:36:10 serveerstertje kernel: [   73.084962] -> #0 (&tty->legacy_mutex){+.+.+.}:
> Jan 26 11:36:10 serveerstertje kernel: [   73.096600]        [<ffffffff8110230b>] __lock_acquire+0x1d4b/0x2220
> Jan 26 11:36:10 serveerstertje kernel: [   73.102559]        [<ffffffff81102dfd>] lock_acquire+0xcd/0x110
> Jan 26 11:36:10 serveerstertje kernel: [   73.108475]        [<ffffffff81ad3f97>] mutex_lock_nested+0x47/0x560
> Jan 26 11:36:10 serveerstertje kernel: [   73.114419]        [<ffffffff81ad6344>] tty_lock_nested+0x44/0xa0
> Jan 26 11:36:10 serveerstertje kernel: [   73.120354]        [<ffffffff81ad63ab>] tty_lock+0xb/0x10
> Jan 26 11:36:10 serveerstertje kernel: [   73.126258]        [<ffffffff81aa4677>] rfcomm_dev_activate+0xb7/0x250
> Jan 26 11:36:10 serveerstertje kernel: [   73.132222]        [<ffffffff81518ad7>] tty_port_open+0x97/0xe0
> Jan 26 11:36:10 serveerstertje kernel: [   73.138195]        [<ffffffff81aa4356>] rfcomm_tty_open+0x26/0xe0
> Jan 26 11:36:10 serveerstertje kernel: [   73.144207]        [<ffffffff8150fcea>] tty_open+0x16a/0x5c0
> Jan 26 11:36:10 serveerstertje kernel: [   73.150164]        [<ffffffff811b4013>] chrdev_open+0xa3/0x1c0
> Jan 26 11:36:10 serveerstertje kernel: [   73.156127]        [<ffffffff811ad686>] do_dentry_open.isra.16+0x246/0x2f0
> Jan 26 11:36:10 serveerstertje kernel: [   73.162070]        [<ffffffff811ad81d>] finish_open+0x1d/0x30
> Jan 26 11:36:10 serveerstertje kernel: [   73.167933]        [<ffffffff811befae>] do_last+0x7ce/0xdf0
> Jan 26 11:36:10 serveerstertje kernel: [   73.173787]        [<ffffffff811bf68d>] path_openat+0xbd/0x6b0
> Jan 26 11:36:10 serveerstertje kernel: [   73.179600]        [<ffffffff811c004e>] do_filp_open+0x3e/0xa0
> Jan 26 11:36:10 serveerstertje kernel: [   73.185302]        [<ffffffff811aeaec>] do_sys_open+0x13c/0x230
> Jan 26 11:36:10 serveerstertje kernel: [   73.190880]        [<ffffffff811aebfd>] SyS_open+0x1d/0x20
> Jan 26 11:36:10 serveerstertje kernel: [   73.196247]        [<ffffffff81ad6f39>] system_call_fastpath+0x16/0x1b
> Jan 26 11:36:10 serveerstertje kernel: [   73.201486] 
> Jan 26 11:36:10 serveerstertje kernel: [   73.201486] other info that might help us debug this:
> Jan 26 11:36:10 serveerstertje kernel: [   73.201486] 
> Jan 26 11:36:10 serveerstertje kernel: [   73.216718]  Possible unsafe locking scenario:
> Jan 26 11:36:10 serveerstertje kernel: [   73.216718] 
> Jan 26 11:36:10 serveerstertje kernel: [   73.226933]        CPU0                    CPU1
> Jan 26 11:36:10 serveerstertje kernel: [   73.231978]        ----                    ----
> Jan 26 11:36:10 serveerstertje kernel: [   73.237001]   lock(&port->mutex);
> Jan 26 11:36:10 serveerstertje kernel: [   73.241994]                                lock(&tty->legacy_mutex);
> Jan 26 11:36:10 serveerstertje kernel: [   73.247043]                                lock(&port->mutex);
> Jan 26 11:36:10 serveerstertje kernel: [   73.251999]   lock(&tty->legacy_mutex);
> Jan 26 11:36:10 serveerstertje kernel: [   73.256902] 
> Jan 26 11:36:10 serveerstertje kernel: [   73.256902]  *** DEADLOCK ***
> Jan 26 11:36:10 serveerstertje kernel: [   73.256902] 
> Jan 26 11:36:10 serveerstertje kernel: [   73.270890] 1 lock held by zabbix_slimmeme/5909:
> Jan 26 11:36:10 serveerstertje kernel: [   73.275398]  #0:  (&port->mutex){+.+.+.}, at: [<ffffffff81518aa7>] tty_port_open+0x67/0xe0
> Jan 26 11:36:10 serveerstertje kernel: [   73.280124] 
> Jan 26 11:36:10 serveerstertje kernel: [   73.280124] stack backtrace:
> Jan 26 11:36:10 serveerstertje kernel: [   73.289130] CPU: 5 PID: 5909 Comm: zabbix_slimmeme Not tainted 3.13.0-20140125-mw-pcireset+ #1
> Jan 26 11:36:10 serveerstertje kernel: [   73.293860] Hardware name: MSI MS-7640/890FXA-GD70 (MS-7640)  , BIOS V1.8B1 09/13/2010
> Jan 26 11:36:10 serveerstertje kernel: [   73.298625]  ffffffff826e2b70 ffff88005858f818 ffffffff81acbcfa ffff880057c72300
> Jan 26 11:36:10 serveerstertje kernel: [   73.303571]  ffffffff826e2b70 ffff88005858f868 ffffffff81ac7011 ffff880057c72300
> Jan 26 11:36:10 serveerstertje kernel: [   73.308511]  ffff880057c72300 ffff88005858f868 ffff880057c72ac0 0000000000000000
> Jan 26 11:36:10 serveerstertje kernel: [   73.313325] Call Trace:
> Jan 26 11:36:10 serveerstertje kernel: [   73.318092]  [<ffffffff81acbcfa>] dump_stack+0x46/0x58
> Jan 26 11:36:10 serveerstertje kernel: [   73.322900]  [<ffffffff81ac7011>] print_circular_bug+0x2f6/0x32a
> Jan 26 11:36:10 serveerstertje kernel: [   73.327723]  [<ffffffff8110230b>] __lock_acquire+0x1d4b/0x2220
> Jan 26 11:36:10 serveerstertje kernel: [   73.332545]  [<ffffffff810fedbd>] ? trace_hardirqs_on+0xd/0x10
> Jan 26 11:36:10 serveerstertje kernel: [   73.337414]  [<ffffffff810e6141>] ? finish_task_switch+0x41/0xf0
> Jan 26 11:36:10 serveerstertje kernel: [   73.342279]  [<ffffffff81ad0244>] ? sleep_on_timeout+0x4/0x20
> Jan 26 11:36:10 serveerstertje kernel: [   73.347128]  [<ffffffff81102dfd>] lock_acquire+0xcd/0x110
> Jan 26 11:36:10 serveerstertje kernel: [   73.351950]  [<ffffffff81ad6344>] ? tty_lock_nested+0x44/0xa0
> Jan 26 11:36:10 serveerstertje kernel: [   73.356792]  [<ffffffff81ad3f97>] mutex_lock_nested+0x47/0x560
> Jan 26 11:36:10 serveerstertje kernel: [   73.361599]  [<ffffffff81ad6344>] ? tty_lock_nested+0x44/0xa0
> Jan 26 11:36:10 serveerstertje kernel: [   73.366363]  [<ffffffff810fec6b>] ? trace_hardirqs_on_caller+0xfb/0x240
> Jan 26 11:36:10 serveerstertje kernel: [   73.371200]  [<ffffffff810fedbd>] ? trace_hardirqs_on+0xd/0x10
> Jan 26 11:36:10 serveerstertje kernel: [   73.376030]  [<ffffffff81ad6344>] tty_lock_nested+0x44/0xa0
> Jan 26 11:36:10 serveerstertje kernel: [   73.380842]  [<ffffffff81ad63ab>] tty_lock+0xb/0x10
> Jan 26 11:36:10 serveerstertje kernel: [   73.385616]  [<ffffffff81aa4677>] rfcomm_dev_activate+0xb7/0x250
> Jan 26 11:36:10 serveerstertje kernel: [   73.390398]  [<ffffffff81ad4287>] ? mutex_lock_nested+0x337/0x560
> Jan 26 11:36:10 serveerstertje kernel: [   73.395154]  [<ffffffff810f90f0>] ? __init_waitqueue_head+0x60/0x60
> Jan 26 11:36:10 serveerstertje kernel: [   73.399861]  [<ffffffff81518ad7>] tty_port_open+0x97/0xe0
> Jan 26 11:36:10 serveerstertje kernel: [   73.404552]  [<ffffffff81aa4356>] rfcomm_tty_open+0x26/0xe0
> Jan 26 11:36:10 serveerstertje kernel: [   73.409263]  [<ffffffff8150fcea>] tty_open+0x16a/0x5c0
> Jan 26 11:36:10 serveerstertje kernel: [   73.413954]  [<ffffffff811b4013>] chrdev_open+0xa3/0x1c0
> Jan 26 11:36:10 serveerstertje kernel: [   73.418657]  [<ffffffff81457bfd>] ? lockref_get+0x1d/0x30
> Jan 26 11:36:10 serveerstertje kernel: [   73.423379]  [<ffffffff811b3f70>] ? cdev_put+0x30/0x30
> Jan 26 11:36:10 serveerstertje kernel: [   73.428056]  [<ffffffff811ad686>] do_dentry_open.isra.16+0x246/0x2f0
> Jan 26 11:36:10 serveerstertje kernel: [   73.432768]  [<ffffffff811ad81d>] finish_open+0x1d/0x30
> Jan 26 11:36:10 serveerstertje kernel: [   73.437464]  [<ffffffff811befae>] do_last+0x7ce/0xdf0
> Jan 26 11:36:10 serveerstertje kernel: [   73.442166]  [<ffffffff811baff3>] ? inode_permission+0x13/0x50
> Jan 26 11:36:10 serveerstertje kernel: [   73.446861]  [<ffffffff811bb5ce>] ? link_path_walk+0x21e/0x880
> Jan 26 11:36:10 serveerstertje kernel: [   73.451533]  [<ffffffff810fec6b>] ? trace_hardirqs_on_caller+0xfb/0x240
> Jan 26 11:36:10 serveerstertje kernel: [   73.456280]  [<ffffffff811bf68d>] path_openat+0xbd/0x6b0
> Jan 26 11:36:10 serveerstertje kernel: [   73.461029]  [<ffffffff8104cb03>] ? __do_page_fault+0x103/0x4e0
> Jan 26 11:36:10 serveerstertje kernel: [   73.465782]  [<ffffffff81102e1d>] ? lock_acquire+0xed/0x110
> Jan 26 11:36:10 serveerstertje kernel: [   73.470553]  [<ffffffff811c004e>] do_filp_open+0x3e/0xa0
> Jan 26 11:36:10 serveerstertje kernel: [   73.475321]  [<ffffffff811cda31>] ? __alloc_fd+0xd1/0x120
> Jan 26 11:36:10 serveerstertje kernel: [   73.480064]  [<ffffffff811aeaec>] do_sys_open+0x13c/0x230
> Jan 26 11:36:10 serveerstertje kernel: [   73.484743]  [<ffffffff810fec6b>] ? trace_hardirqs_on_caller+0xfb/0x240
> Jan 26 11:36:10 serveerstertje kernel: [   73.489470]  [<ffffffff811aebfd>] SyS_open+0x1d/0x20
> Jan 26 11:36:10 serveerstertje kernel: [   73.494191]  [<ffffffff81ad6f39>] system_call_fastpath+0x16/0x1b



-- 
Best regards,
 Sander                            mailto:linux@eikelenboom.it

