Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:39621 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473Ab3ICIoG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 04:44:06 -0400
Subject: [PATCH 2/3] ath10k: implement ath10k_debug_start/stop()
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 03 Sep 2013 11:44:03 +0300
Message-ID: <20130903084403.26199.47052.stgit@localhost6.localdomain6> (sfid-20130903_104410_696310_8B43590A)
In-Reply-To: <20130903084302.26199.3538.stgit@localhost6.localdomain6>
References: <20130903084302.26199.3538.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Needed for the HTT stats implementation.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c  |    6 ++++++
 drivers/net/wireless/ath/ath10k/debug.c |   10 ++++++++++
 drivers/net/wireless/ath/ath10k/debug.h |   11 +++++++++++
 3 files changed, 27 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 2dd39a8..4f2b0e7 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -630,6 +630,10 @@ int ath10k_core_start(struct ath10k *ar)
 	if (status)
 		goto err_disconnect_htc;
 
+	status = ath10k_debug_start(ar);
+	if (status)
+		goto err_disconnect_htc;
+
 	ar->free_vdev_map = (1 << TARGET_NUM_VDEVS) - 1;
 
 	return 0;
@@ -647,6 +651,7 @@ EXPORT_SYMBOL(ath10k_core_start);
 
 void ath10k_core_stop(struct ath10k *ar)
 {
+	ath10k_debug_stop(ar);
 	ath10k_htc_stop(&ar->htc);
 	ath10k_htt_detach(&ar->htt);
 	ath10k_wmi_detach(ar);
@@ -777,6 +782,7 @@ void ath10k_core_unregister(struct ath10k *ar)
 	 * Otherwise we will fail to submit commands to FW and mac80211 will be
 	 * unhappy about callback failures. */
 	ath10k_mac_unregister(ar);
+
 	ath10k_core_free_firmware_files(ar);
 }
 EXPORT_SYMBOL(ath10k_core_unregister);
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 09f535a..219d469 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -517,6 +517,15 @@ static const struct file_operations fops_chip_id = {
 	.llseek = default_llseek,
 };
 
+int ath10k_debug_start(struct ath10k *ar)
+{
+	return 0;
+}
+
+void ath10k_debug_stop(struct ath10k *ar)
+{
+}
+
 int ath10k_debug_create(struct ath10k *ar)
 {
 	ar->debug.debugfs_phy = debugfs_create_dir("ath10k",
@@ -541,6 +550,7 @@ int ath10k_debug_create(struct ath10k *ar)
 
 	return 0;
 }
+
 #endif /* CONFIG_ATH10K_DEBUGFS */
 
 #ifdef CONFIG_ATH10K_DEBUG
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 168140c..9c442a8 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -42,6 +42,8 @@ extern __printf(1, 2) int ath10k_err(const char *fmt, ...);
 extern __printf(1, 2) int ath10k_warn(const char *fmt, ...);
 
 #ifdef CONFIG_ATH10K_DEBUGFS
+int ath10k_debug_start(struct ath10k *ar);
+void ath10k_debug_stop(struct ath10k *ar);
 int ath10k_debug_create(struct ath10k *ar);
 void ath10k_debug_read_service_map(struct ath10k *ar,
 				   void *service_map,
@@ -50,6 +52,15 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
 				    struct wmi_stats_event *ev);
 
 #else
+int ath10k_debug_start(struct ath10k *ar)
+{
+	return 0;
+}
+
+void ath10k_debug_stop(struct ath10k *ar)
+{
+}
+
 static inline int ath10k_debug_create(struct ath10k *ar)
 {
 	return 0;

