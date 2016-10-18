Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49440 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932726AbcJRUMX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 16:12:23 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 18 Oct 2016 23:12:10 +0300
Message-Id: <20161018201213.18873-5-luca@coelho.fi> (sfid-20161018_221232_659730_1CD2B00E)
In-Reply-To: <20161018201213.18873-1-luca@coelho.fi>
References: <20161018201213.18873-1-luca@coelho.fi>
Subject: [PATCH 4/7] mac80211: allow the driver not to pass the tid to ieee80211_sta_uapsd_trigger
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

iwlwifi will check internally that the tid maps to an AC
that is trigger enabled, but can't know what tid exactly.
Allow the driver to pass a generic tid and make mac80211
assume that a trigger frame was received.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h | 4 ++++
 net/mac80211/rx.c      | 5 +++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e50c9e0..f3dbada 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4087,6 +4087,10 @@ void ieee80211_sta_pspoll(struct ieee80211_sta *sta);
  * This must be used in conjunction with ieee80211_sta_ps_transition()
  * and possibly ieee80211_sta_pspoll(); calls to all three must be
  * serialized.
+ * %IEEE80211_NUM_TIDS can be passed as the tid if the tid is unknown.
+ * In this case, mac80211 will not check that this tid maps to an AC
+ * that is trigger enabled and assume that the caller did the proper
+ * checks.
  */
 void ieee80211_sta_uapsd_trigger(struct ieee80211_sta *sta, u8 tid);
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index fc08a50..837d562 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1394,13 +1394,14 @@ void ieee80211_sta_uapsd_trigger(struct ieee80211_sta *pubsta, u8 tid)
 	u8 ac = ieee802_1d_to_ac[tid & 7];
 
 	/*
-	 * If this AC is not trigger-enabled do nothing.
+	 * If this AC is not trigger-enabled do nothing unless the
+	 * driver is calling us after it already checked.
 	 *
 	 * NB: This could/should check a separate bitmap of trigger-
 	 * enabled queues, but for now we only implement uAPSD w/o
 	 * TSPEC changes to the ACs, so they're always the same.
 	 */
-	if (!(sta->sta.uapsd_queues & BIT(ac)))
+	if (!(sta->sta.uapsd_queues & BIT(ac)) && tid != IEEE80211_NUM_TIDS)
 		return;
 
 	/* if we are in a service period, do nothing */
-- 
2.9.3
