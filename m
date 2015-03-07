Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:35226 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbbCGSqN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 13:46:13 -0500
From: =?UTF-8?q?Giedrius=20Statkevi=C4=8Dius?=
	<giedrius.statkevicius@gmail.com>
To: sgruszka@redhat.com
Cc: helmut.schaa@googlemail.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	=?UTF-8?q?Giedrius=20Statkevi=C4=8Dius?=
	<giedrius.statkevicius@gmail.com>
Subject: [PATCH] rt2x00: use rt2x00queue_flush_queues() instead of implementing the same action
Date: Sat,  7 Mar 2015 20:45:50 +0200
Message-Id: <1425753950-15624-1-git-send-email-giedrius.statkevicius@gmail.com> (sfid-20150307_194637_009357_84509D68)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use rt2x00queue_flush_queues() in rt2x00mac_flush() instead of
reimplementing the same actions the second time. Also, now it flushes
the rx queue aswell which it didn't before and that makes it completely
do what it's supposed to do according to struct iee80211_ops: flush()
must flush all queues.

Signed-off-by: Giedrius Statkevičius <giedrius.statkevicius@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 300876d..5bc48c3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -756,13 +756,11 @@ void rt2x00mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		     u32 queues, bool drop)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct data_queue *queue;
 
 	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
 		return;
 
-	tx_queue_for_each(rt2x00dev, queue)
-		rt2x00queue_flush_queue(queue, drop);
+	rt2x00queue_flush_queues(rt2x00dev, drop);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_flush);
 
-- 
2.3.1

