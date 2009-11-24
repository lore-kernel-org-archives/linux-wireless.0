Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:11388 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933275AbZKXPZt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 10:25:49 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [RFC 3/3] iwmc3200wifi: Implement cfg80211 PMKSA API
Date: Tue, 24 Nov 2009 16:26:54 +0100
Message-Id: <601a0b604e70a6a72481e02860c6a6430351cd34.1259075573.git.sameo@linux.intel.com>
In-Reply-To: <fce5ca6545ef79bb7ce9c9abf3e9348d070637dc.1259075573.git.sameo@linux.intel.com>
References: <cover.1259075573.git.sameo@linux.intel.com>
 <ff5bf1a69ecd3ed3695089cf62e6ab51689b683a.1259075573.git.sameo@linux.intel.com>
 <fce5ca6545ef79bb7ce9c9abf3e9348d070637dc.1259075573.git.sameo@linux.intel.com>
In-Reply-To: <cover.1259075573.git.sameo@linux.intel.com>
References: <cover.1259075573.git.sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to implement the PMKSA API for proper WPA2 pre-auth and fast
re-association. Our fullmac device generates all (re-)assoc IEs, and thus it
needs the right PMKIDs. With this implementation we now get them from
wpa_supplicant.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |   30 ++++++++++++++++++++++++++
 drivers/net/wireless/iwmc3200wifi/commands.c |   22 +++++++++++++++++++
 drivers/net/wireless/iwmc3200wifi/commands.h |   13 +++++++++++
 drivers/net/wireless/iwmc3200wifi/umac.h     |    1 +
 4 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index 7cfc2c0..c74f9f9 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -725,6 +725,33 @@ static int iwm_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 				       CFG_POWER_INDEX, iwm->conf.power_index);
 }
 
+int iwm_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
+			   struct cfg80211_pmksa *pmksa)
+{
+	struct iwm_priv *iwm = wiphy_to_iwm(wiphy);
+
+	return iwm_send_pmkid_update(iwm, pmksa, IWM_CMD_PMKID_ADD);
+}
+
+int iwm_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
+			   struct cfg80211_pmksa *pmksa)
+{
+	struct iwm_priv *iwm = wiphy_to_iwm(wiphy);
+
+	return iwm_send_pmkid_update(iwm, pmksa, IWM_CMD_PMKID_DEL);
+}
+
+int iwm_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
+{
+	struct iwm_priv *iwm = wiphy_to_iwm(wiphy);
+	struct cfg80211_pmksa pmksa;
+
+	memset(&pmksa, 0, sizeof(struct cfg80211_pmksa));
+
+	return iwm_send_pmkid_update(iwm, &pmksa, IWM_CMD_PMKID_FLUSH);
+}
+
+
 static struct cfg80211_ops iwm_cfg80211_ops = {
 	.change_virtual_intf = iwm_cfg80211_change_iface,
 	.add_key = iwm_cfg80211_add_key,
@@ -741,6 +768,9 @@ static struct cfg80211_ops iwm_cfg80211_ops = {
 	.set_tx_power = iwm_cfg80211_set_txpower,
 	.get_tx_power = iwm_cfg80211_get_txpower,
 	.set_power_mgmt = iwm_cfg80211_set_power_mgmt,
+	.set_pmksa = iwm_cfg80211_set_pmksa,
+	.del_pmksa = iwm_cfg80211_del_pmksa,
+	.flush_pmksa = iwm_cfg80211_flush_pmksa,
 };
 
 static const u32 cipher_suites[] = {
diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
index 46ca7c5..bd06307 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -960,3 +960,25 @@ int iwm_send_umac_stop_resume_tx(struct iwm_priv *iwm,
 				 sizeof(struct iwm_umac_cmd_stop_resume_tx));
 
 }
+
+int iwm_send_pmkid_update(struct iwm_priv *iwm,
+			  struct cfg80211_pmksa *pmksa, u32 command)
+{
+	struct iwm_umac_pmkid_update update;
+	int ret;
+
+	memset(&update, 0, sizeof(struct iwm_umac_pmkid_update));
+
+	update.command = cpu_to_le32(command);
+	memcpy(&update.bssid, pmksa->bssid, ETH_ALEN);
+	memcpy(&update.pmkid, pmksa->pmkid, WLAN_PMKID_LEN);
+
+	ret = iwm_send_wifi_if_cmd(iwm, &update,
+				   sizeof(struct iwm_umac_pmkid_update), 0);
+	if (ret) {
+		IWM_ERR(iwm, "PMKID update command failed\n");
+		return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/wireless/iwmc3200wifi/commands.h b/drivers/net/wireless/iwmc3200wifi/commands.h
index 95cdf94..06af055 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.h
+++ b/drivers/net/wireless/iwmc3200wifi/commands.h
@@ -458,6 +458,17 @@ struct iwm_umac_cmd_stop_resume_tx {
 	u16 reserved;
 } __attribute__ ((packed));
 
+#define IWM_CMD_PMKID_ADD   1
+#define IWM_CMD_PMKID_DEL   2
+#define IWM_CMD_PMKID_FLUSH 3
+
+struct iwm_umac_pmkid_update {
+	__le32 command;
+	u8 bssid[ETH_ALEN];
+	__le16 reserved;
+	u8 pmkid[WLAN_PMKID_LEN];
+} __attribute__ ((packed));
+
 /* LMAC commands */
 int iwm_read_mac(struct iwm_priv *iwm, u8 *mac);
 int iwm_send_prio_table(struct iwm_priv *iwm);
@@ -488,6 +499,8 @@ int iwm_scan_ssids(struct iwm_priv *iwm, struct cfg80211_ssid *ssids,
 int iwm_scan_one_ssid(struct iwm_priv *iwm, u8 *ssid, int ssid_len);
 int iwm_send_umac_stop_resume_tx(struct iwm_priv *iwm,
 				 struct iwm_umac_notif_stop_resume_tx *ntf);
+int iwm_send_pmkid_update(struct iwm_priv *iwm,
+			  struct cfg80211_pmksa *pmksa, u32 command);
 
 /* UDMA commands */
 int iwm_target_reset(struct iwm_priv *iwm);
diff --git a/drivers/net/wireless/iwmc3200wifi/umac.h b/drivers/net/wireless/iwmc3200wifi/umac.h
index 70094bf..24c7c7a 100644
--- a/drivers/net/wireless/iwmc3200wifi/umac.h
+++ b/drivers/net/wireless/iwmc3200wifi/umac.h
@@ -298,6 +298,7 @@ struct iwm_udma_out_wifi_hdr {
 #define UMAC_WIFI_IF_CMD_GLOBAL_TX_KEY_ID                0x1B
 #define UMAC_WIFI_IF_CMD_SET_HOST_EXTENDED_IE            0x1C
 #define UMAC_WIFI_IF_CMD_GET_SUPPORTED_CHANNELS          0x1E
+#define UMAC_WIFI_IF_CMD_PMKID_UPDATE                    0x1F
 #define UMAC_WIFI_IF_CMD_TX_PWR_TRIGGER                  0x20
 
 /* UMAC WiFi interface ports */
-- 
1.6.3.3

