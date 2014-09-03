Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:65370 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932298AbaICMcn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 08:32:43 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/10] mac80211: fix description comment of ieee80211_subif_start_xmit
Date: Wed,  3 Sep 2014 15:24:59 +0300
Message-Id: <1409747106-30717-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140903_143247_909596_6BFFFD87)
In-Reply-To: <1409747106-30717-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1409747106-30717-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

The function description claimed that on error the skb isn't
freed even though it is, and stated return values that are
different than what really happens in the code.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/tx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6269a3e..56ae886 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1786,9 +1786,8 @@ static void ieee80211_tx_latency_start_msrmnt(struct ieee80211_local *local,
  * @skb: packet to be sent
  * @dev: incoming interface
  *
- * Returns: 0 on success (and frees skb in this case) or 1 on failure (skb will
- * not be freed, and caller is responsible for either retrying later or freeing
- * skb).
+ * Returns: NETDEV_TX_OK both on success and on failure. On failure skb will
+ *	be freed.
  *
  * This function takes in an Ethernet header and encapsulates it with suitable
  * IEEE 802.11 header based on which interface the packet is coming in. The
-- 
1.9.1

