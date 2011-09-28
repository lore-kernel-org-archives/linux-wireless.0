Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39240 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab1I1MN0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 08:13:26 -0400
Message-Id: <20110928121131.093704919@sipsolutions.net> (sfid-20110928_141330_443683_869076BF)
Date: Wed, 28 Sep 2011 14:08:58 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 09/15] mac80211: send (QoS) Null if no buffered frames
References: <20110928120849.882884360@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For PS-poll, there's a possible race between
us expiring a frame and the station polling
for it -- send it a null frame in that case.

For uAPSD, the standard says that we have to
send a frame in each SP, so send null if we
don't have any other frames.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    1 
 net/mac80211/sta_info.c    |  100 ++++++++++++++++++++++++++++++++++++++++-----
 net/mac80211/tx.c          |    3 -
 3 files changed, 92 insertions(+), 12 deletions(-)

--- a/net/mac80211/tx.c	2011-09-28 13:34:03.000000000 +0200
+++ b/net/mac80211/tx.c	2011-09-28 13:35:51.000000000 +0200
@@ -1520,8 +1520,7 @@ static int ieee80211_skb_resize(struct i
 	return 0;
 }
 
-static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
-			   struct sk_buff *skb)
+void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
--- a/net/mac80211/ieee80211_i.h	2011-09-28 13:22:26.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2011-09-28 13:35:51.000000000 +0200
@@ -1272,6 +1272,7 @@ void mac80211_ev_michael_mic_failure(str
 				     struct ieee80211_hdr *hdr, const u8 *tsc,
 				     gfp_t gfp);
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata);
+void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
 void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
 void ieee802_11_parse_elems(u8 *start, size_t len,
 			    struct ieee802_11_elems *elems);
--- a/net/mac80211/sta_info.c	2011-09-28 13:34:03.000000000 +0200
+++ b/net/mac80211/sta_info.c	2011-09-28 13:35:51.000000000 +0200
@@ -24,6 +24,7 @@
 #include "sta_info.h"
 #include "debugfs_sta.h"
 #include "mesh.h"
+#include "wme.h"
 
 /**
  * DOC: STA information lifetime rules
@@ -247,10 +248,16 @@ static void sta_unblock(struct work_stru
 		ieee80211_sta_ps_deliver_wakeup(sta);
 	else if (test_and_clear_sta_flags(sta, WLAN_STA_PSPOLL)) {
 		clear_sta_flags(sta, WLAN_STA_PS_DRIVER);
+
+		local_bh_disable();
 		ieee80211_sta_ps_deliver_poll_response(sta);
+		local_bh_enable();
 	} else if (test_and_clear_sta_flags(sta, WLAN_STA_UAPSD)) {
 		clear_sta_flags(sta, WLAN_STA_PS_DRIVER);
+
+		local_bh_disable();
 		ieee80211_sta_ps_deliver_uapsd(sta);
+		local_bh_enable();
 	} else
 		clear_sta_flags(sta, WLAN_STA_PS_DRIVER);
 }
@@ -1147,6 +1154,70 @@ void ieee80211_sta_ps_deliver_wakeup(str
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 }
 
+static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
+					 struct sta_info *sta, int tid,
+					 bool uapsd)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_qos_hdr *nullfunc;
+	struct sk_buff *skb;
+	int size = sizeof(*nullfunc);
+	__le16 fc;
+	bool qos = test_sta_flags(sta, WLAN_STA_WME);
+	struct ieee80211_tx_info *info;
+
+	if (qos) {
+		fc = cpu_to_le16(IEEE80211_FTYPE_DATA |
+				 IEEE80211_STYPE_QOS_NULLFUNC |
+				 IEEE80211_FCTL_FROMDS);
+	} else {
+		size -= 2;
+		fc = cpu_to_le16(IEEE80211_FTYPE_DATA |
+				 IEEE80211_STYPE_NULLFUNC |
+				 IEEE80211_FCTL_FROMDS);
+	}
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + size);
+	if (!skb)
+		return;
+
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	nullfunc = (void *) skb_put(skb, size);
+	nullfunc->frame_control = fc;
+	nullfunc->duration_id = 0;
+	memcpy(nullfunc->addr1, sta->sta.addr, ETH_ALEN);
+	memcpy(nullfunc->addr2, sdata->vif.addr, ETH_ALEN);
+	memcpy(nullfunc->addr3, sdata->vif.addr, ETH_ALEN);
+
+	if (qos) {
+		skb->priority = tid;
+
+		skb_set_queue_mapping(skb, ieee802_1d_to_ac[tid]);
+
+		nullfunc->qos_ctrl = cpu_to_le16(tid);
+
+		if (uapsd)
+			nullfunc->qos_ctrl |=
+				cpu_to_le16(IEEE80211_QOS_CTL_EOSP);
+	}
+
+	info = IEEE80211_SKB_CB(skb);
+
+	/*
+	 * Tell TX path to send this frame even though the
+	 * STA may still remain is PS mode after this frame
+	 * exchange.
+	 */
+	info->flags |= IEEE80211_TX_CTL_POLL_RESPONSE;
+
+	if (uapsd)
+		info->flags |= IEEE80211_TX_STATUS_EOSP |
+			       IEEE80211_TX_CTL_REQ_TX_STATUS;
+
+	ieee80211_xmit(sdata, skb);
+}
+
 static void
 ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 				  int n_frames, u8 ignored_acs,
@@ -1218,19 +1289,28 @@ ieee80211_sta_ps_deliver_response(struct
 	}
 
 	if (!found) {
-#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
+		int tid;
+
 		/*
-		 * FIXME: This can be the result of a race condition between
-		 *	  us expiring a frame and the station polling for it.
-		 *	  Should we send it a null-func frame indicating we
-		 *	  have nothing buffered for it?
+		 * For PS-Poll, this can only happen due to a race condition
+		 * when we set the TIM bit and the station notices it, but
+		 * before it can poll for the frame we expire it.
+		 *
+		 * For uAPSD, this is said in the standard (11.2.1.5 h):
+		 *	At each unscheduled SP for a non-AP STA, the AP shall
+		 *	attempt to transmit at least one MSDU or MMPDU, but no
+		 *	more than the value specified in the Max SP Length field
+		 *	in the QoS Capability element from delivery-enabled ACs,
+		 *	that are destined for the non-AP STA.
+		 *
+		 * Since we have no other MSDU/MMPDU, transmit a QoS null frame.
 		 */
-		if (reason == IEEE80211_FRAME_RELEASE_PSPOLL)
-			printk(KERN_DEBUG "%s: STA %pM sent PS Poll even "
-			       "though there are no buffered frames for it\n",
-			       sdata->name, sta->sta.addr);
-#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 
+		/* This will evaluate to 1, 3, 5 or 7. */
+		tid = 7 - ((ffs(~ignored_acs) - 1) << 1);
+
+		ieee80211_send_null_response(sdata, sta, tid,
+				reason == IEEE80211_FRAME_RELEASE_UAPSD);
 		return;
 	}
 


