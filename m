Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:34258 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbaCROqN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:13 -0400
Received: by mail-ee0-f52.google.com with SMTP id e49so5427529eek.39
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:46:12 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/35] iwlwifi: mvm: BT Coex - enable per-AC BT priority
Date: Tue, 18 Mar 2014 16:45:20 +0200
Message-Id: <1395153939-23897-16-git-send-email-egrumbach@gmail.com> (sfid-20140318_154705_317105_7BC93A38)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We can now define the priority against BT per AC. This is
possible with a newer firmware that allows to define the
priority with 2 bits.
Note that this change is compatible with older firmware
since older firmware will simply ignore the new bit (11),
and we still set the old bit (12) in the same cases as
before.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c | 22 ++++++++++++++++++----
 drivers/net/wireless/iwlwifi/mvm/mvm.h  |  4 +++-
 drivers/net/wireless/iwlwifi/mvm/sta.c  |  2 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c   |  9 ++++++---
 4 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 43027c3..018d75c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -1208,16 +1208,30 @@ bool iwl_mvm_bt_coex_is_mimo_allowed(struct iwl_mvm *mvm,
 }
 
 u8 iwl_mvm_bt_coex_tx_prio(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
-			   struct ieee80211_tx_info *info)
+			   struct ieee80211_tx_info *info, u8 ac)
 {
 	__le16 fc = hdr->frame_control;
 
+	if (info->band != IEEE80211_BAND_2GHZ)
+		return 0;
+
 	/* High prio packet (wrt. BT coex) if it is EAPOL, MCAST or MGMT */
-	if (info->band == IEEE80211_BAND_2GHZ &&
-	    (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO ||
+	if (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO ||
 	     is_multicast_ether_addr(hdr->addr1) ||
-	     ieee80211_is_back_req(fc) || ieee80211_is_mgmt(fc)))
+	     ieee80211_is_ctl(fc) || ieee80211_is_mgmt(fc) ||
+	     ieee80211_is_nullfunc(fc) || ieee80211_is_qos_nullfunc(fc))
+		return 3;
+
+	switch (ac) {
+	case IEEE80211_AC_BE:
+		return 1;
+	case IEEE80211_AC_VO:
+		return 3;
+	case IEEE80211_AC_VI:
 		return 2;
+	default:
+		break;
+	}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 221a482..f77be76 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -346,6 +346,8 @@ iwl_mvm_vif_from_mac80211(struct ieee80211_vif *vif)
 	return (void *)vif->drv_priv;
 }
 
+extern const u8 tid_to_mac80211_ac[];
+
 enum iwl_scan_status {
 	IWL_MVM_SCAN_NONE,
 	IWL_MVM_SCAN_OS,
@@ -913,7 +915,7 @@ u16 iwl_mvm_coex_agg_time_limit(struct iwl_mvm *mvm,
 bool iwl_mvm_bt_coex_is_mimo_allowed(struct iwl_mvm *mvm,
 				     struct ieee80211_sta *sta);
 u8 iwl_mvm_bt_coex_tx_prio(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
-			   struct ieee80211_tx_info *info);
+			   struct ieee80211_tx_info *info, u8 ac);
 int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id, bool enable);
 
 enum iwl_bt_kill_msk {
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 2677d1c..6739353 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -851,7 +851,7 @@ static int iwl_mvm_sta_tx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	return ret;
 }
 
-static const u8 tid_to_mac80211_ac[] = {
+const u8 tid_to_mac80211_ac[] = {
 	IEEE80211_AC_BE,
 	IEEE80211_AC_BK,
 	IEEE80211_AC_BK,
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index dd813d4..0e3f45a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -79,6 +79,7 @@ static void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 	__le16 fc = hdr->frame_control;
 	u32 tx_flags = le32_to_cpu(tx_cmd->tx_flags);
 	u32 len = skb->len + FCS_LEN;
+	u8 ac;
 
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
 		tx_flags |= TX_CMD_FLG_ACK;
@@ -90,9 +91,6 @@ static void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 	else if (ieee80211_is_back_req(fc))
 		tx_flags |= TX_CMD_FLG_ACK | TX_CMD_FLG_BAR;
 
-	tx_flags |= iwl_mvm_bt_coex_tx_prio(mvm, hdr, info) <<
-			TX_CMD_FLG_BT_PRIO_POS;
-
 	if (ieee80211_has_morefrags(fc))
 		tx_flags |= TX_CMD_FLG_MORE_FRAG;
 
@@ -108,6 +106,11 @@ static void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 			tx_flags &= ~TX_CMD_FLG_SEQ_CTL;
 	}
 
+	/* tid_tspec will default to 0 = BE when QOS isn't enabled */
+	ac = tid_to_mac80211_ac[tx_cmd->tid_tspec];
+	tx_flags |= iwl_mvm_bt_coex_tx_prio(mvm, hdr, info, ac) <<
+			TX_CMD_FLG_BT_PRIO_POS;
+
 	if (ieee80211_is_mgmt(fc)) {
 		if (ieee80211_is_assoc_req(fc) || ieee80211_is_reassoc_req(fc))
 			tx_cmd->pm_frame_timeout = cpu_to_le16(3);
-- 
1.8.3.2

