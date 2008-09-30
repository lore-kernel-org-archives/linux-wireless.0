Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:58458 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbYI3SUF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 14:20:05 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KkjpK-0003PD-NW
	for linux-wireless@vger.kernel.org; Tue, 30 Sep 2008 18:20:02 +0000
Received: from 87.114.24.126.plusnet.thn-ag3.dyn.plus.net ([87.114.24.126])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 30 Sep 2008 18:20:02 +0000
Received: from sitsofe by 87.114.24.126.plusnet.thn-ag3.dyn.plus.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 30 Sep 2008 18:20:02 +0000
To: linux-wireless@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: ath5k tries to free an IRQ that is already-free
Date: Tue, 30 Sep 2008 19:15:14 +0100
Message-ID: <48E26CB2.8000302@yahoo.com> (sfid-20080930_202010_492984_0FD20D60)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-kernel@vger.kernel.org, ath5k-devel@lists.ath5k.org
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In yesterday's linux-tip I was able to provoke this backtrace by 
repeatedly  disabling and enabling the wifi on my EeePC 900:

[  786.455830] uvcvideo 1-8:1.0: no reset_resume for driver uvcvideo?
[  786.455835] uvcvideo 1-8:1.1: no reset_resume for driver uvcvideo?
[  786.458642] uvcvideo: Found UVC 1.00 device CNF7129 (04f2:b071)
[  786.485835] Restarting tasks ... <6>pciehp: Card not present on Slot(3)
[  787.160420] done.
[  787.197658] Trying to free already-free IRQ 18
[  787.197726] Pid: 226, comm: pciehpd Not tainted 
2.6.27-rc7-tipskw-00976-g30d1868-dirty #25
[  787.197733]  [<c01513b6>] free_irq+0xa6/0x130
[  787.197749]  [<c03ceb97>] ath5k_pci_remove+0x77/0xb0
[  787.197759]  [<c021f38e>] pci_device_remove+0x1e/0x40
[  787.197770]  [<c0298f2e>] __device_release_driver+0x5e/0x90
[  787.197780]  [<c0299038>] device_release_driver+0x28/0x40
[  787.197788]  [<c0298585>] bus_remove_device+0x65/0x80
[  787.197796]  [<c0296c21>] device_del+0x101/0x180
[  787.197805]  [<c0296cb0>] device_unregister+0x10/0x20
[  787.197813]  [<c021b88d>] pci_stop_dev+0x3d/0x50
[  787.197820]  [<c021b960>] pci_remove_bus_device+0x30/0xa0
[  787.197829]  [<c02287b9>] pciehp_unconfigure_device+0x99/0x190
[  787.197840]  [<c022744e>] pciehp_disable_slot+0x5e/0x240
[  787.197848]  [<c014a92b>] ? trace_hardirqs_on+0xb/0x10
[  787.197858]  [<c02279d8>] pciehp_power_thread+0x88/0xe0
[  787.197867]  [<c0136ac4>] ? run_workqueue+0xd4/0x1e0
[  787.197877]  [<c0136ac4>] ? run_workqueue+0xd4/0x1e0
[  787.197886]  [<c0136b26>] run_workqueue+0x136/0x1e0
[  787.197894]  [<c0136ac4>] ? run_workqueue+0xd4/0x1e0
[  787.197902]  [<c0227950>] ? pciehp_power_thread+0x0/0xe0
[  787.197912]  [<c013744b>] worker_thread+0x9b/0xf0
[  787.197920]  [<c013a390>] ? autoremove_wake_function+0x0/0x50
[  787.197930]  [<c01373b0>] ? worker_thread+0x0/0xf0
[  787.197939]  [<c0139fe6>] kthread+0x46/0x80
[  787.197947]  [<c0139fa0>] ? kthread+0x0/0x80
[  787.197955]  [<c010407b>] kernel_thread_helper+0x7/0x10
[  787.197966]  =======================

-- 
Sitsofe | http://sucs.org/~sits/

