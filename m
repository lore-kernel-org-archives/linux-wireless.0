Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:30358 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbZBLTOX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 14:14:23 -0500
Received: by nf-out-0910.google.com with SMTP id d21so80961nfb.21
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 11:14:21 -0800 (PST)
Message-Id: <A31F863C-69D2-4415-B470-2514EEE60CBB@icix.org> (sfid-20090212_201426_804722_8506CF9F)
From: Antonio Marques <froz@icix.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: [RFC PATCH] iwlwifi: Add mesh support for Intel Wireless WiFi Link AGN
Date: Thu, 12 Feb 2009 19:14:16 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for Mesh Point mode in iwlwifi. It is based on  
a previously
submitted patch:

http://marc.info/?l=linux-wireless&m=121304247317921&w=2

I would appreciate it if someone more knowledgeable could take a look  
at this as
this is my first patch and I am not entirely familiar with the codebase.
Signed-off-by: Antonio Marques <froz@icix.org>
---
  drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    6 +++---
  drivers/net/wireless/iwlwifi/iwl-agn.c    |   17 +++++++++++++++--
  drivers/net/wireless/iwlwifi/iwl-core.c   |    2 ++
  drivers/net/wireless/iwlwifi/iwl-rx.c     |    1 +
  drivers/net/wireless/iwlwifi/iwl-sta.c    |    7 +++++--
  5 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/ 
wireless/iwlwifi/iwl-agn-rs.c
index 04b42c8..da80c05 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -806,7 +806,7 @@ static void rs_tx_status(void *priv_r, struct  
ieee80211_supported_band *sband,
  	if (retries > 15)
  		retries = 15;

-	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
+	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC || priv->iw_mode ==  
NL80211_IFTYPE_MESH_POINT)  &&
  	    !lq_sta->ibss_sta_added)
  		goto out;

@@ -2082,7 +2082,7 @@ static void rs_initialize_lq(struct iwl_priv  
*priv,
  	i = lq_sta->last_txrate_idx;

  	if ((lq_sta->lq.sta_id == 0xff) &&
-	    (priv->iw_mode == NL80211_IFTYPE_ADHOC))
+	    (priv->iw_mode == NL80211_IFTYPE_ADHOC || priv->iw_mode ==  
NL80211_IFTYPE_MESH_POINT))
  		goto out;

  	valid_tx_ant = priv->hw_params.valid_tx_ant;
@@ -2162,7 +2162,7 @@ static void rs_get_rate(void *priv_r, struct  
ieee80211_sta *sta, void *priv_sta,

  	rate_idx  = lq_sta->last_txrate_idx;

-	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
+	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC || priv->iw_mode ==  
NL80211_IFTYPE_MESH_POINT) &&
  	    !lq_sta->ibss_sta_added) {
  		u8 sta_id = iwl_find_station(priv, hdr->addr1);

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/ 
wireless/iwlwifi/iwl-agn.c
index 397577c..ff81d67 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -303,6 +303,7 @@ static unsigned int iwl_fill_beacon_frame(struct  
iwl_priv *priv,
  {
  	if (!iwl_is_associated(priv) || !priv->ibss_beacon ||
  	    ((priv->iw_mode != NL80211_IFTYPE_ADHOC) &&
+	     (priv->iw_mode != NL80211_IFTYPE_MESH_POINT) &&
  	     (priv->iw_mode != NL80211_IFTYPE_AP)))
  		return 0;

@@ -2096,7 +2097,7 @@ static void iwl_post_associate(struct iwl_priv  
*priv)
  		else
  			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;

-		if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
+		if (priv->iw_mode == NL80211_IFTYPE_ADHOC || priv->iw_mode ==  
NL80211_IFTYPE_MESH_POINT)
  			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_SLOT_MSK;

  	}
@@ -2107,6 +2108,7 @@ static void iwl_post_associate(struct iwl_priv  
*priv)
  	case NL80211_IFTYPE_STATION:
  		break;

+	case NL80211_IFTYPE_MESH_POINT:
  	case NL80211_IFTYPE_ADHOC:

  		/* assume default assoc id */
@@ -2123,7 +2125,7 @@ static void iwl_post_associate(struct iwl_priv  
*priv)
  		break;
  	}

-	if (priv->iw_mode == NL80211_IFTYPE_ADHOC)
+	if (priv->iw_mode == NL80211_IFTYPE_ADHOC || priv->iw_mode ==  
NL80211_IFTYPE_MESH_POINT)
  		priv->assoc_station_added = 1;

  	spin_lock_irqsave(&priv->lock, flags);
@@ -2542,6 +2544,12 @@ static int iwl_mac_config_interface(struct  
ieee80211_hw *hw,
  		priv->ibss_beacon = ieee80211_beacon_get(hw, vif);
  	}

+	if (priv->iw_mode == NL80211_IFTYPE_MESH_POINT) {
+		if (priv->ibss_beacon)
+			dev_kfree_skb(priv->ibss_beacon);
+		priv->ibss_beacon = ieee80211_beacon_get(hw, vif);
+	}
+
  	if (iwl_is_rfkill(priv))
  		goto done;

@@ -2583,6 +2591,11 @@ static int iwl_mac_config_interface(struct  
ieee80211_hw *hw,
  	IWL_DEBUG_MAC80211(priv, "leave\n");
  	mutex_unlock(&priv->mutex);

+	if (priv->iw_mode == NL80211_IFTYPE_MESH_POINT) {
+		iwl_reset_qos(priv);
+		iwl_post_associate(priv);
+	}
+
  	return 0;
  }

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/ 
wireless/iwlwifi/iwl-core.c
index 260bf90..a3592ac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1028,6 +1028,7 @@ void iwl_connection_init_rx_config(struct  
iwl_priv *priv, int mode)
  		priv->staging_rxon.filter_flags = RXON_FILTER_ACCEPT_GRP_MSK;
  		break;

+	case NL80211_IFTYPE_MESH_POINT:
  	case NL80211_IFTYPE_ADHOC:
  		priv->staging_rxon.dev_type = RXON_DEV_TYPE_IBSS;
  		priv->staging_rxon.flags = RXON_FLG_SHORT_PREAMBLE_MSK;
@@ -1268,6 +1269,7 @@ int iwl_setup_mac(struct iwl_priv *priv)
  		    IEEE80211_HW_SUPPORTS_PS;
  	hw->wiphy->interface_modes =
  		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_MESH_POINT) |
  		BIT(NL80211_IFTYPE_ADHOC);

  	hw->wiphy->custom_regulatory = true;
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/ 
wireless/iwlwifi/iwl-rx.c
index 8f65908..f2060a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -959,6 +959,7 @@ static int iwl_is_network_packet(struct iwl_priv  
*priv,
  	/* Filter incoming packets to determine if they are targeted toward
  	 * this network, discarding packets coming from ourselves */
  	switch (priv->iw_mode) {
+	case NL80211_IFTYPE_MESH_POINT:
  	case NL80211_IFTYPE_ADHOC: /* Header: Dest. | Source    | BSSID */
  		/* packets to our IBSS update information */
  		return !compare_ether_addr(header->addr3, priv->bssid);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/ 
wireless/iwlwifi/iwl-sta.c
index 1fae3a6..94a18f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -45,6 +45,7 @@ u8 iwl_find_station(struct iwl_priv *priv, const u8  
*addr)
  	unsigned long flags;

  	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) ||
+	    (priv->iw_mode == NL80211_IFTYPE_MESH_POINT) ||
  	    (priv->iw_mode == NL80211_IFTYPE_AP))
  		start = IWL_STA_ID;

@@ -285,7 +286,8 @@ u8 iwl_add_station_flags(struct iwl_priv *priv,  
const u8 *addr, int is_ap,

  	/* BCAST station and IBSS stations do not work in HT mode */
  	if (sta_id != priv->hw_params.bcast_sta_id &&
-	    priv->iw_mode != NL80211_IFTYPE_ADHOC)
+	    (priv->iw_mode != NL80211_IFTYPE_ADHOC) &&
+	    (priv->iw_mode != NL80211_IFTYPE_MESH_POINT))
  		iwl_set_ht_add_station(priv, sta_id, ht_info);

  	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
@@ -908,7 +910,7 @@ int iwl_send_lq_cmd(struct iwl_priv *priv,
  	};

  	if ((lq->sta_id == 0xFF) &&
-	    (priv->iw_mode == NL80211_IFTYPE_ADHOC))
+	    (priv->iw_mode == NL80211_IFTYPE_ADHOC || priv->iw_mode ==  
NL80211_IFTYPE_MESH_POINT))
  		return -EINVAL;

  	if (lq->sta_id == 0xFF)
@@ -1052,6 +1054,7 @@ int iwl_get_sta_id(struct iwl_priv *priv, struct  
ieee80211_hdr *hdr)

  	/* If this frame is going out to an IBSS network, find the station,
  	 * or create a new station table entry */
+	case NL80211_IFTYPE_MESH_POINT:
  	case NL80211_IFTYPE_ADHOC:
  		sta_id = iwl_find_station(priv, hdr->addr1);
  		if (sta_id != IWL_INVALID_STATION)
-- 
1.5.6.3

