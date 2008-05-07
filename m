Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:48105 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752101AbYEGJwf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 05:52:35 -0400
From: Bruno Randolf <br1@einfach.org>
Subject: [PATCH] zd1211rw: initial IBSS support
To: dsd@gentoo.org, kune@deine-taler.de
Cc: linux-wireless@vger.kernel.org, zd1211-devs@lists.sourceforge.net
Date: Wed, 07 May 2008 11:46:02 +0200
Message-ID: <20080507094602.830.53031.stgit@localhost> (sfid-20080507_115142_676215_95D68A08)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

this adds initial IBSS support for the zydas zd1211rw:
convince driver that it can do IBSS mode. add mac80211 beacon_update callback.

IBSS merge and TSF updates don't work yet, but it makes the driver usable in
ad-hoc networks.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---

 drivers/net/wireless/zd1211rw/zd_mac.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)


diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 69c45ca..ee43312 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -751,6 +751,7 @@ static int zd_op_add_interface(struct ieee80211_hw *hw,
 	case IEEE80211_IF_TYPE_MNTR:
 	case IEEE80211_IF_TYPE_MESH_POINT:
 	case IEEE80211_IF_TYPE_STA:
+	case IEEE80211_IF_TYPE_IBSS:
 		mac->type = conf->type;
 		break;
 	default:
@@ -781,7 +782,8 @@ static int zd_op_config_interface(struct ieee80211_hw *hw,
 	struct zd_mac *mac = zd_hw_mac(hw);
 	int associated;
 
-	if (mac->type == IEEE80211_IF_TYPE_MESH_POINT) {
+	if (mac->type == IEEE80211_IF_TYPE_MESH_POINT ||
+	    mac->type == IEEE80211_IF_TYPE_IBSS) {
 		associated = true;
 		if (conf->beacon) {
 			zd_mac_config_beacon(hw, conf->beacon);
@@ -941,6 +943,18 @@ static void zd_op_bss_info_changed(struct ieee80211_hw *hw,
 	}
 }
 
+static int zd_op_beacon_update(struct ieee80211_hw *hw,
+			       struct sk_buff *skb,
+			       struct ieee80211_tx_control *ctl)
+{
+	struct zd_mac *mac = zd_hw_mac(hw);
+	zd_mac_config_beacon(hw, skb);
+	kfree_skb(skb);
+	zd_set_beacon_interval(&mac->chip, BCN_MODE_IBSS |
+					hw->conf.beacon_int);
+	return 0;
+}
+
 static const struct ieee80211_ops zd_ops = {
 	.tx			= zd_op_tx,
 	.start			= zd_op_start,
@@ -951,6 +965,7 @@ static const struct ieee80211_ops zd_ops = {
 	.config_interface	= zd_op_config_interface,
 	.configure_filter	= zd_op_configure_filter,
 	.bss_info_changed	= zd_op_bss_info_changed,
+	.beacon_update		= zd_op_beacon_update,
 };
 
 struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)

