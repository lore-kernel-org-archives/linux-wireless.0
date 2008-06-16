Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61996 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbYFPNJz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 09:09:55 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>
Subject: [PATCH 2/2 V3] mac80211: 11h - Handling measurement request
Date: Mon, 16 Jun 2008 16:09:49 +0300
Message-Id: <1213621789-12688-1-git-send-email-tomas.winkler@intel.com> (sfid-20080616_150958_601745_1C79B4DF)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

This patch handles the 11h measurement request information element.
This is minimal requested implementation - refuse measurement.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 include/linux/ieee80211.h |   10 ++++++
 net/mac80211/mlme.c       |   78 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 9dcf3f8..b7e4e61 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -389,11 +389,21 @@ struct ieee80211_ht_addt_info {
 #define WLAN_CAPABILITY_SHORT_PREAMBLE	(1<<5)
 #define WLAN_CAPABILITY_PBCC		(1<<6)
 #define WLAN_CAPABILITY_CHANNEL_AGILITY	(1<<7)
+
 /* 802.11h */
 #define WLAN_CAPABILITY_SPECTRUM_MGMT	(1<<8)
 #define WLAN_CAPABILITY_QOS		(1<<9)
 #define WLAN_CAPABILITY_SHORT_SLOT_TIME	(1<<10)
 #define WLAN_CAPABILITY_DSSS_OFDM	(1<<13)
+/* measurement */
+#define IEEE80211_SPCT_MSR_RPRT_MODE_LATE	(1<<0)
+#define IEEE80211_SPCT_MSR_RPRT_MODE_INCAPABLE	(1<<1)
+#define IEEE80211_SPCT_MSR_RPRT_MODE_REFUSED	(1<<2)
+
+#define IEEE80211_SPCT_MSR_RPRT_TYPE_BASIC	0
+#define IEEE80211_SPCT_MSR_RPRT_TYPE_CCA	1
+#define IEEE80211_SPCT_MSR_RPRT_TYPE_RPI	2
+
 
 /* 802.11g ERP information element */
 #define WLAN_ERP_NON_ERP_PRESENT (1<<0)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 37ebec5..2cc689f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1720,6 +1720,71 @@ void ieee80211_sta_tear_down_BA_sessions(struct net_device *dev, u8 *addr)
 	}
 }
 
+static void ieee80211_send_refuse_measurement_request(struct net_device *dev,
+					struct ieee80211_msrment_ie *request_ie,
+					const u8 *da, const u8 *bssid,
+					u8 dialog_token)
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
+	msr_report->u.action.u.measurement.msr_elem.mode |=
+			IEEE80211_SPCT_MSR_RPRT_MODE_REFUSED;
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
+	 * Mandatory measurements must be reported optional
+	 * measurements might be refused or reported incapable
+	 * For now just refuse
+	 * TODO: Answer basic measurement as unmeasured
+	 */
+	ieee80211_send_refuse_measurement_request(dev,
+			&mgmt->u.action.u.measurement.msr_elem,
+			mgmt->sa, mgmt->bssid,
+			mgmt->u.action.u.measurement.dialog_token);
+}
+
+
 static void ieee80211_rx_mgmt_auth(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta,
 				   struct ieee80211_mgmt *mgmt,
@@ -3043,11 +3108,24 @@ static void ieee80211_rx_mgmt_action(struct net_device *dev,
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
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

