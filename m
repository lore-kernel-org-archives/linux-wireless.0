Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49793 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab3CFMoS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Mar 2013 07:44:18 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH] mac80211: Call drv_set_tim only if there is a change
Date: Wed,  6 Mar 2013 13:44:10 +0100
Message-Id: <1362573850-1460-1-git-send-email-johannes@sipsolutions.net> (sfid-20130306_134421_977530_69EF968F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

It is possible that sta_info_recalc_tim() is called consecutively
without changing the station's tim bit. In such cases there is no
need to call the driver's set_tim() callback.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 852bf45..a36ceed 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -556,6 +556,15 @@ static inline void __bss_tim_clear(u8 *tim, u16 id)
 	tim[id / 8] &= ~(1 << (id % 8));
 }
 
+static inline bool __bss_tim_get(u8 *tim, u16 id)
+{
+	/*
+	 * This format has been mandated by the IEEE specifications,
+	 * so this line may not be changed to use the test_bit() format.
+	 */
+	return tim[id / 8] & (1 << (id % 8));
+}
+
 static unsigned long ieee80211_tids_for_ac(int ac)
 {
 	/* If we ever support TIDs > 7, this obviously needs to be adjusted */
@@ -636,6 +645,9 @@ void sta_info_recalc_tim(struct sta_info *sta)
  done:
 	spin_lock_bh(&local->tim_lock);
 
+	if (indicate_tim == __bss_tim_get(ps->tim, id))
+		goto out_unlock;
+
 	if (indicate_tim)
 		__bss_tim_set(ps->tim, id);
 	else
@@ -647,6 +659,7 @@ void sta_info_recalc_tim(struct sta_info *sta)
 		local->tim_in_locked_section = false;
 	}
 
+out_unlock:
 	spin_unlock_bh(&local->tim_lock);
 }
 
-- 
1.8.0

