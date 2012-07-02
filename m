Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:49318 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753781Ab2GBRq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 13:46:27 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, chunkeey@googlemail.com,
	johannes@sipsolutions.net, thomas@net.t-labs.tu-berlin.de,
	nbd@openwrt.org
Subject: [PATCH v2] mac80211: reduce IEEE80211_TX_MAX_RATES from 5 to 4 to enable upcoming TPC support
Date: Mon,  2 Jul 2012 19:46:16 +0200
Message-Id: <1341251176-31113-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120702_194630_687263_CFB2F5BB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IEEE80211_TX_MAX_RATES are reduced from 5 to 4, as there is no current hardware
supporting a rate chain with 5 multi rate stages (mrr), so 4 mrr stages are
sufficient. The memory that is freed within the ieee80211_tx_info struct will
be used to implement the upcoming Transmission Power Control (TPC). This patch
is a pre-requisite to TPC.

Suggested-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
refixing tx_info checks in driver P54 and carl as reported by Johannes Berg.
---
 drivers/net/wireless/ath/carl9170/tx.c |    6 +++---
 drivers/net/wireless/p54/txrx.c        |    6 +++---
 include/net/mac80211.h                 |    8 ++++----
 net/mac80211/tx.c                      |    3 +--
 4 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index aed3051..ede0b57 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -277,11 +277,11 @@ static void carl9170_tx_release(struct kref *ref)
 		return;
 
 	BUILD_BUG_ON(
-	    offsetof(struct ieee80211_tx_info, status.ampdu_ack_len) != 23);
+	    offsetof(struct ieee80211_tx_info, status.ack_signal) != 20);
 
-	memset(&txinfo->status.ampdu_ack_len, 0,
+	memset(&txinfo->status.ack_signal, 0,
 	       sizeof(struct ieee80211_tx_info) -
-	       offsetof(struct ieee80211_tx_info, status.ampdu_ack_len));
+	       offsetof(struct ieee80211_tx_info, status.ack_signal));
 
 	if (atomic_read(&ar->tx_total_queued))
 		ar->tx_schedule = true;
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 82a1cac..f38786e 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -422,11 +422,11 @@ static void p54_rx_frame_sent(struct p54_common *priv, struct sk_buff *skb)
 	 * Clear manually, ieee80211_tx_info_clear_status would
 	 * clear the counts too and we need them.
 	 */
-	memset(&info->status.ampdu_ack_len, 0,
+	memset(&info->status.ack_signal, 0,
 	       sizeof(struct ieee80211_tx_info) -
-	       offsetof(struct ieee80211_tx_info, status.ampdu_ack_len));
+	       offsetof(struct ieee80211_tx_info, status.ack_signal));
 	BUILD_BUG_ON(offsetof(struct ieee80211_tx_info,
-			      status.ampdu_ack_len) != 23);
+			      status.ack_signal) != 20);
 
 	if (entry_hdr->flags & cpu_to_le16(P54_HDR_FLAG_DATA_ALIGN))
 		pad = entry_data->align[0];
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

