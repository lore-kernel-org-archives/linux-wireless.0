Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755447Ab1KPKHp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 05:07:45 -0500
Date: Wed, 16 Nov 2011 11:09:17 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Amir Hedayaty <hedayaty@gmail.com>
Subject: [PATCH] rt2800pci: handle spurious interrupts
Message-ID: <20111116100915.GA2191@redhat.com> (sfid-20111116_110749_087135_329E51A5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some devices may generate spurious interrupts, we have to handle them
otherwise interrupt line will be disabled with below message and driver
will not work:

[ 2052.114334] irq 17: nobody cared (try booting with the "irqpoll" option)
[ 2052.114339] Pid: 0, comm: swapper Tainted: P           2.6.35.6-48.fc14.x86_64 #1
[ 2052.114341] Call Trace:
[ 2052.114342]  <IRQ>  [<ffffffff810a6e2b>] __report_bad_irq.clone.1+0x3d/0x8b
[ 2052.114349]  [<ffffffff810a6f93>] note_interrupt+0x11a/0x17f
[ 2052.114352]  [<ffffffff810a7a73>] handle_fasteoi_irq+0xa8/0xce
[ 2052.114355]  [<ffffffff8100c2ea>] handle_irq+0x88/0x90
[ 2052.114357]  [<ffffffff8146f034>] do_IRQ+0x5c/0xb4
[ 2052.114360]  [<ffffffff81469593>] ret_from_intr+0x0/0x11
[ 2052.114361]  <EOI>  [<ffffffff8102b7f9>] ? native_safe_halt+0xb/0xd
[ 2052.114366]  [<ffffffff81010f03>] ? need_resched+0x23/0x2d
[ 2052.114367]  [<ffffffff8101102a>] default_idle+0x34/0x4f
[ 2052.114370]  [<ffffffff81008325>] cpu_idle+0xaa/0xcc
[ 2052.114373]  [<ffffffff81461f2a>] start_secondary+0x24d/0x28e
[ 2052.114374] handlers:
[ 2052.114375] [<ffffffff81332944>] (usb_hcd_irq+0x0/0x7c)
[ 2052.114378] [<ffffffffa00697da>] (rt2800pci_interrupt+0x0/0x18d [rt2800pci])
[ 2052.114384] Disabling IRQ #17

Resolve:
https://bugzilla.redhat.com/show_bug.cgi?id=658451

Reported-and-tested-by: Amir Hedayaty <hedayaty@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
I changed rt2800pci only because get bug report for that device, not
sure if similar changes are not needed for other rt2x00 PCI devices.

 drivers/net/wireless/rt2x00/rt2800pci.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index da48c8a..4dc2d0f 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -880,8 +880,13 @@ static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
 	rt2x00pci_register_read(rt2x00dev, INT_SOURCE_CSR, &reg);
 	rt2x00pci_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
 
+	/*
+	 * Some devices can generate interrupts with empty CSR register, we
+	 * "handle" such irq's to prevent interrupt controller treat them as
+	 * spurious interrupts and disable irq line.
+	 */
 	if (!reg)
-		return IRQ_NONE;
+		return IRQ_HANDLED;
 
 	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		return IRQ_HANDLED;
-- 
1.7.1

