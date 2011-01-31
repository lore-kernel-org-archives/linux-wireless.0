Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:56254 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752954Ab1AaSu1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:50:27 -0500
Subject: [PATCH 21/22] zd1211rw: enable NL80211_IFTYPE_AP
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 31 Jan 2011 20:50:21 +0200
Message-ID: <20110131185021.10044.92458.stgit@fate.lan>
In-Reply-To: <20110131184657.10044.98610.stgit@fate.lan>
References: <20110131184657.10044.98610.stgit@fate.lan>
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
index beaa969..74a269e 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -1038,6 +1038,7 @@ static int zd_op_add_interface(struct ieee80211_hw *hw,
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_AP:
 		mac->type = vif->type;
 		break;
 	default:
@@ -1214,7 +1215,8 @@ static void zd_op_bss_info_changed(struct ieee80211_hw *hw,
 	dev_dbg_f(zd_mac_dev(mac), "changes: %x\n", changes);
 
 	if (mac->type == NL80211_IFTYPE_MESH_POINT ||
-	    mac->type == NL80211_IFTYPE_ADHOC) {
+	    mac->type == NL80211_IFTYPE_ADHOC ||
+	    mac->type == NL80211_IFTYPE_AP) {
 		associated = true;
 		if (changes & BSS_CHANGED_BEACON) {
 			struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
@@ -1317,7 +1319,8 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_MESH_POINT) |
 		BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_ADHOC);
+		BIT(NL80211_IFTYPE_ADHOC) |
+		BIT(NL80211_IFTYPE_AP);
 
 	hw->max_signal = 100;
 	hw->queues = 1;

