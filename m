Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:65414 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041AbYLSPjb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 10:39:31 -0500
Message-ID: <494BC02B.4000906@lwfinger.net> (sfid-20081219_163935_808912_A48970A5)
Date: Fri, 19 Dec 2008 09:39:23 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linville@tuxdriver.com, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Fix some MAC locking
References: <200812182213.39260.mb@bu3sch.de>
In-Reply-To: <200812182213.39260.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> This fixes some locking w.r.t. the lower MAC (firmware).
> It also removes a lot of ancient IRQ-locking that's not needed anymore.
> We simply suspend the MAC. That's easier and causes less trouble.

When booting with this patch and the RFKILL switch off, I got these b43dbg messages:

kernel: b43-phy0 debug: PHY/RADIO register access with enabled MAC.
kernel: Pid: 7, comm: events/0 Not tainted 2.6.28-rc8-wl #55
kernel: Call Trace:
kernel:  [<ffffffffa02d6b15>] b43_phy_read+0x33/0x46 [b43]
kernel:  [<ffffffffa02d8350>] b43_gphy_op_software_rfkill+0xde/0x131 [b43]
kernel:  [<ffffffffa02d66d8>] b43_software_rfkill+0x20/0x2d [b43]
kernel:  [<ffffffffa02e5609>] b43_rfkill_soft_toggle+0x71/0xa8 [b43]
kernel:  [<ffffffffa02c61c0>] rfkill_toggle_radio+0xc6/0x10e [rfkill]
kernel:  [<ffffffffa02c681d>] __rfkill_switch_all+0x6c/0xbb [rfkill]
kernel:  [<ffffffffa02c68e5>] rfkill_switch_all+0x2d/0x3e [rfkill]
kernel:  [<ffffffffa04bc165>] rfkill_task_handler+0x165/0x1ae [rfkill_input]
kernel:  [<ffffffff8024ac90>] run_workqueue+0x103/0x20a
kernel:  [<ffffffff8024ac3e>] ? run_workqueue+0xb1/0x20a
kernel:  [<ffffffffa04bc000>] ? rfkill_task_handler+0x0/0x1ae [rfkill_input]
kernel:  [<ffffffff8024ae77>] worker_thread+0xe0/0xf1
kernel:  [<ffffffff8024e9fc>] ? autoremove_wake_function+0x0/0x38
kernel:  [<ffffffff8024ad97>] ? worker_thread+0x0/0xf1
kernel:  [<ffffffff8024e6a0>] kthread+0x49/0x76
kernel:  [<ffffffff8020d0d9>] child_rip+0xa/0x11
kernel:  [<ffffffff80236bd4>] ? finish_task_switch+0x0/0xb9
kernel:  [<ffffffff8020c5f4>] ? restore_args+0x0/0x30


kernel: b43-phy0 debug: PHY/RADIO register access with enabled MAC.
kernel: Pid: 7, comm: events/0 Not tainted 2.6.28-rc8-wl #55
kernel: Call Trace:
kernel:  [<ffffffffa02d6f93>] ? b43_gphy_op_read+0x2b/0x2f [b43]
kernel:  [<ffffffffa02d6b15>] b43_phy_read+0x33/0x46 [b43]
kernel:  [<ffffffffa02d835f>] b43_gphy_op_software_rfkill+0xed/0x131 [b43]
kernel:  [<ffffffffa02d66d8>] b43_software_rfkill+0x20/0x2d [b43]
...

kernel: b43-phy0 debug: PHY/RADIO register access with enabled MAC.
kernel: Pid: 7, comm: events/0 Not tainted 2.6.28-rc8-wl #55
kernel: Call Trace:
kernel:  [<ffffffffa02d6ac8>] b43_phy_write+0x3c/0x56 [b43]
kernel:  [<ffffffffa02d8384>] b43_gphy_op_software_rfkill+0x112/0x131 [b43]
kernel:  [<ffffffffa02d66d8>] b43_software_rfkill+0x20/0x2d [b43]
...

kernel: b43-phy0 debug: PHY/RADIO register access with enabled MAC.
kernel: Pid: 7, comm: events/0 Not tainted 2.6.28-rc8-wl #55
kernel: Call Trace:
kernel:  [<ffffffffa02d6fc7>] ? b43_gphy_op_write+0x30/0x35 [b43]
kernel:  [<ffffffffa02d6ac8>] b43_phy_write+0x3c/0x56 [b43]
kernel:  [<ffffffffa02d839a>] b43_gphy_op_software_rfkill+0x128/0x131 [b43]
kernel:  [<ffffffffa02d66d8>] b43_software_rfkill+0x20/0x2d [b43]
...

These were on an x86_64 system running wireless testing that git-describe shows
as v2.6.28-rc8-8079-g3af3a24.

Larry
