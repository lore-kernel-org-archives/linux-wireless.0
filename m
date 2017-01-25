Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33778 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751659AbdAYLoC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jan 2017 06:44:02 -0500
Received: by mail-lf0-f67.google.com with SMTP id x1so20654626lff.0
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jan 2017 03:43:56 -0800 (PST)
Received: from localhost.localdomain ([92.176.165.227])
        by smtp.gmail.com with ESMTPSA id l9sm31033784wmf.18.2017.01.25.03.43.54
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Jan 2017 03:43:54 -0800 (PST)
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v4 4/5] mac80211: Add set_cqm_rssi_range_config
Date: Wed, 25 Jan 2017 12:43:43 +0100
Message-Id: <20170125114344.8179-4-andrew.zaborowski@intel.com> (sfid-20170125_124407_016817_972B63B2)
In-Reply-To: <20170125114344.8179-1-andrew.zaborowski@intel.com>
References: <20170125114344.8179-1-andrew.zaborowski@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support .set_cqm_rssi_range_config if the beacons are available for
processing in mac80211.  There's no reason that this couldn't be
offloaded by mac80211-based drivers but there's no driver method for
that added in this patch as I don't have the hardware.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
changes in v3:
 - set NL80211_EXT_FEATURE_CQM_RSSI_LIST automatically in
   ieee80211_register_hw based on the default interface's
   IEEE80211_VIF_BEACON_FILTER flag.
changes in v4:
 - drop the above attempt and set NL80211_EXT_FEATURE_CQM_RSSI_LIST
   in a separate patch in each driver.
---
 include/net/mac80211.h |  6 ++++++
 net/mac80211/cfg.c     | 28 ++++++++++++++++++++++++++++
 net/mac80211/mlme.c    | 24 ++++++++++++++++++++++++
 3 files changed, 58 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8810ae7..d3992c4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -502,6 +502,10 @@ struct ieee80211_mu_group_data {
  *	implies disabled. As with the cfg80211 callback, a change here should
  *	cause an event to be sent indicating where the current value is in
  *	relation to the newly configured threshold.
+ * @cqm_rssi_low: Connection quality monitor RSSI lower threshold, a zero value
+ *	implies disabled.  This is an alternative mechanism to the single
+ *	threshold event and can't be enabled simultaneously with it.
+ * @cqm_rssi_high: Connection quality monitor RSSI upper threshold.
  * @cqm_rssi_hyst: Connection quality monitor RSSI hysteresis
  * @arp_addr_list: List of IPv4 addresses for hardware ARP filtering. The
  *	may filter ARP queries targeted for other addresses than listed here.
@@ -554,6 +558,8 @@ struct ieee80211_bss_conf {
 	u16 ht_operation_mode;
 	s32 cqm_rssi_thold;
 	u32 cqm_rssi_hyst;
+	s32 cqm_rssi_low;
+	s32 cqm_rssi_high;
 	struct cfg80211_chan_def chandef;
 	struct ieee80211_mu_group_data mu_group;
 	__be32 arp_addr_list[IEEE80211_BSS_ARP_ADDR_LIST_LEN];
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e91e503..cf02aaa 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2630,6 +2630,33 @@ static int ieee80211_set_cqm_rssi_config(struct wiphy *wiphy,
 
 	bss_conf->cqm_rssi_thold = rssi_thold;
 	bss_conf->cqm_rssi_hyst = rssi_hyst;
+	bss_conf->cqm_rssi_low = 0;
+	bss_conf->cqm_rssi_high = 0;
+	sdata->u.mgd.last_cqm_event_signal = 0;
+
+	/* tell the driver upon association, unless already associated */
+	if (sdata->u.mgd.associated &&
+	    sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_CQM_RSSI)
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_CQM);
+
+	return 0;
+}
+
+static int ieee80211_set_cqm_rssi_range_config(struct wiphy *wiphy,
+					       struct net_device *dev,
+					       s32 rssi_low, s32 rssi_high)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_vif *vif = &sdata->vif;
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+
+	if (sdata->vif.driver_flags & IEEE80211_VIF_BEACON_FILTER)
+		return -EOPNOTSUPP;
+
+	bss_conf->cqm_rssi_low = rssi_low;
+	bss_conf->cqm_rssi_high = rssi_high;
+	bss_conf->cqm_rssi_thold = 0;
+	bss_conf->cqm_rssi_hyst = 0;
 	sdata->u.mgd.last_cqm_event_signal = 0;
 
 	/* tell the driver upon association, unless already associated */
@@ -3628,6 +3655,7 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.mgmt_tx = ieee80211_mgmt_tx,
 	.mgmt_tx_cancel_wait = ieee80211_mgmt_tx_cancel_wait,
 	.set_cqm_rssi_config = ieee80211_set_cqm_rssi_config,
+	.set_cqm_rssi_range_config = ieee80211_set_cqm_rssi_range_config,
 	.mgmt_frame_register = ieee80211_mgmt_frame_register,
 	.set_antenna = ieee80211_set_antenna,
 	.get_antenna = ieee80211_get_antenna,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0cfa215..260e20d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3434,6 +3434,30 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+	if (bss_conf->cqm_rssi_low &&
+	    ifmgd->count_beacon_signal >= IEEE80211_SIGNAL_AVE_MIN_COUNT) {
+		int sig = -ewma_beacon_signal_read(&ifmgd->ave_beacon_signal);
+		int last_event = ifmgd->last_cqm_event_signal;
+		int low = bss_conf->cqm_rssi_low;
+		int high = bss_conf->cqm_rssi_high;
+
+		if (sig < low &&
+		    (last_event == 0 || last_event >= low)) {
+			ifmgd->last_cqm_event_signal = sig;
+			ieee80211_cqm_rssi_notify(
+				&sdata->vif,
+				NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
+				sig, GFP_KERNEL);
+		} else if (sig > high &&
+			   (last_event == 0 || last_event <= high)) {
+			ifmgd->last_cqm_event_signal = sig;
+			ieee80211_cqm_rssi_notify(
+				&sdata->vif,
+				NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
+				sig, GFP_KERNEL);
+		}
+	}
+
 	if (ifmgd->flags & IEEE80211_STA_CONNECTION_POLL) {
 		mlme_dbg_ratelimited(sdata,
 				     "cancelling AP probe due to a received beacon\n");
-- 
2.9.3
