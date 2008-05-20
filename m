Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.231]:28114 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbYETLcz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 07:32:55 -0400
Received: by wr-out-0506.google.com with SMTP id c48so997239wra.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2008 04:32:53 -0700 (PDT)
Message-ID: <69e28c910805200432lbd3790vb925dacaea3aca83@mail.gmail.com> (sfid-20080520_141946_747540_E2F0A327)
Date: Tue, 20 May 2008 07:32:52 -0400
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: iwlwifi injection bug
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Andy Green" <andy@warmcat.com>
In-Reply-To: <1211249729.2532.59.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1210945631.6381.11.camel@johannes.berg>
	 <1211249729.2532.59.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 19, 2008 at 10:15 PM, Zhu Yi <yi.zhu@intel.com> wrote:
> On Fri, 2008-05-16 at 15:47 +0200, Johannes Berg wrote:
>> I don't know why you want to disallow sending frames when in monitor
>> mode (especially since reportedly it works), but this is not a good
>> way
>> to go about it:
>>
>> static int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff
>> *skb)
>> {
>>         struct iwl_priv *priv = hw->priv;
>>
>>         IWL_DEBUG_MAC80211("enter\n");
>>
>>         if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
>>                 IWL_DEBUG_MAC80211("leave - monitor\n");
>>                 return -1;
>>         }
>>
>> You see, this will cause mac80211 to resubmit the frame and most
>> likely will totally mess up queue handling and various other things.
>
> The monitor mode the driver is using currently is purely a "sniffer". We
> will look into other promiscuous mode supported by the firmware to see
> if we can enable that.
>
> Thanks,
> -yi
>

That mode is not really a sniffer, since I can perfectly use packet
injection using this patch; packetspammer, aireplay-ng and mdk3 all
work, at least for 3945 (4965 not tested because I don't own one):

diff -rp -U 8 compat-wireless-2008-05-20/drivers/net/wireless/iwlwifi/iwl3945-base.c
compat-wireless-2008-05-20.bak/drivers/net/wireless/iwlwifi/iwl3945-base.c
--- compat-wireless-2008-05-20/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-05-20
05:05:29.000000000 -0400
+++ compat-wireless-2008-05-20.bak/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-05-20
09:28:05.321889249 -0400
@@ -2579,21 +2579,16 @@ static int iwl3945_tx_skb(struct iwl3945
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

@@ -2606,33 +2601,36 @@ static int iwl3945_tx_skb(struct iwl3945
 		IWL_DEBUG_TX("Sending ASSOC frame\n");
 	else if (ieee80211_is_reassoc_request(fc))
 		IWL_DEBUG_TX("Sending REASSOC frame\n");
 #endif

 	/* drop all data frame if we are not associated */
 	if ((!iwl3945_is_associated(priv) ||
 	     ((priv->iw_mode == IEEE80211_IF_TYPE_STA) && !priv->assoc_id)) &&
-	    ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)) {
+	    ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) && priv->vif) {
 		IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated\n");
 		goto drop_unlock;
 	}

 	spin_unlock_irqrestore(&priv->lock, flags);

 	hdr_len = ieee80211_get_hdrlen(fc);

 	/* Find (or create) index into station table for destination station */
 	sta_id = iwl3945_get_sta_id(priv, hdr);
 	if (sta_id == IWL_INVALID_STATION) {
 		DECLARE_MAC_BUF(mac);

-		IWL_DEBUG_DROP("Dropping - INVALID STATION: %s\n",
-			       print_mac(mac, hdr->addr1));
-		goto drop;
+		if (priv->vif) {
+			IWL_DEBUG_DROP("Dropping - INVALID STATION: %s\n",
+				       print_mac(mac, hdr->addr1));
+			goto drop;
+		}
+		sta_id = priv->hw_setting.bcast_sta_id;
 	}

 	IWL_DEBUG_RATE("station Id %d\n", sta_id);

 	qc = ieee80211_get_qos_ctrl(hdr);
 	if (qc) {
 		u8 tid = (u8)(le16_to_cpu(*qc) & 0xf);
 		seq_number = priv->stations[sta_id].tid[tid].seq_number &
@@ -6692,17 +6690,17 @@ static void iwl3945_mac_stop(struct ieee

 static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		      struct ieee80211_tx_control *ctl)
 {
 	struct iwl3945_priv *priv = hw->priv;

 	IWL_DEBUG_MAC80211("enter\n");

-	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
+	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR && 0) {
 		IWL_DEBUG_MAC80211("leave - monitor\n");
 		return -1;
 	}

 	IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 		     ctl->tx_rate->bitrate);

 	if (iwl3945_tx_skb(priv, skb, ctl))
diff -rp -U 8 compat-wireless-2008-05-20/drivers/net/wireless/iwlwifi/iwl4965-base.c
compat-wireless-2008-05-20.bak/drivers/net/wireless/iwlwifi/iwl4965-base.c
--- compat-wireless-2008-05-20/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-05-20
05:05:29.000000000 -0400
+++ compat-wireless-2008-05-20.bak/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-05-20
09:28:05.325889557 -0400
@@ -1784,21 +1784,16 @@ static int iwl4965_tx_skb(struct iwl_pri
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

@@ -1810,35 +1805,37 @@ static int iwl4965_tx_skb(struct iwl_pri
 	else if (ieee80211_is_assoc_request(fc))
 		IWL_DEBUG_TX("Sending ASSOC frame\n");
 	else if (ieee80211_is_reassoc_request(fc))
 		IWL_DEBUG_TX("Sending REASSOC frame\n");
 #endif

 	/* drop all data frame if we are not associated */
 	if (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
-	   (!iwl_is_associated(priv) ||
+	   priv->vif && (!iwl_is_associated(priv) ||
 	    ((priv->iw_mode == IEEE80211_IF_TYPE_STA) && !priv->assoc_id) ||
 	    !priv->assoc_station_added)) {
 		IWL_DEBUG_DROP("Dropping - !iwl_is_associated\n");
 		goto drop_unlock;
 	}

 	spin_unlock_irqrestore(&priv->lock, flags);

 	hdr_len = ieee80211_get_hdrlen(fc);

 	/* Find (or create) index into station table for destination station */
 	sta_id = iwl4965_get_sta_id(priv, hdr);
 	if (sta_id == IWL_INVALID_STATION) {
 		DECLARE_MAC_BUF(mac);

-		IWL_DEBUG_DROP("Dropping - INVALID STATION: %s\n",
-			       print_mac(mac, hdr->addr1));
-		goto drop;
+		if (priv->vif) {
+			IWL_DEBUG_DROP("Dropping - INVALID STATION: %s\n", print_mac(mac,
hdr->addr1));
+			goto drop;
+		}
+		sta_id = priv->hw_params.bcast_sta_id;
 	}

 	IWL_DEBUG_TX("station Id %d\n", sta_id);

 	qc = ieee80211_get_qos_ctrl(hdr);
 	if (qc) {
 		u8 tid = (u8)(le16_to_cpu(*qc) & 0xf);
 		seq_number = priv->stations[sta_id].tid[tid].seq_number &
@@ -5110,17 +5107,17 @@ static void iwl4965_mac_stop(struct ieee

 static int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		      struct ieee80211_tx_control *ctl)
 {
 	struct iwl_priv *priv = hw->priv;

 	IWL_DEBUG_MAC80211("enter\n");

-	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
+	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR && 0) {
 		IWL_DEBUG_MAC80211("leave - monitor\n");
 		return -1;
 	}

 	IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 		     ctl->tx_rate->bitrate);

 	if (iwl4965_tx_skb(priv, skb, ctl))
