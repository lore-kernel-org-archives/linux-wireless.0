Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0062.hostedemail.com ([216.40.44.62]:54265 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756103AbaFWNm4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 09:42:56 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 15/22] ipw2100: Use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:43 -0700
Message-Id: <300ca978edde7122af48aae0f6de0d06730c5fbc.1403530604.git.joe@perches.com> (sfid-20140623_154618_604328_0C4B3732)
In-Reply-To: <cover.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ipw2x00/ipw2100.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index dfc6dfc..1ab8e50 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -3449,8 +3449,9 @@ static int ipw2100_msg_allocate(struct ipw2100_priv *priv)
 		return -ENOMEM;
 
 	for (i = 0; i < IPW_COMMAND_POOL_SIZE; i++) {
-		v = pci_alloc_consistent(priv->pci_dev,
-					 sizeof(struct ipw2100_cmd_header), &p);
+		v = pci_zalloc_consistent(priv->pci_dev,
+					  sizeof(struct ipw2100_cmd_header),
+					  &p);
 		if (!v) {
 			printk(KERN_ERR DRV_NAME ": "
 			       "%s: PCI alloc failed for msg "
@@ -3459,8 +3460,6 @@ static int ipw2100_msg_allocate(struct ipw2100_priv *priv)
 			break;
 		}
 
-		memset(v, 0, sizeof(struct ipw2100_cmd_header));
-
 		priv->msg_buffers[i].type = COMMAND;
 		priv->msg_buffers[i].info.c_struct.cmd =
 		    (struct ipw2100_cmd_header *)v;
@@ -4336,16 +4335,12 @@ static int status_queue_allocate(struct ipw2100_priv *priv, int entries)
 	IPW_DEBUG_INFO("enter\n");
 
 	q->size = entries * sizeof(struct ipw2100_status);
-	q->drv =
-	    (struct ipw2100_status *)pci_alloc_consistent(priv->pci_dev,
-							  q->size, &q->nic);
+	q->drv = pci_zalloc_consistent(priv->pci_dev, q->size, &q->nic);
 	if (!q->drv) {
 		IPW_DEBUG_WARNING("Can not allocate status queue.\n");
 		return -ENOMEM;
 	}
 
-	memset(q->drv, 0, q->size);
-
 	IPW_DEBUG_INFO("exit\n");
 
 	return 0;
@@ -4374,13 +4369,12 @@ static int bd_queue_allocate(struct ipw2100_priv *priv,
 
 	q->entries = entries;
 	q->size = entries * sizeof(struct ipw2100_bd);
-	q->drv = pci_alloc_consistent(priv->pci_dev, q->size, &q->nic);
+	q->drv = pci_zalloc_consistent(priv->pci_dev, q->size, &q->nic);
 	if (!q->drv) {
 		IPW_DEBUG_INFO
 		    ("can't allocate shared memory for buffer descriptors\n");
 		return -ENOMEM;
 	}
-	memset(q->drv, 0, q->size);
 
 	IPW_DEBUG_INFO("exit\n");
 
-- 
1.8.1.2.459.gbcd45b4.dirty

