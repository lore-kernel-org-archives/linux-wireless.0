Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:62630 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbYAWQRZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 11:17:25 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/1] mac80211: fixing null qos data frames check for reordering buffer
Date: Wed, 23 Jan 2008 18:17:13 +0200
Message-Id: <12011050332904-git-send-email-ron.rindjunsky@intel.com> (sfid-20080123_161730_796518_0ADC97EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a wrong condition for null qos data frames, causing us to
drop data frames needed for reordering as well.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6cc1e7e..1d27b17 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1951,7 +1951,7 @@ u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
 		goto end_reorder;
 
 	/* null data frames are excluded */
-	if (unlikely(fc & IEEE80211_STYPE_QOS_NULLFUNC))
+	if (unlikely(fc & IEEE80211_STYPE_NULLFUNC))
 		goto end_reorder;
 
 	/* new un-ordered ampdu frame - process it */
-- 
1.5.3.3

