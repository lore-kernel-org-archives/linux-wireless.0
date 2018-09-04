Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46462 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726212AbeIDQFu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 12:05:50 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  4 Sep 2018 14:40:50 +0300
Message-Id: <20180904114055.1429-5-luca@coelho.fi> (sfid-20180904_134133_353333_4E1B69F9)
In-Reply-To: <20180904114055.1429-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
 <20180904114055.1429-1-luca@coelho.fi>
Subject: [PATCH v2 4/9] mac80211: add an option for station management TXQ
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

We have a TXQ abstraction for non-data packets that need
powersave buffering. Since the AP cannot sleep, in case
of station we can use this TXQ for all management frames,
regardless if they are bufferable. Add HW flag to allow
that.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h |  5 +++++
 net/mac80211/debugfs.c |  1 +
 net/mac80211/tx.c      | 14 +++++++++++---
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 50bf598abdfd..fe71cec8ba42 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2152,6 +2152,10 @@ struct ieee80211_txq {
  *	but if the rate control is built-in then it must be set by the driver.
  *	See also the documentation for that flag.
  *
+ * @IEEE80211_HW_STA_MMPDU_TXQ: use the extra non-TID per-station TXQ for all
+ *	MMPDUs on station interfaces. This of course requires the driver to use
+ *	TXQs to start with.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2199,6 +2203,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_DOESNT_SUPPORT_QOS_NDP,
 	IEEE80211_HW_BUFF_MMPDU_TXQ,
 	IEEE80211_HW_SUPPORTS_VHT_EXT_NSS_BW,
+	IEEE80211_HW_STA_MMPDU_TXQ,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index fb45eb5d1dc4..3fe541e358f3 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -217,6 +217,7 @@ static const char *hw_flag_names[] = {
 	FLAG(DOESNT_SUPPORT_QOS_NDP),
 	FLAG(BUFF_MMPDU_TXQ),
 	FLAG(SUPPORTS_VHT_EXT_NSS_BW),
+	FLAG(STA_MMPDU_TXQ),
 #undef FLAG
 };
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5b6e06ad35ff..6689492c9713 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1251,7 +1251,8 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
 
 	if (unlikely(!ieee80211_is_data_present(hdr->frame_control))) {
 		if ((!ieee80211_is_mgmt(hdr->frame_control) ||
-		     ieee80211_is_bufferable_mmpdu(hdr->frame_control)) &&
+		     ieee80211_is_bufferable_mmpdu(hdr->frame_control) ||
+		     vif->type == NL80211_IFTYPE_STATION) &&
 		    sta && sta->uploaded) {
 			/*
 			 * This will be NULL if the driver didn't set the
@@ -1456,9 +1457,16 @@ void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (tid == IEEE80211_NUM_TIDS) {
-		/* Drivers need to opt in to the bufferable MMPDU TXQ */
-		if (!ieee80211_hw_check(&sdata->local->hw, BUFF_MMPDU_TXQ))
+		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+			/* Drivers need to opt in to the management MPDU TXQ */
+			if (!ieee80211_hw_check(&sdata->local->hw,
+						STA_MMPDU_TXQ))
+				return;
+		} else if (!ieee80211_hw_check(&sdata->local->hw,
+					       BUFF_MMPDU_TXQ)) {
+			/* Drivers need to opt in to the bufferable MMPDU TXQ */
 			return;
+		}
 		txqi->txq.ac = IEEE80211_AC_VO;
 	} else {
 		txqi->txq.ac = ieee80211_ac_from_tid(tid);
-- 
2.18.0
