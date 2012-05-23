Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:53167 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab2EWINj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 04:13:39 -0400
Received: by weyu7 with SMTP id u7so4400190wey.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 May 2012 01:13:38 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: allow setting default U-APSD queues/max_sp_len for STA
Date: Wed, 23 May 2012 11:13:33 +0300
Message-Id: <1337760813-27055-1-git-send-email-arik@wizery.com> (sfid-20120523_101346_548028_26D95699)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow the low level driver to set U-APSD parameters when operating in
managed mode.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/net/mac80211.h |    9 +++++++++
 net/mac80211/main.c    |    8 ++++++++
 net/mac80211/mlme.c    |    4 ++--
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4d6e6c6..36c3318 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1288,6 +1288,13 @@ enum ieee80211_hw_flags {
  *
  * @offchannel_tx_hw_queue: HW queue ID to use for offchannel TX
  *	(if %IEEE80211_HW_QUEUE_CONTROL is set)
+ *
+ * @sta_uapsd_queues: Bitmask of enabled U-APSD queues when operating in
+ *	managed mode (%IEEE80211_WMM_IE_STA_QOSINFO_AC_VO & co). Defaults
+ *	to all four ACs.
+ *
+ * @sta_uapsd_max_sp_len: Maximum number of buffered frames AP can deliver in
+ *	a service period. Defaults to %IEEE80211_WMM_IE_STA_QOSINFO_SP_ALL
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -1309,6 +1316,8 @@ struct ieee80211_hw {
 	u8 max_rx_aggregation_subframes;
 	u8 max_tx_aggregation_subframes;
 	u8 offchannel_tx_hw_queue;
+	unsigned int sta_uapsd_queues;
+	unsigned int sta_uapsd_max_sp_len;
 };
 
 /**
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index b70f7f0..56e6c61 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -594,6 +594,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	local->hw.max_rx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF;
 	local->hw.max_tx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF;
 	local->hw.offchannel_tx_hw_queue = IEEE80211_INVAL_HW_QUEUE;
+	local->hw.sta_uapsd_queues = IEEE80211_DEFAULT_UAPSD_QUEUES;
+	local->hw.sta_uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;
 	local->hw.conf.long_frame_max_tx_count = wiphy->retry_long;
 	local->hw.conf.short_frame_max_tx_count = wiphy->retry_short;
 	local->user_power_level = -1;
@@ -708,6 +710,12 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (hw->max_report_rates == 0)
 		hw->max_report_rates = hw->max_rates;
 
+	if (hw->sta_uapsd_queues & ~IEEE80211_WMM_IE_STA_QOSINFO_AC_MASK)
+		return -EINVAL;
+
+	if (hw->sta_uapsd_max_sp_len & ~IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK)
+		return -EINVAL;
+
 	/*
 	 * generic code guarantees at least one band,
 	 * set this very early because much code assumes
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2b5235e..da52587 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2974,8 +2974,8 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 
 	ifmgd->flags = 0;
 	ifmgd->powersave = sdata->wdev.ps;
-	ifmgd->uapsd_queues = IEEE80211_DEFAULT_UAPSD_QUEUES;
-	ifmgd->uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;
+	ifmgd->uapsd_queues = sdata->local->hw.sta_uapsd_queues;
+	ifmgd->uapsd_max_sp_len = sdata->local->hw.sta_uapsd_max_sp_len;
 
 	mutex_init(&ifmgd->mtx);
 
-- 
1.7.9.5

