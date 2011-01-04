Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:38495 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab1ADXuO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 18:50:14 -0500
Subject: [RFC PATCH 17/17] zd1211rw: enable NL80211_IFTYPE_AP
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>
Date: Wed, 05 Jan 2011 01:50:09 +0200
Message-ID: <20110104235009.25309.38556.stgit@fate.lan>
In-Reply-To: <20110104234745.25309.72030.stgit@fate.lan>
References: <20110104234745.25309.72030.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It should be safe to enable AP-mode now.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 1fc733c..73006ac 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -1047,6 +1047,7 @@ static int zd_op_add_interface(struct ieee80211_hw *hw,
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_AP:
 		mac->type = vif->type;
 		break;
 	default:
@@ -1219,7 +1220,8 @@ static void zd_op_bss_info_changed(struct ieee80211_hw *hw,
 	dev_dbg_f(zd_mac_dev(mac), "changes: %x\n", changes);
 
 	if (mac->type == NL80211_IFTYPE_MESH_POINT ||
-	    mac->type == NL80211_IFTYPE_ADHOC) {
+	    mac->type == NL80211_IFTYPE_ADHOC ||
+	    mac->type == NL80211_IFTYPE_AP) {
 		associated = true;
 		if (changes & BSS_CHANGED_BEACON) {
 			struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
@@ -1323,7 +1325,8 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_MESH_POINT) |
 		BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_ADHOC);
+		BIT(NL80211_IFTYPE_ADHOC) |
+		BIT(NL80211_IFTYPE_AP);
 
 	hw->max_signal = 100;
 	hw->queues = 1;

