Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1762 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab1HHN7d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:33 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 19/82] staging: brcm80211: use mutex instead of
 semaphore in dhd_linux.c
Date: Mon, 8 Aug 2011 15:58:03 +0200
Message-ID: <1312811946-16713-20-git-send-email-arend@broadcom.com> (sfid-20110808_155950_961994_0765FB94)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The semaphore proto_sem has been replaced with mutex proto_block
which lock certain code paths for one thread.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 05dada9..4ba9d7d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -28,8 +28,8 @@
 #include <linux/fcntl.h>
 #include <linux/fs.h>
 #include <linux/uaccess.h>
-#include <linux/interrupt.h>
 #include <linux/hardirq.h>
+#include <linux/mutex.h>
 #include <net/cfg80211.h>
 #include <defs.h>
 #include <brcmu_utils.h>
@@ -75,7 +75,7 @@ struct brcmf_info {
 	/* OS/stack specifics */
 	struct brcmf_if *iflist[BRCMF_MAX_IFS];
 
-	struct semaphore proto_sem;
+	struct mutex proto_block;
 	wait_queue_head_t ioctl_resp_wait;
 
 	/* Thread to issue ioctl for multicast */
@@ -1314,7 +1314,7 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 		goto fail;
 
 	net->netdev_ops = NULL;
-	sema_init(&drvr_priv->proto_sem, 1);
+	mutex_init(&drvr_priv->proto_block);
 	/* Initialize other structure content */
 	init_waitqueue_head(&drvr_priv->ioctl_resp_wait);
 
@@ -1584,7 +1584,7 @@ int brcmf_os_proto_block(struct brcmf_pub *drvr)
 	struct brcmf_info *drvr_priv = drvr->info;
 
 	if (drvr_priv) {
-		down(&drvr_priv->proto_sem);
+		mutex_lock(&drvr_priv->proto_block);
 		return 1;
 	}
 	return 0;
@@ -1595,7 +1595,7 @@ int brcmf_os_proto_unblock(struct brcmf_pub *drvr)
 	struct brcmf_info *drvr_priv = drvr->info;
 
 	if (drvr_priv) {
-		up(&drvr_priv->proto_sem);
+		mutex_unlock(&drvr_priv->proto_block);
 		return 1;
 	}
 
-- 
1.7.4.1


