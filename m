Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:52846 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab3FKMWF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 08:22:05 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>,
	Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Subject: [PATCHv5 3/4] ath6kl: make mgmt_tx accept a NULL channel
Date: Tue, 11 Jun 2013 14:20:02 +0200
Message-Id: <1370953203-4086-3-git-send-email-ordex@autistici.org> (sfid-20130611_142212_102631_4D790F0B)
In-Reply-To: <1370953203-4086-1-git-send-email-ordex@autistici.org>
References: <1370953203-4086-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

cfg80211 passes a NULL channel to mgmt_tx if the frame has
to be sent on the one currently in use by the device.
Make the implementation of mgmt_tx correctly handle this
case

Cc: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index f7995b2..2437ad2 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3175,10 +3175,21 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 {
 	struct ath6kl_vif *vif = ath6kl_vif_from_wdev(wdev);
 	struct ath6kl *ar = ath6kl_priv(vif->ndev);
-	u32 id;
+	u32 id, freq;
 	const struct ieee80211_mgmt *mgmt;
 	bool more_data, queued;
 
+	/* default to the current channel, but use the one specified as argument
+	 * if any
+	 */
+	freq = vif->ch_hint;
+	if (chan)
+		freq = chan->center_freq;
+
+	/* never send freq zero to the firmware */
+	if (WARN_ON(freq == 0))
+		return -EINVAL;
+
 	mgmt = (const struct ieee80211_mgmt *) buf;
 	if (vif->nw_type == AP_NETWORK && test_bit(CONNECTED, &vif->flags) &&
 	    ieee80211_is_probe_resp(mgmt->frame_control) &&
@@ -3188,8 +3199,7 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		 * command to allow the target to fill in the generic IEs.
 		 */
 		*cookie = 0; /* TX status not supported */
-		return ath6kl_send_go_probe_resp(vif, buf, len,
-						 chan->center_freq);
+		return ath6kl_send_go_probe_resp(vif, buf, len, freq);
 	}
 
 	id = vif->send_action_id++;
@@ -3205,17 +3215,14 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	/* AP mode Power saving processing */
 	if (vif->nw_type == AP_NETWORK) {
-		queued = ath6kl_mgmt_powersave_ap(vif,
-					id, chan->center_freq,
-					wait, buf,
-					len, &more_data, no_cck);
+		queued = ath6kl_mgmt_powersave_ap(vif, id, freq, wait, buf, len,
+						  &more_data, no_cck);
 		if (queued)
 			return 0;
 	}
 
-	return ath6kl_wmi_send_mgmt_cmd(ar->wmi, vif->fw_vif_idx, id,
-					chan->center_freq, wait,
-					buf, len, no_cck);
+	return ath6kl_wmi_send_mgmt_cmd(ar->wmi, vif->fw_vif_idx, id, freq,
+					wait, buf, len, no_cck);
 }
 
 static void ath6kl_mgmt_frame_register(struct wiphy *wiphy,
-- 
1.8.1.5

