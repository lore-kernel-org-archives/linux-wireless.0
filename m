Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:54865 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYKXHom (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 02:44:42 -0500
Received: by ey-out-2122.google.com with SMTP id 6so755732eyi.37
        for <linux-wireless@vger.kernel.org>; Sun, 23 Nov 2008 23:44:41 -0800 (PST)
Message-ID: <eb3ff54b0811232344t665fe6abp9ca2be85cfcbd855@mail.gmail.com> (sfid-20081124_084447_149059_40BDA54A)
Date: Mon, 24 Nov 2008 09:44:41 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 2/2] zd1211rw: enable an AP that can't support fully PS clients (wireless-testing).
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net, j@w1.fi
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables master mode support in zd1211rw driver and enables
it to support the PS challenged mode when used in master mode.

It adds this functionality in the zd1211rw driver by adding support to
master mode (NL80211_IFTYPE_AP) in zd_op_add_interface() and in
zd_mac_alloc_hw() methods
of drivers/net/wireless/zd_mac.c.

In addition, the new boolean member of wiphy struct, ap_ps_challenged,
is initialized to true in zd_mac_alloc_hw().

Signed-off-by: Rami Rosen <ramirose@gmail.com>

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c
b/drivers/net/wireless/zd1211rw/zd_mac.c
index 980acdf..d00cff2 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -721,6 +721,7 @@ static int zd_op_add_interface(struct ieee80211_hw *hw,
 		return -EOPNOTSUPP;

 	switch (conf->type) {
+	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_STATION:
@@ -972,10 +973,11 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct
usb_interface *intf)
 		    IEEE80211_HW_SIGNAL_DB;

 	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_MESH_POINT) |
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
-
+	hw->wiphy->ap_ps_challenged = true;
 	hw->max_signal = 100;
 	hw->queues = 1;
 	hw->extra_tx_headroom = sizeof(struct zd_ctrlset);
