Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754Ab1HBL2R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 07:28:17 -0400
Date: Tue, 2 Aug 2011 13:29:02 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rt2x00: fix usage of NULL queue
Message-ID: <20110802112314.GA2688@redhat.com> (sfid-20110802_132821_565252_087A0D88)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We may call rt2x00queue_pause_queue(queue) with queue == NULL. Bug
was introduced by commit 62fe778412b36791b7897cfa139342906fbbf07b
"rt2x00: Fix stuck queue in tx failure case" .

Cc: stable@kernel.org # 3.0+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 8efab39..4ccf238 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -113,7 +113,7 @@ void rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * due to possible race conditions in mac80211.
 	 */
 	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
-		goto exit_fail;
+		goto exit_free_skb;
 
 	/*
 	 * Use the ATIM queue if appropriate and present.
@@ -127,7 +127,7 @@ void rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		ERROR(rt2x00dev,
 		      "Attempt to send packet over invalid queue %d.\n"
 		      "Please file bug report to %s.\n", qid, DRV_PROJECT);
-		goto exit_fail;
+		goto exit_free_skb;
 	}
 
 	/*
@@ -159,6 +159,7 @@ void rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
  exit_fail:
 	rt2x00queue_pause_queue(queue);
+ exit_free_skb:
 	dev_kfree_skb_any(skb);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_tx);
-- 
1.7.1
