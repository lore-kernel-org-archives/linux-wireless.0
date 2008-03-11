Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41682 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbYCKXSM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 19:18:12 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/6] iwlwifi: fix bug to show hidden APs during scan
Date: Tue, 11 Mar 2008 16:17:15 -0700
Message-Id: <1205277440-14323-2-git-send-email-reinette.chatre@intel.com> (sfid-20080311_231824_273307_6271A609)
In-Reply-To: <1205277440-14323-1-git-send-email-reinette.chatre@intel.com>
References: <1205277440-14323-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Indirect scanning ('iwlist scan') should report information about
hidden APs. When an AP is hidden it does not respond to active scanning,
we thus have to use passive scanning to locate these APs.

This fixes http://bughost.org/bugzilla/show_bug.cgi?id=1499

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Bill Moss <bmoss@clemson.edu>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   21 +++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   21 +++++++++++++--------
 2 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index ecf749c..ed48134 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6309,18 +6309,23 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR)
 		scan->filter_flags = RXON_FILTER_PROMISC_MSK;
 
-	if (direct_mask)
+	if (direct_mask) {
 		IWL_DEBUG_SCAN
 		    ("Initiating direct scan for %s.\n",
 		     iwl3945_escape_essid(priv->essid, priv->essid_len));
-	else
+		scan->channel_count =
+			iwl3945_get_channels_for_scan(
+				priv, band, 1, /* active */
+				direct_mask,
+				(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
+	} else {
 		IWL_DEBUG_SCAN("Initiating indirect scan.\n");
-
-	scan->channel_count =
-		iwl3945_get_channels_for_scan(
-			priv, band, 1, /* active */
-			direct_mask,
-			(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
+		scan->channel_count =
+			iwl3945_get_channels_for_scan(
+				priv, band, 0, /* passive */
+				direct_mask,
+				(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
+	}
 
 	cmd.len += le16_to_cpu(scan->tx_cmd.len) +
 	    scan->channel_count * sizeof(struct iwl3945_scan_channel);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 28c64c3..74b06b1 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6821,18 +6821,23 @@ static void iwl4965_bg_request_scan(struct work_struct *data)
 	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR)
 		scan->filter_flags = RXON_FILTER_PROMISC_MSK;
 
-	if (direct_mask)
+	if (direct_mask) {
 		IWL_DEBUG_SCAN
 		    ("Initiating direct scan for %s.\n",
 		     iwl4965_escape_essid(priv->essid, priv->essid_len));
-	else
+		scan->channel_count =
+			iwl4965_get_channels_for_scan(
+				priv, band, 1, /* active */
+				direct_mask,
+				(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
+	} else {
 		IWL_DEBUG_SCAN("Initiating indirect scan.\n");
-
-	scan->channel_count =
-		iwl4965_get_channels_for_scan(
-			priv, band, 1, /* active */
-			direct_mask,
-			(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
+		scan->channel_count =
+			iwl4965_get_channels_for_scan(
+				priv, band, 0, /* passive */
+				direct_mask,
+				(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
+	}
 
 	cmd.len += le16_to_cpu(scan->tx_cmd.len) +
 	    scan->channel_count * sizeof(struct iwl4965_scan_channel);
-- 
1.5.3.4

