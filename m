Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49588 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbZJ2Hlx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2009 03:41:53 -0400
Subject: [PATCH] mac80211: deprecate qual value
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Oct 2009 08:41:25 +0100
Message-ID: <1256802085.3865.50.camel@johannes.local>
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
 net/mac80211/debugfs_sta.c |    2 --
 net/mac80211/rx.c          |    1 -
 net/mac80211/sta_info.h    |    2 --
 4 files changed, 1 insertion(+), 6 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-10-29 08:35:37.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-10-29 08:40:25.000000000 +0100
@@ -552,7 +552,7 @@ struct ieee80211_rx_status {
 	int freq;
 	int signal;
 	int noise;
-	int qual;
+	int __deprecated qual;
 	int antenna;
 	int rate_idx;
 	int flag;
--- wireless-testing.orig/net/mac80211/debugfs_sta.c	2009-10-29 08:32:19.000000000 +0100
+++ wireless-testing/net/mac80211/debugfs_sta.c	2009-10-29 08:40:25.000000000 +0100
@@ -57,7 +57,6 @@ STA_FILE(tx_filtered, tx_filtered_count,
 STA_FILE(tx_retry_failed, tx_retry_failed, LU);
 STA_FILE(tx_retry_count, tx_retry_count, LU);
 STA_FILE(last_signal, last_signal, D);
-STA_FILE(last_qual, last_qual, D);
 STA_FILE(last_noise, last_noise, D);
 STA_FILE(wep_weak_iv_count, wep_weak_iv_count, LU);
 
@@ -233,7 +232,6 @@ void ieee80211_sta_debugfs_add(struct st
 	DEBUGFS_ADD(tx_retry_failed);
 	DEBUGFS_ADD(tx_retry_count);
 	DEBUGFS_ADD(last_signal);
-	DEBUGFS_ADD(last_qual);
 	DEBUGFS_ADD(last_noise);
 	DEBUGFS_ADD(wep_weak_iv_count);
 	DEBUGFS_ADD(ht_capa);
--- wireless-testing.orig/net/mac80211/rx.c	2009-10-28 22:22:48.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-10-29 08:40:25.000000000 +0100
@@ -859,7 +859,6 @@ ieee80211_rx_h_sta_process(struct ieee80
 	sta->rx_fragments++;
 	sta->rx_bytes += rx->skb->len;
 	sta->last_signal = rx->status->signal;
-	sta->last_qual = rx->status->qual;
 	sta->last_noise = rx->status->noise;
 
 	/*
--- wireless-testing.orig/net/mac80211/sta_info.h	2009-10-28 22:22:48.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.h	2009-10-29 08:40:25.000000000 +0100
@@ -193,7 +193,6 @@ struct sta_ampdu_mlme {
  * @rx_fragments: number of received MPDUs
  * @rx_dropped: number of dropped MPDUs from this STA
  * @last_signal: signal of last received frame from this STA
- * @last_qual: qual of last received frame from this STA
  * @last_noise: noise of last received frame from this STA
  * @last_seq_ctrl: last received seq/frag number from this STA (per RX queue)
  * @tx_filtered_count: number of frames the hardware filtered for this STA
@@ -259,7 +258,6 @@ struct sta_info {
 	unsigned long rx_fragments;
 	unsigned long rx_dropped;
 	int last_signal;
-	int last_qual;
 	int last_noise;
 	__le16 last_seq_ctrl[NUM_RX_DATA_QUEUES];
 


