Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:53077 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab1CAH1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 02:27:03 -0500
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
To: linux-wireless@vger.kernel.org
Cc: gregkh@suse.de
Subject: [PATCH] staging: rtl8192e: Fix incorrect netif_stop_queue usage warning
Date: Tue,  1 Mar 2011 09:23:12 +0200
Message-Id: <1298964192-13074-1-git-send-email-ozan@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TX queues are allocated inside register_netdev.
It doesn't make any sense to stop the queue before
allocation.

Signed-off-by: Ozan Çağlayan <ozan@pardus.org.tr>
---
 drivers/staging/rtl8192e/r8192E_core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8192e/r8192E_core.c b/drivers/staging/rtl8192e/r8192E_core.c
index fac4eee..08af4fa 100644
--- a/drivers/staging/rtl8192e/r8192E_core.c
+++ b/drivers/staging/rtl8192e/r8192E_core.c
@@ -6006,7 +6006,6 @@ static int __devinit rtl8192_pci_probe(struct pci_dev *pdev,
 	}
 
 	netif_carrier_off(dev);
-	netif_stop_queue(dev);
 
 	register_netdev(dev);
 	RT_TRACE(COMP_INIT, "dev name=======> %s\n",dev->name);
-- 
1.7.3.4

