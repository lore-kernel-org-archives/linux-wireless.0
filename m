Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55969 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758573Ab1KVWAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 17:00:30 -0500
Date: Tue, 22 Nov 2011 16:49:40 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Amir Hedayaty <hedayaty@gmail.com>
Subject: Re: [PATCH] rt2800pci: handle spurious interrupts
Message-ID: <20111122214940.GH8452@tuxdriver.com> (sfid-20111122_230046_442208_11A45C54)
References: <20111116100915.GA2191@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111116100915.GA2191@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 16, 2011 at 11:09:17AM +0100, Stanislaw Gruszka wrote:
> Some devices may generate spurious interrupts, we have to handle them
> otherwise interrupt line will be disabled with below message and driver
> will not work:
> 
> [ 2052.114334] irq 17: nobody cared (try booting with the "irqpoll" option)
> [ 2052.114339] Pid: 0, comm: swapper Tainted: P           2.6.35.6-48.fc14.x86_64 #1
> [ 2052.114341] Call Trace:
> [ 2052.114342]  <IRQ>  [<ffffffff810a6e2b>] __report_bad_irq.clone.1+0x3d/0x8b
> [ 2052.114349]  [<ffffffff810a6f93>] note_interrupt+0x11a/0x17f
> [ 2052.114352]  [<ffffffff810a7a73>] handle_fasteoi_irq+0xa8/0xce
> [ 2052.114355]  [<ffffffff8100c2ea>] handle_irq+0x88/0x90
> [ 2052.114357]  [<ffffffff8146f034>] do_IRQ+0x5c/0xb4
> [ 2052.114360]  [<ffffffff81469593>] ret_from_intr+0x0/0x11
> [ 2052.114361]  <EOI>  [<ffffffff8102b7f9>] ? native_safe_halt+0xb/0xd
> [ 2052.114366]  [<ffffffff81010f03>] ? need_resched+0x23/0x2d
> [ 2052.114367]  [<ffffffff8101102a>] default_idle+0x34/0x4f
> [ 2052.114370]  [<ffffffff81008325>] cpu_idle+0xaa/0xcc
> [ 2052.114373]  [<ffffffff81461f2a>] start_secondary+0x24d/0x28e
> [ 2052.114374] handlers:
> [ 2052.114375] [<ffffffff81332944>] (usb_hcd_irq+0x0/0x7c)
> [ 2052.114378] [<ffffffffa00697da>] (rt2800pci_interrupt+0x0/0x18d [rt2800pci])
> [ 2052.114384] Disabling IRQ #17
> 
> Resolve:
> https://bugzilla.redhat.com/show_bug.cgi?id=658451
> 
> Reported-and-tested-by: Amir Hedayaty <hedayaty@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

I trust that you saw the comments in the other thread.  I have reverted
this patch and the related rt2x00 one.

Perhaps there is some way to convince the hardware not to generate
spurious interrupts?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
