Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5249 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbaG2Mmp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2014 08:42:45 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	Ido Yariv <idox.yariv@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: don't resize skbs needlessly
Date: Tue, 29 Jul 2014 15:39:14 +0300
Message-Id: <1406637554-19475-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140729_144248_019883_59A9C3D0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

Header-less cloned skbs with sufficient headroom need not be cloned
unless the tailroom is going to be modified.

Fix ieee80211_skb_resize so it would only resize cloned skbs if either
the header isn't released or the tailroom is going to be modified.

Some drivers might have assumed that skbs are never cloned, so add a HW
flag that explicitly permits cloned TX skbs. Drivers which do not modify
TX skbs should set this flag to avoid copying skbs.

Signed-off-by: Ido Yariv <idox.yariv@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h | 5 ++++-
 net/mac80211/tx.c      | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c9d1a5b..b32ef8f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1610,6 +1610,9 @@ struct ieee80211_tx_control {
  *	is not enabled the default action is to disconnect when getting the
  *	CSA frame.
  *
+ * @IEEE80211_HW_SUPPORTS_CLONED_SKBS: The driver will never modify the payload
+ *	or tailroom of TX skbs without copying them first.
+ *
  * @IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS: The HW supports scanning on all bands
  *	in one command, mac80211 doesn't have to run separate scans per band.
  */
@@ -1643,7 +1646,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TIMING_BEACON_ONLY			= 1<<26,
 	IEEE80211_HW_SUPPORTS_HT_CCK_RATES		= 1<<27,
 	IEEE80211_HW_CHANCTX_STA_CSA			= 1<<28,
-	/* bit 29 unused */
+	IEEE80211_HW_SUPPORTS_CLONED_SKBS		= 1<<29,
 	IEEE80211_SINGLE_HW_SCAN_ON_ALL_BANDS		= 1<<30,
 };
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8216d91..43bd7f0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1479,7 +1479,10 @@ static int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
 		tail_need = max_t(int, tail_need, 0);
 	}
 
-	if (skb_cloned(skb))
+	if (skb_cloned(skb) &&
+	    (!(local->hw.flags & IEEE80211_HW_SUPPORTS_CLONED_SKBS) ||
+	     !skb_clone_writable(skb, ETH_HLEN) ||
+	     sdata->crypto_tx_tailroom_needed_cnt))
 		I802_DEBUG_INC(local->tx_expand_skb_head_cloned);
 	else if (head_need || tail_need)
 		I802_DEBUG_INC(local->tx_expand_skb_head);
-- 
1.9.1

