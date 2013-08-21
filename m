Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:44164 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237Ab3HUGeW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 02:34:22 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/3] ath10k: make the workqueue multithreaded
Date: Wed, 21 Aug 2013 08:34:12 +0200
Message-ID: <1377066854-13981-2-git-send-email-michal.kazior@tieto.com> (sfid-20130821_083426_655241_9F57D572)
In-Reply-To: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com>
References: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TX work for a HTC endpoint can run for long
periods of time, especially on slower host
machines when under heavy load.

This patch prevents one endpoint starving another
one by allowing each endpoint worker to be
processed in parallel.

This is safe since none of ar->workqueue users
depend on sequential execution.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    4 +++-
 drivers/net/wireless/ath/ath10k/core.h |    5 +++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 04c132e..a828584 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -520,7 +520,9 @@ struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
 
 	setup_timer(&ar->scan.timeout, ath10k_reset_scan, (unsigned long)ar);
 
-	ar->workqueue = create_singlethread_workqueue("ath10k_wq");
+	ar->workqueue = alloc_workqueue("ath10k_wq",
+					WQ_UNBOUND | WQ_MEM_RECLAIM,
+					ATH10K_MAX_NUM_PARALLEL_WORKERS);
 	if (!ar->workqueue)
 		goto err_wq;
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index ab05c4c..e196833 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -40,6 +40,11 @@
 #define ATH10K_FLUSH_TIMEOUT_HZ (5*HZ)
 #define ATH10K_NUM_CHANS 38
 
+#define ATH10K_NUM_HTC_TX_WORKERS ATH10K_HTC_EP_COUNT
+#define ATH10K_NUM_WMI_RX_WORKERS 1
+#define ATH10K_MAX_NUM_PARALLEL_WORKERS (ATH10K_NUM_HTC_TX_WORKERS + \
+					 ATH10K_NUM_WMI_RX_WORKERS)
+
 /* Antenna noise floor */
 #define ATH10K_DEFAULT_NOISE_FLOOR -95
 
-- 
1.7.9.5

