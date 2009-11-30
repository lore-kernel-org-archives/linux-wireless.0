Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:57159 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbZK3RN2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:13:28 -0500
Date: Mon, 30 Nov 2009 18:13:34 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 09/12] mwl8k: don't forget to call pci_disable_device()
Message-ID: <20091130171334.GL20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't forget to call pci_disable_device() if pci_request_regions()
fails during probe.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index b3eba35..5e67ae9 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3378,7 +3378,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	if (rc) {
 		printk(KERN_ERR "%s: Cannot obtain PCI resources\n",
 		       MWL8K_NAME);
-		return rc;
+		goto err_disable_device;
 	}
 
 	pci_set_master(pdev);
@@ -3609,6 +3609,8 @@ err_iounmap:
 
 err_free_reg:
 	pci_release_regions(pdev);
+
+err_disable_device:
 	pci_disable_device(pdev);
 
 	return rc;
-- 
1.5.6.4
