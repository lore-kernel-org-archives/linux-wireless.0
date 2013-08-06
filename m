Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54641 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab3HFJ5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 05:57:42 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: add control port protocol TX control flag
Date: Tue,  6 Aug 2013 11:57:36 +0200
Message-Id: <1375783056-2665-1-git-send-email-johannes@sipsolutions.net> (sfid-20130806_115746_886863_FC07E6F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A lot of drivers check the frame protocol for ETH_P_PAE,
for various reasons (like making those more reliable).
Add a new flags bitmap to the TX control info and a new
flag indicating the control port protocol is in use to
let all drivers also apply such logic to other control
port protocols, should they be configured.

Change-Id: I292ba4865694142670f005856b6320f7f3fa05c8
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DocBook/80211.tmpl            |  1 +
 drivers/net/wireless/iwlwifi/dvm/tx.c       |  2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |  3 ++-
 drivers/net/wireless/iwlwifi/mvm/tx.c       |  9 ++++-----
 include/net/mac80211.h                      | 19 ++++++++++++++++---
 net/mac80211/rc80211_minstrel_ht.c          |  5 +++--
 net/mac80211/tx.c                           |  8 +++++---
 7 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/Documentation/DocBook/80211.tmpl b/Documentation/DocBook/80211.tmpl
index 49267ea..f403ec3 100644
--- a/Documentation/DocBook/80211.tmpl
+++ b/Documentation/DocBook/80211.tmpl
@@ -325,6 +325,7 @@
           <title>functions/definitions</title>
 !Finclude/net/mac80211.h ieee80211_rx_status
 !Finclude/net/mac80211.h mac80211_rx_flags
+!Finclude/net/mac80211.h mac80211_tx_info_flags
 !Finclude/net/mac80211.h mac80211_tx_control_flags
 !Finclude/net/mac80211.h mac80211_rate_control_flags
 !Finclude/net/mac80211.h ieee80211_tx_rate
diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index 5ee983f..f364583 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -87,7 +87,7 @@ static void iwlagn_tx_cmd_build_basic(struct iwl_priv *priv,
 		 priv->lib->bt_params->advanced_bt_coexist &&
 		 (ieee80211_is_auth(fc) || ieee80211_is_assoc_req(fc) ||
 		 ieee80211_is_reassoc_req(fc) ||
-		 skb->protocol == cpu_to_be16(ETH_P_PAE)))
+		 info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO))
 		tx_flags |= TX_CMD_FLG_IGNORE_BT;
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index 4491c1c..9f43fb9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -33,9 +33,10 @@
 static inline bool iwl_trace_data(struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 	if (ieee80211_is_data(hdr->frame_control))
-		return skb->protocol != cpu_to_be16(ETH_P_PAE);
+		return info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO;
 	return false;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index f0e96a9..d62a6d3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -91,11 +91,10 @@ static void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 		tx_flags |= TX_CMD_FLG_ACK | TX_CMD_FLG_BAR;
 
 	/* High prio packet (wrt. BT coex) if it is EAPOL, MCAST or MGMT */
-	if (info->band == IEEE80211_BAND_2GHZ        &&
-	    (skb->protocol == cpu_to_be16(ETH_P_PAE)  ||
-	     is_multicast_ether_addr(hdr->addr1)      ||
-	     ieee80211_is_back_req(fc)                ||
-	     ieee80211_is_mgmt(fc)))
+	if (info->band == IEEE80211_BAND_2GHZ &&
+	    (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO ||
+	     is_multicast_ether_addr(hdr->addr1) ||
+	     ieee80211_is_back_req(fc) || ieee80211_is_mgmt(fc)))
 		tx_flags |= TX_CMD_FLG_BT_DIS;
 
 	if (ieee80211_has_morefrags(fc))
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 839991a..df93c77 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -375,7 +375,7 @@ struct ieee80211_bss_conf {
 };
 
 /**
- * enum mac80211_tx_control_flags - flags to describe transmission information/status
+ * enum mac80211_tx_info_flags - flags to describe transmission information/status
  *
  * These flags are used with the @flags member of &ieee80211_tx_info.
  *
@@ -471,7 +471,7 @@ struct ieee80211_bss_conf {
  * Note: If you have to add new flags to the enumeration, then don't
  *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
  */
-enum mac80211_tx_control_flags {
+enum mac80211_tx_info_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
 	IEEE80211_TX_CTL_ASSIGN_SEQ		= BIT(1),
 	IEEE80211_TX_CTL_NO_ACK			= BIT(2),
@@ -507,6 +507,18 @@ enum mac80211_tx_control_flags {
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
 
+/**
+ * enum mac80211_tx_control_flags - flags to describe transmit control
+ *
+ * @IEEE80211_TX_CTRL_PORT_CTRL_PROTO: this frame is a port control
+ *	protocol frame (e.g. EAP)
+ *
+ * These flags are used in tx_info->control.flags.
+ */
+enum mac80211_tx_control_flags {
+	IEEE80211_TX_CTRL_PORT_CTRL_PROTO	= BIT(0),
+};
+
 /*
  * This definition is used as a mask to clear all temporary flags, which are
  * set by the tx handlers for each transmission attempt by the mac80211 stack.
@@ -680,7 +692,8 @@ struct ieee80211_tx_info {
 			/* NB: vif can be NULL for injected frames */
 			struct ieee80211_vif *vif;
 			struct ieee80211_key_conf *hw_key;
-			/* 8 bytes free */
+			u32 flags;
+			/* 4 bytes free */
 		} control;
 		struct {
 			struct ieee80211_tx_rate rates[IEEE80211_TX_MAX_RATES];
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 7475a7a..9eff382 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -439,12 +439,13 @@ minstrel_aggr_check(struct ieee80211_sta *pubsta, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	u16 tid;
 
 	if (unlikely(!ieee80211_is_data_qos(hdr->frame_control)))
 		return;
 
-	if (unlikely(skb->protocol == cpu_to_be16(ETH_P_PAE)))
+	if (unlikely(info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO))
 		return;
 
 	tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
@@ -776,7 +777,7 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 
 	/* Don't use EAPOL frames for sampling on non-mrr hw */
 	if (mp->hw->max_rates == 1 &&
-	    txrc->skb->protocol == cpu_to_be16(ETH_P_PAE))
+	    (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO))
 		sample_idx = -1;
 	else
 		sample_idx = minstrel_get_sample_rate(mp, mi);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0e42322..098ae85 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -539,9 +539,11 @@ ieee80211_tx_h_check_control_port_protocol(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 
-	if (unlikely(tx->sdata->control_port_protocol == tx->skb->protocol &&
-		     tx->sdata->control_port_no_encrypt))
-		info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	if (unlikely(tx->sdata->control_port_protocol == tx->skb->protocol)) {
+		if (tx->sdata->control_port_no_encrypt)
+			info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+		info->control.flags |= IEEE80211_TX_CTRL_PORT_CTRL_PROTO;
+	}
 
 	return TX_CONTINUE;
 }
-- 
1.8.0

