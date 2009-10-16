Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62948 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbZJPVZ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 17:25:58 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/10] iwlagn: store station rate scale information in mac80211 station structure
Date: Fri, 16 Oct 2009 14:25:55 -0700
Message-Id: <1255728358-29976-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255728358-29976-1-git-send-email-reinette.chatre@intel.com>
References: <1255728358-29976-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Currently mac80211 initializes the rate scaling before notifying the driver
of the station's existence. The driver dealt with this by not relying on
mac80211's station notifications and instead mixing this functionality with
the rate scaling code and other places. To clean this up the driver needs
to do rate scaling initialization after being notified of the station, this
can be done if the rate scaling information forms part of the station
information passed from mac80211 to driver.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    8 ++------
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h    |   13 +++++++++++++
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 2d4ec1a..27d4ece 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2475,19 +2475,17 @@ static void *rs_alloc_sta(void *priv_rate, struct ieee80211_sta *sta,
 			  gfp_t gfp)
 {
 	struct iwl_lq_sta *lq_sta;
+	struct iwl_station_priv *sta_priv = (struct iwl_station_priv *) sta->drv_priv;
 	struct iwl_priv *priv;
 	int i, j;
 
 	priv = (struct iwl_priv *)priv_rate;
 	IWL_DEBUG_RATE(priv, "create station rate scale window\n");
 
-	lq_sta = kzalloc(sizeof(struct iwl_lq_sta), gfp);
+	lq_sta = &sta_priv->lq_sta;
 
-	if (lq_sta == NULL)
-		return NULL;
 	lq_sta->lq.sta_id = 0xff;
 
-
 	for (j = 0; j < LQ_SIZE; j++)
 		for (i = 0; i < IWL_RATE_COUNT; i++)
 			rs_rate_scale_clear_window(&lq_sta->lq_info[j].win[i]);
@@ -2719,11 +2717,9 @@ static void rs_free(void *priv_rate)
 static void rs_free_sta(void *priv_r, struct ieee80211_sta *sta,
 			void *priv_sta)
 {
-	struct iwl_lq_sta *lq_sta = priv_sta;
 	struct iwl_priv *priv __maybe_unused = priv_r;
 
 	IWL_DEBUG_RATE(priv, "enter\n");
-	kfree(lq_sta);
 	IWL_DEBUG_RATE(priv, "leave\n");
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c3e7101..3664d01 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2305,6 +2305,7 @@ static int iwl_setup_mac(struct iwl_priv *priv)
 		hw->flags |= IEEE80211_HW_SUPPORTS_PS |
 			     IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
 
+	hw->sta_data_size = sizeof(struct iwl_station_priv);
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 35d5794..6ba082d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -576,6 +576,19 @@ struct iwl_station_entry {
 	struct iwl_hw_key keyinfo;
 };
 
+/*
+ * iwl_station_priv: Driver's private station information
+ *
+ * When mac80211 creates a station it reserves some space (hw->sta_data_size)
+ * in the structure for use by driver. This structure is places in that
+ * space.
+ *
+ * At the moment use it for the station's rate scaling information.
+ */
+struct iwl_station_priv {
+	struct iwl_lq_sta lq_sta;
+};
+
 /* one for each uCode image (inst/data, boot/init/runtime) */
 struct fw_desc {
 	void *v_addr;		/* access by driver */
-- 
1.5.6.3

