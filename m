Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:1076 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379AbYETNOc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 09:14:32 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1763103wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2008 06:14:30 -0700 (PDT)
Message-ID: <69e28c910805200614q2232b21ame8ff03fe4156fb3b@mail.gmail.com> (sfid-20080520_151447_367483_12E03AB2)
Date: Tue, 20 May 2008 09:14:30 -0400
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi injection bug
Cc: "Zhu Yi" <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Andy Green" <andy@warmcat.com>
In-Reply-To: <1211287111.6252.84.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1210945631.6381.11.camel@johannes.berg>
	 <1211249729.2532.59.camel@debian.sh.intel.com>
	 <69e28c910805200432lbd3790vb925dacaea3aca83@mail.gmail.com>
	 <1211287111.6252.84.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Resend of previous mail, his time also sending to the list.)
On Tue, May 20, 2008 at 8:38 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> <snip>
>
> That code is completely bogus anyway IMO, it should just be removed.
>
>> <snip>
>
> Same here, why drop a frame if there's no station for it, that just
> means you can't do hw encryption which, well, cannot happen anyway since
> mac80211 would tell you about the station for hw crypto.
>
>> <snip>
>
> That's the code I was complaining about. Just kill it if it works then.
>
>> <snip>
>
> Same code, other driver. What are you doing poking with the 802.11
> frames you're supposed to transmit anyway?
>
> I wish you guys at Intel would trust mac80211 and not try to work around
> it all the time.
>
> johannes
>

Patch with nits addressed, a syslog issue fixed and also with a
bracketing fix in 3945:

diff -rp -U 8 compat-wireless-2008-05-20.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c
compat-wireless-2008-05-20/drivers/net/wireless/iwlwifi/iwl3945-base.c
--- compat-wireless-2008-05-20.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-05-20
05:05:29.000000000 -0400
+++ compat-wireless-2008-05-20/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-05-20
08:54:52.819664502 -0400
@@ -2523,17 +2523,17 @@ static int iwl3945_get_sta_id(struct iwl
 	case IEEE80211_IF_TYPE_AP:
 		sta_id = iwl3945_hw_find_station(priv, hdr->addr1);
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
 		return priv->hw_setting.bcast_sta_id;

 	/* If this frame is going out to an IBSS network, find the station,
 	 * or create a new station table entry */
-	case IEEE80211_IF_TYPE_IBSS: {
+	case IEEE80211_IF_TYPE_IBSS:
 		DECLARE_MAC_BUF(mac);

 		/* Create new station table entry */
 		sta_id = iwl3945_hw_find_station(priv, hdr->addr1);
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;

 		sta_id = iwl3945_add_station(priv, hdr->addr1, 0, CMD_ASYNC);
@@ -2541,17 +2541,20 @@ static int iwl3945_get_sta_id(struct iwl
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;

 		IWL_DEBUG_DROP("Station %s not in station map. "
 			       "Defaulting to broadcast...\n",
 			       print_mac(mac, hdr->addr1));
 		iwl3945_print_hex_dump(IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
 		return priv->hw_setting.bcast_sta_id;
-	}
+
+	/* If we are in monitor mode, use BCAST */
+	case IEEE80211_IF_TYPE_MNTR:
+		return priv->hw_params.bcast_sta_id;
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

@@ -2603,37 +2601,22 @@ static int iwl3945_tx_skb(struct iwl3945
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
-	if (sta_id == IWL_INVALID_STATION) {
-		DECLARE_MAC_BUF(mac);
-
-		IWL_DEBUG_DROP("Dropping - INVALID STATION: %s\n",
-			       print_mac(mac, hdr->addr1));
-		goto drop;
-	}

 	IWL_DEBUG_RATE("station Id %d\n", sta_id);

 	qc = ieee80211_get_qos_ctrl(hdr);
 	if (qc) {
 		u8 tid = (u8)(le16_to_cpu(*qc) & 0xf);
 		seq_number = priv->stations[sta_id].tid[tid].seq_number &
 				IEEE80211_SCTL_SEQ;
@@ -6692,21 +6675,16 @@ static void iwl3945_mac_stop(struct ieee

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
08:55:20.689530273 -0400
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

@@ -1808,38 +1806,22 @@ static int iwl4965_tx_skb(struct iwl_pri
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
-	if (sta_id == IWL_INVALID_STATION) {
-		DECLARE_MAC_BUF(mac);
-
-		IWL_DEBUG_DROP("Dropping - INVALID STATION: %s\n",
-			       print_mac(mac, hdr->addr1));
-		goto drop;
-	}

 	IWL_DEBUG_TX("station Id %d\n", sta_id);

 	qc = ieee80211_get_qos_ctrl(hdr);
 	if (qc) {
 		u8 tid = (u8)(le16_to_cpu(*qc) & 0xf);
 		seq_number = priv->stations[sta_id].tid[tid].seq_number &
 				IEEE80211_SCTL_SEQ;
@@ -5110,21 +5092,16 @@ static void iwl4965_mac_stop(struct ieee

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
