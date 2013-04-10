Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-ca-6.exch022.serverdata.net ([64.78.56.51]:41880 "EHLO
	HUB022-ca-6.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148Ab3DJIyg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 04:54:36 -0400
Message-ID: <516528C8.90509@posedge.com> (sfid-20130410_105443_117821_9F07C071)
Date: Wed, 10 Apr 2013 14:24:32 +0530
From: Vivekananda Holla <vivekanandah@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [Patch] mac80211: SMPS for AP Mode
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch for SMPS mode for AP. This is to define a new ieee80211_tx_info flag to allow a lower AP driver to set RTS/CTS protection for a dynamic SMPS station

Signed-off-by: Vivekananda Holla <vivekanandah@posedge.com>
---
 include/net/mac80211.h             |    4 ++++
 net/mac80211/rc80211_minstrel_ht.c |    3 +++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 64faf01..48a950c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -458,6 +458,9 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_DONTFRAG: Don't fragment this packet even if it
  *    would be fragmented by size (this is optional, only used for
  *    monitor injection).
+ * @IEEE80211_TX_CTL_SMPS_SET_RTS: set the RTS/CTS protection mechanism
+ *    for the packet at AP when SMPS mode at the station is 
+ *    dynamic SMPS.
  *
  * Note: If you have to add new flags to the enumeration, then don't
  *     forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
@@ -493,6 +496,7 @@ enum mac80211_tx_control_flags {
     IEEE80211_TX_STATUS_EOSP        = BIT(28),
     IEEE80211_TX_CTL_USE_MINRATE        = BIT(29),
     IEEE80211_TX_CTL_DONTFRAG        = BIT(30),
+    IEEE80211_TX_CTL_SMPS_SET_RTS        = BIT(31),
 };
 
 #define IEEE80211_TX_CTL_STBC_SHIFT        23
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index d2b264d..84557e4 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -719,6 +719,9 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
     info->flags |= mi->tx_flags;
     minstrel_ht_check_cck_shortpreamble(mp, mi, txrc->short_preamble);
 
+    if (sta->smps_mode == IEEE80211_SMPS_DYNAMIC)
+        info->flags |= IEEE80211_TX_CTL_SMPS_SET_RTS;
+
     /* Don't use EAPOL frames for sampling on non-mrr hw */
     if (mp->hw->max_rates == 1 &&
         txrc->skb->protocol == cpu_to_be16(ETH_P_PAE))
