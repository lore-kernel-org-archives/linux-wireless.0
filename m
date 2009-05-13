Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60178 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357AbZEMJVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 05:21:00 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC v2 1/5] mac80211: fix idle trigger upon resume
Date: Wed, 13 May 2009 05:20:57 -0400
Message-Id: <1242206461-30793-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
References: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we suspend we stop the queues, then upon resume
the new idle checks will immediately pick up we're
idle and call our driver's config callback. At
this point its pointless to to call this callback
as we haven't yet come back from suspend. We avoid
then making assumptions about being idle until we know
we've come back from suspend.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/iface.c       |    4 ++++
 net/mac80211/pm.c          |    2 ++
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index fec3ded..43f3d07 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -609,6 +609,7 @@ struct ieee80211_local {
 	unsigned int filter_flags; /* FIF_* */
 	struct iw_statistics wstats;
 	bool tim_in_locked_section; /* see ieee80211_beacon_get() */
+	bool suspended; /* true if we finished suspend work for it */
 	int tx_headroom; /* required headroom for hardware/radiotap */
 
 	/* Tasklet and skb queue to process calls from IRQ mode. All frames
@@ -1047,6 +1048,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw);
 
 static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 {
+	hw_to_local(hw)->suspended = false;
 	return ieee80211_reconfig(hw_to_local(hw));
 }
 #else
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 8c9f1c7..5e091a7 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -931,6 +931,10 @@ u32 __ieee80211_recalc_idle(struct ieee80211_local *local)
 	struct ieee80211_sub_if_data *sdata;
 	int count = 0;
 
+	/* allow resume to finish before we make any assumptions */
+	if (local->suspended)
+		return 0;
+
 	if (local->hw_scanning || local->sw_scanning)
 		return ieee80211_idle_off(local, "scanning");
 
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 9d3d89a..8883d05 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -65,6 +65,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
 	/* flush again, in case driver queued work */
 	flush_workqueue(local->hw.workqueue);
 
+	local->suspended = true;
+
 	/* stop hardware */
 	if (local->open_count) {
 		ieee80211_led_radio(local, false);
-- 
1.6.0.6

