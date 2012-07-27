Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51455 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab2G0LRx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:17:53 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 11/20] mac80211: use oper_channel in rate init
Date: Fri, 27 Jul 2012 13:16:47 +0200
Message-Id: <1343387816-9414-12-git-send-email-johannes@sipsolutions.net> (sfid-20120727_131822_387617_C871E0A7)
In-Reply-To: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Using hw.conf.channel is wrong as it could be the
temporary channel if the station is added from the
workqueue while the device is already on another
channel. Use oper_channel instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rate.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index 6e4fd32..10de668 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -56,7 +56,7 @@ static inline void rate_control_rate_init(struct sta_info *sta)
 	if (!ref)
 		return;
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	sband = local->hw.wiphy->bands[local->oper_channel->band];
 
 	ref->ops->rate_init(ref->priv, sband, ista, priv_sta);
 	set_sta_flag(sta, WLAN_STA_RATE_CONTROL);
-- 
1.7.10.4

