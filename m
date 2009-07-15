Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36726 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbZGOPg0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 11:36:26 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1MR6Wt-0008PN-JR
	for linux-wireless@vger.kernel.org; Wed, 15 Jul 2009 17:36:24 +0200
Subject: [RFC] mac80211: deprecate qual value
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 17:28:48 +0200
Message-Id: <1247671728.10754.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This value is unused by mac80211, because it was only
be used by wireless extensions, and turned out to not
be useful there because the quality value needs to be
comparable between scan results and the current value
which is impossible when the qual value is calculated
taking into account noise, for example.

Since it is unused anyway, this patch deprecates it
in the hope that drivers will remove their sometimes
quite expensive calculations of the value.

I'm open to actual uses of the value, but the best
way of using it seems to be what the Intel drivers do
which should probably be generalised if we have noise
values from the hardware.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h     |    2 +-
 net/mac80211/debugfs_sta.c |    3 ---
 net/mac80211/rx.c          |    1 -
 net/mac80211/sta_info.h    |    3 ---
 4 files changed, 1 insertion(+), 8 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-07-15 17:27:36.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-07-15 17:27:39.000000000 +0200
@@ -508,7 +508,7 @@ struct ieee80211_rx_status {
 	int freq;
 	int signal;
 	int noise;
-	int qual;
+	int __deprecated qual;
 	int antenna;
 	int rate_idx;
 	int flag;
--- wireless-testing.orig/net/mac80211/debugfs_sta.c	2009-07-15 17:28:00.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs_sta.c	2009-07-15 17:28:04.000000000 +0200
@@ -57,7 +57,6 @@ STA_FILE(tx_filtered, tx_filtered_count,
 STA_FILE(tx_retry_failed, tx_retry_failed, LU);
 STA_FILE(tx_retry_count, tx_retry_count, LU);
 STA_FILE(last_signal, last_signal, D);
-STA_FILE(last_qual, last_qual, D);
 STA_FILE(last_noise, last_noise, D);
 STA_FILE(wep_weak_iv_count, wep_weak_iv_count, LU);
 
@@ -209,7 +208,6 @@ void ieee80211_sta_debugfs_add(struct st
 	DEBUGFS_ADD(tx_retry_failed);
 	DEBUGFS_ADD(tx_retry_count);
 	DEBUGFS_ADD(last_signal);
-	DEBUGFS_ADD(last_qual);
 	DEBUGFS_ADD(last_noise);
 	DEBUGFS_ADD(wep_weak_iv_count);
 }
@@ -235,7 +233,6 @@ void ieee80211_sta_debugfs_remove(struct
 	DEBUGFS_DEL(tx_retry_failed);
 	DEBUGFS_DEL(tx_retry_count);
 	DEBUGFS_DEL(last_signal);
-	DEBUGFS_DEL(last_qual);
 	DEBUGFS_DEL(last_noise);
 	DEBUGFS_DEL(wep_weak_iv_count);
 
--- wireless-testing.orig/net/mac80211/rx.c	2009-07-15 17:27:54.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2009-07-15 17:27:55.000000000 +0200
@@ -860,7 +860,6 @@ ieee80211_rx_h_sta_process(struct ieee80
 	sta->rx_fragments++;
 	sta->rx_bytes += rx->skb->len;
 	sta->last_signal = rx->status->signal;
-	sta->last_qual = rx->status->qual;
 	sta->last_noise = rx->status->noise;
 
 	/*
--- wireless-testing.orig/net/mac80211/sta_info.h	2009-07-15 17:27:44.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.h	2009-07-15 17:28:10.000000000 +0200
@@ -195,7 +195,6 @@ struct sta_ampdu_mlme {
  * @rx_fragments: number of received MPDUs
  * @rx_dropped: number of dropped MPDUs from this STA
  * @last_signal: signal of last received frame from this STA
- * @last_qual: qual of last received frame from this STA
  * @last_noise: noise of last received frame from this STA
  * @last_seq_ctrl: last received seq/frag number from this STA (per RX queue)
  * @tx_filtered_count: number of frames the hardware filtered for this STA
@@ -261,7 +260,6 @@ struct sta_info {
 	unsigned long rx_fragments;
 	unsigned long rx_dropped;
 	int last_signal;
-	int last_qual;
 	int last_noise;
 	__le16 last_seq_ctrl[NUM_RX_DATA_QUEUES];
 
@@ -322,7 +320,6 @@ struct sta_info {
 		struct dentry *tx_retry_failed;
 		struct dentry *tx_retry_count;
 		struct dentry *last_signal;
-		struct dentry *last_qual;
 		struct dentry *last_noise;
 		struct dentry *wep_weak_iv_count;
 		bool add_has_run;


