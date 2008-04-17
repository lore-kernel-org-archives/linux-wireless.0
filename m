Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6294 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349AbYDQXDn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 19:03:43 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Bill Moss <bmoss@clemson.edu>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/5] iwlwifi: fix debug messages during scanning
Date: Thu, 17 Apr 2008 16:03:40 -0700
Message-Id: <1208473420-16550-6-git-send-email-reinette.chatre@intel.com> (sfid-20080418_000351_953077_4551277B)
In-Reply-To: <1208473420-16550-5-git-send-email-reinette.chatre@intel.com>
References: <1208473420-16550-1-git-send-email-reinette.chatre@intel.com>
 <1208473420-16550-2-git-send-email-reinette.chatre@intel.com>
 <1208473420-16550-3-git-send-email-reinette.chatre@intel.com>
 <1208473420-16550-4-git-send-email-reinette.chatre@intel.com>
 <1208473420-16550-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bill Moss <bmoss@clemson.edu>

direct_mask will be set when we are not associated and requesting a
direct scan. The second debug print will be confusing as priv->essid
is not set at that time and it will thus print "<hidden>" while it is
known to which AP a direct scan is requested - as previous debug message
also indicates.

Now make all debugging consistent.

Signed-off-by: Bill Moss <bmoss@clemson.edu>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   16 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   13 ++++++-------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 1a5678f..1351e91 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6303,12 +6303,17 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 		       priv->direct_ssid, priv->direct_ssid_len);
 		direct_mask = 1;
 	} else if (!iwl3945_is_associated(priv) && priv->essid_len) {
+		IWL_DEBUG_SCAN
+		  ("Kicking off one direct scan for '%s' when not associated\n",
+		   iwl3945_escape_essid(priv->essid, priv->essid_len));
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->essid_len;
 		memcpy(scan->direct_scan[0].ssid, priv->essid, priv->essid_len);
 		direct_mask = 1;
-	} else
+	} else {
+		IWL_DEBUG_SCAN("Kicking off one indirect scan.\n");
 		direct_mask = 0;
+	}
 
 	/* We don't build a direct scan probe request; the uCode will do
 	 * that based on the direct_mask added to each channel entry */
@@ -6346,23 +6351,18 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR)
 		scan->filter_flags = RXON_FILTER_PROMISC_MSK;
 
-	if (direct_mask) {
-		IWL_DEBUG_SCAN
-		    ("Initiating direct scan for %s.\n",
-		     iwl3945_escape_essid(priv->essid, priv->essid_len));
+	if (direct_mask)
 		scan->channel_count =
 			iwl3945_get_channels_for_scan(
 				priv, band, 1, /* active */
 				direct_mask,
 				(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
-	} else {
-		IWL_DEBUG_SCAN("Initiating indirect scan.\n");
+	else
 		scan->channel_count =
 			iwl3945_get_channels_for_scan(
 				priv, band, 0, /* passive */
 				direct_mask,
 				(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
-	}
 
 	cmd.len += le16_to_cpu(scan->tx_cmd.len) +
 	    scan->channel_count * sizeof(struct iwl3945_scan_channel);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index fe340fd..7f1a743 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5775,11 +5775,15 @@ static void iwl4965_bg_request_scan(struct work_struct *data)
 		       priv->direct_ssid, priv->direct_ssid_len);
 		direct_mask = 1;
 	} else if (!iwl_is_associated(priv) && priv->essid_len) {
+		IWL_DEBUG_SCAN
+		  ("Kicking off one direct scan for '%s' when not associated\n",
+		   iwl4965_escape_essid(priv->essid, priv->essid_len));
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->essid_len;
 		memcpy(scan->direct_scan[0].ssid, priv->essid, priv->essid_len);
 		direct_mask = 1;
 	} else {
+		IWL_DEBUG_SCAN("Kicking off one indirect scan.\n");
 		direct_mask = 0;
 	}
 
@@ -5832,23 +5836,18 @@ static void iwl4965_bg_request_scan(struct work_struct *data)
 	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR)
 		scan->filter_flags = RXON_FILTER_PROMISC_MSK;
 
-	if (direct_mask) {
-		IWL_DEBUG_SCAN
-		    ("Initiating direct scan for %s.\n",
-		     iwl4965_escape_essid(priv->essid, priv->essid_len));
+	if (direct_mask)
 		scan->channel_count =
 			iwl4965_get_channels_for_scan(
 				priv, band, 1, /* active */
 				direct_mask,
 				(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
-	} else {
-		IWL_DEBUG_SCAN("Initiating indirect scan.\n");
+	else
 		scan->channel_count =
 			iwl4965_get_channels_for_scan(
 				priv, band, 0, /* passive */
 				direct_mask,
 				(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
-	}
 
 	cmd.len += le16_to_cpu(scan->tx_cmd.len) +
 	    scan->channel_count * sizeof(struct iwl4965_scan_channel);
-- 
1.5.3.4

