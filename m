Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:35192 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbYFBRcD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 13:32:03 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/2 V2] mac80211: fix unbalanced locking in ieee80211_get_buffered_bc
Date: Mon,  2 Jun 2008 20:31:56 +0300
Message-Id: <1212427917-7007-1-git-send-email-tomas.winkler@intel.com> (sfid-20080602_193209_114238_EF4A6FE4)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes unbalanced locking in ieee80211_get_buffered_bc

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 16af308..2f63739 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2009,7 +2009,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 	}
 
 	if (WARN_ON(tx.skb != skb))
-		return NULL;
+		res = TX_DROP;
 
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

