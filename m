Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:40958 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaKIQu2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2014 11:50:28 -0500
Received: by mail-wg0-f49.google.com with SMTP id x13so7060940wgg.22
        for <linux-wireless@vger.kernel.org>; Sun, 09 Nov 2014 08:50:26 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Liad Kaufman <liad.kaufman@intel.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 02/16] mac80211: retransmit TDLS teardown packet through AP if not ACKed
Date: Sun,  9 Nov 2014 18:50:08 +0200
Message-Id: <1415551822-20121-2-git-send-email-arik@wizery.com> (sfid-20141109_175038_852518_4DF1B9DC)
In-Reply-To: <1415551822-20121-1-git-send-email-arik@wizery.com>
References: <1415551822-20121-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Since the TDLS peer station might not receive the teardown
packet (e.g., when in PS), this makes sure the packet is
retransmitted - this time through the AP - if the TDLS peer
didn't ACK the packet.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/linux/ieee80211.h  | 25 ++++++++++++++++++++
 net/mac80211/ieee80211_i.h |  4 ++++
 net/mac80211/mlme.c        | 12 ++++++++++
 net/mac80211/status.c      | 55 ++++++++++++++++++++++++++++++++++++++++--
 net/mac80211/tdls.c        | 59 +++++++++++++++++++++++++++++++++++++---------
 5 files changed, 142 insertions(+), 13 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index f65b544..4e2bb91 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -19,6 +19,7 @@
 #include <linux/types.h>
 #include <linux/if_ether.h>
 #include <asm/byteorder.h>
+#include <asm/unaligned.h>
 
 /*
  * DS bit usage
@@ -2418,6 +2419,30 @@ static inline bool ieee80211_check_tim(const struct ieee80211_tim_ie *tim,
 	return !!(tim->virtual_map[index] & mask);
 }
 
+/**
+ * ieee80211_get_tdls_action - get tdls packet action (or -1, if not tdls packet)
+ * @skb: the skb containing the frame, length will not be checked
+ * @hdr_size: the size of the ieee80211_hdr that starts at skb->data
+ *
+ * This function assumes the frame is a data frame, and that the network header
+ * is in the correct place.
+ */
+static inline int ieee80211_get_tdls_action(struct sk_buff *skb, u32 hdr_size)
+{
+	if (!skb_is_nonlinear(skb) &&
+	    skb->len > (skb_network_offset(skb) + 2)) {
+		/* Point to where the indication of TDLS should start */
+		const u8 *tdls_data = skb_network_header(skb) - 2;
+
+		if (get_unaligned_be16(tdls_data) == ETH_P_TDLS &&
+		    tdls_data[2] == WLAN_TDLS_SNAP_RFTYPE &&
+		    tdls_data[3] == WLAN_CATEGORY_TDLS)
+			return tdls_data[4];
+	}
+
+	return -1;
+}
+
 /* convert time units */
 #define TU_TO_JIFFIES(x)	(usecs_to_jiffies((x) * 1024))
 #define TU_TO_EXP_TIME(x)	(jiffies + TU_TO_JIFFIES(x))
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 208953d..bc6f12f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -525,8 +525,12 @@ struct ieee80211_if_managed {
 	struct ieee80211_vht_cap vht_capa; /* configured VHT overrides */
 	struct ieee80211_vht_cap vht_capa_mask; /* Valid parts of vht_capa */
 
+	/* TDLS support */
 	u8 tdls_peer[ETH_ALEN] __aligned(2);
 	struct delayed_work tdls_peer_del_work;
+	struct sk_buff *orig_teardown_skb; /* The original teardown skb */
+	struct sk_buff *teardown_skb; /* A copy to send through the AP */
+	spinlock_t teardown_lock; /* To lock changing teardown_skb */
 
 	/* WMM-AC TSPEC support */
 	struct ieee80211_sta_tx_tspec tx_tspec[IEEE80211_NUM_ACS];
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 213a420..dc7f088 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3998,6 +3998,11 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 		ifmgd->req_smps = IEEE80211_SMPS_AUTOMATIC;
 	else
 		ifmgd->req_smps = IEEE80211_SMPS_OFF;
+
+	/* Setup TDLS data */
+	spin_lock_init(&ifmgd->teardown_lock);
+	ifmgd->teardown_skb = NULL;
+	ifmgd->orig_teardown_skb = NULL;
 }
 
 /* scan finished notification */
@@ -4860,6 +4865,13 @@ void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata)
 	}
 	if (ifmgd->auth_data)
 		ieee80211_destroy_auth_data(sdata, false);
+	spin_lock_bh(&ifmgd->teardown_lock);
+	if (ifmgd->teardown_skb) {
+		kfree_skb(ifmgd->teardown_skb);
+		ifmgd->teardown_skb = NULL;
+		ifmgd->orig_teardown_skb = NULL;
+	}
+	spin_unlock_bh(&ifmgd->teardown_lock);
 	del_timer_sync(&ifmgd->timer);
 	sdata_unlock(sdata);
 }
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 9612d89..71de2d3 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -390,6 +390,46 @@ ieee80211_add_tx_radiotap_header(struct ieee80211_local *local,
 	}
 }
 
+/*
+ * Handles the tx for TDLS teardown frames.
+ * If the frame wasn't ACKed by the peer - it will be re-sent through the AP
+ */
+static void ieee80211_tdls_td_tx_handle(struct ieee80211_local *local,
+					struct ieee80211_sub_if_data *sdata,
+					struct sk_buff *skb, u32 flags)
+{
+	struct sk_buff *teardown_skb;
+	struct sk_buff *orig_teardown_skb;
+	bool is_teardown = false;
+
+	/* Get the teardown data we need and free the lock */
+	spin_lock(&sdata->u.mgd.teardown_lock);
+	teardown_skb = sdata->u.mgd.teardown_skb;
+	orig_teardown_skb = sdata->u.mgd.orig_teardown_skb;
+	if ((skb == orig_teardown_skb) && teardown_skb) {
+		sdata->u.mgd.teardown_skb = NULL;
+		sdata->u.mgd.orig_teardown_skb = NULL;
+		is_teardown = true;
+	}
+	spin_unlock(&sdata->u.mgd.teardown_lock);
+
+	if (is_teardown) {
+		/* This mechanism relies on being able to get ACKs */
+		WARN_ON(!(local->hw.flags &
+			  IEEE80211_HW_REPORTS_TX_ACK_STATUS));
+
+		/* Check if peer has ACKed */
+		if (flags & IEEE80211_TX_STAT_ACK) {
+			dev_kfree_skb_any(teardown_skb);
+		} else {
+			tdls_dbg(sdata,
+				 "TDLS Resending teardown through AP\n");
+
+			ieee80211_subif_start_xmit(teardown_skb, skb->dev);
+		}
+	}
+}
+
 static void ieee80211_report_used_skb(struct ieee80211_local *local,
 				      struct sk_buff *skb, bool dropped)
 {
@@ -426,8 +466,19 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
 		if (!sdata) {
 			skb->dev = NULL;
 		} else if (info->flags & IEEE80211_TX_INTFL_MLME_CONN_TX) {
-			ieee80211_mgd_conn_tx_status(sdata, hdr->frame_control,
-						     acked);
+			unsigned int hdr_size =
+				ieee80211_hdrlen(hdr->frame_control);
+
+			/* Check to see if packet is a TDLS teardown packet */
+			if (ieee80211_is_data(hdr->frame_control) &&
+			    (ieee80211_get_tdls_action(skb, hdr_size) ==
+			     WLAN_TDLS_TEARDOWN))
+				ieee80211_tdls_td_tx_handle(local, sdata, skb,
+							    info->flags);
+			else
+				ieee80211_mgd_conn_tx_status(sdata,
+							     hdr->frame_control,
+							     acked);
 		} else if (ieee80211_is_nullfunc(hdr->frame_control) ||
 			   ieee80211_is_qos_nullfunc(hdr->frame_control)) {
 			cfg80211_probe_status(sdata->dev, hdr->addr1,
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index b4f368e..d4fe091 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -512,20 +512,22 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb = NULL;
+	u32 flags = 0;
 	bool send_direct;
 	struct sta_info *sta;
 	int ret;
 
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
-			    max(sizeof(struct ieee80211_mgmt),
-				sizeof(struct ieee80211_tdls_data)) +
-			    50 + /* supported rates */
-			    7 + /* ext capab */
-			    26 + /* max(WMM-info, WMM-param) */
-			    2 + max(sizeof(struct ieee80211_ht_cap),
-				    sizeof(struct ieee80211_ht_operation)) +
-			    extra_ies_len +
-			    sizeof(struct ieee80211_tdls_lnkie));
+	skb = netdev_alloc_skb(dev,
+			       local->hw.extra_tx_headroom +
+			       max(sizeof(struct ieee80211_mgmt),
+				   sizeof(struct ieee80211_tdls_data)) +
+			       50 + /* supported rates */
+			       7 + /* ext capab */
+			       26 + /* max(WMM-info, WMM-param) */
+			       2 + max(sizeof(struct ieee80211_ht_cap),
+				       sizeof(struct ieee80211_ht_operation)) +
+			       extra_ies_len +
+			       sizeof(struct ieee80211_tdls_lnkie));
 	if (!skb)
 		return -ENOMEM;
 
@@ -623,9 +625,44 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 		break;
 	}
 
+	/*
+	 * Set the WLAN_TDLS_TEARDOWN flag to indicate a teardown in progress.
+	 * Later, if no ACK is returned from peer, we will re-send the teardown
+	 * packet through the AP.
+	 */
+	if ((action_code == WLAN_TDLS_TEARDOWN) &&
+	    (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)) {
+		struct sta_info *sta = NULL;
+		bool try_resend; /* Should we keep skb for possible resend */
+
+		/* If not sending directly to peer - no point in keeping skb */
+		rcu_read_lock();
+		sta = sta_info_get(sdata, peer);
+		try_resend = sta && test_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH);
+		rcu_read_unlock();
+
+		spin_lock_bh(&sdata->u.mgd.teardown_lock);
+		if (try_resend && !sdata->u.mgd.teardown_skb) {
+			/* Mark it as requiring TX status callback  */
+			flags |= IEEE80211_TX_CTL_REQ_TX_STATUS |
+				 IEEE80211_TX_INTFL_MLME_CONN_TX;
+
+			/*
+			 * skb is copied since mac80211 will later set
+			 * properties that might not be the same as the AP,
+			 * such as encryption, QoS, addresses, etc.
+			 *
+			 * No problem if skb_copy() fails, so no need to check.
+			 */
+			sdata->u.mgd.teardown_skb = skb_copy(skb, GFP_ATOMIC);
+			sdata->u.mgd.orig_teardown_skb = skb;
+		}
+		spin_unlock_bh(&sdata->u.mgd.teardown_lock);
+	}
+
 	/* disable bottom halves when entering the Tx path */
 	local_bh_disable();
-	ret = ieee80211_subif_start_xmit(skb, dev);
+	__ieee80211_subif_start_xmit(skb, dev, flags);
 	local_bh_enable();
 
 	return ret;
-- 
1.9.1

