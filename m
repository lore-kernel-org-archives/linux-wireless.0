Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57726 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466Ab1JDQ1P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 12:27:15 -0400
Subject: [PATCH] mac80211: fix offchannel TX cookie matching
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 18:27:10 +0200
Message-ID: <1317745630.6741.26.camel@jlt3.sipsolutions.net> (sfid-20111004_182718_694386_905D12D1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When I introduced in-kernel off-channel TX I
introduced a bug -- the work can't be canceled
again because the code clear the skb pointer.
Fix this by keeping track separately of whether
TX status has already been reported.

Cc: stable@kernel.org [2.6.38+]
Reported-by: Jouni Malinen <j@w1.fi>
Tested-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |    2 +-
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/status.c      |    2 +-
 net/mac80211/work.c        |    2 +-
 4 files changed, 4 insertions(+), 3 deletions(-)

--- a/net/mac80211/cfg.c	2011-10-04 10:49:07.000000000 +0200
+++ b/net/mac80211/cfg.c	2011-10-04 18:12:34.000000000 +0200
@@ -1886,7 +1886,7 @@ ieee80211_offchan_tx_done(struct ieee802
 	 * so in that case userspace will have to deal with it.
 	 */
 
-	if (wk->offchan_tx.wait && wk->offchan_tx.frame)
+	if (wk->offchan_tx.wait && !wk->offchan_tx.status)
 		cfg80211_mgmt_tx_status(wk->sdata->dev,
 					(unsigned long) wk->offchan_tx.frame,
 					wk->ie, wk->ie_len, false, GFP_KERNEL);
--- a/net/mac80211/ieee80211_i.h	2011-10-04 10:49:07.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2011-10-04 18:11:45.000000000 +0200
@@ -346,6 +346,7 @@ struct ieee80211_work {
 		struct {
 			struct sk_buff *frame;
 			u32 wait;
+			bool status;
 		} offchan_tx;
 	};
 
--- a/net/mac80211/status.c	2011-10-04 10:55:26.000000000 +0200
+++ b/net/mac80211/status.c	2011-10-04 18:12:46.000000000 +0200
@@ -429,7 +429,7 @@ void ieee80211_tx_status(struct ieee8021
 				continue;
 			if (wk->offchan_tx.frame != skb)
 				continue;
-			wk->offchan_tx.frame = NULL;
+			wk->offchan_tx.status = true;
 			break;
 		}
 		rcu_read_unlock();
--- a/net/mac80211/work.c	2011-10-04 18:15:17.000000000 +0200
+++ b/net/mac80211/work.c	2011-10-04 18:15:26.000000000 +0200
@@ -577,7 +577,7 @@ ieee80211_offchannel_tx(struct ieee80211
 		/*
 		 * After this, offchan_tx.frame remains but now is no
 		 * longer a valid pointer -- we still need it as the
-		 * cookie for canceling this work.
+		 * cookie for canceling this work/status matching.
 		 */
 		ieee80211_tx_skb(wk->sdata, wk->offchan_tx.frame);
 


