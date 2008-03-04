Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935427AbYCDX1o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 18:27:44 -0500
Message-Id: <200803042326.m24NQB9o003295@imap1.linux-foundation.org> (sfid-20080304_232753_096060_16957793)
Subject: [patch 05/10] prism54: convert stats_sem in a mutex
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	matthias@kaehlcke.net, flamingice@sourmilk.net,
	mcgrof@winlab.rutgers.edu
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2008 15:26:10 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matthias Kaehlcke <matthias@kaehlcke.net>

The semaphore stats_sem is used as mutex, convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Michael Wu <flamingice@sourmilk.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/prism54/isl_ioctl.c  |    8 ++++----
 drivers/net/wireless/prism54/islpci_dev.c |    2 +-
 drivers/net/wireless/prism54/islpci_dev.h |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/net/wireless/prism54/isl_ioctl.c~convert-stats_sem-in-a-mutex drivers/net/wireless/prism54/isl_ioctl.c
--- a/drivers/net/wireless/prism54/isl_ioctl.c~convert-stats_sem-in-a-mutex
+++ a/drivers/net/wireless/prism54/isl_ioctl.c
@@ -165,7 +165,7 @@ prism54_update_stats(struct work_struct 
 	struct obj_bss bss, *bss2;
 	union oid_res_t r;
 
-	down(&priv->stats_sem);
+	mutex_lock(&priv->stats_lock);
 
 /* Noise floor.
  * I'm not sure if the unit is dBm.
@@ -207,7 +207,7 @@ prism54_update_stats(struct work_struct 
 	mgt_get_request(priv, DOT11_OID_MPDUTXFAILED, 0, NULL, &r);
 	priv->local_iwstatistics.discard.retries = r.u;
 
-	up(&priv->stats_sem);
+	mutex_unlock(&priv->stats_lock);
 
 	return;
 }
@@ -218,12 +218,12 @@ prism54_get_wireless_stats(struct net_de
 	islpci_private *priv = netdev_priv(ndev);
 
 	/* If the stats are being updated return old data */
-	if (down_trylock(&priv->stats_sem) == 0) {
+	if (mutex_trylock(&priv->stats_lock) == 0) {
 		memcpy(&priv->iwstatistics, &priv->local_iwstatistics,
 		       sizeof (struct iw_statistics));
 		/* They won't be marked updated for the next time */
 		priv->local_iwstatistics.qual.updated = 0;
-		up(&priv->stats_sem);
+		mutex_unlock(&priv->stats_lock);
 	} else
 		priv->iwstatistics.qual.updated = 0;
 
diff -puN drivers/net/wireless/prism54/islpci_dev.c~convert-stats_sem-in-a-mutex drivers/net/wireless/prism54/islpci_dev.c
--- a/drivers/net/wireless/prism54/islpci_dev.c~convert-stats_sem-in-a-mutex
+++ a/drivers/net/wireless/prism54/islpci_dev.c
@@ -864,7 +864,7 @@ islpci_setup(struct pci_dev *pdev)
 	mutex_init(&priv->mgmt_lock);
 	priv->mgmt_received = NULL;
 	init_waitqueue_head(&priv->mgmt_wqueue);
-	sema_init(&priv->stats_sem, 1);
+	mutex_init(&priv->stats_lock);
 	spin_lock_init(&priv->slock);
 
 	/* init state machine with off#1 state */
diff -puN drivers/net/wireless/prism54/islpci_dev.h~convert-stats_sem-in-a-mutex drivers/net/wireless/prism54/islpci_dev.h
--- a/drivers/net/wireless/prism54/islpci_dev.h~convert-stats_sem-in-a-mutex
+++ a/drivers/net/wireless/prism54/islpci_dev.h
@@ -88,7 +88,7 @@ typedef struct {
 
 	/* Take care of the wireless stats */
 	struct work_struct stats_work;
-	struct semaphore stats_sem;
+	struct mutex stats_lock;
 	/* remember when we last updated the stats */
 	unsigned long stats_timestamp;
 	/* The first is accessed under semaphore locking.
_
