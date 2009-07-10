Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:1949 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbZGJPJs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 11:09:48 -0400
Subject: Re: PROBLEM: USB wlan device stops working; ehci "kernel BUG"
From: Pavel Roskin <proski@gnu.org>
To: Ian Lynagh <igloo@earth.li>
Cc: dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
In-Reply-To: <20090710143253.GA4133@matrix.chaos.earth.li>
References: <20090710143253.GA4133@matrix.chaos.earth.li>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 10 Jul 2009 11:09:46 -0400
Message-Id: <1247238586.3210.18.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-07-10 at 15:32 +0100, Ian Lynagh wrote:
> Hi all,
> 
> [1.] PROBLEM: USB wlan device stops working; ehci "kernel BUG"
> 
> [2.]
> 
> I am having a problem with an rt73usb and/or ehci. I /think/ the bug is
> in ehci, and the rt73usb problems are just a symptom, but I'm not sure.

Actually, I'm using the current wireless-testing, and I'm getting
following in the kernel log on rt73us unload:

usbcore: deregistering interface driver rt73usb
=============================================================================
BUG kmalloc-16: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff88012d860f88-0xffff88012d860f8b. First byte 0xb instead of 0xcc
INFO: Allocated in rt2x00usb_probe+0xb9/0x180 [rt2x00usb] age=6413897 cpu=1 pid=21955
INFO: Freed in fsnotify_put_event+0x3b/0x70 age=16350710 cpu=3 pid=2508
INFO: Slab 0xffffea00067a6100 objects=46 used=46 fp=0x(null) flags=0x8000000000000083
INFO: Object 0xffff88012d860f78 @offset=3960 fp=0x(null)

Bytes b4 0xffff88012d860f68:  0d 49 0a 00 01 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a .I......ZZZZZZZZ
  Object 0xffff88012d860f78:  00 00 00 00 0c 2c 00 00 86 07 00 00 51 8e 06 00 .....,......Q...
 Redzone 0xffff88012d860f88:  0b ba 0c 00 cc cc cc cc                         .╨..лллл        
 Padding 0xffff88012d860fc8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
Pid: 3978, comm: rmmod Not tainted 2.6.31-rc2-wl #153
Call Trace:
 [<ffffffff810a42a1>] print_trailer+0x101/0x170
 [<ffffffff810a49d2>] check_bytes_and_report+0xf2/0x120
 [<ffffffffa01df098>] ? rt2x00usb_free_reg+0x18/0x60 [rt2x00usb]
 [<ffffffff810a4a65>] check_object+0x65/0x260
 [<ffffffffa01df098>] ? rt2x00usb_free_reg+0x18/0x60 [rt2x00usb]
 [<ffffffff810a5563>] __slab_free+0x203/0x330
 [<ffffffffa01df098>] ? rt2x00usb_free_reg+0x18/0x60 [rt2x00usb]
 [<ffffffff810a6d47>] kfree+0xf7/0x130
 [<ffffffffa01df098>] rt2x00usb_free_reg+0x18/0x60 [rt2x00usb]
 [<ffffffffa01df113>] rt2x00usb_disconnect+0x33/0x70 [rt2x00usb]
 [<ffffffff812b8764>] usb_unbind_interface+0xb4/0x100
 [<ffffffff81255e11>] __device_release_driver+0x61/0xc0
 [<ffffffff81255f30>] driver_detach+0xc0/0xd0
 [<ffffffff81254fa7>] bus_remove_driver+0x97/0xc0
 [<ffffffff812564f9>] driver_unregister+0x59/0x90
 [<ffffffff812b847e>] usb_deregister+0xbe/0xd0
 [<ffffffffa01e7784>] rt73usb_exit+0x10/0x12 [rt73usb]
 [<ffffffff8106f1d5>] sys_delete_module+0x185/0x260
 [<ffffffff8100bd69>] ? retint_swapgs+0xe/0x13
 [<ffffffff81063f15>] ? trace_hardirqs_on_caller+0x145/0x190
 [<ffffffff813c686e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8100b32b>] system_call_fastpath+0x16/0x1b
FIX kmalloc-16: Restoring 0xffff88012d860f88-0xffff88012d860f8b=0xcc

So I think rt73usb is the main suspect.  Before this is fixed, we should
probably not suspect EHCI.

-- 
Regards,
Pavel Roskin
