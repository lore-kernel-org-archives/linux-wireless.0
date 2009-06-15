Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:54288 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760594AbZFOPiK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 11:38:10 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>
Subject: [PATCH 01/12][2.6.31 and w-t] iwmc3200wifi: fix sdio initialisation race
Date: Mon, 15 Jun 2009 17:39:17 +0200
Message-Id: <8843005a4ec0cad33483426a4ecc7656bce24243.1245076752.git.samuel@sortiz.org>
In-Reply-To: <cover.1245076752.git.samuel@sortiz.org>
References: <cover.1245076752.git.samuel@sortiz.org>
In-Reply-To: <cover.1245076752.git.samuel@sortiz.org>
References: <cover.1245076752.git.samuel@sortiz.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

When modprobing this driver, the netdev interface is ready before the SDIO
function is correctly set.
This can lead to userspace calling ndo_open() before the SDIO bus is ready.
We fix that by returning an error from ndo_open() when the
IWM_STATUS_BUS_READY bit is not set yet.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/iwm.h    |   11 ++++++-----
 drivers/net/wireless/iwmc3200wifi/main.c   |    6 +++++-
 drivers/net/wireless/iwmc3200wifi/netdev.c |   10 ++++++----
 drivers/net/wireless/iwmc3200wifi/sdio.c   |    4 ++++
 4 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index 635c16e..3cc4e91 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -180,11 +180,12 @@ struct iwm_key {
 
 #define IWM_SCAN_ID_MAX 0xff
 
-#define IWM_STATUS_READY		0
-#define IWM_STATUS_SCANNING		1
-#define IWM_STATUS_SCAN_ABORTING	2
-#define IWM_STATUS_ASSOCIATING		3
-#define IWM_STATUS_ASSOCIATED		4
+#define IWM_STATUS_BUS_READY		0
+#define IWM_STATUS_READY		1
+#define IWM_STATUS_SCANNING		2
+#define IWM_STATUS_SCAN_ABORTING	3
+#define IWM_STATUS_ASSOCIATING		4
+#define IWM_STATUS_ASSOCIATED		5
 
 #define IWM_RADIO_RFKILL_OFF		0
 #define IWM_RADIO_RFKILL_HW		1
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index 6a2640f..09ed247 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -227,11 +227,15 @@ int iwm_priv_init(struct iwm_priv *iwm)
 void iwm_reset(struct iwm_priv *iwm)
 {
 	struct iwm_notif *notif, *next;
+	unsigned long status = 0;
 
 	if (test_bit(IWM_STATUS_READY, &iwm->status))
 		iwm_target_reset(iwm);
 
-	iwm->status = 0;
+	if (test_bit(IWM_STATUS_BUS_READY, &iwm->status))
+		set_bit(IWM_STATUS_BUS_READY, &status);
+
+	iwm->status = status;
 	iwm->scan_id = 1;
 
 	list_for_each_entry_safe(notif, next, &iwm->pending_notif, pending) {
diff --git a/drivers/net/wireless/iwmc3200wifi/netdev.c b/drivers/net/wireless/iwmc3200wifi/netdev.c
index 68e2c3b..5b7aa34 100644
--- a/drivers/net/wireless/iwmc3200wifi/netdev.c
+++ b/drivers/net/wireless/iwmc3200wifi/netdev.c
@@ -54,9 +54,10 @@
 static int iwm_open(struct net_device *ndev)
 {
 	struct iwm_priv *iwm = ndev_to_iwm(ndev);
-	int ret = 0;
+	int ret = -ENODEV;
 
-	if (!test_bit(IWM_RADIO_RFKILL_SW, &iwm->radio))
+	if (!test_bit(IWM_RADIO_RFKILL_SW, &iwm->radio)
+	    && test_bit(IWM_STATUS_BUS_READY, &iwm->status))
 		ret = iwm_up(iwm);
 
 	return ret;
@@ -65,9 +66,10 @@ static int iwm_open(struct net_device *ndev)
 static int iwm_stop(struct net_device *ndev)
 {
 	struct iwm_priv *iwm = ndev_to_iwm(ndev);
-	int ret = 0;
+	int ret = -ENODEV;
 
-	if (!test_bit(IWM_RADIO_RFKILL_SW, &iwm->radio))
+	if (!test_bit(IWM_RADIO_RFKILL_SW, &iwm->radio)
+	    && test_bit(IWM_STATUS_BUS_READY, &iwm->status))
 		ret = iwm_down(iwm);
 
 	return ret;
diff --git a/drivers/net/wireless/iwmc3200wifi/sdio.c b/drivers/net/wireless/iwmc3200wifi/sdio.c
index b54da67..97e7da3 100644
--- a/drivers/net/wireless/iwmc3200wifi/sdio.c
+++ b/drivers/net/wireless/iwmc3200wifi/sdio.c
@@ -454,6 +454,9 @@ static int iwm_sdio_probe(struct sdio_func *func,
 
 	INIT_WORK(&hw->isr_worker, iwm_sdio_isr_worker);
 
+	/* The SDIO bus is set and ready to be enabled */
+	set_bit(IWM_STATUS_BUS_READY, &iwm->status);
+
 	dev_info(dev, "IWM SDIO probe\n");
 
 	return 0;
@@ -476,6 +479,7 @@ static void iwm_sdio_remove(struct sdio_func *func)
 	destroy_workqueue(hw->isr_wq);
 
 	sdio_set_drvdata(func, NULL);
+	clear_bit(IWM_STATUS_BUS_READY, &iwm->status);
 
 	dev_info(dev, "IWM SDIO remove\n");
 
-- 
1.6.3.1

