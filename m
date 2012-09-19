Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44242 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033Ab2ISKH6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 06:07:58 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] mac80211: don't send delBA on addBA failure
Date: Wed, 19 Sep 2012 12:08:33 +0200
Message-Id: <1348049313-7650-4-git-send-email-johannes@sipsolutions.net> (sfid-20120919_120805_783053_4DEFC92B)
In-Reply-To: <1348049313-7650-1-git-send-email-johannes@sipsolutions.net>
References: <1348049313-7650-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no reason to send a delBA when the
peer refused our addBA, so change that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index d0deb3e..3195a63 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -869,7 +869,7 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 
 	} else {
 		___ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_INITIATOR,
-						true);
+						false);
 	}
 
  out:
-- 
1.7.10.4

