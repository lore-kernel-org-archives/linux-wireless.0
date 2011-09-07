Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42440 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668Ab1IGUKb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 16:10:31 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1R1OS5-0007w5-NF
	for linux-wireless@vger.kernel.org; Wed, 07 Sep 2011 22:10:29 +0200
Message-Id: <20110907200923.537463760@sipsolutions.net> (sfid-20110907_221101_383645_C82718F8)
Date: Wed, 07 Sep 2011 22:07:53 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 09/11] mac80211: reply only once to each PS-poll
References: <20110907200744.076513799@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If a PS-poll frame is retried (but was received)
there is no way to detect that since it has no
sequence number. As a consequence, the standard
asks us to not react to PS-poll frames until the
response to one made it out (was ACKed or lost).

Implement this by adding a new station flag that
indicates whether we're sending a response, and
a new status flag that indicates we should clear
the station flag again. This requires TX status
reporting for the frame, so request that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h  |   15 ++++++++++++++-
 net/mac80211/rx.c       |   10 ++++++----
 net/mac80211/sta_info.c |   27 +++++++++++++++++++++++----
 net/mac80211/sta_info.h |    3 +++
 net/mac80211/status.c   |    2 ++
 5 files changed, 48 insertions(+), 9 deletions(-)

--- a/net/mac80211/rx.c	2011-09-07 15:06:19.000000000 +0200
+++ b/net/mac80211/rx.c	2011-09-07 15:06:22.000000000 +0200
@@ -1195,10 +1195,12 @@ ieee80211_rx_h_uapsd_and_pspoll(struct i
 		return RX_CONTINUE;
 
 	if (unlikely(ieee80211_is_pspoll(hdr->frame_control))) {
-		if (!test_sta_flags(rx->sta, WLAN_STA_PS_DRIVER))
-			ieee80211_sta_ps_deliver_poll_response(rx->sta);
-		else
-			set_sta_flags(rx->sta, WLAN_STA_PSPOLL);
+		if (!test_sta_flags(rx->sta, WLAN_STA_POLLED)) {
+			if (!test_sta_flags(rx->sta, WLAN_STA_PS_DRIVER))
+				ieee80211_sta_ps_deliver_poll_response(rx->sta);
+			else
+				set_sta_flags(rx->sta, WLAN_STA_PSPOLL);
+		}
 
 		/* Free PS Poll skb here instead of returning RX_DROP that would
 		 * count as an dropped frame. */
--- a/net/mac80211/sta_info.h	2011-09-07 15:06:19.000000000 +0200
+++ b/net/mac80211/sta_info.h	2011-09-07 15:06:22.000000000 +0200
@@ -48,6 +48,8 @@
  *	unblocks the station.
  * @WLAN_STA_SP: Station is in a service period, so don't try to
  *	reply to other uAPSD trigger frames.
+ * @WLAN_STA_POLLED: We're responding to a PS-Poll frame right now,
+ *	don't respond to retries as well.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH		= 1<<0,
@@ -65,6 +67,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_PSPOLL		= 1<<13,
 	WLAN_STA_UAPSD		= 1<<14,
 	WLAN_STA_SP		= 1<<15,
+	WLAN_STA_POLLED		= 1<<16,
 };
 
 #define STA_TID_NUM 16
--- a/include/net/mac80211.h	2011-09-07 15:06:19.000000000 +0200
+++ b/include/net/mac80211.h	2011-09-07 15:06:22.000000000 +0200
@@ -360,6 +360,11 @@ struct ieee80211_bss_conf {
  *	when its status is reported the service period ends. For frames in
  *	an SP that mac80211 transmits, it is already set; for driver frames
  *	the driver may set this flag.
+ * @IEEE80211_TX_STATUS_PSPOLL_RESP: This packet was a response to a PS-Poll
+ *	frame and thus marks the end of this PS-Poll. For frames that mac80211
+ *	releases from queues it is already set; for driver queued frames the
+ *	driver must set the flag and report TX status with it for a response
+ *	to a PS-poll.
  *
  * Note: If you have to add new flags to the enumeration, then don't
  *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
@@ -391,6 +396,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_TX_OFFCHAN		= BIT(25),
 	IEEE80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(26),
 	IEEE80211_TX_STATUS_EOSP		= BIT(27),
+	IEEE80211_TX_STATUS_PSPOLL_RESP		= BIT(28),
 };
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
@@ -406,7 +412,8 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_STAT_AMPDU | IEEE80211_TX_STAT_AMPDU_NO_BACK |	      \
 	IEEE80211_TX_CTL_RATE_CTRL_PROBE | IEEE80211_TX_CTL_POLL_RESPONSE |   \
 	IEEE80211_TX_CTL_MORE_FRAMES | IEEE80211_TX_CTL_LDPC |		      \
-	IEEE80211_TX_CTL_STBC | IEEE80211_TX_STATUS_EOSP)
+	IEEE80211_TX_CTL_STBC | IEEE80211_TX_STATUS_EOSP |		      \
+	IEEE80211_TX_STATUS_PSPOLL_RESP)
 
 /**
  * enum mac80211_rate_control_flags - per-rate flags set by the
@@ -1937,6 +1944,12 @@ enum ieee80211_frame_release_type {
  *	the frames being released then it must still set the more-data bit in
  *	the frame. If the @more_data parameter is %true, then of course the
  *	more-data bit must always be set.
+ *	In the case this is used for a PS-poll initiated release, the
+ *	@num_frames parameter will always be 1 so code can be shared. In
+ *	this case the driver must also set %IEEE80211_TX_STATUS_PSPOLL_RESP
+ *	flag on the TX status (and must report TX status) so that the PS-poll
+ *	period is properly ended. This is used to avoid sending multiple
+ *	responses for a retried PS-poll frame.
  *	In the case this is used for uAPSD, the @num_frames parameter may be
  *	bigger than one, but the driver may send fewer frames (it must send
  *	at least one, however). In this case it is also responsible for
--- a/net/mac80211/status.c	2011-09-07 15:06:19.000000000 +0200
+++ b/net/mac80211/status.c	2011-09-07 15:06:22.000000000 +0200
@@ -254,6 +254,8 @@ void ieee80211_tx_status(struct ieee8021
 
 		if (info->flags & IEEE80211_TX_STATUS_EOSP)
 			clear_sta_flags(sta, WLAN_STA_SP);
+		else if (info->flags & IEEE80211_TX_STATUS_PSPOLL_RESP)
+			clear_sta_flags(sta, WLAN_STA_POLLED);
 
 		acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
 		if (!acked && test_sta_flags(sta, WLAN_STA_PS_STA)) {
--- a/net/mac80211/sta_info.c	2011-09-07 15:06:19.000000000 +0200
+++ b/net/mac80211/sta_info.c	2011-09-07 15:06:22.000000000 +0200
@@ -1272,8 +1272,11 @@ ieee80211_sta_ps_deliver_response(struct
 				hdr->frame_control |=
 					cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 
-			if (reason == IEEE80211_FRAME_RELEASE_UAPSD &&
-			    skb_queue_empty(&frames)) {
+			if (reason == IEEE80211_FRAME_RELEASE_PSPOLL) {
+				info->flags |= IEEE80211_TX_STATUS_PSPOLL_RESP |
+					       IEEE80211_TX_CTL_REQ_TX_STATUS;
+			} else if (reason == IEEE80211_FRAME_RELEASE_UAPSD &&
+				   skb_queue_empty(&frames)) {
 				/* set EOSP for the frame */
 				u8 *p = ieee80211_get_qos_ctl(hdr);
 				*p |= IEEE80211_QOS_CTL_EOSP;
@@ -1330,6 +1333,7 @@ void ieee80211_sta_ps_deliver_poll_respo
 
 void ieee80211_sta_ps_deliver_uapsd(struct sta_info *sta)
 {
+	int n_frames = sta->sta.max_sp;
 	u8 delivery_enabled = sta->sta.uapsd_queues;
 
 	/*
@@ -1344,8 +1348,23 @@ void ieee80211_sta_ps_deliver_uapsd(stru
 	/* Ohh, finally, the service period starts :-) */
 	set_sta_flags(sta, WLAN_STA_SP);
 
-	ieee80211_sta_ps_deliver_response(sta, sta->sta.max_sp,
-					  ~delivery_enabled,
+	switch (sta->sta.max_sp) {
+	case 1:
+		n_frames = 2;
+		break;
+	case 2:
+		n_frames = 4;
+		break;
+	case 3:
+		n_frames = 6;
+		break;
+	case 0:
+		/* XXX: what is a good value? */
+		n_frames = 8;
+		break;
+	}
+
+	ieee80211_sta_ps_deliver_response(sta, n_frames, ~delivery_enabled,
 					  IEEE80211_FRAME_RELEASE_UAPSD);
 }
 


