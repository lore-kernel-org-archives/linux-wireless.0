Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes2.cs.kuleuven.be ([134.58.40.2]:57062 "EHLO
	hermes2.cs.kuleuven.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab3KZSWF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 13:22:05 -0500
Received: from hermes2.cs.kuleuven.be. (localhost [127.0.0.1])
	by hermes2.cs.kuleuven.be.  with ESMTP id rAQIF1I8023490
	for <linux-wireless@vger.kernel.org>; Tue, 26 Nov 2013 19:15:01 +0100
Received: (from defang@localhost)
	by hermes2.cs.kuleuven.be. (8.14.4/8.14.4/Submit) id rAQIDccS023458
	for <linux-wireless@vger.kernel.org>; Tue, 26 Nov 2013 19:13:38 +0100
Message-ID: <5294E4C5.4050301@cs.kuleuven.be> (sfid-20131126_192218_076303_059B9155)
Date: Tue, 26 Nov 2013 19:13:25 +0100
From: Mathy Vanhoef <mathy.vanhoef@cs.kuleuven.be>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com
Subject: [PATCH] ath9k_htc: properly set MAC address and BSSID mask
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Mathy Vanhoef" <Mathy.Vanhoef@cs.kuleuven.be>

Pick the MAC address of the first virtual interface as the new hardware MAC
address. Set BSSID mask according to this MAC address. This fixes CVE-2013-4579.

Signed-off-by: Mathy Vanhoef <Mathy.Vanhoef@cs.kuleuven.be>
---
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index d441045..84359c3 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -147,21 +147,26 @@ static void ath9k_htc_bssid_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
  	struct ath9k_vif_iter_data *iter_data = data;
  	int i;
  
-	for (i = 0; i < ETH_ALEN; i++)
-		iter_data->mask[i] &= ~(iter_data->hw_macaddr[i] ^ mac[i]);
+	if (iter_data->hw_macaddr != NULL) {
+		for (i = 0; i < ETH_ALEN; i++)
+			iter_data->mask[i] &= ~(iter_data->hw_macaddr[i] ^ mac[i]);
+	} else {
+		iter_data->hw_macaddr = mac;
+	}
  }
  
-static void ath9k_htc_set_bssid_mask(struct ath9k_htc_priv *priv,
+static void ath9k_htc_set_mac_bssid_mask(struct ath9k_htc_priv *priv,
  				     struct ieee80211_vif *vif)
  {
  	struct ath_common *common = ath9k_hw_common(priv->ah);
  	struct ath9k_vif_iter_data iter_data;
  
  	/*
-	 * Use the hardware MAC address as reference, the hardware uses it
-	 * together with the BSSID mask when matching addresses.
+	 * Pick the MAC address of the first interface as the new hardware
+	 * MAC address. The hardware will use it together with the BSSID mask
+	 * when matching addresses.
  	 */
-	iter_data.hw_macaddr = common->macaddr;
+	iter_data.hw_macaddr = NULL;
  	memset(&iter_data.mask, 0xff, ETH_ALEN);
  
  	if (vif)
@@ -173,6 +178,10 @@ static void ath9k_htc_set_bssid_mask(struct ath9k_htc_priv *priv,
  		ath9k_htc_bssid_iter, &iter_data);
  
  	memcpy(common->bssidmask, iter_data.mask, ETH_ALEN);
+
+	if (iter_data.hw_macaddr)
+		memcpy(common->macaddr, iter_data.hw_macaddr, ETH_ALEN);
+
  	ath_hw_setbssidmask(common);
  }
  
@@ -1083,7 +1092,7 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
  		goto out;
  	}
  
-	ath9k_htc_set_bssid_mask(priv, vif);
+	ath9k_htc_set_mac_bssid_mask(priv, vif);
  
  	priv->vif_slot |= (1 << avp->index);
  	priv->nvifs++;
@@ -1148,7 +1157,7 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
  
  	ath9k_htc_set_opmode(priv);
  
-	ath9k_htc_set_bssid_mask(priv, vif);
+	ath9k_htc_set_mac_bssid_mask(priv, vif);
  
  	/*
  	 * Stop ANI only if there are no associated station interfaces.
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b6aad69..99ab0aa 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -885,8 +885,9 @@ void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
  	struct ath_common *common = ath9k_hw_common(ah);
  
  	/*
-	 * Use the hardware MAC address as reference, the hardware uses it
-	 * together with the BSSID mask when matching addresses.
+	 * Pick the MAC address of the first interface as the new hardware
+	 * MAC address. The hardware will use it together with the BSSID mask
+	 * when matching addresses.
  	 */
  	memset(iter_data, 0, sizeof(*iter_data));
  	memset(&iter_data->mask, 0xff, ETH_ALEN);


Disclaimer: http://www.kuleuven.be/cwis/email_disclaimer.htm
