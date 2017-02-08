Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55586 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753475AbdBHLr2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 06:47:28 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Vishal Thanki <vishalthanki@gmail.com>
Subject: [PATCH 1/2] rt2x00usb: do not anchor rx and tx urb's
Date: Wed,  8 Feb 2017 12:18:09 +0100
Message-Id: <1486552690-27597-1-git-send-email-sgruszka@redhat.com> (sfid-20170208_124733_205071_058D2473)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We might kill TX or RX urb during rt2x00usb_flush_entry(), what can
cause anchor list corruption like shown below:

[ 2074.035633] WARNING: CPU: 2 PID: 14480 at lib/list_debug.c:33 __list_add+0xac/0xc0
[ 2074.035634] list_add corruption. prev->next should be next (ffff88020f362c28), but was dead000000000100. (prev=ffff8801d161bb70).
<snip>
[ 2074.035670] Call Trace:
[ 2074.035672]  [<ffffffff813bde47>] dump_stack+0x63/0x8c
[ 2074.035674]  [<ffffffff810a2231>] __warn+0xd1/0xf0
[ 2074.035676]  [<ffffffff810a22af>] warn_slowpath_fmt+0x5f/0x80
[ 2074.035678]  [<ffffffffa073855d>] ? rt2x00usb_register_write_lock+0x3d/0x60 [rt2800usb]
[ 2074.035679]  [<ffffffff813dbe4c>] __list_add+0xac/0xc0
[ 2074.035681]  [<ffffffff81591c6c>] usb_anchor_urb+0x4c/0xa0
[ 2074.035683]  [<ffffffffa07322af>] rt2x00usb_kick_rx_entry+0xaf/0x100 [rt2x00usb]
[ 2074.035684]  [<ffffffffa0732322>] rt2x00usb_clear_entry+0x22/0x30 [rt2x00usb]

To fix do not anchor TX and RX urb's, it is not needed as during
shutdown we kill those urbs in rt2x00usb_free_entries().

Cc: Vishal Thanki <vishalthanki@gmail.com>
Fixes: 8b4c0009313f ("rt2x00usb: Use usb anchor to manage URB")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index 5a2bf9f..fe13dd0 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -319,10 +319,8 @@ static bool rt2x00usb_kick_tx_entry(struct queue_entry *entry, void *data)
 			  entry->skb->data, length,
 			  rt2x00usb_interrupt_txdone, entry);
 
-	usb_anchor_urb(entry_priv->urb, rt2x00dev->anchor);
 	status = usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
 	if (status) {
-		usb_unanchor_urb(entry_priv->urb);
 		if (status == -ENODEV)
 			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
@@ -410,10 +408,8 @@ static bool rt2x00usb_kick_rx_entry(struct queue_entry *entry, void *data)
 			  entry->skb->data, entry->skb->len,
 			  rt2x00usb_interrupt_rxdone, entry);
 
-	usb_anchor_urb(entry_priv->urb, rt2x00dev->anchor);
 	status = usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
 	if (status) {
-		usb_unanchor_urb(entry_priv->urb);
 		if (status == -ENODEV)
 			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
-- 
1.8.3.1
