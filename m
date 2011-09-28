Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39244 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab1I1MNa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 08:13:30 -0400
Message-Id: <20110928121131.423300879@sipsolutions.net> (sfid-20110928_141333_862089_6AAFC9B7)
Date: Wed, 28 Sep 2011 14:08:59 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 10/15] mac80211: reply only once to each PS-poll
References: <20110928120849.882884360@sipsolutions.net>
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

--- a/net/mac80211/rx.c	2011-09-28 13:34:03.000000000 +0200
+++ b/net/mac80211/rx.c	2011-09-28 13:38:11.000000000 +0200
@@ -1194,10 +1194,12 @@ ieee80211_rx_h_uapsd_and_pspoll(struct i
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
--- a/net/mac80211/sta_info.h	2011-09-28 13:34:03.000000000 +0200
+++ b/net/mac80211/sta_info.h	2011-09-28 13:38:11.000000000 +0200
@@ -50,7 +50,7 @@
  *	keeping station in power-save mode, reply when the driver
  *	unblocks the station.
  * @WLAN_STA_SP: Station is in a service period, so don't try to
- *	reply to other uAPSD trigger frames.
+ *	reply to other uAPSD trigger frames or PS-Poll.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH		= 1<<0,
--- a/include/net/mac80211.h	2011-09-28 13:34:03.000000000 +0200
+++ b/include/net/mac80211.h	2011-09-28 13:38:11.000000000 +0200
@@ -370,7 +370,8 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_STATUS_EOSP: This packet marks the end of service period,
  *	when its status is reported the service period ends. For frames in
  *	an SP that mac80211 transmits, it is already set; for driver frames
- *	the driver may set this flag.
+ *	the driver may set this flag. It is also used to do the same for
+ *	PS-Poll responses.
  *
  * Note: If you have to add new flags to the enumeration, then don't
  *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
@@ -1959,6 +1960,12 @@ enum ieee80211_frame_release_type {
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
--- a/net/mac80211/sta_info.c	2011-09-28 13:35:51.000000000 +0200
+++ b/net/mac80211/sta_info.c	2011-09-28 13:38:11.000000000 +0200
@@ -1207,13 +1207,12 @@ static void ieee80211_send_null_response
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
@@ -1231,6 +1230,9 @@ ieee80211_sta_ps_deliver_response(struct
 	unsigned long driver_release_tids = 0;
 	struct sk_buff_head frames;
 
+	/* Service or PS-Poll period starts */
+	set_sta_flags(sta, WLAN_STA_SP);
+
 	__skb_queue_head_init(&frames);
 
 	/*
@@ -1347,10 +1349,11 @@ ieee80211_sta_ps_deliver_response(struct
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
 
@@ -1412,9 +1415,6 @@ void ieee80211_sta_ps_deliver_uapsd(stru
 	if (!delivery_enabled)
 		return;
 
-	/* Ohh, finally, the service period starts :-) */
-	set_sta_flags(sta, WLAN_STA_SP);
-
 	switch (sta->sta.max_sp) {
 	case 1:
 		n_frames = 2;


