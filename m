Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64985 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958Ab0JBLRP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 07:17:15 -0400
Received: by fxm14 with SMTP id 14so1064921fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 04:17:13 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2] mac80211: fix rx monitor filter refcounters
Date: Sat, 2 Oct 2010 13:17:07 +0200
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <201009281836.24529.chunkeey@googlemail.com> <201010012353.21053.chunkeey@googlemail.com> <1286009187.1646.2.camel@Nokia-N900-51-1>
In-Reply-To: <1286009187.1646.2.camel@Nokia-N900-51-1>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010021317.07864.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes an refcounting bug. Previously it
was possible to corrupt the per-device recv. filter
and monitor management counters when:
	iw dev wlanX set monitor [new flags]
was issued on an active monitor interface.

Acked-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
On Saturday 02 October 2010 10:46:27 Johannes Berg wrote:
> > +        if (test_bit(SDATA_STATE_RUNNING, &sdata->state)) {
> 
> There's an inline for this, I think?
> 
> >   static inline bool ieee80211_sdata_running(struct ieee80211_sub_if_data
> 
> heh, by accident it's even in your patch :)
but what an accident!
---
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c981604..9e63fc2 100644
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
+		if (ieee80211_sdata_running(sdata)) {
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
+				return -EBUSY;
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
