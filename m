Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx39.mail.ru ([94.100.176.53]:59104 "EHLO mx39.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbZG3Su6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 14:50:58 -0400
Subject: [RFC PATCH v2] mac80211: FIF_PSPOLL filter flag
From: Igor Perminov <igor.perminov@inbox.ru>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Thu, 30 Jul 2009 22:50:56 +0400
Message-Id: <1248979856.29068.229.camel@sunlight>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When an interface is configured in the AP mode, the mac80211
implementation doesn't inform the driver to receive PS Poll frames.
It leads to inability to communicate with power-saving stations
reliably.
The FIF_CONTROL flag isn't passed by mac80211 to
ieee80211_ops.configure_filter when an interface is in the AP mode.
And it's ok, because we don't want to receive ACK frames and other
control ones, but only PS Poll ones.

This patch introduces the FIF_PSPOLL filter flag in addition to
FIF_CONTROL, which means for the driver "pass PS Poll frames".

This flag is passed to the driver:
A) When an interface is configured in the AP mode.
B) In all cases, when the FIF_CONTROL flag was passed earlier (in
addition to it).

Signed-off-by: Igor Perminov <igor.perminov@inbox.ru>
---
 include/net/mac80211.h     |    8 ++++++--
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/iface.c       |   18 ++++++++++++++++--
 net/mac80211/main.c        |    3 +++
 4 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d4e09a0..5113bba 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1236,10 +1236,13 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  *	mac80211 needs to do and the amount of CPU wakeups, so you should
  *	honour this flag if possible.
  *
- * @FIF_CONTROL: pass control frames, if PROMISC_IN_BSS is not set then
- *	only those addressed to this station
+ * @FIF_CONTROL: pass control frames (except for PS Poll), if PROMISC_IN_BSS
+ *  is not set then only those addressed to this station.
  *
  * @FIF_OTHER_BSS: pass frames destined to other BSSes
+ *
+ * @FIF_PSPOLL: pass PS Poll frames, if PROMISC_IN_BSS  is not set then only
+ *  those addressed to this station.
  */
 enum ieee80211_filter_flags {
 	FIF_PROMISC_IN_BSS	= 1<<0,
@@ -1249,6 +1252,7 @@ enum ieee80211_filter_flags {
 	FIF_BCN_PRBRESP_PROMISC	= 1<<4,
 	FIF_CONTROL		= 1<<5,
 	FIF_OTHER_BSS		= 1<<6,
+	FIF_PSPOLL		= 1<<7,
 };
 
 /**
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index aec6853..ab6003d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -621,7 +621,7 @@ struct ieee80211_local {
 	int open_count;
 	int monitors, cooked_mntrs;
 	/* number of interfaces with corresponding FIF_ flags */
-	int fif_fcsfail, fif_plcpfail, fif_control, fif_other_bss;
+	int fif_fcsfail, fif_plcpfail, fif_control, fif_other_bss, fif_pspoll;
 	unsigned int filter_flags; /* FIF_* */
 	struct iw_statistics wstats;
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index a83087f..c5f4559 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -220,8 +220,10 @@ static int ieee80211_open(struct net_device *dev)
 			local->fif_fcsfail++;
 		if (sdata->u.mntr_flags & MONITOR_FLAG_PLCPFAIL)
 			local->fif_plcpfail++;
-		if (sdata->u.mntr_flags & MONITOR_FLAG_CONTROL)
+		if (sdata->u.mntr_flags & MONITOR_FLAG_CONTROL) {
 			local->fif_control++;
+			local->fif_pspoll++;
+		}
 		if (sdata->u.mntr_flags & MONITOR_FLAG_OTHER_BSS)
 			local->fif_other_bss++;
 
@@ -244,7 +246,14 @@ static int ieee80211_open(struct net_device *dev)
 			spin_unlock_bh(&local->filter_lock);
 
 			ieee80211_start_mesh(sdata);
+		} else if (sdata->vif.type == NL80211_IFTYPE_AP) {
+			local->fif_pspoll++;
+
+			spin_lock_bh(&local->filter_lock);
+			ieee80211_configure_filter(local);
+			spin_unlock_bh(&local->filter_lock);
 		}
+
 		changed |= ieee80211_reset_erp_info(sdata);
 		ieee80211_bss_info_change_notify(sdata, changed);
 		ieee80211_enable_keys(sdata);
@@ -388,6 +397,9 @@ static int ieee80211_stop(struct net_device *dev)
 	if (sdata->flags & IEEE80211_SDATA_PROMISC)
 		atomic_dec(&local->iff_promiscs);
 
+	if (sdata->vif.type == NL80211_IFTYPE_AP)
+		local->fif_pspoll--;
+
 	netif_addr_lock_bh(dev);
 	spin_lock_bh(&local->filter_lock);
 	__dev_addr_unsync(&local->mc_list, &local->mc_count,
@@ -439,8 +451,10 @@ static int ieee80211_stop(struct net_device *dev)
 			local->fif_fcsfail--;
 		if (sdata->u.mntr_flags & MONITOR_FLAG_PLCPFAIL)
 			local->fif_plcpfail--;
-		if (sdata->u.mntr_flags & MONITOR_FLAG_CONTROL)
+		if (sdata->u.mntr_flags & MONITOR_FLAG_CONTROL) {
+			local->fif_pspoll--;
 			local->fif_control--;
+		}
 		if (sdata->u.mntr_flags & MONITOR_FLAG_OTHER_BSS)
 			local->fif_other_bss--;
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 5e76dd1..c330235 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -77,6 +77,9 @@ void ieee80211_configure_filter(struct ieee80211_local *local)
 	if (local->fif_other_bss)
 		new_flags |= FIF_OTHER_BSS;
 
+	if (local->fif_pspoll)
+		new_flags |= FIF_PSPOLL;
+
 	changed_flags = local->filter_flags ^ new_flags;
 
 	/* be a bit nasty */


