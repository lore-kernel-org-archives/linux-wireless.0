Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.190]:27918 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933066AbYETPjc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 11:39:32 -0400
Received: by gv-out-0910.google.com with SMTP id e6so539728gvc.37
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2008 08:39:29 -0700 (PDT)
Message-ID: <69e28c910805200839k7426833auf96faef99dc49d9b@mail.gmail.com> (sfid-20080520_174113_068070_0B6A21F2)
Date: Tue, 20 May 2008 11:39:28 -0400
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi injection bug
Cc: "Tomas Winkler" <tomasw@gmail.com>, "Zhu Yi" <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Andy Green" <andy@warmcat.com>
In-Reply-To: <1211296710.6252.99.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1210945631.6381.11.camel@johannes.berg>
	 <1211249729.2532.59.camel@debian.sh.intel.com>
	 <69e28c910805200432lbd3790vb925dacaea3aca83@mail.gmail.com>
	 <1211287111.6252.84.camel@johannes.berg>
	 <69e28c910805200614q2232b21ame8ff03fe4156fb3b@mail.gmail.com>
	 <1ba2fa240805200641j4ccc1de4r5572e1321394a526@mail.gmail.com>
	 <69e28c910805200716i3fd16c33x274983ab8e7591e6@mail.gmail.com>
	 <1211293631.6252.98.camel@johannes.berg>
	 <69e28c910805200758j72281d34kfaa244e9bbdd8451@mail.gmail.com>
	 <1211296710.6252.99.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2008 at 11:18 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> I tend to think it should be removed, in regular operation mac80211
> would never create such a data frame, and when injecting you actually
> want it.
>
> johannes
>

OK! I have also determined that my IWL_INVALID_STATION change is
unnecessary, as injected packets do have a valid station ID (they are
marked as broadcast by iwl*9*5_get_sta_id). The IWL_INVALID_STATION
change was a hack I put in earlier, before finding the real problems
in iwl*9*5_get_sta_id and iwl*9*5_mac_tx.

----

diff -rp -U 8 compat-wireless-2008-05-20.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c
compat-wireless-2008-05-20/drivers/net/wireless/iwlwifi/iwl3945-base.c
--- compat-wireless-2008-05-20.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-05-20
05:05:29.000000000 -0400
+++ compat-wireless-2008-05-20/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-05-20
11:31:15.513173847 -0400
@@ -2542,16 +2542,19 @@ static int iwl3945_get_sta_id(struct iwl
 			return sta_id;

 		IWL_DEBUG_DROP("Station %s not in station map. "
 			       "Defaulting to broadcast...\n",
 			       print_mac(mac, hdr->addr1));
 		iwl3945_print_hex_dump(IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
 		return priv->hw_setting.bcast_sta_id;
 	}
+	/* If we are in monitor mode, use BCAST */
+	case IEEE80211_IF_TYPE_MNTR:
+		return priv->hw_setting.bcast_sta_id;
 	default:
 		IWL_WARNING("Unknown mode of operation: %d", priv->iw_mode);
 		return priv->hw_setting.bcast_sta_id;
 	}
 }

 /*
  * start REPLY_TX command process
@@ -2579,21 +2582,16 @@ static int iwl3945_tx_skb(struct iwl3945
 	int rc;

 	spin_lock_irqsave(&priv->lock, flags);
 	if (iwl3945_is_rfkill(priv)) {
 		IWL_DEBUG_DROP("Dropping - RF KILL\n");
 		goto drop_unlock;
 	}

-	if (!priv->vif) {
-		IWL_DEBUG_DROP("Dropping - !priv->vif\n");
-		goto drop_unlock;
-	}
-
 	if ((ctl->tx_rate->hw_value & 0xFF) == IWL_INVALID_RATE) {
 		IWL_ERROR("ERROR: No TX rate available.\n");
 		goto drop_unlock;
 	}

 	unicast = !is_multicast_ether_addr(hdr->addr1);
 	id = 0;

@@ -2603,24 +2601,16 @@ static int iwl3945_tx_skb(struct iwl3945
 	if (ieee80211_is_auth(fc))
 		IWL_DEBUG_TX("Sending AUTH frame\n");
 	else if (ieee80211_is_assoc_request(fc))
 		IWL_DEBUG_TX("Sending ASSOC frame\n");
 	else if (ieee80211_is_reassoc_request(fc))
 		IWL_DEBUG_TX("Sending REASSOC frame\n");
 #endif

-	/* drop all data frame if we are not associated */
-	if ((!iwl3945_is_associated(priv) ||
-	     ((priv->iw_mode == IEEE80211_IF_TYPE_STA) && !priv->assoc_id)) &&
-	    ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)) {
-		IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated\n");
-		goto drop_unlock;
-	}
-
 	spin_unlock_irqrestore(&priv->lock, flags);

 	hdr_len = ieee80211_get_hdrlen(fc);

 	/* Find (or create) index into station table for destination station */
 	sta_id = iwl3945_get_sta_id(priv, hdr);
 	if (sta_id == IWL_INVALID_STATION) {
 		DECLARE_MAC_BUF(mac);
@@ -6692,21 +6682,16 @@ static void iwl3945_mac_stop(struct ieee

 static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		      struct ieee80211_tx_control *ctl)
 {
 	struct iwl3945_priv *priv = hw->priv;

 	IWL_DEBUG_MAC80211("enter\n");

-	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
-		IWL_DEBUG_MAC80211("leave - monitor\n");
-		return -1;
-	}
-
 	IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 		     ctl->tx_rate->bitrate);

 	if (iwl3945_tx_skb(priv, skb, ctl))
 		dev_kfree_skb_any(skb);

 	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
diff -rp -U 8 compat-wireless-2008-05-20.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c
compat-wireless-2008-05-20/drivers/net/wireless/iwlwifi/iwl4965-base.c
--- compat-wireless-2008-05-20.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-05-20
05:05:29.000000000 -0400
+++ compat-wireless-2008-05-20/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-05-20
11:31:54.278205087 -0400
@@ -1746,16 +1746,19 @@ static int iwl4965_get_sta_id(struct iwl
 			return sta_id;

 		IWL_DEBUG_DROP("Station %s not in station map. "
 			       "Defaulting to broadcast...\n",
 			       print_mac(mac, hdr->addr1));
 		iwl_print_hex_dump(priv, IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
 		return priv->hw_params.bcast_sta_id;

+	/* If we are in monitor mode, use BCAST */
+	case IEEE80211_IF_TYPE_MNTR:
+		return priv->hw_params.bcast_sta_id;
 	default:
 		IWL_WARNING("Unknown mode of operation: %d", priv->iw_mode);
 		return priv->hw_params.bcast_sta_id;
 	}
 }

 /*
  * start REPLY_TX command process
@@ -1784,21 +1787,16 @@ static int iwl4965_tx_skb(struct iwl_pri
 	int rc;

 	spin_lock_irqsave(&priv->lock, flags);
 	if (iwl_is_rfkill(priv)) {
 		IWL_DEBUG_DROP("Dropping - RF KILL\n");
 		goto drop_unlock;
 	}

-	if (!priv->vif) {
-		IWL_DEBUG_DROP("Dropping - !priv->vif\n");
-		goto drop_unlock;
-	}
-
 	if ((ctl->tx_rate->hw_value & 0xFF) == IWL_INVALID_RATE) {
 		IWL_ERROR("ERROR: No TX rate available.\n");
 		goto drop_unlock;
 	}

 	unicast = !is_multicast_ether_addr(hdr->addr1);
 	id = 0;

@@ -1808,25 +1806,16 @@ static int iwl4965_tx_skb(struct iwl_pri
 	if (ieee80211_is_auth(fc))
 		IWL_DEBUG_TX("Sending AUTH frame\n");
 	else if (ieee80211_is_assoc_request(fc))
 		IWL_DEBUG_TX("Sending ASSOC frame\n");
 	else if (ieee80211_is_reassoc_request(fc))
 		IWL_DEBUG_TX("Sending REASSOC frame\n");
 #endif

-	/* drop all data frame if we are not associated */
-	if (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
-	   (!iwl_is_associated(priv) ||
-	    ((priv->iw_mode == IEEE80211_IF_TYPE_STA) && !priv->assoc_id) ||
-	    !priv->assoc_station_added)) {
-		IWL_DEBUG_DROP("Dropping - !iwl_is_associated\n");
-		goto drop_unlock;
-	}
-
 	spin_unlock_irqrestore(&priv->lock, flags);

 	hdr_len = ieee80211_get_hdrlen(fc);

 	/* Find (or create) index into station table for destination station */
 	sta_id = iwl4965_get_sta_id(priv, hdr);
 	if (sta_id == IWL_INVALID_STATION) {
 		DECLARE_MAC_BUF(mac);
@@ -5110,21 +5099,16 @@ static void iwl4965_mac_stop(struct ieee

 static int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		      struct ieee80211_tx_control *ctl)
 {
 	struct iwl_priv *priv = hw->priv;

 	IWL_DEBUG_MAC80211("enter\n");

-	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
-		IWL_DEBUG_MAC80211("leave - monitor\n");
-		return -1;
-	}
-
 	IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 		     ctl->tx_rate->bitrate);

 	if (iwl4965_tx_skb(priv, skb, ctl))
 		dev_kfree_skb_any(skb);

 	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
