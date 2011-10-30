Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:36487 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab1J3TQa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Oct 2011 15:16:30 -0400
Subject: [PATCH 2/5] ath6kl: power down hardware when interface is down
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Oct 2011 21:16:15 +0200
Message-ID: <20111030191615.20466.49934.stgit@localhost6.localdomain6> (sfid-20111030_201634_879493_BB4571B4)
In-Reply-To: <20111030190922.20466.299.stgit@localhost6.localdomain6>
References: <20111030190922.20466.299.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The benefit from this is that user space can control hardware's power state
by putting interface up and down. This is handy if firmware gets to some
weird state.

The downside will be that putting interface up takes a bit longer,
I was measuring ~500 ms during interface up.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/bmi.c  |    5 +++++
 drivers/net/wireless/ath/ath6kl/bmi.h  |    2 ++
 drivers/net/wireless/ath/ath6kl/core.h |    4 ++++
 drivers/net/wireless/ath/ath6kl/htc.c  |    3 +++
 drivers/net/wireless/ath/ath6kl/init.c |   35 +++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath6kl/main.c |   22 ++++++++++++++++----
 6 files changed, 64 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/bmi.c b/drivers/net/wireless/ath/ath6kl/bmi.c
index 5a4c24d..a962fe4 100644
--- a/drivers/net/wireless/ath/ath6kl/bmi.c
+++ b/drivers/net/wireless/ath/ath6kl/bmi.c
@@ -670,6 +670,11 @@ int ath6kl_bmi_fast_download(struct ath6kl *ar, u32 addr, u8 *buf, u32 len)
 	return ret;
 }
 
+void ath6kl_bmi_reset(struct ath6kl *ar)
+{
+	ar->bmi.done_sent = false;
+}
+
 int ath6kl_bmi_init(struct ath6kl *ar)
 {
 	ar->bmi.cmd_buf = kzalloc(MAX_BMI_CMDBUF_SZ, GFP_ATOMIC);
diff --git a/drivers/net/wireless/ath/ath6kl/bmi.h b/drivers/net/wireless/ath/ath6kl/bmi.h
index 96851d5..009e8f6 100644
--- a/drivers/net/wireless/ath/ath6kl/bmi.h
+++ b/drivers/net/wireless/ath/ath6kl/bmi.h
@@ -230,6 +230,8 @@ struct ath6kl_bmi_target_info {
 
 int ath6kl_bmi_init(struct ath6kl *ar);
 void ath6kl_bmi_cleanup(struct ath6kl *ar);
+void ath6kl_bmi_reset(struct ath6kl *ar);
+
 int ath6kl_bmi_done(struct ath6kl *ar);
 int ath6kl_bmi_get_target_info(struct ath6kl *ar,
 			       struct ath6kl_bmi_target_info *targ_info);
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 5ac415e..1ac0dd1 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -447,6 +447,7 @@ enum ath6kl_dev_state {
 	DESTROY_IN_PROGRESS,
 	SKIP_SCAN,
 	ROAM_TBL_PEND,
+	FIRST_BOOT,
 };
 
 struct ath6kl {
@@ -662,4 +663,7 @@ void ath6kl_deinit_if_data(struct ath6kl_vif *vif);
 void ath6kl_core_free(struct ath6kl *ar);
 struct ath6kl_vif *ath6kl_vif_first(struct ath6kl *ar);
 void ath6kl_cleanup_vif(struct ath6kl_vif *vif, bool wmi_ready);
+int ath6kl_init_hw_start(struct ath6kl *ar);
+int ath6kl_init_hw_stop(struct ath6kl *ar);
+
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 04b4070..99220d4 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -2622,6 +2622,9 @@ int ath6kl_htc_start(struct htc_target *target)
 	struct htc_packet *packet;
 	int status;
 
+	memset(&target->dev->irq_proc_reg, 0,
+	       sizeof(target->dev->irq_proc_reg));
+
 	/* Disable interrupts at the chip level */
 	ath6kl_hif_disable_intrs(target->dev);
 
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index a0b81c3..c197e4c 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1421,11 +1421,13 @@ static int ath6kl_init_hw_params(struct ath6kl *ar)
 	return 0;
 }
 
-static int ath6kl_hw_start(struct ath6kl *ar)
+int ath6kl_init_hw_start(struct ath6kl *ar)
 {
 	long timeleft;
 	int ret, i;
 
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "hw start\n");
+
 	ret = ath6kl_hif_power_on(ar);
 	if (ret)
 		return ret;
@@ -1517,6 +1519,25 @@ err_power_off:
 	return ret;
 }
 
+int ath6kl_init_hw_stop(struct ath6kl *ar)
+{
+	int ret;
+
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "hw stop\n");
+
+	ath6kl_htc_stop(ar->htc_target);
+
+	ath6kl_hif_stop(ar);
+
+	ath6kl_bmi_reset(ar);
+
+	ret = ath6kl_hif_power_off(ar);
+	if (ret)
+		ath6kl_warn("failed to power off hif: %d\n", ret);
+
+	return 0;
+}
+
 int ath6kl_core_init(struct ath6kl *ar)
 {
 	struct ath6kl_bmi_target_info targ_info;
@@ -1628,9 +1649,11 @@ int ath6kl_core_init(struct ath6kl *ar)
 
 	ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM;
 
-	ret = ath6kl_hw_start(ar);
+	set_bit(FIRST_BOOT, &ar->flag);
+
+	ret = ath6kl_init_hw_start(ar);
 	if (ret) {
-		ath6kl_err("Failed to boot hardware: %d\n", ret);
+		ath6kl_err("Failed to start hardware: %d\n", ret);
 		goto err_rxbuf_cleanup;
 	}
 
@@ -1640,6 +1663,12 @@ int ath6kl_core_init(struct ath6kl *ar)
 	 */
 	memcpy(ndev->dev_addr, ar->mac_addr, ETH_ALEN);
 
+	ret = ath6kl_init_hw_stop(ar);
+	if (ret) {
+		ath6kl_err("Failed to stop hardware: %d\n", ret);
+		goto err_htc_cleanup;
+	}
+
 	return ret;
 
 err_rxbuf_cleanup:
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 3b2a7e8..717ed22 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -673,10 +673,12 @@ void ath6kl_ready_event(void *devt, u8 *datap, u32 sw_ver, u32 abi_ver)
 	set_bit(WMI_READY, &ar->flag);
 	wake_up(&ar->event_wq);
 
-	ath6kl_info("hw %s fw %s%s\n",
-		    get_hw_id_string(ar->wiphy->hw_version),
-		    ar->wiphy->fw_version,
-		    test_bit(TESTMODE, &ar->flag) ? " testmode" : "");
+	if (test_and_clear_bit(FIRST_BOOT, &ar->flag)) {
+		ath6kl_info("hw %s fw %s%s\n",
+			    get_hw_id_string(ar->wiphy->hw_version),
+			    ar->wiphy->fw_version,
+			    test_bit(TESTMODE, &ar->flag) ? " testmode" : "");
+	}
 }
 
 void ath6kl_scan_complete_evt(struct ath6kl_vif *vif, int status)
@@ -1112,6 +1114,12 @@ struct ath6kl_vif *ath6kl_vif_first(struct ath6kl *ar)
 static int ath6kl_open(struct net_device *dev)
 {
 	struct ath6kl_vif *vif = netdev_priv(dev);
+	int ret;
+
+	/* FIXME: how to handle multi vif support? */
+	ret = ath6kl_init_hw_start(vif->ar);
+	if (ret)
+		return ret;
 
 	set_bit(WLAN_ENABLED, &vif->flags);
 
@@ -1128,6 +1136,7 @@ static int ath6kl_close(struct net_device *dev)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
 	struct ath6kl_vif *vif = netdev_priv(dev);
+	int ret;
 
 	netif_stop_queue(dev);
 
@@ -1143,6 +1152,11 @@ static int ath6kl_close(struct net_device *dev)
 
 	ath6kl_cfg80211_scan_complete_event(vif, -ECANCELED);
 
+	/* FIXME: how to handle multi vif support? */
+	ret = ath6kl_init_hw_stop(ar);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 

