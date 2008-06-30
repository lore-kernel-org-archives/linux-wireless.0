Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19551 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759587AbYF3J1Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:27:16 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	=?utf-8?q?Stefanik=20G=C3=A1bor?= <netrolller.3d@gmail.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 30/33] iwlwifi: enable packet injection for iwl3945
Date: Mon, 30 Jun 2008 17:23:30 +0800
Message-Id: <1214817813-17639-31-git-send-email-yi.zhu@intel.com> (sfid-20080630_113813_980192_BB767F24)
In-Reply-To: <1214817813-17639-30-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-7-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-8-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-9-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-10-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-11-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-12-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-13-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-14-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-15-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-16-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-17-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-18-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-19-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-20-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-21-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-22-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-23-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-24-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-25-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-26-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-27-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-28-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-29-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-30-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=46rom: Stefanik G=C3=A1bor <netrolller.3d@gmail.com>

This patch enables packet injection on iwl3945 devices. Tested with
packetspammer and aireplay-ng.

Signed-off-by: G=C3=A1bor Stefanik <netrolller.3d@gmail.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   23 +++++++++----------=
----
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/=
wireless/iwlwifi/iwl3945-base.c
index 2744b0a..73942a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2539,6 +2539,11 @@ static int iwl3945_get_sta_id(struct iwl3945_pri=
v *priv, struct ieee80211_hdr *h
 		iwl3945_print_hex_dump(IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
 		return priv->hw_setting.bcast_sta_id;
 	}
+	/* If we are in monitor mode, use BCAST. This is required for
+	 * packet injection. */
+	case IEEE80211_IF_TYPE_MNTR:
+		return priv->hw_setting.bcast_sta_id;
+
 	default:
 		IWL_WARNING("Unknown mode of operation: %d", priv->iw_mode);
 		return priv->hw_setting.bcast_sta_id;
@@ -2578,11 +2583,6 @@ static int iwl3945_tx_skb(struct iwl3945_priv *p=
riv, struct sk_buff *skb)
 		goto drop_unlock;
 	}
=20
-	if (!priv->vif) {
-		IWL_DEBUG_DROP("Dropping - !priv->vif\n");
-		goto drop_unlock;
-	}
-
 	if ((ieee80211_get_tx_rate(priv->hw, info)->hw_value & 0xFF) =3D=3D I=
WL_INVALID_RATE) {
 		IWL_ERROR("ERROR: No TX rate available.\n");
 		goto drop_unlock;
@@ -2603,9 +2603,10 @@ static int iwl3945_tx_skb(struct iwl3945_priv *p=
riv, struct sk_buff *skb)
 #endif
=20
 	/* drop all data frame if we are not associated */
-	if ((!iwl3945_is_associated(priv) ||
-	     ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA) && !priv->assoc_id=
)) &&
-	    ieee80211_is_data(fc)) {
+	if (ieee80211_is_data(fc) &&
+	    (priv->iw_mode !=3D IEEE80211_IF_TYPE_MNTR) && /* packet injectio=
n */
+	    (!iwl3945_is_associated(priv) ||
+	     ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA) && !priv->assoc_id=
))) {
 		IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated\n");
 		goto drop_unlock;
 	}
@@ -6693,12 +6694,6 @@ static int iwl3945_mac_tx(struct ieee80211_hw *h=
w, struct sk_buff *skb)
=20
 	IWL_DEBUG_MAC80211("enter\n");
=20
-	if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
-		IWL_DEBUG_MAC80211("leave - monitor\n");
-		dev_kfree_skb_any(skb);
-		return 0;
-	}
-
 	IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 		     ieee80211_get_tx_rate(hw, IEEE80211_SKB_CB(skb))->bitrate);
=20
--=20
1.5.3.6

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
