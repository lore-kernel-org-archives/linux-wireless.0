Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52820 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928Ab2EKIx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 04:53:26 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>
Subject: [PATCH 3/4] iwlwifi: invert the order of ssid list in scan cmd
Date: Fri, 11 May 2012 10:53:17 +0200
Message-Id: <1336726398-13200-4-git-send-email-johannes@sipsolutions.net> (sfid-20120511_105352_146548_479BF5E1)
In-Reply-To: <1336726398-13200-1-git-send-email-johannes@sipsolutions.net>
References: <1336726398-13200-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

The firmware inverts the order of ssid list of scan command, we
should invert the order before sending the command, in order to
get probe requests sent in wanted order.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 0505e4e..031d8e2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -767,7 +767,11 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 			ssid_len = priv->scan_request->ssids[0].ssid_len;
 			ssid = priv->scan_request->ssids[0].ssid;
 
-			for (i = 1; i < priv->scan_request->n_ssids; i++) {
+			/*
+			 * Invert the order of ssids, the firmware will invert
+			 * it back.
+			 */
+			for (i = priv->scan_request->n_ssids - 1; i >= 1; i--) {
 				scan->direct_scan[p].id = WLAN_EID_SSID;
 				scan->direct_scan[p].len =
 					priv->scan_request->ssids[i].ssid_len;
-- 
1.7.10

