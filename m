Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55031 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab1IHAuJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 20:50:09 -0400
Received: by mail-pz0-f42.google.com with SMTP id 37so370400pzk.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2011 17:50:09 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH v2 2/3] mac80211: Mesh data frames must have the QoS header
Date: Wed,  7 Sep 2011 17:49:53 -0700
Message-Id: <1315442994-304-3-git-send-email-javier@cozybit.com> (sfid-20110908_025018_005827_AF159CA7)
In-Reply-To: <1315442994-304-1-git-send-email-javier@cozybit.com>
References: <1315442994-304-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Per sec 7.1.3.5 of draft 12.0 of 802.11s, mesh frames indicate the
presence of the mesh control header in their QoS header.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/ieee80211.h   |    2 ++
 net/mac80211/mesh.c         |    3 +--
 net/mac80211/mesh_pathtbl.c |    2 +-
 net/mac80211/rx.c           |    6 +++---
 net/mac80211/tx.c           |    2 +-
 net/mac80211/wme.c          |   10 ++++++----
 net/mac80211/wme.h          |    3 ++-
 7 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 37f95f2..72f3933 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -130,6 +130,8 @@
 #define IEEE80211_QOS_CTL_ACK_POLICY_BLOCKACK	0x0060
 /* A-MSDU 802.11n */
 #define IEEE80211_QOS_CTL_A_MSDU_PRESENT	0x0080
+/* Mesh Control 802.11s */
+#define IEEE80211_QOS_CTL_MESH_CONTROL_PRESENT  0x0100
 
 /* U-APSD queue for WMM IEs sent by AP */
 #define IEEE80211_WMM_IE_AP_QOSINFO_UAPSD	(1<<7)
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 28ab510..576ef7e 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -464,8 +464,7 @@ int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc,
 		memcpy(hdr->addr3, meshsa, ETH_ALEN);
 		return 24;
 	} else {
-		*fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS |
-				IEEE80211_FCTL_TODS);
+		*fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
 		/* RA TA DA SA */
 		memset(hdr->addr1, 0, ETH_ALEN);   /* RA is resolved later */
 		memcpy(hdr->addr2, meshsa, ETH_ALEN);
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index b51fce6..8ac712b 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -223,7 +223,7 @@ void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta)
 		hdr = (struct ieee80211_hdr *) skb->data;
 		memcpy(hdr->addr1, sta->sta.addr, ETH_ALEN);
 		skb_set_queue_mapping(skb, ieee80211_select_queue(sdata, skb));
-		ieee80211_set_qos_hdr(sdata->local, skb);
+		ieee80211_set_qos_hdr(sdata, skb);
 		__skb_queue_tail(&tmpq, skb);
 	}
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1146991..2c44b08 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1907,7 +1907,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 								fwded_mcast);
 				skb_set_queue_mapping(fwd_skb,
 					ieee80211_select_queue(sdata, fwd_skb));
-				ieee80211_set_qos_hdr(local, fwd_skb);
+				ieee80211_set_qos_hdr(sdata, fwd_skb);
 			} else {
 				int err;
 				/*
@@ -2569,12 +2569,12 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx)
 		CALL_RXH(ieee80211_rx_h_ps_poll)
 		CALL_RXH(ieee80211_rx_h_michael_mic_verify)
 		/* must be after MMIC verify so header is counted in MPDU mic */
-		CALL_RXH(ieee80211_rx_h_remove_qos_control)
-		CALL_RXH(ieee80211_rx_h_amsdu)
 #ifdef CONFIG_MAC80211_MESH
 		if (ieee80211_vif_is_mesh(&rx->sdata->vif))
 			CALL_RXH(ieee80211_rx_h_mesh_fwding);
 #endif
+		CALL_RXH(ieee80211_rx_h_remove_qos_control)
+		CALL_RXH(ieee80211_rx_h_amsdu)
 		CALL_RXH(ieee80211_rx_h_data)
 		CALL_RXH(ieee80211_rx_h_ctrl);
 		CALL_RXH(ieee80211_rx_h_mgmt_check)
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4c567e1..e6fe16a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1595,7 +1595,7 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 				return;
 			}
 
-	ieee80211_set_qos_hdr(local, skb);
+	ieee80211_set_qos_hdr(sdata, skb);
 	ieee80211_tx(sdata, skb, false);
 	rcu_read_unlock();
 }
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index a9fee2b..971004c 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -135,7 +135,8 @@ u16 ieee80211_downgrade_queue(struct ieee80211_local *local,
 	return ieee802_1d_to_ac[skb->priority];
 }
 
-void ieee80211_set_qos_hdr(struct ieee80211_local *local, struct sk_buff *skb)
+void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
+			   struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 
@@ -146,10 +147,11 @@ void ieee80211_set_qos_hdr(struct ieee80211_local *local, struct sk_buff *skb)
 
 		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 
-		if (unlikely(local->wifi_wme_noack_test))
+		if (unlikely(sdata->local->wifi_wme_noack_test))
 			ack_policy |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
-		/* qos header is 2 bytes, second reserved */
+		/* qos header is 2 bytes */
 		*p++ = ack_policy | tid;
-		*p = 0;
+		*p = ieee80211_vif_is_mesh(&sdata->vif) ?
+			(IEEE80211_QOS_CTL_MESH_CONTROL_PRESENT >> 8) : 0;
 	}
 }
diff --git a/net/mac80211/wme.h b/net/mac80211/wme.h
index faead6d..34e166f 100644
--- a/net/mac80211/wme.h
+++ b/net/mac80211/wme.h
@@ -17,7 +17,8 @@ extern const int ieee802_1d_to_ac[8];
 
 u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 			   struct sk_buff *skb);
-void ieee80211_set_qos_hdr(struct ieee80211_local *local, struct sk_buff *skb);
+void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
+			   struct sk_buff *skb);
 u16 ieee80211_downgrade_queue(struct ieee80211_local *local,
                               struct sk_buff *skb);
 
-- 
1.7.6

