Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34443 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbeIAODc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Sep 2018 10:03:32 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: sameo@linux.intel.com, davem@davemloft.net, viro@zeniv.linux.org.uk
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: nfc: nci: Fix a sleep-in-atomic-context bug in nci_uart_default_recv_buf()
Date: Sat,  1 Sep 2018 17:51:46 +0800
Message-Id: <20180901095146.15627-1-baijiaju1990@gmail.com> (sfid-20180901_115221_486849_17D2E04F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The kernel module may sleep with holding a spinlock.

The function call paths (from bottom to top) in Linux-4.16 are:

[FUNC] nci_skb_alloc(GFP_KERNEL)
net/nfc/nci/uart.c, 349: 
	nci_skb_alloc in nci_uart_default_recv_buf
net/nfc/nci/uart.c, 255: 
	[FUNC_PTR]nci_uart_default_recv_buf in nci_uart_tty_receive
net/nfc/nci/uart.c, 254: 
	spin_lock in nci_uart_tty_receive

Note that [FUNC_PTR] means a function pointer call is used.

To fix this bug, GFP_KERNEL is replaced with GFP_ATOMIC.

This bug is found by my static analysis tool DSAC.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 net/nfc/nci/uart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/nci/uart.c b/net/nfc/nci/uart.c
index a66f102c6c01..040576dd73bb 100644
--- a/net/nfc/nci/uart.c
+++ b/net/nfc/nci/uart.c
@@ -348,7 +348,7 @@ static int nci_uart_default_recv_buf(struct nci_uart *nu, const u8 *data,
 			nu->rx_packet_len = -1;
 			nu->rx_skb = nci_skb_alloc(nu->ndev,
 						   NCI_MAX_PACKET_SIZE,
-						   GFP_KERNEL);
+						   GFP_ATOMIC);
 			if (!nu->rx_skb)
 				return -ENOMEM;
 		}
-- 
2.17.0
