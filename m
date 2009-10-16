Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15258 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbZJPFUX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 01:20:23 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 04/16] iwmc3200wifi: CT kill support
Date: Fri, 16 Oct 2009 13:18:48 +0800
Message-Id: <1255670340-22565-5-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1255670340-22565-4-git-send-email-yi.zhu@intel.com>
References: <1255670340-22565-1-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-2-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-3-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-4-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

We set the initial CT (Temperature control) value to 110 degrees.
If the chip goes over that threshold, we hard block the device which will turn
it down. At the same time we schedule a 30 seconds delayed work that unblock
the device (and userspace is supposed to bring it back up), hoping that the
chip will have cooled down by then...

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/commands.c |   11 +++++++++++
 drivers/net/wireless/iwmc3200wifi/commands.h |    1 +
 drivers/net/wireless/iwmc3200wifi/fw.c       |    2 ++
 drivers/net/wireless/iwmc3200wifi/iwm.h      |    3 +++
 drivers/net/wireless/iwmc3200wifi/lmac.h     |    8 ++++++++
 drivers/net/wireless/iwmc3200wifi/main.c     |   14 ++++++++++++++
 drivers/net/wireless/iwmc3200wifi/netdev.c   |    1 +
 drivers/net/wireless/iwmc3200wifi/rx.c       |   16 +++++++++++++++-
 8 files changed, 55 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
index 84158b6..1ba839c 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -275,6 +275,17 @@ int iwm_send_calib_results(struct iwm_priv *iwm)
 	return ret;
 }
 
+int iwm_send_ct_kill_cfg(struct iwm_priv *iwm, u8 entry, u8 exit)
+{
+	struct iwm_ct_kill_cfg_cmd cmd;
+
+	cmd.entry_threshold = entry;
+	cmd.exit_threshold = exit;
+
+	return iwm_send_lmac_ptrough_cmd(iwm, REPLY_CT_KILL_CONFIG_CMD, &cmd,
+					 sizeof(struct iwm_ct_kill_cfg_cmd), 0);
+}
+
 int iwm_send_umac_reset(struct iwm_priv *iwm, __le32 reset_flags, bool resp)
 {
 	struct iwm_udma_wifi_cmd udma_cmd = UDMA_UMAC_INIT;
diff --git a/drivers/net/wireless/iwmc3200wifi/commands.h b/drivers/net/wireless/iwmc3200wifi/commands.h
index 4e183be..e486f8e 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.h
+++ b/drivers/net/wireless/iwmc3200wifi/commands.h
@@ -396,6 +396,7 @@ int iwm_send_init_calib_cfg(struct iwm_priv *iwm, u8 calib_requested);
 int iwm_send_periodic_calib_cfg(struct iwm_priv *iwm, u8 calib_requested);
 int iwm_send_calib_results(struct iwm_priv *iwm);
 int iwm_store_rxiq_calib_result(struct iwm_priv *iwm);
+int iwm_send_ct_kill_cfg(struct iwm_priv *iwm, u8 entry, u8 exit);
 
 /* UMAC commands */
 int iwm_send_wifi_if_cmd(struct iwm_priv *iwm, void *payload, u16 payload_size,
diff --git a/drivers/net/wireless/iwmc3200wifi/fw.c b/drivers/net/wireless/iwmc3200wifi/fw.c
index 6b0bcad..f02d571 100644
--- a/drivers/net/wireless/iwmc3200wifi/fw.c
+++ b/drivers/net/wireless/iwmc3200wifi/fw.c
@@ -398,6 +398,8 @@ int iwm_load_fw(struct iwm_priv *iwm)
 	iwm_send_prio_table(iwm);
 	iwm_send_calib_results(iwm);
 	iwm_send_periodic_calib_cfg(iwm, periodic_calib_map);
+	iwm_send_ct_kill_cfg(iwm, iwm->conf.ct_kill_entry,
+			     iwm->conf.ct_kill_exit);
 
 	return 0;
 
diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index 1b02a4e..fe0ab80 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -65,6 +65,8 @@ struct iwm_conf {
 	u32 sdio_ior_timeout;
 	unsigned long calib_map;
 	unsigned long expected_calib_map;
+	u8 ct_kill_entry;
+	u8 ct_kill_exit;
 	bool reset_on_fatal_err;
 	bool auto_connect;
 	bool wimax_not_present;
@@ -276,6 +278,7 @@ struct iwm_priv {
 	struct iw_statistics wstats;
 	struct delayed_work stats_request;
 	struct delayed_work disconnect;
+	struct delayed_work ct_kill_delay;
 
 	struct iwm_debugfs dbg;
 
diff --git a/drivers/net/wireless/iwmc3200wifi/lmac.h b/drivers/net/wireless/iwmc3200wifi/lmac.h
index 6c1a14c..a3a79b5 100644
--- a/drivers/net/wireless/iwmc3200wifi/lmac.h
+++ b/drivers/net/wireless/iwmc3200wifi/lmac.h
@@ -187,6 +187,14 @@ struct iwm_coex_prio_table_cmd {
 				     COEX_EVT_FLAG_MEDIUM_ACTV_NTFY_MSK | \
 				     COEX_EVT_FLAG_DELAY_MEDIUM_FREE_NTFY_MSK)
 
+/* CT kill config command */
+struct iwm_ct_kill_cfg_cmd {
+	u32 exit_threshold;
+	u32 reserved;
+	u32 entry_threshold;
+} __attribute__ ((packed));
+
+
 /* LMAC OP CODES */
 #define REPLY_PAD			0x0
 #define REPLY_ALIVE			0x1
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index 68fb3dc..dfc8fd4 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -64,6 +64,8 @@ static struct iwm_conf def_iwm_conf = {
 				  BIT(PHY_CALIBRATE_TX_IQ_CMD)	|
 				  BIT(PHY_CALIBRATE_RX_IQ_CMD)	|
 				  BIT(SHILOH_PHY_CALIBRATE_BASE_BAND_CMD),
+	.ct_kill_entry		= 110,
+	.ct_kill_exit		= 110,
 	.reset_on_fatal_err	= 1,
 	.auto_connect		= 1,
 	.wimax_not_present	= 0,
@@ -134,6 +136,17 @@ static void iwm_disconnect_work(struct work_struct *work)
 	cfg80211_disconnected(iwm_to_ndev(iwm), 0, NULL, 0, GFP_KERNEL);
 }
 
+static void iwm_ct_kill_work(struct work_struct *work)
+{
+	struct iwm_priv *iwm =
+		container_of(work, struct iwm_priv, ct_kill_delay.work);
+	struct wiphy *wiphy = iwm_to_wiphy(iwm);
+
+	IWM_INFO(iwm, "CT kill delay timeout\n");
+
+	wiphy_rfkill_set_hw_state(wiphy, false);
+}
+
 static int __iwm_up(struct iwm_priv *iwm);
 static int __iwm_down(struct iwm_priv *iwm);
 
@@ -226,6 +239,7 @@ int iwm_priv_init(struct iwm_priv *iwm)
 	iwm->scan_id = 1;
 	INIT_DELAYED_WORK(&iwm->stats_request, iwm_statistics_request);
 	INIT_DELAYED_WORK(&iwm->disconnect, iwm_disconnect_work);
+	INIT_DELAYED_WORK(&iwm->ct_kill_delay, iwm_ct_kill_work);
 	INIT_WORK(&iwm->reset_worker, iwm_reset_worker);
 	INIT_LIST_HEAD(&iwm->bss_list);
 
diff --git a/drivers/net/wireless/iwmc3200wifi/netdev.c b/drivers/net/wireless/iwmc3200wifi/netdev.c
index 35ec006..4f8dbdd 100644
--- a/drivers/net/wireless/iwmc3200wifi/netdev.c
+++ b/drivers/net/wireless/iwmc3200wifi/netdev.c
@@ -152,6 +152,7 @@ void iwm_if_free(struct iwm_priv *iwm)
 	if (!iwm_to_ndev(iwm))
 		return;
 
+	cancel_delayed_work_sync(&iwm->ct_kill_delay);
 	free_netdev(iwm_to_ndev(iwm));
 	iwm_priv_deinit(iwm);
 	kfree(iwm->umac_profile);
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 771a301..813e1b3 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -1079,6 +1079,7 @@ static int iwm_ntf_wifi_if_wrapper(struct iwm_priv *iwm, u8 *buf,
 	return 0;
 }
 
+#define CT_KILL_DELAY (30 * HZ)
 static int iwm_ntf_card_state(struct iwm_priv *iwm, u8 *buf,
 			      unsigned long buf_size, struct iwm_wifi_cmd *cmd)
 {
@@ -1091,7 +1092,20 @@ static int iwm_ntf_card_state(struct iwm_priv *iwm, u8 *buf,
 		 flags & IWM_CARD_STATE_HW_DISABLED ? "ON" : "OFF",
 		 flags & IWM_CARD_STATE_CTKILL_DISABLED ? "ON" : "OFF");
 
-	wiphy_rfkill_set_hw_state(wiphy, flags & IWM_CARD_STATE_HW_DISABLED);
+	if (flags & IWM_CARD_STATE_CTKILL_DISABLED) {
+		/*
+		 * We got a CTKILL event: We bring the interface down in
+		 * oder to cool the device down, and try to bring it up
+		 * 30 seconds later. If it's still too hot, we'll go through
+		 * this code path again.
+		 */
+		cancel_delayed_work_sync(&iwm->ct_kill_delay);
+		schedule_delayed_work(&iwm->ct_kill_delay, CT_KILL_DELAY);
+	}
+
+	wiphy_rfkill_set_hw_state(wiphy, flags &
+				  (IWM_CARD_STATE_HW_DISABLED |
+				   IWM_CARD_STATE_CTKILL_DISABLED));
 
 	return 0;
 }
-- 
1.6.0.4

