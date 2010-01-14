Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:56094 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217Ab0ANLJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 06:09:55 -0500
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o0EB8n54008263
	for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 05:09:55 -0600
Received: from [127.0.1.1] (trdhcp21270.nmp.nokia.com [172.22.212.70])
	by mgw-sa01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o0EB9One022857
	for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 13:09:24 +0200
Subject: [PATCH 2/2] mac80211: improve powersave documentation
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 14 Jan 2010 13:09:21 +0200
Message-ID: <20100114110921.22608.22483.stgit@tikku>
In-Reply-To: <20100114110826.22608.23087.stgit@tikku>
References: <20100114110826.22608.23087.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

There has been some confusion how drivers should implement powersave
support. Improve the documentation a bit to make it more clear what
drivers need to do. Also mention about U-APSD.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 include/net/mac80211.h |   75 +++++++++++++++++++++++++++++++++++-------------
 1 files changed, 54 insertions(+), 21 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index bbfa475..c90047d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -569,7 +569,13 @@ struct ieee80211_rx_status {
  * @IEEE80211_CONF_MONITOR: there's a monitor interface present -- use this
  *	to determine for example whether to calculate timestamps for packets
  *	or not, do not use instead of filter flags!
- * @IEEE80211_CONF_PS: Enable 802.11 power save mode (managed mode only)
+ * @IEEE80211_CONF_PS: Enable 802.11 power save mode (managed mode only).
+ *	This is the power save mode defined by IEEE 802.11-2007 section 11.2,
+ *	meaning that the hardware still wakes up for beacons, is able to
+ *	transmit frames and receive the possible acknowledgment frames.
+ *	Not to be confused with hardware specific wakeup/sleep states,
+ *	driver is responsible for that. See the section "Powersave support"
+ *	for more.
  * @IEEE80211_CONF_IDLE: The device is running, but idle; if the flag is set
  *	the driver should be prepared to handle configuration requests but
  *	may turn the device off as much as possible. Typically, this flag will
@@ -1138,18 +1144,24 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  *
  * mac80211 has support for various powersave implementations.
  *
- * First, it can support hardware that handles all powersaving by
- * itself, such hardware should simply set the %IEEE80211_HW_SUPPORTS_PS
- * hardware flag. In that case, it will be told about the desired
- * powersave mode depending on the association status, and the driver
- * must take care of sending nullfunc frames when necessary, i.e. when
- * entering and leaving powersave mode. The driver is required to look at
- * the AID in beacons and signal to the AP that it woke up when it finds
- * traffic directed to it. This mode supports dynamic PS by simply
- * enabling/disabling PS.
- *
- * Additionally, such hardware may set the %IEEE80211_HW_SUPPORTS_DYNAMIC_PS
- * flag to indicate that it can support dynamic PS mode itself (see below).
+ * First, it can support hardware that handles all powersaving by itself,
+ * such hardware should simply set the %IEEE80211_HW_SUPPORTS_PS hardware
+ * flag. In that case, it will be told about the desired powersave mode
+ * with the %IEEE80211_CONF_PS flag depending on the association status.
+ * The hardware must take care of sending nullfunc frames when necessary,
+ * i.e. when entering and leaving powersave mode. The hardware is required
+ * to look at the AID in beacons and signal to the AP that it woke up when
+ * it finds traffic directed to it.
+ *
+ * %IEEE80211_CONF_PS flag enabled means that the powersave mode defined in
+ * IEEE 802.11-2007 section 11.2 is enabled. This is not to be confused
+ * with hardware wakeup and sleep states. Driver is responsible for waking
+ * up the hardware before issueing commands to the hardware and putting it
+ * back to sleep at approriate times.
+ *
+ * When PS is enabled, hardware needs to wakeup for beacons and receive the
+ * buffered multicast/broadcast frames after the beacon. Also it must be
+ * possible to send frames and receive the acknowledment frame.
  *
  * Other hardware designs cannot send nullfunc frames by themselves and also
  * need software support for parsing the TIM bitmap. This is also supported
@@ -1157,14 +1169,35 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  * %IEEE80211_HW_PS_NULLFUNC_STACK flags. The hardware is of course still
  * required to pass up beacons. The hardware is still required to handle
  * waking up for multicast traffic; if it cannot the driver must handle that
- * as best as it can, mac80211 is too slow.
- *
- * Dynamic powersave mode is an extension to normal powersave mode in which
- * the hardware stays awake for a user-specified period of time after sending
- * a frame so that reply frames need not be buffered and therefore delayed
- * to the next wakeup. This can either be supported by hardware, in which case
- * the driver needs to look at the @dynamic_ps_timeout hardware configuration
- * value, or by the stack if all nullfunc handling is in the stack.
+ * as best as it can, mac80211 is too slow to do that.
+ *
+ * Dynamic powersave is an extension to normal powersave in which the
+ * hardware stays awake for a user-specified period of time after sending a
+ * frame so that reply frames need not be buffered and therefore delayed to
+ * the next wakeup. It's compromise of getting good enough latency when
+ * there's data traffic and still saving significantly power in idle
+ * periods.
+ *
+ * Dynamic powersave is supported by simply mac80211 enabling and disabling
+ * PS based on traffic. Driver needs to only set %IEEE80211_HW_SUPPORTS_PS
+ * flag and mac80211 will handle everything automatically. Additionally,
+ * hardware having support for the dynamic PS feature may set the
+ * %IEEE80211_HW_SUPPORTS_DYNAMIC_PS flag to indicate that it can support
+ * dynamic PS mode itself. The driver needs to look at the
+ * @dynamic_ps_timeout hardware configuration value and use it that value
+ * whenever %IEEE80211_CONF_PS is set. In this case mac80211 will disable
+ * dynamic PS feature in stack and will just keep %IEEE80211_CONF_PS
+ * enabled whenever user has enabled powersave.
+ *
+ * Driver informs U-APSD client support by enabling
+ * %IEEE80211_HW_SUPPORTS_UAPSD flag. The mode is configured through the
+ * uapsd paramater in conf_tx() operation. Hardware needs to send the QoS
+ * Nullfunc frames and stay awake until the service period has ended. To
+ * utilize U-APSD, dynamic powersave is disabled for voip AC and all frames
+ * from that AC are transmitted with powersave enabled.
+ *
+ * Note: U-APSD client mode is not yet supported with
+ * %IEEE80211_HW_PS_NULLFUNC_STACK.
  */
 
 /**

