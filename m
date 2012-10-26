Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54539 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab2JZKcF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 06:32:05 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: a few formatting fixes
Date: Fri, 26 Oct 2012 12:32:37 +0200
Message-Id: <1351247557-24097-1-git-send-email-johannes@sipsolutions.net> (sfid-20121026_123210_993316_42C5D6FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Fix a few code formatting issues in the RX code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c |   39 +++++++++++++--------------------------
 1 file changed, 13 insertions(+), 26 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d07216a..c0a1f53 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -54,8 +54,7 @@ static struct sk_buff *remove_monitor_info(struct ieee80211_local *local,
 	return skb;
 }
 
-static inline int should_drop_frame(struct sk_buff *skb,
-				    int present_fcs_len)
+static inline int should_drop_frame(struct sk_buff *skb, int present_fcs_len)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -130,15 +129,14 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 			    (1 << IEEE80211_RADIOTAP_RX_FLAGS));
 	rthdr->it_len = cpu_to_le16(rtap_len);
 
-	pos = (unsigned char *)(rthdr+1);
+	pos = (unsigned char *)(rthdr + 1);
 
 	/* the order of the following fields is important */
 
 	/* IEEE80211_RADIOTAP_TSFT */
 	if (status->flag & RX_FLAG_MACTIME_MPDU) {
 		put_unaligned_le64(status->mactime, pos);
-		rthdr->it_present |=
-			cpu_to_le32(1 << IEEE80211_RADIOTAP_TSFT);
+		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_TSFT);
 		pos += 8;
 	}
 
@@ -374,7 +372,6 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	return origskb;
 }
 
-
 static void ieee80211_parse_qos(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
@@ -481,8 +478,7 @@ static int ieee80211_get_mmie_keyidx(struct sk_buff *skb)
 	struct ieee80211_mgmt *hdr = (struct ieee80211_mgmt *) skb->data;
 	struct ieee80211_mmie *mmie;
 
-	if (skb->len < 24 + sizeof(*mmie) ||
-	    !is_multicast_ether_addr(hdr->da))
+	if (skb->len < 24 + sizeof(*mmie) || !is_multicast_ether_addr(hdr->da))
 		return -1;
 
 	if (!ieee80211_is_robust_mgmt_frame((struct ieee80211_hdr *) hdr))
@@ -497,9 +493,7 @@ static int ieee80211_get_mmie_keyidx(struct sk_buff *skb)
 	return le16_to_cpu(mmie->key_id);
 }
 
-
-static ieee80211_rx_result
-ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
+static ieee80211_rx_result ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	char *dev_addr = rx->sdata->vif.addr;
@@ -507,7 +501,7 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 	if (ieee80211_is_data(hdr->frame_control)) {
 		if (is_multicast_ether_addr(hdr->addr1)) {
 			if (ieee80211_has_tods(hdr->frame_control) ||
-				!ieee80211_has_fromds(hdr->frame_control))
+			    !ieee80211_has_fromds(hdr->frame_control))
 				return RX_DROP_MONITOR;
 			if (ether_addr_equal(hdr->addr3, dev_addr))
 				return RX_DROP_MONITOR;
@@ -534,7 +528,7 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 			mgmt = (struct ieee80211_mgmt *)hdr;
 			category = mgmt->u.action.category;
 			if (category != WLAN_CATEGORY_MESH_ACTION &&
-				category != WLAN_CATEGORY_SELF_PROTECTED)
+			    category != WLAN_CATEGORY_SELF_PROTECTED)
 				return RX_DROP_MONITOR;
 			return RX_CONTINUE;
 		}
@@ -546,7 +540,6 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 			return RX_CONTINUE;
 
 		return RX_DROP_MONITOR;
-
 	}
 
 	return RX_CONTINUE;
@@ -570,7 +563,6 @@ static inline u16 seq_sub(u16 sq1, u16 sq2)
 	return (sq1 - sq2) & SEQ_MASK;
 }
 
-
 static void ieee80211_release_reorder_frame(struct ieee80211_sub_if_data *sdata,
 					    struct tid_ampdu_rx *tid_agg_rx,
 					    int index)
@@ -1575,18 +1567,15 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	return RX_CONTINUE;
 }
 
-static int
-ieee80211_802_1x_port_control(struct ieee80211_rx_data *rx)
+static int ieee80211_802_1x_port_control(struct ieee80211_rx_data *rx)
 {
-	if (unlikely(!rx->sta ||
-	    !test_sta_flag(rx->sta, WLAN_STA_AUTHORIZED)))
+	if (unlikely(!rx->sta || !test_sta_flag(rx->sta, WLAN_STA_AUTHORIZED)))
 		return -EACCES;
 
 	return 0;
 }
 
-static int
-ieee80211_drop_unencrypted(struct ieee80211_rx_data *rx, __le16 fc)
+static int ieee80211_drop_unencrypted(struct ieee80211_rx_data *rx, __le16 fc)
 {
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
@@ -1608,8 +1597,7 @@ ieee80211_drop_unencrypted(struct ieee80211_rx_data *rx, __le16 fc)
 	return 0;
 }
 
-static int
-ieee80211_drop_unencrypted_mgmt(struct ieee80211_rx_data *rx)
+static int ieee80211_drop_unencrypted_mgmt(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
@@ -1978,7 +1966,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	} else {
 		/* unable to resolve next hop */
 		mesh_path_error_tx(ifmsh->mshcfg.element_ttl, fwd_hdr->addr3,
-				    0, reason, fwd_hdr->addr2, sdata);
+				   0, reason, fwd_hdr->addr2, sdata);
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_no_route);
 		kfree_skb(fwd_skb);
 		return RX_DROP_MONITOR;
@@ -2379,7 +2367,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 		if (!ieee80211_vif_is_mesh(&sdata->vif))
 			break;
 		if (mesh_action_is_path_sel(mgmt) &&
-		  (!mesh_path_sel_is_hwmp(sdata)))
+		    !mesh_path_sel_is_hwmp(sdata))
 			break;
 		goto queue;
 	}
@@ -2435,7 +2423,6 @@ ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 		return RX_QUEUED;
 	}
 
-
 	return RX_CONTINUE;
 }
 
-- 
1.7.10.4

