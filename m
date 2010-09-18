Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:32567 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082Ab0IRBpn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 21:45:43 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 18:45:36 -0700
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <vmehta@atheros.com>,
	<devel@driverdev.osuosl.org>, <randy.dunlap@oracle.com>
Subject: [PATCH] staging: ath6kl: Fixing the driver to use modified mmc_host structure
Date: Fri, 17 Sep 2010 18:45:38 -0700
Message-ID: <1284774338-16285-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A recent change in the mmc_host structure removed the distinction
between hw and phys segments (58cb50c20fde6059f3f8db4466a1bd4d1fff999c)
Changing the driver to use the modified structure.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Vipin Mehta <vmehta@atheros.com>
---
 .../ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c   |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
index 22c6c66..ee8b477 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
@@ -285,9 +285,9 @@ A_STATUS SetupHIFScatterSupport(HIF_DEVICE *device, HIF_DEVICE_SCATTER_SUPPORT_I
     do {
         
             /* check if host supports scatter requests and it meets our requirements */
-        if (device->func->card->host->max_hw_segs < MAX_SCATTER_ENTRIES_PER_REQ) {
+        if (device->func->card->host->max_segs < MAX_SCATTER_ENTRIES_PER_REQ) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("HIF-SCATTER : host only supports scatter of : %d entries, need: %d \n",
-                    device->func->card->host->max_hw_segs, MAX_SCATTER_ENTRIES_PER_REQ));
+                    device->func->card->host->max_segs, MAX_SCATTER_ENTRIES_PER_REQ));
             status = A_ENOTSUP;
             break;    
         }
-- 
1.6.3.3

