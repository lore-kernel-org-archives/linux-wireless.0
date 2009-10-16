Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15258 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbZJPFUy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 01:20:54 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 09/16] iwmc3200wifi: Tx power setting
Date: Fri, 16 Oct 2009 13:18:53 +0800
Message-Id: <1255670340-22565-10-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1255670340-22565-9-git-send-email-yi.zhu@intel.com>
References: <1255670340-22565-1-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-2-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-3-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-4-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-5-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-6-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-7-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-8-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-9-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

We can now set the Tx power from e.g. iwconfig.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |   12 +++++++++++-
 drivers/net/wireless/iwmc3200wifi/commands.c |   13 +++++++++++++
 drivers/net/wireless/iwmc3200wifi/commands.h |    6 ++++++
 3 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index ea0ed32..2e00a4b 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -671,9 +671,19 @@ static int iwm_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 static int iwm_cfg80211_set_txpower(struct wiphy *wiphy,
 				    enum tx_power_setting type, int dbm)
 {
+	struct iwm_priv *iwm = wiphy_to_iwm(wiphy);
+	int ret;
+
 	switch (type) {
 	case TX_POWER_AUTOMATIC:
 		return 0;
+	case TX_POWER_FIXED:
+		ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
+					      CFG_TX_PWR_LIMIT_USR, dbm * 2);
+		if (ret < 0)
+			return ret;
+
+		return iwm_tx_power_trigger(iwm);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -685,7 +695,7 @@ static int iwm_cfg80211_get_txpower(struct wiphy *wiphy, int *dbm)
 {
 	struct iwm_priv *iwm = wiphy_to_iwm(wiphy);
 
-	*dbm = iwm->txpower;
+	*dbm = iwm->txpower >> 1;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
index 1ba839c..0641bc7 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -794,6 +794,19 @@ int iwm_invalidate_mlme_profile(struct iwm_priv *iwm)
 	return ret ? 0 : -EBUSY;
 }
 
+int iwm_tx_power_trigger(struct iwm_priv *iwm)
+{
+	struct iwm_umac_pwr_trigger pwr_trigger;
+
+	pwr_trigger.hdr.oid = UMAC_WIFI_IF_CMD_TX_PWR_TRIGGER;
+	pwr_trigger.hdr.buf_size =
+		cpu_to_le16(sizeof(struct iwm_umac_pwr_trigger) -
+			    sizeof(struct iwm_umac_wifi_if));
+
+
+	return iwm_send_wifi_if_cmd(iwm, &pwr_trigger, sizeof(pwr_trigger), 1);
+}
+
 int iwm_send_umac_stats_req(struct iwm_priv *iwm, u32 flags)
 {
 	struct iwm_udma_wifi_cmd udma_cmd = UDMA_UMAC_INIT;
diff --git a/drivers/net/wireless/iwmc3200wifi/commands.h b/drivers/net/wireless/iwmc3200wifi/commands.h
index 511b6e3..b36be2b 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.h
+++ b/drivers/net/wireless/iwmc3200wifi/commands.h
@@ -441,6 +441,11 @@ struct iwm_umac_tx_key_id {
 	u8 reserved[3];
 } __attribute__ ((packed));
 
+struct iwm_umac_pwr_trigger {
+	struct iwm_umac_wifi_if hdr;
+	__le32 reseved;
+} __attribute__ ((packed));
+
 struct iwm_umac_cmd_stats_req {
 	__le32 flags;
 } __attribute__ ((packed));
@@ -467,6 +472,7 @@ int iwm_invalidate_mlme_profile(struct iwm_priv *iwm);
 int iwm_send_packet(struct iwm_priv *iwm, struct sk_buff *skb, int pool_id);
 int iwm_set_tx_key(struct iwm_priv *iwm, u8 key_idx);
 int iwm_set_key(struct iwm_priv *iwm, bool remove, struct iwm_key *key);
+int iwm_tx_power_trigger(struct iwm_priv *iwm);
 int iwm_send_umac_stats_req(struct iwm_priv *iwm, u32 flags);
 int iwm_send_umac_channel_list(struct iwm_priv *iwm);
 int iwm_scan_ssids(struct iwm_priv *iwm, struct cfg80211_ssid *ssids,
-- 
1.6.0.4

