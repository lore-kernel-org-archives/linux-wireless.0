Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59729 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbaIZXY1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 19:24:27 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 3/4] wireless:  support creating wiphy w/out creating wlanX.
Date: Fri, 26 Sep 2014 16:24:15 -0700
Message-Id: <1411773856-25042-3-git-send-email-greearb@candelatech.com> (sfid-20140927_012439_719932_AF1F8F08)
In-Reply-To: <1411773856-25042-1-git-send-email-greearb@candelatech.com>
References: <1411773856-25042-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This will be helpful when using the mac80211_hwsim
wiphys and automated testing.  Let user create the
wlan devs as needed, and named as expected.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  New to the series, more help with automation.

 include/net/mac80211.h | 7 ++++++-
 net/mac80211/main.c    | 3 ++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0ad1f47..5c3dade2 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1576,6 +1576,10 @@ struct ieee80211_tx_control {
  *	a virtual monitor interface when monitor interfaces are the only
  *	active interfaces.
  *
+ * @IEEE80211_HW_NO_AUTO_VDEV: The driver would like for no wlanX to
+ *	be created.  It is expected user-space will create vdevs as
+ *      desired (and thus have them named as desired).
+ *
  * @IEEE80211_HW_QUEUE_CONTROL: The driver wants to control per-interface
  *	queue mapping in order to use different queues (not just one per AC)
  *	for different virtual interfaces. See the doc section on HW queue
@@ -1622,7 +1626,8 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_DYNAMIC_PS		= 1<<12,
 	IEEE80211_HW_MFP_CAPABLE			= 1<<13,
 	IEEE80211_HW_WANT_MONITOR_VIF			= 1<<14,
-	/* free slots */
+	IEEE80211_HW_NO_AUTO_VDEV			= 1<<15,
+	/* free slot */
 	IEEE80211_HW_SUPPORTS_UAPSD			= 1<<17,
 	IEEE80211_HW_REPORTS_TX_ACK_STATUS		= 1<<18,
 	IEEE80211_HW_CONNECTION_MONITOR			= 1<<19,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0de7c93..8106770 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1019,7 +1019,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	}
 
 	/* add one default STA interface if supported */
-	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION)) {
+	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION) &&
+	    !(hw->flags & IEEE80211_HW_NO_AUTO_VDEV)) {
 		result = ieee80211_if_add(local, "wlan%d", NULL,
 					  NL80211_IFTYPE_STATION, NULL);
 		if (result)
-- 
1.7.11.7

