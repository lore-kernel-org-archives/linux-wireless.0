Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60373 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758056AbYFOPXh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jun 2008 11:23:37 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>
Subject: [PATCH 2/2] mac80211: 11h - Handling measurement request
Date: Sun, 15 Jun 2008 18:23:30 +0300
Message-Id: <1213543410-30890-2-git-send-email-tomas.winkler@intel.com> (sfid-20080615_172403_759235_F878756B)
In-Reply-To: <1213543410-30890-1-git-send-email-tomas.winkler@intel.com>
References: <1213543410-30890-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

This patch handles the 11h measurement request information element.
This is minimal requested implementation - refuse measurement.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/mlme.c     |   75 +++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h |    3 ++
 2 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 866eaa0..86ea68b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1720,6 +1720,68 @@ void ieee80211_sta_tear_down_BA_sessions(struct net_device *dev, u8 *addr)
 	}
 }
 
+static void ieee80211_send_measurement_req(struct net_device *dev,
+				struct ieee80211_msrment_ie *request_ie,
+				const u8 *da, const u8 *bssid,
+				u8 dialog_token)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *msr_report;
+
+	skb = dev_alloc_skb(sizeof(*msr_report) + local->hw.extra_tx_headroom +
+				sizeof(struct ieee80211_msrment_ie));
+
+	if (!skb) {
+		printk(KERN_ERR "%s: failed to allocate buffer for "
+				"measurement report frame\n", dev->name);
+		return;
+	}
+
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	msr_report = (struct ieee80211_mgmt *)skb_put(skb, 24);
+	memset(msr_report, 0, 24);
+	memcpy(msr_report->da, da, ETH_ALEN);
+	memcpy(msr_report->sa, dev->dev_addr, ETH_ALEN);
+	memcpy(msr_report->bssid, bssid, ETH_ALEN);
+	msr_report->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
+						IEEE80211_STYPE_ACTION);
+
+	skb_put(skb, 1 + sizeof(msr_report->u.action.u.measurement));
+	msr_report->u.action.category = WLAN_CATEGORY_SPECTRUM_MGMT;
+	msr_report->u.action.u.measurement.action_code =
+				WLAN_ACTION_SPCT_MSR_RPRT;
+	msr_report->u.action.u.measurement.dialog_token = dialog_token;
+
+	msr_report->u.action.u.measurement.element_id = WLAN_EID_MEASURE_REPORT;
+	msr_report->u.action.u.measurement.length =
+			sizeof(struct ieee80211_msrment_ie);
+
+	memset(&msr_report->u.action.u.measurement.msr_elem, 0,
+		sizeof(struct ieee80211_msrment_ie));
+	msr_report->u.action.u.measurement.msr_elem.token = request_ie->token;
+	msr_report->u.action.u.measurement.msr_elem.mode |= MSR_REPORT_REFUSED;
+	msr_report->u.action.u.measurement.msr_elem.type = request_ie->type;
+
+	ieee80211_sta_tx(dev, skb, 0);
+}
+
+static void ieee80211_sta_process_measurement_req(struct net_device *dev,
+						struct ieee80211_mgmt *mgmt,
+						size_t len)
+{
+	/*
+	 * Ignoring measurement request is spec violation.
+	 * A measurement needs to be refused or preformed.
+	 * For now just refuse
+	 */
+	ieee80211_send_measurement_req(dev,
+		&mgmt->u.action.u.measurement.msr_elem,
+		mgmt->sa, mgmt->bssid,
+		mgmt->u.action.u.measurement.dialog_token);
+}
+
+
 static void ieee80211_rx_mgmt_auth(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta,
 				   struct ieee80211_mgmt *mgmt,
@@ -3044,11 +3106,24 @@ static void ieee80211_rx_mgmt_action(struct net_device *dev,
 				     struct ieee80211_rx_status *rx_status)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
 	if (len < IEEE80211_MIN_ACTION_SIZE)
 		return;
 
 	switch (mgmt->u.action.category) {
+	case WLAN_CATEGORY_SPECTRUM_MGMT:
+		if (local->hw.conf.channel->band != IEEE80211_BAND_5GHZ)
+			break;
+		switch (mgmt->u.action.u.chan_switch.action_code) {
+		case WLAN_ACTION_SPCT_MSR_REQ:
+			if (len < (IEEE80211_MIN_ACTION_SIZE +
+				   sizeof(mgmt->u.action.u.measurement)))
+				break;
+			ieee80211_sta_process_measurement_req(dev, mgmt, len);
+			break;
+		}
+		break;
 	case WLAN_CATEGORY_BACK:
 		switch (mgmt->u.action.u.addba_req.action_code) {
 		case WLAN_ACTION_ADDBA_REQ:
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 95753f8..e38e464 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -65,6 +65,9 @@ enum ieee80211_sta_info_flags {
 					 HT_ADDBA_RECEIVED_MSK)
 #define HT_AGG_STATE_DEBUGFS_CTL	BIT(7)
 
+/* measurement report mode field - refuse to generate a report */
+#define MSR_REPORT_REFUSED       BIT(2)
+
 /**
  * struct tid_ampdu_tx - TID aggregation information (Tx).
  *
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

