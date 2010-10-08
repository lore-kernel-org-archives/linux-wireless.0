Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64702 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759242Ab0JHUfP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 16:35:15 -0400
Received: by fxm14 with SMTP id 14so729853fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Oct 2010 13:35:14 -0700 (PDT)
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] mac80211: temporarily disable reorder release timer
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Fri, 8 Oct 2010 22:35:09 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010082235.09355.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several serve threading problems in the current
release reorder timer implementation have been
discovered.

A lengthy discussion - which lists some of the
pitfalls and possible solutions - can be found at:
 http://marc.info/?t=128635927000001

But due to the complicated nature of the subject and
the imminent advent of a new -rc cycle, it was
decided to disable the feature for the time being.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
v1 -> v2:
	fix compiling error
	net/mac80211/rx.c: In function ‘ieee80211_sta_reorder_release’:
	net/mac80211/rx.c:665: error: label at end of compound statement
---
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b67221d..aa9b08d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -622,6 +622,26 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 							tid_agg_rx->buf_size;
 	}
 
+	/*
+	 * Disable the reorder release timer for now.
+	 *
+	 * The current implementation lacks a proper locking scheme
+	 * which would protect vital statistic and debug counters
+	 * from being updated by two different but concurrent BHs.
+	 *
+	 * More information about the topic is available from:
+	 * - thread: http://marc.info/?t=128635927000001
+	 *
+	 * What was wrong:
+	 * =>  http://marc.info/?l=linux-wireless&m=128636170811964
+	 * "Basically the thing is that until your patch, the data
+	 *  in the struct didn't actually need locking because it
+	 *  was accessed by the RX path only which is not concurrent."
+	 *
+	 * List of what needs to be fixed:
+	 * => http://marc.info/?l=linux-wireless&m=128656352920957
+	 *
+
 	if (tid_agg_rx->stored_mpdu_num) {
 		j = index = seq_sub(tid_agg_rx->head_seq_num,
 				    tid_agg_rx->ssn) % tid_agg_rx->buf_size;
@@ -640,6 +660,10 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 	} else {
 		del_timer(&tid_agg_rx->reorder_timer);
 	}
+	*/
+
+set_release_timer:
+	return;
 }
 
 /*
