Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37859 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab1LMUPS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 15:15:18 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1RaYkv-00036W-Np
	for linux-wireless@vger.kernel.org; Tue, 13 Dec 2011 21:15:17 +0100
Message-Id: <20111213201449.856309539@sipsolutions.net> (sfid-20111213_211524_602565_158B6DED)
Date: Tue, 13 Dec 2011 21:07:20 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 3/4] mac80211: unwind station state on destroy
References: <20111213200717.465896579@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Before destroying a station entry, unwind its
state so drivers and other code can rely on
state transitions happening.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c |    3 +++
 net/mac80211/sta_info.h |    1 +
 2 files changed, 4 insertions(+)

--- a/net/mac80211/sta_info.h	2011-12-13 19:58:01.000000000 +0100
+++ b/net/mac80211/sta_info.h	2011-12-13 20:15:32.000000000 +0100
@@ -74,6 +74,7 @@ enum ieee80211_sta_info_flags {
 };
 
 enum ieee80211_sta_state {
+	/* NOTE: These need to be ordered correctly! */
 	IEEE80211_STA_NONE,
 	IEEE80211_STA_AUTH,
 	IEEE80211_STA_ASSOC,
--- a/net/mac80211/sta_info.c	2011-12-13 19:59:57.000000000 +0100
+++ b/net/mac80211/sta_info.c	2011-12-13 20:17:25.000000000 +0100
@@ -905,6 +905,9 @@ static int __must_check __sta_info_destr
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
 
+	while (sta->sta_state > IEEE80211_STA_NONE)
+		sta_info_move_state(sta, sta->sta_state - 1);
+
 	if (sta->uploaded) {
 		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 			sdata = container_of(sdata->bss,


