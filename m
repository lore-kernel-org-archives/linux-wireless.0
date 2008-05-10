Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:54673 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbYEJMKa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 08:10:30 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1148254fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 05:10:29 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 1/5] rt2x00: use rate index in TX control
Date: Sat, 10 May 2008 13:49:49 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805101349.19481.IvDoorn@gmail.com>
In-Reply-To: <200805101349.19481.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805101349.49618.IvDoorn@gmail.com> (sfid-20080510_141041_162944_63C93A26)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the new functions ieee80211_get_tx_rate() and
ieee80211_get_rts_cts_rate() provided by patch:
	mac80211: use rate index in TX control

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 19c1062..5cf4c2f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -33,8 +33,10 @@ void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 				      struct txentry_desc *txdesc,
 				      struct ieee80211_tx_control *control)
 {
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)entry->skb->data;
-	struct ieee80211_rate *rate = control->tx_rate;
+	struct ieee80211_rate *rate =
+	    ieee80211_get_tx_rate(rt2x00dev->hw, control);
 	const struct rt2x00_rate *hwrate;
 	unsigned int data_length;
 	unsigned int duration;
@@ -77,8 +79,9 @@ void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 			__set_bit(ENTRY_TXD_CTS_FRAME, &txdesc->flags);
 			__clear_bit(ENTRY_TXD_ACK, &txdesc->flags);
 		}
-		if (control->rts_cts_rate)
-			rate = control->rts_cts_rate;
+		if (control->rts_cts_rate_idx >= 0)
+			rate =
+			    ieee80211_get_rts_cts_rate(rt2x00dev->hw, control);
 	}
 
 	/*
-- 
1.5.5.1

