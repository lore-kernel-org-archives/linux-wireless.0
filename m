Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59442 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab1IFU2Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 16:28:24 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1R12Fl-0004IA-Uv
	for linux-wireless@vger.kernel.org; Tue, 06 Sep 2011 22:28:18 +0200
Message-Id: <20110906202725.521429120@sipsolutions.net> (sfid-20110906_222829_677927_941F230D)
Date: Tue, 06 Sep 2011 22:27:07 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 4/5] mac80211: reply only once to each PS-poll
References: <20110906201703.703254041@sipsolutions.net>
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
 include/net/mac80211.h  |    6 ++++++
 net/mac80211/rx.c       |   10 ++++++----
 net/mac80211/sta_info.c |    7 +++++--
 net/mac80211/sta_info.h |    3 +++
 net/mac80211/status.c   |    2 ++
 5 files changed, 22 insertions(+), 6 deletions(-)

--- a/net/mac80211/rx.c	2011-09-06 22:09:52.000000000 +0200
+++ b/net/mac80211/rx.c	2011-09-06 22:13:05.000000000 +0200
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
--- a/net/mac80211/sta_info.h	2011-09-06 22:09:52.000000000 +0200
+++ b/net/mac80211/sta_info.h	2011-09-06 22:23:19.000000000 +0200
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
--- a/include/net/mac80211.h	2011-09-06 22:09:52.000000000 +0200
+++ b/include/net/mac80211.h	2011-09-06 22:23:00.000000000 +0200
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
--- a/net/mac80211/status.c	2011-09-06 22:09:52.000000000 +0200
+++ b/net/mac80211/status.c	2011-09-06 22:13:05.000000000 +0200
@@ -236,6 +236,8 @@ void ieee80211_tx_status(struct ieee8021
 
 		if (info->flags & IEEE80211_TX_STATUS_EOSP)
 			clear_sta_flags(sta, WLAN_STA_SP);
+		else if (info->flags & IEEE80211_TX_STATUS_PSPOLL_RESP)
+			clear_sta_flags(sta, WLAN_STA_POLLED);
 
 		acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
 		if (!acked && test_sta_flags(sta, WLAN_STA_PS_STA)) {
--- a/net/mac80211/sta_info.c	2011-09-06 22:09:52.000000000 +0200
+++ b/net/mac80211/sta_info.c	2011-09-06 22:24:11.000000000 +0200
@@ -1262,8 +1262,11 @@ ieee80211_sta_ps_deliver_response(struct
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


