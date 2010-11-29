Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:53470 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab0K2NmY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 08:42:24 -0500
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH v2  1/1] wl12xx: BA receiver support
Date: Mon, 29 Nov 2010 15:42:38 +0200
Message-Id: <1291038158-20727-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new ampdu_action ops to support receiver BA.
The BA initiator session management in FW independently.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
Dependencies:
- BA Initiator patches have a runtime dependency on commit
   "[RFC v4] wl1271: BA Initiator support"

Changes from v1:
- Add mutex and (wl->state == WL1271_STATE_OFF) protection
- "BIT(tid)" instead of "BIT(0) << tid"
- Move all event code move to the next patch
                                       
 drivers/net/wireless/wl12xx/acx.c  |   36 ++++++++++++++++++++++
 drivers/net/wireless/wl12xx/acx.h  |   21 +++++++++++++
 drivers/net/wireless/wl12xx/main.c |   59 ++++++++++++++++++++++++++++++++++++
 3 files changed, 116 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 6c433b7..c51796e 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1359,6 +1359,42 @@ out:
 	return ret;
 }
 
+/* setup BA session receiver setting in the FW. */
+int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index,
+				       u16 *ssn, u8 policy)
+{
+	struct wl1271_acx_ba_receiver_setup *acx;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx ba receiver session setting");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* Single link for now */
+	acx->link_id = 1;
+	acx->tid = tid_index;
+	acx->enable = policy;
+	acx->win_size = 0;
+
+	if (policy)
+		acx->ssn = *ssn;
+
+	ret = wl1271_cmd_configure(wl, ACX_BA_SESSION_RX_SETUP, acx,
+				   sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx ba receiver session failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime)
 {
 	struct wl1271_acx_fw_tsf_information *tsf_info;
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index c511dce..6da8423 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1080,6 +1080,25 @@ struct wl1271_acx_ba_session_policy {
 	u8 padding[3];
 } __packed;
 
+struct wl1271_acx_ba_receiver_setup {
+	struct acx_header header;
+
+	/* Specifies Link Id, Range 0-31, 0xFF means ANY  Link Id */
+	u8 link_id;
+
+	u8 tid;
+
+	u8 enable;
+
+	u8 padding[1];
+
+	/* Windows size in number of packets */
+	u16 win_size;
+
+	/* BA session starting sequence number.  RANGE 0-FFF */
+	u16 ssn;
+} __packed;
+
 struct wl1271_acx_fw_tsf_information {
 	struct acx_header header;
 
@@ -1217,6 +1236,8 @@ int wl1271_acx_set_ht_information(struct wl1271 *wl,
 int wl1271_acx_set_ba_session(struct wl1271 *wl,
 			      enum ieee80211_back_parties direction,
 			      u8 tid_index, u8 policy);
+int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index,
+				       u16 *ssn, u8 policy);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index c1812c8..af6dbad 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2228,6 +2228,64 @@ static int wl1271_op_get_survey(struct ieee80211_hw *hw, int idx,
 	return 0;
 }
 
+int wl1271_op_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			   enum ieee80211_ampdu_mlme_action action,
+			   struct ieee80211_sta *sta, u16 tid, u16 *ssn)
+{
+	struct wl1271 *wl = hw->priv;
+	int ret;
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state == WL1271_STATE_OFF)) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	ret = wl1271_ps_elp_wakeup(wl, false);
+	if (ret < 0)
+		goto out;
+
+	switch (action) {
+	case IEEE80211_AMPDU_RX_START:
+		if (wl->ba_allowed) {
+			ret = wl1271_acx_set_ba_receiver_session(wl, tid, ssn,
+								 true);
+			if (!ret)
+				wl->ba_rx_bitmap |= BIT(tid);
+		} else
+			ret = -EPERM;
+		break;
+
+	case IEEE80211_AMPDU_RX_STOP:
+		ret = wl1271_acx_set_ba_receiver_session(wl, tid, ssn, false);
+		if (!ret)
+			wl->ba_rx_bitmap &= ~BIT(tid);
+		break;
+
+	/*
+	 * The BA initiator session management in FW independently.
+	 * Falling break here on purpose for all TX APDU commands.
+	 */
+	case IEEE80211_AMPDU_TX_START:
+	case IEEE80211_AMPDU_TX_STOP:
+	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		ret = -EINVAL;
+		break;
+
+	default:
+		wl1271_error("Incorrect ampdu action id=%x\n", action);
+		ret = -ENODEV;
+	}
+
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
 /* can't be const, mac80211 writes to this */
 static struct ieee80211_rate wl1271_rates[] = {
 	{ .bitrate = 10,
@@ -2482,6 +2540,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.conf_tx = wl1271_op_conf_tx,
 	.get_tsf = wl1271_op_get_tsf,
 	.get_survey = wl1271_op_get_survey,
+	.ampdu_action = wl1271_op_ampdu_action,
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
-- 
1.7.0.4

