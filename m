Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50034 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaAXOBo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 09:01:44 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix bufferable MMPDU RX handling
Date: Fri, 24 Jan 2014 15:01:38 +0100
Message-Id: <1390572098-5194-1-git-send-email-johannes@sipsolutions.net> (sfid-20140124_150148_432913_14813541)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Action, disassoc and deauth frames are bufferable, and as such don't
have the PM bit in the frame control field reserved which means we
need to react to the bit when receiving in such a frame.

Fix this by introducing a new helper ieee80211_is_bufferable_mmpdu()
and using it for the RX path that currently ignores the PM bit in
any non-data frames for doze->wake transitions, but listens to it in
all frames for wake->doze transitions, both of which are wrong.

Also use the new helper in the TX path to clean up the code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 14 ++++++++++++++
 net/mac80211/rx.c         | 19 ++++++++-----------
 net/mac80211/tx.c         |  5 +----
 3 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index fdd5bff..2bb3eb4 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -597,6 +597,20 @@ static inline int ieee80211_is_qos_nullfunc(__le16 fc)
 }
 
 /**
+ * ieee80211_is_bufferable_mmpdu - check if frame is bufferable MMPDU
+ * @fc: frame control field in little-endian byteorder
+ */
+static inline bool ieee80211_is_bufferable_mmpdu(__le16 fc)
+{
+	/* IEEE 802.11-2012, definition of "bufferable management frame";
+	 * note that this ignores the IBSS special case. */
+	return ieee80211_is_mgmt(fc) &&
+	       (ieee80211_is_action(fc) ||
+		ieee80211_is_disassoc(fc) ||
+		ieee80211_is_deauth(fc));
+}
+
+/**
  * ieee80211_is_first_frag - check if IEEE80211_SCTL_FRAG is not set
  * @seq_ctrl: frame sequence control bytes in little-endian byteorder
  */
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6f76da6..f25f826ad 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1313,18 +1313,15 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	    !ieee80211_has_morefrags(hdr->frame_control) &&
 	    !(status->rx_flags & IEEE80211_RX_DEFERRED_RELEASE) &&
 	    (rx->sdata->vif.type == NL80211_IFTYPE_AP ||
-	     rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)) {
+	     rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
+	    /* PM bit is only checked in frames where it isn't reserved,
+	     * in AP mode it's reserved in non-bufferable management frames
+	     * (cf. IEEE 802.11-2012 8.2.4.1.7 Power Management field)
+	     */
+	    (!ieee80211_is_mgmt(hdr->frame_control) ||
+	     ieee80211_is_bufferable_mmpdu(hdr->frame_control))) {
 		if (test_sta_flag(sta, WLAN_STA_PS_STA)) {
-			/*
-			 * Ignore doze->wake transitions that are
-			 * indicated by non-data frames, the standard
-			 * is unclear here, but for example going to
-			 * PS mode and then scanning would cause a
-			 * doze->wake transition for the probe request,
-			 * and that is clearly undesirable.
-			 */
-			if (ieee80211_is_data(hdr->frame_control) &&
-			    !ieee80211_has_pm(hdr->frame_control))
+			if (!ieee80211_has_pm(hdr->frame_control))
 				sta_ps_end(sta);
 		} else {
 			if (ieee80211_has_pm(hdr->frame_control))
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index a33ab2d..a6ee535 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -474,11 +474,8 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 		     !(info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER))) {
 		int ac = skb_get_queue_mapping(tx->skb);
 
-		/* only deauth, disassoc and action are bufferable MMPDUs */
 		if (ieee80211_is_mgmt(hdr->frame_control) &&
-		    !ieee80211_is_deauth(hdr->frame_control) &&
-		    !ieee80211_is_disassoc(hdr->frame_control) &&
-		    !ieee80211_is_action(hdr->frame_control)) {
+		    !ieee80211_is_bufferable_mmpdu(hdr->frame_control)) {
 			info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
 			return TX_CONTINUE;
 		}
-- 
1.8.5.2

