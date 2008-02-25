Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49286 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbYBYPj2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 10:39:28 -0500
Message-Id: <20080225153009.411684000@sipsolutions.net> (sfid-20080225_153939_272078_F6FF9A14)
References: <20080225152740.360393000@sipsolutions.net>
Date: Mon, 25 Feb 2008 16:27:50 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Michael Buesch <mb@bu3sch.de>
Subject: [PATCH 10/10] b43: verify sta_notify mac80211 callback
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This helps verify that nothing bad is going on in mac80211,
it is unfortunately not possible to implement this generically
in mac80211 easily because there we can't assume that we only
have a single vif which b43 currently can assume.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>
---
 drivers/net/wireless/b43/main.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- everything.orig/drivers/net/wireless/b43/main.c	2008-02-25 08:46:14.000000000 +0100
+++ everything/drivers/net/wireless/b43/main.c	2008-02-25 08:49:42.000000000 +0100
@@ -3835,6 +3835,16 @@ static int b43_op_ibss_beacon_update(str
 	return 0;
 }
 
+static void b43_op_sta_notify(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      enum sta_notify_cmd notify_cmd,
+			      const u8 *addr)
+{
+	struct b43_wl *wl = hw_to_b43_wl(hw);
+
+	B43_WARN_ON(!vif || wl->vif != vif);
+}
+
 static const struct ieee80211_ops b43_hw_ops = {
 	.tx			= b43_op_tx,
 	.conf_tx		= b43_op_conf_tx,
@@ -3851,6 +3861,7 @@ static const struct ieee80211_ops b43_hw
 	.set_retry_limit	= b43_op_set_retry_limit,
 	.set_tim		= b43_op_beacon_set_tim,
 	.beacon_update		= b43_op_ibss_beacon_update,
+	.sta_notify		= b43_op_sta_notify,
 };
 
 /* Hard-reset the chip. Do not call this directly.

-- 

