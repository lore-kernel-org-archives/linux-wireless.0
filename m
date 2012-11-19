Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65056 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab2KSQj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 11:39:58 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1209576eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 08:39:57 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 14/15] wlcore: refactor CHANGED_HT handling
Date: Mon, 19 Nov 2012 18:39:29 +0200
Message-Id: <1353343170-26516-15-git-send-email-eliad@wizery.com> (sfid-20121119_174526_546012_5EF0E2C9)
In-Reply-To: <1353343170-26516-1-git-send-email-eliad@wizery.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
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
index a1ad326..a81e50b 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3975,44 +3975,32 @@ sta_not_found:
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

