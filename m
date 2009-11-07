Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56143 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbZKGUTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:02 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 14/29] ath9k: remove temp variable ratecode from ath_rx_prepare()
Date: Sat,  7 Nov 2009 15:18:51 -0500
Message-Id: <1257625146-17971-15-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Its just a distraction when reading the code, instead use the
rx_stats->rs_rate directly.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6e00eaf..9e6dded 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -161,7 +161,6 @@ static int ath_rx_prepare(struct ath_common *common,
 {
 	struct ath_hw *ah = common->ah;
 	struct ieee80211_hdr *hdr;
-	u8 ratecode;
 	__le16 fc;
 	struct ieee80211_sta *sta;
 	struct ath_node *an;
@@ -174,16 +173,14 @@ static int ath_rx_prepare(struct ath_common *common,
 	if (!ath9k_rx_accept(common, skb, rx_status, rx_stats, decrypt_error))
 		goto rx_next;
 
-	ratecode = rx_stats->rs_rate;
-
-	if (ratecode & 0x80) {
+	if (rx_stats->rs_rate & 0x80) {
 		/* HT rate */
 		rx_status->flag |= RX_FLAG_HT;
 		if (rx_stats->rs_flags & ATH9K_RX_2040)
 			rx_status->flag |= RX_FLAG_40MHZ;
 		if (rx_stats->rs_flags & ATH9K_RX_GI)
 			rx_status->flag |= RX_FLAG_SHORT_GI;
-		rx_status->rate_idx = ratecode & 0x7f;
+		rx_status->rate_idx = rx_stats->rs_rate & 0x7f;
 	} else {
 		struct ieee80211_supported_band *sband;
 		unsigned int i = 0;
-- 
1.6.5.2.143.g8cc62

