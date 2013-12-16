Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:60664 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab3LPWBI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 17:01:08 -0500
Received: by mail-ob0-f179.google.com with SMTP id wm4so5432462obc.38
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 14:01:08 -0800 (PST)
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	brcm80211-dev-list@broadcom.com,
	"John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Arend van Spriel <arend@broadcom.com>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [RFC PATCH 3/8] mac80211: Add powersave module
Date: Mon, 16 Dec 2013 16:00:55 -0600
Message-Id: <1387231260-2849-4-git-send-email-seth.forshee@canonical.com> (sfid-20131216_230129_367393_7332CE15)
In-Reply-To: <1387231260-2849-1-git-send-email-seth.forshee@canonical.com>
References: <1387231260-2849-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current powersave implementation manages the hw PS state
directly based on the type of interface attached to the device,
making it unsuitable for supporting multiple vifs on a single
device. This commit adds a new powersave module which will take
over the direct control of the hw PS states. The power states
of interfaces will be managed based on the interface type, and
the PS module will aggregate the interface states for a device
and set the hw PS state accordingly.

This commit adds the PS module but leaves it unused. Later
commits will convert the rest of mac80211 to use this module.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 include/net/mac80211.h     |  47 +++++++------
 net/mac80211/Makefile      |   3 +-
 net/mac80211/ieee80211_i.h |   8 +++
 net/mac80211/ps.c          | 162 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 200 insertions(+), 20 deletions(-)
 create mode 100644 net/mac80211/ps.c

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 03e4a63..3c9ce86 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1870,22 +1870,29 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
 /**
  * DOC: Powersave support
  *
+ * There are two methods by which drivers can support powersave. Drivers
+ * which support only a single interface can use the information in
+ * &struct ieee80211_conf from the config() callback. Drivers supporting
+ * multiple interfaces must implement the change_ps() callback and use the
+ * per-interface powersave state in &struct ieee80211_vif. Details for using
+ * both techniques are described in subsequent sections.
+ *
  * mac80211 has support for various powersave implementations.
  *
  * First, it can support hardware that handles all powersaving by itself,
  * such hardware should simply set the %IEEE80211_HW_SUPPORTS_PS hardware
- * flag. In that case, it will be told about the desired powersave mode
- * with the %IEEE80211_CONF_PS flag depending on the association status.
- * The hardware must take care of sending nullfunc frames when necessary,
- * i.e. when entering and leaving powersave mode. The hardware is required
- * to look at the AID in beacons and signal to the AP that it woke up when
- * it finds traffic directed to it.
- *
- * %IEEE80211_CONF_PS flag enabled means that the powersave mode defined in
- * IEEE 802.11-2007 section 11.2 is enabled. This is not to be confused
- * with hardware wakeup and sleep states. Driver is responsible for waking
- * up the hardware before issuing commands to the hardware and putting it
- * back to sleep at appropriate times.
+ * flag. In that case, depending on association status, it will be told about
+ * the desired powersave mode with the @ps_mode field or the
+ * %IEEE80211_CONF_PS flag. The hardware must take care of sending nullfunc
+ * frames when necessary, i.e. when entering and leaving powersave mode. The
+ * hardware is required to look at the AID in beacons and signal to the AP
+ * that it woke up when it finds traffic directed to it.
+ *
+ * When @ps_mode == %IEEE80211_VIF_PS_DOZE or the %IEEE80211_CONF_PS flag is
+ * set it means that the powersave mode defined in IEEE 802.11-2007 section
+ * 11.2 is enabled. This is not to be confused with hardware wakeup and sleep
+ * states. The driver is responsible for waking up the hardware before issuing
+ * commands to the hardware and putting it back to sleep at appropriate times.
  *
  * When PS is enabled, hardware needs to wakeup for beacons and receive the
  * buffered multicast/broadcast frames after the beacon. Also it must be
@@ -1903,19 +1910,21 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
  * hardware stays awake for a user-specified period of time after sending a
  * frame so that reply frames need not be buffered and therefore delayed to
  * the next wakeup. It's compromise of getting good enough latency when
- * there's data traffic and still saving significantly power in idle
- * periods.
+ * there's data traffic and still saving significant power in idle periods.
  *
  * Dynamic powersave is simply supported by mac80211 enabling and disabling
  * PS based on traffic. Driver needs to only set %IEEE80211_HW_SUPPORTS_PS
  * flag and mac80211 will handle everything automatically. Additionally,
  * hardware having support for the dynamic PS feature may set the
  * %IEEE80211_HW_SUPPORTS_DYNAMIC_PS flag to indicate that it can support
- * dynamic PS mode itself. The driver needs to look at the
- * @dynamic_ps_timeout hardware configuration value and use it that value
- * whenever %IEEE80211_CONF_PS is set. In this case mac80211 will disable
- * dynamic PS feature in stack and will just keep %IEEE80211_CONF_PS
- * enabled whenever user has enabled powersave.
+ * dynamic PS mode itself. Single-interface drivers need to look at the
+ * @dynamic_ps_timeout hardware configuration value and use that value
+ * whenever %IEEE80211_CONF_PS is set. Drivers supporting multiple interfaces
+ * should look at @dynamic_ps_active whenever @ps_mode is
+ * %IEEE80211_VIF_PS_DOZE to determine if dynamic powersave is enabled and
+ * use the @dynamic_ps_timeout value in &struct ieee80211_vif. In this case
+ * mac80211 will disable dynamic PS feature in stack and will just keep
+ * powersave enabled whenever the user has enabled powersave.
  *
  * Driver informs U-APSD client support by enabling
  * %IEEE80211_HW_SUPPORTS_UAPSD flag. The mode is configured through the
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 9d7d840..9416198 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -25,7 +25,8 @@ mac80211-y := \
 	wme.o \
 	event.o \
 	chan.o \
-	trace.o mlme.o
+	trace.o mlme.o \
+	ps.o
 
 mac80211-$(CONFIG_MAC80211_LEDS) += led.o
 mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 785d1b8..a489676 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1180,6 +1180,7 @@ struct ieee80211_local {
 #endif /* CONFIG_MAC80211_DEBUG_COUNTERS */
 
 
+	int awake_cnt;
 	int total_ps_buffered; /* total number of all buffered unicast and
 				* multicast packets for power saving stations
 				*/
@@ -1788,6 +1789,13 @@ int ieee80211_cs_headroom(struct ieee80211_local *local,
 			  struct cfg80211_crypto_settings *crypto,
 			  enum nl80211_iftype iftype);
 
+/* power save */
+void ieee80211_ps_init_vif(struct ieee80211_sub_if_data *sdata);
+void ieee80211_ps_vif_open(struct ieee80211_sub_if_data *sdata);
+void ieee80211_ps_vif_close(struct ieee80211_sub_if_data *sdata);
+void ieee80211_vif_set_ps_mode(struct ieee80211_sub_if_data *sdata,
+			       enum ieee80211_vif_ps_mode mode);
+
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
 #else
diff --git a/net/mac80211/ps.c b/net/mac80211/ps.c
new file mode 100644
index 0000000..b691e8d
--- /dev/null
+++ b/net/mac80211/ps.c
@@ -0,0 +1,162 @@
+/*
+ * Copyright (C) 2013 Canonical Ltd.
+ * Author: Seth Forshee <seth.forshee@canonical.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/nl80211.h>
+#include <linux/pm_qos.h>
+#include <net/mac80211.h>
+#include "ieee80211_i.h"
+#include "driver-ops.h"
+
+/*
+ * Sets the PS parameters in ieee80211_conf. Uses parameters from the first
+ * managed interface found which has power save enabled, or failing that
+ * the parameters from an arbitrary managed interface are used.
+ */
+static void ieee80211_set_ps_params(struct ieee80211_local *local) { struct
+	ieee80211_sub_if_data *sdata, *ps_sdata = NULL;
+
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (sdata->vif.ps_mode == IEEE80211_VIF_PS_INACTIVE)
+			continue;
+		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+			ps_sdata = sdata;
+			if (sdata->vif.dynamic_ps_active ||
+			    sdata->vif.ps_mode == IEEE80211_VIF_PS_DOZE)
+				break;
+		}
+	}
+
+	if (ps_sdata) {
+		struct ieee80211_vif *vif = &sdata->vif;
+		local->hw.conf.dynamic_ps_timeout = vif->dynamic_ps_timeout;
+		local->hw.conf.max_sleep_period = vif->max_sleep_period;
+		local->hw.conf.ps_dtim_period = vif->ps_dtim_period;
+	}
+}
+
+static void ieee80211_recalc_hw_ps(struct ieee80211_local *local)
+{
+	struct ieee80211_conf *conf = &local->hw.conf;
+	bool ps_enabled, ps_enable;
+
+	ps_enable = (local->awake_cnt == 0 &&
+		     local->hw.flags & IEEE80211_HW_SUPPORTS_PS);
+	ps_enabled = !!(conf->flags & IEEE80211_CONF_PS);
+
+	if (ps_enable != ps_enabled) {
+		if (ps_enable) {
+			conf->flags |= IEEE80211_CONF_PS;
+			ieee80211_set_ps_params(local);
+		} else {
+			conf->flags &= ~IEEE80211_CONF_PS;
+		}
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+	}
+}
+
+static void __ieee80211_vif_set_ps_mode(struct ieee80211_sub_if_data *sdata,
+					enum ieee80211_vif_ps_mode mode)
+{
+	struct ieee80211_local *local = sdata->local;
+
+	if (WARN_ON_ONCE(sdata->vif.type == NL80211_IFTYPE_MONITOR))
+		return;
+
+	switch (mode) {
+	case IEEE80211_VIF_PS_INACTIVE:
+	case IEEE80211_VIF_PS_DOZE:
+		if (sdata->vif.ps_mode > IEEE80211_VIF_PS_DOZE &&
+		    !WARN_ON(local->awake_cnt <= 0))
+			local->awake_cnt--;
+		break;
+	case IEEE80211_VIF_PS_AWAKE:
+	case IEEE80211_VIF_PS_AWAKE_PM:
+		if (sdata->vif.ps_mode <= IEEE80211_VIF_PS_DOZE)
+			local->awake_cnt++;
+		break;
+	default:
+		sdata_err(sdata, "Invalid PS mode %d\n", mode);
+		return;
+	}
+	sdata->vif.ps_mode = mode;
+}
+
+void ieee80211_ps_init_vif(struct ieee80211_sub_if_data *sdata)
+{
+	sdata->vif.dynamic_ps_active = false;
+	sdata->vif.ps_mode = IEEE80211_VIF_PS_INACTIVE;
+}
+
+void ieee80211_ps_vif_open(struct ieee80211_sub_if_data *sdata)
+{
+	if (sdata->vif.ps_mode != IEEE80211_VIF_PS_INACTIVE)
+		return;
+
+	/* Always start vifs in awake state */
+	sdata->vif.dynamic_ps_active = false;
+	if (sdata->vif.type == NL80211_IFTYPE_MONITOR) {
+		sdata->vif.ps_mode = IEEE80211_VIF_PS_AWAKE;
+		return;
+	}
+	__ieee80211_vif_set_ps_mode(sdata, IEEE80211_VIF_PS_AWAKE);
+	ieee80211_recalc_hw_ps(sdata->local);
+	drv_change_ps(sdata->local, sdata);
+}
+
+void ieee80211_ps_vif_close(struct ieee80211_sub_if_data *sdata)
+{
+	sdata->vif.dynamic_ps_active = false;
+	if (sdata->vif.type == NL80211_IFTYPE_MONITOR) {
+		sdata->vif.ps_mode = IEEE80211_VIF_PS_INACTIVE;
+		return;
+	}
+	__ieee80211_vif_set_ps_mode(sdata, IEEE80211_VIF_PS_INACTIVE);
+	drv_change_ps(sdata->local, sdata);
+	ieee80211_recalc_hw_ps(sdata->local);
+}
+
+void ieee80211_vif_set_ps_mode(struct ieee80211_sub_if_data *sdata,
+			       enum ieee80211_vif_ps_mode mode)
+{
+	/*
+	 * Only ieee80211_ps_vif_{close,open} should move interfaces in
+	 * and out of inactive mode
+	 */
+	if (WARN_ON_ONCE(mode == IEEE80211_VIF_PS_INACTIVE ||
+			 sdata->vif.ps_mode == IEEE80211_VIF_PS_INACTIVE))
+		return;
+
+	if (sdata->vif.type == NL80211_IFTYPE_MONITOR)
+		return;
+
+	/*
+	 * Skip updating the PS mode if already in the requested state,
+	 * except when setting HW dynamic PS active. In that case we
+	 * must always call down into the driver in case any of the
+	 * dynamic PS parameters have changed.
+	 */
+	if (!(sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS &&
+	      sdata->vif.dynamic_ps_active && mode == IEEE80211_VIF_PS_DOZE) &&
+	    sdata->vif.ps_mode == mode)
+		return;
+
+	__ieee80211_vif_set_ps_mode(sdata, mode);
+
+	/*
+	 * If entering powersave the vif must be transitioned first, and
+	 * the other way around when leaving.
+	 */
+	if (mode <= IEEE80211_VIF_PS_DOZE) {
+		drv_change_ps(sdata->local, sdata);
+		ieee80211_recalc_hw_ps(sdata->local);
+	} else {
+		ieee80211_recalc_hw_ps(sdata->local);
+		drv_change_ps(sdata->local, sdata);
+	}
+}
-- 
1.8.3.2

