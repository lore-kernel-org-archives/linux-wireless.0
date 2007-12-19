Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40602 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821AbXLSPrW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 10:47:22 -0500
Subject: [PATCH] iwl4965: fix bogus hardware scan configuration caching
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 19 Dec 2007 01:30:23 +0100
Message-Id: <1198024224.4885.188.camel@johannes.berg> (sfid-20071219_154729_785972_17734D5B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When iwl4965 is scanning, it needs to cache any configuration requests.
This was implemented but the implementation is buggy: it uses only
the *first* configuration rather than the *last* that is requested
during scanning. This patch fixes that and also removes a bogus
comment related to the issue.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This patch requires porting to iwl3965. For correctness, it
needs to be applied to 2.6.24 although most likely nobody will
ask to change channel twice during a single hardware scan. Duh!

Warning: patch is not even compile tested yet because I currently have a
broken tree. I don't see why it shouldn't work though.

 drivers/net/wireless/iwlwifi/iwl4965-base.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

--- everything.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-12-19 01:17:23.773023329 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-12-19 01:20:08.943020887 +0100
@@ -7471,25 +7471,21 @@ static int iwl4965_mac_config(struct iee
 		goto out;
 	}
 
-	/* TODO: Figure out how to get ieee80211_local->sta_scanning w/ only
-	 * what is exposed through include/ declarations */
 	if (unlikely(!iwl4965_param_disable_hw_scan &&
 		     test_bit(STATUS_SCANNING, &priv->status))) {
+		/*
+		 * Cache the configuration now so that we can
+		 * replay it after the hardware scan is finished.
+		 */
 
-		if (unlikely(priv->cache_conf))
-			IWL_DEBUG_MAC80211("leave - still scanning\n");
-		else {
-			/* Cache the configuration now so that we can
-			 * replay it after the hardware scan is finished. */
+		if (likely(!priv->cache_conf))
 			priv->cache_conf = kmalloc(sizeof(*conf), GFP_KERNEL);
-			if (priv->cache_conf) {
-				memcpy(priv->cache_conf, conf, sizeof(*conf));
-				IWL_DEBUG_MAC80211("leave - scanning\n");
-			} else {
-				IWL_DEBUG_MAC80211("leave - no memory\n");
-				ret = -ENOMEM;
-			}
-		}
+
+		if (likely(priv->cache_conf))
+			memcpy(priv->cache_conf, conf, sizeof(*conf));
+		else
+			ret = -ENOMEM;
+
 		mutex_unlock(&priv->mutex);
 		return ret;
 	}


