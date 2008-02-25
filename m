Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35723 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbYBYJt2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 04:49:28 -0500
Subject: [PATCH] b43: verify sta_notify mac80211 callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 09:24:58 +0100
Message-Id: <1203927898.13162.43.camel@johannes.berg> (sfid-20080225_094955_696474_6C19D46B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This helps verify that nothing bad is going on in mac80211,
it is unfortunately not possible to implement this generically
in mac80211 easily because there we can't assume that we only
have a single vif which b43 currently can assume.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I like this for debugging and wouldn't mind carrying it out of
tree either but the penalty is just a few lines of code and
a rather infrequent function call.

Note that it will always trigger before my sta info rework in mac80211,
so please don't apply before that.

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


