Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46599 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537Ab1EMXzY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 19:55:24 -0400
Subject: [PATCH] mac80211: verify IBSS in interface combinations
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 May 2011 01:55:23 +0200
Message-ID: <1305330923.680.5.camel@jlt3.sipsolutions.net> (sfid-20110514_015528_664811_F99F01FF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Drivers shouldn't attempt to advertise support
for more than one IBSS interface since mac80211
doesn't support that. Check and return an error
from ieee80211_register_hw() in that case.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/net/mac80211/main.c	2011-05-14 01:48:56.000000000 +0200
+++ b/net/mac80211/main.c	2011-05-14 01:52:40.000000000 +0200
@@ -752,11 +752,25 @@ int ieee80211_register_hw(struct ieee802
 	hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_MONITOR);
 	hw->wiphy->software_iftypes |= BIT(NL80211_IFTYPE_MONITOR);
 
-	/* mac80211 doesn't support more than 1 channel */
-	for (i = 0; i < hw->wiphy->n_iface_combinations; i++)
-		if (hw->wiphy->iface_combinations[i].num_different_channels > 1)
+	/*
+	 * mac80211 doesn't support more than 1 channel, and also not more
+	 * than one IBSS interface
+	 */
+	for (i = 0; i < hw->wiphy->n_iface_combinations; i++) {
+		const struct ieee80211_iface_combination *c;
+		int j;
+
+		c = &hw->wiphy->iface_combinations[i];
+
+		if (c->num_different_channels > 1)
 			return -EINVAL;
 
+		for (j = 0; j < c->n_limits; j++)
+			if ((c->limits[j].types & BIT(NL80211_IFTYPE_ADHOC)) &&
+			    c->limits[j].max > 1)
+				return -EINVAL;
+	}
+
 #ifndef CONFIG_MAC80211_MESH
 	/* mesh depends on Kconfig, but drivers should set it if they want */
 	local->hw.wiphy->interface_modes &= ~BIT(NL80211_IFTYPE_MESH_POINT);


