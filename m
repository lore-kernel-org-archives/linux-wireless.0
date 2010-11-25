Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:57618 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab0KYNvu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 08:51:50 -0500
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH ] wl12xx: BA receiver support
Date: Thu, 25 Nov 2010 15:51:32 +0200
Message-Id: <1290693092-3904-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new ampdu_action ops to support receiver BA.
The BA initiator session management in FW independently.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
Dependencies:
- BA Initiator patches have a runtime dependency on commit
   "[RFC v3] wl1271: BA Initiator support"

 drivers/net/wireless/wl12xx/acx.c   |   38 ++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/acx.h   |   21 ++++++++++++++
 drivers/net/wireless/wl12xx/event.c |    3 +++
 drivers/net/wireless/wl12xx/event.h |   17 ++++++++++-
 drivers/net/wireless/wl12xx/main.c  |   50 +++++++++++++++++++++++++++++++++++
 5 files changed, 128 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 6c433b7..85d87dd 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1359,6 +1359,44 @@ out:
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
+	ret = wl1271_cmd_configure(wl,
+				   ACX_BA_SESSION_RX_SETUP,
+				   acx,
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
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index f9146f5..4e053ff 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -241,6 +241,9 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 			wl1271_event_rssi_trigger(wl, mbox);
 	}
 
+	if (vector & BA_SESSION_RX_CONSTRAINT_EVENT_ID)
+		wl1271_debug(DEBUG_EVENT, "BA_SESSION_RX_CONSTRAINT_EVENT_ID");
+
 	if (wl->vif && beacon_loss)
 		ieee80211_connection_loss(wl->vif);
 
diff --git a/drivers/net/wireless/wl12xx/event.h b/drivers/net/wireless/wl12xx/event.h
index 6cce014..4c697d7 100644
--- a/drivers/net/wireless/wl12xx/event.h
+++ b/drivers/net/wireless/wl12xx/event.h
@@ -67,7 +67,7 @@ enum {
 	HEALTH_CHECK_REPLY_EVENT_ID		 = BIT(27),
 	PERIODIC_SCAN_COMPLETE_EVENT_ID		 = BIT(28),
 	PERIODIC_SCAN_REPORT_EVENT_ID		 = BIT(29),
-	BA_SESSION_TEAR_DOWN_EVENT_ID		 = BIT(30),
+	BA_SESSION_RX_CONSTRAINT_EVENT_ID	 = BIT(30),
 	EVENT_MBOX_ALL_EVENT_ID			 = 0x7fffffff,
 };
 
@@ -115,7 +115,20 @@ struct event_mailbox {
 	u8 scheduled_scan_status;
 	u8 ps_status;
 
-	u8 reserved_5[29];
+	/*
+	 * Bitmap, Each bit set represents the Role ID for which this constraint
+	 * is set. Range: 0 - FF, FF means ANY role
+	 */
+	u8 ba_role_id;
+	/*
+	 * Bitmap, Each bit set represents the Link ID for which this constraint
+	 * is set. Not applicable if ba_role_id is set to ANY role (FF).
+	 * Range: 0 - FFFF, FFFF means ANY link in that role
+	 */
+	u8 ba_link_id;
+	u8 ba_allowed;
+
+	u8 reserved_5[26];
 } __packed;
 
 int wl1271_event_unmask(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index b8c42d7..8ef2fcd 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2204,6 +2204,55 @@ static int wl1271_op_get_survey(struct ieee80211_hw *hw, int idx,
 	return 0;
 }
 
+int wl1271_op_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			   enum ieee80211_ampdu_mlme_action action,
+			   struct ieee80211_sta *sta, u16 tid, u16 *ssn)
+{
+	struct wl1271 *wl = hw->priv;
+	int ret;
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
+				wl->ba_rx_bitmap |= (u8)(BIT(0) << tid);
+		} else
+			ret = -EPERM;
+		break;
+
+	case IEEE80211_AMPDU_RX_STOP:
+		ret = wl1271_acx_set_ba_receiver_session(wl, tid, ssn, false);
+		if (!ret)
+			wl->ba_rx_bitmap &= ~(u8)(BIT(0) << tid);
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
+	return ret;
+}
+
 /* can't be const, mac80211 writes to this */
 static struct ieee80211_rate wl1271_rates[] = {
 	{ .bitrate = 10,
@@ -2458,6 +2507,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.conf_tx = wl1271_op_conf_tx,
 	.get_tsf = wl1271_op_get_tsf,
 	.get_survey = wl1271_op_get_survey,
+	.ampdu_action = wl1271_op_ampdu_action,
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
-- 
1.7.0.4

