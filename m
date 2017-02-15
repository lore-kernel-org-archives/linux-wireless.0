Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55122 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751598AbdBOJaS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 04:30:18 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH v2 06/10] rt2x00: fixup fill_tx_status for nomatch case
Date: Wed, 15 Feb 2017 10:25:09 +0100
Message-Id: <1487150713-3510-7-git-send-email-sgruszka@redhat.com> (sfid-20170215_103021_889111_4C3436FC)
In-Reply-To: <1487150713-3510-1-git-send-email-sgruszka@redhat.com>
References: <1487150713-3510-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add bits rt2x00lib_fill_tx_status() when filling status in nomatch
case and hopefully do not break the function for existing cases.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c   | 6 +++++-
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.h | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 90fc259..e95d2aa 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -357,6 +357,9 @@ static void rt2x00lib_fill_tx_status(struct rt2x00_dev *rt2x00dev,
 	if (i < (IEEE80211_TX_MAX_RATES - 1))
 		tx_info->status.rates[i].idx = -1; /* terminate */
 
+	if (test_bit(TXDONE_NO_ACK_REQ, &txdesc->flags))
+		tx_info->flags |= IEEE80211_TX_CTL_NO_ACK;
+
 	if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK)) {
 		if (success)
 			tx_info->flags |= IEEE80211_TX_STAT_ACK;
@@ -375,7 +378,8 @@ static void rt2x00lib_fill_tx_status(struct rt2x00_dev *rt2x00dev,
 	 */
 	if (test_bit(TXDONE_AMPDU, &txdesc->flags) ||
 	    tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
-		tx_info->flags |= IEEE80211_TX_STAT_AMPDU;
+		tx_info->flags |= IEEE80211_TX_STAT_AMPDU |
+				  IEEE80211_TX_CTL_AMPDU;
 		tx_info->status.ampdu_len = 1;
 		tx_info->status.ampdu_ack_len = success ? 1 : 0;
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
index 9b297fc..c78fb8c 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
@@ -215,6 +215,7 @@ enum txdone_entry_desc_flags {
 	TXDONE_FAILURE,
 	TXDONE_EXCESSIVE_RETRY,
 	TXDONE_AMPDU,
+	TXDONE_NO_ACK_REQ,
 };
 
 /**
-- 
1.8.3.1
