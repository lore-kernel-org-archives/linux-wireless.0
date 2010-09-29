Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57031 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab0I2X5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 19:57:31 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 2/2] wireless:  Report noise to /proc/net/wireless
Date: Wed, 29 Sep 2010 16:57:17 -0700
Message-Id: <1285804637-5400-2-git-send-email-greearb@candelatech.com>
In-Reply-To: <1285804637-5400-1-git-send-email-greearb@candelatech.com>
References: <1285804637-5400-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This adds noise reports to /proc/net/wireless again.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 b807430... 324d352... M	include/net/cfg80211.h
:100644 100644 4fded2e... 3e2f354... M	net/mac80211/cfg.c
:100644 100644 504a5d6... 27717ea... M	net/wireless/wext-compat.c
 include/net/cfg80211.h     |    3 +++
 net/mac80211/cfg.c         |    4 ++++
 net/wireless/wext-compat.c |    1 +
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b807430..324d352 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -458,6 +458,7 @@ struct rate_info {
  * @plink_state: mesh peer link state
  * @signal: signal strength of last received packet in dBm
  * @status: ieee80211_sta_info_flags plus:  (1<<15) Scanning.
+ * @noise: noise, as obtained from dump_survey of index 0.
  * @txrate: current unicast bitrate to this station
  * @rx_packets: packets received from this station
  * @tx_packets: packets transmitted to this station
@@ -476,6 +477,8 @@ struct station_info {
 	u8 plink_state;
 	s8 signal;
 	u16 status;
+	u8 noise;
+	/* 3 byte hole */
 	struct rate_info txrate;
 	u32 rx_packets;
 	u32 tx_packets;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 4fded2e..3e2f354 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -277,6 +277,7 @@ static int ieee80211_config_default_mgmt_key(struct wiphy *wiphy,
 static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct survey_info survey;
 
 	sinfo->generation = sdata->local->sta_generation;
 
@@ -331,6 +332,9 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	sinfo->status = sta->flags;
 	if (sdata->local->scanning)
 		sinfo->status |= (1<<15);
+
+	if (drv_get_survey(sdata->local, 0, &survey) == 0)
+		sinfo->noise = survey.noise;
 }
 
 
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 504a5d6..27717ea 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1356,6 +1356,7 @@ struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 	wstats.qual.updated |= IW_QUAL_NOISE_INVALID;
 
 	wstats.status = sinfo.status;
+	wstats.qual.noise = sinfo.noise;
 
 	return &wstats;
 }
-- 
1.7.2.2

