Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:32479 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbbGTTnR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2015 15:43:17 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: sara.sharon@intel.com,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 01/10] mac80211: allow the driver to adverise A-MSDU within A-MPDU Rx support
Date: Mon, 20 Jul 2015 22:42:55 +0300
Message-Id: <1437421384-19884-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150720_214345_836333_037C4071)
In-Reply-To: <1437421384-19884-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1437421384-19884-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers may be interested in receiving A-MSDU within A-MDPU.
Not all the devices may be able to do so, make it configurable.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h | 4 ++++
 net/mac80211/agg-rx.c  | 4 +++-
 net/mac80211/debugfs.c | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6b1077c..95ea827 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1888,6 +1888,9 @@ struct ieee80211_txq {
  * @IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS: The HW supports scanning on all bands
  *	in one command, mac80211 doesn't have to run separate scans per band.
  *
+ * @IEEE80211_HW_SUPPORTS_AMSDU_IN_AMPDU:
+ *	Hardware supports A-MSDU within A-MPDU.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -1920,6 +1923,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_CHANCTX_STA_CSA,
 	IEEE80211_HW_SUPPORTS_CLONED_SKBS,
 	IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS,
+	IEEE80211_HW_SUPPORTS_AMSDU_IN_AMPDU,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 5c564a6..78de79b 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -189,6 +189,7 @@ static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *d
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
+	bool amsdu = ieee80211_hw_check(&local->hw, SUPPORTS_AMSDU_IN_AMPDU);
 	u16 capab;
 
 	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom);
@@ -217,7 +218,8 @@ static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *d
 	mgmt->u.action.u.addba_resp.action_code = WLAN_ACTION_ADDBA_RESP;
 	mgmt->u.action.u.addba_resp.dialog_token = dialog_token;
 
-	capab = (u16)(policy << 1);	/* bit 1 aggregation policy */
+	capab = (u16)(amsdu << 0);	/* bit 0 A-MSDU support */
+	capab |= (u16)(policy << 1);	/* bit 1 aggregation policy */
 	capab |= (u16)(tid << 2); 	/* bit 5:2 TID number */
 	capab |= (u16)(buf_size << 6);	/* bit 15:6 max size of aggregation */
 
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 3ea8b7d..6d36249 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -122,6 +122,7 @@ static const char *hw_flag_names[NUM_IEEE80211_HW_FLAGS + 1] = {
 	FLAG(CHANCTX_STA_CSA),
 	FLAG(SUPPORTS_CLONED_SKBS),
 	FLAG(SINGLE_SCAN_ON_ALL_BANDS),
+	FLAG(SUPPORTS_AMSDU_IN_AMPDU),
 
 	/* keep last for the build bug below */
 	(void *)0x1
-- 
2.1.4

