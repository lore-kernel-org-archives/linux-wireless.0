Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:4529 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbYKQPvc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 10:51:32 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1188801nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 07:51:31 -0800 (PST)
Message-ID: <eb3ff54b0811170751p56544c8fic38d046a868f3bb8@mail.gmail.com> (sfid-20081117_165138_429172_482A518A)
Date: Mon, 17 Nov 2008 17:51:31 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH ] zd1211rw: enable master mode. (wireless-testing)
Cc: linux-wireless@vger.kernel.org, kune@deine-taler.de
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds initial support for master mode for zd1211rw USB
wireless driver (via tools such as  hostapd).
It enables basic functionality like association from a managed station
and identifying the master mode by scanning from a station.

Signed-off-by: Rami Rosen <ramirose@gmail.com>

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c
b/drivers/net/wireless/zd1211rw/zd_mac.c
index 980acdf..03be818 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -721,6 +721,7 @@ static int zd_op_add_interface(struct ieee80211_hw *hw,
 		return -EOPNOTSUPP;

 	switch (conf->type) {
+	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_STATION:
@@ -972,6 +973,7 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct
usb_interface *intf)
 		    IEEE80211_HW_SIGNAL_DB;

 	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_MESH_POINT) |
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
