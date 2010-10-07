Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51584 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab0JGXOu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:14:50 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] wireless:  Set some stats used by /proc/net/wireless (wext)
Date: Thu,  7 Oct 2010 16:14:35 -0700
Message-Id: <1286493275-18364-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Some stats for /proc/net/wireless (and wext in general) are not
being set.  This patch addresses a few of those with values easily
obtained from mac80211 core.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 183739c... c02cc1d... M	include/net/cfg80211.h
:100644 100644 ecf9b71... 51daf3a... M	net/mac80211/cfg.c
:100644 100644 6002265... b0d8580... M	net/wireless/wext-compat.c
 include/net/cfg80211.h     |    2 ++
 net/mac80211/cfg.c         |    1 +
 net/wireless/wext-compat.c |    2 ++
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 183739c..c02cc1d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -468,6 +468,7 @@ struct rate_info {
  * @tx_packets: packets transmitted to this station
  * @tx_retries: cumulative retry counts
  * @tx_failed: number of failed transmissions (retries exceeded, no ACK)
+ * @rx_dropped_misc:  Dropped for un-specified reason.
  * @generation: generation number for nl80211 dumps.
  *	This number should increase every time the list of stations
  *	changes, i.e. when a station is added or removed, so that
@@ -487,6 +488,7 @@ struct station_info {
 	u32 tx_packets;
 	u32 tx_retries;
 	u32 tx_failed;
+	u32 rx_dropped_misc;
 
 	int generation;
 };
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ecf9b71..51daf3a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -338,6 +338,7 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	sinfo->tx_packets = sta->tx_packets;
 	sinfo->tx_retries = sta->tx_retry_count;
 	sinfo->tx_failed = sta->tx_retry_failed;
+	sinfo->rx_dropped_misc = sta->rx_dropped;
 
 	if ((sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) ||
 	    (sta->local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)) {
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 6002265..b0d8580 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1366,6 +1366,8 @@ struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 	}
 
 	wstats.qual.updated |= IW_QUAL_NOISE_INVALID;
+	wstats.discard.misc = sinfo.rx_dropped_misc;
+	wstats.discard.retries = sinfo.tx_failed;
 
 	return &wstats;
 }
-- 
1.7.2.2

