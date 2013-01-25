Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:60387 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756802Ab3AYK4p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 05:56:45 -0500
Date: Fri, 25 Jan 2013 16:20:03 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 2/7] mwl8k: Allow adding station interface on AP firmware
Message-ID: <20130125105002.GA9404@markyou.marvell.com> (sfid-20130125_115712_987210_CBF524DF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When user wants to add a station interface when
AP firmware is loaded & in-use, allow creating
it and also notify user about the same.

Allow adding max one STA interface for AP fw.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 6c727be..59df345 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2519,7 +2519,7 @@ static int mwl8k_cmd_get_hw_spec_ap(struct ieee80211_hw *hw)
 		priv->hw_rev = cmd->hw_rev;
 		mwl8k_set_caps(hw, le32_to_cpu(cmd->caps));
 		priv->ap_macids_supported = 0x000000ff;
-		priv->sta_macids_supported = 0x00000000;
+		priv->sta_macids_supported = 0x00000100;
 		priv->num_ampdu_queues = le32_to_cpu(cmd->num_of_ampdu_queues);
 		if (priv->num_ampdu_queues > MWL8K_MAX_AMPDU_QUEUES) {
 			wiphy_warn(hw->wiphy, "fw reported %d ampdu queues"
@@ -4669,12 +4669,18 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 		break;
 	case NL80211_IFTYPE_STATION:
 		if (priv->ap_fw && di->fw_image_sta) {
-			/* we must load the sta fw to meet this request */
-			if (!list_empty(&priv->vif_list))
-				return -EBUSY;
-			rc = mwl8k_reload_firmware(hw, di->fw_image_sta);
-			if (rc)
-				return rc;
+			if (!list_empty(&priv->vif_list)) {
+				wiphy_warn(hw->wiphy, "AP interface is running.\n"
+					   "Adding STA interface for WDS");
+			} else {
+				/* we must load the sta fw to
+				 * meet this request.
+				 */
+				rc = mwl8k_reload_firmware(hw,
+							   di->fw_image_sta);
+				if (rc)
+					return rc;
+			}
 		}
 		macids_supported = priv->sta_macids_supported;
 		break;
-- 
1.8.0.3

