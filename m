Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62208 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895Ab0JAVxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 17:53:25 -0400
Received: by fxm14 with SMTP id 14so923215fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 14:53:23 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: fix rx monitor filter refcounters
Date: Fri, 1 Oct 2010 23:53:20 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
References: <201009281836.24529.chunkeey@googlemail.com> <201009292157.04141.chunkeey@googlemail.com> <1285790439.3756.35.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285790439.3756.35.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010012353.21053.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a refcounter & commit bug when monitor
rx flags are changed by:
        iw dev moni set monitor [new flags]

while interface is up.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
On Wednesday 29 September 2010 22:00:39 Johannes wrote:
> On Wed, 2010-09-29 at 21:57 +0200, Christian wrote:
> > It's about MONITOR_FLAG_COOK_FRAMES. This flag gives me
> > headaches. I wish we could make this flag "const" and
> > don't allow it be changed by iw dev wlanX set monitor.
>  
> I'm fine with not allowing the cook flag to change,
> seems like a pretty special case anyway. Or, we can
> allow it to change, but only while the interface is
> down, right?
jup, works:

command failed: Function not implemented (-38), or should
we use a different error code like -EBUSY/-EOPNOTSUPP?
---
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c981604..554166b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -68,8 +68,36 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 		 params && params->use_4addr >= 0)
 		sdata->u.mgd.use_4addr = params->use_4addr;
 
-	if (sdata->vif.type == NL80211_IFTYPE_MONITOR && flags)
-		sdata->u.mntr_flags = *flags;
+	if (sdata->vif.type == NL80211_IFTYPE_MONITOR && flags) {
+		struct ieee80211_local *local = sdata->local;
+
+		if (test_bit(SDATA_STATE_RUNNING, &sdata->state)) {
+			/*
+			 * Prohibit MONITOR_FLAG_COOK_FRAMES to be
+			 * changed while the interface is up.
+			 * Else we would need to add a lot of cruft
+			 * to update everything:
+			 *	cooked_mntrs, monitor and all fif_* counters
+			 *	reconfigure hardware
+			 */
+			if ((*flags & MONITOR_FLAG_COOK_FRAMES) !=
+			    (sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES))
+				return -ENOSYS;
+
+			ieee80211_adjust_monitor_flags(sdata, -1);
+			sdata->u.mntr_flags = *flags;
+			ieee80211_adjust_monitor_flags(sdata, 1);
+
+			ieee80211_configure_filter(local);
+		} else {
+			/*
+			 * Because the interface is down, ieee80211_do_stop
+			 * and ieee80211_do_open take care of "everything"
+			 * mentioned in the comment above.
+			 */
+			sdata->u.mntr_flags = *flags;
+		}
+	}
 
 	return 0;
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 945fbf2..f6a6d78 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1132,6 +1132,8 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata);
 void ieee80211_remove_interfaces(struct ieee80211_local *local);
 u32 __ieee80211_recalc_idle(struct ieee80211_local *local);
 void ieee80211_recalc_idle(struct ieee80211_local *local);
+void ieee80211_adjust_monitor_flags(struct ieee80211_sub_if_data *sdata,
+				    const int offset);
 
 static inline bool ieee80211_sdata_running(struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 6678573..1300e88 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -148,6 +148,26 @@ static int ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
+void ieee80211_adjust_monitor_flags(struct ieee80211_sub_if_data *sdata,
+				    const int offset)
+{
+	struct ieee80211_local *local = sdata->local;
+	u32 flags = sdata->u.mntr_flags;
+
+#define ADJUST(_f, _s)	do {					\
+	if (flags & MONITOR_FLAG_##_f)				\
+		local->fif_##_s += offset;			\
+	} while (0)
+
+	ADJUST(FCSFAIL, fcsfail);
+	ADJUST(PLCPFAIL, plcpfail);
+	ADJUST(CONTROL, control);
+	ADJUST(CONTROL, pspoll);
+	ADJUST(OTHER_BSS, other_bss);
+
+#undef ADJUST
+}
+
 /*
  * NOTE: Be very careful when changing this function, it must NOT return
  * an error on interface type changes that have been pre-checked, so most
@@ -240,17 +260,7 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 			hw_reconf_flags |= IEEE80211_CONF_CHANGE_MONITOR;
 		}
 
-		if (sdata->u.mntr_flags & MONITOR_FLAG_FCSFAIL)
-			local->fif_fcsfail++;
-		if (sdata->u.mntr_flags & MONITOR_FLAG_PLCPFAIL)
-			local->fif_plcpfail++;
-		if (sdata->u.mntr_flags & MONITOR_FLAG_CONTROL) {
-			local->fif_control++;
-			local->fif_pspoll++;
-		}
-		if (sdata->u.mntr_flags & MONITOR_FLAG_OTHER_BSS)
-			local->fif_other_bss++;
-
+		ieee80211_adjust_monitor_flags(sdata, 1);
 		ieee80211_configure_filter(local);
 
 		netif_carrier_on(dev);
@@ -477,17 +487,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 			hw_reconf_flags |= IEEE80211_CONF_CHANGE_MONITOR;
 		}
 
-		if (sdata->u.mntr_flags & MONITOR_FLAG_FCSFAIL)
-			local->fif_fcsfail--;
-		if (sdata->u.mntr_flags & MONITOR_FLAG_PLCPFAIL)
-			local->fif_plcpfail--;
-		if (sdata->u.mntr_flags & MONITOR_FLAG_CONTROL) {
-			local->fif_pspoll--;
-			local->fif_control--;
-		}
-		if (sdata->u.mntr_flags & MONITOR_FLAG_OTHER_BSS)
-			local->fif_other_bss--;
-
+		ieee80211_adjust_monitor_flags(sdata, -1);
 		ieee80211_configure_filter(local);
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
