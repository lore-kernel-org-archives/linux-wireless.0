Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55859 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab1K0Lun (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 06:50:43 -0500
Subject: [PATCH v2] mac80211: fix race condition caused by late addBA
 response
From: Johannes Berg <johannes@sipsolutions.net>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Norbert Preining <preining@logic.at>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1322378621-14647-2-git-send-email-mar.kolya@gmail.com> (sfid-20111127_082402_823149_B8E64ABA)
References: <1322378621-14647-1-git-send-email-mar.kolya@gmail.com>
	 <1322378621-14647-2-git-send-email-mar.kolya@gmail.com>
	 (sfid-20111127_082402_823149_B8E64ABA)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Nov 2011 12:50:38 +0100
Message-ID: <1322394638.4044.32.camel@jlt3.sipsolutions.net> (sfid-20111127_125046_228715_1E6D1B75)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nikolay Martynov <mar.kolya@gmail.com>

If addBA responses comes in just after addba_resp_timer has
expired mac80211 will still accept it and try to open the
aggregation session. This causes drivers to be confused and
in some cases even crash.

This patch fixes the race condition and makes sure that if
addba_resp_timer has expired addBA response is not longer
accepted and we do not try to open half-closed session.

Cc: stable@vger.kernel.org
Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
[some adjustments]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/net/mac80211/agg-tx.c	2011-11-27 12:41:41.000000000 +0100
+++ b/net/mac80211/agg-tx.c	2011-11-27 12:48:03.000000000 +0100
@@ -762,11 +762,27 @@ void ieee80211_process_addba_resp(struct
 		goto out;
 	}
 
-	del_timer(&tid_tx->addba_resp_timer);
+	del_timer_sync(&tid_tx->addba_resp_timer);
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "switched off addBA timer for tid %d\n", tid);
 #endif
+
+	/*
+	 * addba_resp_timer may have fired before we got here, and
+	 * caused WANT_STOP to be set. STOPPING should not be set
+	 * as we're under the mutex, but check it anyway.
+	 */
+	if (test_bit(HT_AGG_STATE_WANT_STOP, &tid_tx->state) ||
+	    test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "got addBA resp for tid %d but we are not "
+				"(or no longer) expecting expecting it\n",
+			tid);
+#endif
+		goto out;
+	}
+
 	/*
 	 * IEEE 802.11-2007 7.3.1.14:
 	 * In an ADDBA Response frame, when the Status Code field


