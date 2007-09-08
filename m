Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:43781
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbXIHVnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2007 17:43:47 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ulrich Kunitz <kune@deine-taler.de>, Daniel Drake <dsd@gentoo.org>
Subject: zd-mac80211: Fix TX status reports.
Date: Sat, 8 Sep 2007 23:41:31 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709082341.31720.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Automatic rate scaling does not work on the zd-mac80211 driver.
The driver does not properly report succeed and failed frames
to mac80211.

We need to indicate failed frames with the excessive_retries field
(Should we also fake report some high retry count here?)
Otherwise the rc algo is not able to scale down.

Remove the conditional in REQ_TX_STATUS, as mac80211 handles that internally.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---


Johannes, to me it seems that there's also a bug in mac80211.
I never get a frame with the REQ_TX_STATUS bit set, so frames
will always end up on the "unreliable" tx status queue.


Index: wireless-dev/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c	2007-09-07 16:13:10.000000000 +0200
+++ wireless-dev/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c	2007-09-08 23:33:47.000000000 +0200
@@ -348,6 +348,7 @@ static int init_tx_skb_control_block(str
  * @hw - a &struct ieee80211_hw pointer
  * @skb - a sk-buffer
  * @status - the tx status of the packet without control information
+ * @success - True for successfull transmission of the frame
  *
  * This information calls ieee80211_tx_status_irqsafe() if required by the
  * control information. It copies the control information into the status
@@ -356,19 +357,18 @@ static int init_tx_skb_control_block(str
  * If no status information has been requested, the skb is freed.
  */
 static void tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
-	              struct ieee80211_tx_status *status)
+	              struct ieee80211_tx_status *status,
+		      bool success)
 {
 	struct zd_tx_skb_control_block *cb = (struct zd_tx_skb_control_block *)
 		skb->cb;
 
 	ZD_ASSERT(cb->control != NULL);
-	if ((cb->control->flags & IEEE80211_TXCTL_REQ_TX_STATUS)) {
-		memcpy(&status->control, cb->control, sizeof(status->control));
-		clear_tx_skb_control_block(skb);
-		ieee80211_tx_status_irqsafe(hw, skb, status);
-	} else {
-		kfree_tx_skb(skb);
-	}
+	memcpy(&status->control, cb->control, sizeof(status->control));
+	if (!success)
+		status->excessive_retries = 1;
+	clear_tx_skb_control_block(skb);
+	ieee80211_tx_status_irqsafe(hw, skb, status);
 }
 
 /**
@@ -388,7 +388,7 @@ void zd_mac_tx_failed(struct ieee80211_h
 	skb = skb_dequeue(q);
 	if (skb == NULL)
 		return;
-	tx_status(hw, skb, &status);
+	tx_status(hw, skb, &status, 0);
 }
 
 /**
@@ -413,7 +413,7 @@ void zd_mac_tx_to_dev(struct sk_buff *sk
 		    (cb->control->flags & IEEE80211_TXCTL_NO_ACK)))
 		{
 			struct ieee80211_tx_status status = {{0}};
-			tx_status(hw, skb, &status);
+			tx_status(hw, skb, &status, !error);
 		} else {
 			struct sk_buff_head *q =
 				&zd_hw_mac(hw)->ack_wait_queue;
@@ -664,7 +664,7 @@ static int filter_ack(struct ieee80211_h
 			status.flags = IEEE80211_TX_STATUS_ACK;
 			status.ack_signal = stats->ssi;
 			__skb_unlink(skb, q);
-			tx_status(hw, skb, &status);
+			tx_status(hw, skb, &status, 1);
 			goto out;
 		}
 	}
