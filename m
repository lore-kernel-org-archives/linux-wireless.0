Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:60304 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbaEOVvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 17:51:54 -0400
Received: by mail-wi0-f171.google.com with SMTP id hm4so12982wib.4
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 14:51:52 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH rebased 12/15] staging: vt6656: lock changes device_xmit
Date: Thu, 15 May 2014 22:49:21 +0100
Message-Id: <1400190564-5135-12-git-send-email-tvboxspy@gmail.com> (sfid-20140516_002147_892307_8FB3BB8D)
In-Reply-To: <1400190564-5135-1-git-send-email-tvboxspy@gmail.com>
References: <1400190564-5135-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace locks with the spin_lock_irqsave and spin_unlock_irqrestore

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 14e649a..462f95d 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1159,8 +1159,9 @@ static int device_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct vnt_private *pDevice = netdev_priv(dev);
 	struct net_device_stats *stats = &pDevice->stats;
+	unsigned long flags;
 
-	spin_lock_irq(&pDevice->lock);
+	spin_lock_irqsave(&pDevice->lock, flags);
 
 	netif_stop_queue(dev);
 
@@ -1181,7 +1182,7 @@ static int device_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 out:
-	spin_unlock_irq(&pDevice->lock);
+	spin_unlock_irqrestore(&pDevice->lock, flags);
 
 	return NETDEV_TX_OK;
 }
-- 
1.9.1

