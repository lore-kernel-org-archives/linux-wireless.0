Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:46464 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab3GPHUK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 03:20:10 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infraread.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 02/10] ath10k: decouple core start/stop logic
Date: Tue, 16 Jul 2013 09:19:45 +0200
Message-ID: <1373959193-5164-3-git-send-email-michal.kazior@tieto.com> (sfid-20130716_092039_514405_84EA8DAE)
In-Reply-To: <1373959193-5164-1-git-send-email-michal.kazior@tieto.com>
References: <1371041642-20273-1-git-send-email-michal.kazior@tieto.com>
 <1373959193-5164-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enables code reuse for proper hw reconfiguration
that is in turn required for proper
suspend/hibernation/wowlan support.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c |   44 +++++++++++++++++++++++---------
 drivers/net/wireless/ath/ath10k/core.h |    2 ++
 2 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index f1312fa..dcddae4 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -502,8 +502,7 @@ void ath10k_core_destroy(struct ath10k *ar)
 }
 EXPORT_SYMBOL(ath10k_core_destroy);
 
-
-int ath10k_core_register(struct ath10k *ar)
+int ath10k_core_start(struct ath10k *ar)
 {
 	struct bmi_target_info target_info;
 	int status;
@@ -589,9 +588,36 @@ int ath10k_core_register(struct ath10k *ar)
 	if (status)
 		goto err_disconnect_htc;
 
+	return 0;
+
+err_disconnect_htc:
+	ath10k_htc_stop(&ar->htc);
+err_htt_detach:
+	ath10k_htt_detach(&ar->htt);
+err_wmi_detach:
+	ath10k_wmi_detach(ar);
+err:
+	return status;
+}
+
+void ath10k_core_stop(struct ath10k *ar)
+{
+	ath10k_htc_stop(&ar->htc);
+	ath10k_htt_detach(&ar->htt);
+	ath10k_wmi_detach(ar);
+}
+
+int ath10k_core_register(struct ath10k *ar)
+{
+	int status;
+
+	status = ath10k_core_start(ar);
+	if (status)
+		goto err;
+
 	status = ath10k_mac_register(ar);
 	if (status)
-		goto err_disconnect_htc;
+		goto err_core_stop;
 
 	status = ath10k_debug_create(ar);
 	if (status) {
@@ -603,12 +629,8 @@ int ath10k_core_register(struct ath10k *ar)
 
 err_unregister_mac:
 	ath10k_mac_unregister(ar);
-err_disconnect_htc:
-	ath10k_htc_stop(&ar->htc);
-err_htt_detach:
-	ath10k_htt_detach(&ar->htt);
-err_wmi_detach:
-	ath10k_wmi_detach(ar);
+err_core_stop:
+	ath10k_core_stop(ar);
 err:
 	return status;
 }
@@ -620,9 +642,7 @@ void ath10k_core_unregister(struct ath10k *ar)
 	 * Otherwise we will fail to submit commands to FW and mac80211 will be
 	 * unhappy about callback failures. */
 	ath10k_mac_unregister(ar);
-	ath10k_htc_stop(&ar->htc);
-	ath10k_htt_detach(&ar->htt);
-	ath10k_wmi_detach(ar);
+	ath10k_core_stop(ar);
 }
 EXPORT_SYMBOL(ath10k_core_unregister);
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 2f7065c..5a0b2ce 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -353,6 +353,8 @@ struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
 				  const struct ath10k_hif_ops *hif_ops);
 void ath10k_core_destroy(struct ath10k *ar);
 
+int ath10k_core_start(struct ath10k *ar);
+void ath10k_core_stop(struct ath10k *ar);
 int ath10k_core_register(struct ath10k *ar);
 void ath10k_core_unregister(struct ath10k *ar);
 
-- 
1.7.9.5

