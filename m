Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42594 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab1JUQjC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 12:39:02 -0400
Received: by eye27 with SMTP id 27so4030084eye.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2011 09:39:01 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] carl9170: fix AMPDU TX_CTL_REQ_TX_STATUS handling
Date: Fri, 21 Oct 2011 18:38:56 +0200
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201110211838.56860.chunkeey@googlemail.com> (sfid-20111021_183907_909730_64D040BA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously the driver did not care if TX_CTL_REQ_TX_STATUS
was set on aggregated frames or not and it would silently
drop successfully sent frames if possible [much like:
"no news is good news!"].

But, TX_CTL_REQ_TX_STATUS was invented for a reason and
no tx status report should ever be dropped if it is set.

Reported-by: Johannes Berg
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index d209469..59472e1 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -296,7 +296,8 @@ static void carl9170_tx_release(struct kref *ref)
 			super = (void *)skb->data;
 			txinfo->status.ampdu_len = super->s.rix;
 			txinfo->status.ampdu_ack_len = super->s.cnt;
-		} else if (txinfo->flags & IEEE80211_TX_STAT_ACK) {
+		} else if ((txinfo->flags & IEEE80211_TX_STAT_ACK) &&
+			   !(txinfo->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)) {
 			/*
 			 * drop redundant tx_status reports:
 			 *
@@ -308,15 +309,17 @@ static void carl9170_tx_release(struct kref *ref)
 			 *
 			 * 3. minstrel_ht is picky, it only accepts
 			 *    reports of frames with the TX_STATUS_AMPDU flag.
+			 *
+			 * 4. mac80211 is not particularly interested in
+			 *    feedback either [CTL_REQ_TX_STATUS not set]
 			 */
 
 			dev_kfree_skb_any(skb);
 			return;
 		} else {
 			/*
-			 * Frame has failed, but we want to keep it in
-			 * case it was lost due to a power-state
-			 * transition.
+			 * Either the frame transmission has failed or
+			 * mac80211 requested tx status.
 			 */
 		}
 	}
