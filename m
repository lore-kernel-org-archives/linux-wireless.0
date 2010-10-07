Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:41340 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760433Ab0JGNEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 09:04:13 -0400
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH 02/03] wl1271: BA Initiator support, BA functions
Date: Thu,  7 Oct 2010 15:06:01 +0200
Message-Id: <1286456762-17480-3-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1286456762-17480-1-git-send-email-shahar_levi@ti.com>
References: <1286456762-17480-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New ops support ampdu_action as initiator returns EINVAL due to
the fact that BA initiator session manage in the FW independently.
acx function set BA policies.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.c  |   55 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.h  |    4 ++
 drivers/net/wireless/wl12xx/wl1271_main.c |   42 ++++++++++++++++++++++
 3 files changed, 101 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index cc6b7d8..f82656e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -1317,6 +1317,61 @@ out:
 	return ret;
 }
 
+/*
+ * wl1271_acx_set_ba_session
+ * configure BA session initiator\receiver parameters setting in the FW.
+ */
+int wl1271_acx_set_ba_session(struct wl1271 *wl,
+							  u16 id,
+							  u8 tid_index,
+							  u8 policy)
+{
+	struct wl1271_acx_ba_session_policy *acx;
+	int ret = 0;
+	/*
+	* Note, currently this value will be set to FFFFFFFFFFFF to indicate
+	* it is relevant for all peers.
+	*/
+	u8 mac_address[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+
+	wl1271_debug(DEBUG_ACX, "acx ba session setting");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(acx->mac_address, mac_address, ETH_ALEN);
+	acx->tid = tid_index;
+	acx->policy = policy;
+	acx->win_size = BA_RECEIVER_WIN_SIZE;
+
+	if (ACX_BA_SESSION_INITIATOR_POLICY == id)
+		acx->inactivity_timeout = BA_INACTIVITY_TIMEOUT;
+	else
+		if (ACX_BA_SESSION_RESPONDER_POLICY == id)
+			acx->inactivity_timeout = 0;
+		else {
+			wl1271_error("Incorrect acx command id=%x\n", id);
+			ret = -EINVAL;
+			goto out;
+		}
+
+	ret = wl1271_cmd_configure(wl,
+				   id,
+				   acx,
+				   sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx ba session setting failed: %d", ret);
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
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 6c3c7c0..f417624 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -1205,6 +1205,10 @@ int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
 				    bool allow_ht_operation);
 int wl1271_acx_set_ht_information(struct wl1271 *wl,
 				   u16 ht_operation_mode);
+int wl1271_acx_set_ba_session(struct wl1271 *wl,
+							  u16 id,
+							  u8 tid_index,
+							  u8 policy);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index af092f4..53c03e5 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1128,6 +1128,22 @@ static void wl1271_configure_filters(struct wl1271 *wl, unsigned int filters)
 	}
 }
 
+/*
+ * wl1271_set_ba_policies
+ * Set the BA session policies to the FW.
+ */
+static void wl1271_set_ba_policies(struct wl1271 *wl)
+{
+	u8	tid_index;
+
+	/* 802.11n BA session setting */
+	for (tid_index = 0; tid_index < CONF_TX_MAX_TID_COUNT; ++tid_index)
+			wl1271_acx_set_ba_session(wl,
+				ACX_BA_SESSION_INITIATOR_POLICY,
+				tid_index,
+				true);
+}
+
 static int wl1271_dummy_join(struct wl1271 *wl)
 {
 	int ret = 0;
@@ -2056,6 +2072,32 @@ static int wl1271_op_get_survey(struct ieee80211_hw *hw, int idx,
 	return 0;
 }
 
+int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif,
+			    enum ieee80211_ampdu_mlme_action action,
+			    struct ieee80211_sta *sta, u16 tid, u16 *ssn)
+{
+		int ret;
+
+		switch (action) {
+		case IEEE80211_AMPDU_RX_START:
+		case IEEE80211_AMPDU_RX_STOP:
+
+		/* The BA initiator session management in FW independently */
+		case IEEE80211_AMPDU_TX_START:
+		case IEEE80211_AMPDU_TX_STOP:
+		case IEEE80211_AMPDU_TX_OPERATIONAL:
+			ret = -EINVAL;
+		break;
+
+		default:
+			wl1271_error("Incorrect ampdu action id=%x\n", action);
+			ret = -ENODEV;
+		}
+
+		return ret;
+}
+
 /* can't be const, mac80211 writes to this */
 static struct ieee80211_rate wl1271_rates[] = {
 	{ .bitrate = 10,
-- 
1.6.0.4

