Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:50060 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbZAGAXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 19:23:53 -0500
Received: by ewy10 with SMTP id 10so8751997ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 16:23:51 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: arvidjaar@mail.ru, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH] orinoco: take the driver lock in the rx tasklet
Date: Wed,  7 Jan 2009 00:23:55 +0000
Message-Id: <1231287835-17707-1-git-send-email-kilroyd@googlemail.com> (sfid-20090107_012359_247346_1421ABFF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the warning reproduced below.

We add to rx_list in interrupt context and remove elements in tasklet
context. While removing elements we need to prevent the interrupt
modifying the list.

Note that commit 31afcef385bb8bf528c6fbe05b359af9f456f02a did not
preserve locking semantics on what is now orinoco_rx.

This patch reinstates the locking semantics and ensures it covers
rx_list as well. This leads to additional cleanup required in
free_orinocodev.

[89479.105038] WARNING: at lib/list_debug.c:30 __list_add+0x8f/0xa0()
[89479.105058] list_add corruption. prev->next should be next (dddb3568), but was cbc28978. (prev=dddb3568).
[89479.106002] Pid: 15746, comm: X Not tainted 2.6.28-1avb #26
[89479.106020] Call Trace:
[89479.106062]  [<c011d3b0>] warn_slowpath+0x60/0x80
[89479.106104]  [<c01073d0>] ? native_sched_clock+0x20/0x70
[89479.106194]  [<c013d825>] ? lock_release_holdtime+0x35/0x200
[89479.106218]  [<c018d9f0>] ? __slab_alloc+0x550/0x560
[89479.106254]  [<c02f9c9d>] ? _spin_unlock+0x1d/0x20
[89479.106270]  [<c018d9f0>] ? __slab_alloc+0x550/0x560
[89479.106302]  [<c01ff2a7>] ? delay_tsc+0x17/0x24
[89479.106319]  [<c01ff221>] ? __const_udelay+0x21/0x30
[89479.106376]  [<dfa8b1e2>] ? hermes_bap_seek+0x112/0x1e0 [hermes]
[89479.106396]  [<c013d7eb>] ? trace_hardirqs_off+0xb/0x10
[89479.106418]  [<c018e307>] ? __kmalloc_track_caller+0xb7/0x110
[89479.106448]  [<c028eefc>] ? dev_alloc_skb+0x1c/0x30
[89479.106465]  [<c028eefc>] ? dev_alloc_skb+0x1c/0x30
[89479.106482]  [<c020e13f>] __list_add+0x8f/0xa0
[89479.106551]  [<dfd0fcae>] orinoco_interrupt+0xcae/0x16c0 [orinoco]
[89479.106574]  [<c013b0e3>] ? tick_dev_program_event+0x33/0xb0
[89479.106594]  [<c01073d0>] ? native_sched_clock+0x20/0x70
[89479.106613]  [<c013d825>] ? lock_release_holdtime+0x35/0x200
[89479.106662]  [<c013d7eb>] ? trace_hardirqs_off+0xb/0x10
[89479.106892]  [<dfe7faa7>] ? usb_hcd_irq+0x97/0xa0 [usbcore]
[89479.106926]  [<c015ba79>] handle_IRQ_event+0x29/0x60
[89479.106947]  [<c015cf89>] handle_level_irq+0x69/0xe0
[89479.106963]  [<c015cf20>] ? handle_level_irq+0x0/0xe0
[89479.106977]  <IRQ>  [<c02ca933>] ? tcp_v4_rcv+0x633/0x6e0
[89479.107025]  [<c0103f0c>] ? common_interrupt+0x28/0x30
[89479.107057]  [<c02a0000>] ? sk_run_filter+0x320/0x7a0
[89479.107078]  [<c020e041>] ? list_del+0x21/0x90
[89479.107106]  [<dfd0d24e>] ? orinoco_rx_isr_tasklet+0x2ce/0x480 [orinoco]
[89479.107131]  [<c01402e0>] ? __lock_acquire+0x160/0x1650
[89479.107151]  [<c01073d0>] ? native_sched_clock+0x20/0x70
[89479.107169]  [<c013d825>] ? lock_release_holdtime+0x35/0x200
[89479.107200]  [<c012249a>] ? irq_enter+0xa/0x60
[89479.107217]  [<c0104e52>] ? do_IRQ+0xd2/0x130
[89479.107518]  [<c010342c>] ? restore_nocheck_notrace+0x0/0xe
[89479.107542]  [<c0122830>] ? __do_softirq+0x0/0x110
[89479.107561]  [<c013f7b4>] ? trace_hardirqs_on_caller+0x74/0x140
[89479.107583]  [<c01ff678>] ? trace_hardirqs_on_thunk+0xc/0x10
[89479.107602]  [<c0122087>] ? tasklet_action+0x27/0x90
[89479.107620]  [<c013f7b4>] ? trace_hardirqs_on_caller+0x74/0x140
[89479.107638]  [<c01220a3>] ? tasklet_action+0x43/0x90
[89479.107655]  [<c012289f>] ? __do_softirq+0x6f/0x110
[89479.107674]  [<c0122830>] ? __do_softirq+0x0/0x110
[89479.107685]  <IRQ>  [<c015cf20>] ? handle_level_irq+0x0/0xe0
[89479.107715]  [<c012246d>] ? irq_exit+0x5d/0x80
[89479.107732]  [<c0104e52>] ? do_IRQ+0xd2/0x130
[89479.107747]  [<c0103337>] ? sysenter_exit+0xf/0x16
[89479.107765]  [<c013f83d>] ? trace_hardirqs_on_caller+0xfd/0x140
[89479.107782]  [<c0103f0c>] ? common_interrupt+0x28/0x30
[89479.107797] ---[ end trace a1fc0a52df4a729d ]---

Reported-by: Andrey Borzenkov <arvidjaar@mail.ru>
Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---

John, this is a regression to 2.6.27. I guess it should go into 2.6.29,
and possibly stable.

The latter case requires at least a path munge
s?wireless/orinoco?wireless/? to apply. I can roll a separate patch for
stable if necessary.


Dave.
---
 drivers/net/wireless/orinoco/orinoco.c |   28 +++++++++++++++++++++++++---
 1 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco.c b/drivers/net/wireless/orinoco/orinoco.c
index b33e13f..2b7e2e9 100644
--- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/orinoco.c
@@ -1613,6 +1613,16 @@ static void orinoco_rx_isr_tasklet(unsigned long data)
 	struct orinoco_rx_data *rx_data, *temp;
 	struct hermes_rx_descriptor *desc;
 	struct sk_buff *skb;
+	unsigned long flags;
+
+	/* orinoco_rx requires the driver lock, and we also need to
+	 * protect priv->rx_list, so just hold the lock over the
+	 * lot.
+	 *
+	 * If orinoco_lock fails, we've unplugged the card. In this
+	 * case just abort. */
+	if (orinoco_lock(priv, &flags) != 0)
+		return;
 
 	/* extract desc and skb from queue */
 	list_for_each_entry_safe(rx_data, temp, &priv->rx_list, list) {
@@ -1625,6 +1635,8 @@ static void orinoco_rx_isr_tasklet(unsigned long data)
 
 		kfree(desc);
 	}
+
+	orinoco_unlock(priv, &flags);
 }
 
 /********************************************************************/
@@ -3649,12 +3661,22 @@ struct net_device
 void free_orinocodev(struct net_device *dev)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
+	struct orinoco_rx_data *rx_data, *temp;
 
-	/* No need to empty priv->rx_list: if the tasklet is scheduled
-	 * when we call tasklet_kill it will run one final time,
-	 * emptying the list */
+	/* If the tasklet is scheduled when we call tasklet_kill it
+	 * will run one final time. However the tasklet will only
+	 * drain priv->rx_list if the hw is still available. */
 	tasklet_kill(&priv->rx_tasklet);
 
+	/* Explicitly drain priv->rx_list */
+	list_for_each_entry_safe(rx_data, temp, &priv->rx_list, list) {
+		list_del(&rx_data->list);
+
+		dev_kfree_skb(rx_data->skb);
+		kfree(rx_data->desc);
+		kfree(rx_data);
+	}
+
 	unregister_pm_notifier(&priv->pm_notifier);
 	orinoco_uncache_fw(priv);
 
-- 
1.6.0.6

