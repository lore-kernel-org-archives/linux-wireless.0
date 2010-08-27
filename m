Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56918 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab0H0Khx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 06:37:53 -0400
Message-Id: <20100827103659.106822399@sipsolutions.net>
Date: Fri, 27 Aug 2010 12:35:59 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6/6] mac80211_hwsim: support runtime iftype changes
References: <20100827103553.559128239@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add the trivial support for runtime interface
type changes to mac80211_hwsim for testing.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2010-08-27 12:27:07.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2010-08-27 12:27:09.000000000 +0200
@@ -601,6 +601,18 @@ static int mac80211_hwsim_add_interface(
 }
 
 
+static int mac80211_hwsim_change_interface(struct ieee80211_hw *hw,
+					   struct ieee80211_vif *vif,
+					   enum nl80211_iftype newtype)
+{
+	wiphy_debug(hw->wiphy,
+		    "%s (old type=%d, new type=%d, mac_addr=%pM)\n",
+		    __func__, vif->type, newtype, vif->addr);
+	hwsim_check_magic(vif);
+
+	return 0;
+}
+
 static void mac80211_hwsim_remove_interface(
 	struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
@@ -1027,6 +1039,7 @@ static struct ieee80211_ops mac80211_hws
 	.start = mac80211_hwsim_start,
 	.stop = mac80211_hwsim_stop,
 	.add_interface = mac80211_hwsim_add_interface,
+	.change_interface = mac80211_hwsim_change_interface,
 	.remove_interface = mac80211_hwsim_remove_interface,
 	.config = mac80211_hwsim_config,
 	.configure_filter = mac80211_hwsim_configure_filter,


