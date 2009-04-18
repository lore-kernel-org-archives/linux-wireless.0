Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48884 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753225AbZDRAKt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 20:10:49 -0400
Message-ID: <49E91A85.8020501@gmx.de> (sfid-20090418_021053_448284_8E94C72F)
Date: Sat, 18 Apr 2009 02:10:45 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [PATCH] mwl8k: fix module re-insertion bug
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

swap mwl8k_remove and mwl8k_shutdown functions to allow
"rmmod mwl8k; modprobe mwl8k"

Signed-off-by: Joerg Albert <jal2@gmx.de>

---

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 57a0268..b5dbf6d 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3720,12 +3720,12 @@ err_free_reg:
         return rc;
  }

-static void __devexit mwl8k_remove(struct pci_dev *pdev)
+static void __devexit mwl8k_shutdown(struct pci_dev *pdev)
  {
         printk(KERN_ERR "===>%s(%u)\n", __func__, __LINE__);
  }

-static void __devexit mwl8k_shutdown(struct pci_dev *pdev)
+static void __devexit mwl8k_remove(struct pci_dev *pdev)
  {
         struct ieee80211_hw *hw = pci_get_drvdata(pdev);
         struct mwl8k_priv *priv;
