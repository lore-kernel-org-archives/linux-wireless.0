Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:17670 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156Ab0LGCtL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 21:49:11 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 18:48:56 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	<amod.bodas@atheros.com>, <pstew@google.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/5] mac80211: fix idle change notifications upon device stop
Date: Mon, 6 Dec 2010 18:48:54 -0800
Message-ID: <1291690135-4535-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1291690135-4535-1-git-send-email-lrodriguez@atheros.com>
References: <1291690135-4535-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers that depend on tuning their devices to disable the radio
completely and properly through mac80211' idle state change
were being left with the radio turned on once a device interface
is stopped, the reason is that we first were checking for the open
count prior to issuing any further config changes. For some devices
this could mean breaking suspend and resume completely as they were
under the impression that the idle state change to idle would be
issued either during or after the stop callback. Fix this by
allowing state changes through upon the device stop.

This fixes suspend and resume on ath9k and likely a few other
drivers.

Cc: stable@kernel.org
Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/ieee80211_i.h |    9 ++++++++-
 net/mac80211/iface.c       |    9 ++-------
 net/mac80211/main.c        |    4 ++--
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 72499fe..ae32349 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1023,8 +1023,15 @@ static inline int ieee80211_bssid_match(const u8 *raddr, const u8 *addr)
 	       is_broadcast_ether_addr(raddr);
 }
 
+int __ieee80211_hw_config(struct ieee80211_local *local,
+			  u32 changed, bool nocheck);
+
+static inline int ieee80211_hw_config(struct ieee80211_local *local,
+				      u32 changed)
+{
+	return __ieee80211_hw_config(local, changed, false);
+}
 
-int ieee80211_hw_config(struct ieee80211_local *local, u32 changed);
 void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx);
 void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 				      u32 changed);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index f0f11bb..36b7000 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -530,20 +530,15 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_recalc_ps(local, -1);
 
+	__ieee80211_hw_config(local, hw_reconf_flags, true);
+
 	if (local->open_count == 0) {
 		if (local->ops->napi_poll)
 			napi_disable(&local->napi);
 		ieee80211_clear_tx_pending(local);
 		ieee80211_stop_device(local);
-
-		/* no reconfiguring after stop! */
-		hw_reconf_flags = 0;
 	}
 
-	/* do after stop to avoid reconfiguring when we stop anyway */
-	if (hw_reconf_flags)
-		ieee80211_hw_config(local, hw_reconf_flags);
-
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 	for (i = 0; i < IEEE80211_MAX_QUEUES; i++) {
 		skb_queue_walk_safe(&local->pending[i], skb, tmp) {
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 2de6976..45d6f21 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -96,7 +96,7 @@ static void ieee80211_reconfig_filter(struct work_struct *work)
 	ieee80211_configure_filter(local);
 }
 
-int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
+int __ieee80211_hw_config(struct ieee80211_local *local, u32 changed, bool nocheck)
 {
 	struct ieee80211_channel *chan, *scan_chan;
 	int ret = 0;
@@ -159,7 +159,7 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 		local->hw.conf.power_level = power;
 	}
 
-	if (changed && local->open_count) {
+	if (changed && (nocheck || local->open_count)) {
 		ret = drv_config(local, changed);
 		/*
 		 * Goal:
-- 
1.7.3.2.90.gd4c43

