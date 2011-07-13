Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34241 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965050Ab1GMIsj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 04:48:39 -0400
Subject: [PATCH] nl80211: advertise GTK rekey support, new triggers
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jul 2011 10:48:55 +0200
Message-ID: <1310546935.3873.7.camel@jlt3.sipsolutions.net> (sfid-20110713_104842_966385_E4C5DD83)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since we now have the necessary API in place to support
GTK rekeying, applications will need to know whether it
is supported by a device. Add a pseudo-trigger that is
used only to advertise that capability. Also, add some
new triggers that match what iwlagn devices can do.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |   19 ++++++++++++++++--
 include/net/cfg80211.h  |   24 +++++++++++++++++++----
 net/wireless/core.c     |    4 +++
 net/wireless/nl80211.c  |   49 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 90 insertions(+), 6 deletions(-)

--- a/include/linux/nl80211.h	2011-07-13 10:09:08.000000000 +0200
+++ b/include/linux/nl80211.h	2011-07-13 10:48:27.000000000 +0200
@@ -989,8 +989,8 @@ enum nl80211_commands {
  *	driving the peer link management state machine.
  *	@NL80211_MESH_SETUP_USERSPACE_AMPE must be enabled.
  *
- * @NL80211_ATTR_WOWLAN_SUPPORTED: indicates, as part of the wiphy capabilities,
- *	the supported WoWLAN triggers
+ * @NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED: indicates, as part of the wiphy
+ *	capabilities, the supported WoWLAN triggers
  * @NL80211_ATTR_WOWLAN_TRIGGERS: used by %NL80211_CMD_SET_WOWLAN to
  *	indicate which WoW triggers should be enabled. This is also
  *	used by %NL80211_CMD_GET_WOWLAN to get the currently enabled WoWLAN
@@ -2255,6 +2255,16 @@ struct nl80211_wowlan_pattern_support {
  *
  *	In %NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED, it is a binary attribute
  *	carrying a &struct nl80211_wowlan_pattern_support.
+ * @NL80211_WOWLAN_TRIG_GTK_REKEY_SUPPORTED: Not a real trigger, and cannot be
+ *	used when setting, used only to indicate that GTK rekeying is supported
+ *	by the device (flag)
+ * @NL80211_WOWLAN_TRIG_GTK_REKEY_FAILURE: wake up on GTK rekey failure (if
+ *	done by the device) (flag)
+ * @NL80211_WOWLAN_TRIG_EAP_IDENT_REQUEST: wake up on EAP Identity Request
+ *	packet (flag)
+ * @NL80211_WOWLAN_TRIG_4WAY_HANDSHAKE: wake up on 4-way handshake (flag)
+ * @NL80211_WOWLAN_TRIG_RFKILL_RELEASE: wake up when rfkill is released
+ *	(on devices that have rfkill in the device) (flag)
  * @NUM_NL80211_WOWLAN_TRIG: number of wake on wireless triggers
  * @MAX_NL80211_WOWLAN_TRIG: highest wowlan trigger attribute number
  */
@@ -2264,6 +2274,11 @@ enum nl80211_wowlan_triggers {
 	NL80211_WOWLAN_TRIG_DISCONNECT,
 	NL80211_WOWLAN_TRIG_MAGIC_PKT,
 	NL80211_WOWLAN_TRIG_PKT_PATTERN,
+	NL80211_WOWLAN_TRIG_GTK_REKEY_SUPPORTED,
+	NL80211_WOWLAN_TRIG_GTK_REKEY_FAILURE,
+	NL80211_WOWLAN_TRIG_EAP_IDENT_REQUEST,
+	NL80211_WOWLAN_TRIG_4WAY_HANDSHAKE,
+	NL80211_WOWLAN_TRIG_RFKILL_RELEASE,
 
 	/* keep last */
 	NUM_NL80211_WOWLAN_TRIG,
--- a/include/net/cfg80211.h	2011-07-13 10:09:09.000000000 +0200
+++ b/include/net/cfg80211.h	2011-07-13 10:48:27.000000000 +0200
@@ -1141,9 +1141,15 @@ struct cfg80211_wowlan_trig_pkt_pattern
  * @magic_pkt: wake up on receiving magic packet
  * @patterns: wake up on receiving packet matching a pattern
  * @n_patterns: number of patterns
+ * @gtk_rekey_failure: wake up on GTK rekey failure
+ * @eap_identity_req: wake up on EAP identity request packet
+ * @four_way_handshake: wake up on 4-way handshake
+ * @rfkill_release: wake up when rfkill is released
  */
 struct cfg80211_wowlan {
-	bool any, disconnect, magic_pkt;
+	bool any, disconnect, magic_pkt, gtk_rekey_failure,
+	     eap_identity_req, four_way_handshake,
+	     rfkill_release;
 	struct cfg80211_wowlan_trig_pkt_pattern *patterns;
 	int n_patterns;
 };
@@ -1668,11 +1674,21 @@ struct ieee80211_txrx_stypes {
  * @WIPHY_WOWLAN_MAGIC_PKT: supports wakeup on magic packet
  *	(see nl80211.h)
  * @WIPHY_WOWLAN_DISCONNECT: supports wakeup on disconnect
+ * @WIPHY_WOWLAN_SUPPORTS_GTK_REKEY: supports GTK rekeying while asleep
+ * @WIPHY_WOWLAN_GTK_REKEY_FAILURE: supports wakeup on GTK rekey failure
+ * @WIPHY_WOWLAN_EAP_IDENTITY_REQ: supports wakeup on EAP identity request
+ * @WIPHY_WOWLAN_4WAY_HANDSHAKE: supports wakeup on 4-way handshake failure
+ * @WIPHY_WOWLAN_RFKILL_RELEASE: supports wakeup on RF-kill release
  */
 enum wiphy_wowlan_support_flags {
-	WIPHY_WOWLAN_ANY	= BIT(0),
-	WIPHY_WOWLAN_MAGIC_PKT	= BIT(1),
-	WIPHY_WOWLAN_DISCONNECT	= BIT(2),
+	WIPHY_WOWLAN_ANY		= BIT(0),
+	WIPHY_WOWLAN_MAGIC_PKT		= BIT(1),
+	WIPHY_WOWLAN_DISCONNECT		= BIT(2),
+	WIPHY_WOWLAN_SUPPORTS_GTK_REKEY	= BIT(3),
+	WIPHY_WOWLAN_GTK_REKEY_FAILURE	= BIT(4),
+	WIPHY_WOWLAN_EAP_IDENTITY_REQ	= BIT(5),
+	WIPHY_WOWLAN_4WAY_HANDSHAKE	= BIT(6),
+	WIPHY_WOWLAN_RFKILL_RELEASE	= BIT(7),
 };
 
 /**
--- a/net/wireless/nl80211.c	2011-07-13 10:09:09.000000000 +0200
+++ b/net/wireless/nl80211.c	2011-07-13 10:48:27.000000000 +0200
@@ -205,6 +205,10 @@ nl80211_wowlan_policy[NUM_NL80211_WOWLAN
 	[NL80211_WOWLAN_TRIG_DISCONNECT] = { .type = NLA_FLAG },
 	[NL80211_WOWLAN_TRIG_MAGIC_PKT] = { .type = NLA_FLAG },
 	[NL80211_WOWLAN_TRIG_PKT_PATTERN] = { .type = NLA_NESTED },
+	[NL80211_WOWLAN_TRIG_GTK_REKEY_FAILURE] = { .type = NLA_FLAG },
+	[NL80211_WOWLAN_TRIG_EAP_IDENT_REQUEST] = { .type = NLA_FLAG },
+	[NL80211_WOWLAN_TRIG_4WAY_HANDSHAKE] = { .type = NLA_FLAG },
+	[NL80211_WOWLAN_TRIG_RFKILL_RELEASE] = { .type = NLA_FLAG },
 };
 
 /* policy for GTK rekey offload attributes */
@@ -929,6 +933,16 @@ static int nl80211_send_wiphy(struct sk_
 			NLA_PUT_FLAG(msg, NL80211_WOWLAN_TRIG_DISCONNECT);
 		if (dev->wiphy.wowlan.flags & WIPHY_WOWLAN_MAGIC_PKT)
 			NLA_PUT_FLAG(msg, NL80211_WOWLAN_TRIG_MAGIC_PKT);
+		if (dev->wiphy.wowlan.flags & WIPHY_WOWLAN_SUPPORTS_GTK_REKEY)
+			NLA_PUT_FLAG(msg, NL80211_WOWLAN_TRIG_GTK_REKEY_SUPPORTED);
+		if (dev->wiphy.wowlan.flags & WIPHY_WOWLAN_GTK_REKEY_FAILURE)
+			NLA_PUT_FLAG(msg, NL80211_WOWLAN_TRIG_GTK_REKEY_FAILURE);
+		if (dev->wiphy.wowlan.flags & WIPHY_WOWLAN_EAP_IDENTITY_REQ)
+			NLA_PUT_FLAG(msg, NL80211_WOWLAN_TRIG_EAP_IDENT_REQUEST);
+		if (dev->wiphy.wowlan.flags & WIPHY_WOWLAN_4WAY_HANDSHAKE)
+			NLA_PUT_FLAG(msg, NL80211_WOWLAN_TRIG_4WAY_HANDSHAKE);
+		if (dev->wiphy.wowlan.flags & WIPHY_WOWLAN_RFKILL_RELEASE)
+			NLA_PUT_FLAG(msg, NL80211_WOWLAN_TRIG_RFKILL_RELEASE);
 		if (dev->wiphy.wowlan.n_patterns) {
 			struct nl80211_wowlan_pattern_support pat = {
 				.max_patterns = dev->wiphy.wowlan.n_patterns,
@@ -5272,6 +5286,14 @@ static int nl80211_get_wowlan(struct sk_
 			NLA_PUT_FLAG(msg, NL80211_WOWLAN_TRIG_DISCONNECT);
 		if (rdev->wowlan->magic_pkt)
 			NLA_PUT_FLAG(msg, NL80211_WOWLAN_TRIG_MAGIC_PKT);
+		if (rdev->wowlan->gtk_rekey_failure)
+			NLA_PUT_FLAG(msg, NL80211_WOWLAN_TRIG_GTK_REKEY_FAILURE);
+		if (rdev->wowlan->eap_identity_req)
+			NLA_PUT_FLAG(msg, NL80211_WOWLAN_TRIG_EAP_IDENT_REQUEST);
+		if (rdev->wowlan->four_way_handshake)
+			NLA_PUT_FLAG(msg, NL80211_WOWLAN_TRIG_4WAY_HANDSHAKE);
+		if (rdev->wowlan->rfkill_release)
+			NLA_PUT_FLAG(msg, NL80211_WOWLAN_TRIG_RFKILL_RELEASE);
 		if (rdev->wowlan->n_patterns) {
 			struct nlattr *nl_pats, *nl_pat;
 			int i, pat_len;
@@ -5348,6 +5370,33 @@ static int nl80211_set_wowlan(struct sk_
 		new_triggers.magic_pkt = true;
 	}
 
+	if (tb[NL80211_WOWLAN_TRIG_GTK_REKEY_SUPPORTED])
+		return -EINVAL;
+
+	if (tb[NL80211_WOWLAN_TRIG_GTK_REKEY_FAILURE]) {
+		if (!(wowlan->flags & WIPHY_WOWLAN_GTK_REKEY_FAILURE))
+			return -EINVAL;
+		new_triggers.gtk_rekey_failure = true;
+	}
+
+	if (tb[NL80211_WOWLAN_TRIG_EAP_IDENT_REQUEST]) {
+		if (!(wowlan->flags & WIPHY_WOWLAN_EAP_IDENTITY_REQ))
+			return -EINVAL;
+		new_triggers.eap_identity_req = true;
+	}
+
+	if (tb[NL80211_WOWLAN_TRIG_4WAY_HANDSHAKE]) {
+		if (!(wowlan->flags & WIPHY_WOWLAN_4WAY_HANDSHAKE))
+			return -EINVAL;
+		new_triggers.four_way_handshake = true;
+	}
+
+	if (tb[NL80211_WOWLAN_TRIG_RFKILL_RELEASE]) {
+		if (!(wowlan->flags & WIPHY_WOWLAN_RFKILL_RELEASE))
+			return -EINVAL;
+		new_triggers.rfkill_release = true;
+	}
+
 	if (tb[NL80211_WOWLAN_TRIG_PKT_PATTERN]) {
 		struct nlattr *pat;
 		int n_patterns = 0;
--- a/net/wireless/core.c	2011-07-13 10:09:09.000000000 +0200
+++ b/net/wireless/core.c	2011-07-13 10:48:27.000000000 +0200
@@ -488,6 +488,10 @@ int wiphy_register(struct wiphy *wiphy)
 	int i;
 	u16 ifmodes = wiphy->interface_modes;
 
+	if (WARN_ON((wiphy->wowlan.flags & WIPHY_WOWLAN_GTK_REKEY_FAILURE) &&
+		    !(wiphy->wowlan.flags & WIPHY_WOWLAN_SUPPORTS_GTK_REKEY)))
+		return -EINVAL;
+
 	if (WARN_ON(wiphy->addresses && !wiphy->n_addresses))
 		return -EINVAL;
 


