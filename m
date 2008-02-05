Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59501 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756423AbYBEV4D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 16:56:03 -0500
Date: Tue, 5 Feb 2008 13:55:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-wireless@vger.kernel.org
Cc: bugme-daemon@bugzilla.kernel.org, patrick.matthaei@web.de,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [Bugme-new] [Bug 9895] New: ssb module segfaults on starting
 the system
Message-Id: <20080205135523.25d1eee8.akpm@linux-foundation.org> (sfid-20080205_215610_759110_B8A841F2)
In-Reply-To: <bug-9895-10286@http.bugzilla.kernel.org/>
References: <bug-9895-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue,  5 Feb 2008 13:42:18 -0800 (PST)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=9895
> 
>            Summary: ssb module segfaults on starting the system
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.24
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: blocking
>           Priority: P1
>          Component: Other
>         AssignedTo: drivers_other@kernel-bugs.osdl.org
>         ReportedBy: patrick.matthaei@web.de
> 
> 
> Latest working kernel version: 2.6.23 (ssb wasn't included)
> Earliest failing kernel version: 2.6.24
> Distribution: Debian Sid
> Hardware Environment: HP Compaq 6715s Notebook
> Problem Description:
> Since kernel 2.6.24, this ssb module has been added and I can't deselect it,
> because it's needed for the wireless b43 driver.
> 
> On starting the kernel, I get following:
> 
> WARNING: at drivers/ssb/main.c:883 ssb_tmslow_reject_bitmask()
> Pid: 1537, comm: modprobe Not tainted 2.6.24-gnu #1
>  [<f89a07ee>] ssb_tmslow_reject_bitmask+0x4b/0x56 [ssb]
>  [<f89a0ee2>] ssb_device_is_enabled+0x9/0x2d [ssb]
>  [<f89a2965>] ssb_pcicore_init+0x11/0x35 [ssb]
>  [<f89a0596>] ssb_attach_queued_buses+0x8a/0x297 [ssb]
>  [<f89a2174>] ssb_pci_xtal+0x1ce/0x1ea [ssb]
>  [<f89a0aec>] ssb_bus_register+0x120/0x185 [ssb]
>  [<f89a1aaa>] ssb_pci_get_invariants+0x0/0x281 [ssb]
>  [<f89a0bb0>] ssb_bus_pcibus_register+0x24/0x47 [ssb]
>  [<c01b8826>] pci_set_master+0x54/0x58
>  [<f89a2299>] ssb_pcihost_probe+0x5e/0x89 [ssb]
>  [<c01ba0cf>] pci_device_probe+0x36/0x55
>  [<c01f526a>] driver_probe_device+0xc5/0x148
>  [<c025cf59>] klist_next+0x58/0x6d
>  [<c01f53c8>] __driver_attach+0x49/0x7f
>  [<c01f485c>] bus_for_each_dev+0x35/0x57
>  [<c01f50de>] driver_attach+0x16/0x18
>  [<c01f537f>] __driver_attach+0x0/0x7f
>  [<c01f4b45>] bus_add_driver+0x6d/0x17d
>  [<c01ba219>] __pci_register_driver+0x55/0x81
>  [<f8836040>] ssb_modinit+0x40/0x56 [ssb]
>  [<c01344ea>] blocking_notifier_call_chain+0x17/0x1a
>  [<c013e6ce>] sys_init_module+0x1690/0x1746
>  [<c0103f3e>] syscall_call+0x7/0xb
>  =======================
> ssb: Sonics Silicon Backplane found on PCI device 0000:30:00.0
> 
> I will upload my whole dmesg.
> 
> 
> Steps to reproduce:
> Just starting my system.

