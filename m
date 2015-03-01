Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbbCAHKw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 02:10:52 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 14/16] nl80211: prohibit mixing 'any' and regular wowlan triggers
Date: Sun,  1 Mar 2015 09:10:13 +0200
Message-Id: <1425193815-17785-15-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_083417_711495_B43EB99F)
In-Reply-To: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the device supports waking up on 'any' signal - i.e. it continues
operating as usual and wakes up the host on pretty much anything that
happens, then it makes no sense to also configure the more restricted
WoWLAN mode where the device operates more autonomously but also in a
more restricted fashion.

Currently only cw2100 supports both 'any' and other triggers, but it
seems to be broken as it doesn't configure anything to the device, so
we can't currently get into a situation where both even can correctly
be configured. This is about to change (Intel devices are going to
support both and have different behaviour depending on configuration)
so make sure the conflicting modes cannot be configured.

(It seems that cw2100 advertises 'any' and 'disconnect' as a means of
saying that's what it will always do, but that isn't really the way
this API was meant to be used nor does it actually mean anything as
'any' always implies 'disconnect' already, and the driver doesn't
change device configuration in any way depending on the settings.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/nl80211.h |  2 ++
 net/wireless/nl80211.c       | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 68b294e..26eac5a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3694,6 +3694,8 @@ struct nl80211_pattern_support {
  * @NL80211_WOWLAN_TRIG_ANY: wake up on any activity, do not really put
  *	the chip into a special state -- works best with chips that have
  *	support for low-power operation already (flag)
+ *	Note that this mode is incompatible with all of the others, if
+ *	any others are even supported by the device.
  * @NL80211_WOWLAN_TRIG_DISCONNECT: wake up on disconnect, the way disconnect
  *	is detected is implementation-specific (flag)
  * @NL80211_WOWLAN_TRIG_MAGIC_PKT: wake up on magic packet (6x 0xff, followed
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index be25015..8471c66 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9084,6 +9084,7 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 	const struct wiphy_wowlan_support *wowlan = rdev->wiphy.wowlan;
 	int err, i;
 	bool prev_enabled = rdev->wiphy.wowlan_config;
+	bool regular = false;
 
 	if (!wowlan)
 		return -EOPNOTSUPP;
@@ -9111,12 +9112,14 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 		if (!(wowlan->flags & WIPHY_WOWLAN_DISCONNECT))
 			return -EINVAL;
 		new_triggers.disconnect = true;
+		regular = true;
 	}
 
 	if (tb[NL80211_WOWLAN_TRIG_MAGIC_PKT]) {
 		if (!(wowlan->flags & WIPHY_WOWLAN_MAGIC_PKT))
 			return -EINVAL;
 		new_triggers.magic_pkt = true;
+		regular = true;
 	}
 
 	if (tb[NL80211_WOWLAN_TRIG_GTK_REKEY_SUPPORTED])
@@ -9126,24 +9129,28 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 		if (!(wowlan->flags & WIPHY_WOWLAN_GTK_REKEY_FAILURE))
 			return -EINVAL;
 		new_triggers.gtk_rekey_failure = true;
+		regular = true;
 	}
 
 	if (tb[NL80211_WOWLAN_TRIG_EAP_IDENT_REQUEST]) {
 		if (!(wowlan->flags & WIPHY_WOWLAN_EAP_IDENTITY_REQ))
 			return -EINVAL;
 		new_triggers.eap_identity_req = true;
+		regular = true;
 	}
 
 	if (tb[NL80211_WOWLAN_TRIG_4WAY_HANDSHAKE]) {
 		if (!(wowlan->flags & WIPHY_WOWLAN_4WAY_HANDSHAKE))
 			return -EINVAL;
 		new_triggers.four_way_handshake = true;
+		regular = true;
 	}
 
 	if (tb[NL80211_WOWLAN_TRIG_RFKILL_RELEASE]) {
 		if (!(wowlan->flags & WIPHY_WOWLAN_RFKILL_RELEASE))
 			return -EINVAL;
 		new_triggers.rfkill_release = true;
+		regular = true;
 	}
 
 	if (tb[NL80211_WOWLAN_TRIG_PKT_PATTERN]) {
@@ -9152,6 +9159,8 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 		int rem, pat_len, mask_len, pkt_offset;
 		struct nlattr *pat_tb[NUM_NL80211_PKTPAT];
 
+		regular = true;
+
 		nla_for_each_nested(pat, tb[NL80211_WOWLAN_TRIG_PKT_PATTERN],
 				    rem)
 			n_patterns++;
@@ -9213,6 +9222,7 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (tb[NL80211_WOWLAN_TRIG_TCP_CONNECTION]) {
+		regular = true;
 		err = nl80211_parse_wowlan_tcp(
 			rdev, tb[NL80211_WOWLAN_TRIG_TCP_CONNECTION],
 			&new_triggers);
@@ -9221,6 +9231,7 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (tb[NL80211_WOWLAN_TRIG_NET_DETECT]) {
+		regular = true;
 		err = nl80211_parse_wowlan_nd(
 			rdev, wowlan, tb[NL80211_WOWLAN_TRIG_NET_DETECT],
 			&new_triggers);
@@ -9228,6 +9239,17 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 			goto error;
 	}
 
+	/* The 'any' trigger means the device continues operating more or less
+	 * as in its normal operation mode and wakes up the host on most of the
+	 * normal interrupts (like packet RX, ...)
+	 * It therefore makes little sense to combine with the more constrained
+	 * wakeup trigger modes.
+	 */
+	if (new_triggers.any && regular) {
+		err = -EINVAL;
+		goto error;
+	}
+
 	ntrig = kmemdup(&new_triggers, sizeof(new_triggers), GFP_KERNEL);
 	if (!ntrig) {
 		err = -ENOMEM;
-- 
1.9.1

