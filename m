Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11264 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2FXQGc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jun 2012 12:06:32 -0400
Date: Sun, 24 Jun 2012 11:06:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: iivanich@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix IRQ disabled warning
Message-ID: <4fe73b05.hCQftM+/T3aH73rp%Larry.Finger@lwfinger.net> (sfid-20120624_180636_377673_A1856EF0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The PCI-based drivers can generate the following warning:

[ 9497.776350] ------------[ cut here ]------------
[ 9497.776366] WARNING: at kernel/softirq.c:159 local_bh_enable_ip+0x7a/0xa0()
[ 9497.776370] Hardware name: 05794NC
[ 9497.776597] Pid: 6413, comm: hostapd Not tainted 3.3.0-4.fc16.x86_64 #1
[ 9497.776601] Call Trace:
[ 9497.776612]  [<ffffffff81057b1f>] warn_slowpath_common+0x7f/0xc0
[ 9497.776633]  [<ffffffffa034a099>] ? rtl_pci_reset_trx_ring+0x199/0x230
[rtlwifi]
[ 9497.776640]  [<ffffffff81057b7a>] warn_slowpath_null+0x1a/0x20
[ 9497.776646]  [<ffffffff8105f06a>] local_bh_enable_ip+0x7a/0xa0
[ 9497.776654]  [<ffffffff815f3ef6>] _raw_spin_unlock_bh+0x16/0x20
[ 9497.776671]  [<ffffffffa03e50de>] destroy_conntrack+0x9e/0x120
[nf_conntrack]
[ 9497.776681]  [<ffffffff81511847>] nf_conntrack_destroy+0x17/0x20
[ 9497.776689]  [<ffffffff814d9c85>] skb_release_head_state+0xe5/0x120
[ 9497.776695]  [<ffffffff814d98b6>] __kfree_skb+0x16/0xa0
[ 9497.776700]  [<ffffffff814d9a35>] kfree_skb+0x45/0xc0
[ 9497.776717]  [<ffffffffa034a099>] rtl_pci_reset_trx_ring+0x199/0x230
[rtlwifi]
[ 9497.776734]  [<ffffffffa034a155>] rtl_pci_start+0x25/0x1d0 [rtlwifi]
[ 9497.776750]  [<ffffffffa03440b5>] rtl_op_start+0x55/0x90 [rtlwifi]
[ 9497.776785]  [<ffffffffa02c4956>] ieee80211_do_open+0x296/0xa10 [mac80211]
[ 9497.776794]  [<ffffffff815f7ddd>] ? notifier_call_chain+0x4d/0x70
[ 9497.776828]  [<ffffffffa02c513d>] ieee80211_open+0x6d/0x80 [mac80211]
[ 9497.776836]  [<ffffffff814e8b3f>] __dev_open+0x8f/0xe0
[ 9497.776842]  [<ffffffff814e8de1>] __dev_change_flags+0xa1/0x180
[ 9497.776847]  [<ffffffff814e8f78>] dev_change_flags+0x28/0x70
[ 9497.776856]  [<ffffffff8154e99d>] devinet_ioctl+0x61d/0x7b0
[ 9497.776863]  [<ffffffff8154ef55>] inet_ioctl+0x75/0x90
[ 9497.776870]  [<ffffffff814cdd50>] sock_do_ioctl+0x30/0x70
[ 9497.776876]  [<ffffffff814cee09>] sock_ioctl+0x79/0x2f0
[ 9497.776885]  [<ffffffff81193498>] do_vfs_ioctl+0x98/0x550
[ 9497.776891]  [<ffffffff811939e1>] sys_ioctl+0x91/0xa0
[ 9497.776897]  [<ffffffff815fc029>] system_call_fastpath+0x16/0x1b
[ 9497.776902] ---[ end trace 22886c442489082d ]---

The cause is due to calling kfree_skb() with interrupts disabled.

This bug is discussed in https://bugzilla.redhat.com/show_bug.cgi?id=797709.

Reported-and-Tested by: Ivan Ivanovich <iivanich@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

Although this bug has been in rtlwifi from the beginning, it only seems to
be active when the device is used as an AP. I thought about adding Stable
to the Cc list, but changed my mind. Please push this for 3.6.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/pci.c
@@ -1273,17 +1273,18 @@ int rtl_pci_reset_trx_ring(struct ieee80
 	 *after reset, release previous pending packet,
 	 *and force the  tx idx to the first one
 	 */
-	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
 	for (i = 0; i < RTL_PCI_MAX_TX_QUEUE_COUNT; i++) {
 		if (rtlpci->tx_ring[i].desc) {
 			struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[i];
 
 			while (skb_queue_len(&ring->queue)) {
-				struct rtl_tx_desc *entry =
-				    &ring->desc[ring->idx];
-				struct sk_buff *skb =
-				    __skb_dequeue(&ring->queue);
+				struct rtl_tx_desc *entry;
+				struct sk_buff *skb;
 
+				spin_lock_irqsave(&rtlpriv->locks.irq_th_lock,
+						  flags);
+				entry = &ring->desc[ring->idx];
+				skb = __skb_dequeue(&ring->queue);
 				pci_unmap_single(rtlpci->pdev,
 						 rtlpriv->cfg->ops->
 							 get_desc((u8 *)
@@ -1291,15 +1292,15 @@ int rtl_pci_reset_trx_ring(struct ieee80
 							 true,
 							 HW_DESC_TXBUFF_ADDR),
 						 skb->len, PCI_DMA_TODEVICE);
-				kfree_skb(skb);
 				ring->idx = (ring->idx + 1) % ring->entries;
+				spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock,
+						  flags);
+				kfree_skb(skb);
 			}
 			ring->idx = 0;
 		}
 	}
 
-	spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
-
 	return 0;
 }
 
