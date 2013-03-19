Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57034 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933933Ab3CSVYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 17:24:00 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/2] mac80211:  Add beacon stats to debugfs.
Date: Tue, 19 Mar 2013 14:23:53 -0700
Message-Id: <1363728234-1629-1-git-send-email-greearb@candelatech.com> (sfid-20130319_222405_289379_8D22391B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Beacon-timeout and number of beacon loss events.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 6d5aec9... dc962aa... M	net/mac80211/debugfs_netdev.c
:100644 100644 6cc8e14... 0f08f22... M	net/mac80211/debugfs_sta.c
 net/mac80211/debugfs_netdev.c |   11 +++++++++++
 net/mac80211/debugfs_sta.c    |    2 ++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 6d5aec9..dc962aa 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -123,6 +123,15 @@ static ssize_t ieee80211_if_fmt_##name(					\
 	return scnprintf(buf, buflen, "%d\n", sdata->field / 16);	\
 }
 
+#define IEEE80211_IF_FMT_JIFFIES_TO_MS(name, field)			\
+static ssize_t ieee80211_if_fmt_##name(					\
+	const struct ieee80211_sub_if_data *sdata,			\
+	char *buf, int buflen)						\
+{									\
+	return scnprintf(buf, buflen, "%d\n",				\
+			 jiffies_to_msecs(sdata->field));		\
+}
+
 #define __IEEE80211_IF_FILE(name, _write)				\
 static ssize_t ieee80211_if_read_##name(struct file *file,		\
 					char __user *userbuf,		\
@@ -174,6 +183,7 @@ IEEE80211_IF_FILE(bssid, u.mgd.bssid, MAC);
 IEEE80211_IF_FILE(aid, u.mgd.aid, DEC);
 IEEE80211_IF_FILE(last_beacon, u.mgd.last_beacon_signal, DEC);
 IEEE80211_IF_FILE(ave_beacon, u.mgd.ave_beacon_signal, DEC_DIV_16);
+IEEE80211_IF_FILE(beacon_timeout, u.mgd.beacon_timeout, JIFFIES_TO_MS);
 
 static int ieee80211_set_smps(struct ieee80211_sub_if_data *sdata,
 			      enum ieee80211_smps_mode smps_mode)
@@ -539,6 +549,7 @@ static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(aid);
 	DEBUGFS_ADD(last_beacon);
 	DEBUGFS_ADD(ave_beacon);
+	DEBUGFS_ADD(beacon_timeout);
 	DEBUGFS_ADD_MODE(smps, 0600);
 	DEBUGFS_ADD_MODE(tkip_mic_test, 0200);
 	DEBUGFS_ADD_MODE(uapsd_queues, 0600);
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 6cc8e14..0f08f22 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -52,6 +52,7 @@ static const struct file_operations sta_ ##name## _ops = {		\
 STA_FILE(aid, sta.aid, D);
 STA_FILE(dev, sdata->name, S);
 STA_FILE(last_signal, last_signal, D);
+STA_FILE(beacon_loss_count, beacon_loss_count, D);
 
 static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
 			      size_t count, loff_t *ppos)
@@ -371,6 +372,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD(agg_status);
 	DEBUGFS_ADD(dev);
 	DEBUGFS_ADD(last_signal);
+	DEBUGFS_ADD(beacon_loss_count);
 	DEBUGFS_ADD(ht_capa);
 
 	DEBUGFS_ADD_COUNTER(rx_packets, rx_packets);
-- 
1.7.3.4

