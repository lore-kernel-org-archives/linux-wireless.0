Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33684 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbcFOFj2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2016 01:39:28 -0400
Received: by mail-pf0-f195.google.com with SMTP id c74so959519pfb.0
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2016 22:39:28 -0700 (PDT)
From: Masashi Honma <masashi.honma@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH] mac80211: Encrypt "Group addressed privacy" action frames
Date: Wed, 15 Jun 2016 14:38:32 +0900
Message-Id: <1465969112-2814-1-git-send-email-masashi.honma@gmail.com> (sfid-20160615_073935_444521_DBDDAE65)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, the action frames to group address was not encrypted. But
[1] "Table 8-38 Category values" indicates "Mesh" and "Multihop" category
action frames should be encrypted (Group addressed privacy == yes). And the
encyption key should be MGTK ([1] 10.13 Group addressed robust management frame
procedures). So this patch modifies the code to make it suitable for spec.

[1] IEEE Std 802.11-2012

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 net/mac80211/tx.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2030443..80afc47 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -578,6 +578,21 @@ ieee80211_tx_h_check_control_port_protocol(struct ieee80211_tx_data *tx)
 	return TX_CONTINUE;
 }
 
+static bool debug_noinline
+ieee80211_is_group_privacy_action(struct ieee80211_hdr *hdr)
+{
+	struct ieee80211_mgmt *mgmt;
+
+	if (!ieee80211_is_action(hdr->frame_control) ||
+	    !is_multicast_ether_addr(hdr->addr1))
+		return false;
+
+	mgmt = (struct ieee80211_mgmt *)hdr;
+
+	return mgmt->u.action.category == WLAN_CATEGORY_MESH_ACTION ||
+		mgmt->u.action.category == WLAN_CATEGORY_MULTIHOP_ACTION;
+}
+
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 {
@@ -590,6 +605,9 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 	else if (tx->sta &&
 		 (key = rcu_dereference(tx->sta->ptk[tx->sta->ptk_idx])))
 		tx->key = key;
+	else if (ieee80211_is_group_privacy_action(hdr) &&
+		 (key = rcu_dereference(tx->sdata->default_multicast_key)))
+		tx->key = key;
 	else if (ieee80211_is_mgmt(hdr->frame_control) &&
 		 is_multicast_ether_addr(hdr->addr1) &&
 		 ieee80211_is_robust_mgmt_frame(tx->skb) &&
@@ -620,6 +638,8 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 		case WLAN_CIPHER_SUITE_CCMP_256:
 		case WLAN_CIPHER_SUITE_GCMP:
 		case WLAN_CIPHER_SUITE_GCMP_256:
+			if (ieee80211_is_group_privacy_action(hdr))
+				break;
 			if (!ieee80211_is_data_present(hdr->frame_control) &&
 			    !ieee80211_use_mfp(hdr->frame_control, tx->sta,
 					       tx->skb))
-- 
2.5.0

