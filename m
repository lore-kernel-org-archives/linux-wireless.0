Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56096 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbYJ1Sgu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 14:36:50 -0400
Subject: [PATCH] iwlwifi: remove implicit direct scan
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 18:21:05 +0100
Message-Id: <1225214465.3598.27.camel@johannes.berg> (sfid-20081028_193653_050927_09B23C55)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When an undirected scan is requested and iwlwifi is not associated but
the user has set an SSID (and maybe was associated with that network at
some point) then iwlwifi will assume the user wanted to scan for this
SSID which seems wrong. Remove this code.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Am I missing something? This seems very strange! What specifies that
when an SSID is set on an interface the user wants to scan for that one?
The interface might just have been associated previously to that SSID,
now disassociated and network manager is asking for a scan to get
information about networks to let the user select a new one.

 drivers/net/wireless/iwlwifi/iwl-scan.c     |    7 -------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    8 --------
 2 files changed, 15 deletions(-)

--- everything.orig/drivers/net/wireless/iwlwifi/iwl-scan.c	2008-10-28 18:12:02.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-scan.c	2008-10-28 18:12:06.000000000 +0100
@@ -743,13 +743,6 @@ static void iwl_bg_request_scan(struct w
 		memcpy(scan->direct_scan[0].ssid,
 		       priv->direct_ssid, priv->direct_ssid_len);
 		n_probes++;
-	} else if (!iwl_is_associated(priv) && priv->essid_len) {
-		IWL_DEBUG_SCAN("Start direct scan for '%s' (not associated)\n",
-				print_ssid(ssid, priv->essid, priv->essid_len));
-		scan->direct_scan[0].id = WLAN_EID_SSID;
-		scan->direct_scan[0].len = priv->essid_len;
-		memcpy(scan->direct_scan[0].ssid, priv->essid, priv->essid_len);
-		n_probes++;
 	} else {
 		IWL_DEBUG_SCAN("Start indirect scan.\n");
 	}
--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-10-28 18:12:20.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-10-28 18:12:27.000000000 +0100
@@ -6158,14 +6158,6 @@ static void iwl3945_bg_request_scan(stru
 		memcpy(scan->direct_scan[0].ssid,
 		       priv->direct_ssid, priv->direct_ssid_len);
 		n_probes++;
-	} else if (!iwl3945_is_associated(priv) && priv->essid_len) {
-		IWL_DEBUG_SCAN
-		  ("Kicking off one direct scan for '%s' when not associated\n",
-		   print_ssid(ssid, priv->essid, priv->essid_len));
-		scan->direct_scan[0].id = WLAN_EID_SSID;
-		scan->direct_scan[0].len = priv->essid_len;
-		memcpy(scan->direct_scan[0].ssid, priv->essid, priv->essid_len);
-		n_probes++;
 	} else
 		IWL_DEBUG_SCAN("Kicking off one indirect scan.\n");
 


