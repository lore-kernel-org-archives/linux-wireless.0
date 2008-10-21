Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318AbYJUSYH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 14:24:07 -0400
Date: Tue, 21 Oct 2008 11:23:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org
Cc: bugme-daemon@bugzilla.kernel.org, sean@mess.org
Subject: Re: [Bugme-new] [Bug 11782] New: p54 misbehaves when firmware can't
 be found
Message-Id: <20081021112313.0885a745.akpm@linux-foundation.org> (sfid-20081021_202411_705496_B17C2BE0)
In-Reply-To: <bug-11782-10286@http.bugzilla.kernel.org/>
References: <bug-11782-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Sat, 18 Oct 2008 09:13:00 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11782
> 
>            Summary: p54 misbehaves when firmware can't be found
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.27-git8
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: low
>           Priority: P1
>          Component: network-wireless
>         AssignedTo: drivers_network-wireless@kernel-bugs.osdl.org
>         ReportedBy: sean@mess.org
> 
> 
> Latest working kernel version: 2.6.26

A regression.

> Earliest failing kernel version: ?
> Distribution: Ubuntu 8.04
> Hardware Environment: AMD Elan (TS-5500)
> Software Environment: 
> Problem Description:
> 
> When firmware can't be found free_irq complains.
> 
> Steps to reproduce:
> Ensure the firmware is not available in /lib/firmware/$(uname -r)/
> 
> p54pci 0000:01:00.0: enabling device (0000 -> 0002)
> p54pci 0000:01:00.0: setting latency timer to 64
> p54pci 0000:01:00.0: firmware: requesting isl3886
> 0000:01:00.0 (p54pci): cannot find firmware (isl3886)
> phy0: device does not respond!
> Trying to free already-free IRQ 10
> Pid: 108, comm: pccardd Not tainted 2.6.27-05577-g0cfd810-dirty #1
> Call Trace:
>  [<c01265dc>] free_irq+0xad/0xb9
>  [<c01050dd>] dma_generic_alloc_coherent+0x0/0xd7
>  [<c01ba8e6>] p54p_stop+0x4a/0x1fa
>  [<c01050dd>] dma_generic_alloc_coherent+0x0/0xd7
>  [<c02348c5>] p54p_probe+0x23e/0x302
>  [<c0192dd3>] kobject_get+0xf/0x13
>  [<c019cd9f>] pci_device_probe+0x36/0x55
>  [<c01adf86>] driver_probe_device+0x9c/0x112
>  [<c01ad5f2>] bus_for_each_drv+0x34/0x5b
>  [<c01ae0d1>] device_attach+0x4e/0x61
>  [<c01ae063>] __device_attach+0x0/0x5
>  [<c01ad4bc>] bus_attach_device+0x1e/0x46
>  [<c01ac8c8>] device_add+0x2c8/0x3ef
>  [<c0199cd9>] pci_bus_write_config_byte+0x16/0x1e
>  [<c0199e24>] pci_bus_add_device+0xc/0x2c
>  [<c0199e62>] pci_bus_add_devices+0x1e/0x134
>  [<c0232e4a>] cb_alloc+0x92/0xa4
>  [<c01ccee7>] socket_insert+0x80/0xa5
>  [<c01cd347>] pccardd+0x13c/0x1b5
>  [<c01cd20b>] pccardd+0x0/0x1b5
>  [<c011bc3b>] kthread+0x36/0x5b
>  [<c011bc05>] kthread+0x0/0x5b
>  [<c0102dc7>] kernel_thread_helper+0x7/0x10
> p54pci: probe of 0000:01:00.0 failed with error -16
> 

