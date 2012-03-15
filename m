Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31659 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030370Ab2COVfB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 17:35:01 -0400
From: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
Subject: [PATCH v2] ath6kl: handle probe response from P2P device in P2P GO mode
Date: Thu, 15 Mar 2012 14:34:56 -0700
Message-ID: <1331847296-2086-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com> (sfid-20120315_223507_163899_554EE88E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the device is in P2P GO mode and in listen state, the correct behavior is
to see two different probe response frames - one from P2P device and the other
from GO. wpa_supplicant uses the same mechanism to send the frame in both cases
(ath6kl_mgmt_tx). For GO probe response, ath6kl needs to call
ath6kl_send_go_probe_resp (this will add only WSC/P2P IEs and the rest of the
IEs are filled in by the firmware). That was done based on the nw_type ==
AP_NETWORK which would work if P2P Device role were in a separate netdev. When
P2P Device and GO use the same netdev, ath6kl needs to use the special GO probe
response case only if SSID is longer than P2P wildcard SSID.

Signed-off-by: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
Reviewed-by: Jouni Malinen <jouni@qca.qualcomm.com>

---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   23 +++++++++++++++++++----
 drivers/net/wireless/ath/ath6kl/core.h     |    2 ++
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 37908e6..37aa5db 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2750,6 +2750,21 @@ static bool ath6kl_mgmt_powersave_ap(struct ath6kl_vif *vif,
 	return false;
 }
 
+/* Check if SSID length is greater than DIRECT- */
+static bool ath6kl_is_p2p_go_ssid(const u8 *buf, size_t len)
+{
+	const struct ieee80211_mgmt *mgmt;
+	mgmt = (const struct ieee80211_mgmt *) buf;
+
+	/* variable[1] contains the SSID tag length */
+	if (buf + len >= &mgmt->u.probe_resp.variable[1] &&
+	    (mgmt->u.probe_resp.variable[1] > P2P_WILDCARD_SSID_LEN)) {
+		return true;
+	}
+
+	return false;
+}
+
 static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 			  struct ieee80211_channel *chan, bool offchan,
 			  enum nl80211_channel_type channel_type,
@@ -2764,11 +2779,11 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 	bool more_data, queued;
 
 	mgmt = (const struct ieee80211_mgmt *) buf;
-	if (buf + len >= mgmt->u.probe_resp.variable &&
-	    vif->nw_type == AP_NETWORK && test_bit(CONNECTED, &vif->flags) &&
-	    ieee80211_is_probe_resp(mgmt->frame_control)) {
+	if (vif->nw_type == AP_NETWORK && test_bit(CONNECTED, &vif->flags) &&
+	    ieee80211_is_probe_resp(mgmt->frame_control) &&
+	    ath6kl_is_p2p_go_ssid(buf, len)) {
 		/*
-		 * Send Probe Response frame in AP mode using a separate WMI
+		 * Send Probe Response frame in GO mode using a separate WMI
 		 * command to allow the target to fill in the generic IEs.
 		 */
 		*cookie = 0; /* TX status not supported */
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index f1dd890..17697eb 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -205,6 +205,8 @@ struct ath6kl_fw_ie {
 #define ATH6KL_CONF_ENABLE_TX_BURST		BIT(3)
 #define ATH6KL_CONF_UART_DEBUG			BIT(4)
 
+#define P2P_WILDCARD_SSID_LEN			7 /* DIRECT- */
+
 enum wlan_low_pwr_state {
 	WLAN_POWER_STATE_ON,
 	WLAN_POWER_STATE_CUT_PWR,
-- 
1.7.0.4

