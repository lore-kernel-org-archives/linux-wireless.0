Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56130 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbZKGUTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:02 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 29/29] ath9k_common: clarify and correct jumbogram processing
Date: Sat,  7 Nov 2009 15:19:06 -0500
Message-Id: <1257625146-17971-30-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jumbograms are frames put together linked together through
more than one descriptor. For example ath9k_htc will use this
to send from the target a large frame split up into 2 or more
segments. The driver then would be in charge of putting the
frame back together.

When jumbograms are constructed the rx_stats->rs_more will
bet set and rx_stats->rs_status will not have any valid content
as the actual status will only be avialable at the end of
the chained descriptors.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/common.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 80edf7a..acd4bb5 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -53,16 +53,17 @@ static bool ath9k_rx_accept(struct ath_common *common,
 	if (rx_stats->rs_datalen > common->rx_bufsize)
 		return false;
 
-	if (rx_stats->rs_more) {
-		/*
-		 * Frame spans multiple descriptors; this cannot happen yet
-		 * as we don't support jumbograms. If not in monitor mode,
-		 * discard the frame. Enable this if you want to see
-		 * error frames in Monitor mode.
-		 */
-		if (ah->opmode != NL80211_IFTYPE_MONITOR)
-			return false;
-	} else if (rx_stats->rs_status != 0) {
+	/*
+	 * rs_more indicates chained descriptors which can be used
+	 * to link buffers together for a sort of scatter-gather
+	 * operation.
+	 *
+	 * The rx_stats->rs_status will not be set until the end of the
+	 * chained descriptors so it can be ignored if rs_more is set. The
+	 * rs_more will be false at the last element of the chained
+	 * descriptors.
+	 */
+	if (!rx_stats->rs_more && rx_stats->rs_status != 0) {
 		if (rx_stats->rs_status & ATH9K_RXERR_CRC)
 			rxs->flag |= RX_FLAG_FAILED_FCS_CRC;
 		if (rx_stats->rs_status & ATH9K_RXERR_PHY)
-- 
1.6.5.2.143.g8cc62

