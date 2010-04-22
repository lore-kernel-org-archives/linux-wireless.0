Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f194.google.com ([209.85.222.194]:37203 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab0DVRw7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 13:52:59 -0400
Received: by pzk32 with SMTP id 32so5663626pzk.21
        for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 10:52:58 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] p54pci: fix regression from prevent stuck rx-ring on slow system
Date: Thu, 22 Apr 2010 19:52:43 +0200
Cc: linville@tuxdriver.com, hdegoede@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201004221952.44071.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hans de Goede <hdegoede@redhat.com>

This patch fixes a recently introduced use-after-free regression
from "p54pci: prevent stuck rx-ring on slow system".

Hans de Goede reported a use-after-free regression:
>BUG: unable to handle kernel paging request at 6b6b6b6b                         
>IP: [<e122284a>] p54p_check_tx_ring+0x84/0xb1 [p54pci]                          
>*pde = 00000000                                                                 
>Oops: 0000 [#1] SMP                                                             
>EIP: 0060:[<e122284a>] EFLAGS: 00010286 CPU: 0                                  
>EIP is at p54p_check_tx_ring+0x84/0xb1 [p54pci]                                 
>EAX: 6b6b6b6b EBX: df10b170 ECX: 00000003 EDX: 00000001                         
>ESI: dc471500 EDI: d8acaeb0 EBP: c098be9c ESP: c098be84                         
> DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068                                   
>Process swapper (pid: 0, ti=c098a000 task=c09ccfe0 task.ti=c098a000)            
>Call Trace:                                                                     
> [<e1222b02>] ? p54p_tasklet+0xaa/0xb5 [p54pci]                                 
> [<c0440568>] ? tasklet_action+0x78/0xcb                                        
> [<c0440ed3>] ? __do_softirq+0xbc/0x173

Quote from comment #17:
"The problem is the innocent looking moving of the tx processing to
 after the rx processing in the tasklet. Quoting from the changelog:
  This patch does it the same way, except that it also prioritize
  rx data processing, simply because tx routines *can* wait.

 This is causing an issue with us referencing already freed memory,
 because some skb's we transmit, we immediately receive back, such
 as those for reading the eeprom (*) and getting stats.

 What can happen because of the moving of the tx processing to after
 the rx processing is that when the tasklet first runs after doing a
 special skb tx (such as eeprom) we've already received the answer
 to it.

 Then the rx processing ends up calling p54_find_and_unlink_skb to
 find the matching tx skb for the just received special rx skb and
 frees the tx skb.

 Then after the processing of the rx skb answer, and thus freeing
 the tx skb, we go process the completed tx ring entires, and then
 dereference the free-ed skb, to see if it should free free-ed by
 p54p_check_tx_ring()."

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=583623
Bug-Identified-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index ca42ccb..07c4528 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -277,6 +277,14 @@ static void p54p_tasklet(unsigned long dev_id)
 	struct p54p_priv *priv = dev->priv;
 	struct p54p_ring_control *ring_control = priv->ring_control;
 
+	p54p_check_tx_ring(dev, &priv->tx_idx_mgmt, 3, ring_control->tx_mgmt,
+			   ARRAY_SIZE(ring_control->tx_mgmt),
+			   priv->tx_buf_mgmt);
+
+	p54p_check_tx_ring(dev, &priv->tx_idx_data, 1, ring_control->tx_data,
+			   ARRAY_SIZE(ring_control->tx_data),
+			   priv->tx_buf_data);
+
 	p54p_check_rx_ring(dev, &priv->rx_idx_mgmt, 2, ring_control->rx_mgmt,
 		ARRAY_SIZE(ring_control->rx_mgmt), priv->rx_buf_mgmt);
 
@@ -285,14 +293,6 @@ static void p54p_tasklet(unsigned long dev_id)
 
 	wmb();
 	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_UPDATE));
-
-	p54p_check_tx_ring(dev, &priv->tx_idx_mgmt, 3, ring_control->tx_mgmt,
-			   ARRAY_SIZE(ring_control->tx_mgmt),
-			   priv->tx_buf_mgmt);
-
-	p54p_check_tx_ring(dev, &priv->tx_idx_data, 1, ring_control->tx_data,
-			   ARRAY_SIZE(ring_control->tx_data),
-			   priv->tx_buf_data);
 }
 
 static irqreturn_t p54p_interrupt(int irq, void *dev_id)
