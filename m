Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:34606 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974AbXK2PxN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 10:53:13 -0500
Received: from localhost (localhost [127.0.0.1])
	by hiems2.ing.unibs.it (Postfix) with ESMTP id 0863C182553A
	for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2007 16:53:11 +0100 (CET)
Received: from hiems2.ing.unibs.it ([127.0.0.1])
	by localhost (hiems1.ing.unibs.it [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id utcBeklIQFko for <linux-wireless@vger.kernel.org>;
	Thu, 29 Nov 2007 16:53:10 +0100 (CET)
Mime-Version: 1.0 (Apple Message framework v752.3)
Message-Id: <0D869D0B-A5CF-4AE4-B986-DB168917296B@ing.unibs.it> (sfid-20071129_155316_945884_5BB2073C)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
To: linux-wireless@vger.kernel.org
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Subject: ath5k: filter patch
Date: Thu, 29 Nov 2007 16:53:13 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everybody,

I discovered that playing with iface promiscuity to capture traffic  
(including control, promisc and all other stuff) is not working on  
ath5k as rx_filters are never refreshed. To make things going I added  
a single ath5k_hw_set_rx_filters(ah,rfilt) at the end of  
ath5k_configure_filter(). I attach the simple patch. Now tcpdump  
captures everything in monitor mode when iface is set to promisc.

By the way, has someone tried to put ath5k into using RTS/CTS procedure?

Regards,
FG



--- wireless-2.6.old/drivers/net/wireless/ath5k/base.c        
2007-11-29 16:20:27.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/ath5k/base.c       2007-11-29  
16:21:24.000000000 +0100
@@ -2813,6 +2813,9 @@
                 rfilt |= AR5K_RX_FILTER_BEACON;
         }
+        /* Set filters */
+        ath5k_hw_set_rx_filter(ah,rfilt);
+
         /* Set multicast bits */
         ath5k_hw_set_mcast_filter(ah, mfilt[0], mfilt[1]);
         /* Set the cached hw filter flags, this will alter actually


