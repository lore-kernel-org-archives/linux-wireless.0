Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.229]:42102 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758371AbYETXDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 19:03:19 -0400
Received: by wr-out-0506.google.com with SMTP id c48so1274429wra.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2008 16:03:18 -0700 (PDT)
Message-ID: <69e28c910805201603i3db5481axb758b842ffc30c8d@mail.gmail.com> (sfid-20080521_010400_536417_2DBCF081)
Date: Tue, 20 May 2008 19:03:17 -0400
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH] iwlwifi: Fix packet injection in iwl3945 and iwl4965
Cc: "John Linville" <linville@tuxdriver.com>,
	"Zhu Yi" <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Andy Green" <andy@warmcat.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <69e28c910805201556g1f28ec9fge9e23ef701db7d9a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <69e28c910805201001r78d13ec5v4c7cf933edd39c10@mail.gmail.com>
	 <1ba2fa240805201441u2182071en5d557bb8f5f28504@mail.gmail.com>
	 <69e28c910805201451r3cab72bbwe9600008c9cc105d@mail.gmail.com>
	 <1ba2fa240805201518h78f9825fw389d0afd42f0130b@mail.gmail.com>
	 <69e28c910805201526v233cf05brfb3fac060a28c33b@mail.gmail.com>
	 <1ba2fa240805201545q4084f0f3ge2c01d9537beec85@mail.gmail.com>
	 <69e28c910805201556g1f28ec9fge9e23ef701db7d9a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2008 at 6:56 PM, Stefanik G=E1bor <netrolller.3d@gmail.=
com> wrote:
> On Tue, May 20, 2008 at 6:45 PM, Tomas Winkler <tomasw@gmail.com> wro=
te:
>> Need to add if (sta_is !=3D bcast)  otherwise this will drop all you=
r
>> injected packets.
>
> Did you mean if (sta_id !=3D priv->hw_setting.bcast_sta_id)? Because
> there is no "sta_is" variable.

Patch with this fixed (also as attachment, in case Gmail damages the
inline patch:

Signed-off by: G=E1bor Stefanik <netrolller.3d@gmail.com>

---

diff -rp -U 8 compat-wireless-2008-05-20.orig/drivers/net/wireless/iwlw=
ifi/iwl3945-base.c
compat-wireless-2008-05-20/drivers/net/wireless/iwlwifi/iwl3945-base.c
--- compat-wireless-2008-05-20.orig/drivers/net/wireless/iwlwifi/iwl394=
5-base.c	2008-05-20
05:05:29.000000000 -0400
+++ compat-wireless-2008-05-20/drivers/net/wireless/iwlwifi/iwl3945-bas=
e.c	2008-05-20
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
 	if ((ctl->tx_rate->hw_value & 0xFF) =3D=3D IWL_INVALID_RATE) {
 		IWL_ERROR("ERROR: No TX rate available.\n");
 		goto drop_unlock;
 	}

 	unicast =3D !is_multicast_ether_addr(hdr->addr1);
 	id =3D 0;

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
-	     ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA) && !priv->assoc_id=
)) &&
-	    ((fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA)) {
-		IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated\n");
-		goto drop_unlock;
-	}
-
 	spin_unlock_irqrestore(&priv->lock, flags);

 	hdr_len =3D ieee80211_get_hdrlen(fc);

 	/* Find (or create) index into station table for destination station =
*/
 	sta_id =3D iwl3945_get_sta_id(priv, hdr);
 	if (sta_id =3D=3D IWL_INVALID_STATION) {
 		DECLARE_MAC_BUF(mac);
@@ -6692,21 +6682,16 @@ static void iwl3945_mac_stop(struct ieee

 static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb=
,
 		      struct ieee80211_tx_control *ctl)
 {
 	struct iwl3945_priv *priv =3D hw->priv;

 	IWL_DEBUG_MAC80211("enter\n");

-	if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
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
diff -rp -U 8 compat-wireless-2008-05-20.orig/drivers/net/wireless/iwlw=
ifi/iwl4965-base.c
compat-wireless-2008-05-20/drivers/net/wireless/iwlwifi/iwl4965-base.c
--- compat-wireless-2008-05-20.orig/drivers/net/wireless/iwlwifi/iwl496=
5-base.c	2008-05-20
05:05:29.000000000 -0400
+++ compat-wireless-2008-05-20/drivers/net/wireless/iwlwifi/iwl4965-bas=
e.c	2008-05-20
18:59:39.400975754 -0400
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
 	if ((ctl->tx_rate->hw_value & 0xFF) =3D=3D IWL_INVALID_RATE) {
 		IWL_ERROR("ERROR: No TX rate available.\n");
 		goto drop_unlock;
 	}

 	unicast =3D !is_multicast_ether_addr(hdr->addr1);
 	id =3D 0;

@@ -1808,22 +1806,20 @@ static int iwl4965_tx_skb(struct iwl_pri
 	if (ieee80211_is_auth(fc))
 		IWL_DEBUG_TX("Sending AUTH frame\n");
 	else if (ieee80211_is_assoc_request(fc))
 		IWL_DEBUG_TX("Sending ASSOC frame\n");
 	else if (ieee80211_is_reassoc_request(fc))
 		IWL_DEBUG_TX("Sending REASSOC frame\n");
 #endif

-	/* drop all data frame if we are not associated */
+	/* drop all non-broadcast data frames if !priv->assoc_station_added *=
/
 	if (((fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA) &&
-	   (!iwl_is_associated(priv) ||
-	    ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA) && !priv->assoc_id)=
 ||
-	    !priv->assoc_station_added)) {
-		IWL_DEBUG_DROP("Dropping - !iwl_is_associated\n");
+	   !priv->assoc_station_added && sta_id !=3D priv->hw_setting.bcast_s=
ta_id) {
+		IWL_DEBUG_DROP("Dropping - !priv->assoc_station_added\n");
 		goto drop_unlock;
 	}

 	spin_unlock_irqrestore(&priv->lock, flags);

 	hdr_len =3D ieee80211_get_hdrlen(fc);

 	/* Find (or create) index into station table for destination station =
*/
@@ -5110,21 +5106,16 @@ static void iwl4965_mac_stop(struct ieee

 static int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb=
,
 		      struct ieee80211_tx_control *ctl)
 {
 	struct iwl_priv *priv =3D hw->priv;

 	IWL_DEBUG_MAC80211("enter\n");

-	if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
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
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
