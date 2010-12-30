Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42980 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab0L3Qql (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Dec 2010 11:46:41 -0500
Received: by fxm20 with SMTP id 20so11325468fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Dec 2010 08:46:39 -0800 (PST)
Message-Id: <ca015cfae85c3ce58cbf8b19b189f444ba8f543f.1293727387.git.chunkeey@googlemail.com>
In-Reply-To: <3f6f7ecee0ecea67238627fb1a60611087ce0ee3.1293727387.git.chunkeey@googlemail.com>
References: <3f6f7ecee0ecea67238627fb1a60611087ce0ee3.1293727387.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Thu, 30 Dec 2010 17:29:53 +0100
Subject: [PATCH 2/2] Revert "mac80211: temporarily disable reorder release timer"
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts enables the reorder release timer once again.

The issues laid out in:
<http://www.spinics.net/lists/linux-wireless/msg57214.html>

Have been addressed by:
	mac80211: serialize rx path workers
	mac80211: ignore PSM bit of reordered frames

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 net/mac80211/rx.c |   24 ------------------------
 1 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 62a82ec..56f8adb 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -625,26 +625,6 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 							tid_agg_rx->buf_size;
 	}
 
-	/*
-	 * Disable the reorder release timer for now.
-	 *
-	 * The current implementation lacks a proper locking scheme
-	 * which would protect vital statistic and debug counters
-	 * from being updated by two different but concurrent BHs.
-	 *
-	 * More information about the topic is available from:
-	 * - thread: http://marc.info/?t=128635927000001
-	 *
-	 * What was wrong:
-	 * =>  http://marc.info/?l=linux-wireless&m=128636170811964
-	 * "Basically the thing is that until your patch, the data
-	 *  in the struct didn't actually need locking because it
-	 *  was accessed by the RX path only which is not concurrent."
-	 *
-	 * List of what needs to be fixed:
-	 * => http://marc.info/?l=linux-wireless&m=128656352920957
-	 *
-
 	if (tid_agg_rx->stored_mpdu_num) {
 		j = index = seq_sub(tid_agg_rx->head_seq_num,
 				    tid_agg_rx->ssn) % tid_agg_rx->buf_size;
@@ -663,10 +643,6 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 	} else {
 		del_timer(&tid_agg_rx->reorder_timer);
 	}
-	*/
-
-set_release_timer:
-	return;
 }
 
 /*
-- 
1.7.2.3

