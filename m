Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:60654 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755071Ab2F2O6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 10:58:42 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, thomas@net.t-labs.tu-berlin.de,
	nbd@openwrt.org
Subject: [PATCH] mac80211: reduce IEEE80211_TX_MAX_RATES from 5 to 4 to enable upcoming TPC support
Date: Fri, 29 Jun 2012 10:57:23 -0400
Message-Id: <1340981843-81779-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120629_165846_247689_05DD2B23)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IEEE80211_TX_MAX_RATES are reduced from 5 to 4, as there is no hardware out
there supporting a rate chain with 5 stages, so 4 is enough. The space that
is freed will be used for the upcoming Transmission Power Control (TPC).

Suggested-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 include/net/mac80211.h |    8 ++++----
 net/mac80211/tx.c      |    3 +--
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 670a58b..8662b79 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -475,7 +475,7 @@ enum mac80211_rate_control_flags {
 #define IEEE80211_TX_INFO_RATE_DRIVER_DATA_SIZE 24
 
 /* maximum number of rate stages */
-#define IEEE80211_TX_MAX_RATES	5
+#define IEEE80211_TX_MAX_RATES	4
 
 /**
  * struct ieee80211_tx_rate - rate selection/status
@@ -563,11 +563,11 @@ struct ieee80211_tx_info {
 		} control;
 		struct {
 			struct ieee80211_tx_rate rates[IEEE80211_TX_MAX_RATES];
-			u8 ampdu_ack_len;
 			int ack_signal;
+			u8 ampdu_ack_len;
 			u8 ampdu_len;
 			u8 antenna;
-			/* 14 bytes free */
+			/* 21 bytes free */
 		} status;
 		struct {
 			struct ieee80211_tx_rate driver_rates[
@@ -634,7 +634,7 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
 		info->status.rates[i].count = 0;
 
 	BUILD_BUG_ON(
-	    offsetof(struct ieee80211_tx_info, status.ampdu_ack_len) != 23);
+	    offsetof(struct ieee80211_tx_info, status.ack_signal) != 20);
 	memset(&info->status.ampdu_ack_len, 0,
 	       sizeof(struct ieee80211_tx_info) -
 	       offsetof(struct ieee80211_tx_info, status.ampdu_ack_len));
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ec8f5346..3bdfac3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -957,8 +957,7 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 			info->control.rates[1].idx = -1;
 			info->control.rates[2].idx = -1;
 			info->control.rates[3].idx = -1;
-			info->control.rates[4].idx = -1;
-			BUILD_BUG_ON(IEEE80211_TX_MAX_RATES != 5);
+			BUILD_BUG_ON(IEEE80211_TX_MAX_RATES != 4);
 			info->flags &= ~IEEE80211_TX_CTL_RATE_CTRL_PROBE;
 		} else {
 			hdr->frame_control &= ~morefrags;
-- 
1.7.10.4

