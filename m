Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35231 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbcFUPZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 11:25:50 -0400
Received: by mail-pf0-f193.google.com with SMTP id t190so1591333pfb.2
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2016 08:25:49 -0700 (PDT)
From: Masashi Honma <masashi.honma@gmail.com>
To: j@w1.fi
Cc: linux-wireless@vger.kernel.org,
	Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH v2] mac80211: Encrypt "Group addressed privacy" action frames
Date: Tue, 21 Jun 2016 15:23:39 +0900
Message-Id: <1466490219-2891-1-git-send-email-masashi.honma@gmail.com> (sfid-20160621_172910_206663_2319B327)
In-Reply-To: <20160620212529.GA19076@w1.fi>
References: <20160620212529.GA19076@w1.fi>
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
 include/linux/ieee80211.h | 20 ++++++++++++++++++++
 net/mac80211/tx.c         |  7 +++++--
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index b118744..3ff7d3f 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -19,6 +19,7 @@
 
 #include <linux/types.h>
 #include <linux/if_ether.h>
+#include <linux/etherdevice.h>
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
@@ -2487,6 +2488,25 @@ static inline bool ieee80211_is_public_action(struct ieee80211_hdr *hdr,
 }
 
 /**
+ * ieee80211_is_group_privacy_action - check if frame is a group addressed
+ * privacy action frame
+ * @hdr: the frame
+ */
+static inline bool ieee80211_is_group_privacy_action(struct ieee80211_hdr *hdr)
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
+/**
  * ieee80211_tu_to_usec - convert time units (TU) to microseconds
  * @tu: the TUs
  */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2030443..5ad205e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -590,6 +590,9 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 	else if (tx->sta &&
 		 (key = rcu_dereference(tx->sta->ptk[tx->sta->ptk_idx])))
 		tx->key = key;
+	else if (ieee80211_is_group_privacy_action(hdr) &&
+		 (key = rcu_dereference(tx->sdata->default_multicast_key)))
+		tx->key = key;
 	else if (ieee80211_is_mgmt(hdr->frame_control) &&
 		 is_multicast_ether_addr(hdr->addr1) &&
 		 ieee80211_is_robust_mgmt_frame(tx->skb) &&
@@ -608,7 +611,6 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 		bool skip_hw = false;
 
 		/* TODO: add threshold stuff again */
-
 		switch (tx->key->conf.cipher) {
 		case WLAN_CIPHER_SUITE_WEP40:
 		case WLAN_CIPHER_SUITE_WEP104:
@@ -622,7 +624,8 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 		case WLAN_CIPHER_SUITE_GCMP_256:
 			if (!ieee80211_is_data_present(hdr->frame_control) &&
 			    !ieee80211_use_mfp(hdr->frame_control, tx->sta,
-					       tx->skb))
+					       tx->skb) &&
+			    !ieee80211_is_group_privacy_action(hdr))
 				tx->key = NULL;
 			else
 				skip_hw = (tx->key->conf.flags &
-- 
2.5.0

