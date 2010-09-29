Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49238 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab0I2T5M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 15:57:12 -0400
Received: by fxm4 with SMTP id 4so232166fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Sep 2010 12:57:10 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [RFC v2] mac80211: fix rx monitor filter refcounters
Date: Wed, 29 Sep 2010 21:57:03 +0200
Cc: linux-wireless@vger.kernel.org
References: <201009281836.24529.chunkeey@googlemail.com> <1285744218.3756.10.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285744218.3756.10.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201009292157.04141.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 29 September 2010 09:10:18 Johannes Berg wrote:
> On Tue, 2010-09-28 at 18:36 +0200, Christian Lamparter wrote:
> > This patch fixes a refcounter & commit bug when monitor
> > rx flags are changed by:
> > 	iw dev moni set monitor [new flags]
> > 
> > while interface is up.
> > 
> > ---
> > Is there a sane way to do that?
> 
> Is this not sane enough? Looks OK to me, even if it adds a bit of code.
> 

It's about MONITOR_FLAG_COOK_FRAMES. This flag gives me headaches.
I wish we could make this flag "const" and don't allow it be changed
by iw dev wlanX set monitor. Another alternative would be to move
the "sdata->u.mntr_flag -> fif_* processing" into
ieee80211_configure_filter. 

or: 
---
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c981604..1ffe266 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -68,9 +68,61 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 		 params && params->use_4addr >= 0)
 		sdata->u.mgd.use_4addr = params->use_4addr;
 
-	if (sdata->vif.type == NL80211_IFTYPE_MONITOR && flags)
+	if (sdata->vif.type == NL80211_IFTYPE_MONITOR && flags) {
+		struct ieee80211_local *local = sdata->local;
+		u32 changed_flags;
+		u32 old_flags;
+		u32 hw_reconf_flags = 0;
+
+		old_flags = sdata->u.mntr_flags;
+		changed_flags = old_flags ^ *flags;
+		if (!(old_flags & MONITOR_FLAG_COOK_FRAMES))
+			ieee80211_adjust_monitor_flags(sdata, -1);
+
+		if (changed_flags & MONITOR_FLAG_COOK_FRAMES) {
+			if (*flags & MONITOR_FLAG_COOK_FRAMES) {
+				local->cooked_mntrs++;
+				local->monitors--;
+			} else {
+				local->monitors++;
+				local->cooked_mntrs--;
+
+				changed_flags |=
+					old_flags & ~MONITOR_FLAG_COOK_FRAMES;
+			}
+
+			switch (local->monitors) {
+			case 0:
+				local->hw.conf.flags &=
+					~IEEE80211_CONF_MONITOR;
+				hw_reconf_flags |=
+					IEEE80211_CONF_CHANGE_MONITOR;
+				break;
+
+			case 1:
+				local->hw.conf.flags |=
+					IEEE80211_CONF_MONITOR;
+				hw_reconf_flags |=
+					 IEEE80211_CONF_CHANGE_MONITOR;
+				break;
+
+			default:
+				break;
+			}
+		}
+
 		sdata->u.mntr_flags = *flags;
 
+		if (!(*flags & MONITOR_FLAG_COOK_FRAMES))
+			ieee80211_adjust_monitor_flags(sdata, 1);
+
+		if (changed_flags)
+			ieee80211_configure_filter(local);
+
+		if (hw_reconf_flags)
+			ieee80211_hw_config(local, hw_reconf_flags);
+	}
+
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
index 6678573..d59b0be 100644
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
+		local->fif_##_s += offset;				\
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
