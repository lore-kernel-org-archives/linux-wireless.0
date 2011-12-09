Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:60683 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab1LIWbf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 17:31:35 -0500
Received: by eaad1 with SMTP id d1so21317eaa.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Dec 2011 14:31:34 -0800 (PST)
Received: from wpaz9.hot.corp.google.com (wpaz9.hot.corp.google.com [172.24.198.73])
	by hpza10.eem.corp.google.com (Postfix) with ESMTPS id 95FCA20004E
	for <linux-wireless@vger.kernel.org>; Fri,  9 Dec 2011 14:31:33 -0800 (PST)
Received: from glenhelen.mtv.corp.google.com (glenhelen.mtv.corp.google.com [172.22.72.223])
	by wpaz9.hot.corp.google.com with ESMTP id pB9MVVsH032537
	for <linux-wireless@vger.kernel.org>; Fri, 9 Dec 2011 14:31:32 -0800
From: Paul Stewart <pstew@chromium.org>
Date: Fri, 9 Dec 2011 11:01:49 -0800
Subject: [PATCH] cfg80211: Return beacon loss count in station
To: linux-wireless@vger.kernel.org
Message-Id: <20111209223131.71B17206F0@glenhelen.mtv.corp.google.com> (sfid-20111209_233139_912049_EC569042)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If station info contains a beacon loss count, return
it to userspace.

Signed-off-by: Paul Stewart <pstew@chromium.org>
---
 include/linux/nl80211.h |    2 ++
 include/net/cfg80211.h  |    7 ++++++-
 net/mac80211/cfg.c      |    4 +++-
 net/mac80211/mlme.c     |    8 ++++++++
 net/mac80211/sta_info.h |    2 ++
 net/wireless/nl80211.c  |    3 +++
 6 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index a187606..3c88e7a 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1651,6 +1651,7 @@ enum nl80211_sta_bss_param {
  *     containing info as possible, see &enum nl80211_sta_bss_param
  * @NL80211_STA_INFO_CONNECTED_TIME: time since the station is last connected
  * @NL80211_STA_INFO_STA_FLAGS: Contains a struct nl80211_sta_flag_update.
+ * @NL80211_STA_INFO_BEACON_LOSS: count of times beacon loss was detected (u32)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -1673,6 +1674,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_BSS_PARAM,
 	NL80211_STA_INFO_CONNECTED_TIME,
 	NL80211_STA_INFO_STA_FLAGS,
+	NL80211_STA_INFO_BEACON_LOSS,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3de1c39..0144de8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -505,6 +505,7 @@ struct station_parameters {
  * @STATION_INFO_CONNECTED_TIME: @connected_time filled
  * @STATION_INFO_ASSOC_REQ_IES: @assoc_req_ies filled
  * @STATION_INFO_STA_FLAGS: @sta_flags filled
+ * @STATION_INFO_BEACON_LOSS_COUNT: @beacon_loss_count filled
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	= 1<<0,
@@ -525,7 +526,8 @@ enum station_info_flags {
 	STATION_INFO_BSS_PARAM          = 1<<15,
 	STATION_INFO_CONNECTED_TIME	= 1<<16,
 	STATION_INFO_ASSOC_REQ_IES	= 1<<17,
-	STATION_INFO_STA_FLAGS		= 1<<18
+	STATION_INFO_STA_FLAGS		= 1<<18,
+	STATION_INFO_BEACON_LOSS_COUNT	= 1<<19
 };
 
 /**
@@ -623,6 +625,7 @@ struct sta_bss_parameters {
  *	the cfg80211_new_sta() calls to notify user space of the IEs.
  * @assoc_req_ies_len: Length of assoc_req_ies buffer in octets.
  * @sta_flags: station flags mask & values
+ * @beacon_loss_count: Number of times beacon loss event has triggered.
  */
 struct station_info {
 	u32 filled;
@@ -650,6 +653,8 @@ struct station_info {
 	const u8 *assoc_req_ies;
 	size_t assoc_req_ies_len;
 
+	u32 beacon_loss_count;
+
 	/*
 	 * Note: Add a new enum station_info_flags value for each new field and
 	 * use it to check which fields are initialized.
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 393b2a4..4b9c8ce 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -355,7 +355,8 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 			STATION_INFO_RX_DROP_MISC |
 			STATION_INFO_BSS_PARAM |
 			STATION_INFO_CONNECTED_TIME |
-			STATION_INFO_STA_FLAGS;
+			STATION_INFO_STA_FLAGS |
+			STATION_INFO_BEACON_LOSS_COUNT;
 
 	do_posix_clock_monotonic_gettime(&uptime);
 	sinfo->connected_time = uptime.tv_sec - sta->last_connected;
@@ -368,6 +369,7 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	sinfo->tx_retries = sta->tx_retry_count;
 	sinfo->tx_failed = sta->tx_retry_failed;
 	sinfo->rx_dropped_misc = sta->rx_dropped;
+	sinfo->beacon_loss_count = sta->beacon_loss_count;
 
 	if ((sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) ||
 	    (sta->local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)) {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 09019d1..b9f6fe3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1381,6 +1381,14 @@ void ieee80211_beacon_connection_loss_work(struct work_struct *work)
 	struct ieee80211_sub_if_data *sdata =
 		container_of(work, struct ieee80211_sub_if_data,
 			     u.mgd.beacon_connection_loss_work);
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct sta_info *sta;
+
+	if (ifmgd->associated) {
+		sta = sta_info_get(sdata, ifmgd->bssid);
+		if (sta)
+			sta->beacon_loss_count++;
+	}
 
 	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
 		__ieee80211_connection_loss(sdata);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 1a14fab..75dfc10 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -262,6 +262,7 @@ struct sta_ampdu_mlme {
  * @dummy: indicate a dummy station created for receiving
  *	EAP frames before association
  * @sta: station information we share with the driver
+ * @beacon_loss_count: number of times beacon loss has triggered
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -352,6 +353,7 @@ struct sta_info {
 #endif
 
 	unsigned int lost_packets;
+	unsigned int beacon_loss_count;
 
 	/* should be right in front of sta to be in the same cache line */
 	bool dummy;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ba43966..a39d1b3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2390,6 +2390,9 @@ static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 	if (sinfo->filled & STATION_INFO_TX_FAILED)
 		NLA_PUT_U32(msg, NL80211_STA_INFO_TX_FAILED,
 			    sinfo->tx_failed);
+	if (sinfo->filled & STATION_INFO_BEACON_LOSS_COUNT)
+		NLA_PUT_U32(msg, NL80211_STA_INFO_BEACON_LOSS,
+			    sinfo->beacon_loss_count);
 	if (sinfo->filled & STATION_INFO_BSS_PARAM) {
 		bss_param = nla_nest_start(msg, NL80211_STA_INFO_BSS_PARAM);
 		if (!bss_param)
-- 
1.7.3.1

