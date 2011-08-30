Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39243 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab1H3Gco (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 02:32:44 -0400
Received: by wyg24 with SMTP id 24so4649117wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 23:32:42 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2] mac80211: add flag to indicate HW only Tx-agg setup support
Date: Tue, 30 Aug 2011 09:32:38 +0300
Message-Id: <1314685958-24855-1-git-send-email-arik@wizery.com> (sfid-20110830_083247_431439_C8394441)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When this flag is set, Tx A-MPDU sessions will not be started by
mac80211. This flag is required for devices that support Tx A-MPDU setup
in hardware.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v2: changed flag name and description to clear up its purpose

include/net/mac80211.h |    5 +++++
 net/mac80211/agg-tx.c  |    3 ++-
 net/mac80211/debugfs.c |    2 ++
 net/mac80211/tx.c      |    3 ++-
 4 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2f01d84..618b1f7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1094,6 +1094,10 @@ enum sta_notify_cmd {
  *	stations based on the PM bit of incoming frames.
  *	Use ieee80211_start_ps()/ieee8021_end_ps() to manually configure
  *	the PS mode of connected stations.
+ *
+ * @IEEE80211_HW_TX_AMPDU_SETUP_IN_HW: The device handles TX A-MPDU session
+ *	setup strictly in HW. mac80211 should not attempt to do this in
+ *	software.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1119,6 +1123,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_CQM_RSSI			= 1<<20,
 	IEEE80211_HW_SUPPORTS_PER_STA_GTK		= 1<<21,
 	IEEE80211_HW_AP_LINK_PS				= 1<<22,
+	IEEE80211_HW_TX_AMPDU_SETUP_IN_HW		= 1<<23,
 };
 
 /**
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 018108d..42a674b 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -364,7 +364,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 		return -EINVAL;
 
 	if ((tid >= STA_TID_NUM) ||
-	    !(local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION))
+	    !(local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION) ||
+	    (local->hw.flags & IEEE80211_HW_TX_AMPDU_SETUP_IN_HW))
 		return -EINVAL;
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 186e02f..59d1331 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -355,6 +355,8 @@ static ssize_t hwflags_read(struct file *file, char __user *user_buf,
 		sf += snprintf(buf + sf, mxln - sf, "SUPPORTS_PER_STA_GTK\n");
 	if (local->hw.flags & IEEE80211_HW_AP_LINK_PS)
 		sf += snprintf(buf + sf, mxln - sf, "AP_LINK_PS\n");
+	if (local->hw.flags & IEEE80211_HW_TX_AMPDU_SETUP_IN_HW)
+		sf += snprintf(buf + sf, mxln - sf, "TX_AMPDU_SETUP_IN_HW\n");
 
 	rv = simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
 	kfree(buf);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0107263..afb9814 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1232,7 +1232,8 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 		tx->sta = sta_info_get(sdata, hdr->addr1);
 
 	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control) &&
-	    (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)) {
+	    (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION) &&
+	    !(local->hw.flags & IEEE80211_HW_TX_AMPDU_SETUP_IN_HW)) {
 		struct tid_ampdu_tx *tid_tx;
 
 		qc = ieee80211_get_qos_ctl(hdr);
-- 
1.7.4.1

