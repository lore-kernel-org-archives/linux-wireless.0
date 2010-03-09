Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13391 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab0CIIER (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 03:04:17 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] ipw2200: use kmalloc for large local variables
Date: Tue,  9 Mar 2010 16:05:31 +0800
Message-Id: <1268121931-12474-1-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed below compiler warning:

drivers/net/wireless/ipw2x00/ipw2200.c: In function ‘ipw_load_firmware’:
drivers/net/wireless/ipw2x00/ipw2200.c:3260: warning: the frame size of
1168 bytes is larger than 1024 bytes

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/ipw2x00/ipw2200.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 63c2a7a..5c7aa1b 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -3177,14 +3177,27 @@ static int ipw_load_firmware(struct ipw_priv *priv, u8 * data, size_t len)
 	int total_nr = 0;
 	int i;
 	struct pci_pool *pool;
-	u32 *virts[CB_NUMBER_OF_ELEMENTS_SMALL];
-	dma_addr_t phys[CB_NUMBER_OF_ELEMENTS_SMALL];
+	void **virts;
+	dma_addr_t *phys;
 
 	IPW_DEBUG_TRACE("<< : \n");
 
+	virts = kmalloc(sizeof(void *) * CB_NUMBER_OF_ELEMENTS_SMALL,
+			GFP_KERNEL);
+	if (!virts)
+		return -ENOMEM;
+
+	phys = kmalloc(sizeof(dma_addr_t) * CB_NUMBER_OF_ELEMENTS_SMALL,
+			GFP_KERNEL);
+	if (!phys) {
+		kfree(virts);
+		return -ENOMEM;
+	}
 	pool = pci_pool_create("ipw2200", priv->pci_dev, CB_MAX_LENGTH, 0, 0);
 	if (!pool) {
 		IPW_ERROR("pci_pool_create failed\n");
+		kfree(phys);
+		kfree(virts);
 		return -ENOMEM;
 	}
 
@@ -3254,6 +3267,8 @@ static int ipw_load_firmware(struct ipw_priv *priv, u8 * data, size_t len)
 		pci_pool_free(pool, virts[i], phys[i]);
 
 	pci_pool_destroy(pool);
+	kfree(phys);
+	kfree(virts);
 
 	return ret;
 }
-- 
1.6.3.3

