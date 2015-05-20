Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37203 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbbETNFl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 09:05:41 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: add missing drv_priv description for TXQ struct
Date: Wed, 20 May 2015 15:05:38 +0200
Message-Id: <1432127138-28546-1-git-send-email-johannes@sipsolutions.net> (sfid-20150520_150544_822468_9DECBBD5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The kernel-doc description for the drv_priv member of
struct ieee80211_txq was missing, leading to errors.
Add a suitable description to fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 67e0df14ba0f..887fe95b9805 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1728,6 +1728,7 @@ struct ieee80211_tx_control {
  * @sta: station table entry, %NULL for per-vif queue
  * @tid: the TID for this queue (unused for per-vif queue)
  * @ac: the AC for this queue
+ * @drv_priv: driver private area, sized by hw->txq_data_size
  *
  * The driver can obtain packets from this queue by calling
  * ieee80211_tx_dequeue().
-- 
2.1.4

