Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35643 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab0BSSIT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 13:08:19 -0500
Message-Id: <20100219180736.853830839@sipsolutions.net>
Date: Fri, 19 Feb 2010 19:06:54 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] p54: convert to new station add/remove callbacks
References: <20100219180652.409890561@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This converts p54 to use the new station
add/remove callbacks instead of using the
old sta_notify callback.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/p54/main.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/p54/main.c	2010-02-19 18:54:09.000000000 +0100
+++ wireless-testing/drivers/net/wireless/p54/main.c	2010-02-19 18:55:32.000000000 +0100
@@ -33,21 +33,29 @@ MODULE_DESCRIPTION("Softmac Prism54 comm
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("prism54common");
 
+static int p54_sta_add_remove(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_sta *sta)
+{
+	struct p54_common *priv = hw->priv;
+
+	/*
+	 * Notify the firmware that we don't want or we don't
+	 * need to buffer frames for this station anymore.
+	 */
+
+	p54_sta_unlock(priv, sta->addr);
+
+	return 0;
+}
+
 static void p54_sta_notify(struct ieee80211_hw *dev, struct ieee80211_vif *vif,
 			      enum sta_notify_cmd notify_cmd,
 			      struct ieee80211_sta *sta)
 {
 	struct p54_common *priv = dev->priv;
-	switch (notify_cmd) {
-	case STA_NOTIFY_ADD:
-	case STA_NOTIFY_REMOVE:
-		/*
-		 * Notify the firmware that we don't want or we don't
-		 * need to buffer frames for this station anymore.
-		 */
 
-		p54_sta_unlock(priv, sta->addr);
-		break;
+	switch (notify_cmd) {
 	case STA_NOTIFY_AWAKE:
 		/* update the firmware's filter table */
 		p54_sta_unlock(priv, sta->addr);
@@ -506,6 +514,8 @@ static const struct ieee80211_ops p54_op
 	.remove_interface	= p54_remove_interface,
 	.set_tim		= p54_set_tim,
 	.sta_notify		= p54_sta_notify,
+	.sta_add		= p54_sta_add_remove,
+	.sta_remove		= p54_sta_add_remove,
 	.set_key		= p54_set_key,
 	.config			= p54_config,
 	.bss_info_changed	= p54_bss_info_changed,


