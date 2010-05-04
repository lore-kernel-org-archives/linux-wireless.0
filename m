Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:47276 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472Ab0EDH7G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 03:59:06 -0400
Message-ID: <4BDFD3C1.4000209@openwrt.org>
Date: Tue, 04 May 2010 09:58:57 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: fix another source of corrupt frames
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Atheros hardware supports receiving frames that span multiple
descriptors and buffers. In this case, the rx status of every
descriptor except for the last one is invalid and may contain random
data. Because the driver does not support this, it needs to drop such
frames.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -57,13 +57,19 @@ static bool ath9k_rx_accept(struct ath_c
 	 * rs_more indicates chained descriptors which can be used
 	 * to link buffers together for a sort of scatter-gather
 	 * operation.
-	 *
+	 * reject the frame, we don't support scatter-gather yet and
+	 * the frame is probably corrupt anyway
+	 */
+	if (rx_stats->rs_more)
+		return false;
+
+	/*
 	 * The rx_stats->rs_status will not be set until the end of the
 	 * chained descriptors so it can be ignored if rs_more is set. The
 	 * rs_more will be false at the last element of the chained
 	 * descriptors.
 	 */
-	if (!rx_stats->rs_more && rx_stats->rs_status != 0) {
+	if (rx_stats->rs_status != 0) {
 		if (rx_stats->rs_status & ATH9K_RXERR_CRC)
 			rxs->flag |= RX_FLAG_FAILED_FCS_CRC;
 		if (rx_stats->rs_status & ATH9K_RXERR_PHY)

