Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:50315 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757477AbZJIUNP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 16:13:15 -0400
Received: from smtp2-g21.free.fr (localhost [127.0.0.1])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 2328B4B006B
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2009 22:12:28 +0200 (CEST)
Received: from [192.168.0.3] (cac94-1-81-57-151-96.fbx.proxad.net [81.57.151.96])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 342DB4B0016
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2009 22:12:26 +0200 (CEST)
Message-ID: <4ACF9929.7060706@free.fr>
Date: Fri, 09 Oct 2009 22:12:25 +0200
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH] airo : allow supend with card without power management
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Some airo card don't support power Management [1].
Don't abort suspend with those cards.


00:06.0 Network controller: AIRONET Wireless Communications PC4800 (rev 01)
        Flags: medium devsel, IRQ 17
        Memory at dffffe00 (32-bit, non-prefetchable) [size=128]
        I/O ports at d000 [size=128]
        I/O ports at cc00 [size=64]
        Kernel driver in use: airo


Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>

Index: linux-2.6/drivers/net/wireless/airo.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/airo.c	2009-10-09 22:06:24.000000000 +0200
+++ linux-2.6/drivers/net/wireless/airo.c	2009-10-09 22:06:38.000000000 +0200
@@ -5660,7 +5660,8 @@
 
 	pci_enable_wake(pdev, pci_choose_state(pdev, state), 1);
 	pci_save_state(pdev);
-	return pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	return 0;
 }
 
 static int airo_pci_resume(struct pci_dev *pdev)

