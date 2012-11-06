Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4499 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010Ab2KFAWt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:49 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 08/24] brcmfmac: use wait_event_timeout for 8021x
 pending count
Date: Mon, 5 Nov 2012 16:22:16 -0800
Message-ID: <1352161352-30405-9-git-send-email-frankyl@broadcom.com> (sfid-20121106_013116_503447_1157E719)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

brcmf_netdev_wait_pend8021x was polling to see if 8021x data was
already sent. Code was replaced using wait_event_timeout.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    1 +
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   34 +++++++++-----------
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 34bad32..8d4789b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -621,6 +621,7 @@ struct brcmf_pub {
 	struct work_struct multicast_work;
 	u8 macvalue[ETH_ALEN];
 	atomic_t pend_8021x_cnt;
+	wait_queue_head_t pend_8021x_wait;
 #ifdef DEBUG
 	struct dentry *dbgfs_dir;
 #endif
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 9e2451f..0f81f31 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -52,6 +52,7 @@ MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN fullmac driver.");
 MODULE_SUPPORTED_DEVICE("Broadcom 802.11n WLAN fullmac cards");
 MODULE_LICENSE("Dual BSD/GPL");
 
+#define MAX_WAIT_FOR_8021X_TX		50	/* msecs */
 
 /* Error bits */
 int brcmf_msg_level = BRCMF_ERROR_VAL;
@@ -404,9 +405,11 @@ void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success)
 	eh = (struct ethhdr *)(txp->data);
 	type = ntohs(eh->h_proto);
 
-	if (type == ETH_P_PAE)
+	if (type == ETH_P_PAE) {
 		atomic_dec(&drvr->pend_8021x_cnt);
-
+		if (waitqueue_active(&drvr->pend_8021x_wait))
+			wake_up(&drvr->pend_8021x_wait);
+	}
 }
 
 static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *ndev)
@@ -822,6 +825,8 @@ int brcmf_attach(uint bus_hdrlen, struct device *dev)
 
 	INIT_LIST_HEAD(&drvr->bus_if->dcmd_list);
 
+	init_waitqueue_head(&drvr->pend_8021x_wait);
+
 	return ret;
 
 fail:
@@ -924,26 +929,19 @@ static int brcmf_get_pend_8021x_cnt(struct brcmf_pub *drvr)
 	return atomic_read(&drvr->pend_8021x_cnt);
 }
 
-#define MAX_WAIT_FOR_8021X_TX	10
-
 int brcmf_netdev_wait_pend8021x(struct net_device *ndev)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pub *drvr = ifp->drvr;
-	int timeout = 10 * HZ / 1000;
-	int ntimes = MAX_WAIT_FOR_8021X_TX;
-	int pend = brcmf_get_pend_8021x_cnt(drvr);
-
-	while (ntimes && pend) {
-		if (pend) {
-			set_current_state(TASK_INTERRUPTIBLE);
-			schedule_timeout(timeout);
-			set_current_state(TASK_RUNNING);
-			ntimes--;
-		}
-		pend = brcmf_get_pend_8021x_cnt(drvr);
-	}
-	return pend;
+	int err;
+
+	err = wait_event_timeout(drvr->pend_8021x_wait,
+				 !brcmf_get_pend_8021x_cnt(drvr),
+				 msecs_to_jiffies(MAX_WAIT_FOR_8021X_TX));
+
+	WARN_ON(!err);
+
+	return !err;
 }
 
 static void brcmf_driver_init(struct work_struct *work)
-- 
1.7.9.5


