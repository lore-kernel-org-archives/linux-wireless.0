Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:58949 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab0LZLZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 06:25:07 -0500
Subject: [RFC PATCH 6/6] zd1211rw: enable NL80211_IFTYPE_AP
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>, zd1211-devs@lists.sourceforge.net,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Sun, 26 Dec 2010 13:25:01 +0200
Message-ID: <20101226112501.31775.17200.stgit@fate.lan>
In-Reply-To: <20101226112404.31775.77854.stgit@fate.lan>
References: <20101226112404.31775.77854.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 2489c97..031dbfe 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -922,6 +922,7 @@ static int zd_op_add_interface(struct ieee80211_hw *hw,
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_AP:
 		mac->type = vif->type;
 		break;
 	default:
@@ -1120,7 +1121,8 @@ static void zd_op_bss_info_changed(struct ieee80211_hw *hw,
 	dev_dbg_f(zd_mac_dev(mac), "changes: %x\n", changes);
 
 	if (mac->type == NL80211_IFTYPE_MESH_POINT ||
-	    mac->type == NL80211_IFTYPE_ADHOC) {
+	    mac->type == NL80211_IFTYPE_ADHOC ||
+	    mac->type == NL80211_IFTYPE_AP) {
 		associated = true;
 		if (changes & BSS_CHANGED_BEACON) {
 			struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
@@ -1223,7 +1225,8 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_MESH_POINT) |
 		BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_ADHOC);
+		BIT(NL80211_IFTYPE_ADHOC) |
+		BIT(NL80211_IFTYPE_AP);
 
 	hw->max_signal = 100;
 	hw->queues = 1;

