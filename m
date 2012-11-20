Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57714 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab2KTLU3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 06:20:29 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1625946eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 03:20:28 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 10/11] wlcore: refactor CHANGED_HT handling
Date: Tue, 20 Nov 2012 13:20:10 +0200
Message-Id: <1353410411-18833-11-git-send-email-eliad@wizery.com> (sfid-20121120_122035_398070_DF821BD7)
In-Reply-To: <1353410411-18833-1-git-send-email-eliad@wizery.com>
References: <1353410411-18833-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass a variable indicating whether HT is enabled,
instead of duplicating the function call with
different arguments.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   48 ++++++++++++--------------------
 1 files changed, 18 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index ade206a..ff9437a 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4009,44 +4009,32 @@ sta_not_found:
 	}
 
 	/* Handle new association with HT. Do this after join. */
-	if (sta_exists) {
-		if ((changed & BSS_CHANGED_HT) &&
-		    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {
-			ret = wl1271_acx_set_ht_capabilities(wl,
-							     &sta_ht_cap,
-							     true,
-							     wlvif->sta.hlid);
-			if (ret < 0) {
-				wl1271_warning("Set ht cap true failed %d",
-					       ret);
-				goto out;
-			}
+	if (sta_exists &&
+	    (changed & BSS_CHANGED_HT)) {
+		bool enabled =
+			bss_conf->channel_type != NL80211_CHAN_NO_HT;
+
+		ret = wl1271_acx_set_ht_capabilities(wl,
+						     &sta_ht_cap,
+						     enabled,
+						     wlvif->sta.hlid);
+		if (ret < 0) {
+			wl1271_warning("Set ht cap failed %d", ret);
+			goto out;
+
 		}
-		/* handle new association without HT and disassociation */
-		else if (changed & BSS_CHANGED_ASSOC) {
-			ret = wl1271_acx_set_ht_capabilities(wl,
-							     &sta_ht_cap,
-							     false,
-							     wlvif->sta.hlid);
+
+		if (enabled) {
+			ret = wl1271_acx_set_ht_information(wl, wlvif,
+						bss_conf->ht_operation_mode);
 			if (ret < 0) {
-				wl1271_warning("Set ht cap false failed %d",
+				wl1271_warning("Set ht information failed %d",
 					       ret);
 				goto out;
 			}
 		}
 	}
 
-	/* Handle HT information change. Done after join. */
-	if ((changed & BSS_CHANGED_HT) &&
-	    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {
-		ret = wl1271_acx_set_ht_information(wl, wlvif,
-					bss_conf->ht_operation_mode);
-		if (ret < 0) {
-			wl1271_warning("Set ht information failed %d", ret);
-			goto out;
-		}
-	}
-
 	/* Handle arp filtering. Done after join. */
 	if ((changed & BSS_CHANGED_ARP_FILTER) ||
 	    (!is_ibss && (changed & BSS_CHANGED_QOS))) {
-- 
1.7.6.401.g6a319

