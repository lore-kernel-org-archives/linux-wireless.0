Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:27918 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab0H0LIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 07:08:16 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com
Subject: [PATCH 4/4] mac80211: allow changing port control protocol
Date: Fri, 27 Aug 2010 14:07:39 +0300
Message-Id: <1282907259-30825-5-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1282907259-30825-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1282907259-30825-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some vendor specified mechanisms for 802.1X-style
functionality use a different protocol than EAP
(even if EAP is vendor-extensible). Support this
in mac80211 via the cfg80211 API for it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/iface.c       |    2 ++
 net/mac80211/main.c        |    3 +++
 net/mac80211/mlme.c        |    3 +++
 net/mac80211/rx.c          |    2 +-
 net/mac80211/tx.c          |   20 +++++++++++++++++---
 6 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0262dfe..d7e7989 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -515,6 +515,8 @@ struct ieee80211_sub_if_data {
 	struct ieee80211_key *default_mgmt_key;
 
 	u16 sequence_number;
+	__be16 control_port_protocol;
+	bool control_port_no_encrypt;
 
 	struct work_struct work;
 	struct sk_buff_head skb_queue;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 9369710..ba2ce55 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -855,6 +855,8 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	sdata->dev->netdev_ops = &ieee80211_dataif_ops;
 	sdata->wdev.iftype = type;
 
+	sdata->control_port_protocol = cpu_to_be16(ETH_P_PAE);
+
 	/* only monitor differs */
 	sdata->dev->type = ARPHRD_ETHER;
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 15f0e96..964c267 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -627,6 +627,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	local->hw.wiphy->interface_modes &= ~BIT(NL80211_IFTYPE_MESH_POINT);
 #endif
 
+	/* mac80211 supports control port protocol changing */
+	local->hw.wiphy->flags |= WIPHY_FLAG_CONTROL_PORT_PROTOCOL;
+
 	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
 		local->hw.wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 	else if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5282ac1..0cb4296 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2262,6 +2262,9 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	else
 		ifmgd->flags &= ~IEEE80211_STA_CONTROL_PORT;
 
+	sdata->control_port_protocol = req->crypto.control_port_ethertype;
+	sdata->control_port_no_encrypt = req->crypto.control_port_no_encrypt;
+
 	ieee80211_add_work(wk);
 	return 0;
 }
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6e5fb16..ac205a3 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1527,7 +1527,7 @@ static bool ieee80211_frame_allowed(struct ieee80211_rx_data *rx, __le16 fc)
 	 * Allow EAPOL frames to us/the PAE group address regardless
 	 * of whether the frame was encrypted or not.
 	 */
-	if (ehdr->h_proto == htons(ETH_P_PAE) &&
+	if (ehdr->h_proto == rx->sdata->control_port_protocol &&
 	    (compare_ether_addr(ehdr->h_dest, rx->sdata->vif.addr) == 0 ||
 	     compare_ether_addr(ehdr->h_dest, pae_group_addr) == 0))
 		return true;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 31a8903..92764bb 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -509,6 +509,18 @@ ieee80211_tx_h_ps_buf(struct ieee80211_tx_data *tx)
 }
 
 static ieee80211_tx_result debug_noinline
+ieee80211_tx_h_check_control_port_protocol(struct ieee80211_tx_data *tx)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
+
+	if (unlikely(tx->sdata->control_port_protocol == tx->skb->protocol &&
+		     tx->sdata->control_port_no_encrypt))
+		info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+
+	return TX_CONTINUE;
+}
+
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_key *key = NULL;
@@ -527,7 +539,7 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 	else if ((key = rcu_dereference(tx->sdata->default_key)))
 		tx->key = key;
 	else if (tx->sdata->drop_unencrypted &&
-		 (tx->skb->protocol != cpu_to_be16(ETH_P_PAE)) &&
+		 (tx->skb->protocol != tx->sdata->control_port_protocol) &&
 		 !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
 		 (!ieee80211_is_robust_mgmt_frame(hdr) ||
 		  (ieee80211_is_action(hdr->frame_control) &&
@@ -1349,6 +1361,7 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 	CALL_TXH(ieee80211_tx_h_dynamic_ps);
 	CALL_TXH(ieee80211_tx_h_check_assoc);
 	CALL_TXH(ieee80211_tx_h_ps_buf);
+	CALL_TXH(ieee80211_tx_h_check_control_port_protocol);
 	CALL_TXH(ieee80211_tx_h_select_key);
 	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
 		CALL_TXH(ieee80211_tx_h_rate_ctrl);
@@ -1826,7 +1839,8 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 #endif
 	case NL80211_IFTYPE_STATION:
 		memcpy(hdr.addr1, sdata->u.mgd.bssid, ETH_ALEN);
-		if (sdata->u.mgd.use_4addr && ethertype != ETH_P_PAE) {
+		if (sdata->u.mgd.use_4addr &&
+		    cpu_to_be16(ethertype) != sdata->control_port_protocol) {
 			fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
 			/* RA TA DA SA */
 			memcpy(hdr.addr2, sdata->vif.addr, ETH_ALEN);
@@ -1879,7 +1893,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	if (!ieee80211_vif_is_mesh(&sdata->vif) &&
 		unlikely(!is_multicast_ether_addr(hdr.addr1) &&
 		      !(sta_flags & WLAN_STA_AUTHORIZED) &&
-		      !(ethertype == ETH_P_PAE &&
+		      !(cpu_to_be16(ethertype) == sdata->control_port_protocol &&
 		       compare_ether_addr(sdata->vif.addr,
 					  skb->data + ETH_ALEN) == 0))) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-- 
1.6.3.3

