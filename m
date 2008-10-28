Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56089 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYJ1Sgp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 14:36:45 -0400
Subject: [PATCH] iwl3945: remove dead code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Reinette Chatre <reinette.chatre@linux.intel.com>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 18:06:02 +0100
Message-Id: <1225213563.3598.20.camel@johannes.berg> (sfid-20081028_193647_701345_22F3F51D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Was wondering about this code since supposedly the firmware will
add the SSID element. Turns out it's dead, so remove it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-10-28 18:04:05.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-10-28 18:04:22.000000000 +0100
@@ -1595,7 +1595,7 @@ static u16 iwl3945_supported_rate_to_ie(
  */
 static u16 iwl3945_fill_probe_req(struct iwl3945_priv *priv,
 			      struct ieee80211_mgmt *frame,
-			      int left, int is_direct)
+			      int left)
 {
 	int len = 0;
 	u8 *pos = NULL;
@@ -1625,20 +1625,6 @@ static u16 iwl3945_fill_probe_req(struct
 	*pos++ = WLAN_EID_SSID;
 	*pos++ = 0;
 
-	/* fill in our direct SSID IE... */
-	if (is_direct) {
-		/* ...next IE... */
-		left -= 2 + priv->essid_len;
-		if (left < 0)
-			return 0;
-		/* ... fill it in... */
-		*pos++ = WLAN_EID_SSID;
-		*pos++ = priv->essid_len;
-		memcpy(pos, priv->essid, priv->essid_len);
-		pos += priv->essid_len;
-		len += 2 + priv->essid_len;
-	}
-
 	/* fill in supported rate */
 	/* ...next IE... */
 	left -= 2;
@@ -6187,7 +6173,7 @@ static void iwl3945_bg_request_scan(stru
 	 * that based on the direct_mask added to each channel entry */
 	scan->tx_cmd.len = cpu_to_le16(
 		iwl3945_fill_probe_req(priv, (struct ieee80211_mgmt *)scan->data,
-			IWL_MAX_SCAN_SIZE - sizeof(*scan), 0));
+			IWL_MAX_SCAN_SIZE - sizeof(*scan)));
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
 	scan->tx_cmd.sta_id = priv->hw_setting.bcast_sta_id;
 	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;


