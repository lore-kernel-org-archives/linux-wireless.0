Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55552 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1IVPuP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 11:50:15 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1R6lXS-0002Ra-IY
	for linux-wireless@vger.kernel.org; Thu, 22 Sep 2011 17:50:14 +0200
Message-Id: <20110922154851.295652960@sipsolutions.net> (sfid-20110922_175023_594988_C298A21E)
Date: Thu, 22 Sep 2011 17:47:36 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 10/15] mac80211: reply only once to each PS-poll
References: <20110922154726.521122680@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If a PS-poll frame is retried (but was received)
there is no way to detect that since it has no
sequence number. As a consequence, the standard
asks us to not react to PS-poll frames until the
response to one made it out (was ACKed or lost).

Implement this by using the WLAN_STA_SP flags to
also indicate a PS-Poll "service period" and the
IEEE80211_TX_STATUS_EOSP flag for the response
packet to indicate the end of the "SP" as usual.

We could use separate flags, but that will most
likely completely confuse drivers, and while the
standard doesn't exclude simultaneously polling
using uAPSD and PS-Poll, doing that seems quite
problematic.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h  |    9 ++++++++-
 net/mac80211/rx.c       |   10 ++++++----
 net/mac80211/sta_info.c |   22 +++++++++++-----------
 net/mac80211/sta_info.h |    2 +-
 4 files changed, 26 insertions(+), 17 deletions(-)

--- a/net/mac80211/rx.c	2011-09-22 17:14:51.000000000 +0200
+++ b/net/mac80211/rx.c	2011-09-22 17:16:25.000000000 +0200
@@ -1186,10 +1186,12 @@ ieee80211_rx_h_uapsd_and_pspoll(struct i
 		return RX_CONTINUE;
 
 	if (unlikely(ieee80211_is_pspoll(hdr->frame_control))) {
-		if (!test_sta_flags(rx->sta, WLAN_STA_PS_DRIVER))
-			ieee80211_sta_ps_deliver_poll_response(rx->sta);
-		else
-			set_sta_flags(rx->sta, WLAN_STA_PSPOLL);
+		if (!test_sta_flags(rx->sta, WLAN_STA_SP)) {
+			if (!test_sta_flags(rx->sta, WLAN_STA_PS_DRIVER))
+				ieee80211_sta_ps_deliver_poll_response(rx->sta);
+			else
+				set_sta_flags(rx->sta, WLAN_STA_PSPOLL);
+		}
 
 		/* Free PS Poll skb here instead of returning RX_DROP that would
 		 * count as an dropped frame. */
--- a/net/mac80211/sta_info.h	2011-09-22 17:14:51.000000000 +0200
+++ b/net/mac80211/sta_info.h	2011-09-22 17:16:25.000000000 +0200
@@ -47,7 +47,7 @@
  *	keeping station in power-save mode, reply when the driver
  *	unblocks the station.
  * @WLAN_STA_SP: Station is in a service period, so don't try to
- *	reply to other uAPSD trigger frames.
+ *	reply to other uAPSD trigger frames or PS-Poll.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH		= 1<<0,
--- a/include/net/mac80211.h	2011-09-22 17:14:51.000000000 +0200
+++ b/include/net/mac80211.h	2011-09-22 17:16:25.000000000 +0200
@@ -367,7 +367,8 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_STATUS_EOSP: This packet marks the end of service period,
  *	when its status is reported the service period ends. For frames in
  *	an SP that mac80211 transmits, it is already set; for driver frames
- *	the driver may set this flag.
+ *	the driver may set this flag. It is also used to do the same for
+ *	PS-Poll responses.
  *
  * Note: If you have to add new flags to the enumeration, then don't
  *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
@@ -1955,6 +1956,12 @@ enum ieee80211_frame_release_type {
  *	more-data bit must always be set.
  *	The @tids parameter tells the driver which TIDs to release frames
  *	from, for PS-poll it will always have only a single bit set.
+ *	In the case this is used for a PS-poll initiated release, the
+ *	@num_frames parameter will always be 1 so code can be shared. In
+ *	this case the driver must also set %IEEE80211_TX_STATUS_EOSP flag
+ *	on the TX status (and must report TX status) so that the PS-poll
+ *	period is properly ended. This is used to avoid sending multiple
+ *	responses for a retried PS-poll frame.
  *	In the case this is used for uAPSD, the @num_frames parameter may be
  *	bigger than one, but the driver may send fewer frames (it must send
  *	at least one, however). In this case it is also responsible for
--- a/net/mac80211/sta_info.c	2011-09-22 17:16:17.000000000 +0200
+++ b/net/mac80211/sta_info.c	2011-09-22 17:16:25.000000000 +0200
@@ -1205,13 +1205,12 @@ static void ieee80211_send_null_response
 	/*
 	 * Tell TX path to send this frame even though the
 	 * STA may still remain is PS mode after this frame
-	 * exchange.
+	 * exchange. Also set EOSP to indicate this packet
+	 * ends the poll/service period.
 	 */
-	info->flags |= IEEE80211_TX_CTL_POLL_RESPONSE;
-
-	if (uapsd)
-		info->flags |= IEEE80211_TX_STATUS_EOSP |
-			       IEEE80211_TX_CTL_REQ_TX_STATUS;
+	info->flags |= IEEE80211_TX_CTL_POLL_RESPONSE |
+		       IEEE80211_TX_STATUS_EOSP |
+		       IEEE80211_TX_CTL_REQ_TX_STATUS;
 
 	ieee80211_xmit(sdata, skb);
 }
@@ -1229,6 +1228,9 @@ ieee80211_sta_ps_deliver_response(struct
 	unsigned long driver_release_tids = 0;
 	struct sk_buff_head frames;
 
+	/* Service or PS-Poll period starts */
+	set_sta_flags(sta, WLAN_STA_SP);
+
 	__skb_queue_head_init(&frames);
 
 	/*
@@ -1345,10 +1347,11 @@ ieee80211_sta_ps_deliver_response(struct
 				/* set EOSP for the frame */
 				u8 *p = ieee80211_get_qos_ctl(hdr);
 				*p |= IEEE80211_QOS_CTL_EOSP;
-				info->flags |= IEEE80211_TX_STATUS_EOSP |
-					       IEEE80211_TX_CTL_REQ_TX_STATUS;
 			}
 
+			info->flags |= IEEE80211_TX_STATUS_EOSP |
+				       IEEE80211_TX_CTL_REQ_TX_STATUS;
+
 			__skb_queue_tail(&pending, skb);
 		}
 
@@ -1410,9 +1413,6 @@ void ieee80211_sta_ps_deliver_uapsd(stru
 	if (!delivery_enabled)
 		return;
 
-	/* Ohh, finally, the service period starts :-) */
-	set_sta_flags(sta, WLAN_STA_SP);
-
 	switch (sta->sta.max_sp) {
 	case 1:
 		n_frames = 2;


