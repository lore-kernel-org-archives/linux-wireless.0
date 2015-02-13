Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:52832 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbbBMMbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2015 07:31:34 -0500
Received: by mail-lb0-f176.google.com with SMTP id u10so15216499lbd.7
        for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2015 04:31:33 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: disable multi-vif ps by default
Date: Fri, 13 Feb 2015 13:30:16 +0100
Message-Id: <1423830616-7516-2-git-send-email-michal.kazior@tieto.com> (sfid-20150213_133138_624809_64A7BFF9)
In-Reply-To: <1423830616-7516-1-git-send-email-michal.kazior@tieto.com>
References: <1423830616-7516-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not all firmware revisions have a proper
multi-interface client powersaving implementation,
e.g. qca6174 WLAN.RM.2.0-00073.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
@Kalle: 999.999.0.636 seems to work okay with
multi-vif PS so you might want to bump it with the
MULTI_VIF_PS_SUPPORT feature flag set.

 drivers/net/wireless/ath/ath10k/core.h |  7 +++++++
 drivers/net/wireless/ath/ath10k/mac.c  | 31 +++++++++++++++++++++++++++++--
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index d60e46f..c900ef2 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -288,6 +288,7 @@ struct ath10k_vif {
 	bool is_started;
 	bool is_up;
 	bool spectral_enabled;
+	bool ps;
 	u32 aid;
 	u8 bssid[ETH_ALEN];
 
@@ -413,6 +414,12 @@ enum ath10k_fw_features {
 	 */
 	ATH10K_FW_FEATURE_WMI_10_2 = 4,
 
+	/* Some firmware revisions lack proper multi-interface client powersave
+	 * implementation. Enabling PS could result in connection drops,
+	 * traffic stalls, etc.
+	 */
+	ATH10K_FW_FEATURE_MULTI_VIF_PS_SUPPORT = 5,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 8ed0ba6..bab8adc 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1253,6 +1253,20 @@ static int ath10k_mac_vif_recalc_ps_poll_count(struct ath10k_vif *arvif)
 	return 0;
 }
 
+static int ath10k_mac_ps_vif_count(struct ath10k *ar)
+{
+	struct ath10k_vif *arvif;
+	int num = 0;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	list_for_each_entry(arvif, &ar->arvifs, list)
+		if (arvif->ps)
+			num++;
+
+	return num;
+}
+
 static int ath10k_mac_vif_setup_ps(struct ath10k_vif *arvif)
 {
 	struct ath10k *ar = arvif->ar;
@@ -1262,13 +1276,24 @@ static int ath10k_mac_vif_setup_ps(struct ath10k_vif *arvif)
 	enum wmi_sta_ps_mode psmode;
 	int ret;
 	int ps_timeout;
+	bool enable_ps;
 
 	lockdep_assert_held(&arvif->ar->conf_mutex);
 
 	if (arvif->vif->type != NL80211_IFTYPE_STATION)
 		return 0;
 
-	if (vif->bss_conf.ps) {
+	enable_ps = arvif->ps;
+
+	if (enable_ps && ath10k_mac_ps_vif_count(ar) > 1 &&
+	    !test_bit(ATH10K_FW_FEATURE_MULTI_VIF_PS_SUPPORT,
+		      ar->fw_features)) {
+		ath10k_warn(ar, "refusing to enable ps on vdev %i: not supported by fw\n",
+			    arvif->vdev_id);
+		enable_ps = false;
+	}
+
+	if (enable_ps) {
 		psmode = WMI_STA_PS_MODE_ENABLED;
 		param = WMI_STA_PS_PARAM_INACTIVITY_TIME;
 
@@ -3546,7 +3571,9 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_PS) {
-		ret = ath10k_mac_vif_setup_ps(arvif);
+		arvif->ps = vif->bss_conf.ps;
+
+		ret = ath10k_config_ps(ar);
 		if (ret)
 			ath10k_warn(ar, "failed to setup ps on vdev %i: %d\n",
 				    arvif->vdev_id, ret);
-- 
1.8.5.3

