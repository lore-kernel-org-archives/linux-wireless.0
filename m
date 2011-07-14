Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4281 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932419Ab1GNVaC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 17:30:02 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 18/35] staging: brcm80211: use mutex instead of
 semaphore in dhd_linux.c
Date: Thu, 14 Jul 2011 14:29:14 -0700
Message-ID: <1310678971-28952-19-git-send-email-frankyl@broadcom.com> (sfid-20110714_233028_577269_D10C1376)
In-Reply-To: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The semaphore proto_sem has been replaced with mutex proto_block
which lock certain code paths for one thread.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 6c8599c..310a96f 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -28,6 +28,7 @@
 #include <linux/fcntl.h>
 #include <linux/fs.h>
 #include <linux/uaccess.h>
+#include <linux/mutex.h>
 #include <net/cfg80211.h>
 #include <defs.h>
 #include <brcmu_utils.h>
@@ -73,7 +74,7 @@ struct brcmf_info {
 	/* OS/stack specifics */
 	struct brcmf_if *iflist[BRCMF_MAX_IFS];
 
-	struct semaphore proto_sem;
+	struct mutex proto_block;
 	wait_queue_head_t ioctl_resp_wait;
 
 	/* Thread to issue ioctl for multicast */
@@ -1312,7 +1313,7 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 		goto fail;
 
 	net->netdev_ops = NULL;
-	sema_init(&drvr_priv->proto_sem, 1);
+	mutex_init(&drvr_priv->proto_block);
 	/* Initialize other structure content */
 	init_waitqueue_head(&drvr_priv->ioctl_resp_wait);
 
@@ -1582,7 +1583,7 @@ int brcmf_os_proto_block(struct brcmf_pub *drvr)
 	struct brcmf_info *drvr_priv = drvr->info;
 
 	if (drvr_priv) {
-		down(&drvr_priv->proto_sem);
+		mutex_lock(&drvr_priv->proto_block);
 		return 1;
 	}
 	return 0;
@@ -1593,7 +1594,7 @@ int brcmf_os_proto_unblock(struct brcmf_pub *drvr)
 	struct brcmf_info *drvr_priv = drvr->info;
 
 	if (drvr_priv) {
-		up(&drvr_priv->proto_sem);
+		mutex_unlock(&drvr_priv->proto_block);
 		return 1;
 	}
 
-- 
1.7.1


