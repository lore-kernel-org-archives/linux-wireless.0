Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48041 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab1IFW0b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 18:26:31 -0400
Received: by mail-pz0-f42.google.com with SMTP id 37so10893553pzk.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Sep 2011 15:26:31 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH 2/2] mac80211: Mesh data frames must have the QoS header
Date: Tue,  6 Sep 2011 15:26:16 -0700
Message-Id: <1315347976-13950-3-git-send-email-javier@cozybit.com> (sfid-20110907_002635_643461_CB17162D)
In-Reply-To: <1315347976-13950-1-git-send-email-javier@cozybit.com>
References: <1315347976-13950-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Per sec 7.1.3.5 of draft 12.0 of 802.11s, mesh frames indicate the
presence of the mesh control header in their QoS header.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/ieee80211.h   |    2 ++
 net/mac80211/mesh.c         |    9 +++++----
 net/mac80211/mesh_pathtbl.c |    2 +-
 net/mac80211/rx.c           |    2 +-
 net/mac80211/tx.c           |    5 +++--
 net/mac80211/wme.c          |   10 ++++++----
 net/mac80211/wme.h          |    3 ++-
 7 files changed, 20 insertions(+), 13 deletions(-)

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
index 28ab510..46f2b60b 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -457,21 +457,22 @@ int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc,
 				  const u8 *meshda, const u8 *meshsa)
 {
 	if (is_multicast_ether_addr(meshda)) {
-		*fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS);
+		*fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS |
+				   IEEE80211_STYPE_QOS_DATA);
 		/* DA TA SA */
 		memcpy(hdr->addr1, meshda, ETH_ALEN);
 		memcpy(hdr->addr2, meshsa, ETH_ALEN);
 		memcpy(hdr->addr3, meshsa, ETH_ALEN);
-		return 24;
+		return 26;
 	} else {
 		*fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS |
-				IEEE80211_FCTL_TODS);
+				IEEE80211_FCTL_TODS | IEEE80211_STYPE_QOS_DATA);
 		/* RA TA DA SA */
 		memset(hdr->addr1, 0, ETH_ALEN);   /* RA is resolved later */
 		memcpy(hdr->addr2, meshsa, ETH_ALEN);
 		memcpy(hdr->addr3, meshda, ETH_ALEN);
 		memcpy(hdr->addr4, meshsa, ETH_ALEN);
-		return 30;
+		return 32;
 	}
 }
 
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
index c5be3ef..c843795 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1927,7 +1927,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 						     fwded_frames);
 			skb_set_queue_mapping(fwd_skb,
 				ieee80211_select_queue(rx->sdata, fwd_skb));
-			ieee80211_set_qos_hdr(local, fwd_skb);
+			ieee80211_set_qos_hdr(rx->sdata, fwd_skb);
 			ieee80211_add_pending_skb(local, fwd_skb);
 		}
 	}
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0107263..56da02c 100644
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
@@ -1879,7 +1879,8 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	}
 
 	/* receiver and we are QoS enabled, use a QoS type frame */
-	if ((sta_flags & WLAN_STA_WME) && local->hw.queues >= 4) {
+	if (!ieee80211_vif_is_mesh(&sdata->vif) && (sta_flags & WLAN_STA_WME)
+			&& local->hw.queues >= 4) {
 		fc |= cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
 		hdrlen += 2;
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

