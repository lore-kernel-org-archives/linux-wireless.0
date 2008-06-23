Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.235]:60784 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbYFWJK1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 05:10:27 -0400
Received: by wx-out-0506.google.com with SMTP id h29so667765wxd.4
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2008 02:10:25 -0700 (PDT)
Message-ID: <485F687C.1050407@gmail.com> (sfid-20080623_111053_910844_84C4020C)
Date: Mon, 23 Jun 2008 12:10:20 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: ipw3945-devel@lists.sourceforge.net,
	=?ISO-8859-1?Q?Stefanik_G=E1bo?= =?ISO-8859-1?Q?r?=
	<netrolller.3d@gmail.com>
Subject: [BUG] Two bugs in monitor mode, iwl3945
Content-Type: multipart/mixed;
 boundary="------------000200060203070207070905"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000200060203070207070905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

I noticed two bugs:

1) Monitor mode hangs the system randomly, and what is interesting that this
bug disappears if I patch the driver with packet injection patch from Gábor Stefanik.
I noticed this bug, after I removed his patch to see if it caused some problems.
Always reproducible, usually hangs just after airodump launch.

2) If I enable monitor mode regardless of injection patch, the scanning results got garbaged,
iwlist scan reports > 100 quality on most APs, or 0% quality on my router, shows extremely low and hi power levels, like
-127dBm or 160 dBm, and those levels change rapidly.
This why I removed the injection patch, I suspected it, but this bug appears to be not related to it.


Injection patch from Gábor Stefanik <netrolller.3d@gmail.com> attached
(I modified the patch to apply on latest wireless -git, but patch is the same)

I use iw to create new monitor interface and use it.

Best regards,
	Maxim Levitsky

--------------000200060203070207070905
Content-Type: text/x-diff;
 name="0001-Enable-packet-injection-in-iwlwifi.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="0001-Enable-packet-injection-in-iwlwifi.patch"

>From GÃ¡bor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   23 ++++-------------------
 1 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 43cb8ff..13f61f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2539,6 +2539,9 @@ static int iwl3945_get_sta_id(struct iwl3945_priv *priv, struct ieee80211_hdr *h
 		iwl3945_print_hex_dump(IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
 		return priv->hw_setting.bcast_sta_id;
 	}
+	/* If we are in monitor mode, use BCAST */
+	case IEEE80211_IF_TYPE_MNTR:
+		return priv->hw_setting.bcast_sta_id;
 	default:
 		IWL_WARNING("Unknown mode of operation: %d", priv->iw_mode);
 		return priv->hw_setting.bcast_sta_id;
@@ -2578,11 +2581,6 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv, struct sk_buff *skb)
 		goto drop_unlock;
 	}
 
-	if (!priv->vif) {
-		IWL_DEBUG_DROP("Dropping - !priv->vif\n");
-		goto drop_unlock;
-	}
-
 	if ((ieee80211_get_tx_rate(priv->hw, info)->hw_value & 0xFF) == IWL_INVALID_RATE) {
 		IWL_ERROR("ERROR: No TX rate available.\n");
 		goto drop_unlock;
@@ -2602,14 +2600,6 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv, struct sk_buff *skb)
 		IWL_DEBUG_TX("Sending REASSOC frame\n");
 #endif
 
-	/* drop all data frame if we are not associated */
-	if ((!iwl3945_is_associated(priv) ||
-	     ((priv->iw_mode == IEEE80211_IF_TYPE_STA) && !priv->assoc_id)) &&
-	    ieee80211_is_data(fc)) {
-		IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated\n");
-		goto drop_unlock;
-	}
-
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	hdr_len = ieee80211_get_hdrlen(le16_to_cpu(fc));
@@ -6350,7 +6340,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	scan->flags |= iwl3945_get_antenna_flags(priv);
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR)
-		scan->filter_flags = RXON_FILTER_PROMISC_MSK;
+		scan->filter_flags |= RXON_FILTER_PROMISC_MSK | RXON_FILTER_CTL2HOST_MSK | RXON_FILTER_ACCEPT_GRP_MSK;
 
 	if (direct_mask)
 		scan->channel_count =
@@ -6693,11 +6683,6 @@ static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
-		IWL_DEBUG_MAC80211("leave - monitor\n");
-		return -1;
-	}
-
 	IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 		     ieee80211_get_tx_rate(hw, IEEE80211_SKB_CB(skb))->bitrate);
 
-- 
1.5.4.3


--------------000200060203070207070905--
