Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51364 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab1KCI7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 04:59:43 -0400
Subject: [PATCH] mac80211: preserve EOSP in QoS header
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 09:59:39 +0100
Message-ID: <1320310779.3950.30.camel@jlt3.sipsolutions.net> (sfid-20111103_095947_428155_5FB0F193)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Janusz reported that the EOSP bit in mac80211 was
getting cleared all the time. I had not found this
since I tested uAPSD with a device that always set
the bit itself. Preserve the bit when building the
QoS header.

Reported-by: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Tested-by: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
This might conflict slightly with Thomas's patch that adds
the NOACK bit for multicast frames.

 net/mac80211/wme.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/mac80211/wme.c	2011-11-02 11:05:29.000000000 +0100
+++ b/net/mac80211/wme.c	2011-11-03 09:14:30.000000000 +0100
@@ -143,10 +143,13 @@ void ieee80211_set_qos_hdr(struct ieee80
 	/* Fill in the QoS header if there is one. */
 	if (ieee80211_is_data_qos(hdr->frame_control)) {
 		u8 *p = ieee80211_get_qos_ctl(hdr);
-		u8 ack_policy = 0, tid;
+		u8 ack_policy, tid;
 
 		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 
+		/* preserve EOSP bit */
+		ack_policy = *p & IEEE80211_QOS_CTL_EOSP;
+
 		if (unlikely(sdata->local->wifi_wme_noack_test))
 			ack_policy |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
 		/* qos header is 2 bytes */


