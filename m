Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57027 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab0I2X5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 19:57:22 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 1/2] wireless:  Show sta_flags for status in /proc/net/wireless
Date: Wed, 29 Sep 2010 16:57:16 -0700
Message-Id: <1285804637-5400-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

User-space can then decode the flags to determine associated,
scanning, and other states.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 e6827ee... 43d485f... M	include/linux/wireless.h
:100644 100644 f355b8c... b807430... M	include/net/cfg80211.h
:100644 100644 c981604... 4fded2e... M	net/mac80211/cfg.c
:100644 100644 7e5c3a4... 504a5d6... M	net/wireless/wext-compat.c
 include/linux/wireless.h   |    4 ++--
 include/net/cfg80211.h     |    2 ++
 net/mac80211/cfg.c         |    4 ++++
 net/wireless/wext-compat.c |    2 ++
 4 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/wireless.h b/include/linux/wireless.h
index e6827ee..43d485f 100644
--- a/include/linux/wireless.h
+++ b/include/linux/wireless.h
@@ -898,8 +898,8 @@ struct	iw_pmkid_cand
  */
 struct	iw_statistics
 {
-	__u16		status;		/* Status
-					 * - device dependent for now */
+	__u16		status;		/* Status: ieee80211_sta_info_flags
+					 *   plus: (1<<15):  Scanning */
 
 	struct iw_quality	qual;		/* Quality of the link
 						 * (instant/mean/max) */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f355b8c..b807430 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -457,6 +457,7 @@ struct rate_info {
  * @plid: mesh peer link id
  * @plink_state: mesh peer link state
  * @signal: signal strength of last received packet in dBm
+ * @status: ieee80211_sta_info_flags plus:  (1<<15) Scanning.
  * @txrate: current unicast bitrate to this station
  * @rx_packets: packets received from this station
  * @tx_packets: packets transmitted to this station
@@ -474,6 +475,7 @@ struct station_info {
 	u16 plid;
 	u8 plink_state;
 	s8 signal;
+	u16 status;
 	struct rate_info txrate;
 	u32 rx_packets;
 	u32 tx_packets;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c981604..4fded2e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -327,6 +327,10 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->plink_state = sta->plink_state;
 #endif
 	}
+
+	sinfo->status = sta->flags;
+	if (sdata->local->scanning)
+		sinfo->status |= (1<<15);
 }
 
 
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 7e5c3a4..504a5d6 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1355,6 +1355,8 @@ struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 
 	wstats.qual.updated |= IW_QUAL_NOISE_INVALID;
 
+	wstats.status = sinfo.status;
+
 	return &wstats;
 }
 EXPORT_SYMBOL_GPL(cfg80211_wireless_stats);
-- 
1.7.2.2

