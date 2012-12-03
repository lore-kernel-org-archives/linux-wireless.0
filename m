Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zmc.proxad.net ([212.27.53.206]:37578 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366Ab2LCP6d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 10:58:33 -0500
From: Florian Fainelli <ffainelli@freebox.fr>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, buytenh@wantstofly.org,
	Florian Fainelli <ffainelli@freebox.fr>
Subject: [PATCH] mwl8k: remove useless pci shutdown callback and stray debugging
Date: Mon,  3 Dec 2012 16:56:34 +0100
Message-Id: <1354550194-19356-1-git-send-email-ffainelli@freebox.fr> (sfid-20121203_165837_528786_1A418429)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes a left over debugging print present in the pci
shutdown callback, since this callback does not do anything useful, get
rid of it entirely.

Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
---
 drivers/net/wireless/mwl8k.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 0cdae66..434d508 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -5873,11 +5873,6 @@ err_disable_device:
 	return rc;
 }
 
-static void __devexit mwl8k_shutdown(struct pci_dev *pdev)
-{
-	printk(KERN_ERR "===>%s(%u)\n", __func__, __LINE__);
-}
-
 static void __devexit mwl8k_remove(struct pci_dev *pdev)
 {
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
@@ -5931,7 +5926,6 @@ static struct pci_driver mwl8k_driver = {
 	.id_table	= mwl8k_pci_id_table,
 	.probe		= mwl8k_probe,
 	.remove		= __devexit_p(mwl8k_remove),
-	.shutdown	= __devexit_p(mwl8k_shutdown),
 };
 
 module_pci_driver(mwl8k_driver);
-- 
1.7.10.4

