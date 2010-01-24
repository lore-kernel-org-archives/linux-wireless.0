Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:51758 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab0AXTol (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 14:44:41 -0500
Message-ID: <4B5CA323.90401@openwrt.org>
Date: Sun, 24 Jan 2010 20:44:35 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: fix WARN_ON in the new work code
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_work_rx_mgmt currently enqueues various management frames,
including deauth and disassoc frames, however the function
ieee80211_work_rx_queued_mgmt does not handle these, as they should
only occur if the AP is buggy. It does emit a WARN_ON when this happens
though, and several users have reported such instances.
Fix the WARN_ON by not queueing such frames in the first place.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -1022,8 +1022,6 @@ ieee80211_rx_result ieee80211_work_rx_mg
 		case IEEE80211_STYPE_PROBE_RESP:
 		case IEEE80211_STYPE_ASSOC_RESP:
 		case IEEE80211_STYPE_REASSOC_RESP:
-		case IEEE80211_STYPE_DEAUTH:
-		case IEEE80211_STYPE_DISASSOC:
 			skb_queue_tail(&local->work_skb_queue, skb);
 			ieee80211_queue_work(&local->hw, &local->work_work);
 			return RX_QUEUED;
