Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52818 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab2EKIx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 04:53:26 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>
Subject: [PATCH 2/4] iwlwifi: disable default wildcard ssid scan
Date: Fri, 11 May 2012 10:53:16 +0200
Message-Id: <1336726398-13200-3-git-send-email-johannes@sipsolutions.net> (sfid-20120511_105350_536285_845D78BF)
In-Reply-To: <1336726398-13200-1-git-send-email-johannes@sipsolutions.net>
References: <1336726398-13200-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

iwl_fill_probe_request has used to add a wildcard ssid IE to
any probe request template, now it's disabled and it will
send wildcard ssid only for full scan. Instead, the highest
priority ssid is set to the template.
Due to adding high priority SSID to the template, it reduce
IE len, but since we had only 260 bytes for IEs before changing
allocation size to be dynamic, now we should have a bit more room
for IEs.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   31 +++++++++++++++++++--------
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index d33cc9c..9abe07a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -223,8 +223,8 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX;
-	/* we create the 802.11 header and a zero-length SSID element */
-	hw->wiphy->max_scan_ie_len = capa->max_probe_length - 24 - 2;
+	/* we create the 802.11 header and a max-length SSID element */
+	hw->wiphy->max_scan_ie_len = capa->max_probe_length - 24 - 34;
 
 	/*
 	 * We don't use all queues: 4 and 9 are unused and any
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 6f221de..0505e4e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -617,7 +617,8 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
  */
 
 static u16 iwl_fill_probe_req(struct ieee80211_mgmt *frame, const u8 *ta,
-			      const u8 *ies, int ie_len, int left)
+			      const u8 *ies, int ie_len, const u8 *ssid,
+			      u8 ssid_len, int left)
 {
 	int len = 0;
 	u8 *pos = NULL;
@@ -639,14 +640,18 @@ static u16 iwl_fill_probe_req(struct ieee80211_mgmt *frame, const u8 *ta,
 	/* ...next IE... */
 	pos = &frame->u.probe_req.variable[0];
 
-	/* fill in our indirect SSID IE */
-	left -= 2;
+	/* fill in our SSID IE */
+	left -= ssid_len + 2;
 	if (left < 0)
 		return 0;
 	*pos++ = WLAN_EID_SSID;
-	*pos++ = 0;
+	*pos++ = ssid_len;
+	if (ssid && ssid_len) {
+		memcpy(pos, ssid, ssid_len);
+		pos += ssid_len;
+	}
 
-	len += 2;
+	len += ssid_len + 2;
 
 	if (WARN_ON(left < ie_len))
 		return len;
@@ -683,6 +688,8 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	int scan_cmd_size = sizeof(struct iwl_scan_cmd) +
 			    MAX_SCAN_CHANNEL * sizeof(struct iwl_scan_channel) +
 			    priv->fw->ucode_capa.max_probe_length;
+	const u8 *ssid = NULL;
+	u8 ssid_len = 0;
 
 	if (WARN_ON_ONCE(priv->scan_request &&
 			 priv->scan_request->n_channels > MAX_SCAN_CHANNEL))
@@ -753,10 +760,14 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		if (priv->scan_request->n_ssids) {
 			int i, p = 0;
 			IWL_DEBUG_SCAN(priv, "Kicking off active scan\n");
-			for (i = 0; i < priv->scan_request->n_ssids; i++) {
-				/* always does wildcard anyway */
-				if (!priv->scan_request->ssids[i].ssid_len)
-					continue;
+			/*
+			 * The highest priority SSID is inserted to the
+			 * probe request template.
+			 */
+			ssid_len = priv->scan_request->ssids[0].ssid_len;
+			ssid = priv->scan_request->ssids[0].ssid;
+
+			for (i = 1; i < priv->scan_request->n_ssids; i++) {
 				scan->direct_scan[p].id = WLAN_EID_SSID;
 				scan->direct_scan[p].len =
 					priv->scan_request->ssids[i].ssid_len;
@@ -890,6 +901,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 					vif->addr,
 					priv->scan_request->ie,
 					priv->scan_request->ie_len,
+					ssid, ssid_len,
 					scan_cmd_size - sizeof(*scan));
 		break;
 	case IWL_SCAN_RADIO_RESET:
@@ -898,6 +910,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		cmd_len = iwl_fill_probe_req(
 					(struct ieee80211_mgmt *)scan->data,
 					iwl_bcast_addr, NULL, 0,
+					NULL, 0,
 					scan_cmd_size - sizeof(*scan));
 		break;
 	default:
-- 
1.7.10

