Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56681 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbaJVTXR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 15:23:17 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 6/9] mac80211: support creating wiphy w/out creating wlanX
Date: Wed, 22 Oct 2014 12:23:03 -0700
Message-Id: <1414005786-27572-6-git-send-email-greearb@candelatech.com> (sfid-20141022_212332_923064_A91683E7)
In-Reply-To: <1414005786-27572-1-git-send-email-greearb@candelatech.com>
References: <1414005786-27572-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This will be helpful when using the mac80211_hwsim
wiphys and automated testing.  Let user create the
vifs as needed, and named as expected.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 include/net/mac80211.h | 7 ++++++-
 net/mac80211/main.c    | 3 ++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3cf3ab8..1fd995d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1580,6 +1580,10 @@ struct ieee80211_tx_control {
  *	a virtual monitor interface when monitor interfaces are the only
  *	active interfaces.
  *
+ * @IEEE80211_HW_NO_AUTO_VIF: The driver would like for no wlanX to
+ *	be created.  It is expected user-space will create vifs as
+ *	desired (and thus have them named as desired).
+ *
  * @IEEE80211_HW_QUEUE_CONTROL: The driver wants to control per-interface
  *	queue mapping in order to use different queues (not just one per AC)
  *	for different virtual interfaces. See the doc section on HW queue
@@ -1626,7 +1630,8 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_DYNAMIC_PS		= 1<<12,
 	IEEE80211_HW_MFP_CAPABLE			= 1<<13,
 	IEEE80211_HW_WANT_MONITOR_VIF			= 1<<14,
-	/* free slots */
+	IEEE80211_HW_NO_AUTO_VIF			= 1<<15,
+	/* free slot */
 	IEEE80211_HW_SUPPORTS_UAPSD			= 1<<17,
 	IEEE80211_HW_REPORTS_TX_ACK_STATUS		= 1<<18,
 	IEEE80211_HW_CONNECTION_MONITOR			= 1<<19,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index b189122..7d40e3f 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1023,7 +1023,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	}
 
 	/* add one default STA interface if supported */
-	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION)) {
+	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION) &&
+	    !(hw->flags & IEEE80211_HW_NO_AUTO_VIF)) {
 		result = ieee80211_if_add(local, "wlan%d", NULL,
 					  NL80211_IFTYPE_STATION, NULL);
 		if (result)
-- 
1.7.11.7

