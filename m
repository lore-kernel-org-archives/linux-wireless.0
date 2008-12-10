Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:48553 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961AbYLJMwN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 07:52:13 -0500
Date: Wed, 10 Dec 2008 14:51:47 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Disable requests for new scans in AP mode
Message-ID: <20081210125147.GA7849@jm.kir.nu> (sfid-20081210_135218_399789_94E88674)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AP mode operations are seriously affected if mac80211 runs through a
multi-second scan while the AP is trying to send Beacon frames on the
operation channel. While this could be implemented in a way that does
not cause too many problems, it is not very simple and will require
synchronization with Beacon frame scheduling in the drivers (scan one
channel at a time between Beacon frames). Furthermore, such scanning
takes quite a bit longer time and existing userspace applications
would be likely to timeout while waiting for the results.

For now, just refuse requests for new scans (SIOCSIWSCAN) when in AP
mode. In practice, this moves the rejection from iwl* drivers into
mac80211 to make it apply to every mac80211-based driver.

This issue shows up in associated stations getting disconnected when
something (e.g., Network Manager) requests a scan while the interface
is in AP mode. When doing this continuously (e.g., NM does it every 120
seconds), the network gets close to useless.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>

---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    6 ------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   11 -----------
 net/mac80211/wext.c                         |    3 +--
 3 files changed, 1 insertion(+), 19 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-12-10 14:47:30.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-12-10 14:48:12.000000000 +0200
@@ -2972,12 +2972,6 @@ static int iwl_mac_hw_scan(struct ieee80
 		goto out_unlock;
 	}
 
-	if (priv->iw_mode == NL80211_IFTYPE_AP) {	/* APs don't scan */
-		ret = -EIO;
-		IWL_ERROR("ERROR: APs don't scan\n");
-		goto out_unlock;
-	}
-
 	/* We don't schedule scan within next_scan_jiffies period.
 	 * Avoid scanning during possible EAPOL exchange, return
 	 * success immediately.
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-12-10 14:47:30.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-12-10 14:48:12.000000000 +0200
@@ -2105,11 +2105,6 @@ static void iwl3945_setup_rxon_timing(st
 
 static int iwl3945_scan_initiate(struct iwl3945_priv *priv)
 {
-	if (priv->iw_mode == NL80211_IFTYPE_AP) {
-		IWL_ERROR("APs don't scan.\n");
-		return 0;
-	}
-
 	if (!iwl3945_is_ready_rf(priv)) {
 		IWL_DEBUG_SCAN("Aborting scan due to not ready.\n");
 		return -EIO;
@@ -6991,12 +6986,6 @@ static int iwl3945_mac_hw_scan(struct ie
 		goto out_unlock;
 	}
 
-	if (priv->iw_mode == NL80211_IFTYPE_AP) {	/* APs don't scan */
-		rc = -EIO;
-		IWL_ERROR("ERROR: APs don't scan\n");
-		goto out_unlock;
-	}
-
 	/* we don't schedule scan within next_scan_jiffies period */
 	if (priv->next_scan_jiffies &&
 			time_after(priv->next_scan_jiffies, jiffies)) {
--- wireless-testing.orig/net/mac80211/wext.c	2008-12-10 14:47:30.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2008-12-10 14:48:12.000000000 +0200
@@ -418,8 +418,7 @@ static int ieee80211_ioctl_siwscan(struc
 
 	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 	    sdata->vif.type != NL80211_IFTYPE_ADHOC &&
-	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
-	    sdata->vif.type != NL80211_IFTYPE_AP)
+	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
 		return -EOPNOTSUPP;
 
 	/* if SSID was specified explicitly then use that */

-- 
Jouni Malinen                                            PGP id EFC895FA
