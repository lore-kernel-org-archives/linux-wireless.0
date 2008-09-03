Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63905 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272AbYICDb5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:57 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	=?utf-8?q?Stefanik=20G=C3=A1bor?= <netrolller.3d@gmail.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 39/39] iwlwifi: enable packet injection for iwlagn
Date: Wed,  3 Sep 2008 11:26:59 +0800
Message-Id: <1220412419-15404-40-git-send-email-yi.zhu@intel.com> (sfid-20080903_055041_778633_365BC4AA)
In-Reply-To: <1220412419-15404-39-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-10-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-11-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-12-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-13-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-14-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-15-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-16-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-17-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-18-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-19-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-20-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-21-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-22-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-23-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-24-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-25-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-26-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-27-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-28-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-29-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-30-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-31-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-32-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-33-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-34-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-35-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-36-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-37-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-38-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-39-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=46rom: Stefanik G=C3=A1bor <netrolller.3d@gmail.com>

Handle station IDs of transmitted packets when in monitor mode, and
remove the various anti-injection checks from the iwl4965 driver.
This makes injection work on iwl4965 and iwl5000. Tested on both cards.

Note: To inject management frames with encryption, HW crypto support
must be disabled using the "swcrypto=3D1" modparam (or "swcrypto50=3D1"
for iwl5000). Otherwise most management frames won't be transmitted.

Signed-off-by: G=C3=A1bor Stefanik <netrolller.3d@gmail.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    6 ------
 drivers/net/wireless/iwlwifi/iwl-sta.c |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-tx.c  |   13 +++++--------
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wirel=
ess/iwlwifi/iwl-agn.c
index cf882bf..31ea288 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2734,12 +2734,6 @@ static int iwl4965_mac_tx(struct ieee80211_hw *h=
w, struct sk_buff *skb)
=20
 	IWL_DEBUG_MACDUMP("enter\n");
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
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wirel=
ess/iwlwifi/iwl-sta.c
index 3c0204c..a72569f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -968,6 +968,11 @@ int iwl_get_sta_id(struct iwl_priv *priv, struct i=
eee80211_hdr *hdr)
 		iwl_print_hex_dump(priv, IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
 		return priv->hw_params.bcast_sta_id;
=20
+	/* If we are in monitor mode, use BCAST. This is required for
+	 * packet injection. */
+	case IEEE80211_IF_TYPE_MNTR:
+		return priv->hw_params.bcast_sta_id;
+
 	default:
 		IWL_WARNING("Unknown mode of operation: %d\n", priv->iw_mode);
 		return priv->hw_params.bcast_sta_id;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wirele=
ss/iwlwifi/iwl-tx.c
index 9ef6451..9d5bcf4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -793,11 +793,6 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_bu=
ff *skb)
 		goto drop_unlock;
 	}
=20
-	if (!priv->vif) {
-		IWL_DEBUG_DROP("Dropping - !priv->vif\n");
-		goto drop_unlock;
-	}
-
 	if ((ieee80211_get_tx_rate(priv->hw, info)->hw_value & 0xFF) =3D=3D
 	     IWL_INVALID_RATE) {
 		IWL_ERROR("ERROR: No TX rate available.\n");
@@ -819,9 +814,11 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_bu=
ff *skb)
=20
 	/* drop all data frame if we are not associated */
 	if (ieee80211_is_data(fc) &&
-	   (!iwl_is_associated(priv) ||
-	    ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA) && !priv->assoc_id)=
 ||
-	    !priv->assoc_station_added)) {
+	    (priv->iw_mode !=3D IEEE80211_IF_TYPE_MNTR ||
+	    !(info->flags & IEEE80211_TX_CTL_INJECTED)) && /* packet injectio=
n */
+	    (!iwl_is_associated(priv) ||
+	     ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA) && !priv->assoc_id=
) ||
+	     !priv->assoc_station_added)) {
 		IWL_DEBUG_DROP("Dropping - !iwl_is_associated\n");
 		goto drop_unlock;
 	}
--=20
1.5.3.6

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
