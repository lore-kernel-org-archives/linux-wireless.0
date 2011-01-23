Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:34555 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab1AWGZM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 01:25:12 -0500
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p0N6PBY9005388
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 23 Jan 2011 00:25:11 -0600
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH v5  2/2] wl12xx: BA receiver support
Date: Sun, 23 Jan 2011 08:27:23 +0200
Message-Id: <1295764043-29918-3-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1295764043-29918-1-git-send-email-shahar_levi@ti.com>
References: <1295764043-29918-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new ampdu_action ops to support receiver BA.
The BA initiator session management in FW independently.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
Dependencies:
- BA Initiator patches have a runtime dependency on commit
  "[RFC v6] wl1271: BA Initiator support"

Limitation:
- For now only one BA per direction is supported

Changes from v1:
- Add mutex and (wl->state == WL1271_STATE_OFF) protection
- "BIT(tid)" instead of "BIT(0) << tid"
- Move all event code move to the next patch

Changes from v2:
- Add supported FW version auto detection mechanism

Changes from v3:
- Stylish

Changes from v4:
- More stylish

 drivers/net/wireless/wl12xx/acx.c    |   34 +++++++++++++++++++
 drivers/net/wireless/wl12xx/acx.h    |   21 ++++++++++++
 drivers/net/wireless/wl12xx/init.c   |    1 -
 drivers/net/wireless/wl12xx/main.c   |   60 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl12xx.h |    1 -
 5 files changed, 115 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 588056a..bff586a 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1393,6 +1393,40 @@ out:
 	return ret;
 }
 
+/* setup BA session receiver setting in the FW. */
+int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index, u16 ssn,
+					bool enable)
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
+	acx->enable = enable;
+	acx->win_size = 0;
+	acx->ssn = ssn;
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
index c0abaf4..c683801 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1095,6 +1095,25 @@ struct wl1271_acx_ba_session_policy {
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
 
@@ -1246,6 +1265,8 @@ int wl1271_acx_set_ht_information(struct wl1271 *wl,
 int wl1271_acx_set_ba_session(struct wl1271 *wl,
 			      enum ieee80211_back_parties direction,
 			      u8 tid_index, u8 policy);
+int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index, u16 ssn,
+				       bool enable);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
 int wl1271_acx_max_tx_retry(struct wl1271 *wl);
 
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 0d939a2..fe6ea71 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -473,7 +473,6 @@ static int wl1271_set_ba_policies(struct wl1271 *wl)
 	u8 ret = 0;
 
 	/* Reset the BA RX indicators */
-	wl->ba_allowed = true;
 	wl->ba_rx_bitmap = 0;
 
 	/* validate that FW support BA */
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 542b1de..fc7da94 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2717,6 +2717,65 @@ out:
 	return ret;
 }
 
+int wl1271_op_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			    enum ieee80211_ampdu_mlme_action action,
+			    struct ieee80211_sta *sta, u16 tid, u16 *ssn)
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
+		if (wl->ba_support) {
+			ret = wl1271_acx_set_ba_receiver_session(wl, tid, *ssn,
+								 true);
+			if (!ret)
+				wl->ba_rx_bitmap |= BIT(tid);
+		} else {
+			ret = -ENOTSUPP;
+		}
+		break;
+
+	case IEEE80211_AMPDU_RX_STOP:
+		ret = wl1271_acx_set_ba_receiver_session(wl, tid, 0, false);
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
+		ret = -EINVAL;
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
@@ -2965,6 +3024,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.get_survey = wl1271_op_get_survey,
 	.sta_add = wl1271_op_sta_add,
 	.sta_remove = wl1271_op_sta_remove,
+	.ampdu_action = wl1271_op_ampdu_action,
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 443befc..a3d1179 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -473,7 +473,6 @@ struct wl1271 {
 
 	/* RX BA constraint value */
 	bool ba_support;
-	u8 ba_allowed;
 	u8 ba_rx_bitmap;
 };
 
-- 
1.7.0.4

