Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64788 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab1HYJvL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 05:51:11 -0400
Received: by wwf5 with SMTP id 5so2178390wwf.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 02:51:10 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 1/2] mac80211: add flag to indicate HW only Tx-agg support
Date: Thu, 25 Aug 2011 12:51:04 +0300
Message-Id: <1314265865-20208-1-git-send-email-arik@wizery.com> (sfid-20110825_115114_645102_D5D8A23E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When this flag is set, Tx aggregations will not be initiated even
if the hardware supports A-MPDU aggregation in general. This flag
is required for devices supporting (partial) software Rx-aggregation.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/net/mac80211.h |    4 ++++
 net/mac80211/agg-tx.c  |    3 ++-
 net/mac80211/debugfs.c |    2 ++
 net/mac80211/tx.c      |    3 ++-
 4 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2f01d84..b21a5bb 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1094,6 +1094,9 @@ enum sta_notify_cmd {
  *	stations based on the PM bit of incoming frames.
  *	Use ieee80211_start_ps()/ieee8021_end_ps() to manually configure
  *	the PS mode of connected stations.
+ *
+ * @IEEE80211_HW_TX_AMPDU_IN_HW_ONLY: The device handles TX aggregation
+ *	strictly in HW. Packets should not be aggregated in software.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1119,6 +1122,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_CQM_RSSI			= 1<<20,
 	IEEE80211_HW_SUPPORTS_PER_STA_GTK		= 1<<21,
 	IEEE80211_HW_AP_LINK_PS				= 1<<22,
+	IEEE80211_HW_TX_AMPDU_IN_HW_ONLY		= 1<<23,
 };
 
 /**
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index b7075f3..be59aef 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -364,7 +364,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 		return -EINVAL;
 
 	if ((tid >= STA_TID_NUM) ||
-	    !(local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION))
+	    !(local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION) ||
+	    (local->hw.flags & IEEE80211_HW_TX_AMPDU_IN_HW_ONLY))
 		return -EINVAL;
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 186e02f..6f1515d 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -355,6 +355,8 @@ static ssize_t hwflags_read(struct file *file, char __user *user_buf,
 		sf += snprintf(buf + sf, mxln - sf, "SUPPORTS_PER_STA_GTK\n");
 	if (local->hw.flags & IEEE80211_HW_AP_LINK_PS)
 		sf += snprintf(buf + sf, mxln - sf, "AP_LINK_PS\n");
+	if (local->hw.flags & IEEE80211_HW_TX_AMPDU_IN_HW_ONLY)
+		sf += snprintf(buf + sf, mxln - sf, "HW_TX_AGGREGATION\n");
 
 	rv = simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
 	kfree(buf);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 69fd494..a0af2f3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1232,7 +1232,8 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 		tx->sta = sta_info_get(sdata, hdr->addr1);
 
 	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control) &&
-	    (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)) {
+	    (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION) &&
+	    !(local->hw.flags & IEEE80211_HW_TX_AMPDU_IN_HW_ONLY)) {
 		struct tid_ampdu_tx *tid_tx;
 
 		qc = ieee80211_get_qos_ctl(hdr);
-- 
1.7.4.1

