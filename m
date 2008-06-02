Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:64654 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbYFBPoU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 11:44:20 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/2] mac80211: fix unbalanced locking in ieee80211_get_buffered_bc
Date: Mon,  2 Jun 2008 18:44:11 +0300
Message-Id: <1212421452-5635-1-git-send-email-tomas.winkler@intel.com> (sfid-20080602_174423_056473_753CD9C9)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes unbalanced locking in ieee80211_get_buffered_bc

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/tx.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 16af308..8a5b24d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2008,8 +2008,10 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 			break;
 	}
 
-	if (WARN_ON(tx.skb != skb))
-		return NULL;
+	if (WARN_ON(tx.skb != skb)) {
+		skb = NULL;
+		goto out;
+	}
 
 	if (res == TX_DROP) {
 		I802_DEBUG_INC(local->tx_handlers_drop);
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

