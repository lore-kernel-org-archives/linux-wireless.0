Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:1725 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbbHOTkn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2015 15:40:43 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 6/9] mac80211: allow the driver to advertise A-MSDU within A-MPDU Rx support
Date: Sat, 15 Aug 2015 22:39:51 +0300
Message-Id: <1439667594-13632-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150815_214047_355565_51CFD4EE)
In-Reply-To: <1439667594-13632-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1439667594-13632-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers may be interested in receiving A-MSDU within A-MDPU.
Not all the devices may be able to do so, make it configurable.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h | 7 +++++++
 net/mac80211/agg-rx.c  | 4 +++-
 net/mac80211/debugfs.c | 1 +
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 16786450..344424c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1897,6 +1897,12 @@ struct ieee80211_txq {
  * @IEEE80211_HW_TDLS_WIDER_BW: The device/driver supports wider bandwidth
  *	than then BSS bandwidth for a TDLS link on the base channel.
  *
+ * @IEEE80211_HW_SUPPORTS_AMSDU_IN_AMPDU:
+ *	Hardware supports A-MSDU within A-MPDU.
+ *
+ * @IEEE80211_HW_SUPPORTS_AMSDU_IN_AMPDU:
+ *	Hardware supports A-MSDU within A-MPDU.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -1930,6 +1936,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_CLONED_SKBS,
 	IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS,
 	IEEE80211_HW_TDLS_WIDER_BW,
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
index ced6bf3..41726fd 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -123,6 +123,7 @@ static const char *hw_flag_names[NUM_IEEE80211_HW_FLAGS + 1] = {
 	FLAG(SUPPORTS_CLONED_SKBS),
 	FLAG(SINGLE_SCAN_ON_ALL_BANDS),
 	FLAG(TDLS_WIDER_BW),
+	FLAG(SUPPORTS_AMSDU_IN_AMPDU),
 
 	/* keep last for the build bug below */
 	(void *)0x1
-- 
2.1.4

