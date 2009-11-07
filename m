Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56215 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbZKGUTI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:08 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 17/29] ath9k: move rssi processing into a helper
Date: Sat,  7 Nov 2009 15:18:54 -0500
Message-Id: <1257625146-17971-18-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This moves all the RX processing of RSSI into a helper,
ath_rx_prepare(). ath_rx_prepare() should now be really
easy to read and follow.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |   44 ++++++++++++++++++++------------
 1 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index d357b9a..4c4c22f 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -230,31 +230,20 @@ static int ath9k_compute_qual(struct ieee80211_hw *hw,
 	return qual;
 }
 
-/*
- * For Decrypt or Demic errors, we only mark packet status here and always push
- * up the frame up to let mac80211 handle the actual error case, be it no
- * decryption key or real decryption error. This let us keep statistics there.
- */
-static int ath_rx_prepare(struct ath_common *common,
-			  struct ieee80211_hw *hw,
-			  struct sk_buff *skb, struct ath_rx_status *rx_stats,
-			  struct ieee80211_rx_status *rx_status,
-			  bool *decrypt_error)
+static void ath9k_process_rssi(struct ath_common *common,
+			       struct ieee80211_hw *hw,
+			       struct sk_buff *skb,
+			       struct ath_rx_status *rx_stats)
 {
 	struct ath_hw *ah = common->ah;
-	struct ieee80211_hdr *hdr;
-	__le16 fc;
 	struct ieee80211_sta *sta;
+	struct ieee80211_hdr *hdr;
 	struct ath_node *an;
 	int last_rssi = ATH_RSSI_DUMMY_MARKER;
+	__le16 fc;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = hdr->frame_control;
-	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
-
-	if (!ath9k_rx_accept(common, skb, rx_status, rx_stats, decrypt_error))
-		goto rx_next;
-
 
 	rcu_read_lock();
 	/* XXX: use ieee80211_find_sta! */
@@ -279,6 +268,27 @@ static int ath_rx_prepare(struct ath_common *common,
 	/* Update Beacon RSSI, this is used by ANI. */
 	if (ieee80211_is_beacon(fc))
 		ah->stats.avgbrssi = rx_stats->rs_rssi;
+}
+
+/*
+ * For Decrypt or Demic errors, we only mark packet status here and always push
+ * up the frame up to let mac80211 handle the actual error case, be it no
+ * decryption key or real decryption error. This let us keep statistics there.
+ */
+static int ath_rx_prepare(struct ath_common *common,
+			  struct ieee80211_hw *hw,
+			  struct sk_buff *skb, struct ath_rx_status *rx_stats,
+			  struct ieee80211_rx_status *rx_status,
+			  bool *decrypt_error)
+{
+	struct ath_hw *ah = common->ah;
+
+	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
+
+	if (!ath9k_rx_accept(common, skb, rx_status, rx_stats, decrypt_error))
+		goto rx_next;
+
+	ath9k_process_rssi(common, hw, skb, rx_stats);
 
 	rx_status->rate_idx = ath9k_process_rate(common, hw,
 						 rx_stats, rx_status, skb);
-- 
1.6.5.2.143.g8cc62

