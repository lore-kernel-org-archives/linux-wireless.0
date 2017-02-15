Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50136 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751077AbdBOJaW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 04:30:22 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH v2 09/10] rt2800: use TXOP_BACKOFF for probe frames
Date: Wed, 15 Feb 2017 10:25:12 +0100
Message-Id: <1487150713-3510-10-git-send-email-sgruszka@redhat.com> (sfid-20170215_103025_780567_62123870)
In-Reply-To: <1487150713-3510-1-git-send-email-sgruszka@redhat.com>
References: <1487150713-3510-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even if we do not set AMPDU bit in TXWI, device still can aggregate
frame and send it with rate not corresponding to requested. That mean
we can do not sent probe frames with requested rate. To prevent that
use TXOP_BACKOFF for probe frames.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
index e1660b9..a2c1ca5 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
@@ -372,15 +372,16 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 
 	/*
 	 * Determine IFS values
-	 * - Use TXOP_BACKOFF for management frames except beacons
+	 * - Use TXOP_BACKOFF for probe and management frames except beacons
 	 * - Use TXOP_SIFS for fragment bursts
 	 * - Use TXOP_HTTXOP for everything else
 	 *
 	 * Note: rt2800 devices won't use CTS protection (if used)
 	 * for frames not transmitted with TXOP_HTTXOP
 	 */
-	if (ieee80211_is_mgmt(hdr->frame_control) &&
-	    !ieee80211_is_beacon(hdr->frame_control))
+	if ((ieee80211_is_mgmt(hdr->frame_control) &&
+	     !ieee80211_is_beacon(hdr->frame_control)) ||
+	    (tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE))
 		txdesc->u.ht.txop = TXOP_BACKOFF;
 	else if (!(tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT))
 		txdesc->u.ht.txop = TXOP_SIFS;
-- 
1.8.3.1
