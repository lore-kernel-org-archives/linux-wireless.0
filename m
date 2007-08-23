Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54769 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbXHWQtY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 12:49:24 -0400
Received: from [131.234.79.133]
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1IOFs0-0000zj-45
	for linux-wireless@vger.kernel.org; Thu, 23 Aug 2007 17:49:21 +0100
Message-Id: <20070823164520.967564000@sipsolutions.net>
References: <20070823164500.998912000@sipsolutions.net>
Date: Thu, 23 Aug 2007 18:45:02 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 01/11] mac80211: renumber and document the hardware flags
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, hardware flags that drivers must set are not
documented well enough. Fix this.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/mac80211.h |  101 ++++++++++++++++++++++++++-----------------------
 1 file changed, 55 insertions(+), 46 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-23 18:26:15.941897709 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-23 18:26:17.191897709 +0200
@@ -507,6 +507,61 @@ typedef enum set_key_cmd {
 	SET_KEY, DISABLE_KEY,
 } set_key_cmd;
 
+
+/**
+ * enum ieee80211_hw_flags - hardware flags
+ *
+ * These flags are used to indicate hardware capabilities to
+ * the stack. Generally, flags here should have their meaning
+ * done in a way that the simplest hardware doesn't need setting
+ * any particular flags. There are some exceptions to this rule,
+ * however, so you are advised to review these flags carefully.
+ *
+ * @IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE:
+ *	The device only needs to be supplied with a beacon template.
+ *	If you need the host to generate each beacon then don't use
+ *	this flag and call ieee80211_beacon_get() when you need the
+ *	next beacon frame. Note that if you set this flag, you must
+ *	implement the set_tim() callback for powersave mode to work
+ *	properly.
+ *	This flag is only relevant for access-point mode.
+ *
+ * @IEEE80211_HW_RX_INCLUDES_FCS:
+ *	Indicates that received frames passed to the stack include
+ *	the FCS at the end.
+ *
+ * @IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING:
+ *	Some wireless LAN chipsets buffer broadcast/multicast frames
+ *	for power saving stations in the hardware/firmware and others
+ *	rely on the host system for such buffering. This option is used
+ *	to configure the IEEE 802.11 upper layer to buffer broadcast and
+ *	multicast frames when there are power saving stations so that
+ *	the driver can fetch them with ieee80211_get_buffered_bc(). Note
+ *	that not setting this flag works properly only when the
+ *	%IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE is also not set because
+ *	otherwise the stack will not know when the DTIM beacon was sent.
+ *
+ * @IEEE80211_HW_MULTICAST_FILTER:
+ *	Device has multicast filters, i.e. it can filter based on the
+ *	multicast address. If this flag is clear, then %FIF_ALLMULTI
+ *	will be enabled instead of passing multicast addresses when
+ *	multicast addresses are added.
+ *
+ * @IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED:
+ *	Channels are already configured to the default regulatory domain
+ *	specified in the device's EEPROM
+ *
+ * @IEEE80211_HW_SUPPORT_HT_MODE: The device capable of supporting 11n.
+ */
+enum ieee80211_hw_flags {
+	IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE		= 1<<0,
+	IEEE80211_HW_RX_INCLUDES_FCS			= 1<<1,
+	IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING	= 1<<2,
+	IEEE80211_HW_MULTICAST_FILTER			= 1<<3,
+	IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED	= 1<<4,
+	IEEE80211_HW_SUPPORT_HT_MODE			= 1<<5,
+};
+
 /**
  * struct ieee80211_hw - hardware information and state
  * TODO: move documentation into kernel-doc format
@@ -530,52 +585,6 @@ struct ieee80211_hw {
 
 	/* The rest is information about your hardware */
 
-	/* TODO: frame_type 802.11/802.3, sw_encryption requirements */
-
-/* hole at 0 */
-
-	/*
-	 * The device only needs to be supplied with a beacon template.
-	 * If you need the host to generate each beacon then don't use
-	 * this flag and use ieee80211_beacon_get().
-	 */
-#define IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE (1<<1)
-
-/* hole at 2 */
-
-	/* Whether RX frames passed to ieee80211_rx() include FCS in the end */
-#define IEEE80211_HW_RX_INCLUDES_FCS (1<<3)
-
-	/* Some wireless LAN chipsets buffer broadcast/multicast frames for
-	 * power saving stations in the hardware/firmware and others rely on
-	 * the host system for such buffering. This option is used to
-	 * configure the IEEE 802.11 upper layer to buffer broadcast/multicast
-	 * frames when there are power saving stations so that low-level driver
-	 * can fetch them with ieee80211_get_buffered_bc(). */
-#define IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING (1<<4)
-
-/* hole at 5 */
-
-/* hole at 6 */
-
-/* hole at 7 */
-
-/* hole at 8 */
-
-	/*
-	 * Device has multicast filters.
-	 */
-#define IEEE80211_HW_MULTICAST_FILTER (1<<9)
-
-/* hole at 10 */
-
-	/* Channels are already configured to the default regulatory domain
-	 * specified in the device's EEPROM */
-#define IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED (1<<11)
-
-	/* The device capable of supporting 11n */
-#define IEEE80211_HW_SUPPORT_HT_MODE (1<<15)
-
 	u32 flags;			/* hardware flags defined above */
 
 	/* Set to the size of a needed device specific skb headroom for TX skbs. */

-- 

