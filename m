Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49177 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbZAFRw6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 12:52:58 -0500
Subject: [RFC] mac80211: extend/document powersave API
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: Vivek Natarajan <vnatarajan@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 18:53:15 +0100
Message-Id: <1231264395.3654.10.camel@johannes> (sfid-20090106_185303_172430_25DAEFFB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This modifies hardware flags for powersave to support three different
flags:
 * IEEE80211_HW_SUPPORTS_PS - indicates general PS support
 * IEEE80211_HW_PS_NULLFUNC_STACK - indicates nullfunc/... handling in software
 * IEEE80211_HW_SUPPORTS_DYNAMIC_PS - indicates dynamic PS on the device

It also adds documentation for all this which explains how to set the
various flags.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    3 +-
 drivers/net/wireless/rt2x00/rt2400pci.c |    4 ++
 drivers/net/wireless/rt2x00/rt2500pci.c |    4 ++
 drivers/net/wireless/rt2x00/rt2500usb.c |    4 ++
 drivers/net/wireless/rt2x00/rt61pci.c   |    4 ++
 drivers/net/wireless/rt2x00/rt73usb.c   |    4 ++
 include/net/mac80211.h                  |   47 ++++++++++++++++++++++++++++----
 net/mac80211/mlme.c                     |    4 +-
 net/mac80211/tx.c                       |    2 -
 net/mac80211/wext.c                     |   31 +++++++++++++++++++--
 10 files changed, 90 insertions(+), 17 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-01-06 18:33:50.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-01-06 18:50:45.000000000 +0100
@@ -858,10 +858,15 @@ enum ieee80211_tkip_key_type {
  * @IEEE80211_HW_AMPDU_AGGREGATION:
  *	Hardware supports 11n A-MPDU aggregation.
  *
- * @IEEE80211_HW_NO_STACK_DYNAMIC_PS:
- *	Hardware which has dynamic power save support, meaning
- *	that power save is enabled in idle periods, and don't need support
- *	from stack.
+ * @IEEE80211_HW_SUPPORTS_PS:
+ *	Hardware has power save support (i.e. can go to sleep).
+ *
+ * @IEEE80211_HW_PS_NULLFUNC_STACK:
+ *	Hardware requires nullfunc frame handling in stack, implies
+ *	stack support for dynamic PS.
+ *
+ * @IEEE80211_HW_SUPPORTS_DYNAMIC_PS:
+ *	Hardware has support for dynamic PS.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_RX_INCLUDES_FCS			= 1<<1,
@@ -874,7 +879,9 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_NOISE_DBM				= 1<<8,
 	IEEE80211_HW_SPECTRUM_MGMT			= 1<<9,
 	IEEE80211_HW_AMPDU_AGGREGATION			= 1<<10,
-	IEEE80211_HW_NO_STACK_DYNAMIC_PS		= 1<<11,
+	IEEE80211_HW_SUPPORTS_PS			= 1<<11,
+	IEEE80211_HW_PS_NULLFUNC_STACK			= 1<<12,
+	IEEE80211_HW_SUPPORTS_DYNAMIC_PS		= 1<<13,
 };
 
 /**
@@ -1061,6 +1068,36 @@ ieee80211_get_alt_retry_rate(const struc
  */
 
 /**
+ * DOC: Powersave support
+ *
+ * mac80211 has support for various powersave implementations.
+ *
+ * First, it can support hardware that handles all powersaving by
+ * itself, such hardware should simply set the %IEEE80211_HW_SUPPORTS_PS
+ * hardware flag. In that case, it will be told about the desired
+ * powersave mode regardless of association status, and the driver or
+ * hardware must take care of enabling/disabling powersave depending on
+ * the association status and TIM bit and send nullfunc frames by itself.
+ *
+ * Additionally, such hardware may set the %IEEE80211_HW_SUPPORTS_DYNAMIC_PS
+ * flag to indicate that it can support dynamic PS mode (see below).
+ *
+ * Other hardware designs cannot send nullfunc frames by themselves and
+ * need to be told explicitly about powersave transitions depending on
+ * association status, need software support for parsing the TIM bitmap
+ * and can implement dynamic PS mode in software. This is also supported
+ * by mac80211 by combining the %IEEE80211_HW_SUPPORTS_PS and
+ * %IEEE80211_HW_PS_NULLFUNC_STACK flags.
+ *
+ * Dynamic powersave mode is an extension to normal powersave mode in which
+ * the hardware stays awake for a user-specified period of time after sending
+ * a frame so that reply frames need not be buffered and therefore delayed
+ * to the next wakeup. This can either be supported by hardware, in which case
+ * the driver needs to look at the @dynamic_ps_timeout hardware configuration
+ * value, or by the stack if all nullfunc handling is in the stack.
+ */
+
+/**
  * DOC: Frame filtering
  *
  * mac80211 requires to see many management frames for proper
--- wireless-testing.orig/net/mac80211/wext.c	2009-01-06 18:34:21.000000000 +0100
+++ wireless-testing/net/mac80211/wext.c	2009-01-06 18:50:59.000000000 +0100
@@ -836,6 +836,9 @@ static int ieee80211_ioctl_siwpower(stru
 	int ret = 0, timeout = 0;
 	bool ps;
 
+	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
+		return -EOPNOTSUPP;
+
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return -EINVAL;
 
@@ -858,8 +861,17 @@ static int ieee80211_ioctl_siwpower(stru
 	if (wrq->flags & ~(IW_POWER_MODE | IW_POWER_TIMEOUT))
 		return -EINVAL;
 
-	if (wrq->flags & IW_POWER_TIMEOUT)
+	if (wrq->flags & IW_POWER_TIMEOUT) {
+		/*
+		 * dynamic PS only supported if nullfunc handling in stack
+		 * or hardware supports dynamic PS itself
+		 */
+		if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS) &&
+		    !(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
+			return -EOPNOTSUPP;
+
 		timeout = wrq->value / 1000;
+	}
 
 set:
 	if (ps == local->powersave && timeout == conf->dynamic_ps_timeout)
@@ -868,10 +880,12 @@ set:
 	local->powersave = ps;
 	conf->dynamic_ps_timeout = timeout;
 
-	if (local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS) {
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
 		ret = ieee80211_hw_config(local,
 					  IEEE80211_CONF_CHANGE_DYNPS_TIMEOUT);
-	} else if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
+
+	if ((sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) &&
+	    (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)) {
 		if (conf->dynamic_ps_timeout > 0)
 			mod_timer(&local->dynamic_ps_timer, jiffies +
 				  msecs_to_jiffies(conf->dynamic_ps_timeout));
@@ -888,6 +902,17 @@ set:
 				ieee80211_send_nullfunc(local, sdata, 0);
 			}
 		}
+	} else if (!(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)) {
+		/*
+		 * hardware-based PS has to handle it all in hw/driver,
+		 * including turning off PS when not associated.
+		 */
+		if (local->powersave)
+			conf->flags |= IEEE80211_CONF_PS;
+		else
+			conf->flags &= ~IEEE80211_CONF_PS;
+
+		ret = ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
 
 	return ret;
--- wireless-testing.orig/net/mac80211/mlme.c	2009-01-06 18:33:49.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-01-06 18:39:51.000000000 +0100
@@ -778,7 +778,7 @@ static void ieee80211_set_associated(str
 	ieee80211_bss_info_change_notify(sdata, bss_info_changed);
 
 	if (local->powersave &&
-			!(local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS)) {
+	    (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)) {
 		if (local->hw.conf.dynamic_ps_timeout > 0)
 			mod_timer(&local->dynamic_ps_timer, jiffies +
 				  msecs_to_jiffies(
@@ -1785,7 +1785,7 @@ static void ieee80211_rx_mgmt_beacon(str
 	ieee80211_sta_wmm_params(local, ifsta, elems.wmm_param,
 				 elems.wmm_param_len);
 
-	if (!(local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS)) {
+	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) {
 		directed_tim = check_tim(&elems, ifsta->aid, &is_mc);
 
 		if (directed_tim || is_mc) {
--- wireless-testing.orig/net/mac80211/tx.c	2009-01-06 18:33:49.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-01-06 18:34:23.000000000 +0100
@@ -1298,7 +1298,7 @@ int ieee80211_master_start_xmit(struct s
 		return 0;
 	}
 
-	if (!(local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS) &&
+	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
 	    local->hw.conf.dynamic_ps_timeout > 0) {
 		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 			ieee80211_stop_queues_by_reason(&local->hw,
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2009-01-06 18:33:49.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.c	2009-01-06 18:34:23.000000000 +0100
@@ -806,7 +806,8 @@ int iwl_setup_mac(struct iwl_priv *priv)
 	/* Tell mac80211 our characteristics */
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM |
-		    IEEE80211_HW_AMPDU_AGGREGATION;
+		    IEEE80211_HW_AMPDU_AGGREGATION |
+		    IEEE80211_HW_SUPPORTS_PS;
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2400pci.c	2009-01-06 18:33:50.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2400pci.c	2009-01-06 18:34:23.000000000 +0100
@@ -1451,7 +1451,9 @@ static int rt2400pci_probe_hw_mode(struc
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-			       IEEE80211_HW_SIGNAL_DBM;
+			       IEEE80211_HW_SIGNAL_DBM |
+			       IEEE80211_HW_SUPPORTS_PS |
+			       IEEE80211_HW_PS_NULLFUNC_STACK;
 	rt2x00dev->hw->extra_tx_headroom = 0;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2500pci.c	2009-01-06 18:33:50.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2500pci.c	2009-01-06 18:34:23.000000000 +0100
@@ -1752,7 +1752,9 @@ static int rt2500pci_probe_hw_mode(struc
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-			       IEEE80211_HW_SIGNAL_DBM;
+			       IEEE80211_HW_SIGNAL_DBM |
+			       IEEE80211_HW_SUPPORTS_PS |
+			       IEEE80211_HW_PS_NULLFUNC_STACK;
 
 	rt2x00dev->hw->extra_tx_headroom = 0;
 
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2500usb.c	2009-01-06 18:33:50.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2500usb.c	2009-01-06 18:34:23.000000000 +0100
@@ -1803,7 +1803,9 @@ static int rt2500usb_probe_hw_mode(struc
 	rt2x00dev->hw->flags =
 	    IEEE80211_HW_RX_INCLUDES_FCS |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-	    IEEE80211_HW_SIGNAL_DBM;
+	    IEEE80211_HW_SIGNAL_DBM |
+	    IEEE80211_HW_SUPPORTS_PS |
+	    IEEE80211_HW_PS_NULLFUNC_STACK;
 
 	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
 
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt61pci.c	2009-01-06 18:33:50.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rt2x00/rt61pci.c	2009-01-06 18:34:23.000000000 +0100
@@ -2558,7 +2558,9 @@ static int rt61pci_probe_hw_mode(struct 
 	 */
 	rt2x00dev->hw->flags =
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-	    IEEE80211_HW_SIGNAL_DBM;
+	    IEEE80211_HW_SIGNAL_DBM |
+	    IEEE80211_HW_SUPPORTS_PS |
+	    IEEE80211_HW_PS_NULLFUNC_STACK;
 	rt2x00dev->hw->extra_tx_headroom = 0;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt73usb.c	2009-01-06 18:33:49.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rt2x00/rt73usb.c	2009-01-06 18:34:23.000000000 +0100
@@ -2079,7 +2079,9 @@ static int rt73usb_probe_hw_mode(struct 
 	 */
 	rt2x00dev->hw->flags =
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-	    IEEE80211_HW_SIGNAL_DBM;
+	    IEEE80211_HW_SIGNAL_DBM |
+	    IEEE80211_HW_SUPPORTS_PS |
+	    IEEE80211_HW_PS_NULLFUNC_STACK;
 	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);


